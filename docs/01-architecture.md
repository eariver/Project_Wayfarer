# Architecture Summary - Ver.0.0.3

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

WorldEdit 7.4.4 and WorldGuard 7.0.17 form a common administration layer on all Paper backends and are not installed on Velocity. Lobby and `frontier_gate` use protected Global Regions; Main currently has no protection Flags, Members, or Owners.

TAB 6.1.0 and VelocityScoreboardAPI 2.1.0 run only on Velocity. TAB-Bridge 6.2.2 and PlaceholderAPI 2.12.3 run on every Paper backend. This is a proxy installation, not a mixed installation.

Multiverse-Core 5.7.2 runs on all Paper backends. Multiverse-NetherPortals 5.0.5 runs only on Main. Lobby and Frontier register only their existing entry worlds; Velocity has no Multiverse module.

mcMMO 2.3.000 runs only on Main and Frontier. Both use the same local Maven build and the shared `wayfarer_mcmmo` MariaDB database with the `mcmmo_` table prefix. Runtime credentials are rendered from tracked sanitized templates; Lobby and Velocity remain outside this progression boundary.

RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 run only on Main and Frontier. Both backends use the same Redis `waymark` cluster namespace but distinct client names, and expose the internal `vault` currency through Vault as Project Wayfarer's Waymark (`WM`). Runtime Redis credentials are rendered from tracked sanitized templates; Lobby and Velocity remain outside this economy boundary.

EconomyShopGUI 7.1.1 Free runs only on Main. Its five fixed-price categories provide the initial Vanilla-material sell and building/supply buy loop through Vault; shop actions therefore update the shared RedisEconomy balance visible on Frontier without installing the shop there. Lobby, Frontier, and Velocity remain outside the shop boundary.

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
| WorldGuard | Whole entry world protected | Plugin only; no Project regions | Whole entry world protected |
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

BetterStructures is not installed. When introduced, it is limited to the persistent trio with dimension-specific packs and remains disabled in Resource dimensions.

Paper's namespaced runtime keys are authoritative. The persistent family is `minecraft:overworld` ↔ `minecraft:the_nether` / `minecraft:the_end`; the Resource family is `minecraft:resource` ↔ `minecraft:resource_nether` / `minecraft:resource_end`. `main_end` is the Multiverse alias for the existing `main_the_end` world. Explicit NetherPortals links exist in both directions within each family and never cross between families.

## Frontier

`frontier_gate` is currently a protected Void entry world with a temporary safety platform. Planned portals will connect it to approved Adventure worlds/themes after their Plugins and content are installed. Frontier inventory remains local. Waymark balances are shared with Main, while Frontier reward sources and a cross-server shop remain future designs.

## Future components

- Cross-server transit vault for allowlisted common items
- Main-authenticated expedition gear slots
- Frontier achievements and Main memorial rewards
- Frontier local expanded storage
- Cross-server shop and additional Waymark reward sources
- Tutorial and advanced AFK routing
- Disposable creative LAB server
