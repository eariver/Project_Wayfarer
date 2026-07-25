# Initial Installation Procedure

This is an execution summary. Follow the repository's [formal Ver.0.0.6 design guide](00-design-guide.md) for the authoritative design and acceptance policy. Ver.0.0.6 defines the future V0.1.0 Alpha completion conditions; it does not itself authorize Runtime changes.

The destructive Ver.0.0.6 replacement generation and Order 6 Final Main Baseline task have completed. Do not repeat either procedure or replace Main world data from this installation summary; use [Main World Baseline](13-main-world-baseline.md) for the authoritative identity, storage paths, spawn coordinates, acceptance record, and local rollback evidence.

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
10. Phase 1B will add the final command-focused Builder allowlist only after Ruined Frontier, Worlds Beyond, Multiverse-Inventories, ResourcePackManager, EliteMobs, Wayfarer_Core, Wayfarer_Main, Wayfarer_Frontier, any conditional Adapter, the adopted Gate／Portal permission model, and the exact Builder-owned Hub／Gate／Theme connection work are known. Until then, do not pre-grant WorldEdit, gamemode, teleport, Multiverse, WorldGuard administration, Velocity, LuckPerms, economy, player punishment, server stop, wildcard, reload/debug/internal, or destructive World lifecycle authority.

## Phase 6 - Lobby

1. Keep the existing protected Lobby entry world and safe platform until the user finishes the minimum Hub.
2. The user builds and fixes the Main and Frontier Gate structures, coordinates, orientation, and arrival areas.
3. In a later Gate Integration task, connect Lobby to Main's spawn hub and `frontier_gate` without guessing coordinates.
4. Verify all initial joins and backend failures end at Lobby when the routes are implemented.

## Phase 7 - Main world foundation and planned expansion

Multiverse-Core 5.7.2 is installed on all Paper backends, while Multiverse-NetherPortals 5.0.5 is installed only on Main. The existing Main dimensions are registered without moving or renaming their data. Main now loads the persistent and Resource families through their Paper namespaced keys, and the Nether/End links are explicitly stored in both directions within each family.

`resource_end` uses its actual Paper per-world Config at `servers/main/main/dimensions/minecraft/resource_end/paper-world.yml`, with legacy Ender Dragon scanning disabled. Do not change `paper-world-defaults.yml` or Main End for this policy.

The Waymark base is installed: RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 run only on Main and Frontier. `Render-LocalConfigs.ps1` renders their ignored Redis credential Configs from tracked sanitized templates. EconomyShopGUI 7.1.1 Free is installed only on Main and uses RedisEconomy through Vault. Its tracked `config.yml`, Japanese language file, five section files, and five shop files define the fixed-price Alpha baseline; the JAR and generated runtime data remain ignored.

BetterStructures 2.6.3, the 278-Structure Main five-Pack working set, BetterStructures Prop Pack, FreeMinecraftModels 2.10.2, and ResourcePackManager 2.3.0 are installed only on Main. Tracked `config.yml` and `ValidWorlds.yml` keep automatic Plugin download off, unknown worlds off, Persistent Main enabled by actual Bukkit name, and every Resource dimension disabled. JAR, import ZIP, extracted／normalized Schematic, Model, generated Resource Pack, Hosting URL, and Cache remain ignored. The V0.1.0 Ruined Frontier scope requires a separate Frontier installation and verification task.

Ver.0.0.6 replaced the persistent dimensions while retaining the approved safe spawn coordinates. Remaining Main work uses separate tasks in this order:

1. Completed 2026-07-25: verify the five approved Structure packs, BetterStructures Prop Pack, FreeMinecraftModels, ResourcePackManager, licenses, hashes, dependencies, World scope, Model IDs, and Main Pack delivery.
2. Completed 2026-07-25: import the complete approved working set and confirm every Plugin／Content dependency loads before World generation.
3. Completed 2026-07-25: replacement-generate only `main`, `main_nether`, and `main_the_end`; preserve and hash-verify the complete Resource family.
4. Completed 2026-07-25: Portals, safe Spawns, Main Resource Pack, four-Pack／three-dimension natural generation, Prop, identities, restart, no-tuning decision, and verified stopped-state Final Main Baseline backup passed.
5. Keep Order 7 CoreProtect deferred／non-blocking while Main／Lobby wait for a Minecraft 26.2-compatible Stable release; do not record an uninstalled Version in the manifests.
6. Continue with Order 8 Frontier lock, Builder Phase 1B, Owner-led construction, protection, and Gate routing in the [Roadmap](09-roadmap.md) order. Owner-only Hub／Gate work uses the retained Final Main Baseline Backup, focused Schematic／backup evidence, controlled edit units, and post-construction WorldGuard protection.

