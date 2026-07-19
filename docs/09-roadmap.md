# Project Wayfarer Roadmap - Ver.0.0.3

このRoadmapは候補の依存関係を示すものであり、固定された実施順や稼働ServerのRelease計画ではありません。各項目は個別に承認されたタスクでVersion、Platform、取得元、Data境界および受入条件を確定します。

## 完了済み基盤

- Bare First Boot
- Velocity NetworkとModern Forwarding
- Lobby、Main、Frontier接続とLobby Failover
- ViaVersionによるMinecraft 26.2 ClientからFrontier 1.21.11への接続
- LuckPerms共有MariaDB基盤
- Void Lobby／Frontier Gateと仮設安全Platform
- 全PaperのWorldEdit／WorldGuardとLobby／Frontier保護
- TAB Proxy InstallationによるHeader／Footer表示
- Multiverse-Coreによる全Paper World登録とMainのPersistent／Resource Family
- Multiverse-NetherPortalsによるMain内2 Familyの明示的な双方向Link
- mcMMO 2.3.000によるMain／Frontier共有MariaDB進行基盤

## 次期候補

- RedisEconomy + VaultUnlocked + EconomyShopGUI
- Advanced PortalsのProxy／Backend一括Integration
- MainのBetterStructures
- MainのEvenMoreFish
- FrontierのEliteMobsとAdventure Content
- Cross-server Chat
- PlugManXによるPaper管理・独自Plugin開発支援
- 独自Plugin用の別RepositoryとRelease／配布Workflow
- 将来の検証用LAB

Resource World Resetの破壊的な実動作試験、Main Hubから各Resource Worldへの直接Gate、Advanced Portals、Resource Endの安全な外周島到着地点、およびResource WorldのRespawn／Bed運用方針は後続タスクです。

PlugManXは独自Plugin開発の開始前または開始時に再検討します。Versionは未選定で、全Paper Backendだけを候補とし、Velocityは対象外です。

## 独立した詳細検証を要求する領域

- Worldの削除、移動、再生成
- Database Migration、Economyおよび共有Progression
- InventoryまたはItemのServer間移動
- Permission、Secret、接続経路およびProtocol変換
- Portal、Dimension Family、Backup、RestoreおよびFailover
- 大規模Content Packまたは不可逆な変更
