# Permission Model - Ver.0.0.5

This document is the source of truth for the Project Wayfarer LuckPerms permission model. Phase 1A was implemented and verified on 2026-07-20. Phase 1B, the final Builder allowlist, remains a V0.1.0 Release Blocker.

## 1. Phase boundary

Phase 1A is implemented:

- five persistent Group definitions;
- self-only temporary Role elevation through Velocity LuckPerms;
- separate Builder and Admin Eligibility;
- global Admin full access;
- OP-independent administration;
- reuse of the existing `wayfarer_builder` Group and WorldGuard Region membership;
- removal of the former Builder WorldEdit／WorldGuard administration wildcards.

Phase 1B is not implemented:

- Builder WorldEdit commands;
- gamemode and teleport commands;
- Multiverse-Core and Main-only Multiverse-NetherPortals commands;
- Advanced Portals commands;
- Frontier Theme-specific administration.

Phase 1B starts before Builder-led Hub／Gate／Theme connection work, after the adopted Advanced Portals permissions, playable Frontier Theme, and exact Builder work are known. It must use a command-focused allowlist and must not restore broad wildcards.

## 2. Persistent Groups and temporary membership

| Group | Definition | Player membership | Current authority |
|---|---|---|---|
| `default` | Persistent | Normal persistent membership | Normal gameplay, six EconomyShopGUI category nodes, and `emf.shop` in Main Context |
| `wayfarer_builder_eligible` | Persistent | Persistent Eligibility | `default` plus self-only temporary Builder add/remove through Velocity |
| `wayfarer_admin_eligible` | Persistent | Persistent Eligibility | `default` plus self-only temporary Admin add/remove through Velocity |
| `wayfarer_builder` | Persistent Role container | Temporary Parent only | `default`; protected-entry building through existing WorldGuard membership |
| `wayfarer_admin` | Persistent Role | Temporary Parent only | Global full access |

`default` and `wayfarer_builder` were reused without deletion or recreation. The three missing Groups were created only after the pre-change audit. Role Groups are not Primary Groups, and Players must not receive permanent `wayfarer_builder` or `wayfarer_admin` Parent membership.

The operational standard duration is 2 hours for Builder and 30 minutes for Admin. LuckPerms does not technically fix either duration. Remove one temporary Role before adding the other.

## 3. LuckPerms Runtime policy

All four LuckPerms 5.5.60 instances use shared MariaDB storage and SQL messaging. Their unique server Contexts are `velocity`, `lobby`, `main`, and `frontier`.

All instances set:

```yaml
argument-based-command-permissions: true
```

All Paper instances additionally set:

```yaml
enable-ops: false
auto-op: false
commands-allow-op: false
```

Velocity does not receive Bukkit OP settings. Runtime Configs remain ignored and are rendered from the tracked sanitized templates. Normal administration depends on temporary Admin membership, not OP.

## 4. Eligibility permission nodes

Eligibility commands are exposed only through Velocity's `/lpv` alias. Every node below is granted with `server=velocity`; no corresponding Paper `/lp` permission is granted.

Common nodes:

```text
luckperms.user.parent.info
luckperms.user.parent.info.view.self
luckperms.user.parent.addtemp
luckperms.user.parent.addtemp.modify.self
luckperms.user.parent.addtemp.usecontext.global
luckperms.user.parent.removetemp
luckperms.user.parent.removetemp.modify.self
luckperms.user.parent.removetemp.usecontext.global
```

Builder Eligibility adds only:

```text
luckperms.user.parent.addtemp.wayfarer_builder
luckperms.user.parent.removetemp.wayfarer_builder
```

Admin Eligibility adds only:

```text
luckperms.user.parent.addtemp.wayfarer_admin
luckperms.user.parent.removetemp.wayfarer_admin
```

These nodes were derived from LuckPerms 5.5.60 command behavior and argument permission checks, then verified against Runtime denial and success cases. Eligibility does not grant permanent Parent changes, other-player modification, arbitrary Groups, permission mutation, Group creation/deletion, Editor access, import/export, or Paper-side LuckPerms management. No broad wildcard or unnecessary explicit deny is used.

## 5. Elevation and demotion

Use the Player's exact current name in place of `<player>`.

```text
/lpv user <player> parent addtemp wayfarer_builder 2h deny
/lpv user <player> parent removetemp wayfarer_builder

/lpv user <player> parent addtemp wayfarer_admin 30m deny
/lpv user <player> parent removetemp wayfarer_admin
```

The `deny` temporary merge strategy prevents an existing matching temporary Parent from being silently extended or combined by the same command. It does not fix the duration.

After Builder work, return to Survival, move to a safe position when necessary, remove the temporary Builder Parent, and verify that Builder permissions are gone. Natural expiry does not reset gamemode. Admin authority ends immediately when its temporary Parent is removed or expires.

