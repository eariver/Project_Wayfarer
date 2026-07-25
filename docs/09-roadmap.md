# Project Wayfarer Roadmap - Ver.0.0.6

Ver.0.0.6 is a design revision, not a Server Release. The first target Release is `V0.1.0 Alpha`, which remains incomplete. This Roadmap defines the dependency order and separates verified current baselines from planned Release Blockers. Every implementation phase requires a separately assigned task.

## Completed baselines

- Bare First Boot, Velocity Modern Forwarding, backend access control, Lobby initial routing and failover
- ViaVersion 5.11.0 on Velocity for a Minecraft 26.2 Client entering Frontier 1.21.11
- LuckPerms shared MariaDB foundation and Permission Phase 1A
- Void Lobby／Frontier Gate safety platforms and current WorldGuard protection
- WorldEdit／WorldGuard on all Paper backends
- TAB proxy installation and backend bridges
- Multiverse registration of current Main Persistent／Resource families and explicit family-local links
- mcMMO 2.3.000 shared Main／Frontier progression
- RedisEconomy `4.5.12-wayfarer.1`／VaultUnlocked 2.20.2 shared Waymark balance
- EconomyShopGUI 7.1.1 Free Main-only fixed-price shop
- BetterStructures 2.6.3 five-Pack／278-Structure Final Main Baseline restricted to Persistent Main dimensions
- 2026-07-25 replacement generation with approved safe spawns, preserved Resource family, Order 5 acceptance, and verified Order 6 stopped-state backup
- EvenMoreFish 2.4.3 Main-only Custom Fishing and Vault Fish Shop
- Main BetterStructures five-Pack working set, FreeMinecraftModels 2.10.2, BetterStructures Prop Pack, and ResourcePackManager 2.3.0 load preflight

The 2026-07-21 family remains the Legacy Rollback Baseline. The 2026-07-25 replacement is the Final Main Baseline after Order 6 accepted the current Config without tuning and verified its stopped-state backup. It is not the V0.1.0 Release Baseline.

## Dependency-based execution order

