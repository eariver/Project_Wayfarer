# Operations

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
- RedisEconomy persistence/config according to its documented storage model
- resource-pack sources

Resource worlds are disposable and may be excluded from long-term backups.

## Resource reset

Use `Reset-ResourceWorlds.ps1` only while Main is stopped. The script refuses to operate without an explicit confirmation switch and allowlisted world names.

## Updates

1. Check the target Minecraft/server/Plugin compatibility matrix.
2. Clone or copy the current installation into a staging directory inside the workspace.
3. Back up persistent data.
4. Update one layer at a time.
5. Run acceptance tests.
6. Never downgrade TAB Config or a world without a supported rollback plan.

## Incident response

- Backend crash: Velocity should fail over to Lobby.
- Database unavailable: stop gameplay servers rather than accepting partially persisted progression.
- Unknown custom item or Config mismatch: quarantine the change and restore the last compatible Plugin set.
- Main world corruption: do not experiment on the only backup; restore to a separate test path first.
