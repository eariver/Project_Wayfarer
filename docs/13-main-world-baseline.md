# Main World Baseline

Project Wayfarer Ver.0.0.4 Roadmap Phase 3 was completed on 2026-07-21, and Ver.0.0.5 adopts this measured baseline unchanged. This document is the production generation baseline for Main's persistent dimension family; it is not a server release or permission to regenerate the worlds.

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

## Known warning and remaining work

The official BetterStructures pack still emits non-blocking DataFixer ERROR-level messages for legacy `minecraft:bed` block-entity keys. BetterStructures completes initialization and structure generation remains functional; see [BetterStructures legacy bed investigation](investigations/2026-07-20-betterstructures-legacy-bed-datafixer-message.md).

Phase 3 created the persistent terrain baseline and safe spawn coordinates only. The Main spawn Hub, Lobby and Frontier gates, three Resource gates, Resource return structures, and Resource End outer-island safety structure are not built or connected. Builder Phase 1B also remains incomplete and must precede Builder-led Hub/Gate/Theme connection work.

Main Spawn WorldGuard protection is designed but not applied. The user first completes the initial Hub footprint; a later approved task then defines the exact Region and focused equipment child regions. Vanilla `spawn-protection=16` remains until that WorldGuard boundary and Builder-member behavior are verified.

The next Roadmap task is Phase 4: EvenMoreFish integration.
