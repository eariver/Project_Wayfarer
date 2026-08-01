# Acceptance Tests - Ver.0.0.6

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
- [x] Permission Phase 1A implements the five persistent Groups, self-only temporary Role foundation, Admin full access, OP removal, and the empty Builder Role container while preserving WorldGuard membership.
- [x] Lobby and Frontier Gate have protected Void entry-world safety baselines.
- [x] WorldEdit/WorldGuard, TAB proxy installation, Multiverse world registration, and Main dimension-family links have verified baselines.
- [x] mcMMO shared Main/Frontier progression and RedisEconomy shared Waymark balances have verified persistence tests.
- [x] EconomyShopGUI 7.1.1 Free provides the verified Main-only fixed-price shop.

These items describe current baselines only. The replacement Main generation, Order 5 acceptance, and Order 6 Final Main Baseline are complete. They do not mark Phase 1B, Hubs, Gates, either Frontier Theme, MVI, the future Frontier ResourcePackManager／Pack, custom Plugins, integrated operations, or the final V0.1.0 Release Backup as implemented.

## 3. V0.1.0 Release Blockers

### Permission model

Phase 1A complete:

- [x] All five Group definitions are persistent. Existing `default` and `wayfarer_builder` were audited and reused without delete/recreate or Primary Group use; missing Eligibility/Admin Groups were created after conflict checks.
- [x] The existing `wayfarer_builder` WorldGuard Global Region Member references remain intact while its former WorldEdit／WorldGuard administration wildcards are removed.
- [x] Eligibility uses exact LuckPerms 5.5.60 self-only, matching-Role, temporary-only argument permissions through Velocity; permanent Role membership, other Players, arbitrary Groups, arbitrary permissions, and Paper-side management are denied.
- [x] Full Minecraft／Plugin authority exists only while the Player's temporary Admin Parent is active and does not depend on OP.
- [x] Temporary add/remove, natural expiry, cross-instance propagation, denial after demotion, restart persistence, and Cleanup were verified.
- [x] The current Builder Role container permits protected-entry building only through WorldGuard membership and denies management commands; building is denied immediately after removal.

Phase 1B incomplete:

- [ ] Builder WorldEdit, gamemode, teleport, and Multiverse-Core access is scoped to the approved Lobby／Main／Frontier commands; Multiverse-NetherPortals access is limited to explicitly approved Main and Ruined Frontier work.
- [ ] Builder Phase 1B keeps WorldGuard Region and Velocity administration, LuckPerms/economy/player-punishment/server-stop authority, unrestricted wildcards, destructive World lifecycle operations, and reload/debug/internal administration excluded.
- [ ] Builder Survival cleanup is repeated after the Phase 1B gamemode allowlist exists.

### Main and gameplay

- [x] BetterStructures 2.6.3 and `103 Default Structures` version 5 are enabled only in Bukkit worlds `main`, `main_nether`, and `main_the_end`; every Resource world and unknown new world is disabled.
- [x] The 2026-07-21 finalized rollback baseline completed under an approved destructive task with exact paths, verified backup and manifest, recorded seed, preserved Resource family, and safe Overworld/Nether/End spawns.
- [x] EvenMoreFish enables with its adopted Config and one representative function; configuration has no explicit mcMMO Fishing conflict.
- [x] Before replacement generation, all five adopted Structure packs, BetterStructures Prop Pack, FreeMinecraftModels 2.10.2, and ResourcePackManager 2.3.0 are verified, imported, and loaded with the approved Main World allowlist and Pack preflight.
- [x] The prior Main baseline and rollback backup remained verified and recoverable immediately before replacement generation.
- [x] The separately assigned one-time Ver.0.0.6 destructive task regenerated only `main`, `main_nether`, and `main_the_end` with exact paths, normal shutdown, exact approval, complete Vanilla player reset, and verified backup／rollback evidence; the Resource family remained excluded.
- [x] Representative adopted Structures generate across Main Overworld／Nether／End and four distinct Packs. `Default`, `Caves`, `Echoes`, and Exploration Pack `betterstructures_exploration_bridgecave_shallow` passed bounded natural-generation acceptance.
- [x] Persistent and Resource Portal families remain separate, the changed Main Nether route passed an actual round-trip, all three Main spawns are safe, bedless respawn works, and the Main Resource Pack is delivered.
- [x] Order 6 accepted the current Weight／Content Config without changes, reverified World identities and Resource hashes, and finalized the replacement family with a verified stopped-state Main backup.
- Order 7 CoreProtect is deferred and non-blocking because CE 24.0 rejects Minecraft 26.2. Main／Lobby CoreProtect is temporarily excluded from the V0.1.0 blockers under Owner-only operation; it is not complete or accepted.
- [ ] After the user substantially completes the initial Hub, an approved exact Main Spawn WorldGuard Region denies general building, permits only intended public use, preserves Builder member building without Region administration, and persists after restart.
- [ ] Vanilla `spawn-protection` remains 16 until the Main Spawn Region passes acceptance; a separately approved change to 0 then avoids double protection without weakening the Region boundary.

