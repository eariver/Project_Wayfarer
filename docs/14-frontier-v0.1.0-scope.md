# Frontier V0.1.0 Scope

## 1. Authority and status

This document is the authoritative source of truth for Project Wayfarer's Frontier scope for `V0.1.0 Alpha`.

The following Concept documents are detailed design inputs, not current Runtime specifications or implementation instructions:

- [Frontier Server V0.0.5](../concepts/frontier/Frontier_Server_Specification_V0.0.5.md)
- [Worlds Beyond V0.0.6](../concepts/frontier/Worlds_Beyond_Specification_V0.0.6.md)
- [Ruined Frontier V0.0.5](../concepts/frontier/Ruined_Frontier_Specification_V0.0.5.md)
- [Plugin Concept V0.0.3](../concepts/plugins/Project_Wayfarer_Plugin_Concept_v0.0.3.md)
- [Worlds Beyond Plugin V0.0.4](../concepts/plugins/frontier/Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.4.md)
- [Ruined Frontier Integration Decision V0.0.2](../concepts/plugins/frontier/Project_Wayfarer_Ruined_Frontier_Integration_Decision_Concept_v0.0.2.md)

Every Plugin acquisition, custom-Plugin development, World operation, Permission change, Database Migration, Gate integration, and Runtime change requires a separately assigned Codex task. Nothing in this document marks those operations as implemented.

Order 8 Artifact／World／Runtime boundaries are formally locked by
[Frontier Runtime Lock](15-frontier-runtime-lock.md) under Proposal
`FRONTIER-LOCK-20260726-003`. The Lock is static approval, not Runtime installation or acceptance.

## 2. V0.1.0 completion condition

`V0.1.0 Alpha` requires both of the following playable Frontier Themes:

- Ruined Frontier alpha;
- Worlds Beyond MVP.

The earlier one-Theme completion policy is retired. Frontier remains a Release Blocker until both Themes, the shared foundation, their isolation boundaries, safe entry and return routes, persistence, and integrated acceptance tests pass.

A World Generator, Content Import, or Plugin Enable by itself is not a playable-Theme completion condition.

## 3. Shared Frontier foundation

The planned Frontier foundation consists of:

- the existing Frontier Paper 1.21.11／Java 25 backend and protected `frontier_gate`;
- Multiverse-Core;
- Multiverse-Inventories;
- Multiverse-NetherPortals for the Ruined Frontier family only;
- WorldEdit;
- WorldGuard;
- a history／rollback product selected by a later dedicated task; Order 8 keeps it unselected and retains CoreProtect 24.0 only as an Artifact candidate;
- ResourcePackManager and one Frontier integrated Resource Pack;
- approved Beyond and Guild Gate routes;
- Wayfarer_Core, Wayfarer_Main, and Wayfarer_Frontier integration contracts from one external Gradle Multi-module Repository;
- the conditional independent `Wayfarer_Frontier_EliteMobsMVI` Artifact only if the formal decision is `ADAPTER_REQUIRED`.

Order 8 locks selected versions, artifacts, licenses, hashes, placement, dependencies, World IDs, Gate method, Pack inputs and authority boundaries. Exact generated Config, Runtime acceptance, final Gate coordinates, Pack output and any history／rollback product still require their assigned implementation tasks. Current installed state is recorded separately in `versions.yml`, `plugin-manifest.yml`, and the Runtime.

## 4. Player State and inventory boundary

Multiverse-Inventories (MVI) is the Runtime source of truth for Frontier world-group Player State.

MVI owns:

- Inventory;
- Armor;
- Offhand;
- Ender Chest;
- Vanilla XP and Level;
- Health;
- Food and Saturation;
- any additional Player State explicitly approved for the selected MVI version.

The initial groups are:

| Group | Conceptual world membership |
| --- | --- |
| `neutral` | `frontier_gate` |
| `worlds_beyond` | `frontier_iris` only |
| `guild` | Adventurer's Guild, Primis, Ruined Frontier Overworld／Nether／End, approved fixed Dungeons, and verified EliteMobs Instances |

Exact Bukkit World names are locked before implementation. MVI Config, not a custom database, is authoritative for group membership and normal state switching.

Wayfarer_Frontier must not store normal Inventory in MariaDB, recreate MVI profile save/restore, or comprehensively intercept normal World change, Portal, Respawn, Gate, or administrative teleport events to perform a second state switch.

