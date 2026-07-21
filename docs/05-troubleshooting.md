# Troubleshooting - Ver.0.0.5

This document records focused operational checks. Do not expose secrets, download replacement JARs automatically, or use database-destructive commands as routine recovery.

## EvenMoreFish

- No Custom Fish: confirm the player is on Main in actual Bukkit world `main` or `resource`, the Main-only JAR is present, and the rendered Config has no unresolved token. Nether, End, and unknown worlds are intentionally excluded; `main_end` is only a Multiverse alias and is not the actual End world name.
- Startup database failure: verify Docker/MariaDB health, the dedicated `wayfarer_evenmorefish` database, and the ignored rendered Config. Do not print credentials or run Flyway clean/repair/drop.
- Journal missing after restart: stop progression testing and preserve logs/database before further writes. Journal/statistics persistence is an accepted baseline.
- No mcMMO Fishing XP or duplicate loot: confirm EvenMoreFish keeps mcMMO loot disabled while mcMMO itself remains enabled. The adopted result is one Custom Fish item with normal mcMMO Fishing XP.
- Fish Shop button missing or `/emf shop` denied: verify the tracked Main GUI, `emf.shop=true` only in `server=main`, and perform a full Main restart.
- Vault is not recognized or fish cannot enter the sell slot: verify VaultUnlocked, RedisEconomy as the Vault provider, the rendered Runtime Config, and the five tracked Rarity files.
- Fish value is zero: Junk intentionally uses 0.0; for other Rarities verify the adopted multiplier and loaded file. Do not enable another economy provider.
- Coinfish or another fish grants WM directly: search active adopted Rarity files for `MONEY`. Only Fish Shop sale is allowed; examples remain ignored/disabled.
- `/emf sellall`, PlayerPoints, Claim Blocks, competition, or direct MONEY activity appears: treat this as a configuration regression and restart after correcting the tracked policy.
- Japanese messages fail to load: retain the tracked Japanese messages and restart Main normally; do not fetch or overwrite Plugin artifacts automatically.

EvenMoreFish 2.4.3 bundles NBT-API 2.15.7, which emits a compatibility warning for the Paper 26.2 build string. Its representative Custom Fish item and Journal worked, so this is currently non-blocking; monitor it when the Plugin changes. Flyway 12.2.0 also reports MariaDB 11.8 as newer than its verified 11.7 range; migration, reconnect, preload, and restart persistence all passed. Neither warning authorizes binary replacement or database repair.

## Existing startup noise

The free BetterStructures content pack can emit legacy `minecraft:bed` DataFixer errors on Minecraft 26.2 while still completing initialization. This is an existing upstream-content issue, not an EvenMoreFish failure. Re-evaluate it only when BetterStructures or its content pack changes.

## EconomyShopGUI prices

If old prices remain visible, verify the five tracked `shops/*.yml` files rather than cache, backup, or vendor-default copies. Confirm YAML and Material validation, exact 100x comparison, then restart Main normally. Do not use Plugin reload or perform a transaction merely to diagnose display caching.
