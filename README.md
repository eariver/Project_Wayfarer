# Project Wayfarer

Minecraftの恒久生活拠点 **Main** と、既製Adventureコンテンツを導入する **Frontier** をVelocityで接続する個人用Paperネットワークです。

このリポジトリは、設定・設計・導入手順・運用Scriptおよび外部拡張Pluginとの接続仕様を構成管理するための正本です。独自PluginのSourceは含めず、必要になった場合はPluginごとの別リポジトリで開発・Releaseします。

## Ver.0.0.4の構成

- Minecraft Client: 26.2
- Velocity: 4.1.0選定Build（Runtime表記: 4.1.0-SNAPSHOT、Java 25）
- Lobby: Paper 26.2（Java 25）
- Main: Paper 26.2（Java 25）
- Frontier: Paper 1.21.11（Java 25）
- MariaDB + Redis: Docker Compose
- ViaVersion: 5.11.0をVelocityのみに導入し、26.2 ClientからFrontier 1.21.11への接続を検証済み
- ViaBackwards: 導入禁止
- LuckPerms: Velocityおよび各Paper、共通MariaDB
- VoidGen 2.3.8: Lobby／FrontierのVoid Entry World
- WorldEdit 7.4.4／WorldGuard 7.0.17: 全Paperへ同一JARを配置（Lobby／Frontier保護、MainはRegion未設定）
- TAB 6.1.0: VelocityへのProxy Installation（全PaperはTAB-Bridge 6.2.2＋PlaceholderAPI 2.12.3）
- mcMMO 2.3.000: Main／Frontierへ同一Local Maven Buildを配置し、MariaDBで進行を共有
- RedisEconomy 4.5.12-wayfarer.1／VaultUnlocked 2.20.2: Main／FrontierでRedis 8上のWaymark残高を共有
- EconomyShopGUI 7.1.1 Free: Main限定の固定価格Waymarkショップ（5カテゴリ・62商品）
- Main／Frontier: 通常Inventoryは分離し、Waymark残高とmcMMO進行だけを共有
- Lobby: TAB・権限以外のゲーム進行をMain／Frontierと共有しない

## 最初に読む文書

1. [正式設計・導入・運用ガイド Ver.0.0.4](docs/00-design-guide.md)
2. [Architecture](docs/01-architecture.md)
3. [Installation](docs/02-installation.md)
4. [Operations](docs/03-operations.md)
5. [Play Guide](docs/04-play-guide.md)
6. [Roadmap](docs/09-roadmap.md)
7. [Waymark Economy](docs/10-waymark-economy.md)
8. [Deferred Design Items](docs/11-deferred-design-items.md)
9. [Investigation Reports](docs/investigations/README.md)

今後はRepository内の正式ガイドを設計基準とし、Runtime Versionは`versions.yml`と`plugin-manifest.yml`で管理します。

互換性問題や障害の詳細な切り分け、上流報告用の再現情報および修正版の再検証条件は、[Investigation Reports](docs/investigations/README.md)へ保存します。

## Scope

このリポジトリに含むもの：

- Velocity、PaperおよびPluginのConfigとTemplate
- 導入・起動・停止・Backup・再生成Script
- MariaDB／Redisの構築定義
- 設計、導入、運用および遊び方の文書
- Plugin収集・互換性情報
- 外部拡張Pluginの接続仕様、導入手順、Version制約およびConfig

このリポジトリに含まないもの：

- 独自PluginのSource Code
- Plugin JARおよびPaper／VelocityのServer JAR
- 有償Pluginおよび有償Content
- World、Player Data、LogおよびDatabaseの実Data
- Password、TokenおよびForwarding Secret
- 別リポジトリで開発される外部拡張

## 基本操作

```powershell
Copy-Item .env.example .env
Copy-Item local/paths.psd1.example local/paths.psd1
.\scripts\Initialize-Local.ps1
.\scripts\Render-LocalConfigs.ps1
.\scripts\Test-Layout.ps1
```

JARとPluginを手動配置し、各コンポーネントを一度ずつ個別起動して標準Configを生成した後、生成Configと公式文書を確認して編集します。

Plugin JARはユーザーが公式Sourceから手動取得し、Ignoredな`manual-downloads/`へ配置します。CodexはVersion、Platform、Metadata、SHA-256および配置先を確認してからRuntimeへコピーします。少人数向けの段階的運用として、通常の既成PluginはIntegration Smoke Testを中心に検証します。

