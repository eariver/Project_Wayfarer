# Project Wayfarer 独自Plugin Concept v0.0.1

> **状態:** 初期構想／要件整理版  
> **対象:** Project Wayfarer V0.1.0へ向けた独自Plugin群  
> **実装状態:** 未着手  
> **Concept Version:** v0.0.1  
> **注意:** 本文書は開発開始承認、Database Migration承認、Release承認または本番導入承認を単独では意味しない。

---

## 1. 文書の目的

本Conceptは、Project Wayfarer V0.1.0で必要となる独自Plugin群の責務、構成、共通要件および初期実装範囲を定義する。

独自Plugin開発は当初V0.2.x以降を想定していたが、V0.1.0のFrontier ThemeであるWorlds Beyondに独自実装が必要となったため前倒しする。

同時に、Main向け将来構想「進化するツール」のPickaxe版を先行実装する。

Ruined Frontierでは、EliteMobsのDungeon／Instance WorldとMultiverse-Inventoriesの連携について、既存設定だけで安全に成立しない場合に限り独自Adapterを追加する。

---

## 2. 要求のAuthority

要求は原則として次の優先順位で解釈する。

1. Project Ownerが明示した最新指示
2. Project Wayfarer現行`docs/`
3. Project Wayfarer現行`concepts/`
4. 本Plugin Conceptおよび分離文書
5. 過去のCodex引継ぎ文書・旧構想
6. 実装時に確認する外部Pluginの正式API・Artifact仕様

矛盾がある場合は、上位Authorityを優先し、Concept改訂時に差分を記録する。

---

## 3. Version運用

Plugin Conceptは`v0.0.1`から開始する。

- Codexへ実装開始を依頼する時点では`v0.1.0`にしない。
- 実装中・単体試験中・テストサーバ統合中は`v0.0.x`を使用する。
- Version各桁は2桁以上へ進んでよい。例: `v0.0.13`
- Project Wayfarer本体とPlugin ConceptのVersionは常時一致する必要はない。
- Project Wayfarer V0.1.0向けのテストサーバ試験が完了した時点で、Plugin Concept最終版を`v0.1.0`とする。
- 本番受入試験、Release Artifact、導入CommitおよびRollback手順は別承認とする。

---

## 4. Repository境界

### 4.1 Project Wayfarer Repository

Project Wayfarer Repositoryへ保存するもの:

- Plugin Concept
- Project側の統合契約
- 採用Plugin Version・Artifact Hash
- Runtime Config
- Database／API／Permission Contract
- 導入・運用・Rollback手順
- Project側Acceptance Test
- Test Server結果の受領記録
- Release ArtifactのSHA-256

保存しないもの:

- 独自Plugin Source
- Build中間生成物
- 開発中JAR
- IDE固有設定
- Runtime Log
- Secret
- Local Database
- Test Player Data

### 4.2 Plugin Repository

独自Plugin Sourceは別の単一Gradle Multi-module Repositoryで管理する。

Plugin Repositoryの`docs/`にはPlugin自身に関する文書だけを保存する。

配置対象:

- Plugin Architecture
- Domain Model
- Database Migration
- API Contract
- Config Schema
- Command／Permission
- Unit／Integration Test
- Build／Release
- Plugin固有の運用・障害復旧
- Project側Conceptに収めるには詳細すぎるPlugin内部設計

Project Wayfarer全体のTheme ConceptをPlugin Repositoryの`concepts/`へ複製しない。

### 4.3 初期Project提供方式

Plugin Concept最終化およびCodex向け設計・実装指示書完成後、Gradle Multi-module Projectの初期構造をZIPとして提供する。

Project OwnerがZIPを展開し、IntelliJ IDEAへ読み込む。

---

## 5. Runtime Plugin構成

初期構成:

| Runtime Plugin | 配置先 | 初期責務 |
|---|---|---|
| `Wayfarer_Core` | Main／Frontier | 共通Infrastructure・Service Contract |
| `Wayfarer_Main` | Main | 進化するツール Pickaxe版 |
| `Wayfarer_Frontier` | Frontier | Worlds Beyond固有機能 |
| `Wayfarer_Frontier_EliteMobsMVI` | Frontier | 必要性が証明された場合だけ追加 |

