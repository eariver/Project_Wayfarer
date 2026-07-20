# Operations

The authoritative design, task-grouping rules and risk-based verification policy are defined in the [Ver.0.0.5 design guide](00-design-guide.md).

## Startup order

1. MariaDB and Redis
2. Lobby
3. Main
4. Frontier
5. Velocity

The provided `Start-All.ps1` follows this order. It opens separate processes and does not treat process launch as a successful health check.

## Shutdown

V0.1.0 normal operation does not treat Server Consoles as a daily administration UI. Responsibility is divided as follows:

- running Minecraft／Plugin／Player／World administration: in-game commands while the Player has a Temporary Admin parent;
- network Start／Stop／Restart／Status／Backup: the planned `Wayfarer.ps1`;
- Windows processes, Docker, MariaDB, Redis, cold backup, restore, and unresponsive-process recovery: PowerShell／OS operations;
- Server Console: exceptional bootstrap, lost-permission recovery, and incident diagnosis.

Because `Wayfarer.ps1` is not implemented in Ver.0.0.5, existing manual Scripts or Console commands may be used provisionally. They are not the formal V0.1.0 operating interface.

The planned V0.1.0 shutdown sequence is:

1. Reject new connections.
2. Display the reason to connected users and disconnect them.
3. Stop Velocity.
4. Wait about 10 seconds for in-flight switching and save requests to settle.
5. Issue `save-all flush` or its equivalent to each Paper backend.
6. Stop Main, Frontier, and Lobby normally, in that order.
7. Confirm that the target Java processes have exited.

The approximate wait is not a data-integrity guarantee. Paper's normal save/stop, process-exit confirmation, and normal database/Redis handling are authoritative.

## Backups

Back up at minimum:

- Main persistent worlds
- Frontier worlds and Plugin data
- Plugin Config
- MariaDB dump
- RedisEconomy Config templates and the stopped Redis AOF volume
- resource-pack sources

Resource worlds are disposable and may be excluded from long-term backups.

Waymark balances are persistent Redis data. Do not copy `infrastructure/data/redis` while Redis is running and do not introduce a hot/warm backup Plugin. A cold backup continues after shutdown step 7: create the MariaDB dump; stop Redis normally; confirm its process has stopped; copy the stopped Redis AOF volume; copy persistent Worlds, Frontier content, Config, and other approved data; then create the Manifest/SHA-256 record and finalize the `.incomplete` generation only after validation. Decide whether to stop or restart remaining Infrastructure after capture. Start Redis again only after the copy has completed. The V0.1.0 Baseline is incomplete without MariaDB dumps, the Redis AOF volume, persistent Worlds/Config, a manifest with SHA-256 values, and an isolated restore test.

## Resource reset

Use `Reset-ResourceWorlds.ps1` only while Main is stopped. The exact allowlist is `resource`, `resource_nether`, and `resource_end`; `all` selects those three exact entries. Runtime storage resolves to `servers/main/main/dimensions/minecraft/<resource-key>`, not similarly named top-level directories.

Every reset requires a new destination below the ignored repository `backups/` directory, the stopped-server assertion, and the exact confirmation text. The script verifies the backup's file count and byte total before deleting the source. It rejects persistent/entry names, the corresponding `minecraft:` persistent keys, Main-external targets, existing backup destinations, and equal or nested source/backup paths.

```powershell
.\scripts\Reset-ResourceWorlds.ps1 `
  -World resource `
  -MainServerIsStopped `
  -BackupDirectory .\backups\resource-reset-YYYYMMDD-HHMMSS `
  -ConfirmationText RESET-WAYFARER-RESOURCE
```

The reset workflow has not yet received a destructive execution test. Do not run it during normal operation until a separately approved reset task validates unload, recreation, link restoration, and recovery from its backup.

