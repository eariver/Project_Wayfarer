# Acceptance Tests - Ver.0.0.4

## 1. Verification policy

### Ordinary officially distributed Plugins

An ordinary Plugin integration is complete when the task confirms:

1. exact Version and Platform;
2. official distribution source;
3. intended placement;
4. required dependencies;
5. successful Enable on the target Runtime;
6. loading of the main Project Wayfarer-created or modified Config;
7. one representative adopted Command or one GUI open;
8. no obvious startup-blocking ERROR, SEVERE, or Exception;
9. Git exclusion of JARs, Secrets, Worlds, Database Data, Logs, Caches, and other Runtime artifacts.

Do not routinely require all Commands, all Config keys, all feature combinations, inventory-full/reconnect/double-processing edge cases, Plugin-author internal quality assurance, unrelated existing-Plugin regression, or broad Network regression. Historical tasks may have performed more checks; those results remain evidence, not the standard for future ordinary integrations.

### Detailed risk-focused work

Use proportionate detailed verification only for Local Build, source-modified/compatibility-patched, or Project-owned Plugins; an observed defect; World lifecycle; Database Migration; shared Economy/Progression foundation; Inventory synchronization or cross-server item movement; Permission/Secret/connection/Security Boundary; Protocol conversion; Portal/Dimension Routing; Backup/Restore; Failover; destructive/irreversible work; or explicit user instruction.

Regression testing is limited to a foundation directly modified by the change. Examples are ViaVersion client access, LuckPerms role boundaries, RedisEconomy shared balances, mcMMO shared progression, changed Advanced Portals routes, and changed backup stop/save/restore behavior.

## 2. Verified baselines

- [x] Velocity Modern Forwarding, local-only Paper binding, Lobby initial route/failover, and ViaVersion Frontier access have verified implementation records.
- [x] LuckPerms uses shared MariaDB and SQL messaging across Velocity and all Paper backends.
- [x] Lobby and Frontier Gate have protected Void entry-world safety baselines.
- [x] WorldEdit/WorldGuard, TAB proxy installation, Multiverse world registration, and Main dimension-family links have verified baselines.
- [x] mcMMO shared Main/Frontier progression and RedisEconomy shared Waymark balances have verified persistence tests.
- [x] EconomyShopGUI 7.1.1 Free provides the verified Main-only fixed-price shop.

These items describe current baselines only. They do not mark the Ver.0.0.4 permission model, Hubs, Gates, Frontier Theme, integrated operations, or V0.1.0 Backup as implemented.

## 3. V0.1.0 Release Blockers

### Permission model

- [ ] `default`, `wayfarer_builder_eligible`, `wayfarer_admin_eligible`, temporary `wayfarer_builder`, and temporary `wayfarer_admin` are implemented without name conflicts.
- [ ] Each Eligibility group can affect only itself and its matching temporary Role; permanent parents, other players, arbitrary groups, and arbitrary permissions are denied.
- [ ] Builder Allowlist covers only approved world-work functions in appropriate Paper Contexts; prohibited administration areas and Velocity management remain denied.
- [ ] Full Minecraft/Plugin authority exists only while the temporary Admin parent is active.
- [ ] Builder and Admin grant/removal, expiry, self-demotion, and Builder Survival cleanup are documented and minimally verified.

### Main and gameplay

- [ ] BetterStructures is enabled only in `main`, `main_nether`, and `main_end`, and one representative Resource dimension remains excluded.
- [ ] Final persistent Main generation completes under an approved destructive task with exact paths, backups, and safe Spawn.
- [ ] EvenMoreFish enables with its adopted Config and one representative function; configuration has no explicit mcMMO Fishing conflict.
- [ ] CoreProtect enables after final Main generation and provides its representative lookup/rollback-administration function.

### Frontier and Hubs

- [ ] One user-approved playable Theme runs on Frontier Paper 1.21.11／Java 25 and exposes a representative entrance/start.
- [ ] Lobby minimum Hub, Main spawn Hub, and Frontier Gate minimum Hub are manually built and approved by the user.
- [ ] The Theme uses normal Frontier inventory and shared mcMMO; V0.1.0 WM rewards, achievements, Main rewards, Theme inventory, and initial equipment remain absent.

### Required Gate routes

- [ ] Lobby -> Main spawn Hub and Lobby -> Frontier Gate.
- [ ] Main -> Lobby, Main -> Frontier Gate, and Main -> each of `resource`, `resource_nether`, `resource_end`.
- [ ] Each Resource world -> Main spawn Hub.
- [ ] Frontier Gate -> playable Theme and playable Theme -> safe Frontier Gate return.
- [ ] Changed routes use approved exact coordinates, safe arrivals, and only their intended source/destination worlds.

### Resource reset bootstrap

- [ ] All Resource worlds have a reproducible safe arrival, Return Gate structure, Gate configuration, Spawn/Arrival setting, and optional approved protection.
- [ ] `resource_end` has a reproducible safe outer-island arrival/return independent of Dragon portals and End gateways.
- [ ] The procedure is idempotent, uses exact Runtime paths, and rejects every persistent/entry world.

### Operations and recoverability

- [ ] `Wayfarer.ps1` implements Start, Stop, Restart, Status, and Backup with the approved dependency and stop order.
- [ ] Cold Backup includes MariaDB dumps, stopped Redis AOF, persistent Worlds, Config, Manifest/SHA-256, and incomplete-generation safety.
- [ ] The Backup restores successfully to an isolated target.
- [ ] A verified V0.1.0 Baseline Backup and exact Release commit are selected; known limitations and the Tag/Release decision are recorded.