| Order | Work | Dependency and outcome |
| ---: | --- | --- |
| 1 | Ver.0.0.6 formal documentation | Adopt the approved Main／Frontier scope without changing Runtime |
| 2 | Main BetterStructures Artifact／Content／Resource Pack Preflight — complete 2026-07-25 | Exact versions, licenses, sources, hashes, dependencies, Model IDs, Pack generation, and World scope are locked; Client delivery evidence is recorded in the integration report |
| 3 | Main full Content Import and load confirmation — complete 2026-07-25 | The five approved packs plus Prop／FreeMinecraftModels／ResourcePackManager working set loaded normally before World generation |
| 4 | Main Persistent Family regeneration — complete 2026-07-25 | Only `main`, `main_nether`, and `main_the_end` were replacement-generated; the Resource family was restored and hash-verified |
| 5 | Main generation acceptance — complete 2026-07-25 | Spawns, Resource exclusion, Portal family, Pack, restart, three dimensions, Props, and four distinct Packs passed; Exploration Pack supplied the fourth natural-generation observation |
| 6 | Main Weight／Content tuning and new baseline — complete 2026-07-25 | Decision A retained current Config; identities, Resource hashes, stopped-state backup, and Final Main Baseline source of truth were verified |
| 7 | CoreProtect — deferred／non-blocking | Main／Lobby wait for an upstream Minecraft 26.2-compatible Stable release; not complete, accepted, or a cold-backup replacement |
| 8 | Frontier lock | Lock Plugin versions, artifacts, World IDs, Gate method, Resource Packs, persistence, licenses, and exact Runtime boundaries |
| 9 | Wayfarer_Core | Approve formal design, create a separate Repository, develop／release, and integrate the V0.1.0 shared foundation |
| 10 | Wayfarer_Frontier | Approve formal design, create a separate Repository, develop／release, and integrate the V0.1.0 Frontier functions |
| 11 | Frontier shared foundation | Integrate MVI, Multiverse-NetherPortals, WorldEdit／WorldGuard, ResourcePackManager, Frontier Pack, Beyond Gate, and Guild Gate; adopt CoreProtect only if Order 8 or a later approved task selects it |
| 12 | EM Adapter necessity decision | Prove whether static MVI registration or strict Regex is sufficient before authorizing an Adapter |
| 13 | Ruined Frontier alpha | Implement and verify the approved Guild／Primis／three-dimension BetterStructures＋EliteMobs scope |
| 14 | Worlds Beyond MVP | Implement and verify the approved Iris／Traversal／Waystone／WM Shop scope |
| 15 | Frontier two-Theme integration | Verify MVI separation, full item isolation, Pack switching, routes, restart, reconnect, and persistence across both Themes |
| 16 | Final Gate and Permission lock | Select Advanced Portals or the approved Gate method and lock exact Player／Builder／Admin permissions |
| 17 | Builder Phase 1B | Build the explicit allowlist from the final Plugin, Theme, Gate, and construction operations |
| 18 | User Hub／Gate construction | User fixes appearance, footprint, equipment, coordinates, orientation, and safe arrivals |
| 19 | Main Spawn protection | Apply and verify the exact WorldGuard Region after substantial Hub completion |
| 20 | Portal Routing completion | Configure and verify every approved Lobby／Main／Frontier／Theme／Resource route |
| 21 | Resource Reset Bootstrap | Restore Resource arrivals, Return Gates, protection, and Resource End outer-island safety reproducibly |
| 22 | Integrated operations | Implement `Wayfarer.ps1` Start／Stop／Restart／Status／Backup |
| 23 | Cold Backup／Isolated Restore | Validate the complete Main, Frontier, MariaDB, Redis, World, Content, Config, and custom-Plugin data recovery path |
| 24 | V0.1.0 Pre-release Player State Reset | Separately approve and reset Waymark and the exact Player State scope after functional testing |
| 25 | V0.1.0 Baseline | Create the post-reset baseline backup and confirm every Blocker before any Release declaration |

The table controls practical priority. Main Content loaded before regeneration and the Final Main Baseline is complete. Order 7 remains numbered but is deferred／non-blocking; Order 8 is the next active task. Both Frontier Themes and the Gate boundary precede Builder Phase 1B.

## Phase details

### Phase 0 - Ver.0.0.6 formal scope

- [x] Promote the approved Main five-Pack expansion and regeneration plan into current documentation
- [x] Make both Ruined Frontier and Worlds Beyond V0.1.0 Release Blockers
- [x] Adopt the MVI, custom-Plugin, complete item-isolation, and Resource Pack responsibility boundaries
- [x] Preserve Concepts as non-authoritative detailed design input
- [x] Preserve current Runtime and Main baseline until separately assigned implementation tasks pass

### Phase 1A - Permission foundation

Phase 1A completed on 2026-07-20. Five persistent Group definitions, self-only Temporary Roles, Admin full access, OP-independent operation, the existing Builder Region membership, and the empty Builder command container remain verified.

### Phase 1B - Final Builder allowlist

- [ ] Lock the adopted Gate／Portal Plugin version and exact permissions
- [ ] Lock Ruined Frontier, Worlds Beyond, MVI, ResourcePackManager, EliteMobs, Wayfarer_Core, and Wayfarer_Frontier administration boundaries
- [ ] Confirm exact Builder-owned Hub／Gate work
- [ ] Allowlist only required WorldEdit, gamemode, teleport, Multiverse, and Gate operations
- [ ] Exclude MVI group management, Resource Pack publishing／rollback, EliteMobs internals, Database, economy, custom-Plugin administration, WorldGuard Region administration, Velocity, LuckPerms, player punishment, server stop, destructive World lifecycle, reload／debug internals, and wildcards
- [ ] Repeat focused elevation, work, Survival cleanup, demotion, and denial tests