### Wayfarer_Main／Growth Pickaxe

Artifact／Repository:

- [ ] One external Gradle Multi-module Repository records Wayfarer_Main release provenance, exact Version, SHA-256, Source Commit, Migration Version, and Config Version.
- [ ] Wayfarer_Main is placed only on Main; Lobby／Frontier do not contain it, and its JAR, Secrets, and Runtime Data remain untracked.

Async Join／Delivery and identity:

- [ ] Join handling performs no Main-thread DB I/O, loads the Player record asynchronously, and grants exactly one initial Tool through a race-safe unique constraint.
- [ ] Inventory-full delivery never drops the Tool; the Player is notified, Console records WARN, and Pending Delivery can be inspected／retried by Admin.
- [ ] Logout prevents late delivery, and a delivered logical record is not automatically reissued.
- [ ] Tool ID, Owner UUID, Item Type, Instance Epoch, and Schema Version survive restart; non-owner use／progress, Drop, Pickup, Container, Anvil, Grindstone, Smithing, Craft repair, Mending, external repair, Item Frame, Armor Stand, and Death Drop are rejected.
- [ ] Reissue increments the Epoch and makes every older Item instance invalid.

Progress and evolution:

- [ ] Progress increments only for the Main Resource Worlds `resource`, `resource_nether`, and `resource_end`, only for valid `minecraft:mineable/pickaxe` blocks broken by the Main-hand canonical Tool.
- [ ] `main`, `main_nether`, `main_the_end`, unknown Worlds, Creative／Spectator, and cancelled breaks grant no Progress.
- [ ] Player-placed blocks, generator-produced blocks, and Silk Touch re-placed ores are valid Progress sources. Each successful, non-cancelled `BlockBreakEvent` grants Progress exactly once.
- [ ] Explosion, Piston, WorldEdit, Command, Plugin deletion, and other non-player block removal grant no Progress.
- [ ] Survival and an actually successful Adventure break are handled according to the locked event contract.
- [ ] Cumulative progress derives Wood → Stone → Iron → Diamond and the approved Efficiency／Unbreaking／Fortune progression through Efficiency X, Unbreaking X, and Fortune V.
- [ ] Admin Fortune／Silk Touch switching works; Player-facing WM switching and Netherite Upgrade, Ranking, Evolution Rewards, Abilities, Cosmetics, Axe, and Shovel remain outside initial acceptance.

Config, broken state, and repair:

- [ ] Config recalculation preserves cumulative progress, fully re-derives Material／Enchants, permits downgrade, synchronizes Item display, does not repair by itself, and leaves an ACTIVE converted Tool with at least one durability.
- [ ] Only actual progress-driven evolution fully repairs; unsafe hot reload is rejected.
- [ ] A broken Tool becomes `GRAY_DYE`, cannot mine, opens the integrated GUI from a Main-hand air right-click, and preserves BROKEN／damage state across restart.
- [ ] Waymark Full Repair reissues the canonical Tool through a Transaction ID with idempotency, double-charge prevention, Refund／Reconcile on failure, and no silent completion of UNKNOWN transactions.

