# Architecture Summary - Ver.0.0.5

## Logical topology

```text
Minecraft Client 26.2
        |
        v
Velocity :25565
  |-- Lobby :25566 / Paper 26.2 / Java 25
  |-- Main :25567 / Paper 26.2 / Java 25
  `-- Frontier :25568 / Paper 1.21.11 / Java 25

MariaDB: LuckPerms and Main/Frontier mcMMO sharing in use; network database reserved
Redis: Main/Frontier RedisEconomy Waymark sharing in use; chat transport is not installed
```

All backend servers bind to `127.0.0.2`. Velocity is the only player-facing endpoint. Modern forwarding is mandatory.

WorldEdit 7.4.4 and WorldGuard 7.0.17 form a common administration layer on all Paper backends and are not installed on Velocity. Lobby and `frontier_gate` use protected Global Regions; Main currently has no protection Flags, Members, or Owners. Main Spawn protection is designed but remains unimplemented until the user substantially completes the Hub and approves an exact `main_spawn_hub` boundary. Vanilla `spawn-protection=16` remains in force until that later WorldGuard integration is verified.

TAB 6.1.0 and VelocityScoreboardAPI 2.1.0 run only on Velocity. TAB-Bridge 6.2.2 and PlaceholderAPI 2.12.3 run on every Paper backend. This is a proxy installation, not a mixed installation.

Multiverse-Core 5.7.2 runs on all Paper backends. Multiverse-NetherPortals 5.0.5 runs only on Main. Lobby and Frontier register only their existing entry worlds; Velocity has no Multiverse module.

mcMMO 2.3.000 runs only on Main and Frontier. Both use the same local Maven build and the shared `wayfarer_mcmmo` MariaDB database with the `mcmmo_` table prefix. Runtime credentials are rendered from tracked sanitized templates; Lobby and Velocity remain outside this progression boundary.

RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 run only on Main and Frontier. Both backends use the same Redis `waymark` cluster namespace but distinct client names, and expose the internal `vault` currency through Vault as Project Wayfarer's Waymark (`WM`). Runtime Redis credentials are rendered from tracked sanitized templates; Lobby and Velocity remain outside this economy boundary.

EconomyShopGUI 7.1.1 Free runs only on Main. Its five fixed-price categories provide the initial Vanilla-material sell and building/supply buy loop through Vault; shop actions therefore update the shared RedisEconomy balance visible on Frontier without installing the shop there. Lobby, Frontier, and Velocity remain outside the shop boundary.

## Current permission boundary and Phase 1B

Phase 1A implements five persistent LuckPerms group definitions: `default`, `wayfarer_builder_eligible`, `wayfarer_admin_eligible`, `wayfarer_builder`, and `wayfarer_admin`. Only a Player's Parent membership in either Role Group is temporary. `default` and the existing `wayfarer_builder` were reused; Eligibility carries normal gameplay rights plus matching self-only temporary parent control through Velocity, not the Role's authority. `wayfarer_admin` provides global full access while its temporary Parent is active, and all Paper backends remain OP-free.

The current Builder is an empty Role container that inherits only `default`. Its existing Lobby／Frontier WorldGuard Region membership permits protected-entry building, but the former WorldEdit／WorldGuard administration wildcards have been removed. Phase 1B will define the explicit Paper command allowlist after Advanced Portals, the playable Frontier Theme, and Builder Hub／Gate work are known. OS processes, Docker, databases, backups, and restore remain outside Minecraft permissions and belong to the planned integrated PowerShell operations layer. See [Permission Model](12-permission-model.md).

## Data boundaries

| Data | Lobby | Main | Frontier |
|---|---|---|---|
| Normal inventory | Local only | Local only | Local only |
| Ender chest / XP / health | Local only | Local only | Local only |
| LuckPerms identity | Shared | Shared | Shared |
| TAB | Network | Network | Network |
| Global chat | Not installed | Not installed | Not installed |
| Waymark | Not used | Shared with Frontier | Shared with Main |
| Waymark shop | Not installed | EconomyShopGUI 7.1.1 | Not installed |
| mcMMO | Not installed | Shared with Frontier | Shared with Main |
| WorldGuard | Whole entry world protected | Plugin only; Spawn protection designed but not applied | Whole entry world protected |
| EvenMoreFish | Not installed | Planned | Not installed |
| Frontier achievements | Future | Future consumer | Future producer |
| Transit vault | Future | Future | Future |

## Main worlds

Persistent and buildable:

- `main`
- `main_nether`
- `main_end`

Installed disposable resource worlds, designed for near-vanilla generation without Plugin-added structures:

- `resource`
- `resource_nether`
- `resource_end`

BetterStructures 2.6.3 is installed only on Main with the free `103 Default Structures` pack. Its Bukkit-world allowlist is `main`, `main_nether`, and the actual End world name `main_the_end`; all three Resource worlds and unknown new worlds are disabled. Structures appear only in newly generated chunks. Frontier retains only a conditional, not-installed BetterStructures entry.

Paper's namespaced runtime keys are authoritative. The persistent family is `minecraft:overworld` ↔ `minecraft:the_nether` / `minecraft:the_end`; the Resource family is `minecraft:resource` ↔ `minecraft:resource_nether` / `minecraft:resource_end`. `main_end` is the Multiverse alias for the existing `main_the_end` world. Explicit NetherPortals links exist in both directions within each family and never cross between families.

Phase 3 generated the persistent family on 2026-07-21 with seed `164225356311935743`. Its physical paths are `servers/main/main/dimensions/minecraft/overworld`, `the_nether`, and `the_end`; the three Resource directories remain alongside them under the same Main container. The approved spawn coordinates are Overworld `(320, 70, 128)`, Nether `(20.5, 60, -19.5)`, and End `(100.5, 49, 0.5)`. See [Main World Baseline](13-main-world-baseline.md) for identities, preservation evidence, and rollback.

## Frontier

`frontier_gate` is currently a protected Void entry world with a temporary safety platform. V0.1.0 requires one user-approved playable theme, but no theme has been selected or installed. The theme must support safe Gate entry and return through `frontier_gate`. Frontier inventory remains local and is used normally across the initial theme; mcMMO and Waymark balances remain shared with Main. Frontier WM rewards, achievements, Main-side rewards, theme-specific inventories, and initial equipment remain future designs.

## Planned V0.1.0 Gate topology

```text
Lobby minimum hub
  |-- Main spawn hub
  `-- Frontier gate hub

Main spawn hub
  |-- Lobby
  |-- Frontier gate hub
  |-- resource --------> Main spawn hub
  |-- resource_nether -> Main spawn hub
  `-- resource_end ----> Main spawn hub

