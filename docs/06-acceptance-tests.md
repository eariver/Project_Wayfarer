# Acceptance Tests

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

- [ ] Main Overworld portal links to `main_nether` and `main_end` as designed.
- [ ] Resource portal links to `resource_nether` and `resource_end` as designed.
- [ ] Persistent dimensions generate appropriate additional structures in new chunks.
- [ ] Resource dimensions contain no BetterStructures content.
- [ ] Resource reset script cannot target Main worlds.

## Economy and progression

- [ ] RedisEconomy balance is identical on Main and Frontier.
- [ ] Lobby does not expose or modify Waymark.
- [ ] mcMMO progression earned on Main appears on Frontier after a server switch and vice versa.
- [ ] Rapid switching does not lose the most recent mcMMO progress.
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
