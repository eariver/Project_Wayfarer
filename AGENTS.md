# Project Wayfarer - Codex Operating Rules

## 1. Authorized workspace

The repository root opened in VS Code is the complete authorized filesystem workspace for this project.

Codex may freely read, create, edit, move, and delete files inside this repository when required by the assigned task, subject to the destructive-operation rules below.

## 2. Access outside the workspace

Do not read, enumerate, search, create, edit, move, or delete any file or directory outside the repository root without explicit user approval.

If access outside the repository is necessary:

1. Stop before accessing it.
2. State the exact path.
3. Explain why access is necessary.
4. State whether access is read-only or read/write.
5. Wait for explicit approval.

A general task instruction is not approval to access outside paths.

## 3. Executables and system changes

Programs already available through PATH may be executed without separate approval only when:

- their project output remains inside the repository;
- they do not modify user-wide or machine-wide configuration;
- they do not install software or packages outside the repository.

Ask before installing software, changing environment variables, modifying Git/Java/Gradle/Docker/VS Code user settings, or accessing another repository.

## 4. Network access

Network access may be used when necessary to resolve dependencies or consult official documentation. Do not download Plugin JARs, paid content, server binaries, or executable artifacts unless the task explicitly requests it and the user approves the source.

Prefer official PaperMC, Plugin-author, Modrinth, Hangar, GitHub release, or vendor pages.

## 5. Plugin binary acquisition policy

Codex must not download Plugin JARs, paid content, server binaries, or other
executable artifacts unless the current task explicitly authorizes automatic
download of that exact artifact.

The default workflow is:

1. the user obtains the artifact manually;
2. the user places it in an ignored repository-local staging directory;
3. Codex verifies the filename, version metadata, checksum, license, platform,
   and intended placement;
4. Codex copies the approved artifact to the required runtime directories.

Permission to research or verify a Plugin version is not permission to download
its JAR.

Permission to install, configure, test, or update documentation for a Plugin is
not permission to obtain or replace its JAR.

Codex must not enable Plugin auto-update or automatic binary replacement unless
an approved task explicitly requires it.

If a required artifact is missing, ambiguous, duplicated, corrupted, or the
wrong platform/version, stop and report the problem. Do not obtain a replacement
automatically.

## 6. Secrets and licensed files

Never commit passwords, tokens, forwarding secrets, private keys, paid Plugin files, paid content packs, or personal credentials.

Use `.env`, ignored local Config files, and `*.example` / `*.template` files. Do not copy secrets into logs or completion reports.

## 7. Destructive operations

Do not delete or overwrite persistent Main worlds, player data, database data, backups, secrets, or paid content unless the task explicitly requires it.

Resource-world reset operations must use the designated script and explicit confirmation switches. LAB reset operations may be destructive only after LAB is introduced and the task explicitly requests a reset.

Before deleting any world directory, report the exact resolved path and confirm that it matches an allowlisted disposable world.

## 8. Project invariants

