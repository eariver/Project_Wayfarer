# Architecture Summary

## Logical topology

```text
Minecraft Client 26.2
        |
        v
Velocity :25565
  |-- Lobby :25566 / Paper 26.2 / Java 25
  |-- Main :25567 / Paper 26.2 / Java 25
  `-- Frontier :25568 / Paper 1.21.11 / Java 21

MariaDB: LuckPerms, mcMMO, future network metadata
Redis: RedisEconomy and optional chat transport
```

All backend servers bind to `127.0.0.2`. Velocity is the only player-facing endpoint. Modern forwarding is mandatory.

## Data boundaries

| Data | Lobby | Main | Frontier |
|---|---|---|---|
| Normal inventory | Local only | Local only | Local only |
| Ender chest / XP / health | Local only | Local only | Local only |
| LuckPerms identity | Shared | Shared | Shared |
| Global chat and TAB | Shared | Shared | Shared |
| Waymark | Not used | Shared with Frontier | Shared with Main |
| mcMMO | Not installed | Shared with Frontier | Shared with Main |
| EvenMoreFish | No | Main only | No |
| Frontier achievements | Future | Future consumer | Future producer |
| Transit vault | Future | Future | Future |

## Main worlds

Persistent and buildable:

- `main`
- `main_nether`
- `main_end`

Disposable resource worlds, almost vanilla and without Plugin-added structures:

- `resource`
- `resource_nether`
- `resource_end`

BetterStructures is enabled only for the persistent trio with dimension-specific packs.

## Frontier

`frontier_gate` is a simple portal hub. It connects to several ready-made Adventure worlds/themes. Frontier inventories and custom equipment remain local to Frontier in Ver.0.0.2. Frontier rewards Main through the shared Waymark balance.

## Future components

- Cross-server transit vault for allowlisted common items
- Main-authenticated expedition gear slots
- Frontier achievements and Main memorial rewards
- Frontier local expanded storage
- Custom shop
- Tutorial and advanced AFK routing
- Disposable creative LAB server