Phase 1B remains a Release Blocker and starts only at dependency order 17.

### Phase 2 - Current Main BetterStructures baseline

The 2026-07-20 integration of BetterStructures 2.6.3 with `103 Default Structures` version 5 remains historical verified evidence. The 2026-07-25 non-destructive preflight supersedes its Content load scope, but not its generated World baseline.

### Phase 2B - Main Persistent Family Content expansion and regeneration

The formal target applies to:

```text
main
main_nether
main_the_end
```

The adopted and load-verified Content set is:

- `103 Default Structures` version 5;
- `Exploration Pack` version 6;
- `Caves and Lost Civilizations Free` version 2;
- `Adventure Pack` internal version 1;
- `Echoes of the Past` version 3;
- BetterStructures Prop Pack;
- FreeMinecraftModels;
- ResourcePackManager.

The exact Artifact locks, selection, normalization, and generated Pack digests are recorded in [the preflight report](investigations/2026-07-25-main-betterstructures-content-preflight.md), `versions.yml`, and `plugin-manifest.yml`. The working set contains 430 source configurations with 278 enabled and 152 disabled. FreeMinecraftModels is locked at 2.10.2 and ResourcePackManager at 2.3.0.

Required order:

```text
Artifact verification [complete]
→ Runtime working copy [complete]
→ Structure-selection Config [complete]
→ Prop／Model ID normalization [complete]
→ all approved Plugin／Content import [complete]
→ World allowlist, Content load, and Resource Pack preflight [complete]
→ healthy load confirmation [complete]
→ separately approved Main Persistent Family regeneration [complete]
→ generation／Portal／Spawn／Pack／Resource-exclusion acceptance [complete]
→ approved no-tuning decision [complete]
→ Final Main Baseline and stopped-state backup [complete]
```

The one-time generation has completed and must not be rerun. Keep `resource`, `resource_nether`, `resource_end`, and unknown Worlds disabled. Any later lifecycle change requires a new assigned task, exact paths, rollback evidence, explicit user confirmation, normal shutdown, and focused destructive verification.

### Phase 3 - Current and future Main baselines

The 2026-07-25 family in [Main World Baseline](13-main-world-baseline.md) is the Final Main Baseline. Order 6 accepted the current Config without tuning and verified `backups/main-v006-final-baseline-20260725-220745/`. The 2026-07-21 family is the Legacy Rollback Baseline, while the pre-replacement copy remains the Replacement Rollback Source. None may be altered by documentation-only work. The future V0.1.0 Release Baseline still requires the remaining network, Frontier, operations, cold-backup／restore, and pre-release reset Blockers.

### Phase 4 - Main lightweight gameplay

EvenMoreFish, the Main fixed-price shop, and the 100x nominal Waymark scale remain verified. This revision changes neither the current prices nor Runtime Config.

### Phase 5 - Frontier V0.1.0

The formal scope is [Frontier V0.1.0 Scope](14-frontier-v0.1.0-scope.md). Both Ruined Frontier alpha and Worlds Beyond MVP are required.

#### Frontier shared foundation

- [ ] Lock every Plugin／Content Artifact, license, hash, World ID, Gate method, Resource Pack, and persistence boundary
- [ ] Integrate Multiverse-Inventories with `neutral`, `worlds_beyond`, and `guild`
- [ ] Integrate Frontier Multiverse-NetherPortals, WorldEdit, WorldGuard, and ResourcePackManager; decide the Frontier history／rollback solution separately
- [ ] Produce and deliver a Frontier-only integrated Pack
- [ ] Integrate separately released Wayfarer_Core and Wayfarer_Frontier
- [ ] Build and verify Beyond and Guild Gate routes

#### EM Adapter necessity decision

