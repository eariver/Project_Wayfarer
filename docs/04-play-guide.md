# Play Guide - Ver.0.0.4

This guide separates the current playable state from the future V0.1.0 Alpha target. Permission Phase 1A is available, but Ver.0.0.4 does not mean that planned Hubs, Gates, the final Builder allowlist, or Frontier content are already available.

## 1. Entering the network

Every login begins in Lobby. Lobby is not part of the Waymark economy or character progression. Physical Gate routing and the minimum Hub are not built or connected; use only the currently verified server-switch path until the later Gate Integration is complete.

## 2. Main

Main is the permanent home for building, farming, storage, fishing and general survival exploration.

- Use `main`, `main_nether` and `main_end` for permanent construction.
- mcMMO progression is shared with Frontier; normal inventory and vanilla player state remain local.
- Waymark balance is shared with Frontier. Main provides a five-category fixed-price shop through `/shop`; see [Waymark Economy](10-waymark-economy.md).
- BetterStructures and EvenMoreFish are planned but not installed.
- The permanent spawn Hub, normal Respawn location, Lobby/Frontier Return Gates, and three Resource Gates are V0.1.0 targets, not current features.

## 3. Resource worlds

The installed `resource`, `resource_nether` and `resource_end` worlds are disposable gathering worlds managed by Multiverse.

- They are designed for near-vanilla generation.
- BetterStructures must remain disabled in them.
- They are disposable, so permanent construction does not belong there.
- Direct Main Hub gates and the Resource End outer-island arrival route are not installed yet; use only administrator-approved access until those routes are verified.
- Every future reset must restore a safe arrival and Main Return Gate. `resource_end` also needs a reproducible safe outer-island site independent of Dragon portals.

## 4. Frontier

Frontier is currently a separate protected entry environment. V0.1.0 requires one playable Theme, but the Theme and its portal routing are not selected or installed.

- Frontier uses a separate local inventory.
- Items do not move between Main and Frontier.
- mcMMO progression and Waymark balance are shared with Main.
- Frontier does not yet provide an installed Waymark reward source.
- EconomyShopGUI is not installed on Frontier; spend and sell through Main's `/shop`.
- Any future Frontier-specific equipment must stay in Frontier.
- Death initially follows vanilla rules.
- V0.1.0 continues to use the normal Frontier inventory and shared mcMMO; it does not add Frontier WM rewards, Theme achievements, Main-side achievement rewards, Theme-specific inventories, or initial Theme equipment.

## 5. Network presentation

TAB currently shows the `Project Wayfarer` header and the current server, network online count and ping footer. Cross-server chat and a TAB Waymark placeholder are not installed and must not be presented as available until their integrations are verified.

## 6. Long-term progression

Later revisions plan to add:

- unlockable cross-server storage slots;
- Main equipment that can be certified for Frontier expeditions;
- Frontier achievements and Main-side memorial rewards;
- Frontier-local expanded storage;
- lighter configurable death penalties;
- additional reward sources, cross-server shops and meta progression.

## 7. Building responsibility for V0.1.0

The user manually builds and approves the Lobby minimum Hub, Main spawn Hub, Frontier Gate Hub, Gate structures, Resource Return structure, and Resource End outer-island structure. Codex configures the exact Gate routes, Spawn/Arrival settings, and required protection only after the user supplies confirmed worlds, coordinates, orientation, and safe destinations. No structure is generated or replaced from this specification alone.

## 8. Temporary Role membership

The five-group Phase 1A LuckPerms foundation is implemented. Group definitions and Eligibility are persistent; eligible Players temporarily add themselves as a Parent member of Builder or Admin through Velocity `/lpv` rather than holding permanent Role membership or OP. Builder's normal membership duration is 2 hours and Admin's is 30 minutes. Remove one Role before adding the other.

The current Builder is only a Role container and WorldGuard member for protected-entry building. Its WorldEdit, gamemode, teleport, Multiverse, and other final allowlist permissions remain Phase 1B work. After future Builder work, return to Survival and remove the temporary Parent; expiry does not automatically clean up gamemode. See [Permission Model](12-permission-model.md).
