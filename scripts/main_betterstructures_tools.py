#!/usr/bin/env python3
"""Reproducible, repository-local BetterStructures content preparation tools."""

from __future__ import annotations

import argparse
import copy
import gzip
import hashlib
import io
import json
import shutil
import struct
import sys
import zipfile
import stat
from collections import Counter
from pathlib import Path
from typing import Any, Iterable

import yaml


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_WORK = ROOT / "local" / "work" / "main-betterstructures-v006"
SELECTION_PATH = ROOT / "config" / "main-betterstructures" / "selection.yml"
MAPPING_PATH = ROOT / "config" / "main-betterstructures" / "prop-id-mapping.yml"
ENTITY_REMOVALS_PATH = (
    ROOT / "config" / "main-betterstructures" / "entity-removals.yml"
)
BLOCK_ENTITY_REMOVALS_PATH = (
    ROOT / "config" / "main-betterstructures" / "block-entity-removals.yml"
)
FIXED_ZIP_TIME = (2026, 7, 25, 0, 0, 0)


class PreflightError(RuntimeError):
    pass


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest().upper()


def load_yaml(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as stream:
        value = yaml.safe_load(stream)
    if not isinstance(value, dict):
        raise PreflightError(f"Expected a YAML mapping: {path}")
    return value


def repo_path(value: str | Path) -> Path:
    path = Path(value)
    if not path.is_absolute():
        path = ROOT / path
    path = path.resolve()
    try:
        path.relative_to(ROOT)
    except ValueError as exc:
        raise PreflightError(f"Path is outside the repository: {path}") from exc
    return path


def reset_generated_directory(path: Path, *, dry_run: bool) -> None:
    path = repo_path(path)
    expected = DEFAULT_WORK.resolve()
    try:
        path.relative_to(expected)
    except ValueError as exc:
        raise PreflightError(
            f"Refusing to replace a directory outside {expected}: {path}"
        ) from exc
    if dry_run:
        return
    if path.exists():
        def make_writable_and_retry(function: Any, target: str, _: Any) -> None:
            Path(target).chmod(stat.S_IWRITE)
            function(target)

        shutil.rmtree(path, onerror=make_writable_and_retry)
    path.mkdir(parents=True, exist_ok=True)


def artifact_paths(work: Path, selection: dict[str, Any]) -> dict[str, Path]:
    original = work / "original"
    result: dict[str, Path] = {}
    for pack, spec in selection["artifacts"].items():
        result[pack] = original / spec["archive"]
    return result


def verify_artifacts(work: Path, selection: dict[str, Any]) -> dict[str, str]:
    hashes: dict[str, str] = {}
    for pack, path in artifact_paths(work, selection).items():
        if not path.is_file():
            raise PreflightError(f"Missing original archive for {pack}: {path}")
        actual = sha256(path)
        expected = str(selection["artifacts"][pack]["sha256"]).upper()
        if actual != expected:
            raise PreflightError(
                f"SHA-256 mismatch for {pack}: expected {expected}, got {actual}"
            )
        try:
            with zipfile.ZipFile(path) as archive:
                bad = archive.testzip()
        except zipfile.BadZipFile as exc:
            raise PreflightError(f"Unreadable ZIP archive: {path}") from exc
        if bad:
            raise PreflightError(f"Corrupt ZIP member in {path}: {bad}")
        hashes[pack] = actual
    return hashes


def expand_selection(selection: dict[str, Any]) -> dict[str, dict[str, tuple[float, str]]]:
    result: dict[str, dict[str, tuple[float, str]]] = {}
    for pack, rule in selection["selection"].items():
        selected: dict[str, tuple[float, str]] = {}
        if rule.get("include_all"):
            result[pack] = selected
            continue
        for group in rule.get("groups", []):
            dimension = str(group["dimension"])
            if "prefix" in group:
                weight = float(group["weight"])
                for variant in group["variants"]:
                    structure_id = f"{group['prefix']}{variant}"
                    if structure_id in selected:
                        raise PreflightError(f"Duplicate selected ID: {structure_id}")
                    selected[structure_id] = (weight, dimension)
            else:
                for structure_id, weight in group["ids"].items():
                    if structure_id in selected:
                        raise PreflightError(f"Duplicate selected ID: {structure_id}")
                    selected[str(structure_id)] = (float(weight), dimension)
        result[pack] = selected
    return result


def find_pack_root(extracted: Path, archive: Path) -> Path:
    expected = extracted / archive.stem
    if expected.is_dir():
        return expected
    candidates = [
        path.parent.parent.parent
        for path in extracted.rglob("*.schem")
        if path.parent.parent.name == "schematics"
    ]
    unique = sorted(set(candidates))
    if len(unique) != 1:
        raise PreflightError(
            f"Cannot identify one extracted pack root for {archive.name}: {unique}"
        )
    return unique[0]


def schematic_configs(pack_root: Path) -> dict[str, Path]:
    result: dict[str, Path] = {}
    for path in sorted((pack_root / "schematics").rglob("*.yml")):
        if path.stem in result:
            raise PreflightError(f"Duplicate structure ID in pack: {path.stem}")
        result[path.stem] = path
    return result


def generator_dimension(config_path: Path) -> str:
    config = load_yaml(config_path)
    generator = str(config.get("generatorConfigFilename", "")).lower()
    nether_tokens = (
        "nether",
        "crimson_forest",
        "soul_sand",
        "warped_forest",
    )
    if any(token in generator for token in nether_tokens):
        return "nether"
    if "end" in generator:
        return "end"
    return "overworld"


def extract_and_select(work: Path, *, dry_run: bool) -> dict[str, Any]:
    selection = load_yaml(SELECTION_PATH)
    hashes = verify_artifacts(work, selection)
    selected_rules = expand_selection(selection)
    extracted = work / "extracted"
    normalized = work / "normalized"
    reports = work / "reports"
    if not dry_run:
        reset_generated_directory(extracted, dry_run=False)
        reset_generated_directory(normalized, dry_run=False)
        reports.mkdir(parents=True, exist_ok=True)

    report: dict[str, Any] = {
        "schema": 1,
        "selection_id": selection["selection_id"],
        "source_hashes": hashes,
        "packs": {},
    }
    total_source = 0
    total_selected = 0
    design_dimensions: Counter[str] = Counter()
    runtime_dimensions: Counter[str] = Counter()

    for pack, archive in artifact_paths(work, selection).items():
        extract_root = extracted / archive.stem
        if not dry_run:
            extract_root.mkdir(parents=True, exist_ok=True)
            with zipfile.ZipFile(archive) as source:
                source.extractall(extract_root)
        else:
            existing_root = find_pack_root(extracted, archive)
            extract_root = existing_root

        configs = schematic_configs(extract_root)
        expected_source = int(selection["artifacts"][pack]["structure_count"])
        if len(configs) != expected_source:
            raise PreflightError(
                f"{pack} structure count mismatch: expected {expected_source}, "
                f"got {len(configs)}"
            )

        explicit = selected_rules[pack]
        if selection["selection"][pack].get("include_all"):
            default_weight = float(selection["selection"][pack]["weight"])
            selected = {
                structure_id: (default_weight, generator_dimension(path))
                for structure_id, path in configs.items()
            }
            design_counts = selection["selection"][pack].get("design_counts", {})
            for dimension, count in design_counts.items():
                design_dimensions[str(dimension)] += int(count)
        else:
            unknown = sorted(set(explicit) - set(configs))
            if unknown:
                raise PreflightError(
                    f"{pack} selected IDs missing from input: {', '.join(unknown)}"
                )
            selected = explicit
            for _, dimension in selected.values():
                design_dimensions[dimension] += 1

        output_root = normalized / archive.stem
        if not dry_run:
            shutil.copytree(extract_root, output_root)
            output_configs = schematic_configs(output_root)
            for structure_id, config_path in output_configs.items():
                source_config = load_yaml(config_path)
                enabled = structure_id in selected
                source_config["isEnabled"] = enabled
                if enabled:
                    source_config["weight"] = selected[structure_id][0]
                config_path.chmod(stat.S_IWRITE | stat.S_IREAD)
                with config_path.open("w", encoding="utf-8", newline="\n") as stream:
                    yaml.safe_dump(
                        source_config,
                        stream,
                        allow_unicode=True,
                        sort_keys=False,
                        default_flow_style=False,
                    )

        selected_runtime: Counter[str] = Counter()
        for structure_id in selected:
            dimension = generator_dimension(configs[structure_id])
            selected_runtime[dimension] += 1
            runtime_dimensions[dimension] += 1

        total_source += len(configs)
        total_selected += len(selected)
        report["packs"][pack] = {
            "source_count": len(configs),
            "selected_count": len(selected),
            "disabled_count": len(configs) - len(selected),
            "selected_ids": sorted(selected),
            "runtime_generator_dimensions": dict(sorted(selected_runtime.items())),
        }

    if total_source != int(selection["source_structure_count"]):
        raise PreflightError(
            f"Total source count mismatch: expected "
            f"{selection['source_structure_count']}, got {total_source}"
        )
    if total_selected != int(selection["selected_structure_count"]):
        raise PreflightError(
            f"Total selected count mismatch: expected "
            f"{selection['selected_structure_count']}, got {total_selected}"
        )
    expected_design = {
        key: int(value) for key, value in selection["design_dimension_counts"].items()
    }
    if dict(design_dimensions) != expected_design:
        raise PreflightError(
            f"Design dimension count mismatch: expected {expected_design}, "
            f"got {dict(design_dimensions)}"
        )
    expected_runtime = {
        key: int(value)
        for key, value in selection["runtime_generator_dimension_counts"].items()
    }
    if dict(runtime_dimensions) != expected_runtime:
        raise PreflightError(
            f"Runtime dimension count mismatch: expected {expected_runtime}, "
            f"got {dict(runtime_dimensions)}"
        )
    report["totals"] = {
        "source": total_source,
        "selected": total_selected,
        "disabled": total_source - total_selected,
        "design_dimensions": dict(sorted(design_dimensions.items())),
        "runtime_generator_dimensions": dict(sorted(runtime_dimensions.items())),
    }
    if not dry_run:
        write_json(reports / "selection-report.json", report)
    return report


class NbtReader:
    def __init__(self, data: bytes):
        self.stream = io.BytesIO(data)

    def read(self, size: int) -> bytes:
        value = self.stream.read(size)
        if len(value) != size:
            raise PreflightError("Unexpected end of NBT stream")
        return value

    def unpack(self, fmt: str) -> Any:
        return struct.unpack(">" + fmt, self.read(struct.calcsize(">" + fmt)))[0]

    def string(self) -> str:
        size = self.unpack("H")
        return self.read(size).decode("utf-8")

    def payload(self, tag: int) -> Any:
        if tag == 1:
            return self.unpack("b")
        if tag == 2:
            return self.unpack("h")
        if tag == 3:
            return self.unpack("i")
        if tag == 4:
            return self.unpack("q")
        if tag == 5:
            return self.unpack("f")
        if tag == 6:
            return self.unpack("d")
        if tag == 7:
            return self.read(self.unpack("i"))
        if tag == 8:
            return self.string()
        if tag == 9:
            child = self.unpack("B")
            count = self.unpack("i")
            return [self.payload(child) for _ in range(count)]
        if tag == 10:
            result: dict[str, Any] = {}
            while True:
                child = self.unpack("B")
                if child == 0:
                    return result
                name = self.string()
                result[name] = self.payload(child)
        if tag == 11:
            return [self.unpack("i") for _ in range(self.unpack("i"))]
        if tag == 12:
            return [self.unpack("q") for _ in range(self.unpack("i"))]
        raise PreflightError(f"Unsupported NBT tag type: {tag}")

    def root(self) -> dict[str, Any]:
        tag = self.unpack("B")
        if tag != 10:
            raise PreflightError(f"Expected root compound tag, got {tag}")
        self.string()
        result = self.payload(tag)
        if not isinstance(result, dict):
            raise PreflightError("NBT root is not a compound")
        return result


def read_schematic(path: Path) -> tuple[dict[str, Any], bytes]:
    raw = path.read_bytes()
    try:
        decompressed = gzip.decompress(raw)
    except (gzip.BadGzipFile, EOFError, OSError) as exc:
        raise PreflightError(f"Unreadable gzip schematic: {path}") from exc
    return NbtReader(decompressed).root(), decompressed


def remove_compounds_from_named_list(
    data: bytes, list_name: str, predicate: Any
) -> tuple[bytes, list[dict[str, Any]]]:
    """Remove matching compounds from the first NBT list with the exact name."""

    reader = NbtReader(data)
    root_tag = reader.unpack("B")
    if root_tag != 10:
        raise PreflightError(f"Expected root compound tag, got {root_tag}")
    reader.string()

    def scan_compound() -> tuple[bytes | None, list[dict[str, Any]]]:
        while True:
            tag = reader.unpack("B")
            if tag == 0:
                return None, []
            name = reader.string()
            if name == list_name:
                if tag != 9:
                    raise PreflightError(f"NBT {list_name} tag is not a list")
                child_tag = reader.unpack("B")
                if child_tag != 10:
                    raise PreflightError(
                        f"NBT {list_name} list contains tag type {child_tag}, "
                        "not compounds"
                    )
                count_offset = reader.stream.tell()
                count = reader.unpack("i")
                entries: list[tuple[int, int, dict[str, Any]]] = []
                for _ in range(count):
                    start = reader.stream.tell()
                    value = reader.payload(child_tag)
                    end = reader.stream.tell()
                    if not isinstance(value, dict):
                        raise PreflightError("NBT entity entry is not a compound")
                    entries.append((start, end, value))
                list_end = reader.stream.tell()
                removed = [value for _, _, value in entries if predicate(value)]
                kept = [
                    data[start:end]
                    for start, end, value in entries
                    if not predicate(value)
                ]
                if not removed:
                    return None, []
                rewritten = (
                    data[:count_offset]
                    + struct.pack(">i", len(kept))
                    + b"".join(kept)
                    + data[list_end:]
                )
                return rewritten, removed
            if tag == 10:
                rewritten, removed = scan_compound()
                if rewritten is not None:
                    return rewritten, removed
            else:
                reader.payload(tag)

    rewritten, removed = scan_compound()
    return (data if rewritten is None else rewritten), removed


def remove_entities_from_nbt(
    data: bytes, predicate: Any
) -> tuple[bytes, list[dict[str, Any]]]:
    return remove_compounds_from_named_list(data, "Entities", predicate)


def matches_entity_removal(entity: dict[str, Any], rule: dict[str, Any]) -> bool:
    if entity_type(entity) != str(rule["entity_type"]):
        return False
    data = entity.get("Data")
    if not isinstance(data, dict):
        return False
    item = data.get("Item")
    if not isinstance(item, dict):
        return False
    return (
        item.get("id") == rule["item_id"]
        and int(item.get("count", -1)) == int(rule["item_count"])
    )


def matches_block_entity_removal(
    block_entity: dict[str, Any], rule: dict[str, Any]
) -> bool:
    expected = str(rule["block_entity_id"])
    data = block_entity.get("Data")
    return (
        block_entity.get("Id") == expected
        and isinstance(data, dict)
        and data.get("id") == expected
    )


def walk_strings(value: Any) -> Iterable[str]:
    if isinstance(value, str):
        yield value
    elif isinstance(value, dict):
        for key, child in value.items():
            yield key
            yield from walk_strings(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk_strings(child)


def exact_nbt_string_pattern(value: str) -> bytes:
    encoded = value.encode("utf-8")
    return struct.pack(">H", len(encoded)) + encoded


def replace_exact_nbt_strings(data: bytes, replacements: dict[str, str]) -> tuple[bytes, Counter[str]]:
    counts: Counter[str] = Counter()
    output = data
    for old, new in sorted(replacements.items(), key=lambda item: -len(item[0])):
        old_pattern = exact_nbt_string_pattern(old)
        count = output.count(old_pattern)
        if count:
            output = output.replace(old_pattern, exact_nbt_string_pattern(new))
            counts[old] += count
    return output, counts


def model_ids(prop_root: Path) -> set[str]:
    ids = {path.stem for path in prop_root.rglob("*.bbmodel")}
    if not ids:
        raise PreflightError(f"No .bbmodel files found under {prop_root}")
    return ids


def normalized_pack_roots(work: Path, selection: dict[str, Any]) -> dict[str, Path]:
    normalized = work / "normalized"
    return {
        pack: normalized / Path(spec["archive"]).stem
        for pack, spec in selection["artifacts"].items()
    }


def build_prop_replacements(
    strings: Iterable[str], models: set[str], mapping: dict[str, Any]
) -> tuple[dict[str, str], set[str]]:
    exceptions = {
        str(source): str(target)
        for source, target in mapping.get("exceptions", {}).items()
    }
    replacements: dict[str, str] = {}
    unresolved: set[str] = set()
    for value in set(strings):
        if value in exceptions:
            target = exceptions[value]
            if target not in models:
                unresolved.add(value)
            else:
                replacements[value] = target
        elif value.startswith("bs_prop_pack_"):
            if value not in models:
                unresolved.add(value)
        else:
            target = f"bs_prop_pack_{value}"
            if target in models:
                replacements[value] = target
    return replacements, unresolved


def deterministic_zip(source_root: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(
        destination, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9
    ) as archive:
        for path in sorted(source_root.rglob("*")):
            if not path.is_file():
                continue
            relative = path.relative_to(source_root).as_posix()
            info = zipfile.ZipInfo(relative, FIXED_ZIP_TIME)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o100644 << 16
            archive.writestr(info, path.read_bytes(), compresslevel=9)


def normalize_props(work: Path, *, dry_run: bool) -> dict[str, Any]:
    selection = load_yaml(SELECTION_PATH)
    mapping = load_yaml(MAPPING_PATH)
    removal_manifest = load_yaml(ENTITY_REMOVALS_PATH)
    block_removal_manifest = load_yaml(BLOCK_ENTITY_REMOVALS_PATH)
    verify_artifacts(work, selection)
    prop_archive = work / "original" / mapping["prop_pack"]["archive"]
    if not prop_archive.is_file():
        raise PreflightError(f"Missing original prop archive: {prop_archive}")
    actual_prop_hash = sha256(prop_archive)
    expected_prop_hash = str(mapping["prop_pack"]["sha256"]).upper()
    if actual_prop_hash != expected_prop_hash:
        raise PreflightError(
            f"Prop archive SHA-256 mismatch: expected {expected_prop_hash}, "
            f"got {actual_prop_hash}"
        )

    extracted_prop = work / "extracted" / prop_archive.stem
    if not extracted_prop.is_dir():
        if dry_run:
            raise PreflightError("Prop pack has not been extracted")
        extracted_prop.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(prop_archive) as archive:
            archive.extractall(extracted_prop)
    models = model_ids(extracted_prop)
    if len(models) != int(mapping["prop_pack"]["model_count"]):
        raise PreflightError(
            f"Prop model count mismatch: expected "
            f"{mapping['prop_pack']['model_count']}, got {len(models)}"
        )

    roots = normalized_pack_roots(work, selection)
    if dry_run:
        roots = {
            pack: work / "extracted" / Path(spec["archive"]).stem
            for pack, spec in selection["artifacts"].items()
        }
    for pack, root in roots.items():
        if not root.is_dir():
            raise PreflightError(
                f"Prepared working copy missing for {pack}; run prepare first: {root}"
            )

    report: dict[str, Any] = {
        "schema": 1,
        "mapping_id": mapping["mapping_id"],
        "mapping_sha256": sha256(MAPPING_PATH),
        "entity_removals_sha256": sha256(ENTITY_REMOVALS_PATH),
        "block_entity_removals_sha256": sha256(BLOCK_ENTITY_REMOVALS_PATH),
        "prop_archive_sha256": actual_prop_hash,
        "model_count": len(models),
        "packs": {},
    }
    total_replacements: Counter[str] = Counter()
    unresolved_all: set[str] = set()
    removal_results: list[dict[str, Any]] = []
    block_removal_results: list[dict[str, Any]] = []
    removal_rules = {
        (str(rule["pack"]), str(rule["structure_id"])): rule
        for rule in removal_manifest.get("removals", [])
    }
    block_removal_rules = block_removal_manifest.get("removals", [])
    selected_ids = {
        pack: set(data["selected_ids"])
        for pack, data in extract_and_select(work, dry_run=True)["packs"].items()
    }

    for pack, root in roots.items():
        pack_counts: Counter[str] = Counter()
        pack_unresolved: set[str] = set()
        scanned = 0
        for path in sorted(root.rglob("*.schem")):
            scanned += 1
            tree, raw = read_schematic(path)
            replacements, unresolved = build_prop_replacements(
                walk_strings(tree), models, mapping
            )
            pack_unresolved.update(unresolved)
            updated = raw
            counts: Counter[str] = Counter()
            if replacements:
                updated, counts = replace_exact_nbt_strings(updated, replacements)
                if not counts:
                    raise PreflightError(
                        f"Detected prop IDs but replaced none in {path}"
                    )
                pack_counts.update(counts)
            rule = removal_rules.get((pack, path.stem))
            if rule:
                updated, removed = remove_entities_from_nbt(
                    updated, lambda entity: matches_entity_removal(entity, rule)
                )
                expected = int(rule["expected_matches"])
                if len(removed) != expected:
                    raise PreflightError(
                        f"Entity removal count mismatch for {pack}/{path.stem}: "
                        f"expected {expected}, got {len(removed)}"
                    )
                removal_results.append(
                    {
                        "pack": pack,
                        "structure_id": path.stem,
                        "entity_type": rule["entity_type"],
                        "item_id": rule["item_id"],
                        "item_count": rule["item_count"],
                        "removed_count": len(removed),
                    }
                )
            block_removed_for_file = 0
            for block_rule in block_removal_rules:
                updated, removed = remove_compounds_from_named_list(
                    updated,
                    str(block_rule["list_name"]),
                    lambda block_entity, current=block_rule: (
                        matches_block_entity_removal(block_entity, current)
                    ),
                )
                if removed:
                    block_removed_for_file += len(removed)
                    block_removal_results.append(
                        {
                            "pack": pack,
                            "structure_id": path.stem,
                            "block_entity_id": block_rule["block_entity_id"],
                            "removed_count": len(removed),
                        }
                    )
            if not dry_run and (replacements or rule or block_removed_for_file):
                path.write_bytes(gzip.compress(updated, compresslevel=9, mtime=0))
                reparsed, _ = read_schematic(path)
                leftover = set(walk_strings(reparsed)) & set(replacements)
                if leftover:
                    raise PreflightError(
                        f"Prop IDs remain after normalization in {path}: "
                        f"{sorted(leftover)}"
                    )
        unresolved_all.update(pack_unresolved)
        total_replacements.update(pack_counts)
        report["packs"][pack] = {
            "schematics_scanned": scanned,
            "selected_schematics": len(selected_ids[pack]),
            "replacement_string_occurrences": sum(pack_counts.values()),
            "replacement_ids": dict(sorted(pack_counts.items())),
            "unresolved_model_ids": sorted(pack_unresolved),
        }

    if unresolved_all:
        raise PreflightError(
            f"Unresolved bs_prop_pack IDs: {', '.join(sorted(unresolved_all))}"
        )
    expected_removal_keys = set(removal_rules)
    actual_removal_keys = {
        (row["pack"], row["structure_id"]) for row in removal_results
    }
    if actual_removal_keys != expected_removal_keys:
        raise PreflightError(
            "Not all declared entity removals were applied: "
            f"expected {sorted(expected_removal_keys)}, "
            f"got {sorted(actual_removal_keys)}"
        )
    for block_rule in block_removal_rules:
        matching_results = [
            row
            for row in block_removal_results
            if row["block_entity_id"] == block_rule["block_entity_id"]
        ]
        actual_matches = sum(row["removed_count"] for row in matching_results)
        actual_files = len(matching_results)
        if actual_matches != int(block_rule["expected_matches"]):
            raise PreflightError(
                f"Block entity removal count mismatch for "
                f"{block_rule['block_entity_id']}: expected "
                f"{block_rule['expected_matches']}, got {actual_matches}"
            )
        if actual_files != int(block_rule["expected_files"]):
            raise PreflightError(
                f"Block entity removal file count mismatch for "
                f"{block_rule['block_entity_id']}: expected "
                f"{block_rule['expected_files']}, got {actual_files}"
            )

    generated = work / "generated"
    if not dry_run:
        reset_generated_directory(generated, dry_run=False)
        imports = generated / "betterstructures-imports"
        for pack, root in roots.items():
            destination = imports / selection["artifacts"][pack]["archive"]
            deterministic_zip(root, destination)
        shutil.copy2(prop_archive, generated / prop_archive.name)
        report["generated"] = {
            path.name: {"sha256": sha256(path), "size": path.stat().st_size}
            for path in sorted(imports.glob("*.zip"))
        }
        report["generated"][prop_archive.name] = {
            "sha256": sha256(generated / prop_archive.name),
            "size": (generated / prop_archive.name).stat().st_size,
        }
    report["totals"] = {
        "replacement_string_occurrences": sum(total_replacements.values()),
        "replacement_ids": dict(sorted(total_replacements.items())),
        "unresolved_model_ids": sorted(unresolved_all),
        "entity_removals": removal_results,
        "block_entity_removals": block_removal_results,
    }
    if not dry_run:
        write_json(work / "reports" / "prop-normalization-report.json", report)
    return report


def entity_type(entity: dict[str, Any]) -> str:
    candidates = [
        entity.get("Id"),
        entity.get("id"),
        entity.get("EntityData", {}).get("id")
        if isinstance(entity.get("EntityData"), dict)
        else None,
    ]
    for candidate in candidates:
        if isinstance(candidate, str) and candidate:
            return candidate
    return "unknown"


def classify_entity(entity_id: str, entity: dict[str, Any]) -> str:
    short = entity_id.split(":")[-1].lower()
    strings = {value.lower() for value in walk_strings(entity)}
    if short == "armor_stand" and any(
        "free_minecraft_models" in value or "fmm" in value or "prop" in value
        for value in strings
    ):
        return "prop_armor_stand"
    if short == "zombie":
        return "zombie"
    if short == "skeleton":
        return "skeleton"
    if short == "bat":
        return "bat"
    if short in {"item", "item_entity"}:
        return "item"
    if any(
        token in short
        for token in ("arrow", "trident", "fireball", "snowball", "egg", "projectile")
    ):
        return "projectile"
    if short in {"boat", "chest_boat", "minecart", "chest_minecart", "hopper_minecart"}:
        return "vehicle"
    return "other"


def schematic_payload(root: dict[str, Any]) -> dict[str, Any]:
    nested = root.get("Schematic")
    if isinstance(nested, dict):
        return nested
    return root


def entity_audit(work: Path, *, dry_run: bool) -> dict[str, Any]:
    selection = load_yaml(SELECTION_PATH)
    roots = normalized_pack_roots(work, selection)
    selection_report_path = work / "reports" / "selection-report.json"
    if not selection_report_path.is_file():
        raise PreflightError("Selection report missing; run prepare first")
    selection_report = json.loads(selection_report_path.read_text(encoding="utf-8"))
    selected = {
        pack: set(data["selected_ids"])
        for pack, data in selection_report["packs"].items()
    }
    report: dict[str, Any] = {"schema": 1, "packs": {}, "blocking_risks": []}
    totals: Counter[str] = Counter()
    data_versions: Counter[str] = Counter()
    schematic_versions: Counter[str] = Counter()

    representative_ids = {
        "default": {"betterstructures_cistern_nether"},
        "exploration": {"betterstructures_exploration_watertemplesmall_end"},
        "adventure": {"betterstructures_adventure_largewatertemple_nether"},
        "echoes": [
            "betterstructures_echoes_seatemple_acacia",
            "betterstructures_echoes_seatemple_desert",
            "betterstructures_echoes_seatemple_grassland",
            "betterstructures_echoes_seatemple_nether",
            "betterstructures_echoes_seatemple_tundra",
            "betterstructures_echoes_temple_desert",
            "betterstructures_echoes_tower_desert",
        ],
    }
    legacy: list[dict[str, Any]] = []

    for pack, root in roots.items():
        files: list[dict[str, Any]] = []
        for path in sorted(root.rglob("*.schem")):
            structure_id = path.stem
            if structure_id not in selected[pack]:
                continue
            tree, _ = read_schematic(path)
            payload = schematic_payload(tree)
            entities = payload.get("Entities", [])
            if not isinstance(entities, list):
                raise PreflightError(f"Entities is not a list: {path}")
            blocks = payload.get("Blocks", {})
            if not isinstance(blocks, dict):
                blocks = {}
            block_entities = blocks.get(
                "BlockEntities", payload.get("BlockEntities", [])
            )
            palette = blocks.get("Palette", payload.get("Palette", {}))
            if not isinstance(palette, dict):
                palette = {}
            if isinstance(block_entities, list):
                stale_beds = [
                    block_entity
                    for block_entity in block_entities
                    if isinstance(block_entity, dict)
                    and block_entity.get("Id") == "minecraft:bed"
                ]
                if stale_beds:
                    report["blocking_risks"].append(
                        f"{structure_id}: {len(stale_beds)} stale "
                        "minecraft:bed block entities"
                    )
            entity_rows: list[dict[str, Any]] = []
            categories: Counter[str] = Counter()
            for entity in entities:
                if not isinstance(entity, dict):
                    raise PreflightError(f"Non-compound entity in {path}")
                kind = entity_type(entity)
                category = classify_entity(kind, entity)
                categories[category] += 1
                totals[category] += 1
                entity_rows.append(
                    {
                        "type": kind,
                        "category": category,
                        "position": entity.get("Pos"),
                        "rotation": entity.get("Rotation"),
                        "persistent": entity.get("PersistenceRequired"),
                    }
                )
            version = payload.get("Version")
            data_version = payload.get("DataVersion")
            schematic_versions[str(version)] += 1
            data_versions[str(data_version)] += 1
            strings = [value.lower() for value in walk_strings(payload)]
            spawn_sign_candidate = any(
                "spawn" in value and ("sign" in value or "entity" in value)
                for value in strings
            )
            if any(categories[key] for key in ("item", "projectile")):
                report["blocking_risks"].append(
                    f"{structure_id}: saved item/projectile entity"
                )
            if categories["other"] > 64:
                report["blocking_risks"].append(
                    f"{structure_id}: unusually high other-entity count "
                    f"({categories['other']})"
                )
            row = {
                "structure_id": structure_id,
                "schematic_version": version,
                "data_version": data_version,
                "palette_size": len(palette),
                "block_entity_count": len(block_entities)
                if isinstance(block_entities, list)
                else None,
                "entity_count": len(entities),
                "entity_categories": dict(sorted(categories.items())),
                "entities": entity_rows,
                "spawn_sign_overlap_candidate": spawn_sign_candidate,
            }
            if entity_rows or spawn_sign_candidate:
                files.append(row)
            representatives = representative_ids.get(pack, set())
            if structure_id in representatives:
                palette_keys = [str(key) for key in palette]
                legacy.append(
                    {
                        **row,
                        "pack": pack,
                        "container_palette_entries": sorted(
                            key
                            for key in palette_keys
                            if any(
                                token in key
                                for token in (
                                    "chest",
                                    "barrel",
                                    "shulker_box",
                                    "furnace",
                                    "dispenser",
                                    "dropper",
                                    "hopper",
                                )
                            )
                        ),
                        "spawner_palette_entries": sorted(
                            key for key in palette_keys if "spawner" in key
                        ),
                        "portal_palette_entries": sorted(
                            key for key in palette_keys if "portal" in key
                        ),
                        "prop_marker_count": sum(
                            1
                            for value in walk_strings(payload)
                            if value.startswith("bs_prop_pack_")
                        ),
                    }
                )
        report["packs"][pack] = {
            "selected_schematic_count": len(selected[pack]),
            "files_with_entities_or_spawn_candidates": files,
        }

    report["totals"] = {
        "entity_categories": dict(sorted(totals.items())),
        "schematic_versions": dict(sorted(schematic_versions.items())),
        "data_versions": dict(sorted(data_versions.items())),
        "legacy_representatives": legacy,
    }
    if not dry_run:
        write_json(work / "reports" / "entity-audit-report.json", report)
    if report["blocking_risks"]:
        raise PreflightError(
            "Blocking entity risks found: " + "; ".join(report["blocking_risks"])
        )
    return report


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def verify_preflight(work: Path) -> dict[str, Any]:
    selection = load_yaml(SELECTION_PATH)
    mapping = load_yaml(MAPPING_PATH)
    hashes = verify_artifacts(work, selection)
    required_reports = [
        work / "reports" / "selection-report.json",
        work / "reports" / "prop-normalization-report.json",
        work / "reports" / "entity-audit-report.json",
    ]
    for path in required_reports:
        if not path.is_file():
            raise PreflightError(f"Required report missing: {path}")
    reports = [json.loads(path.read_text(encoding="utf-8")) for path in required_reports]
    selection_report, normalization_report, entity_report = reports
    if selection_report["totals"]["selected"] != int(
        selection["selected_structure_count"]
    ):
        raise PreflightError("Selection report does not contain 278 selected structures")
    if normalization_report["totals"]["unresolved_model_ids"]:
        raise PreflightError("Normalization report contains unresolved model IDs")
    if entity_report["blocking_risks"]:
        raise PreflightError("Entity report contains blocking risks")
    generated = work / "generated" / "betterstructures-imports"
    zips = sorted(generated.glob("*.zip"))
    if len(zips) != len(selection["artifacts"]):
        raise PreflightError(
            f"Expected {len(selection['artifacts'])} generated import ZIPs, "
            f"found {len(zips)}"
        )
    result = {
        "schema": 1,
        "status": "pass",
        "selection_manifest_sha256": sha256(SELECTION_PATH),
        "prop_mapping_sha256": sha256(MAPPING_PATH),
        "entity_removals_sha256": sha256(ENTITY_REMOVALS_PATH),
        "block_entity_removals_sha256": sha256(BLOCK_ENTITY_REMOVALS_PATH),
        "source_hashes": hashes,
        "selected_structure_count": selection_report["totals"]["selected"],
        "generated_imports": {
            path.name: {"sha256": sha256(path), "size": path.stat().st_size}
            for path in zips
        },
        "entity_categories": entity_report["totals"]["entity_categories"],
    }
    write_json(work / "reports" / "preflight-report.json", result)
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "command", choices=("prepare", "normalize", "entities", "verify")
    )
    parser.add_argument(
        "--work-root",
        default=str(DEFAULT_WORK.relative_to(ROOT)),
        help="Repository-relative ignored work directory",
    )
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    try:
        work = repo_path(args.work_root)
        if args.command == "prepare":
            result = extract_and_select(work, dry_run=args.dry_run)
        elif args.command == "normalize":
            result = normalize_props(work, dry_run=args.dry_run)
        elif args.command == "entities":
            result = entity_audit(work, dry_run=args.dry_run)
        else:
            if args.dry_run:
                raise PreflightError("--dry-run is not applicable to verify")
            result = verify_preflight(work)
        print(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True))
        return 0
    except (OSError, KeyError, ValueError, yaml.YAMLError, PreflightError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