- Project name: Project Wayfarer.
- Client version: Minecraft 26.2.
- Lobby and Main: Paper 26.2 / Java 25.
- Frontier: Paper 1.21.11 / Java 25.
- Proxy: Velocity 4.1.0 selected build / Java 25.
- ViaVersion 5.11.0 is installed on Velocity only and is verified for the selected Velocity 4.1.0-SNAPSHOT build.
- ViaVersion must not be installed on Paper backends unless a later approved design explicitly requires it.
- ViaBackwards must not be installed or referenced as a dependency.
- LuckPerms 5.5.60 is installed on Velocity and all Paper backends.
- All LuckPerms instances use the shared `wayfarer_luckperms` MariaDB database.
- LuckPerms uses SQL messaging for network update propagation.
- LuckPerms runtime configs containing database credentials must remain ignored and be rendered from sanitized templates.
- No other permission plugin may be installed without an approved migration task.
- TAB 6.1.0 is installed only on Velocity.
- VelocityScoreboardAPI 2.1.0 is installed only on Velocity.
- TAB-Bridge 6.2.2 and PlaceholderAPI 2.12.3 are installed on all Paper backends.
- TAB must not be installed on Paper backends.
- TAB-Bridge and PlaceholderAPI must not be installed on Velocity.
- Project Wayfarer uses TAB proxy installation, not mixed installation.
- PlaceholderAPI expansions follow the manual Plugin artifact acquisition policy.
- The baseline TAB display contains only the Project Wayfarer header and the server, online-player, and ping footer.
- All Paper backends bind to `127.0.0.2` and use Velocity modern forwarding.
- Lobby is the initial connection and failover server.
- WorldEdit 7.4.4 and WorldGuard 7.0.17 are installed on all Paper backends and must not be installed on Velocity.
- Lobby and `frontier_gate` are protected by their WorldGuard `__global__` regions with `passthrough` denied.
- Main currently has no Project Wayfarer WorldGuard regions or global protection flags.
- The LuckPerms `wayfarer_builder` group is the WorldGuard member allowed to build in protected entry worlds.
- WorldEdit and WorldGuard permissions for `wayfarer_builder` are restricted to `server=lobby` and `server=frontier`.
- Do not set the WorldGuard `build` flag on global regions.
- Adding Main protection requires a separately approved region design.
- Plugin executable artifacts follow the manual acquisition policy.
- VoidGen 2.3.8 is installed only on Lobby and Frontier; it must not be installed on Main or Velocity.
- The Lobby `lobby` world and Frontier `frontier_gate` entry world are VoidGen void worlds. Main worlds remain unchanged.
- Lobby and Frontier keep Nether and End disabled. Main keeps its designed Overworld, Nether, and End dimensions enabled.
- Each void entry world has a 17x17 stone safety platform at Y=63, a gold center block at `(0, 63, 0)`, and world spawn at `(0, 64, 0)`.
- Lobby and Frontier keep `keep_inventory=true` and respawn radius `0` while using the current void entry-world design.
- Do not regenerate either void entry world without an approved task, an exact resolved-path check, and a verified backup outside the source world path.
- Lobby shares no gameplay inventory, currency, mcMMO, or progression with Main/Frontier.
- Main and Frontier normal inventories are independent.
- RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 are installed only on Main and Frontier; Lobby and Velocity must not load either Plugin.
- Main and Frontier share Waymark balances through the existing Redis 8 service and use distinct Redis client names `main` and `frontier` in the same `waymark` cluster namespace.
- The RedisEconomy Vault currency key is `vault`; the Project logical identifier is `waymark`, the display name is `Waymark`, and the symbol is `WM`.
- RedisEconomy runtime Configs containing Redis credentials must remain ignored and be rendered from sanitized templates.
- RedisEconomy must not be reloaded or unloaded through PlugManX; use a normal server restart.
- A Waymark rollback, duplicate application, or loss is a blocking data-integrity failure.
- EconomyShopGUI 7.1.1 Free is installed only on Main and uses Vault with RedisEconomy as its provider; it must not be installed on Velocity, Lobby, or Frontier.
- The initial Main shop has five fixed-price categories (`sell_resources`, `sell_farming`, `sell_mob_drops`, `buy_building`, and `buy_supplies`) and 62 Vanilla-item entries. Dynamic pricing, global stock, player shops, tax, and automatic price adjustment remain disabled.
- General-player EconomyShopGUI permissions are scoped to `server=main`. Bulk sell, editor, reload, give, update, debug, bypass, and wildcard administration permissions must not be granted.
- EconomyShopGUI Config, Japanese language messages, section definitions, and shop definitions are tracked. Its JAR, cache, transaction/runtime data, generated backups, and archived vendor defaults remain ignored.
- Do not reload or unload EconomyShopGUI, RedisEconomy, or VaultUnlocked through PlugManX; use a normal Main restart after shop Config changes.
- Redis AOF storage is required in the V0.1.0-or-later cold-backup baseline. Do not adopt hot/warm backup Plugins, and copy the Redis volume filesystem only after the Redis container has stopped normally.
- mcMMO 2.3.000 is installed only on Main and Frontier. Lobby and Velocity must not load mcMMO.
- Main and Frontier use the same locally built mcMMO JAR with SHA-256 `03ABEEB48E33733C14859B4CAC6DC1104D19F15E4E81D9EB6B79D666F0E8A1B9`.
- Main and Frontier share mcMMO progression through the `wayfarer_mcmmo` MariaDB database and `mcmmo_` table prefix.
- mcMMO runtime Configs containing credentials must remain ignored and be rendered from sanitized templates.
- mcMMO must not be reloaded or unloaded through PlugManX; use a normal server restart.
- Player progression rollback or stale-profile overwrite during server switching is a blocking data-integrity failure.
- Main persistent dimensions: `main`, `main_nether`, `main_end`.
- Disposable resource dimensions: `resource`, `resource_nether`, `resource_end`.
- Multiverse-Core 5.7.2 is installed on all Paper backends and must not be installed on Velocity.
- Multiverse-NetherPortals 5.0.5 is installed only on Main.
- Lobby and Frontier currently register only their existing `lobby` and `frontier_gate` entry worlds.
- Existing persistent worlds must not be renamed, moved, copied, or recreated to match logical aliases.
- Main contains one persistent dimension family and one disposable Resource dimension family.
- Explicit Multiverse-NetherPortals links must not cross the persistent and Resource families.
- Only the Resource family may be targeted by reset operations.
- Runtime namespaced world keys are authoritative; documentation aliases are not filesystem paths.
- When introduced, BetterStructures must be enabled only in the persistent Main dimensions and disabled in all Resource dimensions.
- The planned Main hub provides independent direct gates to `resource`, `resource_nether`, and `resource_end`; every Resource world requires an explicit return gate to Main.
- `resource_end` must not spawn an Ender Dragon (`entities.spawning.scan-for-legacy-ender-dragon: false`). `main_end` keeps this setting enabled.
- Resource End routing must not depend on the Dragon exit portal or End gateways; use a verified safe outer-island destination.
- Frontier entry world remains simple and will provide portals only to approved, installed Frontier content worlds.
- Literal Twilight Forest Plugin support is not part of the plan.
- LAB is a future component and must not be added to the initial startup set without an approved task.
- This repository does not contain or develop custom Plugin source code.
- Custom Plugins, if required, are developed and released from separate repositories.
- This repository may contain only integration contracts, installation instructions, version constraints, and Config for external custom Plugins.
- Do not create Gradle, Maven, Java, or Kotlin Plugin projects in this repository.
- Do not add external Plugin repositories as Git submodules without explicit approval.
- PlugManX is a planned, unselected-version administration/development Plugin for Paper backends only; it is not installed and must not be placed on Velocity.
- Normal operation uses full server restarts. Any future PlugManX reload permission is admin-only and allowlist-based after Plugin-specific unload/reload verification.
- Do not enable the Minecraft Management Server while using the public placeholder secret. Generate and inject a local secret before enabling it.
- The current formal document revision is Ver.0.0.4. It defines the completion conditions for the future `V0.1.0 Alpha`; it is not a server release, tag, or GitHub Release.
- The Ver.0.0.4 permission model specifies permanent `default`, `wayfarer_builder_eligible`, and `wayfarer_admin_eligible` groups plus temporary `wayfarer_builder` and `wayfarer_admin` roles. This specification is not evidence that the new groups or permissions exist in the runtime database.
- Eligibility groups must remain equivalent to `default` for gameplay and may authorize only self-service temporary add/remove of their matching role. Exact LuckPerms nodes must be verified from LuckPerms 5.5.60 metadata and official documentation during the approved implementation task; do not guess them in advance.
- The planned Builder role is allowlist-based and the planned Admin role is full-access. Builder standard duration is 2 hours and Admin standard duration is 30 minutes, but neither duration is technically fixed in Ver.0.0.4. Permanent role grants and simultaneous temporary roles are not the intended operating model.
- Builder shutdown is operational in Ver.0.0.4: return to Survival, move to a safe position if needed, remove the temporary Builder parent, and verify loss of Builder permissions. Expiry alone does not reset gamemode.
- V0.1.0 requires one user-approved playable Frontier theme, but no theme is selected or installed by this specification. Frontier Waymark rewards, theme achievements, theme-specific inventories, and initial theme equipment remain deferred.
- Lobby, Main, Frontier Gate, Resource return-gate structures, and the Resource End outer-island structure are not built or connected by Ver.0.0.4. The user determines their appearance, coordinates, orientation, and safe arrivals before Codex configures routing.
- Every Resource-world reset design must restore a safe arrival, a return gate to the Main spawn hub, portal configuration, any required protection, and the Resource End outer-island safety structure without modifying persistent worlds.

