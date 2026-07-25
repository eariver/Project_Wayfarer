# Main World Baseline

Project Wayfarer Ver.0.0.4 Roadmap Phase 3 was completed on 2026-07-21, and Ver.0.0.6 continues to use this measured baseline as the current Runtime source of truth. This document remains the production generation baseline for Main's persistent dimension family until a separately approved replacement generation, acceptance, tuning, backup, and baseline-update task completes. It is not a server release or permission to regenerate the worlds.

## Runtime and generation policy

| Item | Baseline |
| --- | --- |
| Pre-execution Git HEAD | `04adff14fdf3e31a730c2471a0c6a809ed82de57` |
| Main runtime | Paper 26.2 build 62 (`75c0b48`) |
| Java | Oracle Java 25.0.3 LTS, 64-bit Server VM |
| Generation date | 2026-07-21 |
| Final seed | `164225356311935743` |
| Seed policy | Reuse the previously selected Main seed and record it explicitly in `server.properties` |
| Vanilla player-data policy | Complete reset for the regenerated persistent family; external LuckPerms, mcMMO, and Waymark data were outside the reset scope |
| BetterStructures | 2.6.3 with `103 Default Structures` version 5 |
| Spawn protection radius | 100 blocks, retained with user approval |

BetterStructures was enabled only for `main`, `main_nether`, and `main_the_end` during generation. It remained disabled for the complete Resource family and for unknown new worlds.

## Persistent dimension identity

| Dimension | Bukkit world | Runtime / Multiverse key | Storage below repository root | World UUID |
| --- | --- | --- | --- | --- |
| Overworld | `main` | `minecraft:overworld` | `servers/main/main/dimensions/minecraft/overworld/` | `1994ef0e-887d-45d2-8860-7c1bb8e0a085` |
| Nether | `main_nether` | `minecraft:the_nether` | `servers/main/main/dimensions/minecraft/the_nether/` | `78d1c82f-f67e-47d7-9af4-06aadc7684a6` |
| End | `main_the_end` | `minecraft:the_end` (Multiverse alias `main_end`) | `servers/main/main/dimensions/minecraft/the_end/` | `e97d228f-11c4-46e6-b7b8-28f458c7a778` |

All three persistent dimensions report the final seed above. These are world UUIDs, not player identities.

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

The ignored local rollback backup is `backups/main-final-generation-20260721-001501/`. It contains the complete pre-generation Main container, selected Config, a preflight record, a JSON manifest, and a SHA-256 list.

- Payload: 177 files, 97,364,677 bytes
- Manifest SHA-256: `50B0F6244223DA68B752407BBE89127E0CE49645F7673A5FF929EE9C5B8A3C9D`
- SHA-256 list digest: `BDE2005F42915AF8272721A177CF26F8F6C04D50E19020E99341998CD6F4B748`
- Every payload hash was reverified before generation.

The backup is local, ignored, and is not available from GitHub. Do not delete it while Phase 3 rollback remains operationally relevant.

Rollback requires stopping player access and every Minecraft component, moving the new persistent family to a quarantine location, restoring the old Main container and selected Config from this backup, verifying file counts and SHA-256, and then checking the old seed, spawn, Resource family, and Multiverse links. Never delete persistent worlds or retry with another seed as an improvised recovery.

## Content preflight and remaining work

The 2026-07-25 non-destructive Content preflight loaded the five-Pack
`main-betterstructures-v006` working set, FreeMinecraftModels 2.10.2,
BetterStructures Prop Pack, and ResourcePackManager 2.3.0. It selected 278 of
430 Structure configurations, resolved every adopted Prop ID, and generated the
Main Java Resource Pack. The normalization pipeline removes only the 144 stale
`minecraft:bed` Block Entity records previously investigated in
[the legacy-bed report](investigations/2026-07-20-betterstructures-legacy-bed-datafixer-message.md);
the bed blocks remain in the Palette. The final clean load had no DataFixer
message or failed Schematic.

This preflight did not paste a Structure or intentionally load an ungenerated
Chunk. The Runtime-only load comparison kept all persistent Region SHA-256
values unchanged. During the approved Client smoke test, representative FMM
Props were placed and removed in already-generated Overworld Chunks. Region
counts remained `11 / 4 / 4`, no new Region appeared, and Nether／End hashes
remained unchanged; four existing Overworld Region-container hashes changed
during normal Player-session saves, so byte-for-byte post-Client invariance is
not claimed. Seed, World registration, and Spawn settings remain unchanged. See
[the Content preflight report](investigations/2026-07-25-main-betterstructures-content-preflight.md).

Phase 3 created the persistent terrain baseline and safe spawn coordinates only. The Main spawn Hub, Lobby and Frontier gates, three Resource gates, Resource return structures, and Resource End outer-island safety structure are not built or connected. Builder Phase 1B also remains incomplete and must precede Builder-led Hub/Gate/Theme connection work.

Ver.0.0.6 now has a load-verified Main BetterStructures expansion working set across `main`, `main_nether`, and `main_the_end`: five selected Structure packs, BetterStructures Prop Pack, FreeMinecraftModels 2.10.2, and ResourcePackManager 2.3.0. Artifact versions, sources, hashes, Structure selection, Weight, Prop／Model IDs, and preflight Pack output are locked. The generated Worlds still contain only the former 103 Default Structures baseline.

That approval does not supersede this baseline or authorize immediate World changes. Do not delete, trim, regenerate, rename, paste into, or alter the Seed／UUID of the current persistent family outside the dedicated destructive task. The complete Resource family remains outside the replacement-generation scope and must retain BetterStructures exclusion.

After Content preflight and healthy load confirmation, the destructive task must preserve exact rollback evidence, regenerate only the persistent family, verify representative natural generation, Portal links, safe Spawn, Main Resource Pack delivery, and Resource-family exclusion, then apply approved tuning. Only after the new identities and verified backup are recorded may this document be replaced with the new baseline.

Main Spawn WorldGuard protection is designed but not applied. The user first completes the initial Hub footprint; a later approved task then defines the exact Region and focused equipment child regions. Vanilla `spawn-protection=16` remains until that WorldGuard boundary and Builder-member behavior are verified.

Phase 4 EvenMoreFish, the 100x Waymark nominal price revision, and Main BetterStructures Roadmap Order 2／3 preflight are complete. The next implementation stage is the separately approved destructive replacement generation of only the persistent Main family. CoreProtect follows the verified replacement Main baseline and precedes substantial Hub／Gate construction.
