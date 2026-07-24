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
- BetterStructures 2.6.3 and `103 Default Structures` version 5 restricted to current Persistent Main dimensions
- 2026-07-21 Main persistent generation baseline with approved safe spawns and preserved Resource family
- EvenMoreFish 2.4.3 Main-only Custom Fishing and Vault Fish Shop

These historical baselines remain verified. Ver.0.0.6 authorizes a future Main Content expansion and destructive regeneration plan, but it does not supersede the current Main baseline until the new generation, acceptance, and backup tasks finish.

## Dependency-based execution order

| Order | Work | Dependency and outcome |
| ---: | --- | --- |
| 1 | Ver.0.0.6 formal documentation | Adopt the approved Main／Frontier scope without changing Runtime |
| 2 | Main BetterStructures Artifact／Content／Resource Pack Preflight | Verify exact versions, licenses, sources, hashes, dependencies, model IDs, Pack delivery, and World scope |
| 3 | Main full Content Import and load confirmation | Install the five approved packs plus Prop／FreeMinecraftModels／ResourcePackManager working set and confirm every dependency before World generation |
| 4 | Main Persistent Family regeneration | Under a separately approved destructive task, regenerate only `main`, `main_nether`, and `main_the_end` after Content load succeeds |
| 5 | Main generation acceptance | Verify representative structures, Resource-family exclusion, Portal family, safe spawns, and Main Resource Pack delivery |
| 6 | Main Weight／Content tuning and new baseline | Apply approved tuning, finalize identities and backup, then update the Main baseline source of truth |
| 7 | CoreProtect | Introduce after the new Main baseline and before substantial Hub／Gate construction; not a cold-backup replacement |
| 8 | Frontier lock | Lock Plugin versions, artifacts, World IDs, Gate method, Resource Packs, persistence, licenses, and exact Runtime boundaries |
| 9 | Wayfarer_Core | Approve formal design, create a separate Repository, develop／release, and integrate the V0.1.0 shared foundation |
| 10 | Wayfarer_Frontier | Approve formal design, create a separate Repository, develop／release, and integrate the V0.1.0 Frontier functions |
| 11 | Frontier shared foundation | Integrate MVI, Multiverse-NetherPortals, WorldEdit／WorldGuard／CoreProtect, ResourcePackManager, Frontier Pack, Beyond Gate, and Guild Gate |
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

The table controls practical priority. In particular, Main Content must load before regeneration; CoreProtect follows the new Main baseline; both Frontier Themes and the Gate boundary precede Builder Phase 1B.

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
- [ ] Lock Ruined Frontier, Worlds Beyond, MVI, ResourcePackManager, EliteMobs, and custom-Plugin administration boundaries
- [ ] Confirm exact Builder-owned Hub／Gate work
- [ ] Allowlist only required WorldEdit, gamemode, teleport, Multiverse, and Gate operations
- [ ] Exclude MVI group management, Resource Pack publishing／rollback, EliteMobs internals, Database, economy, custom-Plugin administration, WorldGuard Region administration, Velocity, LuckPerms, player punishment, server stop, destructive World lifecycle, reload／debug internals, and wildcards
- [ ] Repeat focused elevation, work, Survival cleanup, demotion, and denial tests

Phase 1B remains a Release Blocker and starts only at dependency order 17.

### Phase 2 - Current Main BetterStructures baseline

The 2026-07-20 integration of BetterStructures 2.6.3 with `103 Default Structures` version 5 remains historical verified evidence. It is not the final Ver.0.0.6 Main Content scope.

### Phase 2B - Main Persistent Family Content expansion and regeneration

The formal target applies to:

```text
main
main_nether
main_the_end
```

The approved planned Content set is:

- `103 Default Structures` version 5;
- `Exploration Pack` version 6;
- `Caves and Lost Civilizations Free` version 2;
- `Adventure Pack` internal version 1;
- `Echoes of the Past` version 3;
- BetterStructures Prop Pack;
- FreeMinecraftModels;
- ResourcePackManager.

Artifact versions above are design targets. The implementation task must verify actual versions, sources, licenses, hashes, compatibility, dependency order, Structure selection, Weight, Model／Prop IDs, and generated Pack before recording Runtime versions.

Required order:

```text
Artifact verification
→ Runtime working copy
→ Structure-selection Config
→ Prop／Model ID normalization
→ all approved Plugin／Content import
→ World allowlist, Content load, and Resource Pack preflight
→ healthy load confirmation
→ separately approved Main Persistent Family regeneration
→ generation／Portal／Spawn／Pack／Resource-exclusion acceptance
→ approved tuning
→ new baseline and backup
```

Do not generate the Worlds before Content load. Keep `resource`, `resource_nether`, `resource_end`, and unknown Worlds disabled. Regeneration must not include the Resource family and requires exact paths, rollback evidence, explicit user confirmation, normal shutdown, and focused destructive verification.

### Phase 3 - Current and future Main baselines

The 2026-07-21 baseline in [Main World Baseline](13-main-world-baseline.md) remains the current Runtime source of truth. It is replaced only after Phase 2B generation, acceptance, tuning, identity capture, and backup complete. The current Worlds, Seed, UUIDs, spawns, and rollback backup must not be altered by documentation work.

### Phase 4 - Main lightweight gameplay

EvenMoreFish, the Main fixed-price shop, and the 100x nominal Waymark scale remain verified. This revision changes neither the current prices nor Runtime Config.

### Phase 5 - Frontier V0.1.0

The formal scope is [Frontier V0.1.0 Scope](14-frontier-v0.1.0-scope.md). Both Ruined Frontier alpha and Worlds Beyond MVP are required.

#### Frontier shared foundation

- [ ] Lock every Plugin／Content Artifact, license, hash, World ID, Gate method, Resource Pack, and persistence boundary
- [ ] Integrate Multiverse-Inventories with `neutral`, `worlds_beyond`, and `guild`
- [ ] Integrate Frontier Multiverse-NetherPortals, WorldEdit, WorldGuard, CoreProtect, and ResourcePackManager
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
- [ ] approved five-pack／Prop／Shrine／Dungeoneering Content
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

CoreProtect must be installed after the new Main baseline and before substantial construction. Builder-led work additionally requires Phase 1B.

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

- [ ] Restore a safe arrival and Spawn／Arrival setting for every Resource World
- [ ] Restore a reproducible Return Gate and Gate Config
- [ ] Restore approved protection
- [ ] Restore the Resource End outer-island site
- [ ] Use an idempotent procedure with exact paths and explicit persistent-World rejection

### Phase 9 - CoreProtect

- [ ] Install after the new Main baseline and before substantial Hub／Gate construction
- [ ] Lock exact placement and database policy
- [ ] Keep lookup／rollback administration Admin-only
- [ ] Include Main and Frontier persistence and backup ownership in the operational design

CoreProtect records only changes after installation and never replaces cold backup.

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
- CoreProtect after the new Main baseline
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