Before V0.1.0, the reset design must also bootstrap a safe arrival, a reproducible Return Gate structure to the Main spawn hub, Gate configuration, Spawn/Arrival placement, any required protection, and a return-route check. `resource_end` must restore a safe outer-island site without relying on the Dragon exit portal or End gateways. The Bootstrap implementation method is not selected; compare a user-authored WorldEdit Schematic, tracked structure Template, idempotent Script/Command procedure, or future external custom Plugin. Persistent worlds must remain rejected targets.

## Multiverse world management

Multiverse-Core 5.7.2 runs on Lobby, Main, and Frontier. Lobby and Frontier register only their existing entry worlds. Multiverse-NetherPortals 5.0.5 runs only on Main and stores explicit directional links for both sides of these pairs:

- `minecraft:overworld` ↔ `minecraft:the_nether`
- `minecraft:overworld` ↔ `minecraft:the_end`
- `minecraft:resource` ↔ `minecraft:resource_nether`
- `minecraft:resource` ↔ `minecraft:resource_end`

Use the namespaced keys for runtime diagnosis. `main_end` is a logical Multiverse alias, not a filesystem path. World access enforcement, gamemode enforcement, and flight enforcement remain disabled so that Multiverse does not replace existing backend access or player-state behavior. Phase 1A Admin operation is available, but Builder has no Multiverse authority until Phase 1B. The final Builder Allowlist may include World information, travel, safe Spawn operations, individual World properties, and Main-only NetherPortals link/unlink/inspection; World creation and destructive import/unload/deletion/clone/regeneration/purge, plus reload/debug/internal operations, remain Admin-only.

## BetterStructures

BetterStructures 2.6.3 runs only on Main and depends on WorldEdit 7.4.4. Its tracked Config is limited to `plugins/BetterStructures/config.yml` and `ValidWorlds.yml`; the JAR, Imports, extracted `103 Default Structures` Schematics, generated content assets, Resource Pack output, cache, update and session data remain ignored. Content and Plugin binaries are manually acquired, `nightbreak.autoDownloadPluginUpdates` stays `false`, and the unused EliteMobs Region integration stays disabled.

The actual Bukkit allowlist is `main`, `main_nether`, and `main_the_end`. `resource`, `resource_nether`, and `resource_end` are explicitly `false`, and `New worlds spawn structures` is `false`. Do not use the Multiverse alias `main_end` in this Config. BetterStructures affects only newly generated chunks; do not delete Region files or broaden pregeneration to test it. Normal Config/content changes require a clean Main restart, not PlugManX or server `/reload`. The retained default spawn protection radius of 100 blocks was approved and used for Phase 3 final Main generation.

The official version-5 content emits non-blocking DataFixer messages for legacy `minecraft:bed` block-entity keys on Minecraft 26.2. BetterStructures still completes initialization, and representative natural generation plus restart persistence passed. Recheck this upstream-content warning when either Plugin or Pack changes; do not edit the official Schematics in place.

## Main persistent world baseline

Phase 3 completed on 2026-07-21 with seed `164225356311935743`. Normal Main spawn is `(320, 70, 128)`; the Multiverse administrative spawns are `(20.5, 60, -19.5)` in Nether and `(100.5, 49, 0.5)` in End. The persistent worlds live below `servers/main/main/dimensions/minecraft/{overworld,the_nether,the_end}`. Do not treat the alias `main_end` as a path.

The pre-generation rollback copy is the ignored local directory `backups/main-final-generation-20260721-001501/`. Confirm its manifest and payload hashes before relying on it, and never assume it is available from GitHub. Any rollback or later regeneration requires a new explicitly approved destructive task, all Minecraft components stopped, exact resolved paths, Resource-family preservation checks, and a verified backup. See [Main World Baseline](13-main-world-baseline.md).

## Planned Main Spawn protection

Main has no Project WorldGuard Region yet. Keep `spawn-protection=16` while the user builds the initial Hub. After the Hub footprint and equipment positions are substantially complete, a separate task must approve the exact `main_spawn_hub` boundary and any focused child regions before applying them.

