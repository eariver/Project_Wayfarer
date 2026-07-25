# Main Ver.0.0.6 Persistent Family replacement generation

Date: 2026-07-25

Result: replacement generation succeeded; limited acceptance
Pre-execution Git HEAD: `c6a5d27c5410666c1cde436d1b6986ebbd334cf8`

## Outcome

The approved one-time task replaced only the persistent Bukkit worlds `main`,
`main_nether`, and `main_the_end` after all five BetterStructures Content packs
had loaded. The complete Resource family was copied from a verified rollback
source before first boot and remained excluded from BetterStructures.

The generated family is the **Current Runtime Candidate**. It is not the Final
V0.1.0 Main Baseline. This replacement-generation run observed natural
generation from Default, Caves and Lost Civilizations Free, and Echoes of the
Past, but not from a fourth distinct Pack within its final bounded-exploration
limits. A later bounded follow-up accepted Exploration Pack
`betterstructures_exploration_bridgecave_shallow` and completed Order 5; see
[the fourth-Pack report](2026-07-25-main-fourth-pack-natural-generation.md).
Order 6 Weight／Content tuning and the final baseline backup remain.

## Authorization and destructive boundary

- Player Data Policy: A, Complete Reset.
- Exact approval received:
  `APPROVE-WAYFARER-MAIN-V006-REPLACEMENT-GENERATION`.
- Moved source:
  `servers/main/main/`.
- Replacement scope:
  `dimensions/minecraft/{overworld,the_nether,the_end}` plus the persistent
  container metadata required for a clean generation.
- Explicitly preserved:
  `resource`, `resource_nether`, `resource_end`, Plugin Content, credentials,
  MariaDB, Redis, Waymark, mcMMO, LuckPerms, and EvenMoreFish data.
- No force stop, pregeneration, manual Structure paste, Chunk Pregenerator,
  World Border change, executable download, Content download, database
  migration, or Redis mutation was used.

The task-specific
`scripts/Invoke-MainV006ReplacementBackup.ps1` fails closed on repository
boundary, exact source and backup paths, protected Ports, `session.lock`,
expected seed, Content-lock hashes, confirmation token, and same-volume move
requirements. Its dry run passed before the approved execution.

## Backup and rollback evidence

Rollback root:

```text
backups/main-v006-replacement-generation-20260725-154934/
```

| Evidence | Value |
| --- | --- |
| Payload entries | 181 |
| Payload bytes | 99,480,548 |
| Manifest SHA-256 | `C79C2FC3ECBA998D875200E1D29B1B82B9BE97808B965E28D74B60108F62B118` |
| SHA list SHA-256 | `037DA91AC7451957DFF57D0F8B3B7592233E5A7A2CC699A4CC709AAB1739B969` |
| Pre-generation validation | 181／181 passed |
| Post-acceptance validation | 181／181 passed |

The complete replaced Main container is under `payload/world/main`. Selected
Config snapshots, preflight evidence, and rollback instructions are stored
beside it. The backup is ignored and local; it is not available from GitHub.

The last finalized 2026-07-21 baseline remains separately available locally at
`backups/main-final-generation-20260721-001501/` with manifest SHA-256
`50B0F6244223DA68B752407BBE89127E0CE49645F7673A5FF929EE9C5B8A3C9D`.

## Generated identity

All persistent dimensions retained seed `164225356311935743`.

| Dimension | Bukkit world | Namespaced key | UUID | Multiverse spawn |
| --- | --- | --- | --- | --- |
| Overworld | `main` | `minecraft:overworld` | `d868e7ff-6663-492d-a963-f95f00ce6c30` | `(320, 70, 128)` |
| Nether | `main_nether` | `minecraft:the_nether` | `1225688f-7770-43ed-b1dd-71bd112de3b5` | `(20.5, 60, -19.5)` |
| End | `main_the_end` | `minecraft:the_end` | `436843c4-2229-4c67-907c-b3a7d1530d71` | `(100.5, 49, 0.5)` |

