# Initial Installation Procedure

This is an execution summary. Follow the repository's [formal Ver.0.0.5 design guide](00-design-guide.md) for the authoritative design and acceptance policy. Ver.0.0.5 defines the future V0.1.0 Alpha completion conditions; it does not itself authorize Runtime changes.

The destructive Phase 3 generation has already completed. Do not repeat the bare-generation procedure or replace Main world data from this installation summary; use [Main World Baseline](13-main-world-baseline.md) for the current persistent seed, storage paths, spawn coordinates, and local rollback evidence.

## Phase 0 - Prerequisites

1. Install Java 25 for Velocity and all Paper backends.
2. Install Git and VS Code with Codex.
3. Install Docker Desktop if MariaDB/Redis will run through Compose.
4. Clone this repository and open the repository root in VS Code.
5. Copy `.env.example` to `.env` and `local/paths.psd1.example` to `local/paths.psd1`.
6. Confirm Codex uses workspace-limited access and follows `AGENTS.md`.

## Phase 1 - Start MariaDB and Redis

```powershell
docker compose --env-file .env -f infrastructure/compose.yml up -d
.\scripts\Test-Infrastructure.ps1
```

The initialization script creates separate databases for LuckPerms, mcMMO sharing and future network metadata. LuckPerms and mcMMO use MariaDB; RedisEconomy uses the AOF-enabled Redis service for shared Waymark balances.

## Phase 2 - Manually collect server JARs

Download from official sources and rename locally:

- `velocity/velocity.jar`
- `servers/lobby/paper.jar`
- `servers/main/paper.jar`
- `servers/frontier/paper.jar`

The user obtains Plugin JARs from the official sources listed in `plugin-manifest.yml` and places them in an ignored task-specific directory under `manual-downloads/`. After Version, Platform, Metadata, SHA-256 and placement verification, Codex copies approved JARs to the target Runtime directories. Do not commit JARs or paid content.

## Phase 3 - Bare first boot

Run each component separately to generate default files. Accept the Minecraft EULA locally after reading it.

```powershell
.\scripts\Start-Component.ps1 -Name lobby
.\scripts\Start-Component.ps1 -Name main
.\scripts\Start-Component.ps1 -Name frontier
.\scripts\Start-Component.ps1 -Name velocity
```

Stop each component cleanly with `stop` before editing generated Config.

## Phase 4 - Forwarding and network connection

1. Generate one strong forwarding secret.
2. Put it in `velocity/forwarding.secret` and each Paper `config/paper-global.yml`.
3. Set backend `online-mode=false`, `server-ip=127.0.0.2`, and unique ports.
4. Set Velocity `player-info-forwarding-mode="modern"` and `try=["lobby"]`.
5. Enable unexpected-disconnect failover.
6. Install ViaVersion on Velocity. Do not install ViaBackwards.

## Phase 5 - LuckPerms baseline and implemented Phase 1A

1. Install the correct LuckPerms platform build on Velocity and all backends.
2. Configure all instances for the same MariaDB service.
3. Assign unique server names: `velocity`, `lobby`, `main`, `frontier`.
4. Use SQL messaging or another supported messaging service.
5. Set `argument-based-command-permissions: true` on all four instances. Set `enable-ops: false`, `auto-op: false`, and `commands-allow-op: false` on Paper only.
6. Phase 1A has already implemented and verified the five persistent Group definitions, matching self-only temporary Role control through Velocity, Admin full access, and OP-independent operation. Use [Permission Model](12-permission-model.md) as the exact node and recovery source of truth; do not blindly recreate Groups or permissions.
7. Preserve the reused `default` and `wayfarer_builder`. Do not delete/recreate `wayfarer_builder`, make it a Primary Group, or break its Lobby／Frontier WorldGuard Region Member references.
8. Keep the current Builder Role container limited to `group.default`. The former WorldEdit／WorldGuard administration wildcards are removed; membership-based protected-entry building remains.
9. Assign Eligibility only to an explicitly approved Player. Player membership in `wayfarer_builder` or `wayfarer_admin` must be temporary; do not use permanent Role Parents or OP.
10. Phase 1B will add the final command-focused Builder allowlist only after the Advanced Portals permissions, playable Frontier Theme, and Builder Hub／Gate work are known. Until then, do not pre-grant WorldEdit, gamemode, teleport, Multiverse, WorldGuard administration, Velocity, LuckPerms, economy, player punishment, server stop, wildcard, reload/debug/internal, or destructive World lifecycle authority.

## Phase 6 - Lobby

1. Keep the existing protected Lobby entry world and safe platform until the user finishes the minimum Hub.
2. The user builds and fixes the Main and Frontier Gate structures, coordinates, orientation, and arrival areas.
3. In a later Gate Integration task, connect Lobby to Main's spawn hub and `frontier_gate` without guessing coordinates.
4. Verify all initial joins and backend failures end at Lobby when the routes are implemented.