Persistence／boundary:

- [ ] MariaDB migrations own `wf_main_*`; Session Cache, periodic Checkpoint, immediate critical-state save, Quit Flush, timeout-bounded shutdown Flush, and post-disable callback rejection avoid Main-thread DB I/O and stale writes.
- [ ] Audit, optimistic concurrency, and Reconcile handle Pending Delivery, repair, reissue, and conflict cases.
- [ ] Growth Pickaxe is Main-only, never transfers to Frontier, uses the Waymark Adapter rather than RedisEconomy keys, and never updates MVI, mcMMO, or EliteMobs databases directly.

### Frontier shared foundation

- [x] Order 8 Proposal `FRONTIER-LOCK-20260726-003` statically locks Artifacts, World IDs, MVI groups, Gate method, Pack inputs, persistence and Permission boundaries without claiming Runtime acceptance.
- [ ] Runtime-enable only the locked Frontier components and verify their dependency order, generated Config and final Pack composition without changing the approved versions, hashes, World IDs, Gate method, Pack inputs or persistence owners.
- [ ] MVI implements `neutral`, `worlds_beyond`, and `guild`, switches the approved Player State without loss／duplication／stale overwrite, and survives restart, disconnect, and reconnect.
- [ ] Main, Frontier Lobby, Worlds Beyond, and Ruined Frontier exchange no Inventory, Armor, Offhand, Ender Chest, Vanilla or custom Item, XP, Health, or Food.
- [ ] Waymark and mcMMO retain only their approved shared behavior without becoming an item-transfer path.
- [ ] ResourcePackManager delivers separate Main and Frontier Packs and switches correctly across Main／Frontier backend movement and reconnect.
- [ ] Wayfarer_Core, Wayfarer_Main, and Wayfarer_Frontier load from one external Gradle Multi-module Repository's separately released Runtime Artifacts and satisfy their Database／API／Permission／audit contracts without storing normal Inventory.
- [ ] Beyond and Guild Gates arrive safely; only Ruined Frontier has a family-local Nether／End Portal boundary; Worlds Beyond portals are denied without fallback; both Themes return safely to Frontier Lobby.
- [ ] Lobby minimum Hub, Main spawn Hub, and Frontier Gate minimum Hub are manually built and approved by the user.

### Ruined Frontier alpha

- [ ] Adventurer's Guild, Primis, and the three approved Ruined Frontier dimensions load with the locked World IDs.
- [ ] The initial Ruined Content set consists of Exploration Pack, Caves and Lost Civilizations Free, Echoes of the Past, Adventure Pack, BetterStructures Prop Pack, Free Elite Shrines, and Dungeoneering Modules Free.
- [ ] The full `103 Default Structures` pack remains disabled in Ruined Frontier; any approved individual Structure is separately selected and documented without enabling the whole pack.
- [ ] BetterStructures and EliteMobs are active in all three Ruined Frontier dimensions, with representative natural Structure generation and no cross-Theme generation.
- [ ] Representative EliteMobs Sign, Free Elite Shrine, Dungeoneering module, Boss identity, and Loot behavior work without item leakage.
- [ ] Guild and verified Instance Worlds use the correct MVI profile; restart／reconnect and Instance lifecycle do not lose or duplicate Player State.
- [ ] The independent EM Adapter review records whether static registration, strict Regex, or an Adapter is required; an Adapter is not assumed.
- [ ] The Frontier Resource Pack renders required BetterStructures／EliteMobs／FreeMinecraftModels assets; BetterHealthBar3 passes or is explicitly rejected by its adoption test.
- [x] Order 8 locked the Frontier history／rollback product as unselected and retained CoreProtect 24.0 only as an Artifact candidate; any adoption requires a separate selection／Runtime validation task.

### Worlds Beyond MVP

