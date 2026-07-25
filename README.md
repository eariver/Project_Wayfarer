# Project Wayfarer

Minecraftの恒久生活拠点 **Main** と、既製Adventureコンテンツを導入する **Frontier** をVelocityで接続する個人用Paperネットワークです。

このリポジトリは、設定・承認済み設計・導入手順・運用Scriptおよび外部拡張Pluginとの接続仕様を構成管理するための正本です。正式仕様と分離した非正本のConcept、調査および設計候補も履歴として管理します。独自PluginのSourceは含めず、必要になった場合はPluginごとの別リポジトリで開発・Releaseします。

## Ver.0.0.6の構成

- Minecraft Client: 26.2
- Velocity: 4.1.0選定Build（Runtime表記: 4.1.0-SNAPSHOT、Java 25）
- Lobby: Paper 26.2（Java 25）
- Main: Paper 26.2（Java 25）
- Frontier: Paper 1.21.11（Java 25）
- MariaDB + Redis: Docker Compose
- ViaVersion: 5.11.0をVelocityのみに導入し、26.2 ClientからFrontier 1.21.11への接続を検証済み
- ViaBackwards: 導入禁止
- LuckPerms: Velocityおよび各Paper、共通MariaDB
- Permission Phase 1A: 5つの恒久Group、Velocity経由の自己限定Temporary Role、Admin Full Access、OP非依存運用を実装済み（Builder最終AllowlistはPhase 1B）
- VoidGen 2.3.8: Lobby／FrontierのVoid Entry World
- WorldEdit 7.4.4／WorldGuard 7.0.17: 全Paperへ同一JARを配置（Lobby／Frontier保護、MainはRegion未設定）
- TAB 6.1.0: VelocityへのProxy Installation（全PaperはTAB-Bridge 6.2.2＋PlaceholderAPI 2.12.3）
- mcMMO 2.3.000: Main／Frontierへ同一Local Maven Buildを配置し、MariaDBで進行を共有
- RedisEconomy 4.5.12-wayfarer.1／VaultUnlocked 2.20.2: Main／FrontierでRedis 8上のWaymark残高を共有
- EconomyShopGUI 7.1.1 Free: Main限定の固定価格Waymarkショップ（5カテゴリ・62商品、100倍名目価格Baseline）
- BetterStructures 2.6.3: Mainだけに導入し、5 Pack／278 Structure構成をCurrent Runtime Candidateの新規Chunkへ生成
- EvenMoreFish 2.4.3: Main限定のCustom Fishing。`main`／`resource`で魚売却Shopを提供し、専用MariaDBへJournal／統計を保存
- Main恒久World: 2026-07-25に同一Seedで5 Pack構成へ置換生成。Resource Familyと安全Spawnを保持したCurrent Runtime Candidateで、V0.1.0最終BaselineはOrder 6後に確定
- Main／Frontier: 通常Inventoryは分離し、Waymark残高とmcMMO進行だけを共有
- Lobby: TAB・権限以外のゲーム進行をMain／Frontierと共有しない
- V0.1.0計画: Main候補WorldのOrder 6調整／最終Backup、Ruined Frontier／Worlds Beyond、MVI、Wayfarer_Core／Wayfarer_Frontier、Main／Frontier別Resource Pack（未完了）

## 最初に読む文書

1. [正式設計・導入・運用ガイド Ver.0.0.6](docs/00-design-guide.md)
2. [Architecture](docs/01-architecture.md)
3. [Installation](docs/02-installation.md)
4. [Operations](docs/03-operations.md)
5. [Play Guide](docs/04-play-guide.md)
6. [Troubleshooting](docs/05-troubleshooting.md)
7. [Roadmap](docs/09-roadmap.md)
8. [Waymark Economy](docs/10-waymark-economy.md)
9. [Deferred Design Items](docs/11-deferred-design-items.md)
10. [Permission Model](docs/12-permission-model.md)
11. [Main World Baseline](docs/13-main-world-baseline.md)
12. [Frontier V0.1.0 Scope](docs/14-frontier-v0.1.0-scope.md)
13. [Codex Task Instruction Archive](codex/README.md)
14. [Investigation Reports](docs/investigations/README.md)
15. [Concepts and design candidates](concepts/README.md)

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
- 非正本の構想、候補比較、複数Chat間の引継ぎおよび旧設計案

`concepts/`の資料は現行正本または実装命令ではありません。

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

## Concept運用

`concepts/`は採用前の設計候補、比較、調査および引継ぎの参照資料です。承認済みの現行設計と運用上の正本は`docs/`に置き、実作業はユーザーが現在のSessionで明示的に割り当てた`codex/`内の個別指示書に従います。

ユーザーがConcept文書を手動でCommit／Pushする場合があります。Concepts-only CommitはRuntime変更、正式仕様更新または実装承認を意味しません。

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