Lobby向け独自Pluginは、必要性が発生するまで作成しない。

### 5.1 依存方向

```text
Wayfarer_Main ───────────────→ Wayfarer_Core
Wayfarer_Frontier ───────────→ Wayfarer_Core

Wayfarer_Frontier_EliteMobsMVI
├─→ Wayfarer_Core
├─→ Wayfarer_Frontier API
├─→ EliteMobs
└─→ Multiverse-Inventories
```

禁止:

```text
Wayfarer_Core → Wayfarer_Main
Wayfarer_Core → Wayfarer_Frontier
Wayfarer_Main ↔ Wayfarer_Frontier
循環依存
```

---

## 6. 推奨Gradle Multi-module構造

```text
wayfarer-plugins/
├─ settings.gradle.kts
├─ build.gradle.kts
├─ gradle.properties
├─ gradle/
├─ build-logic/
│
├─ libraries/
│  ├─ wayfarer-api/
│  ├─ wayfarer-common/
│  └─ wayfarer-testkit/
│
├─ integrations/
│  ├─ wayfarer-leafgrapple-adapter/
│  └─ wayfarer-elitemobs-mvi-contract/
│
├─ plugins/
│  ├─ wayfarer-core/
│  ├─ wayfarer-main/
│  ├─ wayfarer-frontier/
│  └─ wayfarer-frontier-elitemobs-mvi/
│
├─ docs/
│  ├─ architecture/
│  ├─ contracts/
│  ├─ migrations/
│  ├─ operations/
│  ├─ test-plans/
│  └─ report-templates/
│
└─ reports/
   └─ test-server/
```

`wayfarer-frontier-elitemobs-mvi`は必要性判断前に実装・Releaseしない。空Moduleを避ける場合、必要性確定後に追加する。

---

## 7. 共通Library

### 7.1 `wayfarer-api`

他Pluginが参照するService Contractを置く。

候補:

- Database Service
- Migration Service
- Audit Service
- Transaction Service
- Identity Service
- Waymark Economy Service
- Health Service
- Messaging Service
- Permission Contract

Bukkit Services API等を通してRuntime Serviceを公開し、Server固有PluginはCoreの実装Classへ直接依存しない。

### 7.2 `wayfarer-common`

Runtime PluginではないPure Java中心の内部Libraryとする。

候補:

- ID／UUID Value Object
- Result／Error Model
- Validation
- Serialization
- Clock abstraction
- Transaction State
- Config Model
- Retry Policy
- Domain Event
- Testに依存しない共通Utility

Paper、LeafGrapple、EliteMobs、MVI等の外部Plugin型を共通Domainへ漏らさない。

### 7.3 `wayfarer-testkit`

候補:

- Fake Clock
- In-memory Repository
- MariaDB Test Fixture
- Migration Test
- Audit Assertion
- Item Identity Fixture
- Failure Injection
- MockBukkit等のPaper Test補助

---

## 8. `Wayfarer_Core`責務

初期必須責務:

- MariaDB Connection Pool
- Schema Migration基盤
- Transaction ID
- Idempotency
- 共通Audit
- Player Identity
- 共通Custom Item Identity
- Waymark Service Adapter
- Redis接続基盤
- Cache／Lock／Pub/Sub基盤
- Cross-server Message基盤
- Permission Contract
- Dependency Health
- Plugin間Service公開

### 8.1 Data Ownership

- MariaDBを永続Gameplay Dataの正本とする。
- RedisをInventoryまたはGameplay永続化の唯一の正本にしない。
- Waymark操作はVaultまたは正式なWaymark Adapter経由とする。
- RedisEconomy内部Keyを直接操作しない。
- mcMMO、MVI、EliteMobs等のDatabaseを直接更新しない。

### 8.2 Migration所有

- CoreはMigration Engineと実行契約を提供する。
- Core固有TableはCoreが所有する。
- Main固有MigrationはMain Moduleが所有する。
- Frontier固有MigrationはFrontier Moduleが所有する。
- CoreがMain／Frontier Domain Schemaへ逆依存しない。

推奨Prefix:

```text
wf_core_*
wf_main_*
wf_frontier_*
```

### 8.3 担当しない項目