## 9. Config editing policy

For third-party Plugins, do not invent configuration keys. First run the exact Plugin version once, inspect the generated Config and official documentation, then edit the generated file.

When a generated runtime Config contains secrets, maintain a sanitized `.template` or `.example` counterpart and keep the runtime file ignored.

Validate YAML, TOML, JSON, XML, PowerShell syntax, and Docker Compose syntax after editing where tooling is available.

## 10. Integration verification policy

For an ordinary officially distributed third-party Plugin, verify only the scope directly owned by the integration task:

1. exact version and platform;
2. official distribution source;
3. intended placement;
4. required dependencies;
5. successful enablement on the target runtime;
6. successful loading of the main Project Wayfarer-created or modified Config;
7. one representative adopted command or one GUI open;
8. absence of an obvious startup-blocking ERROR, SEVERE, or Exception;
9. Git exclusion of JARs, secrets, worlds, database data, logs, caches, and other runtime artifacts.

Do not require exhaustive Plugin quality assurance, every command, every Config key, every feature combination, inventory-full/reconnect/double-processing edge-case coverage, Plugin-author internal behavior testing, unrelated existing-Plugin regression tests, or broad Lobby/Main/Frontier/Velocity regression tests for an ordinary integration. The normal completion threshold is that the Plugin enables, the adopted Config loads, and one representative function works.

