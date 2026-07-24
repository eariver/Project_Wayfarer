# Frontier V0.1.0 Scope

## 1. Authority and status

This document is the authoritative source of truth for Project Wayfarer's Frontier scope for `V0.1.0 Alpha`.

The following Concept documents are detailed design inputs, not current Runtime specifications or implementation instructions:

- [Frontier Server V0.0.4](../concepts/frontier/Frontier_Server_Specification_V0.0.4.md)
- [Worlds Beyond V0.0.4](../concepts/frontier/Worlds_Beyond_Specification_V0.0.4.md)
- [Ruined Frontier V0.0.4](../concepts/frontier/Ruined_Frontier_Specification_V0.0.4.md)

Every Plugin acquisition, custom-Plugin development, World operation, Permission change, Database Migration, Gate integration, and Runtime change requires a separately assigned Codex task. Nothing in this document marks those operations as implemented.

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
- Multiverse-NetherPortals;
- WorldEdit;
- WorldGuard;
- CoreProtect;
- ResourcePackManager and one Frontier integrated Resource Pack;
- approved Beyond and Guild Gate routes;
- Wayfarer_Core and Wayfarer_Frontier integration contracts.

The exact versions, JARs, licenses, hashes, placement, dependencies, World IDs, Gate implementation, and Runtime Config are locked only by dedicated implementation tasks. Current installed state is recorded separately in `versions.yml`, `plugin-manifest.yml`, and the Runtime.

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
| `worlds_beyond` | Worlds Beyond Overworld, Nether, and End |
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

Redis must not be the sole source of truth for Inventory or Gameplay persistence. Wayfarer_Core source, build files, and releases belong in a separate Repository. This Repository may store only its integration contracts, Version constraints, Config, installation and operational procedures, API／Database／Permission contracts, acceptance tests, and release-artifact hash.

## 7. Wayfarer_Frontier responsibilities

Wayfarer_Frontier is a required V0.1.0 external custom Plugin. Its minimum responsibilities are:

- Worlds Beyond Traversal Loadout;
- Worlds Beyond item identity and Theme-bound use;
- Launchpads;
- Waystones, Discovery GUI, and Teleport GUI;
- Frontier WM Shop;
- Admin, inspection, reconciliation, and audit adapters;
- EliteMobs–MVI Adapter only if the independent necessity review proves it is required;
- a foundation for later Ruined Frontier WM reward integration.

It does not reimplement normal Inventory persistence, normal World-change state switching, physical Gate transfer, EliteMobs behavior, BetterStructures generation, MVI profile handling, or the complete functionality of another adopted Plugin.

Its source and build project must be maintained in a separate Repository under separately approved design, creation, implementation, release, and integration tasks.

## 8. Ruined Frontier initial scope

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

## 9. Worlds Beyond initial scope

The V0.1.0 Worlds Beyond MVP includes:

- Frontier Lobby Beyond Gate;
- Iris Overworld, Nether, and End;
- `PEACEFUL` difficulty;
- a dedicated `worlds_beyond` MVI group and family-local Multiverse-NetherPortals links;
- Elytra and the Worlds Beyond Traversal Loadout;
- LeafGrapple adoption and integration;
- Launchpads;
- Frontier WM Shop;
- Waystones;
- Discovery and Teleport GUIs;
- persistent-World operation;
- integrated Resource Pack delivery.

The exact Iris Engine and Pack versions, Seed, World Border, Bukkit World IDs, LeafGrapple version, item contracts, and persistence procedures are locked by dedicated design and generation tasks.

## 10. EliteMobs–MVI decision procedure

The independent `EMアダプタの必要性判断` gate must select the least complex safe option in this order:

1. static MVI registration for fixed Worlds;
2. a strict Regex limited to approved Blueprint names and numbering;
3. an EliteMobs–MVI Adapter only when the first two options are proven insufficient.

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

## 11. Resource Pack distribution

ResourcePackManager is the planned distribution foundation for both Main and Frontier. Main and Frontier use separate Packs.

Before implementation, lock:

- ResourcePackManager version;
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

## 12. Portal and Gate boundary

