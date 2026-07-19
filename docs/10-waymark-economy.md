# Waymark Economy - Initial Alpha Baseline

## Scope

Waymark (`WM`) is Project Wayfarer's shared network balance for Main and Frontier. RedisEconomy `4.5.12-wayfarer.1` stores the balance in Redis, VaultUnlocked 2.20.2 exposes it through Vault, and EconomyShopGUI 7.1.1 Free provides the initial shop only on Main.

Frontier shares the balance but does not load EconomyShopGUI or provide an installed reward source. Lobby does not participate in Waymark. Normal inventories remain local to each backend, so a shop purchase changes only Main inventory while the resulting balance is visible on Frontier.

The initial shop is a conservative Alpha baseline:

- fixed price per single item, in increments no smaller than 0.01 WM;
- Vanilla items only;
- five Main-only GUI categories;
- sell-only gathering categories and buy-only building/supply categories;
- buy price strictly greater than sell price for every item offered in both directions;
- no tax, dynamic pricing, global/server stock, player shop, or automatic price adjustment;
- no general-player `/sellall`, Sell GUI, editor, reload, give, update, debug, bypass, or wildcard access.

## Sell prices

All values are WM per item.

### 資源売却 (`sell_resources`)

| Item | Sell |
|---|---:|
| DIRT | 0.01 |
| COBBLESTONE | 0.02 |
| COBBLED_DEEPSLATE | 0.03 |
| SAND | 0.04 |
| GRAVEL | 0.03 |
| OAK_LOG | 0.08 |
| SPRUCE_LOG | 0.08 |
| BIRCH_LOG | 0.08 |
| JUNGLE_LOG | 0.08 |
| ACACIA_LOG | 0.08 |
| DARK_OAK_LOG | 0.08 |
| MANGROVE_LOG | 0.08 |
| CHERRY_LOG | 0.08 |
| PALE_OAK_LOG | 0.08 |
| COAL | 0.10 |
| RAW_COPPER | 0.08 |
| RAW_IRON | 0.25 |
| RAW_GOLD | 0.50 |
| REDSTONE | 0.04 |
| LAPIS_LAZULI | 0.05 |
| DIAMOND | 4.00 |
| QUARTZ | 0.03 |

`QUARTZ` is the valid Paper 26.2 Material ID for the Nether Quartz item. Stripped logs, wood, stripped wood, stems, and hyphae are not included.

### 農業品売却 (`sell_farming`)

| Item | Sell |
|---|---:|
| WHEAT | 0.02 |
| CARROT | 0.02 |
| POTATO | 0.02 |
| BEETROOT | 0.02 |
| NETHER_WART | 0.02 |
| SUGAR_CANE | 0.03 |

### Mob素材売却 (`sell_mob_drops`)

| Item | Sell |
|---|---:|
| BONE | 0.03 |
| ROTTEN_FLESH | 0.03 |
| STRING | 0.04 |
| GUNPOWDER | 0.08 |
| ENDER_PEARL | 0.20 |
| BLAZE_ROD | 0.35 |
| SHULKER_SHELL | 2.00 |

## Buy prices

All values are WM per item.

### 建築資材 (`buy_building`)

| Item | Buy |
|---|---:|
| DIRT | 0.08 |
| COBBLESTONE | 0.12 |
| COBBLED_DEEPSLATE | 0.18 |
| SAND | 0.25 |
| GRAVEL | 0.20 |
| OAK_LOG | 0.40 |
| SPRUCE_LOG | 0.40 |
| BIRCH_LOG | 0.40 |
| JUNGLE_LOG | 0.40 |
| ACACIA_LOG | 0.40 |
| DARK_OAK_LOG | 0.40 |
| MANGROVE_LOG | 0.40 |
| CHERRY_LOG | 0.40 |
| PALE_OAK_LOG | 0.40 |
| STONE_BRICKS | 0.20 |
| GLASS | 0.30 |
| BRICKS | 0.35 |
| TERRACOTTA | 0.40 |
| WHITE_WOOL | 0.50 |

### 生活用品 (`buy_supplies`)

| Item | Buy |
|---|---:|
| TORCH | 0.08 |
| LANTERN | 0.60 |
| BREAD | 0.30 |
| BONE_MEAL | 0.10 |
| REDSTONE | 0.25 |
| COAL | 0.50 |
| IRON_INGOT | 2.00 |
| GOLD_INGOT | 4.00 |

The initial buy list intentionally excludes diamonds, emeralds, Netherite items, Elytra, Shulker Boxes, enchanted books, Mending, weapons, armor, tools, potions, spawn eggs, Totems of Undying, Beacons, Nether Stars, custom items, Frontier items, and command items.

## Permission boundary

LuckPerms applies these nodes to the existing `default` group only in the `server=main` context. This is the current shop permission boundary. The Ver.0.0.4 Eligibility／Temporary Role model is a separate future Security Boundary implementation and does not change these Runtime nodes in the specification task.

Allowed:

- `economyshopgui.shop`
- `economyshopgui.shop.sell_resources`
- `economyshopgui.shop.sell_farming`
- `economyshopgui.shop.sell_mob_drops`
- `economyshopgui.shop.buy_building`
- `economyshopgui.shop.buy_supplies`

Explicitly denied:

- `economyshopgui.sellall`
- `economyshopgui.sellallitem`
- `economyshopgui.sellallhand`
- `economyshopgui.sellgui`
- `economyshopgui.reload`
- `economyshopgui.eshop.*`
- `economyshopgui.shopgive`
- `economyshopgui.itemindexes`
- `economyshopgui.notifyupdate`

No test group, OP dependency, or permanent test-user permission is used.

## Operations and adjustment policy

The active Config, Japanese language file, section definitions, and shop definitions are tracked under `servers/main/plugins/EconomyShopGUI/`. The JAR, cache, transaction/runtime data, generated backups, other generated language files, and archived Vendor defaults are ignored. Update checking, transaction logging, spawner integration, bulk-sell and administration GUI commands are disabled. Version 7.1.1 generated no Plugin-local metrics key; the existing server-local global bStats setting was inspected but not changed.

Change prices only through a reviewed Config change followed by YAML and Paper Material validation, buy/sell spread checks, and a normal Main restart. Do not reload EconomyShopGUI, RedisEconomy, or VaultUnlocked through PlugManX. Do not edit Redis keys directly.

Prices are intentionally conservative and may be adjusted after observing normal resource production, purchase demand, inflation, and progression pace. A future adjustment must continue to check direct buy/sell spreads and obvious crafting, smelting, and stonecutting arbitrage.

For V0.1.0, this Main Vanilla-material Shop remains Waymark's primary implemented use. The initial Frontier Theme does not grant WM, and V0.1.0 does not add Theme equipment purchases, Frontier utilities, teleporter fees, achievements, or Main-side achievement rewards.

Future work remains separately scoped and is not a V0.1.0 Release Blocker:

- Frontier-, EliteMobs-, EvenMoreFish-, and Quest-based Waymark rewards;
- cross-server shops;
- dynamic pricing, player shops, global stock, and automatic price adjustment.
- WM-backed Theme equipment, Frontier utilities, Main teleporters, storage expansion, cosmetics, convenience features, and special/over-enchanted tools.

Administrator commands may be used for bounded acceptance tests and recovery, but must not become the normal gameplay currency source. Test balances must be restored through RedisEconomy's supported administration command.

Open tradeoffs and custom-Plugin candidates are tracked in [Deferred Design Items](11-deferred-design-items.md).
