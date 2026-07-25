# Project Wayfarer Frontier V0.1.0 Runtime Lock

## 1. Status and authority

This document is the authoritative Order 8 Frontier Artifact／World／Runtime contract.

```text
Proposal:
  FRONTIER-LOCK-20260726-003

Approved:
  2026-07-26

Approval Token:
  APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-003

Order 8:
  complete

Runtime validation:
  deferred
```

Proposal 001 is superseded. Proposal 002 is `superseded-before-approval`; its Token was
never executed. Revision 003 replaced both proposals and is the only approved Lock.

The machine-readable sources of truth are:

- [`artifact-lock.yml`](../config/frontier-lock/artifact-lock.yml)
- [`world-id-lock.yml`](../config/frontier-lock/world-id-lock.yml)
- [`runtime-boundary-lock.yml`](../config/frontier-lock/runtime-boundary-lock.yml)
- [`resource-pack-input-lock.yml`](../config/frontier-lock/resource-pack-input-lock.yml)
- [`persistence-authority-lock.yml`](../config/frontier-lock/persistence-authority-lock.yml)

The [Phase A Preflight](investigations/2026-07-26-frontier-order8-lock-preflight.md)
preserves static evidence and Proposal history. Order 8 approval does not install a
Plugin, generate a World, configure MVI, connect a Gate, build a Resource Pack, create a
Database, grant a Permission, or make Frontier playable.

## 2. Current Runtime baseline

| Item | Locked baseline |
| --- | --- |
| Paper | `1.21.11 build 132` |
| Java | 25 |
| Velocity | `4.1.0` selected build |
| Bind | `127.0.0.2:25568` |
| Existing entry World | `frontier_gate` |
| Existing generated scope | `frontier_gate` only |
| Forwarding | Velocity modern forwarding |

Order 8 artifacts are not installed. Existing Frontier Plugin state remains the Runtime
source of truth until the relevant implementation Order succeeds.

## 3. Artifact Lock

All listed SHA-256 values were statically verified before approval. Compatibility status
is `runtime-unverified` unless a later Order records a focused Runtime result.