Use detailed, change-focused verification for locally built, source-modified, compatibility-patched, or Project-owned Plugins; observed defects; world lifecycle changes; database migrations; shared economy or progression foundation changes; cross-server inventory/item movement; permissions, secrets, connection paths, or security boundaries; protocol conversion; portal/dimension routing; backup/restore; failover; destructive or irreversible work; and tasks where the user explicitly requests detailed testing.

Regression testing is required only when the change directly modifies an existing foundation, and must be limited to that foundation—for example ViaVersion client access, LuckPerms boundaries, RedisEconomy shared balances, mcMMO shared progression, Advanced Portals routing, or backup stop/save/restore behavior. Avoid expanding scope through the ambiguous phrase “obvious regression.”

Plugins that share a feature area, dependency chain, placement, data boundary, and representative acceptance test may be introduced in one task. Minor non-security configuration issues discovered during small-scale operation may be corrected in a later focused commit.

## 11. User-input waiting policy

When a task requires manual in-game action or confirmation from the user, server processes may remain running independently, but Codex must stop active execution and clearly enter a user-input waiting state.

A running server process is not a reason to remain in a thinking or executing status. Do not block on an interactive console, continuous log tail, sleep loop, or foreground process while waiting for the user.

Before waiting:

- state the exact requested user action;
- state the expected result or information to report;
- leave servers in a safe independently running state;
- stop active execution.

After the user responds:

- verify that required server processes are still running;
- inspect relevant logs since the wait began;
- resume the task from the recorded checkpoint.

## 12. Git completion policy

For tasks performed entirely inside this repository, Codex may commit and push
completed changes without requesting an additional Git-only confirmation when
all of the following conditions are satisfied:

- all task-specific acceptance criteria have passed;
- required syntax, configuration, runtime, connection, and manual tests have
  completed successfully;
- any manual test explicitly assigned to the user has been confirmed by the
  user during the current task;
- no unresolved errors or material warnings remain;
- no secrets, JAR files, worlds, logs, database data, paid content, or other
  ignored runtime artifacts are staged;
- the final diff contains only intentional changes;
- the repository, current branch, and configured upstream have been verified.

If any condition is not satisfied, Codex must not commit or push. It must report
the problem and leave the working tree available for review.

Codex must never force-push, amend an existing commit, create a tag, or create a
release unless the task explicitly requires it.

After a successful push, report:

- commit SHA and commit message;
- branch and remote;
- changed files;
- validations and manual tests performed;
- any remaining manual action.
