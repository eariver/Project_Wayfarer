# Codex Task: Bootstrap MariaDB and Redis

## Objective

Validate and start the local Docker Compose infrastructure for Project Wayfarer without modifying files outside the repository.

## Allowed scope

- `.env` only if it already exists and the user explicitly permits secret replacement
- `infrastructure/`
- `scripts/Test-Infrastructure.ps1`
- `docs/02-installation.md`

## Out of scope

- Server and Plugin JAR downloads
- Docker Desktop installation or global configuration
- Windows environment variables
- Any directory outside the repository

## Requirements

1. Validate `infrastructure/compose.yml` with Docker Compose.
2. Confirm services bind only to `127.0.0.2` host ports.
3. Start MariaDB and Redis using `.env`.
4. Confirm health checks pass.
5. Confirm databases `wayfarer_luckperms`, `wayfarer_mcmmo`, and `wayfarer_network` exist.
6. Do not print passwords in the completion report.

## External access rule

If Docker is not installed, inaccessible, or requires access outside the repository, stop and ask the user. State the exact command or path required.

## Completion report

Report validation commands, service status, database names, files changed and unresolved issues. Do not commit or push.