## 4. Future feature acceptance (not V0.1.0 Blockers)

- [ ] Cross-server Chat displays an approved origin format.
- [ ] Cross-server Shop, Dynamic Pricing, Player Shop, Global Stock, or automatic price adjustment has a separately approved economy design.
- [ ] Frontier WM rewards and Theme achievements avoid duplicate/replay rewards and preserve history.
- [ ] Main-side achievement rewards are claim-once and survive Theme removal.
- [ ] Theme-specific inventories and initial equipment prevent item loss/duplication across boundaries.
- [ ] WM Theme equipment purchases and Frontier Gate utilities preserve the Main/Frontier economy boundary.
- [ ] Main teleporters validate safe destinations and any cost/Unlock/Cooldown policy.
- [ ] Special or over-enchanted items retain meaningful normal Survival progression.
- [ ] Multiple playable Themes have explicit routing and data boundaries.
- [ ] PlugManX, a custom Plugin repository, or LAB is introduced only under its own approved task.

## 5. Detailed risk-focused test expectations

- Permission implementation: verify self-only argument restrictions, denial cases, Context scope, temporary expiry/removal, and absence of unintended authority.
- Persistent World generation: verify exact resolved paths, verified backup, selected generator conditions, safe Spawn, and out-of-scope world preservation.
- Shared Economy/Progression change: verify the changed data path across only the affected backends and persistence boundary.
- Portal/Dimension Routing: verify only every added/changed directed route, safe arrival, return path, and prohibited family crossing.
- Resource Reset: verify allowlist, exact paths, backup, recreation, Bootstrap idempotency, persistent-world rejection, and recovery.
- Backup/Restore: verify orderly disconnect/stop, process exit, data capture, manifest/hash, incomplete-generation handling, and isolated restore.
- Protocol/Failover changes: verify only the client/backend path or failure transition directly modified.

## 6. Historical verification results

The following records preserve work already performed under earlier tasks. Their extra detail does not expand the ordinary-Plugin standard above.

### Void entry worlds (2026-07-19)

- [x] VoidGen 2.3.8 loaded only on Lobby Paper 26.2 and Frontier Paper 1.21.11 with Java 25.
- [x] Both players spawned safely on persistent 17x17 platforms without terrain, falling, or suffocation.
- [x] Inventory retention, center respawn, disabled Nether/End, Main isolation, network switching, and direct-backend rejection were confirmed.

### WorldEdit／WorldGuard (2026-07-19)

- [x] WorldEdit 7.4.4 and WorldGuard 7.0.17 loaded on all Paper backends and remained absent from Velocity.
- [x] Lobby and `frontier_gate` denied `passthrough`, used only `g:wayfarer_builder`, and had no `build` flag; Main had no Project Region protection.
- [x] A temporary Builder performed a one-block edit/undo and Region inspection in the protected entry worlds while Main administration remained denied.
- [x] The temporary Builder parent was removed and no permanent test-user membership remained.

### TAB proxy display (2026-07-19)

- [x] TAB 6.1.0 and VelocityScoreboardAPI 2.1.0 loaded only on Velocity; TAB-Bridge 6.2.2 and PlaceholderAPI 2.12.3 loaded on all Paper backends.
- [x] Header, current server, online count, and ping displayed through Lobby -> Main -> Frontier -> Lobby and persisted after a clean restart.
- [x] PlaceholderAPI Cloud was disabled and no Expansion was installed.

### Multiverse and Main worlds (2026-07-19)

- [x] Multiverse-Core 5.7.2 loaded on all Paper backends; Multiverse-NetherPortals 5.0.5 loaded only on Main.
- [x] Existing persistent dimensions were registered without rename/move/copy/recreation, and Resource dimensions were created under Paper namespaced storage.
- [x] Persistent and Resource families retained explicit internal links without family crossing; representative Nether round trips succeeded.
- [x] `resource_end` retained legacy Dragon scanning disabled and showed no Ender Dragon.
- [x] The current `main_end` direct `/mvtp` Spawn caused suffocation; the user accepted this pre-final-generation state because normal routing does not use that point.
- [x] The Resource reset Script rejected persistent and entry targets; destructive execution was not performed.

### mcMMO and Waymark foundation (2026-07-19)

- [x] mcMMO 2.3.000 loaded only on Main/Frontier with shared `wayfarer_mcmmo` storage; Mining XP changes propagated cumulatively without stale-profile overwrite and survived restart.
- [x] RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 loaded only on Main/Frontier with shared `waymark` Redis scope and distinct client names.
- [x] Balance mutations, insufficient payment, Main/Frontier switching, command feedback, Minecraft restart, Redis restart, and cleanup to 0 WM were verified without rollback or duplicate addition.
- [x] The source-modified RedisEconomy compatibility investigation is retained in [its historical report](investigations/2026-07-19-rediseconomy-paper-26-2-message-compatibility.md).

### EconomyShopGUI 7.1.1 (2026-07-20)

- [x] Main-only placement, five sections/shops, 62 fixed Vanilla entries, Vault/RedisEconomy integration, Japanese display, non-OP category access, and administrative denial were confirmed.
- [x] Historical detailed cases confirmed 0 WM rejection, one 10.00 -> 9.60 purchase, reconnect, 9.60 -> 9.68 sale, missing-item rejection, full-inventory rejection, Frontier balance visibility, final cleanup to 0 WM, and clean restart/shutdown.
- [x] Those edge cases are historical evidence and are not required for every future ordinary EconomyShopGUI Config or version integration unless a relevant defect or foundation change occurs.