Use normal WorldGuard membership protection: general Players cannot place or break, `wayfarer_builder` is a Region Member, and Temporary Admin manages the Region. Do not set the `build` flag. `use allow` may cover approved public controls, but do not grant broad `interact allow` or `chest-access allow`; isolate exceptional equipment in the smallest practical higher-priority child Region. Verify the exact WorldGuard 7.0.17 environmental flag names at implementation time. Only after the Region, public interaction, and Builder membership tests pass may a separate task change Vanilla `spawn-protection` to 0.

CoreProtect should be installed before substantial Hub/Gate construction begins so later investigation includes that work. It is not currently installed, remains Admin-only for rollback, and cannot replace cold backup.

## Lobby and Frontier void worlds

VoidGen 2.3.8 is installed only in `servers/lobby/plugins` and `servers/frontier/plugins`. It generates the `lobby` and `frontier_gate` entry worlds; Main must not use VoidGen.

The current safety baseline is:

- a 17x17 stone platform at Y=63 with a gold center block at `(0, 63, 0)`;
- world spawn at `(0, 64, 0)`, with clear space above and void below the platform;
- `keep_inventory=true` and respawn radius `0`;
- Nether and End disabled on Lobby and Frontier only.

Keep the platform until a separately verified permanent Lobby or Frontier gate structure replaces it. Before regenerating either world, stop all Minecraft components, resolve and report the exact source and backup paths, obtain explicit approval, and move the existing world to an ignored backup directory. Never delete the only backup. After regeneration, repeat the safe-spawn, fall/respawn, inventory-retention, distant-void, restart-persistence, network-switching, and direct-backend rejection tests before exposing the world through Velocity.

## Updates

1. Check the target Minecraft/server/Plugin compatibility matrix.
2. Clone or copy the current installation into a staging directory inside the workspace.
3. Back up persistent data.
4. Update one layer at a time.
5. Run acceptance tests.
6. Never downgrade TAB Config or a world without a supported rollback plan.

## Plugin JAR acquisition

Plugin executable artifacts are manually obtained by the user and placed in an ignored repository-local `manual-downloads/` staging directory. Verify each artifact's filename, internal metadata, version, platform, license, checksum, archive readability, and intended placement before copying it to a runtime `plugins/` directory. Staging and runtime JARs remain outside Git, and Plugin auto-update or binary replacement stays disabled unless a separate task explicitly authorizes it.

For an ordinary official Plugin, start only the target Runtime as needed and confirm Enable, the adopted Project Config, one representative Command or GUI, and no startup-blocking error. Do not broaden that task into edge-case coverage, unrelated Plugin regression, or network-wide testing. Plugins that share one feature area, dependency boundary, placement and representative check may be introduced together. Local/source-modified Plugins, observed defects, persistent data, security, protocol, world lifecycle, portal routing, backup/restore and failover work retain change-focused detailed verification.

## Paper building administration and entry-world protection

WorldEdit 7.4.4 and WorldGuard 7.0.17 use the same verified Bukkit JARs on Lobby, Main, and Frontier; neither Plugin is installed on Velocity. Lobby and `frontier_gate` protect their entire entry worlds with `__global__` regions that deny `passthrough` and include the LuckPerms group `wayfarer_builder` as their only member. Phase 1A removed the former `worldedit.*` and `worldguard.*` administration nodes; the Group now inherits only `default`.

Main has the administration Plugins installed but currently has no Project Wayfarer protection Region or Global Region Flag. Normal Survival building remains available there, and `wayfarer_builder` receives no Main WorldEdit or WorldGuard permission. Add Main protection only after a separate World/Region design is approved.

Do not use the WorldGuard `build` flag, because it bypasses normal membership-based build behavior and can interfere with non-player mechanisms. The existing `wayfarer_builder` Group and Region membership are a verified baseline and must be reused, not deleted or recreated. Membership-based one-block building and immediate denial after Parent removal were verified without WorldGuard administration. The expanded Builder Allowlist remains Phase 1B work.

## Temporary Player membership