- [ ] The locked Iris Overworld `frontier_iris` loads as the only persistent Worlds Beyond World at PEACEFUL with the approved Seed and World Border.
- [ ] Only `frontier_iris` belongs to MVI `worlds_beyond`; `frontier_iris_nether` and `frontier_iris_the_end` are not created, registered, or added.
- [ ] Worlds Beyond has no MNP link; Nether／End Portal activation and travel are denied without Default／Ruined／Main／unknown-World fallback.
- [ ] Worlds Beyond functions fail closed in every Nether, End, and unknown World.
- [ ] Traversal Loadout, Elytra, the adopted LeafGrapple integration, and Launchpad work without duplication or use outside the approved Theme.
- [ ] Frontier WM Shop transactions use the formal Waymark adapter and preserve idempotency／audit without accepting Theme items as cross-boundary value.
- [ ] Waystone placement／lifecycle, Discovery GUI, and Teleport GUI operate within safe destinations and Permission limits.
- [ ] Persistence, Resource Pack delivery, MVI separation, restart／reconnect, and safe Frontier Lobby return pass.

### Required Gate routes

- [ ] Lobby -> Main spawn Hub and Lobby -> Frontier Gate.
- [ ] Main -> Lobby, Main -> Frontier Gate, and Main -> each of `resource`, `resource_nether`, `resource_end`.
- [ ] Each Resource world -> Main spawn Hub.
- [ ] Frontier Gate -> Worlds Beyond and Worlds Beyond -> safe Frontier Gate return.
- [ ] Frontier Gate -> Ruined Frontier and Ruined Frontier -> safe Frontier Gate return.
- [ ] Ruined Frontier retains its family-local Nether／End routes; Worlds Beyond has none and cannot cross or fall back to another family.
- [ ] Changed routes use approved exact coordinates, safe arrivals, and only their intended source/destination worlds.

### Resource reset bootstrap

- [ ] Routine Resource reset scripts accept only `resource`, `resource_nether`, and `resource_end`, and reject all three Persistent Main worlds.
- [ ] All Resource worlds have a reproducible safe arrival, Return Gate structure, Gate configuration, Spawn/Arrival setting, and optional approved protection.
- [ ] `resource_end` has a reproducible safe outer-island arrival/return independent of Dragon portals and End gateways.
- [ ] The procedure is idempotent, uses exact Runtime paths, and rejects every persistent/entry world.

### Operations and recoverability

- [ ] `Wayfarer.ps1` implements Start, Stop, Restart, Status, and Backup; planned shutdown rejects new connections, disconnects users, stops Velocity, settles in-flight work, flushes/stops Main／Frontier／Lobby, and confirms Java process exit.
- [ ] Cold Backup includes MariaDB dumps, stopped Redis AOF, persistent Main／Frontier Worlds, MVI Profiles, custom-Plugin release Artifacts／Versions／SHA-256／Source Commits, migrations, `wf_main_*`, Growth Tool identity／epoch／progress／ACTIVE／BROKEN／Pending Delivery／repair transaction data, audit／reconcile records, approved Content／Pack inputs and outputs／hashes, Config, Test Reports, Manifest/SHA-256, and incomplete-generation safety.
- [ ] Isolated restore verifies foundation and migrations before MVI, Worlds, custom data, Artifacts／Config, backends, and proxy, then verifies Growth Tool owner／epoch／derived state／pending delivery／repair transaction and no duplicate issuance before Player join.
- [ ] The Backup restores successfully to an isolated target.
- [ ] A verified V0.1.0 Baseline Backup and exact Release commit are selected; known limitations and the Tag/Release decision are recorded.
- [ ] A separate destructive pre-release task records an explicit Owner decision to Reset or Preserve Growth Tool logical data; this documentation does not choose either option.

## 4. Future feature acceptance (not V0.1.0 Blockers)