## Phase 8 - Shared mcMMO and planned Frontier expansion

EvenMoreFish 2.4.3 is installed only on Main from a manually acquired JAR. Set `MARIADB_EVENMOREFISH_USER` and `MARIADB_EVENMOREFISH_PASSWORD` in ignored `.env`, provision the dedicated `wayfarer_evenmorefish` database through the existing Compose initialization contract, and run `scripts/Render-LocalConfigs.ps1` before startup. Never place the JAR on Velocity, Lobby, or Frontier, and never commit the rendered credential Config. Changes require a normal full Main restart.

mcMMO 2.3.000 is installed only on Main and Frontier from the same local Maven build. Run `Render-LocalConfigs.ps1` after setting `.env`; this renders both ignored runtime Configs from sanitized templates. Both backends use `wayfarer_mcmmo` with the `mcmmo_` prefix. Do not install mcMMO on Lobby or Velocity, and do not reload it through PlugManX.

The following Frontier work is approved for V0.1.0 but not installed:

1. Lock exact Plugin／Content versions, licenses, hashes, World IDs, Gate method, Pack, persistence, and dependencies.
2. Design one external Gradle Multi-module Repository, then develop, release, and integrate Wayfarer_Core, Main, and Frontier under dedicated tasks. Wayfarer_Main and its Growth Pickaxe are Main-only.
3. Install the shared Frontier foundation, including MVI `neutral`／`worlds_beyond`／`guild`, Ruined-only MNP 5.0.5, Frontier ResourcePackManager, and the Beyond／Guild Gate boundary.
4. Determine whether EliteMobs Instances can use MVI static registration or strict Regex before authorizing the independent `Wayfarer_Frontier_EliteMobsMVI` Artifact.
5. Implement and verify both Ruined Frontier alpha and the single-World `frontier_iris` Worlds Beyond MVP. Do not create Worlds Beyond Nether／End Worlds or MNP links.
6. Keep all Main／Frontier and cross-MVI-group Items and normal Player State isolated; share only Waymark, mcMMO, and separately approved item-independent outcomes.
7. The user builds the Frontier Gate Hub and both Theme Gate／return structures; Codex configures routing only after exact arrivals are approved.

Ruined Frontier's initial BetterStructures Content is `Exploration Pack`, `Caves and Lost Civilizations Free`, `Echoes of the Past`, `Adventure Pack`, BetterStructures Prop Pack, Free Elite Shrines, and Dungeoneering Modules Free. Keep the full `103 Default Structures` pack disabled there by default; Main already provides it, and enabling it would dilute the high-difficulty pool. Any later individual Structure adoption requires a separate formal design and task.

Each Resource world also needs a post-reset Bootstrap design before V0.1.0: safe arrival, reproducible Return Gate to Main, Gate reconfiguration, Spawn/Arrival placement, optional protection, and persistent-world rejection. `resource_end` additionally requires a reproducible safe outer-island site independent of Dragon portals and End gateways.

## Phase 9 - Acceptance and V0.1.0 completion

Follow the ordered [Roadmap](09-roadmap.md), then run the release-blocker checklist in `docs/06-acceptance-tests.md`. Main Spawn protection, integrated Start／Stop／Restart／Status／Backup operations, a complete MariaDB／Redis／World／Config cold backup, and an isolated restore must succeed before the V0.1.0 Baseline is declared. Main／Lobby CoreProtect is temporarily excluded under Owner-only operation but must be re-evaluated before multi-player, multiple Builders, public operation, or large collaborative WorldEdit work. Git Tag／GitHub Release adoption is decided only at that final milestone.