Phase 1A is implemented. All five Group definitions are persistent, while Player membership in `wayfarer_builder`／`wayfarer_admin` is temporary. `wayfarer_builder_eligible` may add/remove only its own Builder Parent, and `wayfarer_admin_eligible` may do the same only for Admin, through Velocity `/lpv`. Builder membership uses 2 hours and Admin membership 30 minutes as standard values supplied with the temporary grant; they are not technically fixed. Eligibility remains `default`-equivalent and cannot grant permanent Parents, affect other Players, assign arbitrary Groups/permissions, or use Paper `/lp` administration.

```text
/lpv user <player> parent addtemp wayfarer_builder 2h deny
/lpv user <player> parent removetemp wayfarer_builder
/lpv user <player> parent addtemp wayfarer_admin 30m deny
/lpv user <player> parent removetemp wayfarer_admin
```

The current Builder Role container has no WorldEdit, Creative／Survival／Spectator, teleport, or Multiverse command permission. Phase 1B will derive an explicit allowlist from the adopted versions after the actual Hub／Gate／Theme work is known. WorldGuard Region administration, unapproved Advanced Portals administration, Velocity, LuckPerms, economy, player punishment, server stop, wildcards, destructive World lifecycle operations, Plugin/Config reload, and debug/internal administration remain excluded.

At the end of Builder work: confirm saved state, return to Survival, move to a safe location if needed, self-remove the Temporary Builder Parent, and verify loss of Builder permissions. Natural expiry is only a safety net and does not reset Creative/Spectator state. Remove one Role's Temporary Parent before joining the other. Admin full access ends when the Temporary Admin Parent is removed or expires; Windows, Docker, database, cold-backup, restore, and stopped-server startup remain outside Minecraft permissions.

Exact Eligibility nodes, assignment, bootstrap, recovery, rollback, Specific Deny policy, and acceptance evidence are in [Permission Model](12-permission-model.md). Server Console is reserved for bootstrap, permission-lockout recovery, and incident diagnosis.

## TAB network display

TAB 6.1.0 and VelocityScoreboardAPI 2.1.0 run only on Velocity. Lobby, Main, and Frontier run TAB-Bridge 6.2.2 with PlaceholderAPI 2.12.3; do not install the TAB main Plugin on a backend or the bridge/API Plugins on Velocity. The tracked TAB Config under `velocity/plugins/tab/` is the display source of truth.

The baseline enables only a `Project Wayfarer` header and a footer containing the current backend name, network online count, and player ping. After a Config or routing change, connect through Velocity and switch backends once to confirm that `%server%`, `%online%`, and `%ping%` resolve to values and that the footer follows the player. Sidebar, Bossbar, Layout, objectives, and custom prefix/suffix formatting remain disabled.

PlaceholderAPI Cloud access is disabled and no Expansion is installed. When an Expansion becomes necessary, obtain it manually under the Plugin artifact acquisition policy, document its exact version and placement, and verify it in a separate change. Minor display issues found during operation may be corrected in a later focused Commit.

## mcMMO shared progression

mcMMO 2.3.000 runs only on Main and Frontier. Both backends use the same locally built JAR and the shared MariaDB Database `wayfarer_mcmmo` with Table Prefix `mcmmo_`; Lobby and Velocity must not load it. Before startup, run `scripts/Render-LocalConfigs.ps1` to render each ignored Runtime `plugins/mcMMO/config.yml` from its tracked sanitized Template. Never print or commit the rendered credentials.

Use a normal server restart after mcMMO Config changes. Do not reload or unload mcMMO through PlugManX. During planned shutdown, move or disconnect players first and stop both gameplay backends normally so active Profiles are saved. A value rollback, duplicate addition, stale Profile overwrite, Profile load/save error, or database outage is a blocking data-integrity incident: stop gameplay, retain logs and a database backup, and do not continue progression testing until the cause is resolved.

MariaDB backups must include `wayfarer_mcmmo`. A representative health check is to record one skill's Level/XP on Main, switch normally to Frontier, confirm the same value, make one small authorized change, return to Main, and confirm the value is cumulative. Repeating every Skill is unnecessary.