Storage remained:

```text
servers/main/main/dimensions/minecraft/overworld
servers/main/main/dimensions/minecraft/the_nether
servers/main/main/dimensions/minecraft/the_end
```

`main_end` remains only the Multiverse alias for `main_the_end`.

Complete Reset produced no retained Vanilla playerdata, advancements, or stats
in the new container. Shared external progression and permission stores were
outside the reset scope.

## Resource-family preservation

The restored Resource UUIDs and seeds remained:

| World | UUID | Seed | Region count |
| --- | --- | ---: | ---: |
| `resource` | `32497466-e0eb-4992-806d-f58011cad5d8` | `619713275114720998` | 8 |
| `resource_nether` | `3b494c31-7c24-49a6-a6c0-2891643086a0` | `-7678977951546477015` | 4 |
| `resource_end` | `8c140721-4bbf-4fd3-8837-d250fd73bba3` | `-2348607286205551648` | 4 |

All 16 `region/*.mca` SHA-256 values matched the replacement backup before
generation, after Client acceptance, and after the clean restart. Normal
runtime saves changed only the expected `raids.dat`, `weather.dat`,
`world_clocks.dat`, and Paper `level_overrides.dat` subset. No Resource Region
changed, no Resource Region was added, and BetterStructures remained disabled.

Multiverse-NetherPortals retained family-local links:

```text
main ↔ main_nether
main ↔ main_the_end

resource ↔ resource_nether
resource ↔ resource_end
```

No persistent／Resource cross-link exists.

## BetterStructures, FMM, and Resource Pack

The replacement boot loaded:

- BetterStructures 2.6.3;
- WorldEdit 7.4.4;
- 103 Default Structures version 5;
- Exploration Pack version 6;
- Caves and Lost Civilizations Free version 2;
- Adventure Pack internal version 1;
- Echoes of the Past version 3;
- 278 enabled and 152 disabled Structure configurations;
- FreeMinecraftModels 2.10.2 with 55 BetterStructures Prop models;
- ResourcePackManager 2.3.0.

The existing five-Pack preflight passed again after restart, including all
locked source, selection, normalization, generated-import, and mapping hashes.
No failed Schematic, unresolved Model ID, duplicate ID, or startup-blocking
error was found.

BetterStructures initially presented its first-time setup prompt because
`setupDone` was false. The user selected **Use Current Content**, which retained
the installed five-Pack state and changed only tracked `setupDone: true`.
Automatic Plugin download remains disabled.

Final stopped-state generated Pack evidence:

| Pack | Bytes | SHA-1 | SHA-256 |
| --- | ---: | --- | --- |
| Main Java pack | 839,097 | `07BD5FA29729344F9B9A1DBA3774ACDDC6966655` | `A2E4999A6A00A0458570A379487BB78E3FEEA926829627C6BB3A9660FA7565C3` |
| FMM component pack | 799,654 | `87159F4588C83E6743A12BDDCE84CCA866F3B027` | `7930BAB098A7A26DFFBCD23200D6C06CB339C115412C50DAC6D3C2060E875B6E` |

These generated artifacts and the temporary hosting identity remain ignored.

## Bounded natural-generation acceptance

Confirmed representative natural generation:

| Dimension | Pack | Structure | Result |
| --- | --- | --- | --- |
| Overworld | Default | `betterstructures_mine_storage_deep` | Mine storage rendered normally |
| Overworld | Caves and Lost Civilizations Free | `bs_lostcivilizations_free_circledungeon_dripstone` | Large dripstone dungeon rendered normally |
| Nether | Echoes of the Past | `betterstructures_echoes_wall_nether` | Crimson／Nether-brick wall rendered normally |
| End | Echoes of the Past | `betterstructures_echoes_shrine_end` | Shrine, Spawner, and FMM Props persisted |

The user amended the original limits only for End:

