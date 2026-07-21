# Plugin Collection Checklist - Ver.0.0.5

詳細な進捗管理は同梱外のXLSX台帳を使用する。JARと有償コンテンツはGitへコミットしない。

|分類|対象|名称|区分|配置先|公式URL|注意|
|---|---|---|---|---|---|---|
|Core|Velocity|Velocity|導入・検証済み|velocity/|https://papermc.io/downloads/velocity|手動取得、Java 25|
|Core|Lobby/Main|Paper 26.2|導入・検証済み|servers/lobby, servers/main|https://papermc.io/downloads/paper|Java 25|
|Core|Frontier|Paper 1.21.11|導入・検証済み|servers/frontier|https://papermc.io/downloads/paper|Java 25|
|Proxy|Velocity|LuckPerms 5.5.60|導入・検証済み|velocity/plugins|https://luckperms.net/download|共有MariaDB|
|Proxy|Velocity|ViaVersion 5.11.0|導入・検証済み|velocity/plugins|https://modrinth.com/plugin/viaversion|ViaBackwards禁止|
|Proxy|Velocity|TAB 6.1.0|導入・検証済み|velocity/plugins|https://github.com/NEZNAMY/TAB/releases|Proxy Installation、Paper配置禁止|
|Proxy|Velocity|VelocityScoreboardAPI 2.1.0|導入・検証済み|velocity/plugins|https://github.com/WiIIiam278/VelocityScoreboardAPI|Paper配置禁止、Sidebar等は未使用|
|Portal|Velocity + All Paper|Advanced Portals|計画・未導入|各plugins|https://modrinth.com/plugin/advanced-portals|Proxy／Backend Componentを一括検証|
|Common|All Paper|LuckPerms 5.5.60|導入・検証済み|各plugins|https://luckperms.net/download|共有MariaDB|
|Common|All Paper|PlaceholderAPI 2.12.3|導入・検証済み|各plugins|https://www.spigotmc.org/resources/placeholderapi.6245/|Velocity配置禁止、Expansion未導入・手動取得|
|Common|All Paper|TAB-Bridge 6.2.2|導入・検証済み|各plugins|https://github.com/NEZNAMY/TAB-Bridge/releases|Velocity配置禁止|
|Common|All Paper|WorldEdit 7.4.4|導入・検証済み|各plugins|https://modrinth.com/plugin/worldedit/version/qNuPcliz|同一JARを手動取得、Velocity禁止、Java 25|
|Common|All Paper|WorldGuard 7.0.17|導入・検証済み|各plugins|https://modrinth.com/plugin/worldguard|WorldEdit 7.4.4依存、Velocity禁止|
|World|Lobby + Frontier|VoidGen 2.3.8|導入・検証済み|servers/lobby/plugins, servers/frontier/plugins|https://modrinth.com/plugin/voidgen/version/2.3.8|Main/Velocityには配置しない|
|World|All Paper|Multiverse-Core 5.7.2|導入・検証済み|各Paper plugins|https://modrinth.com/plugin/multiverse-core|手動取得、Velocity対象外、Lobby／FrontierはEntry Worldのみ|
|World|Main|Multiverse-NetherPortals 5.0.5|導入・検証済み|servers/main/plugins|https://modrinth.com/plugin/multiverse-netherportals|Multiverse-Core依存、2 Familyを明示Link|
|Gameplay|Main + Frontier|mcMMO 2.3.000|導入・検証済み|両plugins|https://github.com/mcMMO-Dev/mcMMO|Local Maven Build、同一JAR、共有MariaDB、Lobby／Velocity対象外|
|Gameplay|Main|EvenMoreFish 2.4.3|導入・検証済み|servers/main/plugins|https://modrinth.com/plugin/evenmorefish/version/uf95yrYv|手動取得、`main`／`resource`限定、Vault魚売却、専用MariaDB、Competition／直接MONEY無効|
|Economy|Main + Frontier|RedisEconomy 4.5.12-wayfarer.1|導入・検証済み|両plugins|https://www.spigotmc.org/resources/105965/|ユーザー提供互換Build、共有Redis Waymark、Lobby／Velocity対象外|
|Economy|Main + Frontier|VaultUnlocked 2.20.2|導入・検証済み|両plugins|https://hangar.papermc.io/TNE/VaultUnlocked|RedisEconomy Vault Bridge、Lobby／Velocity対象外|
|Economy|Main|EconomyShopGUI 7.1.1 Free|導入・検証済み|servers/main/plugins|https://www.spigotmc.org/resources/economyshopgui.69927/|100倍名目固定価格、5カテゴリ・62商品、Vault経由RedisEconomy、Lobby／Frontier／Velocity対象外|
|Structure|Main|BetterStructures 2.6.3|導入・検証済み|servers/main/plugins|https://modrinth.com/plugin/betterstructures|103 Default Structuresのみ、Persistent Main Family限定、Resource全世界と未知Worldは無効、手動取得|
|Structure|Main Nether + End|Persistent Nether／End Structure Expansion|計画・未選定|別タスクで確定||Phase 2B、既存103 Default Structuresを補完、CoreProtect後、Resource Family無効維持|
|Adventure|Frontier|EliteMobs|計画・未導入|servers/frontier/plugins|https://modrinth.com/plugin/elitemobs|Content Packは別途|
|Conditional|Frontier|BetterStructures|条件付き・未導入|servers/frontier/plugins|https://modrinth.com/plugin/betterstructures|選定Packが要求するときのみ、WorldEditは導入済み|
|Administration|未定|CoreProtect|計画・未導入|別タスクで確定||次Task・Hub／Gate本格建築前、RollbackはAdmin-only、Cold Backup代替不可|
|Administration / Development|All Paper|PlugManX|計画・未導入|各Paper plugins|https://modrinth.com/plugin/plugmanx|Version未選定、手動取得、Admin-only、Velocity対象外|
|Deferred|Velocity|Cross-server chat|選定中|未配置||PoC後に選定|
|Forbidden|Velocity|ViaBackwards|禁止|配置しない|https://modrinth.com/plugin/viabackwards|意図的に不採用|
|Deferred|Frontier|Aether-like content|PoC|未配置||初期必須ではない|
|Forbidden|Frontier|Twilight Forest legacy plugin|不要|配置しない||現行対応がないため不採用|
|Deferred|LAB|LAB plugins / MythicMobs|将来|未配置||LAB導入時に別途選定|