| Component | Decision | Version／Artifact | SHA-256 | Placement／scope | Deferred Runtime work |
| --- | --- | --- | --- | --- | --- |
| Multiverse-Inventories | Selected | 5.3.5／`multiverse-inventories-5.3.5.jar` | `27568B35AEA1042BAEA1FBC0D5256C17B51C596B8F2D166BE35BA1F77E6847A9` | Frontier／all approved Worlds | Order 12 |
| Multiverse-NetherPortals | Selected | 5.0.5／`multiverse-netherportals-5.0.5.jar` | `7D6364A2B474C2D3C4F8F8C5DCD469D9DE5A5F6F64C43DA39B648C3877AD077D` | Frontier／Ruined family only | Order 12 |
| Advanced Portals | Selected | 2.8.0／`advanced-portals-2.8.0-spigot.jar` | `ABD3E4BE48C1F34BC60530AAA344AB8BFFD4146281B8AD33FC83628C93E7287D` | Velocity and three Paper backends | Orders 12／17 |
| Iris | Selected | 3.9.2／`Iris-3.9.2-1.20.1-1.21.11.jar` | `46E3CD36B08EE6B24B6EC0ECC38379BEF82DADB861DDEBC10E0E338FDB7A7757` | Frontier／Worlds Beyond only | Order 15 |
| Iris Overworld Pack | Selected | version 4000 snapshot／`overworld-master.zip` | `0FA29D96D07B19EDBA3EFCA8E10DCEAAE24E94C7651C1ED888E54FA358144056` | `frontier_iris` only | Order 15 |
| LeafGrapple | Selected | 1.0.2／`LeafGrapple.jar` | `FFE4B3305BB48737E1B6C373698FEFE7121B879FD5B9399F930F5023B5F78833` | Worlds Beyond only | Order 15 |
| EliteMobs | Selected | 10.7.3／`EliteMobs.jar` | `688E93033A36F4168B2F69B8A65921FBB36AFFC047AA9534027724A2E5DA674E` | Guild／Ruined／Primis／approved Instances | Orders 13／14 |
| BetterStructures | Selected | 2.6.3／`BetterStructures.jar` | `AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038` | `frontier_bs*` only | Order 14 |
| FreeMinecraftModels | Selected | 2.10.2／`FreeMinecraftModels.jar` | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` | Frontier asset service | Order 12 |
| ResourcePackManager | Selected | 2.3.0／`ResourcePackManager.jar` | `240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64` | Frontier pack service | Order 12 |
| BetterHealthBar3 | Adoption candidate | 4.1.0／`BetterHealthBar-4.1.0.jar` | `BA78BDC0A293A8516155D6334437881C4E92D3C4F1D786AB38064EA5B032D5F6` | Ruined／Guild／Primis／approved Instances | Orders 12／14 smoke test |
| CoreProtect CE | Artifact candidate only | 24.0／`CoreProtect-CE-24.0.jar` | `66CD362089BB8430E5A018EE77E9B433BF0DC9E65590D5F1A043A78D60415696` | Not placed; history product unselected | Separate history task |

Official sources and licenses are locked in `artifact-lock.yml`. They are Modrinth or
official GitHub sources for free artifacts, and the official Spigot source plus
account-bound terms for BetterHealthBar3. Codex did not download any executable artifact.

### Content

| Content | Decision | Version／evidence | SHA-256 |
| --- | --- | --- | --- |
| BetterStructures Prop Pack | Selected, use terms must remain satisfied | User-owned current | `F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D` |
| Exploration Pack | Selected | 6 | `963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B` |
| Caves and Lost Civilizations Free | Selected | 2 | `27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677` |
| Adventure Pack | Selected, use terms must remain satisfied | internal 1 | `96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C` |
| Echoes of the Past | Selected, use terms must remain satisfied | 3 | `B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F` |
| Dungeoneering Modules Free | Selected | 2 | `5E946E4A1F1C000F4DD4258E35A5E147D71E32D88C772AEB5E61DCA7D2D709E3` |
| Free Elite Shrines | Selected | 9 | `5ABBC796272901199B3F368946FD49B20BDFCFF362104722FDEDA2AB2D7120E5` |
| Primis | Selected | meta 39／Adventure 20 | `46FDE1DD3A7FF2819FD6DFD0411764FC7B4E3EB997F332ABCADDDA09904E41AD` |
| Adventurer's Guild | Selected with approved deferral | Exact Artifact pending official `/em setup` flow | Pending |
| Full 103 Default Structures | Rejected for initial Frontier | Main already owns the full Pack | Not acquired |
| Iris Nether | Rejected | Upstream marks it unfinished | Not acquired |
| Iris End／The End alternatives | Rejected | Outside single-Overworld Scope | Existing ignored candidate remains unplaced |

Adventurer's Guild is the sole approved exact-Artifact exception. Order 12／13 may use the
official `/em setup` flow only to expose its official acquisition link. The User must
manually acquire and stage the original Artifact; Version, filename, license and SHA-256
must be locked before Runtime import. Any mismatch stops Guild integration and requires a
new Lock Revision.

## 4. World ID and lifecycle Lock

| Purpose | Bukkit World ID | Lifecycle | Generator | MVI Group |
| --- | --- | --- | --- | --- |
| Frontier Lobby | `frontier_gate` | Persistent／existing | VoidGen | `neutral` |
| Worlds Beyond | `frontier_iris` | Persistent | Iris Overworld | `worlds_beyond` |
| Adventurer's Guild | `adventurers_guild` | Persistent package-owned | EliteMobs package | `guild` |
| Ruined Overworld | `frontier_bs` | Persistent | Vanilla＋BetterStructures | `guild` |
| Ruined Nether | `frontier_bs_nether` | Persistent | Vanilla＋BetterStructures | `guild` |
| Ruined End | `frontier_bs_the_end` | Persistent | Vanilla＋BetterStructures | `guild` |
| Primis | `em_primis` | Persistent package-owned | EliteMobs package | `guild` |
| Primis Wormhole | `em_primis_wormhole` | Persistent package-owned | EliteMobs package | `guild` |

EliteMobs Instance IDs remain package-defined and may join `guild` only after Order 13
proves static membership, strict approved-Blueprint Regex, or the conditional Adapter.

Do not create or register `frontier_iris_nether` or `frontier_iris_the_end`. Legacy
directories excluded by `world-id-lock.yml` are not approved Worlds and must not be
renamed, deleted, or reused by inference.

## 5. MVI State Lock

The only approved groups are `neutral`, `worlds_beyond`, and `guild`.

Shared state inside each group is limited to:

```text
inventory_contents
off_hand
armor_contents
ender_chest
hit_points
max_hit_points
food_level
saturation
exhaustion
xp
lvl
total_xp
```

GameMode, Potion Effects, Bed Spawn, Location, Economy, Recipes, Advancements and
Statistics are not shared by the initial Lock. MVI is the sole Runtime authority for
normal Frontier Player State. Wayfarer_Frontier and MariaDB must not duplicate normal
Inventory or Profile switching.

Main is not an MVI profile. Main／Frontier Item and Vanilla Player State separation is a
Backend／Network boundary.

## 6. Portal and Gate Lock

Multiverse-NetherPortals 5.0.5 is approved only for:

```text
frontier_bs <-> frontier_bs_nether
frontier_bs <-> frontier_bs_the_end
```

Worlds Beyond has no Nether／End World and no MNP link. Nether／End Portal activation or
travel must fail closed without a Default, Ruined, Main, or unknown-World fallback.

Advanced Portals 2.8.0 is the selected Backend Gate method. The candidate uses its
`proxy:` route for Velocity switching; no Bungee message channel is required. Exact Gate
coordinates, shapes, safe destinations, cooldowns and final Player／Builder nodes remain
Order 17 work. Runtime enablement on Velocity, Lobby, Main and Frontier is Order 12
validation and must stop on any platform mismatch.

Cross-Theme Portal links, Main family links, `frontier_gate` Vanilla dimensions, direct
Theme bypass, and General Player Multiverse administrative teleport are forbidden.

## 7. Runtime boundary Lock

- Iris and LeafGrapple: `frontier_iris` only.
- BetterStructures: `frontier_bs`, `frontier_bs_nether`, `frontier_bs_the_end` only.
- EliteMobs: Guild, Ruined, Primis and explicitly approved Instance Worlds only.
- BetterHealthBar3: disabled by default outside its later adopted Ruined／Guild scope.
- FMM and RPM: backend asset／pack services without World or Gameplay authority.
- Unknown Worlds: fail closed.
- CoreProtect: absent until a separate product-selection and validation task.
- Wayfarer_Main: Main-only and forbidden on Frontier.

Exact third-party Config keys must come from generated Config of the locked Runtime
version. This conceptual matrix is not a Runtime Config template.

## 8. Resource Pack Lock

Main and Frontier use independent Java Packs. Frontier merge priority is:

```text
Wayfarer_Frontier
Wayfarer_Core
LeafGrapple
BetterHealthBar3
EliteMobs
FreeMinecraftModels
BetterStructures
ResourcePackManager
```

Inputs, namespaces and pending collisions are recorded in
`resource-pack-input-lock.yml`. Missing EliteMobs／LeafGrapple generated inputs prevent a
final collision verdict at Order 8; Order 12 must inspect CustomModelData／Item Model
Components, paths, Font, Shader, language, sound and `pack.mcmeta`.

ResourcePackManager on Frontier owns the build. Self-hosting remains disabled until a
separate network design. Temporary remote hosting is acceptance-only. The final ZIP,
URL, size, SHA-1 and SHA-256 are generated and recorded in Order 12. Pack refusal remains
optional／degraded during preflight until final delivery behavior is approved.

BetterHealthBar3 self-hosting and Port 8163 must remain disabled; its generated
Font／Shader input is merged into the Frontier Pack.

## 9. Persistence and backup Lock

`persistence-authority-lock.yml` is authoritative. Key boundaries are:

- MVI owns the three Frontier normal-state profiles.
- World files own blocks and entities.
- RedisEconomy／Redis AOF owns shared Waymark.
- MariaDB `wayfarer_mcmmo` owns shared mcMMO progression.
- EliteMobs owns its Content and package data.
- locked Iris artifacts plus World files own Worlds Beyond generation and persistence.
- ResourcePackManager output plus locked inputs own Frontier Pack reconstruction.
- future Wayfarer_Core／Main／Frontier MariaDB schemas own only their approved domains.
- Frontier history／rollback product remains unselected.

Redis is not an Inventory, Theme State, or Growth Pickaxe authority. A history product
never replaces World, MVI, Plugin-data, MariaDB, Redis AOF, Content or Resource Pack
cold backup.

## 10. Custom Plugin Lock

One external Gradle Multi-module Repository will contain the required sibling modules:

```text
Wayfarer_Core
Wayfarer_Main
Wayfarer_Frontier
```

Their versions and hashes are not invented before release. Wayfarer_Core is placed on
Main／Frontier, Wayfarer_Main only on Main, and Wayfarer_Frontier only on Frontier.

If and only if Order 13 returns `ADAPTER_REQUIRED`, add the independent Runtime Artifact
`Wayfarer_Frontier_EliteMobsMVI`. It may detect approved Instance Worlds, add／remove MVI
Guild membership, inspect restart residue, audit and reconcile. It must not own normal
Inventory, EliteMobs lifecycle, Gameplay, exit, Respawn or World deletion.

## 11. Permission Lock

Temporary Admin exclusively owns World lifecycle, MVI／MNP administration, Gate
create／edit／delete, EliteMobs and BetterStructures administration, Pack build／publish／
rollback, Iris administration, custom-Plugin migration／reconcile, Database, economy
administration, history／rollback and WorldGuard Region administration.

General Players receive only approved Gate traversal, Theme Gameplay and approved GUI.
Order 8 grants no Builder Permission. Exact Builder allowlists remain Orders 17／18 and
must not include Plugin internals, destructive lifecycle, unrestricted wildcard, OP,
Database, economy, Permission, Velocity, history／rollback or Region administration.

## 12. Deferred validation and known limitations

- All newly selected Plugin combinations remain Runtime-unverified.
- Adventurer's Guild exact Artifact is pending.
- Dynamic EliteMobs Instance naming and MVI registration require Order 13.
- BetterHealthBar3 final adoption requires Order 12／14 smoke testing.
- Resource Pack collisions and final hashes require generated inputs in Order 12.
- Gate component enablement and exact routing require Orders 12／17.
- Iris and the selected Overworld Pack require Order 15 generation and acceptance.
- Frontier history／rollback product is unselected.
- Premium／account-bound Content may be used only while the same Owner's terms permit it.

Any Artifact version／hash, World ID, Gate method, Pack input, MVI authority, Theme scope,
custom-Plugin boundary or approved exception change requires a new Lock Revision.

## 13. Implementation handoff

The locked execution order is:

```text
Order 9  Plugin Repository foundation + Wayfarer_Core
Order 10 Wayfarer_Main / Growth Pickaxe
Order 11 Wayfarer_Frontier
Order 12 Frontier shared foundation
Order 13 EliteMobs–MVI Adapter necessity decision
Order 14 Ruined Frontier alpha
Order 15 Worlds Beyond MVP
Order 16 Frontier two-Theme integration
Order 17 Final Gate and Permission lock
Order 18 Builder Phase 1B
```

Orders 19–26 remain controlled by the current Roadmap. No later Order may reinterpret
this Lock as Runtime acceptance.
