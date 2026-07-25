# Main CoreProtect CE 24.0 / Paper 26.2 compatibility stop

## Outcome

The approved Main CoreProtect installation attempt stopped during the first
Main-only startup on 2026-07-26. CoreProtect CE 24.0 loaded, but its own
runtime compatibility guard rejected Minecraft 26.2 and disabled the Plugin:

```text
[CoreProtect] Enabling CoreProtect v24.0
[CoreProtect] Minecraft 26.2 is not supported.
[CoreProtect] CoreProtect Community Edition was unable to start.
[CoreProtect] Disabling CoreProtect v24.0
```

This is a task-defined stop condition. No version spoofing, bytecode change,
unsupported configuration workaround, alternate Artifact, or broader Plugin
update was attempted. Roadmap Order 7 remains incomplete and CoreProtect is
not installed in the active Main Runtime.

## Authorization and scope

- Assigned task:
  `codex/Project_Wayfarer_Main_CoreProtect_Integration_and_Acceptance.md`
- Approval token:
  `APPROVE-WAYFARER-MAIN-COREPROTECT-V24-INSTALL`
- Target: Main only
- Excluded: Velocity, Lobby, Frontier
- Main Runtime: Paper 26.2 build 62 / Oracle Java 25.0.3
- Attempted Plugin: CoreProtect Community Edition 24.0

## Artifact preflight

| Field | Result |
| --- | --- |
| Official source | `https://modrinth.com/plugin/coreprotect/version/24.0` |
| Filename | `CoreProtect-CE-24.0.jar` |
| Size | 1,102,175 bytes |
| SHA-256 | `66CD362089BB8430E5A018EE77E9B433BF0DC9E65590D5F1A043A78D60415696` |
| Public hash comparison | Modrinth SHA-1 and SHA-512 matched |
| Internal name | `CoreProtect` |
| Internal version | `24.0` |
| Main class | `net.coreprotect.CoreProtect` |
| API version | `1.16` |
| Soft dependency | WorldEdit |
| License | Artistic-2.0 |

CoreProtect 24.0 was the latest Stable CE release at the time of the attempt.
The JAR contains no standalone default `config.yml`; the v24 defaults and
recognized keys are generated from `net.coreprotect.config.Config`. The exact
v24.0 JAR class constants were compared with the official `v24.0` source tag.
The applicable database selector is `use-mysql`.

## Pre-install evidence

The ignored pre-install snapshot is:

```text
backups/main-coreprotect-preflight-20260726-003633/
```

It contains:

- the 2,104-file, 88,106,569-byte pre-install Main Plugin tree;
- tracked Config candidates;
- a focused LuckPerms CoreProtect-node query;
- MariaDB Database/User collision evidence;
- all persistent and Resource Region filenames and SHA-256 values.

No pre-existing CoreProtect group permission nodes, dedicated Database,
dedicated User, or `co_` Tables were found. The existing Project Database
policy was `utf8mb4` / `utf8mb4_unicode_ci`.

The Final Main Baseline remained available at:

```text
backups/main-v006-final-baseline-20260725-220745/
```

Its verified hashes were:

- manifest:
  `A85A7CCAA2FE2DECCC69CE3E9F862F1281408B4D02E20EFC1E3E31B74D0814A1`
- SHA list:
  `81593864B49E41FB03F02514C1935DFAF380A1ABFE6FB148897932E328A50C39`

## Provisioning performed before the compatibility stop

The approved attempt created:

- Database: `wayfarer_coreprotect_main`
- User: `wayfarer_coreprotect_main`
- Character set / collation: `utf8mb4` / `utf8mb4_unicode_ci`
- Grants limited to:
  `SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER`
- Table prefix selection: `co_`

Credential values remain only in ignored `.env` and the ignored rendered
Runtime Config. They were not written to Git output or this report.

The intended policy was:

- logging enabled in `main`, `main_nether`, and `main_the_end`;
- every v24 logging category disabled in `resource`, `resource_nether`, and
  `resource_end` through official per-world YAML files;
