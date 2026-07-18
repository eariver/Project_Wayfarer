# Project Wayfarer

Minecraftの恒久生活拠点 **Main** と、既製Adventureコンテンツを導入する **Frontier** をVelocityで接続する個人用Paperネットワークです。

このリポジトリは、設定・設計・導入手順・運用スクリプト・将来の独自Pluginソースを構成管理するための正本です。Paper／Velocity／PluginのJAR、ワールドデータ、秘密情報、有償コンテンツは含みません。

## Ver.0.0.2の初期構成

- Minecraft Client: 26.2
- Velocity: 最新安定版（Java 21）
- Lobby: Paper 26.2（Java 25）
- Main: Paper 26.2（Java 25）
- Frontier: Paper 1.21.11（Java 21）
- MariaDB + Redis: Docker Compose
- ViaVersion: Velocityに導入
- ViaBackwards: 導入禁止
- LuckPerms: Velocityおよび各Paper、共通MariaDB
- Main／Frontier: 共通通貨とmcMMOデータを共有、通常インベントリは分離
- Lobby: チャット・TAB・権限以外のゲーム進行を共有しない

## 最初に読む文書

1. `docs/01-architecture.md`
2. `docs/02-installation.md`
3. `docs/03-operations.md`
4. `docs/04-play-guide.md`
5. `docs/05-custom-plugins-roadmap.md`

詳細な正式設計は、別成果物の「Project Wayfarer 設計・導入・運用ガイド Ver.0.0.2」を参照してください。

## 基本操作

```powershell
Copy-Item .env.example .env
Copy-Item local/paths.psd1.example local/paths.psd1
.\scripts\Initialize-Local.ps1
.\scripts\Test-Layout.ps1
```

JARとPluginを手動配置し、各コンポーネントを一度ずつ個別起動して標準Configを生成した後、Codexに生成Configの編集を依頼します。

## 重要な禁止事項

- ViaBackwardsを導入しない。
- BackendのPaperポートを外部公開しない。
- Mainの恒久ワールドをリセットスクリプトの対象にしない。
- ResourceワールドでBetterStructuresを有効化しない。
- JAR、有償コンテンツ、秘密情報、ワールド、DBデータをGitへコミットしない。

## Ver0.0.2 decisions

- Shared currency: **Waymark (WM)**.
- Main has independent direct gates to all three Resource worlds.
- `resource_end` has no Ender Dragon and uses a verified outer-island arrival/return gate.
- Manual plugin collection is tracked in `docs/08-plugin-collection.md`, `plugin-collection.csv`, and the separate XLSX artifact.
