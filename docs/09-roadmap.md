# Project Wayfarer Roadmap - Ver.0.0.4

Ver.0.0.4 is a design revision, not a Server Release. The first target Release is `V0.1.0 Alpha`, which remains incomplete. This Roadmap defines the recommended implementation order and separates Release Blockers from deferred features. Every implementation phase requires a separately approved task.

## Completed baselines

- Bare First Boot, Velocity Modern Forwarding, backend access control, Lobby initial routing and failover
- ViaVersion 5.11.0 on Velocity for a Minecraft 26.2 Client entering Frontier 1.21.11
- LuckPerms shared MariaDB foundation
- Void Lobby／Frontier Gate safety platforms and current WorldGuard protection
- WorldEdit／WorldGuard on all Paper backends
- TAB proxy installation and backend bridges
- Multiverse registration of persistent and Resource families and explicit family-local links
- mcMMO 2.3.000 shared Main／Frontier progression
- RedisEconomy `4.5.12-wayfarer.1`／VaultUnlocked 2.20.2 shared Waymark balance
- EconomyShopGUI 7.1.1 Free Main-only fixed-price shop

These baselines retain their historical verification records. They do not imply completion of the planned Hubs, Gates, permissions, Frontier Theme, operations Script, or V0.1.0 Backup.

## Recommended phases to V0.1.0

### Phase 0 - Ver.0.0.4 specification

- [x] Formal design revision updated
- [x] Ordinary-Plugin verification scope narrowed
- [x] Five-group permission model specified
- [x] V0.1.0 completion conditions and non-Blockers separated
- [x] Deferred custom-Plugin/design items recorded

### Phase 1 - Permission model implementation

- [ ] Create permanent Eligibility groups and temporary Builder/Admin groups after conflict checks
- [ ] Restrict each Eligibility group to self-only temporary add/remove of its matching Role
- [ ] Implement the Builder Allowlist in appropriate Paper `server` Contexts
- [ ] Give full Minecraft/Plugin authority only to temporary Admin
- [ ] Document and minimally verify the Security Boundary, including denial of permanent/other-player/arbitrary grants

This phase changes a Security Boundary and therefore requires detailed verification limited to the affected permissions and role transitions. Exact nodes must come from LuckPerms 5.5.60 and adopted Plugin metadata, not this Roadmap.

### Phase 2 - Main world-generation features

- [ ] Install BetterStructures as an ordinary Plugin integration
- [ ] Enable it only in `main`, `main_nether`, and `main_end`
- [ ] Keep `resource`, `resource_nether`, and `resource_end` disabled
- [ ] Confirm one representative new persistent chunk and one Resource exclusion

### Phase 3 - Final persistent Main generation

- [ ] Approve exact paths, backups, generation conditions, and Spawn safety
- [ ] Finalize `main`, `main_nether`, and `main_end` only after generation-affecting Plugins are selected
- [ ] Preserve Resource and entry worlds outside the destructive scope

This is destructive work and requires an independently approved, path-checked task.

### Phase 4 - Main lightweight gameplay

- [ ] Install EvenMoreFish
- [ ] Load the adopted Config
- [ ] Run one representative Command or catch
- [ ] Check the configuration for an explicit mcMMO Fishing conflict

Do not turn this ordinary Plugin integration into exhaustive catch, command, reward, or unrelated regression testing.

### Phase 5 - Select and install one playable Frontier Theme

- [ ] Compare candidates for Paper 1.21.11／Java 25, installation, License, cost, dependencies, Resource Pack, worlds, and actual play
- [ ] Obtain user approval and manually acquire the selected artifacts
- [ ] Install one Theme and confirm its representative entrance/start
- [ ] Use normal Frontier inventory and shared mcMMO
- [ ] Keep WM rewards, achievements, Main rewards, Theme inventory, and initial equipment disabled for V0.1.0

A World Generator alone is not assumed to satisfy the playable-theme requirement.

### Phase 6 - User-built Hubs and Gate structures

The user manually builds and approves:

- [ ] Lobby minimum Hub, Main Gate, and Frontier Gate
- [ ] Main initial Spawn Hub, Lobby Return, Frontier Gate, and three Resource Gates
- [ ] Frontier Gate minimum Hub, Theme Gate, and Theme Return destination
- [ ] Return Gate structure for each Resource world
- [ ] Safe Resource End outer-island structure

Codex does not infer or generate appearance, coordinates, orientation, or destinations without explicit user input.

### Phase 7 - Advanced Portals and Gate integration

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

- [ ] Install after final persistent Main generation
- [ ] Adopt it for investigation and partial rollback
- [ ] Perform only normal Plugin Integration verification

CoreProtect does not replace the cold backup.

### Phase 10 - Integrated operations Script

- [ ] Implement formal `Wayfarer.ps1` actions: Start, Stop, Restart, Status, Backup
- [ ] Preserve dependency order, user-disconnect handling, normal stop, process checks, and incomplete-generation safety
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

- Ver.0.0.4 permission model implementation
- BetterStructures restricted to persistent Main dimensions
- Final generation of `main`, `main_nether`, and `main_end`
- EvenMoreFish
- One playable Frontier Theme
- Lobby minimum Hub
- Main initial Spawn Hub
- Frontier Gate minimum Hub
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
- LAB

Accepted compromises and future solution candidates are detailed in [Deferred Design Items](11-deferred-design-items.md).
