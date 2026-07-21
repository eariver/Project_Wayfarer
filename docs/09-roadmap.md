# Project Wayfarer Roadmap - Ver.0.0.5

Ver.0.0.5 is a design revision, not a Server Release. The first target Release is `V0.1.0 Alpha`, which remains incomplete. This Roadmap defines the dependency-based implementation order and separates Release Blockers from deferred features. Every implementation phase requires a separately approved task.

## Completed baselines

- Bare First Boot, Velocity Modern Forwarding, backend access control, Lobby initial routing and failover
- ViaVersion 5.11.0 on Velocity for a Minecraft 26.2 Client entering Frontier 1.21.11
- LuckPerms shared MariaDB foundation
- Permission Phase 1A: five persistent Groups, self-only temporary Role foundation, Admin full access, OP removal, and Builder Role container
- Void Lobby／Frontier Gate safety platforms and current WorldGuard protection
- WorldEdit／WorldGuard on all Paper backends
- TAB proxy installation and backend bridges
- Multiverse registration of persistent and Resource families and explicit family-local links
- mcMMO 2.3.000 shared Main／Frontier progression
- RedisEconomy `4.5.12-wayfarer.1`／VaultUnlocked 2.20.2 shared Waymark balance
- EconomyShopGUI 7.1.1 Free Main-only fixed-price shop
- BetterStructures 2.6.3 and `103 Default Structures` version 5 restricted to persistent Main dimensions
- Phase 3 final persistent Main generation with preserved Resource dimensions and approved safe spawns
- EvenMoreFish 2.4.3 Main-only Custom Fishing with dedicated MariaDB persistence and mcMMO coexistence

These baselines retain their historical verification records. They do not imply completion of the Phase 1B final Builder allowlist, planned Hubs, Gates, Frontier Theme, operations Script, or V0.1.0 Backup.

## Dependency-based execution order from the current baseline

| Order | Work | Dependency and outcome |
| ---: | --- | --- |
| 1 | CoreProtect | Next implementation task; introduce before substantial Hub/Gate construction so new Block history is captured; not a cold-backup replacement |
| 2 | Playable Frontier Theme | Select and install one approved Paper 1.21.11／Java 25 Theme |
| 3 | Advanced Portals | Select the exact version, placement, commands, and Permission boundary |
| 4 | Builder Phase 1B | Build the allowlist only from the selected Portal/Theme and confirmed Builder-owned work |
| 5 | User Hub/Gate construction | User fixes appearance, footprint, equipment, coordinates, orientation, and safe arrivals |
| 6 | Main Spawn protection | After substantial initial Hub completion, approve and apply the exact WorldGuard Region and focused child Regions |
| 7 | Portal Routing | Configure and verify only approved routes after structures and destinations are fixed |
| 8 | Resource Reset Bootstrap | Restore arrivals, Return Gates, protection, and Resource End outer-island safety reproducibly |
| 9 | Integrated operations | Implement `Wayfarer.ps1` Start／Stop／Restart／Status／Backup |
| 10 | Cold Backup／Isolated Restore | Validate the complete data set and recovery path |
| 11 | V0.1.0 Baseline | Confirm every Blocker before any Release declaration |

Phase identifiers below preserve project history, but this dependency table controls practical execution priority. In particular, CoreProtect Phase 9 is intentionally brought forward before Phase 6 construction, and Phase 1B is not executed until the Theme and Advanced Portals boundary are known.

## Recommended phases to V0.1.0

### Phase 0 - Ver.0.0.5 specification

- [x] Formal design revision updated
- [x] Ordinary-Plugin verification scope narrowed
- [x] Five-group permission model specified
- [x] V0.1.0 completion conditions and non-Blockers separated
- [x] Deferred custom-Plugin/design items recorded
- [x] Phase 3 baseline integrated and Main Spawn protection designed without applying a Region
- [x] CoreProtect construction-history dependency and V0.2.x concept scope recorded

### Phase 1A - Permission foundation and temporary Admin

- [x] Treat all five Group definitions as persistent; only Player Parent membership in Builder/Admin is temporary
- [x] Audit and reuse `default` and existing `wayfarer_builder` without delete/recreate or Primary Group use
- [x] Preserve existing Lobby／Frontier WorldGuard Region Member references while removing Builder's former WorldEdit／WorldGuard administration wildcards
- [x] Create `wayfarer_builder_eligible`, `wayfarer_admin_eligible`, and `wayfarer_admin` after conflict checks
- [x] Restrict Eligibility to matching self-only temporary Role add/remove through Velocity
- [x] Give full Minecraft／Plugin authority only during a Player's temporary Admin Parent membership and remove OP dependency
- [x] Verify denial, expiry, demotion, Builder Role container, restart persistence, and Cleanup
- [x] Document exact nodes, operation, bootstrap, recovery, and rollback in [Permission Model](12-permission-model.md)

