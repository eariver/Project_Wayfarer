# Project Wayfarer

Minecraftの恒久生活拠点 **Main** と、既製Adventureコンテンツを導入する **Frontier** をVelocityで接続する個人用Paperネットワークです。

このリポジトリは、設定・設計・導入手順・運用Scriptおよび外部拡張Pluginとの接続仕様を構成管理するための正本です。独自PluginのSourceは含めず、必要になった場合はPluginごとの別リポジトリで開発・Releaseします。

## Ver.0.0.2の初期構成

- Minecraft Client: 26.2
- Velocity: 4.1.0選定Build（Runtime表記: 4.1.0-SNAPSHOT、Java 25）
- Lobby: Paper 26.2（Java 25）
- Main: Paper 26.2（Java 25）
- Frontier: Paper 1.21.11（Java 25）
- MariaDB + Redis: Docker Compose
- ViaVersion: 5.11.0をVelocityのみに導入し、26.2 ClientからFrontier 1.21.11への接続を検証済み
- ViaBackwards: 導入禁止
- LuckPerms: Velocityおよび各Paper、共通MariaDB
- WorldEdit 7.4.4／WorldGuard 7.0.17: 全Paperへ同一JARを配置（Lobby／Frontier保護、MainはRegion未設定）
- Main／Frontier: 共通通貨とmcMMOデータを共有、通常インベントリは分離
- Lobby: チャット・TAB・権限以外のゲーム進行を共有しない

## 最初に読む文書

1. [Architecture](docs/01-architecture.md)
2. [Installation](docs/02-installation.md)
3. [Operations](docs/03-operations.md)
4. [Play Guide](docs/04-play-guide.md)
5. [外部拡張Plugin](docs/05-external-extensions.md)

詳細な正式設計は、別成果物の「Project Wayfarer 設計・導入・運用ガイド Ver.0.0.2」を参照してください。

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

現段階は開発準備中のため、GitHub ReleaseおよびGit Tagは使用しません。最小構成が実際に起動し、Velocity経由で接続できた段階から、設計書と稼働Serverの正式なVersion対応を開始します。

最初の正式Version番号はまだ決定していません。現在の文書に記載されたVersionは設計文書の改訂番号であり、稼働ServerのRelease番号ではありません。

## Ver0.0.2 decisions

- Shared currency: **Waymark (WM)**.
- Main has independent direct gates to all three Resource worlds.
- `resource_end` has no Ender Dragon and uses a verified outer-island arrival/return gate.
- Manual Plugin collection is tracked in [Plugin Collection](docs/08-plugin-collection.md), `plugin-collection.csv`, and the separate XLSX artifact.
