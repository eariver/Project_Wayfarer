# Main World Baseline

Project Wayfarer replacement-generated the Main persistent family on 2026-07-25 and promoted it to the **Final Main Baseline** after completing Orders 5 and 6. Order 6 accepted the current Weight／Content Config without changes and verified a complete stopped-state Main backup. The 2026-07-21 family remains the **Legacy Rollback Baseline**, and the pre-replacement copy remains the **Replacement Rollback Source**. Final Main Baseline does not mean **V0.1.0 Release Baseline**; this document is not a server release or permission to regenerate any family.

## Runtime and generation policy

| Item | Baseline |
| --- | --- |
| Replacement-generation pre-execution Git HEAD | `c6a5d27c5410666c1cde436d1b6986ebbd334cf8` |
| Order 6 pre-execution Git HEAD | `b2eb75a4ee4839e09b8fa4d76270c59b1e8f9f8c` |
| Main runtime | Paper 26.2 build 62 (`75c0b48`) |
| Java | Oracle Java 25.0.3 LTS, 64-bit Server VM |
| Generation date | 2026-07-25 |
| Final Main Baseline seed | `164225356311935743` |
| Seed policy | Reuse the previously selected Main seed and record it explicitly in `server.properties` |
| Vanilla player-data policy | Complete reset for the regenerated persistent family; external LuckPerms, mcMMO, and Waymark data were outside the reset scope |
| BetterStructures | 2.6.3 with the five-Pack `main-betterstructures-v006` working set; 278 enabled／152 disabled |
| Spawn protection radius | 100 blocks, retained with user approval |
| Acceptance status | Orders 4–6 complete; Order 7 CoreProtect deferred／non-blocking; Order 8 next active |

BetterStructures was enabled only for `main`, `main_nether`, and `main_the_end` during generation. It remained disabled for the complete Resource family and for unknown new worlds.

## Persistent dimension identity

| Dimension | Bukkit world | Runtime / Multiverse key | Storage below repository root | World UUID |
| --- | --- | --- | --- | --- |
| Overworld | `main` | `minecraft:overworld` | `servers/main/main/dimensions/minecraft/overworld/` | `d868e7ff-6663-492d-a963-f95f00ce6c30` |
| Nether | `main_nether` | `minecraft:the_nether` | `servers/main/main/dimensions/minecraft/the_nether/` | `1225688f-7770-43ed-b1dd-71bd112de3b5` |
| End | `main_the_end` | `minecraft:the_end` (Multiverse alias `main_end`) | `servers/main/main/dimensions/minecraft/the_end/` | `436843c4-2229-4c67-907c-b3a7d1530d71` |

All three persistent dimensions report the Final Main Baseline seed above. These are world UUIDs, not player identities.

## Approved spawn baseline

| Purpose | World | Coordinate | Verification |
| --- | --- | --- | --- |
| Normal spawn and bedless respawn | `main` | `(320, 70, 128)` | Savanna ground, safe arrival and death-respawn confirmed |
| Administrative Nether spawn | `main_nether` | `(20.5, 60, -19.5)` | Solid Soul Sand below, two air blocks, no immediate lava or fire; travel confirmed |
| Administrative End spawn | `main_the_end` | `(100.5, 49, 0.5)` | Default obsidian platform, 15-second stationary survival check and round-trip travel confirmed |

The Overworld `respawn_radius` is 10. The End coordinate is an administrative Multiverse spawn on the default obsidian platform; it does not replace normal End progression or Dragon mechanics. `main_the_end` retains the normal legacy Dragon scan policy, while `resource_end` remains configured not to spawn a Dragon.

## Resource-family preservation

The Resource worlds stayed outside the destructive scope and use these storage paths:

- `servers/main/main/dimensions/minecraft/resource/`
- `servers/main/main/dimensions/minecraft/resource_nether/`
- `servers/main/main/dimensions/minecraft/resource_end/`

Before generation, their UUIDs, seeds, file counts, byte totals, tree digests, and Region-file hashes were recorded. After restoration and runtime saves, all three retained the same UUID and seed, their Region counts stayed `8 / 4 / 4`, and every `region/*.mca` SHA-256 matched the backup. Only expected runtime metadata changed during normal saves. BetterStructures remained disabled in all three worlds.

## Backup and rollback

The ignored Final Main Baseline backup is `backups/main-v006-final-baseline-20260725-220745/`. It is a stopped-state copy made without moving or modifying the source Main container.

