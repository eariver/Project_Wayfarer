# Operations

The authoritative design, task-grouping rules and risk-based verification policy are defined in the [Ver.0.0.4 design guide](00-design-guide.md).

## Startup order

1. MariaDB and Redis
2. Lobby
3. Main
4. Frontier
5. Velocity

The provided `Start-All.ps1` follows this order. It opens separate processes and does not treat process launch as a successful health check.

## Shutdown

Use each server console's `stop` command. Shut down Velocity last for planned maintenance, or transfer players to Lobby first when maintaining Main/Frontier.

## Backups

Back up at minimum:

- Main persistent worlds
- Frontier worlds and Plugin data
- Plugin Config
- MariaDB dump
- RedisEconomy Config templates and the stopped Redis AOF volume
- resource-pack sources

Resource worlds are disposable and may be excluded from long-term backups.

Waymark balances are persistent Redis data. Do not copy `infrastructure/data/redis` while Redis is running and do not introduce a hot/warm backup Plugin. For a cold backup, disconnect all users, wait about 10 seconds for in-flight work to settle, stop all Paper servers normally, create the MariaDB dump, stop the Redis Container normally, confirm that its process has stopped, and only then copy the Redis AOF volume. Start Redis again only after the copy has completed. The V0.1.0 Baseline is incomplete without MariaDB dumps, the Redis AOF volume, persistent worlds/Config, a manifest with SHA-256 values, and an isolated restore test.

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

Use the namespaced keys for runtime diagnosis. `main_end` is a logical Multiverse alias, not a filesystem path. World access enforcement, gamemode enforcement, and flight enforcement remain disabled so that Multiverse does not replace existing backend access or player-state behavior. World creation, import, property changes, `/mvtp`, and link administration remain console/administrator operations.

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

WorldEdit 7.4.4 and WorldGuard 7.0.17 use the same verified Bukkit JARs on Lobby, Main, and Frontier; neither Plugin is installed on Velocity. Lobby and `frontier_gate` protect their entire entry worlds with `__global__` regions that deny `passthrough` and include the LuckPerms group `wayfarer_builder` as their only member. The group receives `worldedit.*` and `worldguard.*` only in the `server=lobby` and `server=frontier` contexts.

Main has the administration Plugins installed but currently has no Project Wayfarer protection Region or Global Region Flag. Normal Survival building remains available there, and `wayfarer_builder` receives no Main WorldEdit or WorldGuard permission. Add Main protection only after a separate World/Region design is approved.

Do not use the WorldGuard `build` flag, because it bypasses normal membership-based build behavior and can interfere with non-player mechanisms. The current `wayfarer_builder` membership and Context are a verified baseline, not the completed Ver.0.0.4 role model. Eligibility groups, self-only Temporary Parent control, the expanded Builder Allowlist, and temporary Admin full access require a separate approved Security Boundary implementation task.

## Planned temporary role operation

The Ver.0.0.4 model is not implemented yet. When it is implemented, `wayfarer_builder_eligible` may add/remove only its own temporary `wayfarer_builder` parent, and `wayfarer_admin_eligible` may do the same only for `wayfarer_admin`. Builder uses 2 hours and Admin 30 minutes as standard values supplied with the temporary grant; they are not technically fixed. Eligibility itself remains `default`-equivalent and cannot grant permanent parents, affect other players, or assign arbitrary groups/permissions.

At the end of Builder work: confirm saved state, return to Survival, move to a safe location if needed, self-remove the temporary Builder parent, and verify loss of Builder permissions. Natural expiry is only a safety net and does not reset Creative/Spectator state. Remove one temporary role before taking another. Admin full access ends with its temporary parent; Windows, Docker, database, cold-backup, restore, and stopped-server startup remain outside Minecraft permissions.

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

A representative health check is to record a balance on Main, apply one small authorized Console change, switch normally to Frontier, confirm the same value, apply a second change, switch back, and confirm the cumulative result. Restore the test balance with RedisEconomy's normal administration command; never edit or flush Redis keys directly.

## Main Waymark shop

EconomyShopGUI 7.1.1 Free runs only on Main and uses Vault with RedisEconomy as the active provider. The tracked adoption set is `plugins/EconomyShopGUI/config.yml`, `LanguageFiles/lang-jp.yml`, and the five files under each of `sections/` and `shops/`. Generated cache, transaction data, backups, other generated language files, and the archived `vendor-defaults-7.1.1/` tree remain ignored. Do not commit the JAR or restore Vendor defaults into the active section/shop directories.

Price and product changes require YAML validation, Material validation against the selected Main Paper build, a check that every overlapping buy price exceeds its sell price, and a normal Main restart. Do not use EconomyShopGUI reload, PlugManX, or Redis key edits. For an ordinary Config change, verify Enable, adopted section/shop loading, Vault/RedisEconomy integration, no startup-blocking error, and one `/shop` GUI open. Historical transaction and edge-case results remain in [Acceptance Tests](06-acceptance-tests.md) but are not the default standard for later routine shop edits. The complete fixed-price table and permission boundary are documented in [Waymark Economy](10-waymark-economy.md).

The initial shop disables update checking, transaction logging, spawner integration, `/sellall`, Sell GUI, editor/reload, and shop-give commands. Admin commands must remain inaccessible to the default group. If an actual defect appears—such as lost/duplicated items, balance rollback, or account split—treat that symptom as a reason for focused detailed investigation rather than pre-emptively repeating those cases for every ordinary change.

## Planned integrated operations

V0.1.0 requires a formal `Wayfarer.ps1` with Start, Stop, Restart, Status, and Backup actions. It must preserve the existing dependency order and cold-backup sequence, confirm user disconnection and process exit, create MariaDB dumps, stop Redis before AOF copy, copy persistent worlds/Config, record a manifest and SHA-256 values, manage incomplete generations, and support an isolated restore test. This script and the V0.1.0 Baseline Backup are not implemented by Ver.0.0.4.

## Incident response

- Backend crash: Velocity should fail over to Lobby.
- Database unavailable: stop gameplay servers rather than accepting partially persisted progression.
- Redis or Waymark unavailable: stop Main/Frontier rather than accepting missing, duplicated, or partially persisted balances.
- Unknown custom item or Config mismatch: quarantine the change and restore the last compatible Plugin set.
- Main world corruption: do not experiment on the only backup; restore to a separate test path first.