- Overworld and Nether were not to generate further acceptance Regions;
- End cumulative new-Region limit became 16;
- total cumulative new-Region limit became 32;
- End search time became 45 minutes;
- exploration had to stop after one End BetterStructures Structure.

Final Region counts were:

| Dimension | Initial | Final | New |
| --- | ---: | ---: | ---: |
| Overworld | 4 | 11 | 7 |
| Nether | 4 | 11 | 7 |
| End | 4 | 18 | 14 |
| Total | 12 | 40 | 28 |

The End search stopped immediately after the Echoes Shrine. Vanilla outer
islands and an End Ship also generated normally without abnormal density. At
the end of this run, the fourth distinct Pack remained unconfirmed; the later
fourth-Pack follow-up completed that evidence without changing this run's
historical bounds.

## Spawn, respawn, and Portal acceptance

- Overworld spawn remained safe and clear of a BetterStructures placement
  within the retained 100-block protection radius.
- Nether administrative spawn matched the previously approved safe location.
- End administrative spawn remained the default obsidian platform; normal
  Dragon state remained enabled.
- A bedless death returned to the Overworld spawn safely.

For changed-path Portal acceptance, the task created a temporary paired Portal
and platform in already generated high-altitude chunks:

```text
Main:   around (352, 150, 128)
Nether: around (44, 150, 16)
```

The Client completed Main → Nether → Main. A stopped-state Region scan found
only the intended Nether Portal section and no automatically generated second
Portal. Both frames and platforms were removed by exact ranges, all forced
chunks were released, the worlds were flushed, and a second Region scan found
no remaining Nether Portal Palette.

## Restart and Client acceptance

The network stopped in the planned order with zero players:

1. Velocity normal shutdown;
2. approximately ten seconds;
3. Paper `save-all flush`;
4. Main, Frontier, and Lobby normal stop.

All component Ports closed and every Java process exited without force. The
network then started Paper backends before Velocity. Paper 26.2 build 62,
BetterStructures, five Content packs, FMM, ResourcePackManager, Multiverse,
existing gameplay Plugins, and Velocity 4.1.0 all returned normally.

The Client reconnected through Velocity, switched Lobby → Main, received or
reused the Main Pack, and saw no disconnect or protocol error. The naturally
generated End Shrine's FMM markers existed before restart, but the Vase was not
initially visible. After the normal restart and chunk reload,
`bs_prop_pack_vase` rendered correctly with no missing texture. This is recorded
as successful restart recovery, not immediate post-paste visibility.

During the reconnect check, a Creeper damaged a small area near Main spawn while
the user was in Survival. The user switched to Creative and reported that the
area was repaired before final cleanup. No automated rollback or broad entity
operation was performed. The final player state was returned to Survival, the
temporary Admin parent was removed, and the Client disconnected at Main spawn.

## Material notices

- Paper reported that the selected build is three builds behind. The assigned
  build remained unchanged by task scope.
- ViaVersion emitted its documented channel-initializer warnings and reported
  Minecraft 26.2 support.
- EvenMoreFish emitted its existing embedded NBT-API compatibility warning for
  26.2. Its adopted functionality was not changed by this task.
- Backend offline-mode warnings remain expected behind loopback-only Velocity
  modern forwarding.
- No warning above blocked Main generation, Pack delivery, World save, restart,
  or normal shutdown.

## Repository and roadmap result

- Order 4 Main regeneration: complete.
- Order 5 Main generation acceptance: incomplete by one exact item at this
  run's close, then completed by the separately assigned fourth-Pack follow-up.
- Order 6 tuning and final baseline backup: incomplete.
- Order 7 CoreProtect: incomplete.

The implementation commit must therefore use the limited-acceptance message:

```text
feat: Main Persistent Family置換候補を生成
```

Worlds, Regions, entities, POI, player data, backups, logs, JARs, Content ZIPs,
Schematics, Models, generated packs, hosting data, secrets, MariaDB, and Redis
data remain outside Git.
