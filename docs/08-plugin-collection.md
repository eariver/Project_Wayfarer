# Plugin Collection Checklist - Ver.0.0.6

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
|Portal|Velocity + All Paper|Advanced Portals 2.8.0|Order 8 Lock済み・未導入|各plugins|https://modrinth.com/plugin/advanced-portals|`proxy:`方式。Proxy／Backend ComponentをOrder 12で一括検証|
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
|Structure|Main|BetterStructures 2.6.3 + Main 5-Pack|導入・Load検証済み|servers/main/plugins|https://nightbreak.io/plugin/betterstructures/|430件中278件有効、Persistent Main Family限定、Resource全世界と未知Worldは無効、再生成未実施|
|Model|Main|FreeMinecraftModels 2.10.2 + BetterStructures Prop Pack|導入・Load検証済み|servers/main/plugins|https://modrinth.com/plugin/free-minecraft-models/version/sQDrL88L|55 Models、一般Player Menu／Shop無効、Artifact／生成PackはGit対象外|
|Model / Pack|Main|ResourcePackManager 2.3.0|導入・配信Preflight済み|servers/main/plugins|https://modrinth.com/plugin/resourcepackmanager/version/sm5yLBux|Main統合Pack生成、任意Prompt、拒否継続、再接続Cacheを確認済み。Nightbreak一時Hosting、正式Hosting／Frontier Packは未確定|
|Adventure|Frontier|EliteMobs 10.7.3|Order 8 Lock済み・未導入|servers/frontier/plugins|https://modrinth.com/plugin/elitemobs|Guild Artifactだけ承認済み繰越。Runtime／Content受入はOrders 13／14|
|Structure|Frontier Ruined|BetterStructures 2.6.3|Order 8 Lock済み・未導入|servers/frontier/plugins|https://modrinth.com/plugin/betterstructures|Ruined Frontier三次元だけ。Content選定とRuntime受入はOrder 14|
|World / State|Frontier|Multiverse-Inventories 5.3.5|Order 8 Lock済み・未導入|servers/frontier/plugins|https://modrinth.com/plugin/multiverse-inventories|`neutral`／`worlds_beyond`／`guild`、通常Player State正本|
|World / Portal|Frontier Ruined|Multiverse-NetherPortals 5.0.5|Order 8 Lock済み・未導入|servers/frontier/plugins|https://modrinth.com/plugin/multiverse-netherportals|Ruined Frontier三次元だけ。Worlds Beyondでは使用しない|
|World Generator|Frontier Worlds Beyond|Iris 3.9.2／Overworld Pack|Order 8 Lock済み・未導入|servers/frontier/plugins|https://github.com/VolmitSoftware/Iris|`frontier_iris`単一Overworld。Nether／Endなし、Runtime生成はOrder 15|
|Gameplay|Frontier Worlds Beyond|LeafGrapple 1.0.2|Order 8 Lock済み・未導入|servers/frontier/plugins|https://modrinth.com/plugin/leafgrapple|`frontier_iris`限定、既定Damage／Durability／Entity HookをOrder 15で制限|
|Model|Frontier|FreeMinecraftModels 2.10.2|Order 8 Lock済み・未導入|servers/frontier/plugins|https://modrinth.com/plugin/free-minecraft-models|Frontier独立Output、Player Shop／Menu無効|
|Model / Pack|Frontier|ResourcePackManager 2.3.0|Order 8 Lock済み・未導入|servers/frontier/plugins|https://modrinth.com/plugin/resourcepackmanager|Mainとは別Pack。最終Output／Hosting／Hash／切替はOrder 12|
|GUI|Frontier Ruined|BetterHealthBar3 4.1.0|Order 8 Adoption候補・未導入|servers/frontier/plugins|https://www.spigotmc.org/resources/116619/|User-owned。有効化可否はOrders 12／14 Smoke Test、Self-host禁止|
|External Custom|Network|Wayfarer_Core|正式Scope・未開発|外部Multi-module Repository||V0.1.0 Blocker、本RepositoryへSourceを置かない|
|External Custom|Main|Wayfarer_Main|正式Scope・未開発|外部Multi-module Repository||V0.1.0 Blocker、Main限定Growth Pickaxe|
|External Custom|Frontier|Wayfarer_Frontier|正式Scope・未開発|外部Multi-module Repository||V0.1.0 Blocker、MVI通常Inventoryを再実装しない|
|External Custom|Frontier|Wayfarer_Frontier_EliteMobsMVI|条件付き・未開発|外部Multi-module Repository||`ADAPTER_REQUIRED`時だけ独立Artifact|
|Administration|Main／Lobby; Frontier undecided|CoreProtect|延期／候補・未導入|別タスクで再評価||Main／LobbyはMinecraft 26.2対応Stable版待ちでNon-blocking。Frontierは24.0静的候補だが製品未採用、将来RollbackはAdmin-only、Cold Backup代替不可|
|Administration / Development|All Paper|PlugManX|計画・未導入|各Paper plugins|https://modrinth.com/plugin/plugmanx|Version未選定、手動取得、Admin-only、Velocity対象外|
|Deferred|Velocity|Cross-server chat|選定中|未配置||PoC後に選定|
|Forbidden|Velocity|ViaBackwards|禁止|配置しない|https://modrinth.com/plugin/viabackwards|意図的に不採用|
|Deferred|Frontier|Aether-like content|PoC|未配置||初期必須ではない|
|Forbidden|Frontier|Twilight Forest legacy plugin|不要|配置しない||現行対応がないため不採用|
|Deferred|LAB|LAB plugins / MythicMobs|将来|未配置||LAB導入時に別途選定|
