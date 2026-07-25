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
   │  └─ frontier_iris / Iris Overworld only
   └─ Ruined Frontier / guild MVI Group
      ├─ Adventurer's Guild
      ├─ Primis
      ├─ Ruined Frontier Overworld
      ├─ Ruined Frontier Nether
      ├─ Ruined Frontier End
      └─ approved Dungeon / Instance
```

The Main／Frontier child topology is the approved V0.1.0 target, not the current installed Runtime. All backends bind to `127.0.0.2`; Velocity is the only player-facing endpoint and uses Modern Forwarding. Lobby remains the initial and failover server.

MariaDB currently stores LuckPerms, mcMMO, and EvenMoreFish data. Redis currently stores shared Waymark balances with AOF persistence. Planned Wayfarer_Core／Main／Frontier schemas and data owners do not exist until the one external Gradle Multi-module Repository, development, release, migration, and integration tasks complete.

## Current installed foundation

- WorldEdit 7.4.4 and WorldGuard 7.0.17 run on all Paper backends.
- TAB 6.1.0 and VelocityScoreboardAPI 2.1.0 run only on Velocity; TAB-Bridge 6.2.2 and PlaceholderAPI 2.12.3 run on Paper.
- Multiverse-Core 5.7.2 runs on all Paper backends; Multiverse-NetherPortals 5.0.5 currently runs only on Main.
- mcMMO 2.3.000 runs on Main and Frontier with shared MariaDB progression.
- RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 run on Main and Frontier with shared Waymark.
- EconomyShopGUI and EvenMoreFish run only on Main.
- BetterStructures currently runs only on Main with the load-verified five-Pack 278-Structure working set. FreeMinecraftModels 2.10.2 and ResourcePackManager 2.3.0 also run only on Main for the Prop／Java Pack preflight.

MVI, Frontier Multiverse-NetherPortals, any Frontier history／rollback product, Frontier ResourcePackManager／Pack, formal Network pack hosting, Iris, EliteMobs, Wayfarer_Core, Wayfarer_Main, and Wayfarer_Frontier are not installed by Ver.0.0.6. Main／Lobby CoreProtect is deferred and non-blocking while waiting for an upstream Minecraft 26.2-compatible Stable release; Frontier product selection remains undecided.

The approved [Frontier Runtime Lock](15-frontier-runtime-lock.md) statically fixes the
future Frontier Artifact, World ID, MVI, Gate, Pack-input and authority contracts. It
does not change the installed topology above.

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

The Final Main Baseline was replacement-generated on 2026-07-25 with seed `164225356311935743`, accepted through Order 5, and finalized without Config tuning in Order 6 after a verified stopped-state backup. Its exact identity and rollback evidence are authoritative in [Main World Baseline](13-main-world-baseline.md).

The five-Pack BetterStructures working set, Prop／FreeMinecraftModels integration, and Main ResourcePackManager are active in that baseline. The Resource family remains excluded and hash-preserved. Natural generation from four distinct Packs, all three dimensions, Portal routing, safe spawns, Pack delivery, Prop recovery after restart, and clean restart passed. Order 6 is complete; this remains distinct from the future V0.1.0 Release Baseline.

## Frontier target architecture

### MVI

Multiverse-Inventories is the authoritative owner of normal Frontier world-group Player State:

- `neutral`: `frontier_gate`;
- `worlds_beyond`: `frontier_iris` only;
- `guild`: Adventurer's Guild, Primis, the three Ruined Frontier dimensions, approved fixed Dungeons, and verified EliteMobs Instances.

Wayfarer_Frontier does not persist normal Inventory or reimplement MVI switching.

### Ruined Frontier

The alpha target uses BetterStructures and EliteMobs in its Overworld, Nether, and End, plus Adventurer's Guild, Primis, selected free Structure／Shrine／Dungeon Content, Resource Pack assets, and a BetterHealthBar3 adoption test. Order 8 statically locks the selected artifacts and World IDs; exact Structure selection, the deferred Guild Artifact, generated Config, Runtime compatibility and adoption tests remain implementation work.

### Worlds Beyond

The MVP target uses the single persistent Iris Overworld `frontier_iris` at PEACEFUL, a dedicated MVI group, Elytra, LeafGrapple, Traversal Loadout, Launchpads, Waystones, Discovery／Teleport GUIs, and a Frontier WM Shop. Worlds Beyond has no Nether／End World or MNP link; portal activation or travel must fail closed without fallback. Exact Engine／Pack／Seed／Border remains an implementation lock.

### EliteMobs Instances

Inventory integration selects the least complex safe method: static MVI registration, then strict approved-Blueprint Regex, then an Adapter only if necessary. A required Adapter is the independent Frontier Runtime Artifact `Wayfarer_Frontier_EliteMobsMVI`, limited to approved Instance detection, MVI Guild Group registration／removal, restart residue checks, audit, and reconcile. Instance naming, creation／deletion lifecycle, concurrency, restart, reconnect, and relevant APIs／Events must be verified first.

## Custom Plugin responsibility

Wayfarer_Core, Wayfarer_Main, and Wayfarer_Frontier are V0.1.0 Release Blockers but are not implemented.

Wayfarer_Core owns shared database, migration, Waymark adapter, transaction／idempotency, audit, identity, Redis coordination, message, and Permission-contract foundations.

Wayfarer_Main owns the Main-only Growth Pickaxe, including logical identity, owner bind, Resource-family progress, evolution, broken／repair state, pending delivery, audit, and reconcile.

Wayfarer_Frontier owns Worlds Beyond Loadout and item identity, Launchpads, Waystones and GUIs, Frontier WM Shop, inspection, and reconciliation. It does not embed the conditional Adapter or recreate MVI, Gate, EliteMobs, BetterStructures, or Iris functionality.

Their Source and Build projects belong in one external Gradle Multi-module Repository. This Repository stores only integration contracts, Version constraints, Config, procedures, Permission／API／Database contracts, acceptance tests, and release hashes.

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

Only Ruined Frontier keeps family-local Nether／End Portal links. Worlds Beyond routes only to `frontier_iris`; its Nether／End portals are denied with no fallback. Gate routes must preserve MVI switching, reject unintended family crossing, and use user-approved structures, coordinates, orientation, and safe arrivals.

## Persistence and recovery

Cold backup must include every authoritative Main／Frontier World, MVI profile, MariaDB database, stopped Redis AOF, custom-Plugin release artifact／Version／hash／Source Commit, migration history, custom-Plugin data, Growth Tool logical records and pending delivery／epoch／transaction state, Config, Content input, Resource Pack input／output, and Plugin／Project test reports required for recovery. Generated artifacts are rebuilt or captured according to the locked procedure. Restore verifies migrations before MVI, Worlds, custom data, Plugins, backends, and proxy, then runs reconcile before Player join. An isolated restore is a V0.1.0 blocker.

CoreProtect CE 24.0 rejected Minecraft 26.2 at Runtime. Main／Lobby installation is therefore deferred and temporarily excluded from the V0.1.0 blockers under Owner-only operation. Hub／Gate construction may proceed with the Final Main Baseline backup retained, focused before／after backup or ignored Schematic evidence, controlled edit units, and WorldGuard protection after construction. WorldGuard prevents unauthorized changes but provides neither history lookup nor point-in-time rollback; CoreProtect also never substitutes for cold backup. Re-evaluate CoreProtect before multi-player, multi-Builder, public, or large collaborative WorldEdit operation. The approved Order 8 Lock leaves the Frontier history／rollback product unselected; CoreProtect 24.0 remains only an Artifact candidate.

Detailed Frontier authority is in [Frontier V0.1.0 Scope](14-frontier-v0.1.0-scope.md), and implementation order is in the [Roadmap](09-roadmap.md).
