# Source Registry (checked 2026-07-20)

- Paper getting started / Java requirements: https://docs.papermc.io/paper/getting-started/
- Velocity getting started: https://docs.papermc.io/velocity/getting-started/
- Velocity configuration: https://docs.papermc.io/velocity/configuration/
- Velocity modern forwarding: https://docs.papermc.io/velocity/player-information-forwarding/
- Velocity security: https://docs.papermc.io/velocity/security/
- LuckPerms network installation: https://luckperms.net/wiki/Network-Installation
- LuckPerms storage types: https://luckperms.net/wiki/Storage-types
- TAB installation: https://github.com/NEZNAMY/TAB/wiki/Installation
- TAB placeholders: https://github.com/NEZNAMY/TAB/wiki/Placeholders
- TAB releases: https://github.com/NEZNAMY/TAB/releases
- TAB-Bridge releases: https://github.com/NEZNAMY/TAB-Bridge/releases
- VelocityScoreboardAPI: https://github.com/WiIIiam278/VelocityScoreboardAPI
- PlaceholderAPI: https://www.spigotmc.org/resources/placeholderapi.6245/
- PlugManX candidate (version unselected): https://modrinth.com/plugin/plugmanx
- ViaVersion setup: https://viaversion.com/setup
- Multiverse-Core: https://modrinth.com/plugin/multiverse-core
- Multiverse-NetherPortals: https://modrinth.com/plugin/multiverse-netherportals
- mcMMO source project: https://github.com/mcMMO-Dev/mcMMO
- EvenMoreFish: https://modrinth.com/plugin/evenmorefish
- RedisEconomy upstream release: https://www.spigotmc.org/resources/105965/
- RedisEconomy upstream source: https://github.com/Emibergo02/RedisEconomy
- VaultUnlocked: https://hangar.papermc.io/TNE/VaultUnlocked
- EconomyShopGUI official release page: https://www.spigotmc.org/resources/economyshopgui.69927/
- EconomyShopGUI release history: https://www.spigotmc.org/resources/economyshopgui.69927/updates
- EconomyShopGUI official Wiki: https://wiki.gpplugins.com/economyshopgui
- EconomyShopGUI configuration: https://wiki.gpplugins.com/economyshopgui/file-configuration/config.yml
- EconomyShopGUI section/shop formats: https://wiki.gpplugins.com/economyshopgui/file-configuration/sections.yml and https://wiki.gpplugins.com/economyshopgui/file-configuration/shops.yml
- EconomyShopGUI permissions and commands: https://wiki.gpplugins.com/economyshopgui/basics/permission and https://wiki.gpplugins.com/economyshopgui/basics/commands
- BetterStructures: https://modrinth.com/plugin/betterstructures
- EliteMobs: https://modrinth.com/plugin/elitemobs
- WorldEdit: https://enginehub.org/worldedit
- WorldEdit source and GPLv3 license: https://github.com/EngineHub/WorldEdit
- WorldEdit 7.4.4 Bukkit release (1.21.4-26.2): https://modrinth.com/plugin/worldedit/version/qNuPcliz
- WorldGuard source and LGPLv3 license: https://github.com/EngineHub/WorldGuard
- WorldGuard 7.0.17 Bukkit release: https://modrinth.com/plugin/worldguard/version/pI4UHLJL
- WorldGuard global region design: https://worldguard.enginehub.org/en/latest/regions/global-region/
- WorldGuard region commands: https://worldguard.enginehub.org/en/latest/regions/commands/
- VoidGen 2.3.8 release: https://modrinth.com/plugin/voidgen/version/2.3.8
- VoidGen world-generator setup: https://github.com/NicoNekoDev/VoidGen/blob/master/docs/tutorial.md

Before downloading, verify the exact build's Minecraft version, Java version, platform, dependencies, license and release notes.

Project Wayfarer currently uses the user-supplied `RedisEconomy 4.5.12-wayfarer.1` compatibility build, not a binary downloaded from the upstream release URL. Its exact SHA-256 and compatibility investigation are recorded in `versions.yml` and [the investigation report](investigations/2026-07-19-rediseconomy-paper-26-2-message-compatibility.md).

EconomyShopGUI 7.1.1 Free was manually supplied by the user and verified on Main Paper 26.2 / Java 25. Version 7.1.0 introduced Minecraft 26.2 support and 7.1.1 is the adopted follow-up release. The JAR was not downloaded or redistributed by Codex; exact metadata and SHA-256 are recorded in `versions.yml` and `plugin-manifest.yml`.