## Phase 7 - Main world foundation and planned expansion

Multiverse-Core 5.7.2 is installed on all Paper backends, while Multiverse-NetherPortals 5.0.5 is installed only on Main. The existing Main dimensions are registered without moving or renaming their data. Main now loads the persistent and Resource families through their Paper namespaced keys, and the Nether/End links are explicitly stored in both directions within each family.

`resource_end` uses its actual Paper per-world Config at `servers/main/main/dimensions/minecraft/resource_end/paper-world.yml`, with legacy Ender Dragon scanning disabled. Do not change `paper-world-defaults.yml` or Main End for this policy.

The Waymark base is installed: RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 run only on Main and Frontier. `Render-LocalConfigs.ps1` renders their ignored Redis credential Configs from tracked sanitized templates. EconomyShopGUI 7.1.1 Free is installed only on Main and uses RedisEconomy through Vault. Its tracked `config.yml`, Japanese language file, five section files, and five shop files define the fixed-price Alpha baseline; the JAR and generated runtime data remain ignored.

BetterStructures 2.6.3 and the manually imported free `103 Default Structures` pack are installed. Tracked `config.yml` and `ValidWorlds.yml` keep automatic Plugin download off, unknown worlds off, Persistent Main enabled by actual Bukkit name, and every Resource dimension disabled. JAR, import ZIP, extracted Schematic, generated content assets, and cache remain ignored.

Phase 3 has already finalized the three persistent dimensions and approved safe spawn coordinates; do not repeat generation. Remaining expansion uses separately approved tasks in this order:

1. Install CoreProtect before substantial Hub/Gate construction; keep rollback Admin-only and select its backend/database policy in that task.
2. Select and install one playable Frontier Theme, then select Advanced Portals and inspect its exact permissions.
3. Complete Builder Phase 1B from the known Theme, portal operations, and Builder-owned work.
4. The user builds the Main spawn Hub and its Lobby, Frontier, and three Resource Gate structures.
5. After the initial Hub is substantially complete, approve and apply the exact Main Spawn WorldGuard region; keep `spawn-protection=16` until the Region and Builder behavior pass verification.
6. Configure only the approved Gate routes after coordinates and safe arrivals are fixed.

## Phase 8 - Shared mcMMO and planned Frontier expansion

EvenMoreFish 2.4.3 is installed only on Main from a manually acquired JAR. Set `MARIADB_EVENMOREFISH_USER` and `MARIADB_EVENMOREFISH_PASSWORD` in ignored `.env`, provision the dedicated `wayfarer_evenmorefish` database through the existing Compose initialization contract, and run `scripts/Render-LocalConfigs.ps1` before startup. Never place the JAR on Velocity, Lobby, or Frontier, and never commit the rendered credential Config. Changes require a normal full Main restart.

mcMMO 2.3.000 is installed only on Main and Frontier from the same local Maven build. Run `Render-LocalConfigs.ps1` after setting `.env`; this renders both ignored runtime Configs from sanitized templates. Both backends use `wayfarer_mcmmo` with the `mcmmo_` prefix. Do not install mcMMO on Lobby or Velocity, and do not reload it through PlugManX.

The following Frontier work is not installed yet.

1. Compare playable-theme candidates for Paper 1.21.11／Java 25 compatibility, distribution model, License, cost, dependencies, Resource Pack, world layout, and actual exploration/combat/dungeon/quest play.
2. Obtain user approval and manually acquire the selected Theme and dependencies.
3. Install exactly one initial playable Theme for V0.1.0 and keep `frontier_gate` as its simple protected entrance.
4. Use the normal Frontier inventory and shared mcMMO. Do not add V0.1.0 WM rewards, achievements, Main-side rewards, theme-specific inventories, or initial equipment.
5. The user builds the Frontier Gate minimum hub and theme Gate/return structures; Codex configures routing only after exact arrivals are approved.

Each Resource world also needs a post-reset Bootstrap design before V0.1.0: safe arrival, reproducible Return Gate to Main, Gate reconfiguration, Spawn/Arrival placement, optional protection, and persistent-world rejection. `resource_end` additionally requires a reproducible safe outer-island site independent of Dragon portals and End gateways.

## Phase 9 - Acceptance and V0.1.0 completion

Follow the ordered [Roadmap](09-roadmap.md), then run the release-blocker checklist in `docs/06-acceptance-tests.md`. CoreProtect, Main Spawn protection, integrated Start／Stop／Restart／Status／Backup operations, a complete MariaDB／Redis／World／Config cold backup, and an isolated restore must succeed before the V0.1.0 Baseline is declared. Git Tag／GitHub Release adoption is decided only at that final milestone.
