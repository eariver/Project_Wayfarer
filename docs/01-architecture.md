# Architecture Summary - Ver.0.0.6

## Logical topology

```text
Minecraft Client 26.2
        |
        v
Velocity :25565
├─ Lobby :25566 / Paper 26.2 / Java 25
├─ Main :25567 / Paper 26.2 / Java 25
│  ├─ Main Persistent Family
│  └─ Resource Family
└─ Frontier :25568 / Paper 1.21.11 / Java 25
   ├─ frontier_gate / neutral MVI Group
   ├─ Worlds Beyond / worlds_beyond MVI Group
   │  ├─ Overworld
   │  ├─ Nether
   │  └─ End
   └─ Ruined Frontier / guild MVI Group
      ├─ Adventurer's Guild
      ├─ Primis
      ├─ Ruined Frontier Overworld
      ├─ Ruined Frontier Nether
      ├─ Ruined Frontier End
      └─ approved Dungeon / Instance
```

The Main／Frontier child topology is the approved V0.1.0 target, not the current installed Runtime. All backends bind to `127.0.0.2`; Velocity is the only player-facing endpoint and uses Modern Forwarding. Lobby remains the initial and failover server.

MariaDB currently stores LuckPerms, mcMMO, and EvenMoreFish data. Redis currently stores shared Waymark balances with AOF persistence. Planned Wayfarer_Core／Wayfarer_Frontier schemas and Frontier data owners do not exist until their separate Repository, development, release, migration, and integration tasks complete.

## Current installed foundation

- WorldEdit 7.4.4 and WorldGuard 7.0.17 run on all Paper backends.
- TAB 6.1.0 and VelocityScoreboardAPI 2.1.0 run only on Velocity; TAB-Bridge 6.2.2 and PlaceholderAPI 2.12.3 run on Paper.
- Multiverse-Core 5.7.2 runs on all Paper backends; Multiverse-NetherPortals 5.0.5 currently runs only on Main.
- mcMMO 2.3.000 runs on Main and Frontier with shared MariaDB progression.
- RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 run on Main and Frontier with shared Waymark.
- EconomyShopGUI and EvenMoreFish run only on Main.
- BetterStructures currently runs only on Main with the load-verified five-Pack 278-Structure working set. FreeMinecraftModels 2.10.2 and ResourcePackManager 2.3.0 also run only on Main for the Prop／Java Pack preflight.

MVI, Frontier Multiverse-NetherPortals, CoreProtect, Frontier ResourcePackManager／Pack, formal Network pack hosting, Iris, EliteMobs, Wayfarer_Core, and Wayfarer_Frontier are planned and not installed by Ver.0.0.6.

## Permission boundary

Phase 1A implements five persistent LuckPerms Group definitions. Only Player membership in `wayfarer_builder` or `wayfarer_admin` is temporary. Admin is global and OP-independent while the Temporary Parent is active.

The current Builder inherits only `default`; its Lobby／Frontier WorldGuard Region membership permits protected-entry building without management authority. Phase 1B remains incomplete and follows final Theme, Gate, MVI, ResourcePackManager, EliteMobs, and custom-Plugin Permission locks.

MVI group management, Resource Pack publication／rollback, Wayfarer custom-Plugin administration, EliteMobs internals, Database, economy administration, destructive World operations, WorldGuard Region administration, Velocity, LuckPerms, server stop, reload／debug internals, and unrestricted wildcards remain Admin-only. Exact future nodes are derived only from verified adopted versions.

See [Permission Model](12-permission-model.md).

## Data ownership matrix

| Data | Main | Frontier Lobby | Worlds Beyond | Ruined Frontier |
| --- | --- | --- | --- | --- |
| Inventory／Armor／Offhand | Main local | MVI `neutral` | MVI `worlds_beyond` | MVI `guild` |
| Ender Chest | Main local | MVI `neutral` | MVI `worlds_beyond` | MVI `guild` |
| Vanilla XP／Health／Food | Main local | MVI `neutral` | MVI `worlds_beyond` | MVI `guild` |
| Waymark | Shared | Shared／display policy to lock | Shared | Shared |
| mcMMO | Shared | No gameplay use | Shared | Shared with gameplay enabled |
| Item transfer | None | None | None across groups | None across groups |
| Theme Item | Main only | None | Worlds Beyond only | Guild only |
| EliteMobs progression | None | None | Disabled | Guild only |

Main and Frontier do not transfer any Vanilla or custom Item. Backend and MVI boundaries also isolate Armor, Offhand, Ender Chest, Vanilla XP, Health, Food, Theme equipment, EliteMobs loot, Quest items, and materials.

Only Waymark, mcMMO, and separately approved item-independent achievements／rewards may cross the network boundary. An achievement reward must not create an item-transfer path.

## Main worlds

Persistent and buildable:

- `main`;
- `main_nether`;
- actual Bukkit End `main_the_end` (Multiverse alias `main_end`).