Frontier gate hub
  |-- Lobby
  |-- Main spawn hub
  `-- Playable theme <-> Frontier gate safe return
```

This diagram is a target, not current runtime state. Hub appearance, coordinates, orientation, structures, and safe arrival points are user-built inputs. Gate configuration and verification follow only after those inputs are fixed. Each disposable Resource reset must bootstrap its arrival, return structure, portal definition, optional protection, and safe spawn without changing persistent worlds. `resource_end` additionally requires a reproducible outer-island site independent of the Dragon exit portal and End gateways.

CoreProtect is intentionally scheduled after EvenMoreFish but before substantial Hub/Gate construction so construction history exists from the start. It is not installed, its placement and database policy are not selected, rollback remains Admin-only, and it does not replace cold backup. After the user substantially completes the Main Hub, a separate task applies the approved WorldGuard membership region and focused child regions before routing is opened.

## Future components

- Cross-server transit vault for allowlisted common items
- Main-authenticated expedition gear slots
- Frontier achievements and Main memorial rewards
- Frontier local expanded storage
- Cross-server shop and additional Waymark reward sources
- Tutorial and advanced AFK routing
- Disposable creative LAB server

Deferred design tradeoffs, including temporary-role cleanup, Resource bootstrap implementation, theme inventories, achievements, and Main teleporters, are tracked in [Deferred Design Items](11-deferred-design-items.md).

The V0.2.x custom-Plugin concept stored under `codex/` is a non-authoritative draft. It is outside V0.1.0 scope and does not authorize source, repository, schema, migration, or artifact work.