## 6. Builder Role container

Phase 1A intentionally leaves `wayfarer_builder` with only `group.default`. The old `worldedit.*` and `worldguard.*` permissions in Lobby／Frontier Contexts were removed.

The Group remains the sole WorldGuard member of the Lobby and `frontier_gate` `__global__` Regions. This membership permits ordinary block placement and breaking while the temporary Builder Parent is active; it does not grant WorldGuard administration. The one-block acceptance test confirmed building during membership, restoration of the test block, and denial after membership removal.

Until Phase 1B, Builder has no WorldEdit, WorldGuard administration, Multiverse, gamemode, teleport, Velocity, LuckPerms, economy, player-punishment, server-stop, reload/debug/internal, destructive World lifecycle, or wildcard authority.

## 7. Admin full access and specific permissions

`wayfarer_admin` receives global `* = true` and inherits `default`. The Runtime verified representative Velocity, Paper, Vanilla, LuckPerms, WorldGuard, Multiverse, and EconomyShopGUI permissions without OP.

The former `default` EconomyShopGUI administration `false` nodes were removed. Normal-player denial remains fail-closed because those administration nodes are not granted. The six approved EconomyShopGUI nodes and `emf.shop` remain explicitly true for `default` in `server=main`. `emf.sellall`, `emf.admin`, economy administration, and debug authority are not granted globally or in another backend Context.

The following Main-context Admin nodes remain explicitly true in addition to the global wildcard, preventing Plugin-specific resolution from weakening Admin full access:

```text
economyshopgui.eshop.*
economyshopgui.itemindexes
economyshopgui.notifyupdate
economyshopgui.reload
economyshopgui.sellall
economyshopgui.sellallhand
economyshopgui.sellallitem
economyshopgui.sellgui
economyshopgui.shopgive
```

EconomyShopGUI's bare `/eshop` root requires a subcommand. Its “unknown or incomplete command” response is not a permission denial; `economyshopgui.reload` and the editor child permission resolved true during the Admin test. Do not execute reload or destructive administration commands merely to prove access.

## 8. Eligibility assignment and recovery

Eligibility is a persistent trust decision. Assign it only to a user-approved Player from a trusted Velocity Console or an already active Admin session:

```text
lpv user <player> parent add wayfarer_builder_eligible
lpv user <player> parent add wayfarer_admin_eligible
```

Do not guess recipients, store Player names／UUIDs in this repository, or make either Role Parent permanent.

The Server Console is exceptional bootstrap and recovery access, not the normal administration UI. For a permission lockout:

1. retain Console／process access;
2. inspect the Player's Parents and the five Group definitions;
3. repair with official LuckPerms commands;
4. verify self-elevation and immediate demotion;
5. confirm all Paper `ops.json` files remain empty.

Do not repair LuckPerms with direct SQL `UPDATE`／`DELETE`. The pre-change MariaDB dump is ignored backup material. For a broad erroneous change or database damage, stop the network normally and evaluate an isolated restore from that dump; do not replace-import a LuckPerms Web Editor export into the live database.

## 9. Verified Phase 1A boundary

The focused acceptance test confirmed:

- five persistent Groups and unchanged Primary Group behavior;
- matching self-only temporary Admin elevation;
- denial of permanent Parent, wrong Role, arbitrary Group, other Player, permission mutation, Group administration, and Editor access;
- global Admin authority and immediate loss after removal;
- natural temporary expiry with no residual Parent;
- Builder protected-entry building only, with management commands denied;
- Builder building loss immediately after removal;
- no permanent Role Parent and no OP on any Paper backend;
- persistence of Eligibility and all Group definitions after a clean network restart;
- successful post-restart self-elevation, cross-instance propagation, and demotion;
- retained Lobby／Frontier WorldGuard Group membership;
- no LuckPerms startup ERROR, SEVERE, or Exception.

Test Players, UUIDs, temporary records, test Groups, and test permission nodes are not retained in Git. The approved persistent Eligibility remains only in the shared Runtime database.

## 10. Phase 1B constraints

Phase 1B remains incomplete and blocks V0.1.0. It must:

- derive exact permissions from the adopted Plugin versions and actual Builder work;
- scope WorldEdit, gamemode, teleport, and Multiverse-Core to the required Paper backends;
- scope Multiverse-NetherPortals to Main only;
- decide Advanced Portals and Frontier Theme administration separately;
- keep WorldGuard Region administration, Velocity, LuckPerms, economy, player punishment, server stop, reload/debug/internal operations, destructive World lifecycle commands, and unrestricted wildcards excluded;
- repeat only the affected Builder security-boundary tests.

BetterStructures Phase 2 is complete without changing Builder permissions. Phase 1B remains scheduled before Builder-led Hub／Gate／Theme connection work and does not block a future separately approved destructive Phase 3 Main generation task.