- [ ] Re-evaluate Main／Lobby CoreProtect when a Minecraft 26.2-compatible Stable release appears, another Player or multiple Builders join, public operation begins, or large collaborative WorldEdit work is planned.
- [ ] Cross-server Chat displays an approved origin format.
- [ ] Cross-server Shop, Dynamic Pricing, Player Shop, Global Stock, or automatic price adjustment has a separately approved economy design.
- [ ] Optional Ruined Frontier WM rewards avoid duplicate/replay rewards and use the formal adapter.
- [ ] Future item-independent Theme achievements and rewards are claim-once and survive Theme removal.
- [ ] Optional WM Theme-equipment design does not create an item-transfer or conversion path across backend／MVI boundaries.
- [ ] Main teleporters validate safe destinations and any cost/Unlock/Cooldown policy.
- [ ] Special or over-enchanted items retain meaningful normal Survival progression.
- [ ] Any Theme beyond Ruined Frontier and Worlds Beyond has explicit routing and data boundaries.
- [ ] PlugManX, any custom Plugin Repository beyond the one required Gradle Multi-module Repository, or LAB is introduced only under its own approved task.

The V0.2.x custom-Plugin document under `codex/` remains non-authoritative for proposals not explicitly promoted into Ver.0.0.6. It does not satisfy Wayfarer_Core／Main／Frontier implementation checkboxes or authorize Repository／Artifact creation.

### Order 9 Phase 1.5 current evidence

- [x] Exact Wayfarer_Core V0.0.1 release identity, SHA-256, source/handoff commits, Config version, and migration ceiling are recorded in the current manifests.
- [x] An isolated Paper 26.2 build 62／Java 25 probe passed first boot, V001–V003 migration, restart Validate／No-op, Vault／RedisEconomy provider health, clean disable, and task-only cleanup.
- [ ] Install the approved JAR into Main／Frontier, perform the backup-gated Main-first migration, validate Frontier, and complete production acceptance.

The Phase 1.5 probe is evidence for compatibility and configuration foundation only. It does not authorize or claim production Runtime, permission, MariaDB, Redis, world, or player-state changes.

## 5. Detailed risk-focused test expectations

- Permission implementation: verify persistent Group reuse, self-only temporary Parent restrictions, denial cases, Context scope, expiry/removal, and absence of unintended authority.
- Persistent World generation: verify exact resolved paths, verified backup, selected generator conditions, safe Spawn, and out-of-scope world preservation.
- MVI／Inventory boundary: verify every affected Gate, Portal, Respawn, teleport, restart, disconnect／reconnect, Instance lifecycle, and complete item non-transfer boundary.
- Project-owned Plugin: verify Source／Release provenance, schema migrations, idempotency, audit, API／Permission contracts, failure recovery, and detailed changed-function behavior.
- Resource Pack distribution: verify build inputs, hash, Hosting, Client acceptance／refusal／failure, backend switching, cache update, conflicts, and rollback.
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

### Permission Phase 1A (2026-07-20)

- [x] LuckPerms 5.5.60 loaded on Velocity and all Paper backends with shared MariaDB／SQL messaging, argument-based command permissions, unique server Contexts, and OP disabled on Paper.
- [x] Five persistent Group definitions were present; `default` and `wayfarer_builder` were reused, and no Player retained a permanent Builder／Admin Parent or non-default Primary Group.
- [x] Admin Eligibility allowed only matching self temporary elevation/removal; permanent, wrong-Role, arbitrary-Group, other-Player, permission-mutation, Group-administration, and Editor attempts were denied.
- [x] Temporary Admin provided representative Velocity, Paper, Vanilla, LuckPerms, WorldGuard, Multiverse, and EconomyShopGUI authority, then lost it immediately on removal. A short temporary grant also expired naturally.
- [x] Temporary Builder allowed a restored one-block protected-entry edit while WorldEdit, WorldGuard administration, Multiverse, gamemode, teleport, LuckPerms, and Velocity administration were denied; building was denied after removal.
- [x] A clean network restart preserved Eligibility and Group definitions, left Temporary Roles and OP empty, reloaded all four LuckPerms instances without startup errors, and retained self-elevation／demotion behavior.

### BetterStructures 2.6.3 (2026-07-20)