## Waymark shared economy

RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 run only on Main and Frontier. Both use Redis database 0 with shared `clusterId: waymark`, internal Vault currency key `vault`, and distinct client names `main`／`frontier`. The Project display is Waymark (`WM`) with starting balance 0. Run `scripts/Render-LocalConfigs.ps1` before startup to render ignored RedisEconomy Runtime Configs from tracked sanitized templates; never print or commit the Redis Password.

Use full server restarts for RedisEconomy and Vault changes. Do not reload or unload RedisEconomy through PlugManX. Before planned shutdown, move or disconnect players and stop both gameplay backends normally. A balance rollback, duplicate transaction, missing balance, unexpected account split, or Redis persistence failure is a blocking data-integrity incident: stop gameplay, retain logs and a cold backup, and do not continue economy testing until the cause is resolved.

A representative health check is to record a balance on Main, apply one small authorized RedisEconomy administration change through Temporary Admin membership, switch normally to Frontier, confirm the same value, apply a second change, switch back, and confirm the cumulative result. Use Console only for exceptional recovery when in-game authority is unavailable. Restore the test balance with RedisEconomy's normal administration command; never edit or flush Redis keys directly.

## Main Waymark shop

EconomyShopGUI 7.1.1 Free runs only on Main and uses Vault with RedisEconomy as the active provider. The tracked adoption set is `plugins/EconomyShopGUI/config.yml`, `LanguageFiles/lang-jp.yml`, and the five files under each of `sections/` and `shops/`. Generated cache, transaction data, backups, other generated language files, and the archived `vendor-defaults-7.1.1/` tree remain ignored. Do not commit the JAR or restore Vendor defaults into the active section/shop directories.

Price and product changes require YAML validation, Material validation against the selected Main Paper build, a check that every overlapping buy price exceeds its sell price, and a normal Main restart. Do not use EconomyShopGUI reload, PlugManX, or Redis key edits. For an ordinary Config change, verify Enable, adopted section/shop loading, Vault/RedisEconomy integration, no startup-blocking error, and one `/shop` GUI open. Historical transaction and edge-case results remain in [Acceptance Tests](06-acceptance-tests.md) but are not the default standard for later routine shop edits. The complete fixed-price table and permission boundary are documented in [Waymark Economy](10-waymark-economy.md).

The initial shop disables update checking, transaction logging, spawner integration, `/sellall`, Sell GUI, editor/reload, and shop-give commands. Admin commands must remain inaccessible to the default group. If an actual defect appears—such as lost/duplicated items, balance rollback, or account split—treat that symptom as a reason for focused detailed investigation rather than pre-emptively repeating those cases for every ordinary change.

## Planned integrated operations

V0.1.0 requires a formal `Wayfarer.ps1` with Start, Stop, Restart, Status, and Backup actions. It must implement the shutdown order above, preserve startup dependency order, confirm user disconnection and process exit, create MariaDB dumps only after Minecraft shutdown, stop Redis before AOF copy, copy persistent Worlds/Frontier content/Config, record a Manifest and SHA-256 values, manage incomplete generations, and support an isolated restore test. Temporary Admin membership provides Console-equivalent authority only inside a running Runtime; stopped-server startup, post-stop restart, Docker Compose, MariaDB dump, Redis stop/AOF copy, cold backup, restore, and forced recovery remain Script/OS responsibilities. This Script and the V0.1.0 Baseline Backup are not implemented by Ver.0.0.5.

## Incident response

- Backend crash: Velocity should fail over to Lobby.
- Database unavailable: stop gameplay servers rather than accepting partially persisted progression.
- Redis or Waymark unavailable: stop Main/Frontier rather than accepting missing, duplicated, or partially persisted balances.
- Unknown custom item or Config mismatch: quarantine the change and restore the last compatible Plugin set.
- Main world corruption: do not experiment on the only backup; restore to a separate test path first.
