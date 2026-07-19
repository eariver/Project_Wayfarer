# Initial Installation Procedure

This is an execution summary. Follow the formal Ver.0.0.2 design document for full acceptance criteria.

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

The initialization script creates separate databases for LuckPerms, mcMMO and future network metadata.

## Phase 2 - Manually collect server JARs

Download from official sources and rename locally:

- `velocity/velocity.jar`
- `servers/lobby/paper.jar`
- `servers/main/paper.jar`
- `servers/frontier/paper.jar`

Download Plugin JARs listed in `plugin-manifest.yml` and place them into each target `plugins/` directory. Do not commit JARs or paid content.

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

## Phase 7 - Main

1. Install Multiverse-Core and Multiverse-NetherPortals.
2. Create and link `main`, `main_nether`, `main_end`.
3. Create and link `resource`, `resource_nether`, `resource_end`.
4. Install mcMMO, RedisEconomy, VaultUnlocked, EconomyShopGUI and EvenMoreFish.
5. Install BetterStructures before exploring persistent dimensions.
6. Restrict BetterStructures to `main`, `main_nether`, `main_end` only.
7. Apply Overworld, Nether and End-specific structure packs.
8. Verify Resource worlds contain only vanilla structures.

## Phase 8 - Frontier

1. Install the 1.21.11-compatible builds.
2. Keep `frontier_gate` simple.
3. Install EliteMobs and selected ready-made Adventure packs.
4. Add multiple themes only after each passes a clean-server acceptance test.
5. Configure a separate Frontier resource pack if required.
6. Keep Main/Frontier inventories separate.
7. Verify shared Waymark and mcMMO persistence.

## Phase 9 - Acceptance

Run the checklist in `docs/06-acceptance-tests.md`. Back up the clean baseline before normal play.