- [x] The official LGPL-3.0-only Paper release loaded only on Main with WorldEdit 7.4.4; `/betterstructures version` reported 2.6.3 after a clean restart.
- [x] The manually imported free `103 Default Structures` version-5 archive installed exactly 103 Schematics; JAR, ZIP, extracted content, Worlds, Logs, and Cache remain ignored.
- [x] `ValidWorlds.yml` enables actual Bukkit worlds `main`, `main_nether`, and `main_the_end`, disables all three Resource worlds, and defaults unknown new worlds to disabled. Automatic Plugin download is disabled.
- [x] A CIRCLE pregeneration centered on Main Chunk `(64, 64)` with radius 256 and no World Border change generated 264 new Chunks. `betterstructures_well_grassy` naturally appeared in `main` Chunk `(76, 58)` and remained after restart.
- [x] A representative previously ungenerated Resource Overworld Chunk was loaded while Resource remained disabled; no BetterStructures notification or placement/paste event appeared. Resource Nether and End were verified disabled in Config.
- [x] The official Pack's legacy `minecraft:bed` block-entity keys produce non-blocking DataFixer ERROR-level messages on load. BetterStructures completes initialization and the adopted structure/restart tests pass; no other startup ERROR, SEVERE, or Exception occurred.

### Phase 3 final persistent Main generation (2026-07-21)

- [x] The user approved the exact destructive scope, resolved paths, retained seed, complete Vanilla player-data reset, BetterStructures radius 100, and verified rollback backup before world movement.
- [x] The ignored backup contains 177 payload files and a complete SHA-256 list; its manifest digest is `50B0F6244223DA68B752407BBE89127E0CE49645F7673A5FF929EE9C5B8A3C9D`.
- [x] Paper 26.2 build 62 under 64-bit Java 25 generated `main`, `main_nether`, and `main_the_end` with seed `164225356311935743` and new non-conflicting world UUIDs.
- [x] Resource UUIDs and seeds remained unchanged, Region counts remained `8 / 4 / 4`, every Resource Region-file SHA-256 matched the backup, and BetterStructures remained disabled there.
- [x] The approved Savanna Overworld spawn and bedless respawn were safe; the selected Nether and default-platform End administrative spawns passed focused safety and travel tests.
- [x] A clean full-network restart reloaded all worlds, Multiverse links, and BetterStructures scope. Velocity-to-Main arrival reached the approved spawn, and the network then stopped normally.
- [x] Rollback remains possible from the verified ignored local backup. World, player, backup, Region, log, cache, and JAR data remain outside Git.

### Main BetterStructures five-Pack preflight (2026-07-25)

- [x] The user-supplied five Content archives, 55-Model Prop Pack, FreeMinecraftModels 2.10.2, and ResourcePackManager 2.3.0 matched their locked versions and hashes; Codex downloaded no executable or Content artifact.
- [x] A reproducible ignored working copy selected exactly 278 of 430 Structure configurations and disabled 152; two complete builds produced identical import ZIP digests.
- [x] Exact Prop normalization replaced 240 occurrences with zero unresolved Model IDs. The approved `shelf4` and `ladder` mappings resolve to `bs_prop_pack_shelf2` and `bs_prop_pack_ladder_short`.
- [x] The Schematic audit found 627 Prop Armor Stands, 17 Zombies, 27 Skeletons, 29 Bats, 68 other ordinary Entities, and no remaining saved Item or Projectile. All ten exact legacy representatives parsed.
- [x] The user approved removal of one saved egg Item and 144 stale `minecraft:bed` Block Entity records from the generated working copy only. Original archives remain unchanged.
- [x] BetterStructures loaded all five packages with 278 enabled／152 disabled; FMM loaded 55 Models; ResourcePackManager produced the 838,975-byte Main Java pack. The final clean boot had no failed Schematic, unresolved Model, duplicate ID, startup-blocking error, or bed DataFixer message.
- [x] Only `main`, `main_nether`, and `main_the_end` remain enabled. All Resource worlds and unknown new worlds remain disabled; radius 100 and disabled EliteMobs integration are unchanged.
- [x] Client preflight confirmed optional prompt, download/application, representative Prop rendering, refusal behavior, reconnect cache behavior, Main／Lobby switching, and no critical Client error.
- [x] Runtime-only load verification kept every persistent Region SHA-256 unchanged. The approved Client smoke test then placed and removed representative FMM Props in already-generated Overworld Chunks; Region counts remained `11 / 4 / 4`, no new Region appeared, and Nether／End hashes remained unchanged. Four existing Overworld Region-container hashes changed during normal Player-session saves, so byte-for-byte post-Client invariance is not claimed. No Structure was pasted and no ungenerated Chunk was intentionally loaded.
- [x] JARs, archives, Schematics, Models, generated packs, Runtime data, Logs, Worlds, and the ignored rollback snapshot remain outside Git.

