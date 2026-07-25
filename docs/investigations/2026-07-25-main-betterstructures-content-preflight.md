# Main BetterStructures Content／Resource Pack Preflight

Date: 2026-07-25
Status: Runtime and client preflight passed
Scope: Roadmap Order 2 and 3 only

## Outcome

The five-Pack Main working set, BetterStructures Prop Pack, FreeMinecraftModels
2.10.2, and ResourcePackManager 2.3.0 were integrated without regenerating the
persistent Main family. BetterStructures loaded all 430 source
configurations with the manifest-selected 278 enabled and 152 disabled.
FreeMinecraftModels loaded 55 models, ResourcePackManager built the merged Java
pack, and the final clean Main boot contained no integration-caused ERROR,
SEVERE, Exception, failed Schematic, duplicate ID, or unresolved Model ID.

This report records integration evidence, not a new World baseline. Persistent
Main regeneration, natural-generation acceptance, tuning, and baseline
replacement remain separate work.

## Artifact lock

All executable and Content artifacts were supplied manually in an ignored
repository-local staging directory. Codex did not download a JAR, ZIP,
Schematic, Model, Server binary, or generated Resource Pack.

| Artifact | Version／count | SHA-256 | Official source and terms | Runtime use |
| --- | --- | --- | --- | --- |
| BetterStructures | 2.6.3 | `AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038` | [Modrinth](https://modrinth.com/plugin/betterstructures), LGPL-3.0-only | Existing Main-only Plugin |
| 103 Default Structures | internal 5／103 | `118D873FDF87BF94EA6CA3036897B10790F5D73E62F8387E75C1AB6A4A360FE0` | [Nightbreak](https://nightbreak.io/plugin/betterstructures/), free Vendor Content | Main working copy |
| Exploration Pack | internal 6／49 | `963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B` | [Nightbreak](https://nightbreak.io/plugin/betterstructures/), free Vendor Content | Main working copy |
| Caves and Lost Civilizations Free | internal 2／49 | `27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677` | [Nightbreak](https://nightbreak.io/plugin/betterstructures/), free Vendor Content | Main working copy |
| Adventure Pack | internal 1／107 | `96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C` | [Nightbreak](https://nightbreak.io/plugin/betterstructures/), premium Vendor Content | Main working copy |
| Echoes of the Past | internal 3／122 | `B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F` | [Nightbreak](https://nightbreak.io/plugin/betterstructures/), premium Vendor Content | Main working copy |
| BetterStructures Prop Pack | 55 Models | `F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D` | Nightbreak BetterStructures／FMM Content, Vendor terms | FMM Main working copy |
| FreeMinecraftModels | 2.10.2 | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` | [Modrinth release](https://modrinth.com/plugin/free-minecraft-models/version/sQDrL88L), GPL-3.0-only | Main only |
| ResourcePackManager | 2.3.0 | `240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64` | [Modrinth release](https://modrinth.com/plugin/resourcepackmanager/version/sm5yLBux), LGPL-3.0-only | Main only |

The local FMM and ResourcePackManager JAR SHA-1 values,
`B019DCEAECB262CB2722750E0C271874728D39DB` and
`5FAFBCDA1371E2360DF00D5B2DAA26B1B9575E86`, exactly match their official
Modrinth release records. Both releases explicitly include Minecraft 26.2 and
Paper. Their JAR metadata requires Java 21 bytecode or newer; the verified
Runtime is 64-bit Java 25.

Nightbreak distributes the Content specifically for BetterStructures Server
installation and the Prop Pack for FMM-backed BetterStructures display. That
supports the adopted Server use, local normalization, and generated Client pack
delivery. It does not grant this MIT repository a redistribution license.
Originals, premium Content, normalized working copies, Models, Schematics, and
generated packs therefore remain ignored and are not redistributed by Project
Wayfarer. Vendor terms remain authoritative.

## Reproducible working set

The tracked source of truth is:

- `config/main-betterstructures/selection.yml`;
- `config/main-betterstructures/prop-id-mapping.yml`;
- `config/main-betterstructures/entity-removals.yml`;
- `config/main-betterstructures/block-entity-removals.yml`;
- the four PowerShell entry points and
  `scripts/main_betterstructures_tools.py`.

The pipeline validates every source SHA-256, expands only exact IDs, edits a
separate ignored working copy, fails on unknown IDs or unresolved Models, and
produces deterministic ZIP files. Two complete successive builds produced the
same SHA-256 for every import ZIP. Safe Dry Run passed for selection,
normalization, and entity auditing.

| Result | Count |
| --- | ---: |
| Source Schematic configurations | 430 |
| Enabled | 278 |
| Disabled | 152 |
| Design classification: Overworld／Nether／End | 191／44／43 |
| Actual generator classification: Overworld／Nether／End | 188／47／43 |

The count difference is intentional: four Default-pack sky-island variants
use Nether generators, while the approved design table classified three of
them from their ID names. All 103 Default structures remain enabled, so both
classifications are recorded rather than silently changing the approved set.

Generated import locks:

| Pack | Generated ZIP SHA-256 |
| --- | --- |
| Default | `A4373A2692590734D7D95051819722ED05985A49668BDADDF83B1999D2964463` |
| Exploration | `CF9FB95A81ACA8993B1781FC784DB9D14B360E40C5B6C613D31019BC845A91E0` |
| Caves Free | `CF3E34EEE926DFDD6C67703013298663227BA71AFFA398ED81DD9A6E421478D9` |
| Adventure | `13949D75D0E5A813EBE7CCBBF6D0D32D9243424BF183D5B2006FA22F339C1F8A` |
| Echoes | `63D924CF4BFBA5305C8720418D1684AD809B0FAB0385B7439D2259681AE6E0A7` |

## Prop and Schematic audit

The generic mapping adds the exact `bs_prop_pack_` prefix only when the target
Model exists. Explicit approved exceptions are:

| Source ID | Target |
| --- | --- |
| `alchamytable` | `bs_prop_pack_alchemy_table` |
| `shelf4` | `bs_prop_pack_shelf2` |
| `ladder` | `bs_prop_pack_ladder_short` |

There were 240 exact replacement occurrences and zero unresolved Model IDs.
No unknown ID was guessed or replaced.

Selected Schematic entity totals were:

| Category | Count |
| --- | ---: |
| Prop Armor Stand | 627 |
| Zombie | 17 |
| Skeleton | 27 |
| Bat | 29 |
| Other ordinary Entity | 68 |
| Item／Projectile | 0 |

One saved egg Item in `betterstructures_mine_nether` was removed under the
user-approved exact transformation rule. The source archive remains unchanged.
No broad ordinary-Entity removal was performed.

The selected set contains Sponge Schematic v2／DataVersion 2865 and v3／
DataVersion 3955. Exact representative legacy checks passed for
`cistern_nether`, `watertemplesmall_end`, `largewatertemple_nether`, the five
selected `seatemple` variants, `tower_desert`, and `temple_desert`. WorldEdit
7.4.4 loaded all selected Schematics.

The imported source had 144 stale `minecraft:bed` Block Entity records across
24 Schematics. Paper 26.2 rejected these records even though their bed blocks
remain represented by the Palette. With explicit user approval, the
normalization pipeline now removes only those exact stale Block Entity records.
The final load had zero bed DataFixer messages and zero failed Schematics.

## Plugin and Config result

- BetterStructures 2.6.3, FreeMinecraftModels 2.10.2, and
  ResourcePackManager 2.3.0 enabled only on Main.
- WorldEdit 7.4.4 satisfied the BetterStructures dependency.
- BetterStructures recognized all five adopted Content packages.
- FMM loaded the 55-Model BetterStructures Prop Pack.
- FMM furniture, EliteMobs, and both Craftenmine packages are explicitly
  disabled; its Player furniture shop is disabled.
- General Main players are explicitly denied the FMM menu and shop permissions;
  temporary Admin retains the established wildcard authority.
- Plugin auto-download and automatic binary replacement remain disabled.
- EliteMobs, LeafGrapple, Worlds Beyond, and Frontier-only assets are absent.

The BetterStructures allowlist remains:

```yaml
New worlds spawn structures: false
Valid worlds:
  main: true
  main_nether: true
  main_the_end: true
  resource: false
  resource_nether: false
  resource_end: false
```

`main_end` is not used as a Bukkit World key. Spawn protection radius remains
100 and EliteMobs Region integration remains disabled.

## Resource Pack and hosting preflight

ResourcePackManager 2.3.0 was selected because the official release supports
Minecraft 26.2, Paper, FMM auto-merge, SHA-1 Client delivery, optional prompt
behavior, and remote fallback without a paid external account. The Main
configuration merges only ResourcePackManager, FreeMinecraftModels, and
BetterStructures in that priority order. Bedrock conversion is disabled.

The generated files remain ignored:

| Output | Size | SHA-1 | SHA-256 |
| --- | ---: | --- | --- |
| FMM Java pack | 799,622 bytes | `2B1C7468D9274235D64F1ECB0888EFAB1E62EA75` | `055FCD07115F254486435550A6439A73B4361CC01E3B523B245FF39681CA1C2C` |
| Main merged Java pack | 838,975 bytes | `029689B8355600DAAFD96D2F057AC04A65E1091D` | `741986F729C68F3876BA577969AD7AD85B3120526A9E309F13880C6F606C11CE` |

For this preflight, `autoHost: true`, `forceResourcePack: false`,
`selfHostEnabled: false`, and `preferSelfHost: false` use Nightbreak's
temporary remote hosting. No account, credential, public bucket, firewall
change, router change, or Backend Paper port exposure was introduced.
ResourcePackManager network detection still opens an internal backend endpoint;
offset 2 selects loopback port 25569 rather than Frontier's 25568. The endpoint
closed normally with Main. Its random hosting URL is Runtime-sensitive and is
not published here.

Nightbreak documents that remote auto-host data is pseudonymous, contains the
pack plus SHA-1 metadata, is not download-logged or sold, and expires after
Server shutdown inactivity. This is accepted only for preflight. Formal V0.1.0
Main／Frontier hosting and backend-switch policy remain to be locked with the
future Frontier pack.

The final clean Main boot reached `Done`, completed FMM initialization, loaded
all BetterStructures Content, mixed and uploaded the pack, then disabled all
three Plugins and saved all dimensions during normal shutdown.

## Client preflight

Minecraft 26.2 connected through Velocity and entered Main from Lobby. The
optional resource-pack prompt was accepted, the pack downloaded in under five
seconds, and `/fmm admin` opened with temporary Admin authority. A representative
Prop rendered correctly. Temporary Admin removal succeeded.

After `Main -> Lobby -> Main`, the unchanged pack was available again in about
one second and a second representative Prop rendered correctly without a
duplicate or critical Client error. Both test Props were removed with the
radius-limited `/fmm deleteall 2` command, and the temporary Admin parent was
removed.

The Client's Server Resource Packs setting was then changed to Disabled.
`Lobby -> Main` remained connected because `forceResourcePack: false`. After
restoring the setting and reconnecting, the pack loaded from Client cache in
about one second and the representative Models displayed normally. The Player
disconnected before the final normal shutdown.

## World and rollback evidence

Pre-change ignored snapshot:

`backups/main-betterstructures-preflight-20260725-140012/`

- Git HEAD: `9c3239ca69f55d07c54646f6c92a1533360a3142`
- Snapshot manifest SHA-256:
  `6F118EFA78B7D02BEB31FD4275373B8D69C201FF7341DC539074AE2244A16BAA`
- Persistent Region inventory: Overworld 11, Nether 4, End 4
- Runtime-only comparison before Client entry: same filenames and every Region
  SHA-256 unchanged
- Post-Client comparison: same `11 / 4 / 4` Region inventory, no new Region;
  Nether and End hashes unchanged; four existing Overworld Region-container
  hashes changed during normal Player-session saves
- Seed: `164225356311935743`
- Spawn settings: `(320,70,128)`, `(20.5,60,-19.5)`,
  `(100.5,49,0.5)`

Normal boot updates volatile `level.dat` metadata. Before the Client entered,
no persistent Region file changed. The approved Client test used only existing
Overworld terrain and temporarily placed two FMM Props, then removed them with
the Plugin's radius-limited deletion command. Normal Player-session saves
changed four existing Overworld Region-container hashes; this report therefore
does not claim byte-for-byte post-Client World-payload invariance. No new Region
appeared, Nether and End remained byte-identical, no Structure was pasted, and
no ungenerated Chunk was intentionally loaded. The Phase 3 Seed, registered
Worlds, Spawn settings, and current baseline remain authoritative.

Rollback is: stop Main normally, restore the copied BetterStructures and
Config payload from the ignored snapshot, remove the newly introduced FMM／RPM
Runtime directories and JARs, then verify the recorded World identity and
Region inventory. The snapshot intentionally contains no World payload.

## Gate result

Artifact, reproducibility, Schematic, Model, Runtime-load, resource-pack,
optional-refusal, reconnect-cache, cleanup, and Git-exclusion gates passed.
Roadmap Order 2／3 is complete. Persistent Main regeneration, natural-generation
acceptance, tuning, new World identities, and replacement baseline creation
remain exclusively in the separately approved destructive task.
