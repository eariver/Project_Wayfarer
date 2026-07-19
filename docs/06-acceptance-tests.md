# Acceptance Tests

## Verification policy

- Completed baselines remain recorded as verified facts.
- Future ordinary third-party Plugin integrations focus on exact placement, dependencies, adopted Config, successful startup, one representative smoke test and obvious regressions.
- Exhaustive command, Config-key and unused-feature testing is not required for routine integrations.
- Detailed verification remains mandatory for persistent worlds/data, economy/shared progression, inventory synchronization, permissions/secrets, protocol conversion, portal/dimension routing, backup/restore, failover and irreversible changes.
- Minor non-security display or Config issues found during small-scale operation may be corrected in a later focused Commit.

## Network and security

- [ ] Client 26.2 connects to Velocity and enters Lobby.
- [ ] Direct connections to backend ports fail from non-local interfaces.
- [ ] Player UUID and skin are correct on all backends.
- [ ] Stopping Main unexpectedly sends the player to Lobby rather than disconnecting.
- [ ] ViaBackwards is absent from the repository and runtime.
- [ ] Client 26.2 enters Frontier 1.21.11 through ViaVersion.

## Verified void entry-world baseline (2026-07-19)

- [x] VoidGen 2.3.8 loads on Lobby Paper 26.2 / Java 25 and Frontier Paper 1.21.11 / Java 25.
- [x] VoidGen is absent from Main and Velocity.
- [x] Lobby and Frontier spawn the player safely on the gold center block without falling or suffocating.
- [x] The 17x17 safety platforms persist after a clean restart, with air below and no distant vanilla terrain.
- [x] Lobby and Frontier preserve inventory after a void fall and respawn at the center platform.
- [x] Main remains unchanged, server switching works in both directions, and direct backend connections remain rejected.
- [x] Lobby and Frontier do not load Nether or End; Main retains its three configured dimensions.

## Verified all-Paper WorldEdit/WorldGuard baseline (2026-07-19)

- [x] WorldEdit 7.4.4 and WorldGuard 7.0.17 load in dependency order on Lobby, Main, and Frontier with Java 25.
- [x] The same verified JAR and SHA-256 are used on all Paper backends; both Plugins are absent from Velocity.
- [x] Lobby and `frontier_gate` deny `passthrough`, contain only `g:wayfarer_builder`, and have no `build` flag.
- [x] Both protected entry worlds deny PvP, mob spawning, creeper/other explosions, TNT, fire spread, and lighter use.
- [x] Main's Overworld, Nether, and End Global Regions have no Flags, Owners, or Members, and normal Survival building remains available.
- [x] `wayfarer_builder` receives `worldedit.*` and `worldguard.*` only in `server=lobby` and `server=frontier`; Main remains excluded.
- [x] A non-OP, non-Builder player cannot break or place blocks in Lobby/Frontier before or after a clean restart.
- [x] A temporary Builder can build, perform and undo a one-block WorldEdit operation, and inspect the Frontier Global Region.
- [x] Main rejects WorldEdit and WorldGuard administration commands for the same temporary Builder while allowing normal building.
- [x] The temporary Builder parent is removed; no permanent test-user membership remains.
- [x] Lobby/Frontier safety markers, Main terrain/dimensions, ViaVersion switching, and network routing remain unchanged.

## Permissions

- [ ] LuckPerms changes propagate to all instances.
- [ ] `server` context prevents LAB/test or administration rights from leaking to Main/Lobby.
- [ ] Normal operation does not require OP.

## Chat and TAB

- [ ] Chat from each backend is visible everywhere with correct origin tag.
- [x] TAB 6.1.0 and VelocityScoreboardAPI 2.1.0 load only on Velocity; TAB-Bridge 6.2.2 and PlaceholderAPI 2.12.3 load on every Paper backend.
- [x] The baseline displays only the `Project Wayfarer` header and the current server, network online count, and ping footer.
- [x] A Minecraft 26.2 client completes Lobby -> Main -> Frontier -> Lobby without display duplication, disconnect, or protocol error.
- [x] Lobby/Frontier protection, Main normal building, and the existing ViaVersion route show no regression during the display smoke test.
- [x] After a clean network restart, the display persists and the server placeholder updates on a Lobby-to-Frontier switch.
- [x] PlaceholderAPI Cloud access is disabled and no Expansion is installed.

## Main worlds