Ver.0.0.6は設計・導入・運用文書の改訂番号であり、稼働ServerのRelease番号ではありません。最初の目標Server Releaseは`V0.1.0 Alpha`ですが、現時点では未達です。Main再生成、Frontier両Theme、統合運用、Baseline Backupおよび隔離Restoreを含むRelease Blockerを完了した時点で、Git TagおよびGitHub Releaseを採用するか最終決定します。

## Ver.0.0.6 decisions

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
- BetterStructuresは現在Mainだけに配置済みで、`main`、`main_nether`、実Bukkit名`main_the_end`だけを有効化している。Resource Familyと未知の新規Worldは無効とし、Content Artifactは手動取得・Git非追跡とする。V0.1.0のRuined Frontierには、別途Version・配置・依存関係を検証したFrontier用BetterStructuresを導入する計画である。
- EvenMoreFishはMainだけに配置し、`main`／`resource`だけでCustom FishとVault経由の魚売却を有効化する。Fish購入、Sellall、直接MONEY報酬、Competition、Hunt、Lava／Void Fishingは無効とし、Credentialを含むRuntime ConfigはTemplateからRenderする。
- Redis AOFは正式な永続Dataとして、Container停止後のCold Backup対象にする。
- PlugManXは将来のPaper管理・独自Plugin開発支援候補とし、Version選定と導入は後続タスクで行う。
- Shared network currency: **Waymark (WM)**. MainのVanilla固定価格ShopとEvenMoreFish魚売却は導入済みで、Frontier／Quest等の報酬設計は後続タスクとする。
- The planned Main hub has independent direct gates to all three Resource worlds.
- Planned `resource_end` has no Ender Dragon and uses a verified outer-island arrival/return gate.
- Manual Plugin collection is tracked in [Plugin Collection](docs/08-plugin-collection.md), `plugin-collection.csv`, and the separate XLSX artifact.
- 権限Phase 1Aとして、`default`、2つのEligibility Group、`wayfarer_builder`／`wayfarer_admin`の5つの恒久Group定義と、PlayerからRole Groupへの自己限定Temporary Parent所属を実装済み。既存`default`／`wayfarer_builder`は再利用し、AdminはOPではなく一時Roleで全権限を得る。Builderの最終AllowlistはPhase 1Bとして未実装。
- Main Persistent Familyは5 Pack構成で置換生成済みで、Resource Family除外、3 Spawn、Portal往復、Pack配信、自然生成Propおよび再起動を確認済み。Exploration Packを含む4 Pack目の自然生成確認によりOrder 5も完了した。Order 6調整／最終Backupが残るため、現在はRuntime CandidateでありV0.1.0最終Baselineではない。
- V0.1.0ではRuined Frontier alphaとWorlds Beyond MVPの両方を実装・統合・受入試験する。Ruined Frontierの初期BetterStructures ScopeはMain五Packとは異なり、103 Default Structures全体を原則無効として、Exploration／Caves／Echoes／Adventure、Prop Pack、Free Elite Shrines、Dungeoneering Modules Freeを採用する。
- Frontierの通常Player StateはMultiverse-Inventoriesの`neutral`、`worlds_beyond`、`guild` Groupを正本とし、Wayfarer_FrontierでInventory保存を再実装しない。
- Main／Frontier間ではVanilla Itemを含む全Item、Inventory、Armor、Offhand、Ender ChestおよびVanilla Player Stateを移送しない。共有成果はWaymark、mcMMOおよび別途承認されるItem非依存実績／報酬だけとする。
- Wayfarer_CoreとWayfarer_FrontierはV0.1.0 Blockerとして別Repositoryで開発し、本RepositoryにはIntegration Contract、Config、Version／Hashおよび運用・受入文書だけを置く。
- ResourcePackManager 2.3.0はMain Preflight済み。Frontierは別Packとして未導入であり、正式Hosting、Backend切替、競合およびRollbackはFrontier統合時にNetwork全体でLockする。
- Lobby／Main／FrontierのHub外観とGate構造はユーザーが手作業で確定し、Codexは確定座標に基づく接続・設定・保護を後続タスクで行う。
- Main Spawn保護は設計済み・未実装とし、ユーザーが初期Hubを概ね整備した後にWorldGuard RegionのExact範囲を別タスクで承認する。それまではVanilla `spawn-protection=16`を維持する。
- CoreProtectは新しいMain Baseline確定後、Hub／Gateの本格建築前に導入する。Block履歴と部分Rollbackを担当するが、Cold Backupの代替にはしない。
- V0.2.x以降の独自Plugin構想は、一般Concept運用を導入する以前の歴史的例外として[Codex Task Instruction Archive](codex/README.md)内に参考草案を保存する。Fileは現位置を維持し、Ver.0.0.6へ明示的に昇格したWayfarer_Core／Wayfarer_Frontier Scope以外について、V0.1.0の実装対象・Release Blocker・開発開始承認にはしない。