- 通常Inventory保存
- MVI Profile切替
- Growth Tool固有Gameplay
- Worlds Beyond固有Gameplay
- Gate移動
- Iris World Generation
- EliteMobs／BetterStructures本体機能

---

## 9. `Wayfarer_Main`責務

V0.1.0向け初期責務は「進化するツール」のPickaxe版とする。

詳細は次を正とする。

- `Project_Wayfarer_Growth_Tool_Concept_v0.0.1.md`

初期機能:

- Playerごとに1本のGrowth Pickaxe
- Tool Identity
- Owner Bind
- Resource三次元でのProgress
- Material Evolution
- Enchantment Evolution
- Broken Tool
- WM Full Repair
- 統合GUI
- Admin／Debug Command
- MariaDB永続化
- Audit／Reconcile

将来:

- Axe
- Shovel
- Player向けFortune／Silk Touch WM切替
- DiamondからNetheriteへのWM Upgrade
- Ranking／Reward
- その他Ability

---

## 10. `Wayfarer_Frontier`責務

V0.1.0向け初期責務はWorlds Beyond MVPとする。

詳細は次を正とする。

- `Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.1.md`
- Project Wayfarerの現行Frontier／Worlds Beyond Concept

初期責務:

- Worlds Beyond Traversal Loadout
- Soulbound Elytra
- LeafGrapple Adapter
- Navigation Item
- Launchpad
- Frontier WM Shop
- Waystone
- Discovery GUI
- Teleport GUI
- System Structure保護
- Pending Delivery
- Admin Inspect／Repair／Remove／Reconcile
- Audit接続

### 10.1 責務境界

`Wayfarer_Frontier`は次を再実装しない。

- 通常Inventory、Armor、Offhand、Ender Chest、XP、Health、Foodの保存・復元
- MVI Profile切替
- 通常のWorld変更、Portal、Respawn、Gate移動
- Iris World Generation
- LeafGrappleの移動物理
- BetterStructures生成
- EliteMobs Boss、Loot、Quest、Progression
- EliteMobs Instance Lifecycle
- Vanilla／EliteMobs Item全般のIdentity管理

Frontier Backend内の通常Player StateはMultiverse-Inventoriesを正本とする。

---

## 11. EliteMobs–MVI Adapter

Adapterは現時点で実装確定ではない。

次の優先順で最小方式を選択する。

1. 固定WorldをMVI Guild Groupへ静的登録
2. 承認済みBlueprint名と連番だけに限定した厳密Regex
3. 前二者で安全に成立しない場合だけAdapter

Adapter採用時の限定責務:

- EliteMobs Instance生成Eventの受信
- Package／Blueprint／World名のAllowlist検証
- MVI Guild Groupへの追加
- Instance削除Event後のGroup解除
- Restart時の残留登録検査
- Audit

担当しない項目:

- Instance World生成・複製・Load・削除
- Dungeon Gameplay
- Boss・Loot・Quest
- Player退出先決定
- Inventory保存・復元
- EliteMobs内部Config／Database／Content変更

---

## 12. Platform境界

初期想定:

- Main: Paper 26.2／Java 25
- Frontier: Paper 1.21.11／Java 25

原則:

- NMSは使用しない。
- 共通Libraryは最低共通機能またはPure Javaとする。
- Main／FrontierのPaper APIは各Runtime Moduleで`compileOnly`指定する。
- Version依存処理はAdapterへ隔離する。
- 単一Core Artifactで安全に動かない場合だけ、同一SourceからPlatform別Artifactを生成する。
- Unsupported RuntimeはFail-fastする。

---

## 13. Threading・Performance

- Main ThreadでMariaDB I/Oを実行しない。
- Bukkit World／Block／Item／Inventory操作はMain Threadで行う。
- DB I/Oは専用Executorで行う。
- Player Join時に必要なRecordを非同期ロードし、Session Cacheへ格納する。
- Block Break等の高頻度EventはRAM上で更新する。
- 重要状態は即時Checkpoint、通常Progressは周期Checkpointとする。
- Shutdown時は制限時間付きFlushを実行する。
- Plugin Disable後に非同期Callbackを適用しない。

---

## 14. Fail-closed

次の場合、該当Gameplay機能を停止する。

