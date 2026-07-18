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

## 5. Secrets and licensed files

Never commit passwords, tokens, forwarding secrets, private keys, paid Plugin files, paid content packs, or personal credentials.

Use `.env`, ignored local Config files, and `*.example` / `*.template` files. Do not copy secrets into logs or completion reports.

## 6. Destructive operations

Do not delete or overwrite persistent Main worlds, player data, database data, backups, secrets, or paid content unless the task explicitly requires it.

Resource-world reset operations must use the designated script and explicit confirmation switches. LAB reset operations may be destructive only after LAB is introduced and the task explicitly requests a reset.

Before deleting any world directory, report the exact resolved path and confirm that it matches an allowlisted disposable world.

## 7. Project invariants

- Project name: Project Wayfarer.
- Client version: Minecraft 26.2.
- Lobby and Main: Paper 26.2 / Java 25.
- Frontier: Paper 1.21.11 / Java 21 until a later design revision changes it.
- Proxy: Velocity 4.1.0 selected build / Java 25.
- ViaVersion 5.11.0 is installed on Velocity only and is verified for the selected Velocity 4.1.0-SNAPSHOT build.
- ViaVersion must not be installed on Paper backends unless a later approved design explicitly requires it.
- ViaBackwards must not be installed or referenced as a dependency.
- All Paper backends bind to `127.0.0.2` and use Velocity modern forwarding.
- Lobby is the initial connection and failover server.
- Lobby shares no gameplay inventory, currency, mcMMO, or progression with Main/Frontier.
- Main and Frontier normal inventories are independent.
- Main and Frontier share only explicitly designed network data: initially Waymark and mcMMO.
- Network currency display name: `Waymark`; symbol: `WM`; internal identifier: `waymark`.
- Main persistent dimensions: `main`, `main_nether`, `main_end`.
- Disposable resource dimensions: `resource`, `resource_nether`, `resource_end`.
- BetterStructures is enabled only in the persistent Main dimensions and disabled in all Resource dimensions.
- Main hub provides independent direct gates to `resource`, `resource_nether`, and `resource_end`; every Resource world has an explicit return gate to Main.
- `resource_end` must not spawn an Ender Dragon (`entities.spawning.scan-for-legacy-ender-dragon: false`). `main_end` keeps this setting enabled.
- Resource End routing must not depend on the Dragon exit portal or End gateways; use a verified safe outer-island destination.
- Frontier entry world is simple and provides portals to installed Frontier content worlds.
- Literal Twilight Forest Plugin support is not part of the plan.
- LAB is a future component and must not be added to the initial startup set without an approved task.
- This repository does not contain or develop custom Plugin source code.
- Custom Plugins, if required, are developed and released from separate repositories.
- This repository may contain only integration contracts, installation instructions, version constraints, and Config for external custom Plugins.
- Do not create Gradle, Maven, Java, or Kotlin Plugin projects in this repository.
- Do not add external Plugin repositories as Git submodules without explicit approval.
- Do not enable the Minecraft Management Server while using the public placeholder secret. Generate and inject a local secret before enabling it.

## 8. Config editing policy

For third-party Plugins, do not invent configuration keys. First run the exact Plugin version once, inspect the generated Config and official documentation, then edit the generated file.

When a generated runtime Config contains secrets, maintain a sanitized `.template` or `.example` counterpart and keep the runtime file ignored.

Validate YAML, TOML, JSON, XML, PowerShell syntax, and Docker Compose syntax after editing where tooling is available.

## 9. Git completion policy

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