## 重要な禁止事項

- ViaBackwardsを導入しない。
- BackendのPaper Portを外部公開しない。
- Mainの恒久WorldをReset Scriptの対象にしない。
- Resource WorldでBetterStructuresを有効化しない。
- JAR、有償Content、秘密情報、WorldおよびDB DataをGitへCommitしない。
- 独自PluginのSourceやBuild Projectをこのリポジトリへ追加しない。

## License

Project Wayfarerが独自に作成したConfig、Script、文書、Templateその他の成果物は、[MIT License](LICENSE)で提供します。

第三者Plugin、Minecraft、Paper、Velocity、Content Pack、Resource Packおよび有償Contentには、それぞれの権利者が定めるLicenseと利用条件が適用されます。このリポジトリは第三者PluginやMinecraftの再配布物ではなく、本リポジトリのMIT Licenseによって第三者成果物を再許諾するものではありません。詳細は[Third-party notices](THIRD_PARTY.md)を参照してください。

Project Wayfarerは、Mojang Studios、Microsoft、PaperMCまたは各Plugin作者との提携、後援もしくは承認関係を示すものではありません。

## Versioning

Ver.0.0.4は設計・導入・運用文書の改訂番号であり、稼働ServerのRelease番号ではありません。最初の目標Server Releaseは`V0.1.0 Alpha`ですが、現時点では完成条件を確定しただけで未達です。Baseline Backupと隔離Restoreを含むRelease Blockerを完了した時点で、Git TagおよびGitHub Releaseを採用するか最終決定します。

## Ver0.0.4 decisions

- Velocityと全Paper BackendをJava 25へ統一する。
- LobbyとFrontier GateはVoid Worldとし、仮設安全Platformを維持する。
- WorldEdit／WorldGuardを全Paperへ配置し、現時点ではLobby／Frontierだけを保護する。
- TABはProxy Installation方式とし、TAB本体をPaperへ配置しない。
- Plugin JARとPlaceholderAPI Expansionは手動取得する。
- Plugin導入は機能・依存関係・受入試験の単位でまとめてよい。
- 公式配布された通常の既成Pluginは、Version／配布元／配置／依存関係／Enable／主要Config／代表機能1件／起動阻害Error／Git除外だけを確認する。無関係な回帰試験やPlugin内部の例外ケース網羅は標準要件にしない。
- mcMMOはMain／Frontierだけで共有MariaDBを使用し、Runtime ConfigはSanitized TemplateからRenderする。
- Waymark（WM）はMain／Frontierだけで共有し、RedisEconomy Runtime ConfigはSanitized TemplateからRenderする。
- EconomyShopGUIはMainだけに配置し、Vault経由でRedisEconomyを使用する。初期ショップは固定価格とし、一括売却・Dynamic Pricing・Global Stock・Player Shopを一般開放しない。
- Redis AOFは正式な永続Dataとして、Container停止後のCold Backup対象にする。
- PlugManXは将来のPaper管理・独自Plugin開発支援候補とし、Version選定と導入は後続タスクで行う。
- Shared network currency: **Waymark (WM)**. Mainの初期ショップは導入済みで、Frontier／EvenMoreFish／Quest等の報酬設計は後続タスクとする。
- The planned Main hub has independent direct gates to all three Resource worlds.
- Planned `resource_end` has no Ender Dragon and uses a verified outer-island arrival/return gate.
- Manual Plugin collection is tracked in [Plugin Collection](docs/08-plugin-collection.md), `plugin-collection.csv`, and the separate XLSX artifact.
- V0.1.0前に、`default`、2つのEligibility Group、Temporaryな`wayfarer_builder`／`wayfarer_admin`からなる権限モデルを後続タスクで実装する。Ver.0.0.4では仕様のみを確定し、Runtime Groupは変更しない。
- Lobby／Main／FrontierのHub外観とGate構造はユーザーが手作業で確定し、Codexは確定座標に基づく接続・設定・保護を後続タスクで行う。
- V0.1.0ではFrontierへ未選定のPlayable Themeを1つ導入するが、WM報酬、Theme実績、Theme別Inventoryおよび複数ThemeはRelease Blockerにしない。