## 5. Cross-backend data boundary

Main and Frontier never share or transfer items, including Vanilla items.

The non-transfer boundary includes:

- Inventory, Armor, and Offhand;
- Ender Chest;
- Vanilla and Custom items;
- EliteMobs loot and Quest items;
- Theme equipment and materials;
- Vanilla XP and Level;
- Health, Food, and Saturation.

Main, Frontier Lobby, Worlds Beyond, and Ruined Frontier hold isolated Player State through their backend or MVI group. No achievement or reward path may become an implicit item-transfer mechanism.

Network-shared outcomes are limited to:

- Waymark;
- mcMMO progression;
- separately approved item-independent achievements;
- separately approved item-independent rewards such as titles, Permissions, GUI or ranking displays, achievement records, cosmetic unlocks, Waymark, and non-item feature unlocks.

## 6. Wayfarer_Core responsibilities

Wayfarer_Core is a required V0.1.0 external custom Plugin. Its minimum responsibilities are:

- MariaDB connection and Schema Migration foundations;
- Waymark Service Adapter through the supported economy boundary;
- Transaction IDs and idempotency;
- shared audit records;
- Player identity;
- shared custom-item identity foundation;
- Redis Cache, Lock, and Pub/Sub connection foundations;
- cross-server messaging;
- Permission contracts.

Redis must not be the sole source of truth for Inventory or Gameplay persistence. Custom Plugin source, build files, and releases belong in one external Gradle Multi-module Repository. This Repository may store only its integration contracts, Version constraints, Config, installation and operational procedures, API／Database／Permission contracts, acceptance tests, and release-artifact hash.

## 7. Wayfarer_Main responsibilities

Wayfarer_Main is a required V0.1.0 external custom Plugin installed only on Main.
Its initial Release scope is the Growth Pickaxe:

- one logical Tool per Player with Owner bind;
- Main Resource-family progress only in `resource`, `resource_nether`, and `resource_end`;
- no progress in `main`, `main_nether`, `main_the_end`, or unknown Worlds;
- Wood → Stone → Iron → Diamond material evolution;
- Efficiency, Unbreaking, Fortune, and Admin Fortune／Silk Touch control;
- cumulative-progress-based complete Config recalculation;
- ACTIVE／BROKEN state and Waymark Full Repair;
- initial async delivery, Pending Delivery, Admin reissue, audit, and reconcile;
- MariaDB authoritative logical identity, epoch, progress, state, and transaction data.

It does not prohibit ordinary Vanilla tools and must not transfer Growth Tool items to
Frontier. Axe, Shovel, Player-facing WM Fortune／Silk Touch switching, Player Netherite
Upgrade, Ranking, Evolution Rewards, Abilities, Cosmetics, and cross-server transfer are
outside the initial V0.1.0 scope.

## 8. Wayfarer_Frontier responsibilities

Wayfarer_Frontier is a required V0.1.0 external custom Plugin. Its minimum responsibilities are:

- Worlds Beyond Traversal Loadout;
- Worlds Beyond item identity and Theme-bound use;
- Launchpads;
- Waystones, Discovery GUI, and Teleport GUI;
- Frontier WM Shop;
- Admin, inspection, reconciliation, and audit adapters;
- a foundation for later Ruined Frontier WM reward integration.

It does not reimplement normal Inventory persistence, normal World-change state switching, physical Gate transfer, EliteMobs behavior, BetterStructures generation, MVI profile handling, or the complete functionality of another adopted Plugin.

An EliteMobs–MVI Adapter is not a permanent internal Module. If the independent necessity
review returns `ADAPTER_REQUIRED`, add the independent Frontier Runtime Artifact
`Wayfarer_Frontier_EliteMobsMVI`. Its only responsibilities are approved Instance World
detection, MVI Guild Group registration／removal, restart residue inspection, audit, and
reconcile. It must not own normal Inventory, EliteMobs lifecycle, Gameplay, exit, Respawn,
or World deletion.

## 9. Ruined Frontier initial scope

The V0.1.0 Ruined Frontier alpha includes:

- Frontier Lobby Guild Gate;
- Adventurer's Guild;
- Primis;
- Ruined Frontier Overworld, Nether, and End;
- the shared Frontier foundation;
- BetterStructures and EliteMobs in all three Ruined Frontier dimensions;
- FreeMinecraftModels and ResourcePackManager;
- a BetterHealthBar3 adoption test;
- `Exploration Pack`, `Caves and Lost Civilizations Free`, `Echoes of the Past`, and `Adventure Pack`;
- BetterStructures Prop Pack;
- Free Elite Shrines and Dungeoneering Modules Free.

The full `103 Default Structures` pack is disabled in Ruined Frontier by default. Main already provides that Content, and enabling the whole pack would dilute Ruined Frontier's high-difficulty, large-Structure, and EliteMobs-integrated selection. A later design may adopt individual Structures such as a Waypoint or Graveyard only through a separate formal decision and assigned task; this initial scope is not a five-Pack.

The initial conceptual World IDs are:

```text
frontier_bs
frontier_bs_nether
frontier_bs_the_end
```

Exact World IDs remain a pre-implementation lock. Acceptance must cover representative BetterStructures generation, EliteMobs Sign integration, Shrines, Boss and Loot behavior, Primis and Guild routing, World／MVI isolation, safe return, Resource Pack assets, and prevention of item leakage.

## 10. Worlds Beyond initial scope

The V0.1.0 Worlds Beyond MVP includes:

- Frontier Lobby Beyond Gate;
- Iris Overworld `frontier_iris` only;
- `PEACEFUL` difficulty;
- a dedicated `worlds_beyond` MVI group containing only `frontier_iris`;
- Elytra and the Worlds Beyond Traversal Loadout;
- LeafGrapple adoption and integration;
- Launchpads;
- Frontier WM Shop;
- Waystones;
- Discovery and Teleport GUIs;
- persistent-World operation;
- integrated Resource Pack delivery.

Do not create or register `frontier_iris_nether` or `frontier_iris_the_end`. Worlds Beyond
has no MNP link, and Nether／End Portal activation or travel must be denied without a
Default, Ruined, Main, or unknown-World fallback.

The exact Iris Engine and Overworld Pack versions, Seed, World Border, LeafGrapple version, item contracts, and persistence procedures are locked by dedicated design and generation tasks.

## 11. EliteMobs–MVI decision procedure

The independent `EMアダプタの必要性判断` gate must select the least complex safe option in this order:

1. static MVI registration for fixed Worlds;
2. a strict Regex limited to approved Blueprint names and numbering;
3. the independent `Wayfarer_Frontier_EliteMobsMVI` Artifact only when the first two options are proven insufficient.

The review must lock or verify:

- EliteMobs version and Content packages;
- fixed, cloned, and temporary World behavior;
- approved Blueprint names and Instance naming;
- MVI static registration and Regex capabilities;
- simultaneous Instances;
- Instance completion, deletion, restart, disconnect, and reconnect;
- behavior after World deletion;
- MVI API;
- EliteMobs creation and deletion Events;
- whether safe operation is possible without an Adapter.

No Adapter is developed merely because it appears in a Concept.

## 12. Resource Pack distribution

ResourcePackManager 2.3.0 is the load-verified Main preflight foundation. Frontier still requires a separate installation and Pack. Main and Frontier use separate Packs.

Before Frontier implementation and final Network acceptance, lock:

- Frontier ResourcePackManager version and compatibility with the Main 2.3.0 lock;
- Main and Frontier Pack composition;
- generation and Hosting methods;
- Hosting URL and Pack hash;
- Minecraft's required hash format;
- mandatory／optional policy and Client-refusal behavior;
- download-failure behavior;
- Main／Frontier switching and backend-reconnect reload behavior;
- FreeMinecraftModels output;
- BetterStructures Prop, EliteMobs, BetterHealthBar, and adopted LeafGrapple assets;
- CustomModelData／Item Model Component, Model ID, Shader, and Font conflicts;
- Pack size, download time, cache update, and rollback.

Generated Packs, Models, and Content artifacts remain Git-ignored. The Repository tracks only approved Config, contracts, hashes, and procedures.

## 13. Portal and Gate boundary

The user determines Gate appearance, coordinates, orientation, and safe arrivals. A dedicated Gate task selects Advanced Portals or another approved implementation and locks exact Permissions.

Required Frontier routes include:

- Lobby／Main access to `frontier_gate` through the approved network routing;
- `frontier_gate` to Beyond Gate and safe return;
- `frontier_gate` to Guild Gate and safe return;
- family-local Portal links inside Ruined Frontier;
- denial of Worlds Beyond Nether／End Portal activation and travel without fallback;
- safe routing to Adventurer's Guild, Primis, and approved content entry points.

Portal families must not cross accidentally, bypass MVI separation, or allow direct general-player administrative teleport shortcuts.

## 14. Permission boundary

Normal administration remains OP-independent and uses temporary `wayfarer_admin` membership.

The following are Admin-only:

- MVI group and profile administration;
- ResourcePackManager build, publish, reload, rollback, and internal administration;
- Wayfarer_Core／Main／Frontier and any conditional Adapter administration, inspection, delivery, migration, and reconciliation;
- EliteMobs internal administration and teleport shortcuts;
- Database, economy-administration, and destructive World operations.

General Players do not receive Multiverse teleport or EliteMobs administrative shortcuts. Builder Phase 1B uses an explicit allowlist only after Ruined Frontier, Worlds Beyond, Multiverse-Inventories, ResourcePackManager, EliteMobs, Wayfarer_Core, Wayfarer_Main, Wayfarer_Frontier, any conditional Adapter, the adopted Gate／Portal implementation, and the exact Builder-owned Hub／Gate／Theme connection work are known. It does not grant MVI group administration, Resource Pack administration, EliteMobs internals, Database or economy administration, custom-Plugin administration, unrestricted wildcards, or OP.

Exact Permission nodes are not asserted before the selected Plugin versions are verified.

## 15. Persistence and destructive operations

Worlds Beyond and Ruined Frontier Worlds are persistent unless an approved design explicitly identifies an EliteMobs Instance as lifecycle-managed content. Inventory, World, custom-Plugin database, audit, and Content data must be included in the V0.1.0 backup and restore design according to their authoritative owner.

World generation, regeneration, deletion, trimming, Instance cleanup, Database Migration, and Player State reset are separate risk-focused tasks. They require exact paths, backups, explicit scope, normal shutdown, and focused restore or rollback verification.

## 16. Release blockers

Frontier V0.1.0 blockers are:

- shared Frontier Plugin and World foundation;
- MVI and the `neutral`, `worlds_beyond`, and `guild` groups;
- ResourcePackManager and the Frontier integrated Pack;
- one external Gradle Multi-module Repository and Wayfarer_Core／Main／Frontier;
- Main-only Growth Pickaxe and its detailed acceptance／backup boundary;
- the EliteMobs–MVI Adapter necessity decision;
- Ruined Frontier alpha;
- Worlds Beyond MVP;
- MVI separation between both Themes and Frontier Lobby;
- complete Main／Frontier item separation;
- the Ruined Frontier Portal family, denied Worlds Beyond Nether／End portals, and both safe Frontier Lobby returns;
- Main／Frontier Resource Pack switching;
- confirmed Frontier cold-backup and isolated-restore scope;
- integrated restart, disconnect／reconnect, and routing acceptance.

## 17. Deferred items

The following remain outside the minimum initial scope unless a later formal revision promotes them:

- additional Frontier Themes;
- premium or optional Content beyond the approved alpha／MVP sets;
- Ruined Frontier WM reward balancing and rollout;
- item-based cross-backend rewards or transport;
- broad cross-server shops;
- an EliteMobs–MVI Adapter when static registration or strict Regex is sufficient;
- replacement of MVI with custom Inventory persistence.

## 18. Acceptance summary

Planned acceptance must demonstrate:

- exact Version／Artifact／World ID／Gate／Pack locks;
- healthy startup and dependency loading;
- safe entry, return, Ruined Portal-family routing, Worlds Beyond portal denial, restart, and reconnect;
- correct MVI state switching without duplication, loss, or stale overwrite;
- no Main／Frontier or cross-group item leakage;
- shared Waymark and mcMMO without converting them into item transport;
- representative Ruined Frontier and Worlds Beyond gameplay;
- correct Resource Pack delivery and backend switching;
- Permission denial for unapproved shortcuts and administration;
- backup and isolated restore of every authoritative Frontier data owner.

The detailed planned checklists are maintained in [Acceptance Tests](06-acceptance-tests.md) and ordered by the [Roadmap](09-roadmap.md).
