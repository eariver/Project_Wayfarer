# Waymark Economy - 100x Nominal Alpha Baseline

## Scope

Waymark (`WM`) is Project Wayfarer's shared network balance for Main and Frontier. RedisEconomy `4.5.12-wayfarer.1` stores the balance in Redis, VaultUnlocked 2.20.2 exposes it through Vault, EconomyShopGUI 7.1.1 Free provides the Vanilla-item shop, and EvenMoreFish 2.4.3 provides fish sales only on Main.

Frontier shares the balance but does not load EconomyShopGUI or provide an installed reward source. Lobby does not participate in Waymark. Normal inventories remain local to each backend, so a shop purchase changes only Main inventory while the resulting balance is visible on Frontier.

The initial shop is a conservative Alpha baseline:

- fixed price per single item, scaled exactly 100x from the earlier nominal baseline, with no standard Vanilla price below 1 WM;
- Vanilla items only;
- five Main-only GUI categories;
- sell-only gathering categories and buy-only building/supply categories;
- buy price strictly greater than sell price for every item offered in both directions;
- no tax, dynamic pricing, global/server stock, player shop, or automatic price adjustment;
- no general-player `/sellall`, Sell GUI, editor, reload, give, update, debug, bypass, or wildcard access.

The 100x change preserved relative values, categories, directions, and buy/sell spreads. Existing balances were not multiplied, reset, migrated, or edited directly.

## Sell prices

All values are WM per item.

### 資源売却 (`sell_resources`)

| Item | Sell |
|---|---:|
| DIRT | 1.00 |
| COBBLESTONE | 2.00 |
| COBBLED_DEEPSLATE | 3.00 |
| SAND | 4.00 |
| GRAVEL | 3.00 |
| OAK_LOG | 8.00 |
| SPRUCE_LOG | 8.00 |
| BIRCH_LOG | 8.00 |
| JUNGLE_LOG | 8.00 |
| ACACIA_LOG | 8.00 |
| DARK_OAK_LOG | 8.00 |
| MANGROVE_LOG | 8.00 |
| CHERRY_LOG | 8.00 |
| PALE_OAK_LOG | 8.00 |
| COAL | 10.00 |
| RAW_COPPER | 8.00 |
| RAW_IRON | 25.00 |
| RAW_GOLD | 50.00 |
| REDSTONE | 4.00 |
| LAPIS_LAZULI | 5.00 |
| DIAMOND | 400.00 |
| QUARTZ | 3.00 |

`QUARTZ` is the valid Paper 26.2 Material ID for the Nether Quartz item. Stripped logs, wood, stripped wood, stems, and hyphae are not included.

### 農業品売却 (`sell_farming`)

| Item | Sell |
|---|---:|
| WHEAT | 2.00 |
| CARROT | 2.00 |
| POTATO | 2.00 |
| BEETROOT | 2.00 |
| NETHER_WART | 2.00 |
| SUGAR_CANE | 3.00 |

### Mob素材売却 (`sell_mob_drops`)

| Item | Sell |
|---|---:|
| BONE | 3.00 |
| ROTTEN_FLESH | 3.00 |
| STRING | 4.00 |
| GUNPOWDER | 8.00 |
| ENDER_PEARL | 20.00 |
| BLAZE_ROD | 35.00 |
| SHULKER_SHELL | 200.00 |

## Buy prices

All values are WM per item.

### 建築資材 (`buy_building`)

| Item | Buy |
|---|---:|
| DIRT | 8.00 |
| COBBLESTONE | 12.00 |
| COBBLED_DEEPSLATE | 18.00 |
| SAND | 25.00 |
| GRAVEL | 20.00 |
| OAK_LOG | 40.00 |
| SPRUCE_LOG | 40.00 |
| BIRCH_LOG | 40.00 |
| JUNGLE_LOG | 40.00 |
| ACACIA_LOG | 40.00 |
| DARK_OAK_LOG | 40.00 |
| MANGROVE_LOG | 40.00 |
| CHERRY_LOG | 40.00 |
| PALE_OAK_LOG | 40.00 |
| STONE_BRICKS | 20.00 |
| GLASS | 30.00 |
| BRICKS | 35.00 |
| TERRACOTTA | 40.00 |
| WHITE_WOOL | 50.00 |

### 生活用品 (`buy_supplies`)