- [ ] Lock EliteMobs version, Content packages, Blueprint names, Instance naming, lifecycle, concurrency, restart, and reconnect behavior
- [ ] Test static MVI registration first
- [ ] Test a strict approved-Blueprint Regex second
- [ ] Authorize an Adapter only if both approaches are insufficient

#### Ruined Frontier alpha

- [ ] Adventurer's Guild and Primis
- [ ] `frontier_bs`, `frontier_bs_nether`, and `frontier_bs_the_end` after exact ID lock
- [ ] BetterStructures and EliteMobs enabled across the three Theme dimensions
- [ ] Exploration Pack, Caves and Lost Civilizations Free, Echoes of the Past, Adventure Pack, BetterStructures Prop Pack, Free Elite Shrines, and Dungeoneering Modules Free
- [ ] Keep the full `103 Default Structures` pack disabled by default; require a separate formal design and task for any individual Structure adoption
- [ ] BetterHealthBar3 adoption test
- [ ] representative Sign, Shrine, Boss, Loot, Guild, Portal, MVI, Pack, and safe-return acceptance

#### Worlds Beyond MVP

- [ ] Iris Overworld, Nether, and End after exact Engine／Pack／Seed／World ID lock
- [ ] PEACEFUL and persistent-World operation
- [ ] MVI `worlds_beyond` group and family-local Portal links
- [ ] Traversal Loadout, Elytra, LeafGrapple, Launchpad
- [ ] Frontier WM Shop, Waystone, Discovery GUI, and Teleport GUI
- [ ] Pack, persistence, MVI, routing, and safe-return acceptance

### Phase 6 - User-built Hubs and Gates

Main／Lobby CoreProtect is deferred while Owner-only operation continues and is not a prerequisite for Owner-led Hub／Gate construction. Retain the Final Main Baseline Backup, preserve focused before／after backup or ignored Schematic evidence as appropriate, divide destructive work into controlled units, and apply a separately accepted WorldGuard boundary after construction. WorldGuard does not provide history lookup or point-in-time rollback. Builder-led work additionally requires Phase 1B.

The user manually builds and approves:

- [ ] Lobby minimum Hub and Main／Frontier Gates
- [ ] Main initial Spawn Hub and Lobby／Frontier／three Resource Gates
- [ ] Frontier Gate Hub, Beyond Gate, Guild Gate, and both safe return destinations
- [ ] each Resource Return Gate
- [ ] Resource End safe outer-island structure

Codex does not infer appearance, coordinates, orientation, or destinations.

### Phase 7 - Gate integration and Main Spawn protection

- [ ] Lock Advanced Portals or another approved Gate method and its exact permission model
- [ ] Configure only user-approved routes and safe arrivals
- [ ] Preserve MVI switching and family-local dimension routing
- [ ] Apply the exact `main_spawn_hub` WorldGuard membership boundary after substantial initial construction
- [ ] Keep Vanilla `spawn-protection=16` until the Region and Builder behavior pass

### Phase 8 - Resource reset bootstrap

- [ ] Restrict routine reset scripts and normal reset operations to `resource`, `resource_nether`, and `resource_end`; explicitly reject the Persistent Main family
- [ ] Restore a safe arrival and Spawn／Arrival setting for every Resource World
- [ ] Restore a reproducible Return Gate and Gate Config
- [ ] Restore approved protection
- [ ] Restore the Resource End outer-island site
- [ ] Use an idempotent procedure with exact paths and explicit persistent-World rejection

### Phase 9 - CoreProtect

- [ ] Wait for an upstream Stable Community Edition that explicitly supports Minecraft／Paper 26.2 and Java 25
- [ ] Re-audit Version, Artifact, license, placement, database, per-world logging, permissions, and Main／Lobby／Frontier boundaries before any new attempt
- [ ] Keep any future lookup／rollback administration Admin-only
- [ ] Re-evaluate before non-Owner participation, multiple Builders, public operation, large collaborative WorldEdit work, or materially expanded persistent construction

