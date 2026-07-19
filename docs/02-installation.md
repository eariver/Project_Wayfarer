# Initial Installation Procedure

This is an execution summary. Follow the repository's [formal Ver.0.0.3 design guide](00-design-guide.md) for the authoritative design and acceptance policy.

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

The initialization script creates separate databases for LuckPerms, future mcMMO sharing and future network metadata. Only the LuckPerms database is currently used by a Plugin.

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

## Phase 5 - LuckPerms

1. Install the correct LuckPerms platform build on Velocity and all backends.
2. Configure all instances for the same MariaDB service.
3. Assign unique server names: `velocity`, `lobby`, `main`, `frontier`.
4. Use SQL messaging or another supported messaging service.
5. Create minimal groups: `default`, `tester`, `admin`.
6. Avoid relying on OP for normal operation.

## Phase 6 - Lobby

1. Use a single protected Lobby world.
2. Set Adventure mode, disable building and harmful mechanics.
3. Add one physical or command-based gate to Main.
4. Verify all initial joins and backend failures end at Lobby.

## Phase 7 - Main world foundation and planned expansion

Multiverse-Core 5.7.2 is installed on all Paper backends, while Multiverse-NetherPortals 5.0.5 is installed only on Main. The existing Main dimensions are registered without moving or renaming their data. Main now loads the persistent and Resource families through their Paper namespaced keys, and the Nether/End links are explicitly stored in both directions within each family.

`resource_end` uses its actual Paper per-world Config at `servers/main/main/dimensions/minecraft/resource_end/paper-world.yml`, with legacy Ender Dragon scanning disabled. Do not change `paper-world-defaults.yml` or Main End for this policy.

The remaining expansion requires separately approved tasks:

1. Install mcMMO, RedisEconomy, VaultUnlocked, EconomyShopGUI and EvenMoreFish.
2. Install BetterStructures before exploring additional persistent-dimension chunks.
3. Restrict BetterStructures to `main`, `main_nether`, `main_end` only.
4. Apply Overworld, Nether and End-specific structure packs.
5. Verify Resource worlds remain free of Plugin-added structures.

## Phase 8 - Planned Frontier expansion

The following components and shared-data integrations are not installed yet.

1. Install the 1.21.11-compatible builds.
2. Keep `frontier_gate` simple.
3. Install EliteMobs and selected ready-made Adventure packs.
4. Add multiple themes only after each passes a clean-server acceptance test.
5. Configure a separate Frontier resource pack if required.
6. Keep Main/Frontier inventories separate.
7. After their future installation, verify shared Waymark and mcMMO persistence using risk-focused data tests.

## Phase 9 - Acceptance

Run the checklist in `docs/06-acceptance-tests.md`. Back up the clean baseline before normal play.
