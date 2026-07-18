# Custom Plugin Roadmap

No custom Plugin is required for the initial Ver.0.0.2 launch. The following components are future phases.

## Phase A - NetworkExpedition Core

- Shared player profile and unlock flags
- MariaDB schema and migrations
- Economy interface through VaultUnlocked/RedisEconomy
- Audit log and safe transaction primitives

## Phase B - Transit Vault

- Explicit shared GUI between Main and Frontier
- Slots unlocked through Waymark and later achievements
- Initially allow vanilla/common items only
- Reject Plugin-specific PDC, custom model data and unsafe containers
- MariaDB locking, idempotent transaction IDs and recovery of incomplete operations

## Phase C - Expedition Gear

- Main-origin authenticated equipment may travel to Frontier and return
- Network item UUID and lifecycle state
- Same runtime Plugin and item definition on Main and Frontier
- Reject or quarantine unsupported Frontier modifications

## Phase D - Frontier Achievements

- Frontier records network achievements
- Main reads achievements and generates memorial items, recipes, facilities or unlocks
- No direct transfer of incompatible Frontier items is required

## Phase E - Frontier Storage

- Frontier-local field bag and camp storage
- Access blocked during combat, boss fights, dangerous regions or recent damage
- Capacity unlocked by Waymark and achievements
- No nesting of backpacks, shulkers or other storage items where unsafe

## Phase F - Custom Shop

- Replace or complement EconomyShopGUI
- YAML-defined product tables, buy/sell prices and unlock conditions
- World or progression-aware catalog
- Transaction audit and future dynamic pricing hooks

## Later network features

- Tutorial
- Advanced AFK detection and safe transfer to Lobby
- Planned-maintenance drain and richer failover reasons
- Creative disposable LAB server