- Main-container payload: 207 files, 148,994,081 bytes
- SHA-list entries: 227, covering the complete Main container, 17 Config snapshots, and supporting evidence except the self-referential manifest
- Manifest SHA-256: `A85A7CCAA2FE2DECCC69CE3E9F862F1281408B4D02E20EFC1E3E31B74D0814A1`
- SHA-256 list digest: `81593864B49E41FB03F02514C1935DFAF380A1ABFE6FB148897932E328A50C39`
- Source／payload file count, byte total, relative path set, and every SHA-256 matched
- Persistent Region counts stayed `17 / 11 / 18`; Resource counts stayed `8 / 4 / 4`
- Every one of the 16 Resource Region hashes matched the replacement rollback evidence
- `preflight.json`, `manifest.json`, `sha256.txt`, `restore.md`, and `validation.json` are present

The Replacement Rollback Source is `backups/main-v006-replacement-generation-20260725-154934/`. It contains the complete pre-replacement Main container, selected Config, a preflight record, rollback instructions, a JSON manifest, and a SHA-256 list.

- Payload: 181 entries, 99,480,548 bytes
- Manifest SHA-256: `C79C2FC3ECBA998D875200E1D29B1B82B9BE97808B965E28D74B60108F62B118`
- SHA-256 list digest: `037DA91AC7451957DFF57D0F8B3B7592233E5A7A2CC699A4CC709AAB1739B969`
- Every payload hash was reverified before generation and after acceptance.

The Legacy Rollback Baseline also remains at `backups/main-final-generation-20260721-001501/`, with manifest SHA-256 `50B0F6244223DA68B752407BBE89127E0CE49645F7673A5FF929EE9C5B8A3C9D`. All three backups are local, ignored, unavailable from GitHub, and must not be assumed present in another clone.

Restoring the Final Main Baseline requires stopping player access and every Minecraft component, moving the current Main container to a new quarantine location, copying `payload/world/main` and the Config snapshots from the Final Main Baseline backup, verifying file counts and SHA-256, and then checking Seed, UUID, Spawn, Resource family, and Multiverse links. Restore is not part of Order 6 and requires a separately assigned task. Never delete persistent worlds or retry with another seed as improvised recovery.

## Order 6 finalization

The user selected Decision A with exact token `APPROVE-WAYFARER-MAIN-ORDER6-ACCEPT-AS-IS`. No concrete Blocking defect or sufficiently representative density evidence justified changing Weight, Distance, Altitude, Content selection, World allowlist, or Spawn protection. The tracked Selection and Runtime Config therefore remained unchanged at 430 source／278 enabled／152 disabled.

After clean Runtime validation, the user confirmed the existing Exploration Bridge Cave and End Shrine／Vase Prop remained correctly rendered. Paper 26.2 build 62, BetterStructures 2.6.3, WorldEdit 7.4.4, all five packs, FMM 2.10.2 with 55 Models, ResourcePackManager 2.3.0, and existing Gameplay Plugins enabled without a startup-blocking error, failed Schematic, unresolved Model, or duplicate ID. Player cleanup and normal shutdown completed, and no new Region was generated.

The exact final-backup token was `APPROVE-WAYFARER-MAIN-V006-FINAL-BASELINE`. Current stopped-state generated Pack records are:

| Pack | Bytes | SHA-1 | SHA-256 |
| --- | ---: | --- | --- |
| Main ResourcePackManager | 838,975 | `029689B8355600DAAFD96D2F057AC04A65E1091D` | `741986F729C68F3876BA577969AD7AD85B3120526A9E309F13880C6F606C11CE` |
| FreeMinecraftModels | 799,622 | `2B1C7468D9274235D64F1ECB0888EFAB1E62EA75` | `055FCD07115F254486435550A6439A73B4361CC01E3B523B245FF39681CA1C2C` |

Generated Pack ZIPs remain ignored and are not redistributed. Detailed audit, Config／artifact hashes, validation, and backup evidence are recorded in [the Order 6 report](investigations/2026-07-25-main-order6-final-baseline.md).

## Replacement generation and Order 5 acceptance

The assigned destructive task recorded the exact paths, Player Data Policy A
(Complete Reset), verified rollback evidence, and approval token before moving
the Main container. It restored only the Resource family, verified all Resource
Region hashes, and generated the three persistent dimensions with the already
loaded five-Pack working set. BetterStructures initialization was completed
with the user-selected “Use Current Content” path, resulting in tracked
`setupDone: true`; no Content or executable artifact was downloaded.

