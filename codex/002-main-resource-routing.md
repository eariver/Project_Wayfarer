# Codex Task: Main Resource Routing and Dragon Policy

## Objective
Configure Main so that the Main hub has independent direct gates to `resource`, `resource_nether`, and `resource_end`, and ensure `resource_end` never spawns an Ender Dragon.

## Allowed scope
- `servers/main/`
- `docs/`
- `versions.yml`
- `plugin-manifest.yml`

## Requirements
- Inspect generated Multiverse, Advanced Portals, and Paper configs; do not invent keys.
- Keep `main`, `main_nether`, and `main_end` persistent.
- Keep all three Resource worlds resettable and free from BetterStructures content.
- Set `entities.spawning.scan-for-legacy-ender-dragon: false` only for `resource_end`.
- Keep the setting true for `main_end`.
- Route the Resource End gate to a verified safe outer-island location and create an explicit return gate to Main.
- Do not rely on the Dragon exit portal or Dragon-generated End gateways.
- Do not access paths outside the repository without prior permission under `AGENTS.md`.

## Validation
- Verify YAML syntax.
- Verify direct travel and return for all three Resource worlds.
- Regenerate `resource_end` and verify no Ender Dragon exists.
- Verify `main_end` behavior remains unchanged.
- Report exact generated config paths and changed files.