- Database unavailable
- Schema不一致
- Critical Dependency不足
- Item Identity不一致
- Owner不一致
- Instance Epoch不一致
- Unsupported Plugin Version
- World Allowlist不一致
- Economy Adapter不成立
- Template欠落
- MVI前提不成立
- LeafGrapple Adapter不成立

不正な代替Item配布や、Database正本を無視した継続動作を行わない。

---

## 15. Audit・Reconcile

重要操作は共通Auditへ記録する。

最低項目:

```text
timestamp
transaction_id
actor_uuid
target_id
action
old_state
new_state
result
error_code
server_id
world_id
details
```

対象例:

- Item発行
- Reissue
- Identity Validation失敗
- Progress Checkpoint
- Evolution
- Broken化
- Repair／Refund
- Launchpad設置／使用／破壊／期限切れ
- Waystone操作
- Admin操作
- DB Conflict
- Reconcile

---

## 16. Config方針

- Balance値、上限、期間、価格、World AllowlistはConfig化する。
- World ID、Schema、Template Identity、Database接続等の危険設定はHot Reload対象にしない。
- 表示、価格、Threshold等は安全性を確認した範囲だけReload可能とする。
- Config改訂時はRevisionを更新し、必要なDomain再計算を行う。
- Configで値を下げてもMariaDBの累計Progress等の正本を破壊的に書き換えない。

---

## 17. 開発・試験の担当境界

### 17.1 IntelliJ IDEA側Codex

担当:

- Repository初期構築
- Source実装
- Unit Test
- Integration Test
- Local MariaDB Test
- Build
- Release Candidate JAR
- Plugin内部文書
- Changelog
- Known Limitations

### 17.2 VS Code側Codex

Project Wayfarerサーバ構築Repositoryを操作し、テストサーバ統合を担当する。

担当:

- Release Candidate Artifact配置
- Config・Secret Template統合
- MariaDB Migration適用
- Plugin起動確認
- Runtime Integration Test
- MVI／Economy／World／External Plugin連携
- Restart／Reconnect／Failure Test
- Test結果Evidence収集
- Project本流へ共有可能なTest Report作成

### 17.3 Project本流チャット

担当:

- 本番導入前の受入試験内容決定
- Test Report評価
- 本番導入承認
- Rollback条件
- V0.1.0 Baseline判断

---

## 18. Test Reportの最低構造

正式Templateは後続Conceptで作成する。

最低限含めるもの:

- 対象Plugin／Version／Commit
- Build環境
- Artifact SHA-256
- Test Server環境
- Migration Version
- Config Revision
- External Dependency Version
- Test Case一覧
- Expected／Actual
- Evidence
- Log要約
- Performance観測
- Failure／Recovery確認
- Known Limitation
- 未解決事項
- 本番受入試験への引継ぎ事項

---

## 19. 分離文書

本Concept v0.0.1では、詳細を次へ分離する。

- `Project_Wayfarer_Growth_Tool_Concept_v0.0.1.md`
- `Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.1.md`

---

## 20. 未決事項

現時点でArchitectureを阻害する重大な未決事項はない。

実装前に順次Lockする項目:

- Repository正式名称
- Group ID／Package Root
- Gradle／Java Toolchain
- Database Pool／Migration Tool
- Config Library
- Command Framework
- GUI Framework
- API公開方式
- Exact Permission Node
- Exact Config Schema
- Exact Database DDL
- Exact Command Syntax
- Testcontainers／MockBukkit採否
- Release Versioning
- CI
- Signing／Checksum手順

BalanceおよびUIの暫定値はv0.0.xのPlaytestで改訂する。

---

## 21. v0.0.1時点の結論

V0.1.0へ向けた初期Plugin群は次で構成する。

```text
Wayfarer_Core
Wayfarer_Main
Wayfarer_Frontier
Wayfarer_Frontier_EliteMobsMVI（必要性確認後のみ）
```

Sourceは単一Gradle Multi-module Repositoryで管理する。

MainではGrowth Pickaxeを先行実装し、FrontierではWorlds Beyond MVPを実装する。

MVI、Iris、LeafGrapple、EliteMobs、BetterStructures等の既製Pluginの責務は再実装しない。

Plugin Conceptはテストサーバ試験を経て改訂し、Project Wayfarer V0.1.0向け最終版を`v0.1.0`とする。
