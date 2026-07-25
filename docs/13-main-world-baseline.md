# Main World Baseline

Project Wayfarer replacement-generated the Main persistent family on 2026-07-25. That family is the **Current Runtime Candidate**. The 2026-07-21 family remains the **Last Finalized Rollback Baseline**. The **Final V0.1.0 Main Baseline** is not yet declared because natural-generation evidence from a fourth distinct Pack and Order 6 Weight／Content tuning plus the final backup remain incomplete. This document is not a server release or permission to regenerate either family.

## Runtime and generation policy

| Item | Baseline |
| --- | --- |
| Pre-execution Git HEAD | `c6a5d27c5410666c1cde436d1b6986ebbd334cf8` |
| Main runtime | Paper 26.2 build 62 (`75c0b48`) |
| Java | Oracle Java 25.0.3 LTS, 64-bit Server VM |
| Generation date | 2026-07-25 |
| Candidate seed | `164225356311935743` |
| Seed policy | Reuse the previously selected Main seed and record it explicitly in `server.properties` |
| Vanilla player-data policy | Complete reset for the regenerated persistent family; external LuckPerms, mcMMO, and Waymark data were outside the reset scope |
| BetterStructures | 2.6.3 with the five-Pack `main-betterstructures-v006` working set; 278 enabled／152 disabled |
| Spawn protection radius | 100 blocks, retained with user approval |
| Acceptance status | Limited acceptance; fourth distinct Pack natural-generation evidence remains |

BetterStructures was enabled only for `main`, `main_nether`, and `main_the_end` during generation. It remained disabled for the complete Resource family and for unknown new worlds.

## Persistent dimension identity

| Dimension | Bukkit world | Runtime / Multiverse key | Storage below repository root | World UUID |
| --- | --- | --- | --- | --- |
| Overworld | `main` | `minecraft:overworld` | `servers/main/main/dimensions/minecraft/overworld/` | `d868e7ff-6663-492d-a963-f95f00ce6c30` |
| Nether | `main_nether` | `minecraft:the_nether` | `servers/main/main/dimensions/minecraft/the_nether/` | `1225688f-7770-43ed-b1dd-71bd112de3b5` |
| End | `main_the_end` | `minecraft:the_end` (Multiverse alias `main_end`) | `servers/main/main/dimensions/minecraft/the_end/` | `436843c4-2229-4c67-907c-b3a7d1530d71` |

All three persistent dimensions report the candidate seed above. These are world UUIDs, not player identities.

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

The ignored candidate rollback backup is `backups/main-v006-replacement-generation-20260725-154934/`. It contains the complete replaced Main container, selected Config, a preflight record, rollback instructions, a JSON manifest, and a SHA-256 list.

- Payload: 181 entries, 99,480,548 bytes
- Manifest SHA-256: `C79C2FC3ECBA998D875200E1D29B1B82B9BE97808B965E28D74B60108F62B118`
- SHA-256 list digest: `037DA91AC7451957DFF57D0F8B3B7592233E5A7A2CC699A4CC709AAB1739B969`
- Every payload hash was reverified before generation and after acceptance.

The last finalized baseline also remains at `backups/main-final-generation-20260721-001501/`, with manifest SHA-256 `50B0F6244223DA68B752407BBE89127E0CE49645F7673A5FF929EE9C5B8A3C9D`. Both backups are local, ignored, unavailable from GitHub, and must not be assumed present in another clone.

Rollback requires stopping player access and every Minecraft component, moving the new persistent family to a quarantine location, restoring the old Main container and selected Config from this backup, verifying file counts and SHA-256, and then checking the old seed, spawn, Resource family, and Multiverse links. Never delete persistent worlds or retry with another seed as an improvised recovery.

## Replacement generation and limited acceptance

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
missing texture. Exploration Pack and Adventure Pack remain load-verified, but
neither supplied the fourth distinct naturally observed Pack within the bounded
test. That exact evidence remains Order 5 work.

A temporary high-altitude Main／Nether Portal pair passed a round-trip and was
removed from both worlds. Region inspection found no automatically generated
second Portal, no Portal Palette after cleanup, and no remaining forced Chunk.
Multiverse-NetherPortals keeps persistent and Resource families separate.
The normal full-network restart preserved all UUIDs, seeds, spawns, Content
selection, Resource links, and every Resource Region hash. Main Resource Pack
delivery and reconnect passed without protocol failure.

Final stopped-state Main Java Pack SHA-256 was
`A2E4999A6A00A0458570A379487BB78E3FEEA926829627C6BB3A9660FA7565C3`;
the FMM component Pack SHA-256 was
`7930BAB098A7A26DFFBCD23200D6C06CB339C115412C50DAC6D3C2060E875B6E`.
Generated Packs remain ignored and are not redistributed. See
[the replacement-generation report](investigations/2026-07-25-main-v006-replacement-generation.md).

## Remaining work

Order 4 is complete. Order 5 remains incomplete only for natural-generation
evidence from a fourth distinct Pack. Order 6 must then decide Weight／Content
tuning, accept or replace the candidate, and create the final baseline backup.
Order 7 CoreProtect remains unimplemented.

The Main spawn Hub, Lobby and Frontier gates, three Resource gates, Resource
return structures, and Resource End outer-island safety structure are not built
or connected. Builder Phase 1B also remains incomplete. Do not delete, trim,
regenerate, rename, paste into, or alter the Seed／UUID of the Runtime Candidate
outside a new assigned destructive task.

Main Spawn WorldGuard protection is designed but not applied. The user first completes the initial Hub footprint; a later approved task then defines the exact Region and focused equipment child regions. Vanilla `spawn-protection=16` remains until that WorldGuard boundary and Builder-member behavior are verified.

Phase 4 EvenMoreFish, the 100x Waymark nominal price revision, BetterStructures Orders 2／3, and replacement generation Order 4 are complete. Finish the exact Order 5 evidence and Order 6 tuning／backup before CoreProtect and substantial Hub／Gate construction.
