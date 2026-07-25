# Main Fourth-Pack Natural-Generation Acceptance

Date: 2026-07-25

Result: passed; Roadmap Order 5 complete

## Scope

This focused follow-up closed the only remaining Order 5 item for the
2026-07-25 Main Current Runtime Candidate: natural generation from a fourth
distinct BetterStructures Pack.

The test did not change the seed, UUIDs, spawns, BetterStructures selection,
weights, Config, Models, Resource Pack composition, Portal links, World Border,
or Resource family. It did not use pregeneration, Chunk Pregenerator, manual
paste, Region deletion, Trim, or regeneration.

Pre-execution Git HEAD was
`ed5fe4de4940986943bce885adaca1ba09010880`.

## Preflight

- Git branch was `main`, synchronized with `origin/main`.
- The only initial untracked file was the assigned task document.
- MariaDB 11.8 and Redis 8 were healthy.
- All Wayfarer Java processes and ports were stopped before startup.
- Main seed was `164225356311935743`.
- Main UUID was `d868e7ff-6663-492d-a963-f95f00ce6c30`.
- Initial persistent Region counts were `11 / 11 / 18`.
- Resource Region counts were `8 / 4 / 4`.
- All 16 Resource `region/*.mca` SHA-256 values were recorded.
- BetterStructures 2.6.3, WorldEdit 7.4.4, FreeMinecraftModels 2.10.2, and
  ResourcePackManager 2.3.0 passed the existing static preflight.
- The five-Pack selection still contained 430 source configurations, 278
  enabled Structures, and 152 disabled Structures.
- `warnAdminsAboutNewBuildings: true`, `setupDone: true`,
  `protectEliteMobsRegions: false`, and `spawnProtectionRadius: 100` were
  unchanged.
- BetterStructures remained enabled only in `main`, `main_nether`, and
  `main_the_end`; every Resource world and unknown new world remained disabled.

Current-candidate Logs contained no prior Exploration or Adventure natural
generation evidence. An older pre-normalization Log contained failed Schematic
load messages, but it predated the Current Runtime Candidate and was excluded;
the current five-Pack preflight and both task startups had no Schematic error.

The bundled `plugin.yml` exposes the base `/betterstructures` command and only
setup, initialization, and generation permissions. It provides no read-only
history or natural-generation locator command. No guessed management command
was used.

The FreeMinecraftModels first-boot message was treated as informational.
`/fmm setup` was not run because 55 Models and the generated Pack were already
load-verified, and this task prohibited Model or Config changes.

## Bounded exploration

Exploration began at `2026-07-25T20:28:35+09:00` in Main Overworld only. The
test player was in Spectator mode. The first destination was the center of the
adjacent Region `r.-1.1.mca` at approximately `(-248, 200, 776)`.

Delayed view-distance loading ultimately created six Region files:

- `r.-2.0.mca`
- `r.-2.1.mca`
- `r.-2.2.mca`
- `r.-1.1.mca`
- `r.-1.2.mca`
- `r.0.2.mca`

This changed Overworld from 11 to 17 Region files. It remained within Stage A's
eight-Region limit. Nether remained 11 and End remained 18. No additional
destination was used.

Three admin notifications appeared:

- two Underground Shallow notifications;
- one Underground Deep notification.

The accepted target was reached through the notification's generated
read-only teleport action:

```text
/betterstructures teleport main -328 10 792
```

The target notification was reached about 1 minute 27 seconds after the first
destination. Visual identification and representative inspection completed
within about six minutes of exploration start.

## Accepted Structure

| Item | Evidence |
| --- | --- |
| Pack | Exploration Pack version 6 |
| Exact ID | `betterstructures_exploration_bridgecave_shallow` |
| Selection | Enabled Overworld `bridgecave_` variant, weight 1.0 |
| World | `main` / `minecraft:overworld` |
| Notification anchor | `(-328, 10, 792)` |
| Anchor Chunk | `(-21, 49)` |
| Region | `r.-1.1.mca` |
| Representative Container | Chest near `(-330, 4, 801)`, Chunk `(-21, 50)` |
| Schematic SHA-256 | `8BCC1848339FDF93212438B80B681C0E07CBE400E5A7E1A60A55C0077D0EC175` |

The exact ID was established from the Underground Shallow notification, the
notification anchor, the bridge-cave appearance, the enabled selection entry,
and read-only comparison with the exact Schematic Palette. The Structure used
polished andesite, stone-brick elements, leaves, chains, signs, Chests, and
Spawners. It did not contain the Obsidian／Nether Portal palette that
distinguishes Adventure Pack `portalroom_shallow`.

The Client confirmed:

- a complete bridge-like underground layout without obvious clipping;
- a real Chest with normal loot rendering;
- no Missing Texture;
- no unresolved Model;
- no abnormal Entity density;
- no obvious terrain-placement defect.

Stopped-state Region inspection found persisted Chest and Spawner Block
Entities in the accepted Structure area. No exhaustive loot, Mob, or variant
test was performed.

## Restart and preservation

The test player returned to Main Spawn, and the network followed the normal
Velocity-first stop, settlement wait, Paper `save-all flush`, and normal Paper
stop sequence. No process was forced.

After a clean full-network restart:

- BetterStructures 2.6.3 initialized normally;
- FreeMinecraftModels 2.10.2 initialized normally;
- ResourcePackManager 2.3.0 rebuilt and delivered the Main Pack;
- the Client revisited `(-328, 10, 792)`;
- the bridge Structure and representative Chest remained visible;
- stopped-state Region data still contained the target Chest and Spawner
  Block Entities;
- no ERROR, SEVERE, Exception, failed Schematic, missing Model, or duplicate
  Structure message appeared.

Final Region counts were:

| Family | Before | After | Added |
| --- | ---: | ---: | ---: |
| Main Overworld | 11 | 17 | 6 |
| Main Nether | 11 | 11 | 0 |
| Main End | 18 | 18 | 0 |
| Resource Overworld | 8 | 8 | 0 |
| Resource Nether | 4 | 4 | 0 |
| Resource End | 4 | 4 | 0 |

All 16 Resource Region SHA-256 values matched the preflight values after the
first stop and after the restart. No Resource world was visited or intentionally
loaded for exploration.

The test Player was returned to Main Spawn. Temporary Admin membership was
removed, and the final mode reset and disconnect were issued together rather
than leaving the Player waiting in Survival. All Minecraft components then
stopped normally with exit code 0; Wayfarer Java processes and ports were
closed.

## Result and remaining work

- Order 4: complete.
- Order 5: complete.
- Order 6: incomplete.
- Order 7: incomplete.

Natural generation is now accepted from four distinct Packs:

1. 103 Default Structures;
2. Caves and Lost Civilizations Free;
3. Echoes of the Past;
4. Exploration Pack.

The family remains the **Current Runtime Candidate**. It has not been promoted
to the **Final V0.1.0 Main Baseline**. Order 6 still owns Weight／Content
tuning, candidate selection, the final backup, and the final baseline
declaration.

Worlds, Regions, POI, entities, player data, Logs, screenshots, JARs, Content
archives, generated Packs, hosting data, secrets, and Database data remain
outside Git.