- player message and command logging disabled globally;
- WorldEdit, block, entity, item, container, interaction, sign, and session
  logging enabled in the persistent family;
- update checking, automatic purge, and automatic error reporting disabled.

The rendered credential-bearing Config SHA-256 was:

```text
7BEDFEBEDEB1E808540AA4D8575495308208418197B31051BA8222C1714B8A36
```

CoreProtect rejected Minecraft 26.2 before database initialization. The
dedicated Database therefore contained zero Tables, and no CoreProtect event
was written.

## Runtime observations

CoreProtect was loaded as `v24.0`, then rejected the Runtime during its enable
phase. It did not reach MariaDB connection, Schema generation, Consumer
startup, `/co status`, or any functional acceptance test.

The Main server itself reached `Done` and the existing Plugins enabled. The
known pre-existing MariaDB/Flyway notice from EvenMoreFish and normal
Velocity-backend offline-mode warning were unrelated to this attempt.

Because CoreProtect did not enable, the following tests were not started:

- Inspector;
- exact lookup;
- preview;
- limited rollback / restore;
- container lookup;
- Resource negative logging;
- permission boundary;
- restart persistence.

## Rollback

Main was stopped normally after `save-all flush`. The active JAR and Runtime
directory were moved, not deleted, to:

```text
backups/main-coreprotect-quarantine-20260726-005500/
```

The quarantine holds:

- the exact attempted JAR;
- the rendered global and Resource per-world Configs;
- the failed startup log;
- a non-secret quarantine summary.

Per the assigned rollback policy, the dedicated Database and User were
retained as incident evidence. They were not dropped or purged. The active
paths no longer contain `CoreProtect.jar` or `plugins/CoreProtect/`.

Main was then started without CoreProtect. It reached `Done` in 17.512 seconds;
EconomyShopGUI, EvenMoreFish, BetterStructures, FreeMinecraftModels, and
ResourcePackManager enabled, and the latter three completed delayed
initialization. Main was stopped normally again.

## Baseline safety result

All Region files remained byte-identical to the pre-install snapshot:

| World | Region files | SHA-256 matches | Changed | New |
| --- | ---: | ---: | ---: | ---: |
| `main` | 17 | 17 | 0 | 0 |
| `main_nether` | 11 | 11 | 0 | 0 |
| `main_the_end` | 18 | 18 | 0 | 0 |
| `resource` | 8 | 8 | 0 | 0 |
| `resource_nether` | 4 | 4 | 0 | 0 |
| `resource_end` | 4 | 4 | 0 | 0 |

No new Region file was generated. No Player joined during either Main-only
startup. Portal, BetterStructures, WorldGuard, world lifecycle, Seed, UUID,
and Spawn configuration were not changed.

## Deferral decision

The follow-up
`codex/Project_Wayfarer_CoreProtect_Deferral_and_Roadmap_Override.md`
formally deferred Roadmap Order 7 and made it non-blocking under Owner-only
operation. Main／Lobby CoreProtect is temporarily outside the V0.1.0 Release
Blockers; Order 8 Frontier lock is the next active task. Frontier CoreProtect
adoption remains undecided.

The failed attempt's uncommitted Config templates, Render／provision scripts,
future-clone database initialization changes, and ignore-rule changes were
removed from the documentation-only deferral change. The assigned integration
task and this investigation remain as future re-evaluation evidence. The
ignored preflight and quarantine snapshots remain local.

Owner-led Hub／Gate construction may proceed with the Final Main Baseline
Backup retained, focused backup／Schematic evidence as appropriate, controlled
edit units, and post-construction WorldGuard protection. WorldGuard does not
provide history lookup or point-in-time rollback.

The next CoreProtect attempt requires a separately confirmed official CE
Artifact that explicitly enables on Minecraft / Paper 26.2, plus a fresh
review of Version, license, configuration, database, per-world logging,
permissions, and backend placement. Do not substitute a Patreon build,
unofficial mirror, development snapshot, modified JAR, or a different version
without a new version decision and approval gate.