### Main Ver.0.0.6 replacement generation and Order 5 acceptance (2026-07-25)

- [x] Pre-execution HEAD `c6a5d27c5410666c1cde436d1b6986ebbd334cf8`, exact approval `APPROVE-WAYFARER-MAIN-V006-REPLACEMENT-GENERATION`, and Complete Reset policy were recorded before moving the Main container.
- [x] `backups/main-v006-replacement-generation-20260725-154934/` contains 181 verified payload entries. Manifest SHA-256 is `C79C2FC3ECBA998D875200E1D29B1B82B9BE97808B965E28D74B60108F62B118`; all hashes passed before generation and after acceptance.
- [x] The candidate retained seed `164225356311935743` and created UUIDs `d868e7ff-6663-492d-a963-f95f00ce6c30`, `1225688f-7770-43ed-b1dd-71bd112de3b5`, and `436843c4-2229-4c67-907c-b3a7d1530d71` for Overworld, Nether, and End.
- [x] Main／Nether／End spawns remained `(320,70,128)`, `(20.5,60,-19.5)`, and `(100.5,49,0.5)`. Overworld bedless respawn, Nether safety, and the default End platform passed.
- [x] Every one of the 16 preserved Resource Region hashes matched the replacement backup after generation and after restart. Resource UUIDs, seeds, Multiverse registration, family-local links, and BetterStructures exclusion remained intact.
- [x] Natural generation passed for Default `mine_storage_deep`, Caves `circledungeon_dripstone`, Echoes `wall_nether`, and Echoes `shrine_end`; the End shrine's `bs_prop_pack_vase` rendered normally after a clean restart.
- [x] The user-authorized amended exploration bounds ended at new Region counts `7 / 7 / 14` (total 28) for Overworld／Nether／End, within the final limits. No pregeneration, manual paste, Chunk Pregenerator, or World Border change was used.
- [x] A temporary high-altitude Main／Nether Portal pair completed a round-trip, was removed from both worlds, and left no Nether Portal Palette or forced Chunk. Config inspection confirmed that persistent and Resource links do not cross.
- [x] A full normal network restart reloaded Paper, Velocity, all five Content packs, 278 selected Structures, FMM 55 Models, ResourcePackManager, unchanged UUID／Seed／Spawn settings, and the Resource family without a startup-blocking error.
- [x] Main Resource Pack reconnect succeeded without protocol error. FMM Prop markers existed before restart; the Client-visible Vase appeared after restart, establishing restart recovery rather than a missing Model.
- [x] Exploration Pack `betterstructures_exploration_bridgecave_shallow` completed the fourth distinct Pack requirement in `main`; the exact notification anchor, Chunk／Region, Chest, restart persistence, six-Region bound, and Resource hash preservation were verified.
- [x] Order 6 selected Decision A, retained all 278／152 Content and Weight settings, and promoted this candidate to the Final Main Baseline. This does not complete the network cold backup or V0.1.0 Release Baseline.

### Main Order 6 Final Main Baseline (2026-07-25)