The final persistent Region totals after bounded acceptance were `11 / 11 / 18`
for Overworld／Nether／End. Relative to the initial `4 / 4 / 4`, the task
generated `7 / 7 / 14` new Region containers, total 28. This is within the
user-amended limits of 16 new End Regions and 32 total; Overworld and Nether
were not expanded after the amendment. No pregeneration, manual paste, Chunk
Pregenerator, or World Border change was used.

Natural generation confirmed:

- Default `betterstructures_mine_storage_deep`;
- Caves and Lost Civilizations Free `bs_lostcivilizations_free_circledungeon_dripstone`;
- Echoes of the Past `betterstructures_echoes_wall_nether`;
- Echoes of the Past `betterstructures_echoes_shrine_end`.

The End Shrine supplied FMM Prop markers. The Vase was not client-visible
immediately after natural generation, but rendered normally after the required
clean restart, proving restart recovery and a valid Model／Pack rather than a
missing texture. The replacement-generation task therefore ended with three
distinct naturally observed Packs and deferred the fourth Pack to a bounded
follow-up.

The follow-up began from `11 / 11 / 18` Region files and loaded only Main
Overworld. Its first destination generated six Region files after delayed view
loading: `r.-2.0.mca`, `r.-2.1.mca`, `r.-2.2.mca`, `r.-1.1.mca`,
`r.-1.2.mca`, and `r.0.2.mca`. Current persistent counts are therefore
`17 / 11 / 18`; the follow-up added `6 / 0 / 0`, within Stage A's eight-Region
limit.

Three natural-generation notifications appeared in the first destination.
Exploration Pack `betterstructures_exploration_bridgecave_shallow` was
identified from the Underground Shallow notification, exact teleport anchor
`(-328, 10, 792)`, Chunk `(-21, 49)`, Region `r.-1.1.mca`, bridge-cave
appearance, enabled selection entry, and the exact Schematic Palette. A Chest
was inspected near `(-330, 4, 801)`, and stopped-state Region inspection
confirmed Chest and Spawner Block Entities in the Structure area. No Portal,
missing texture, unresolved Model, abnormal Entity density, Schematic error, or
duplicate error was found.

After a clean full-network restart, the Client revisited the exact anchor and
confirmed the Structure and Chest remained normally rendered. Every one of the
16 Resource Region hashes remained unchanged, Resource counts stayed
`8 / 4 / 4`, and Nether／End gained no Region. This completes natural-generation
acceptance from Default, Caves and Lost Civilizations Free, Echoes of the Past,
and Exploration Pack. See
[the fourth-Pack report](investigations/2026-07-25-main-fourth-pack-natural-generation.md).

A temporary high-altitude Main／Nether Portal pair passed a round-trip and was
removed from both worlds. Region inspection found no automatically generated
second Portal, no Portal Palette after cleanup, and no remaining forced Chunk.
Multiverse-NetherPortals keeps persistent and Resource families separate.
The normal full-network restart preserved all UUIDs, seeds, spawns, Content
selection, Resource links, and every Resource Region hash. Main Resource Pack
delivery and reconnect passed without protocol failure.

The replacement-generation stopped-state Pack hashes were recorded at that
checkpoint; Order 6 re-recorded the current generated ZIPs in the finalization
section above. Generated Packs remain ignored and are not redistributed. See
[the replacement-generation report](investigations/2026-07-25-main-v006-replacement-generation.md).

## Remaining work

Orders 4, 5, and 6 are complete. Order 7 CoreProtect remains unimplemented,
but is deferred and non-blocking while Main／Lobby wait for an upstream
Minecraft 26.2-compatible Stable release. Order 8 Frontier lock is the next
active task.

The Main spawn Hub, Lobby and Frontier gates, three Resource gates, Resource
return structures, and Resource End outer-island safety structure are not built
or connected. Builder Phase 1B also remains incomplete. Do not delete, trim,
regenerate, rename, paste into, or alter the Seed／UUID of the Final Main Baseline
outside a new assigned destructive task.

Main Spawn WorldGuard protection is designed but not applied. The user first completes the initial Hub footprint; a later approved task then defines the exact Region and focused equipment child regions. Vanilla `spawn-protection=16` remains until that WorldGuard boundary and Builder-member behavior are verified.

Phase 4 EvenMoreFish, the 100x Waymark nominal price revision, and BetterStructures Orders 2 through 6 are complete. Owner-only Hub／Gate construction may proceed before CoreProtect when the Final Main Baseline Backup is retained, focused Schematic／backup evidence is preserved as appropriate, work is divided into controlled units, and a separately accepted WorldGuard boundary is applied after construction. WorldGuard is not a history or point-in-time rollback substitute.
