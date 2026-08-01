# Wayfarer_Core V0.0.1 Integration Foundation

Status: approved project input, not installed in production

Date: 2026-08-01

## Release identity

- Release: `V0.0.1`
- Artifact: `Wayfarer_Core-V0.0.1.jar`
- Release: https://github.com/eariver/Project-Wayfarer-Plugins/releases/tag/V0.0.1
- SHA-256: `B045581D3984DDDBA10ED7B2ADA435926B8538BA9B29A1151550CE59588395A2`
- Product source commit: `49e00e21716c1c13a2dbb170fdad1b19c4275612`
- Handoff commit: `efe9d81029a10ce9ca0ce01f9c6770a4991784bc`
- Config version: `1`
- Highest migration: `V003`

The release package contains stale historical test snapshots. This phase records that as a known limitation and does not rewrite vendor release evidence.

## Project boundaries

Wayfarer_Core is planned for Paper Main and Paper Frontier only. Its shared database authority is the existing MariaDB database `wayfarer_network`, with tables in the `wf_core_*` namespace and Flyway locations `db/migration/core`. Production IDs are `main` and `frontier`; the compatibility probe uses `main-probe` and a task-only database.

Wayfarer_Core uses Vault／ServicesManager for the Waymark provider boundary. It must not read RedisEconomy keys directly. Redis is a Core coordination dependency with the fixed `wayfarer` key prefix; the Project's Waymark authority remains the existing RedisEconomy／Vault integration.

## Configuration and secrets

Tracked sanitized templates are provided at:

- `servers/main/plugins/Wayfarer_Core/config.yml.template`
- `servers/frontier/plugins/Wayfarer_Core/config.yml.template`

Runtime `config.yml` is ignored. `scripts/Render-WayfarerCoreConfig.ps1` renders only from process-local environment variables, validates the exact release contract, fails closed on missing／blank／placeholder values, and never emits secret values. `scripts/Wayfarer-CoreEnvironment.ps1` supplies process-local values from the existing ignored Project `.env`; it does not print or persist them.

The templates use `server-id: main`／`frontier`, MariaDB `wayfarer_network`, Redis URI without a guessed database index, migration `db/migration/core`, and the exact release environment variable names. Audit is enabled in the foundation templates so the durable Core audit／identity path is exercised in the isolated probe; Phase 2 owner review must confirm the production rollout policy.

## Acceptance boundary

The isolated Paper 26.2 build 62／Java 25 probe passed first boot, fresh V001–V003 migration, second boot Validate／No-op, safe Vault／RedisEconomy provider health, clean disable, and task-only cleanup. No Main or Frontier production JAR, runtime Config, permission, MariaDB schema, Redis key, world, or player state was changed.

Production installation requires the approved Phase 2 stopped-state backup, Main-first migration, Frontier validation／no-op, restart acceptance, and the remaining production tests. This document does not authorize those operations.