Phase 1A completed its focused Security Boundary verification on 2026-07-20.

### Phase 1B - Final Builder allowlist

- [ ] Confirm Advanced Portals version and permission model
- [ ] Select the first playable Frontier Theme and its required management commands
- [ ] Confirm the exact Builder-owned Hub／Gate／Theme connection work
- [ ] Scope approved Builder WorldEdit, gamemode, teleport, and Multiverse-Core commands to Lobby／Main／Frontier
- [ ] Scope approved Multiverse-NetherPortals commands to Main only
- [ ] Keep WorldGuard Region／Velocity／LuckPerms／economy／player-punishment／server-stop authority, destructive World lifecycle operations, wildcards, reload/debug/internal actions, and other prohibited administration excluded
- [ ] Repeat focused Builder elevation, work, Survival cleanup, demotion, and denial tests

Phase 1B remains a V0.1.0 Release Blocker and must complete before Builder-led Hub／Gate／Theme connection work. Execute it only after one playable Theme is selected, the Advanced Portals version and permissions are verified, and the exact Builder-owned work is known. It did not block the independently approved BetterStructures integration or Phase 3 generation.

### Phase 2 - Main world-generation features

- [x] Install BetterStructures 2.6.3 with only the free `103 Default Structures` pack
- [x] Enable it only in actual Bukkit worlds `main`, `main_nether`, and `main_the_end`
- [x] Keep `resource`, `resource_nether`, `resource_end`, and unknown new worlds disabled
- [x] Confirm natural `betterstructures_well_grassy` generation, representative Resource exclusion, and restart persistence

Phase 2 completed on 2026-07-20. Its retained BetterStructures spawn protection radius of 100 blocks was reviewed and approved during Phase 3.

### Phase 3 - Final persistent Main generation

- [x] Approve exact paths, backup, generation conditions, player-data reset policy, and Spawn safety
- [x] Finalize `main`, `main_nether`, and actual Bukkit End world `main_the_end` on seed `164225356311935743`
- [x] Preserve the Resource family outside the destructive scope and verify UUID, seed, and Region data

Phase 3 completed on 2026-07-21. The verified baseline and local rollback evidence are recorded in [Main World Baseline](13-main-world-baseline.md). Repeating generation remains destructive and requires a new independently approved, path-checked task. Phase 4 is complete; CoreProtect is next and Phase 1B remains incomplete.

### Phase 4 - Main lightweight gameplay

- [x] Install EvenMoreFish 2.4.3 only on Main
- [x] Load the adopted Japanese Config with `main`／`resource` scope, dedicated MariaDB, Economy/Competition disabled
- [x] Complete one natural catch, Journal persistence, permission boundary, and clean restart check
- [x] Preserve mcMMO Fishing XP while disabling duplicate mcMMO loot and leaving Waymark unchanged

Phase 4 completed on 2026-07-21. Do not turn future ordinary Config/version maintenance into exhaustive catch, command, reward, or unrelated regression testing unless an observed defect changes the risk.

### Phase 5 - Select and install one playable Frontier Theme

- [ ] Compare candidates for Paper 1.21.11／Java 25, installation, License, cost, dependencies, Resource Pack, worlds, and actual play
- [ ] Obtain user approval and manually acquire the selected artifacts
- [ ] Install one Theme and confirm its representative entrance/start
- [ ] Use normal Frontier inventory and shared mcMMO
- [ ] Keep WM rewards, achievements, Main rewards, Theme inventory, and initial equipment disabled for V0.1.0

A World Generator alone is not assumed to satisfy the playable-theme requirement.

### Phase 6 - User-built Hubs and Gate structures

CoreProtect Phase 9 must be completed before substantial construction begins. Builder-led work additionally requires Phase 1B; user planning and initial manual work do not authorize Codex to infer structures or routes.

The user manually builds and approves:

- [ ] Lobby minimum Hub, Main Gate, and Frontier Gate
- [ ] Main initial Spawn Hub, Lobby Return, Frontier Gate, and three Resource Gates
- [ ] Frontier Gate minimum Hub, Theme Gate, and Theme Return destination
- [ ] Return Gate structure for each Resource world
- [ ] Safe Resource End outer-island structure

Codex does not infer or generate appearance, coordinates, orientation, or destinations without explicit user input.

Main Spawn protection is designed but not implemented. After the user has substantially completed the initial Main Hub footprint and equipment layout, a separate task must approve the exact `main_spawn_hub` WorldGuard boundary. Use membership-based construction protection without a `build` flag, allow only approved public `use`, isolate broader interaction in focused child Regions, verify environmental flags, and only then consider changing Vanilla `spawn-protection` from 16 to 0.