- [x] Multiverse-Core 5.7.2 loads on all Paper backends and is absent from Velocity; Lobby and Frontier register only their existing entry worlds.
- [x] Multiverse-NetherPortals 5.0.5 loads only on Main and resolves its Multiverse-Core dependency.
- [x] Main's three existing dimensions were registered without renaming, moving, copying, recreating, or changing their seeds/generators.
- [x] `resource`, `resource_nether`, and `resource_end` were created under the Paper 26.2 namespaced storage structure with NORMAL, NETHER, and THE_END environments.
- [x] Main Overworld portal links to `main_nether` and `main_end` in both directions as designed.
- [x] Resource portal links to `resource_nether` and `resource_end` in both directions as designed.
- [x] A Minecraft 26.2 client completed one Main Nether portal round trip and one Resource Nether portal round trip; temporary test portals/blocks were restored as part of the test procedure.
- [x] `resource_end` keeps `scan-for-legacy-ender-dragon: false`, and repeated console entity queries before and after restart found no Ender Dragon.
- [x] The client loaded all six Main worlds. The current `main_end` `/mvtp` spawn caused suffocation; the user explicitly accepted this pre-gameplay condition because the world is scheduled for regeneration and normal routing will not use `/mvtp` at that location.
- [x] Lobby -> Main -> Frontier -> Lobby, TAB, ViaVersion, Lobby/Frontier protection, and Main normal building showed no regression.
- [x] After a clean network stop/restart, all six registrations, eight directional links, and the Resource End override persisted; Main -> `resource` succeeded once.
- [x] A verified pre-change backup is stored at ignored path `backups/pre-multiverse-20260719-173605` (374 files, 66.45 MiB).
- [ ] Persistent dimensions generate appropriate additional structures in new chunks.
- [x] Resource dimensions contain no BetterStructures content because BetterStructures is not installed.
- [x] The Resource reset script uses exact runtime-path mappings and explicitly rejects Main, Lobby, Frontier, and persistent namespaced keys; its destructive workflow was not run in this task.

## Economy and progression

> 正式版RedisEconomy 4.5.12のPaper 26.2 Message dispatch問題は、ユーザー提供の互換Build `4.5.12-wayfarer.1`で解消しました。原因、修正差分および再検証履歴は[Investigation Report](investigations/2026-07-19-rediseconomy-paper-26-2-message-compatibility.md)を参照してください。

- [x] RedisEconomy `4.5.12-wayfarer.1` and VaultUnlocked 2.20.2 enable on Main and Frontier; the same verified JARs are absent from Lobby and Velocity.
- [x] RedisEconomy uses shared cluster `waymark`, distinct `main`／`frontier` client names, Vault currency `vault`, Waymark unit `WM`, starting balance 0, and ignored credential Configs rendered from sanitized templates.
- [x] RedisEconomy balance is identical on Main and Frontier: 0 -> Main 100 -> Frontier 100 -> Frontier 75 -> Main 75 -> immediate switch 76, without rollback or duplicate addition.
- [x] A player payment above the 75 WM balance was rejected without creating or crediting the test recipient.
- [x] A clean Minecraft network restart and a stopped-server Redis Container restart preserved the 76 WM test balance; Vault and Redis reconnected normally.
- [x] The temporary balance was returned to 0 with RedisEconomy's administration command and confirmed on both gameplay backends.
- [x] Main and Frontier display balance and missing-player command feedback with the compatibility build; a Minecraft 26.2 client confirmed the Main/Frontier results and no material regression.
- [x] Lobby does not expose or modify Waymark.
- [x] mcMMO 2.3.000 enables on Main and Frontier from the same local Maven build and is absent from Lobby and Velocity.
- [x] Main and Frontier use `wayfarer_mcmmo` with the `mcmmo_` prefix; runtime credentials remain ignored and render from sanitized templates.
- [x] The test Profile loaded on both backends. Main Console changed Mining XP from 0 to 10, and Frontier displayed 10 after a normal Velocity switch.
- [x] Frontier Console then added 7 Mining XP, and Main displayed the cumulative 17 after switching back.
- [x] The shared database stored Mining Level 0 / XP 17 without rollback, stale-profile overwrite, or duplicate addition during the immediate switches.
- [x] After a clean network stop/restart, both Main and Frontier displayed Mining Level 0 / XP 17, with no mcMMO database or Profile load/save error.
- [x] Lobby exposes no mcMMO command or display. Existing ViaVersion routing and backend switching showed no obvious regression during the shared-progression test.
- [ ] EvenMoreFish catches, shop and journal work on Main 26.2.
- [ ] mcMMO Fishing and EvenMoreFish do not duplicate or cancel intended rewards.
- [ ] EconomyShopGUI buy/sell actions update the shared balance correctly.

## Frontier

- [ ] Entry hub contains only approved portals and minimal facilities.
- [ ] Each installed Adventure/theme loads without SEVERE errors.
- [ ] Frontier custom equipment survives logout/restart inside Frontier.
- [ ] Frontier equipment does not appear in Main inventory.
- [ ] Vanilla death behavior is confirmed.
- [ ] Frontier resource pack activates and clears/switches correctly when leaving.

## Reliability

- [ ] Three clean restart cycles preserve all intended data.
- [ ] MariaDB or Redis outage produces a controlled failure; no silent partial progression is accepted.
- [ ] spark profiles show no persistent tick overload during structure generation or Adventure combat.
- [ ] A clean baseline backup can be restored to an isolated test copy.
