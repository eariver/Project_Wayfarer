# Acceptance Tests

## Network and security

- [ ] Client 26.2 connects to Velocity and enters Lobby.
- [ ] Direct connections to backend ports fail from non-local interfaces.
- [ ] Player UUID and skin are correct on all backends.
- [ ] Stopping Main unexpectedly sends the player to Lobby rather than disconnecting.
- [ ] ViaBackwards is absent from the repository and runtime.
- [ ] Client 26.2 enters Frontier 1.21.11 through ViaVersion.

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