### Phase 7 - Advanced Portals and Gate integration

Before Phase 1B, select the Advanced Portals version and verify Velocity/Paper placement, portal create/edit/delete, destination/server transfer, reload/debug, Builder-safe operations, and Admin-only operations. Do not configure production routes until the user-built structures and safe destinations are fixed.

- [ ] Lobby -> Main spawn Hub
- [ ] Lobby -> Frontier Gate
- [ ] Main -> Lobby and Frontier Gate
- [ ] Main -> `resource`, `resource_nether`, and `resource_end`
- [ ] Each Resource world -> Main spawn Hub
- [ ] Frontier Gate -> playable Theme
- [ ] Playable Theme -> Frontier Gate safe return

Portal/Dimension Routing requires detailed verification of only the routes changed by the task.

### Phase 8 - Resource reset bootstrap

- [ ] Safe arrival and Spawn/Arrival placement for all Resource worlds
- [ ] Reproducible Return Gate structure and Gate reconfiguration
- [ ] Optional protection reapplication where approved
- [ ] Resource End safe outer-island reconstruction
- [ ] Idempotent procedure and exact runtime paths
- [ ] Explicit persistent-world rejection

The implementation may use a user-authored Schematic, tracked Template, PowerShell/Command procedure, external custom Plugin, or an approved combination. Destructive reset execution remains separately approved.

### Phase 9 - CoreProtect

- [ ] Install next, after completed Phase 4 EvenMoreFish and before substantial Hub/Gate construction
- [ ] Select exact Paper placement and database policy in the approved integration task
- [ ] Adopt it for investigation and partial rollback
- [ ] Keep rollback administration Admin-only; do not grant it to Builder
- [ ] Perform only normal Plugin Integration verification

CoreProtect records history only after installation and does not replace the cold backup.

### Phase 10 - Integrated operations Script

- [ ] Implement formal `Wayfarer.ps1` actions: Start, Stop, Restart, Status, Backup
- [ ] On planned shutdown: reject new connections, notify/disconnect users, stop Velocity, settle about 10 seconds, flush Paper, stop Main／Frontier／Lobby, and confirm Java exit
- [ ] Treat the wait only as a settling interval; rely on normal save/stop, process checks, and database/Redis handling for integrity
- [ ] Keep Console exceptional and use Temporary Admin membership for normal running-Runtime administration
- [ ] Preserve startup dependency order and incomplete-generation safety
- [ ] Keep OS/Docker/Database operations outside Minecraft permissions

### Phase 11 - Cold backup and isolated restore

- [ ] Disconnect all users and wait about 10 seconds for in-flight work
- [ ] Stop all Paper components normally and confirm Java process exit
- [ ] Dump MariaDB
- [ ] Stop Redis normally and copy its AOF volume
- [ ] Copy persistent worlds and Config
- [ ] Create manifest and SHA-256 records with `.incomplete` generation handling
- [ ] Restore to an isolated target and verify it

### Phase 12 - V0.1.0 Baseline

- [ ] Confirm all Release Blockers
- [ ] Create and verify the Baseline Backup
- [ ] Select the exact Release commit and record known limitations
- [ ] Decide Git Tag／GitHub Release adoption
- [ ] Declare `V0.1.0 Alpha` only after all preceding checks pass

## V0.1.0 Release Blockers

- Phase 1B final Builder allowlist
- BetterStructures restricted to persistent Main dimensions (Phase 2 complete)
- Final generation of `main`, `main_nether`, and actual Bukkit End world `main_the_end` (Phase 3 complete)
- EvenMoreFish (Phase 4 complete)
- One playable Frontier Theme
- Lobby minimum Hub
- Main initial Spawn Hub
- Frontier Gate minimum Hub
- Main Spawn WorldGuard protection after substantial initial Hub construction
- All Phase 7 required Gate routes
- Resource Return Gate Bootstrap design and procedure
- Resource End safe outer-island arrival and return
- CoreProtect
- Integrated Start／Stop／Restart／Status／Backup Script
- MariaDB／Redis／World／Config cold backup
- Isolated restore test
- Verified V0.1.0 Baseline Backup

## Not V0.1.0 Release Blockers

- Cross-server Chat or Shop
- Dynamic Pricing, Player Shop, Global Stock, or automatic price adjustment
- Frontier WM rewards
- Theme achievements or Main-side achievement rewards
- Theme-specific inventories, initial equipment, or WM equipment purchases
- Main teleport system
- Frontier Gate utilities
- Over-enchanted/special tools
- Multiple playable Themes
- PlugManX
- Custom Plugin repository
- V0.2.x custom-Plugin concept draft and growth-tool proposal
- LAB

Accepted compromises and future solution candidates are detailed in [Deferred Design Items](11-deferred-design-items.md).