Disposable Resource family:

- `resource`;
- `resource_nether`;
- `resource_end`.

The current persistent family was generated on 2026-07-21 with seed `164225356311935743`; its exact identity and backup remain authoritative in [Main World Baseline](13-main-world-baseline.md).

The five-Pack BetterStructures working set, Prop／FreeMinecraftModels integration, and Main ResourcePackManager preflight are load-verified. Ver.0.0.6 next requires a separately approved destructive persistent-family generation. The Resource family remains excluded. The preflight does not replace the current baseline or authorize World operations.

## Frontier target architecture

### MVI

Multiverse-Inventories is the authoritative owner of normal Frontier world-group Player State:

- `neutral`: `frontier_gate`;
- `worlds_beyond`: the three Worlds Beyond dimensions;
- `guild`: Adventurer's Guild, Primis, the three Ruined Frontier dimensions, approved fixed Dungeons, and verified EliteMobs Instances.

Wayfarer_Frontier does not persist normal Inventory or reimplement MVI switching.

### Ruined Frontier

The alpha target uses BetterStructures and EliteMobs in its Overworld, Nether, and End, plus Adventurer's Guild, Primis, selected free Structure／Shrine／Dungeon Content, Resource Pack assets, and a BetterHealthBar3 adoption test. Exact artifacts and IDs remain implementation locks.

### Worlds Beyond

The MVP target uses persistent Iris Overworld／Nether／End Worlds at PEACEFUL, a dedicated MVI group, Elytra, LeafGrapple, Traversal Loadout, Launchpads, Waystones, Discovery／Teleport GUIs, and a Frontier WM Shop. Exact Engine／Pack／Seed／Border／World IDs remain implementation locks.

### EliteMobs Instances

Inventory integration selects the least complex safe method: static MVI registration, then strict approved-Blueprint Regex, then an Adapter only if necessary. Instance naming, creation／deletion lifecycle, concurrency, restart, reconnect, and relevant APIs／Events must be verified first.

## Custom Plugin responsibility

Wayfarer_Core and Wayfarer_Frontier are V0.1.0 Release Blockers but are not implemented.

Wayfarer_Core owns shared database, migration, Waymark adapter, transaction／idempotency, audit, identity, Redis coordination, message, and Permission-contract foundations.

Wayfarer_Frontier owns Worlds Beyond Loadout and item identity, Launchpads, Waystones and GUIs, Frontier WM Shop, inspection／reconciliation, and only a proven-necessary EliteMobs–MVI Adapter. It does not recreate MVI, Gate, EliteMobs, BetterStructures, or Iris functionality.

Their Source and Build projects belong in separate Repositories. This Repository stores only integration contracts, Version constraints, Config, procedures, Permission／API／Database contracts, acceptance tests, and release hashes.

## Resource Pack architecture

ResourcePackManager 2.3.0 is installed for Main preflight; Frontier remains unimplemented. Main and Frontier use separate Packs.

- Main Pack: Main BetterStructures Prop and FreeMinecraftModels output only.
- Frontier Pack: Ruined Frontier and Worlds Beyond assets, including verified EliteMobs, BetterHealthBar, BetterStructures Prop, and adopted LeafGrapple outputs.

Main's Version, build, optional policy, generated hash, and temporary preflight delivery are recorded. Formal Hosting, failure handling, backend-switch reload, cross-Pack model／shader／font conflicts, cache, and rollback are locked with the Frontier integration. Generated Pack and Model artifacts remain Git-ignored.

## Gate topology

```text
Lobby minimum hub
├─ Main spawn hub
└─ Frontier gate hub

Main spawn hub
├─ Lobby
├─ Frontier gate hub
├─ resource --------> Main spawn hub
├─ resource_nether -> Main spawn hub
└─ resource_end ----> Main spawn hub

Frontier gate hub
├─ Lobby
├─ Main spawn hub
├─ Beyond Gate <-> Worlds Beyond safe return
└─ Guild Gate  <-> Ruined Frontier safe return
```

Each Theme keeps family-local Nether／End Portal links. Gate routes must preserve MVI switching, reject unintended family crossing, and use user-approved structures, coordinates, orientation, and safe arrivals.

## Persistence and recovery

Cold backup must include every authoritative Main／Frontier World, MVI profile, MariaDB database, stopped Redis AOF, custom-Plugin data, Config, Content input, and Resource Pack input required for recovery. Generated artifacts are rebuilt or captured according to the locked procedure. An isolated restore is a V0.1.0 blocker.

CoreProtect is introduced after the new Main baseline and before substantial Hub／Gate construction. It records investigation history and partial rollback only; it is not a cold-backup substitute.

Detailed Frontier authority is in [Frontier V0.1.0 Scope](14-frontier-v0.1.0-scope.md), and implementation order is in the [Roadmap](09-roadmap.md).