| Item | Buy |
|---|---:|
| TORCH | 8.00 |
| LANTERN | 60.00 |
| BREAD | 30.00 |
| BONE_MEAL | 10.00 |
| REDSTONE | 25.00 |
| COAL | 50.00 |
| IRON_INGOT | 200.00 |
| GOLD_INGOT | 400.00 |

The initial buy list intentionally excludes diamonds, emeralds, Netherite items, Elytra, Shulker Boxes, enchanted books, Mending, weapons, armor, tools, potions, spawn eggs, Totems of Undying, Beacons, Nether Stars, custom items, Frontier items, and command items.

## EvenMoreFish sales

`/emf shop` sells caught EvenMoreFish fish; it does not sell fish to players. The nominal value is:

```text
fish size × rarity worth-multiplier × Vault multiplier 1.0
```

| Rarity | Worth multiplier | Config size range | Reference price range |
| --- | ---: | ---: | ---: |
| Junk | 0.0 | none | not sellable |
| Common | 1.0 | 1–30 | 1–30 WM |
| Rare | 0.5 | 20–150 | 10–75 WM |
| Epic | 0.3 | 125–800 | 37.5–240 WM |
| Legendary | 0.2 | 800–4000 | 160–800 WM |

EvenMoreFish performs its own display/rounding. `/emf sellall`, fish purchase, Bait purchase, competition rewards, PlayerPoints, Claim Blocks, and direct MONEY events are disabled. Coinfish remains an ordinary Epic fish, but its vendor-default direct-money interaction and misleading lore were removed. The only adopted EvenMoreFish WM source is a confirmed Fish Shop sale.

## Permission boundary

LuckPerms applies these nodes to the existing `default` group only in the `server=main` context. This is the current shop permission boundary. Phase 1A has implemented the Ver.0.0.5 Eligibility／Temporary Role security boundary, but it does not broaden these default shop nodes; the Admin Role receives full access only while its Temporary Parent is active, and the Builder Role receives no EconomyShopGUI administration.

Allowed:

- `economyshopgui.shop`
- `economyshopgui.shop.sell_resources`
- `economyshopgui.shop.sell_farming`
- `economyshopgui.shop.sell_mob_drops`
- `economyshopgui.shop.buy_building`
- `economyshopgui.shop.buy_supplies`
- `emf.shop`

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
- `emf.sellall`
- `emf.admin`

No test group, OP dependency, or permanent test-user permission is used.

## Operations and adjustment policy

The active Config, Japanese language file, section definitions, and shop definitions are tracked under `servers/main/plugins/EconomyShopGUI/`. The JAR, cache, transaction/runtime data, generated backups, other generated language files, and archived Vendor defaults are ignored. Update checking, transaction logging, spawner integration, bulk-sell and administration GUI commands are disabled. Version 7.1.1 generated no Plugin-local metrics key; the existing server-local global bStats setting was inspected but not changed.

Change prices only through a reviewed Config change followed by YAML and Paper Material validation, buy/sell spread checks, and a normal Main restart. Do not reload EconomyShopGUI, RedisEconomy, or VaultUnlocked through PlugManX. Do not edit Redis keys directly.

Prices are intentionally conservative and may be adjusted after observing normal resource production, purchase demand, inflation, and progression pace. A future adjustment must continue to check direct buy/sell spreads and obvious crafting, smelting, and stonecutting arbitrage.

For V0.1.0, the Main Vanilla-material Shop and EvenMoreFish fish sales are the implemented Waymark sources/uses. The initial Frontier Theme does not grant WM, and V0.1.0 does not add Theme equipment purchases, Frontier utilities, teleporter fees, achievements, or Main-side achievement rewards.

Future work remains separately scoped and is not a V0.1.0 Release Blocker:

- Frontier-, EliteMobs-, and Quest-based Waymark rewards;
- fish purchase, Bait purchase, and competition economy;
- cross-server shops;
- dynamic pricing, player shops, global stock, and automatic price adjustment.
- WM-backed Theme equipment, Frontier utilities, Main teleporters, storage expansion, cosmetics, convenience features, and special/over-enchanted tools.

Administrator commands may be used for bounded acceptance tests and recovery, but must not become the normal gameplay currency source. Test balances must be restored through RedisEconomy's supported administration command.

Immediately before the final V0.1.0 baseline backup, a separately approved destructive task resets all Waymark balances and the approved Vanilla player-state scope. This task does not migrate current balances and must never edit Redis keys directly.

Open tradeoffs and custom-Plugin candidates are tracked in [Deferred Design Items](11-deferred-design-items.md).