Order 7 is deferred and non-blocking, not complete. Main／Lobby CoreProtect is temporarily outside the V0.1.0 blockers under Owner-only operation. Frontier adoption remains undecided until Order 8 or later. CoreProtect records only changes after installation and never replaces cold backup; WorldGuard is preventive protection and does not replace it.

### Phase 10 - Integrated operations

- [ ] Implement `Wayfarer.ps1` Start, Stop, Restart, Status, and Backup
- [ ] Preserve the approved shutdown／flush／process-exit order
- [ ] Add all Frontier Worlds, Content, Packs, and custom-Plugin data owners
- [ ] Keep OS, Docker, MariaDB, Redis, backup, restore, and forced recovery outside Minecraft permissions

### Phase 11 - Cold backup and isolated restore

- [ ] Dump MariaDB after normal Minecraft shutdown
- [ ] Stop Redis and copy its AOF
- [ ] Copy persistent Main／Frontier Worlds, Config, Content, Pack inputs, and approved custom-Plugin data
- [ ] Record a manifest and SHA-256 with incomplete-generation safety
- [ ] Restore to an isolated target and verify every authoritative data owner

### V0.1.0 Pre-release Player State Reset

- [ ] Use a separate destructive task after all Gameplay／Portal／Hub／Permission／Backup tests
- [ ] Back up exact Redis, World, and Player State scope before reset
- [ ] Reset Waymark through a supported RedisEconomy mechanism, never direct Redis key editing
- [ ] Reset the approved Main and Frontier／MVI Player State without violating authoritative ownership
- [ ] Verify zero／initial representative state and create the final post-reset baseline backup

This reset has not been executed and must not be brought forward.

### Phase 12 - V0.1.0 Baseline

- [ ] Confirm every Release Blocker
- [ ] Create and verify the Baseline Backup
- [ ] Select the exact Release commit and record known limitations
- [ ] Decide Git Tag／GitHub Release adoption
- [ ] Declare `V0.1.0 Alpha` only after all checks pass

## V0.1.0 Release Blockers

- Main five-Pack／Prop／FreeMinecraftModels／ResourcePackManager preflight and import
- destructive Main Persistent Family regeneration after Content load
- Main generation acceptance, tuning, new baseline, and backup
- Frontier shared foundation
- Multiverse-Inventories and all three groups
- ResourcePackManager, separate Main／Frontier Packs, and backend-switch delivery
- Wayfarer_Core and Wayfarer_Frontier from separate Repositories
- EM Adapter necessity decision
- Ruined Frontier alpha
- Worlds Beyond MVP
- both Themes' MVI separation and complete Main／Frontier item isolation
- both Theme Portal families and safe returns to Frontier Lobby
- Lobby, Main, and Frontier Hubs／Gates
- Phase 1B final Builder allowlist
- Main Spawn WorldGuard protection
- complete Portal Routing
- Resource Reset Bootstrap and Resource End safety
- integrated operations
- Frontier-inclusive cold backup and isolated restore
- V0.1.0 pre-release Player State reset
- verified V0.1.0 Baseline Backup

## Not V0.1.0 Release Blockers

- Main／Lobby CoreProtect while Owner-only operation continues and no Minecraft 26.2-compatible Stable Community Edition is available
- cross-server Chat
- Dynamic Pricing, Player Shop, Global Stock, or automatic price adjustment
- item-based achievement rewards
- additional Themes beyond Ruined Frontier and Worlds Beyond
- optional／premium Frontier Content outside the approved alpha／MVP
- Ruined Frontier WM reward rollout and final balance
- an EM Adapter when static MVI registration or strict Regex is sufficient
- Main teleport system
- PlugManX
- LAB

Accepted compromises and later candidates are tracked in [Deferred Design Items](11-deferred-design-items.md). Detailed Frontier authority and boundaries are in [Frontier V0.1.0 Scope](14-frontier-v0.1.0-scope.md).