- [x] Exact approvals `APPROVE-WAYFARER-MAIN-ORDER6-ACCEPT-AS-IS` and `APPROVE-WAYFARER-MAIN-V006-FINAL-BASELINE` were recorded. No Structure, Weight, Distance, Altitude, World allowlist, Region, Seed, UUID, Spawn, Portal, Content, Model, or executable artifact changed.
- [x] Clean Runtime validation loaded Paper 26.2 build 62, BetterStructures 2.6.3, WorldEdit 7.4.4, all five Content packs, 278 selected Structures, FMM 55 Models, ResourcePackManager 2.3.0, and existing Gameplay Plugins without a startup-blocking error, failed Schematic, unresolved Model, or duplicate ID.
- [x] Client delivery, Lobby → Main, existing Exploration Bridge Cave／Chest, existing End Shrine／Vase Prop, restart persistence, and Player cleanup passed without generating another Region.
- [x] Final Region counts remained `17 / 11 / 18`; Resource counts remained `8 / 4 / 4`, and all 16 Resource Region SHA-256 values matched the replacement rollback evidence.
- [x] `backups/main-v006-final-baseline-20260725-220745/` contains a stopped-state copy of all 207 Main-container files totaling 148,994,081 bytes plus Config／evidence snapshots. Every Source–Payload SHA-256 matched.
- [x] Final Backup manifest SHA-256 is `A85A7CCAA2FE2DECCC69CE3E9F862F1281408B4D02E20EFC1E3E31B74D0814A1`; SHA-list digest is `81593864B49E41FB03F02514C1935DFAF380A1ABFE6FB148897932E328A50C39`.

### EvenMoreFish 2.4.3 (2026-07-21)

- [x] The stable MIT Paper release was manually acquired, verified at SHA-256 `0F131FE8F7EC68DF2C14D09D2A4E39B9E481257F106A12B06B5BD6513B30BC05`, and installed only on Main.
- [x] Japanese Config loaded with 5 rarities, 72 fish, 6 baits, 1 rod, and zero competitions. Only actual worlds `main` and `resource` are allowed; representative excluded world `main_the_end` is absent from the allowlist.
- [x] One natural catch produced exactly one Custom Fish, increased mcMMO Fishing XP from 0 to 151 without duplicate loot, and left Waymark unchanged at 0.
- [x] The representative catch was retained only as a normal test item and was not sold or converted into Waymark.
- [x] Dedicated MariaDB `wayfarer_evenmorefish` initialized only `emf_` tables. Journal/statistics persisted through a clean full-network restart without exposing credentials or row contents.
- [x] General-player Main-context Journal, bait application, and two adopted toggles worked while Shop, Sellall, competition, and administration remained denied. Temporary Admin reported version 2.4.3 and was removed afterward.
- [x] The GUI retained no Shop after restart. The bundled NBT-API Paper-build warning and Flyway MariaDB verified-range warning are recorded as non-blocking because the affected representative item/database paths passed.

### Waymark 100x scale and EvenMoreFish Fish Shop (2026-07-22)

- [x] All 62 EconomyShopGUI prices across five unchanged categories were exactly 100x their prior values; product keys, Materials, directions, GUI rows, and buy/sell spreads were unchanged. YAML and representative GUI prices passed without an EconomyShopGUI transaction.
- [x] EvenMoreFish hooked into Vault through RedisEconomy/VaultUnlocked with multiplier 1.0. PlayerPoints, Claim Blocks, competitions, Hunt, Lava／Void Fishing, and direct MONEY rewards remained disabled.
- [x] Tracked worth multipliers are Junk 0.0, Common 1.0, Rare 0.5, Epic 0.3, and Legendary 0.2. Coinfish retained its identity but lost its direct-money requirement, interaction, and lore.
- [x] The Main menu Fish Shop and `/emf shop` opened for a normal player, while `/emf sellall` and administration remained denied through the Main-only permission boundary.
- [x] One previously caught Common Lemon Shark was sold and consumed. Exact post-sale balance was not an acceptance assertion; only the resulting test increment was restored through the supported RedisEconomy administration command.
- [x] Main restarted normally with EvenMoreFish 2.4.3, EconomyShopGUI 7.1.1, Vault/RedisEconomy, MariaDB, mcMMO, and zero competitions healthy. Existing documented NBT-API, Flyway, and BetterStructures content warnings remained non-blocking.
- [x] No global balance migration, player-state reset, Redis-key edit, Player data change, JAR change, or V0.1.0 release declaration occurred.
