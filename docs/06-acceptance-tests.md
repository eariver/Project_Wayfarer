# Acceptance Tests

## Network and security

- [ ] Client 26.2 connects to Velocity and enters Lobby.
- [ ] Direct connections to backend ports fail from non-local interfaces.
- [ ] Player UUID and skin are correct on all backends.
- [ ] Stopping Main unexpectedly sends the player to Lobby rather than disconnecting.
- [ ] ViaBackwards is absent from the repository and runtime.
- [ ] Client 26.2 enters Frontier 1.21.11 through ViaVersion.

## Verified void entry-world baseline (2026-07-19)

- [x] VoidGen 2.3.8 loads on Lobby Paper 26.2 / Java 25 and Frontier Paper 1.21.11 / Java 21.
- [x] VoidGen is absent from Main and Velocity.
- [x] Lobby and Frontier spawn the player safely on the gold center block without falling or suffocating.
- [x] The 17x17 safety platforms persist after a clean restart, with air below and no distant vanilla terrain.
- [x] Lobby and Frontier preserve inventory after a void fall and respawn at the center platform.
- [x] Main remains unchanged, server switching works in both directions, and direct backend connections remain rejected.
- [x] Lobby and Frontier do not load Nether or End; Main retains its three configured dimensions.

## Verified Lobby building-protection baseline (2026-07-19)

- [x] WorldEdit 7.4.4 and WorldGuard 7.0.17 load on Lobby Paper 26.2 / Java 25 in dependency order.
- [x] WorldEdit and WorldGuard are absent from Main, Frontier, and Velocity.
- [x] The Lobby `__global__` region denies `passthrough`, contains only `g:wayfarer_builder`, and has no `build` flag.
- [x] PvP, mob spawning, creeper/other explosions, TNT, fire spread, and lighter use are denied.
- [x] `wayfarer_builder` receives `worldedit.*` and `worldguard.*` only in `server=lobby`.
- [x] A non-OP, non-Builder player cannot break or place blocks before or after a clean restart.
- [x] A temporary Builder can break and restore one block, perform and undo a one-block WorldEdit operation, and inspect the global region.
- [x] The temporary Builder parent is removed; no permanent test-user membership remains.
- [x] Lobby safety markers, Main terrain/dimensions, Frontier Void World, and network switching remain unchanged.

## Permissions

- [ ] LuckPerms changes propagate to all instances.
- [ ] `server` context prevents LAB/test or administration rights from leaking to Main/Lobby.
- [ ] Normal operation does not require OP.

## Chat and TAB

- [ ] Chat from each backend is visible everywhere with correct origin tag.
- [ ] TAB lists players across all backends.
- [ ] Backend placeholders update after switching servers.

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