The user determines Gate appearance, coordinates, orientation, and safe arrivals. A dedicated Gate task selects Advanced Portals or another approved implementation and locks exact Permissions.

Required Frontier routes include:

- Lobby／Main access to `frontier_gate` through the approved network routing;
- `frontier_gate` to Beyond Gate and safe return;
- `frontier_gate` to Guild Gate and safe return;
- family-local Portal links inside Worlds Beyond;
- family-local Portal links inside Ruined Frontier;
- safe routing to Adventurer's Guild, Primis, and approved content entry points.

Portal families must not cross accidentally, bypass MVI separation, or allow direct general-player administrative teleport shortcuts.

## 13. Permission boundary

Normal administration remains OP-independent and uses temporary `wayfarer_admin` membership.

The following are Admin-only:

- MVI group and profile administration;
- ResourcePackManager build, publish, reload, rollback, and internal administration;
- Wayfarer_Core／Wayfarer_Frontier administration, inspection, and reconciliation;
- EliteMobs internal administration and teleport shortcuts;
- Database, economy-administration, and destructive World operations.

General Players do not receive Multiverse teleport or EliteMobs administrative shortcuts. Builder Phase 1B uses an explicit allowlist only after Ruined Frontier, Worlds Beyond, Multiverse-Inventories, ResourcePackManager, EliteMobs, Wayfarer_Core, Wayfarer_Frontier, the adopted Gate／Portal implementation, and the exact Builder-owned Hub／Gate／Theme connection work are known. It does not grant MVI group administration, Resource Pack administration, EliteMobs internals, Database or economy administration, custom-Plugin administration, unrestricted wildcards, or OP.

Exact Permission nodes are not asserted before the selected Plugin versions are verified.

## 14. Persistence and destructive operations

Worlds Beyond and Ruined Frontier Worlds are persistent unless an approved design explicitly identifies an EliteMobs Instance as lifecycle-managed content. Inventory, World, custom-Plugin database, audit, and Content data must be included in the V0.1.0 backup and restore design according to their authoritative owner.

World generation, regeneration, deletion, trimming, Instance cleanup, Database Migration, and Player State reset are separate risk-focused tasks. They require exact paths, backups, explicit scope, normal shutdown, and focused restore or rollback verification.

## 15. Release blockers

Frontier V0.1.0 blockers are:

- shared Frontier Plugin and World foundation;
- MVI and the `neutral`, `worlds_beyond`, and `guild` groups;
- ResourcePackManager and the Frontier integrated Pack;
- Wayfarer_Core and Wayfarer_Frontier;
- the EliteMobs–MVI Adapter necessity decision;
- Ruined Frontier alpha;
- Worlds Beyond MVP;
- MVI separation between both Themes and Frontier Lobby;
- complete Main／Frontier item separation;
- both Portal families and both safe Frontier Lobby returns;
- Main／Frontier Resource Pack switching;
- confirmed Frontier cold-backup and isolated-restore scope;
- integrated restart, disconnect／reconnect, and routing acceptance.

## 16. Deferred items

The following remain outside the minimum initial scope unless a later formal revision promotes them:

- additional Frontier Themes;
- premium or optional Content beyond the approved alpha／MVP sets;
- Ruined Frontier WM reward balancing and rollout;
- item-based cross-backend rewards or transport;
- broad cross-server shops;
- an EliteMobs–MVI Adapter when static registration or strict Regex is sufficient;
- replacement of MVI with custom Inventory persistence.

## 17. Acceptance summary

Planned acceptance must demonstrate:

- exact Version／Artifact／World ID／Gate／Pack locks;
- healthy startup and dependency loading;
- safe entry, return, Portal-family routing, restart, and reconnect;
- correct MVI state switching without duplication, loss, or stale overwrite;
- no Main／Frontier or cross-group item leakage;
- shared Waymark and mcMMO without converting them into item transport;
- representative Ruined Frontier and Worlds Beyond gameplay;
- correct Resource Pack delivery and backend switching;
- Permission denial for unapproved shortcuts and administration;
- backup and isolated restore of every authoritative Frontier data owner.

The detailed planned checklists are maintained in [Acceptance Tests](06-acceptance-tests.md) and ordered by the [Roadmap](09-roadmap.md).
