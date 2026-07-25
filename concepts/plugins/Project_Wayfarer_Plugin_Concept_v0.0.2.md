# Project Wayfarer 独自Plugin Concept v0.0.2

> **状態:** Under Review  
> **保存先:** Project Wayfarer Repository `concepts/plugins/`  
> **対象:** Project Wayfarer V0.1.0へ向けた独自Plugin群  
> **実装状態:** 未着手  
> **Concept Version:** v0.0.2

---

## 1. 目的

本Conceptは、Project Wayfarer V0.1.0で必要となる独自Plugin群について、機能境界、Runtime配置、Data Ownership、既製Pluginとの責務分担および下位Conceptの関係を定義する。

本Conceptは実装作業指示書ではない。

Concept群の確認完了後、Codex向けの**実装作業指示書兼設計仕様書**を別途作成し、独自Plugin Sourceを管理するPlugin Repositoryへ保存する。

Project Wayfarer Repositoryへ置く本Concept群だけでは、Source作成、Database Migration、Plugin配布、Runtime導入またはReleaseを承認しない。

---

## 2. Authorityと文書境界

Project Wayfarer内では、現行`docs/`、`versions.yml`、`plugin-manifest.yml`および追跡対象Runtime Configが、承認済みScopeと現行状態の正本である。

本Concept群は、後続の作業設計に使用する非正本のDesign Inputである。

矛盾時の優先順:

1. Project Ownerが現在のSessionで明示した最新指示
2. Project Wayfarer現行`docs/`
3. Project Wayfarer現行Server／Theme Concept
4. 本Plugin Concept群
5. 旧Conceptおよび引継ぎ資料

本Plugin ConceptはProject WayfarerのServer／Theme Conceptを置き換えない。独自Pluginが担当する範囲と、既製Pluginへ委譲する境界を補足する。

---

## 3. Concept体系

現行Concept:

```text
concepts/plugins/
├─ Project_Wayfarer_Plugin_Concept_v0.0.2.md
├─ main/
│  └─ Project_Wayfarer_Growth_Tool_Concept_v0.0.4.md
└─ frontier/
   ├─ Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.2.md
   └─ Project_Wayfarer_Ruined_Frontier_Integration_Decision_Concept_v0.0.1.md
```

役割:

| Concept | 役割 |
|---|---|
| Plugin全体 | Runtime Plugin構成、共通責務、Repository／Data境界 |
| Growth Tool | Main向けGrowth PickaxeのGameplay Concept |
| Worlds Beyond Plugin | Traversal Loadout、Launchpad、Waystone、Frontier WM Shop |
| Ruined Frontier Integration Decision | EliteMobs InstanceとMVIの連携方式を選ぶDecision Gate |

各系列の置換済み文書は、同じ系列の`old/`へ保存する。

---

## 4. VersionとLifecycle

Conceptは`v0.0.1`から開始し、検討、実装準備、実装中およびテスト中は`v0.0.x`を使用する。

Version各桁は9を超えてよい。

Lifecycle:

```text
Draft
→ Under Review
→ Candidate
→ Approved for Task Design
→ Superseded
```

`Approved for Task Design`は、実装作業指示書兼設計仕様書の作成に進める状態を示す。実装、Runtime変更またはRelease承認ではない。

Project Wayfarer V0.1.0向けのテストサーバ試験が完了した時点で、Plugin Concept群の最終版を`v0.1.0`とする。

---

## 5. Repository境界

### 5.1 Project Wayfarer Repository

保存するもの:

- Plugin Concept
- Project側の統合契約
- Runtime配置
- Version／Artifact Hash
- Runtime Config
- Database／API／Permission Contract
- 導入・運用・Rollback手順
- Project側Acceptance Test
- Test Reportの受領記録

保存しないもの:

- 独自Plugin Source
- Gradle Build Project
- 開発中JAR
- IDE設定
- Build中間生成物
- Secret
- Local Database
- Runtime Log

### 5.2 Plugin Repository

Concept確認後に作成する独立Repositoryへ保存するもの:

- 独自Plugin Source
- Gradle Multi-module Project
- 実装作業指示書兼設計仕様書
- Plugin内部Architecture
- Database Migration
- Config Schema
- Command／Permission
- Unit／Integration Test
- Build／Release
- Plugin固有の運用・障害復旧文書
- Test Serverへ渡すRelease Candidate

Project Wayfarer全体のTheme ConceptをPlugin Repositoryへ複製しない。Plugin Repositoryの設計仕様書は、本Concept群とProject Wayfarerの採用Scopeを参照する。

---

## 6. Runtime Plugin構成

V0.1.0向け初期構成:

| Runtime Plugin | 配置先 | 初期責務 |
|---|---|---|
| `Wayfarer_Core` | Main／Frontier | Network共通InfrastructureとService Contract |
| `Wayfarer_Main` | Main | Growth Pickaxe |
| `Wayfarer_Frontier` | Frontier | Worlds Beyond MVPとFrontier固有連携 |
| `Wayfarer_Frontier_EliteMobsMVI` | Frontier | Decision Gateで必要性が証明された場合だけ |

Lobby向け独自Pluginは、V0.1.0で具体的な必須機能が発生するまで作成しない。

依存方向:

```text
Wayfarer_Main ───────────────→ Wayfarer_Core
Wayfarer_Frontier ───────────→ Wayfarer_Core

Wayfarer_Frontier_EliteMobsMVI
├─→ Wayfarer_Core
├─→ Wayfarer_Frontierの限定Contract
├─→ EliteMobs
└─→ Multiverse-Inventories
```

禁止:

- CoreからMain／Frontierへの依存
- MainとFrontierの相互依存
- 循環依存
- Server固有GameplayをCoreへ混在
- 条件未成立のAdapter先行実装

---

## 7. Plugin Repositoryの高位構成

独自Plugin Sourceは、1つのGradle Multi-module Repositoryで管理する方針とする。

概念上の区分:

```text
libraries/
├─ wayfarer-api
├─ wayfarer-common
└─ wayfarer-testkit

integrations/
├─ wayfarer-leafgrapple-adapter
└─ wayfarer-elitemobs-mvi-contract

plugins/
├─ wayfarer-core
├─ wayfarer-main
├─ wayfarer-frontier
└─ wayfarer-frontier-elitemobs-mvi
```

正確なDirectory名、Group ID、Package、Gradle Convention、LibraryおよびModule分割は、Plugin Repositoryへ置く実装作業指示書兼設計仕様書でLockする。

Feature単位に過剰分割せず、Runtime Plugin境界と外部Version Adapter境界を優先する。

---

## 8. `Wayfarer_Core`責務

V0.1.0の共通基盤候補:

- MariaDB接続基盤
- Schema Migration基盤
- Waymark Service Adapter
- Transaction ID
- Idempotency
- 共通Audit
- Player Identity
- 共通Custom Item Identity
- Redis Cache／Lock／Pub/Sub接続基盤
- Cross-server Message基盤
- Permission Contract
- Dependency Health
- Bukkit Service等によるPlugin間Contract公開

Data方針:

- MariaDBを永続Gameplay Dataの正本とする。
- RedisをInventoryまたはGameplay永続化の唯一の正本にしない。
- Waymark操作はVaultまたは正式なWaymark Adapter経由とする。
- RedisEconomy内部Keyを直接操作しない。
- MVI、mcMMO、EliteMobs等のDatabaseを直接更新しない。

Coreが担当しないもの:

- 通常Inventory保存
- MVI Profile切替
- Growth Tool固有Gameplay
- Worlds Beyond固有Gameplay
- Gate移動
- World Generation
- EliteMobs Instance Lifecycle

---

## 9. `Wayfarer_Main`責務

V0.1.0向け初期責務はGrowth Pickaxeとする。

対象Concept:

- `main/Project_Wayfarer_Growth_Tool_Concept_v0.0.4.md`

初期責務:

- Playerごとに1本のGrowth Pickaxe
- Tool Identity／Owner Bind
- Resource三次元でのProgress
- Material／Enchant Evolution
- Config再計算
- Broken Tool
- WM Full Repair
- 統合GUI
- Admin／Debug
- MariaDB永続化
- Audit／Reconcile

初期Scope外:

- Axe
- Shovel
- Player向けWM Fortune／Silk Touch切替
- Netherite UpgradeのPlayer向け実装
- Ranking／Reward
- Cross-server Tool移送

---

## 10. `Wayfarer_Frontier`責務

対象Concept:

- `frontier/Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.2.md`
- `frontier/Project_Wayfarer_Ruined_Frontier_Integration_Decision_Concept_v0.0.1.md`

V0.1.0向け初期責務:

- Worlds Beyond Traversal Loadout
- Worlds Beyond Item IdentityとTheme-bound Use
- LeafGrapple連携
- Launchpad
- Waystone
- Discovery／Teleport GUI
- Frontier WM Shop
- Pending Delivery
- Admin／Inspect／Reconcile
- Audit Adapter
- 将来のRuined Frontier WM Reward基盤

担当しないもの:

- 通常Inventory保存
- MVI Profile切替
- 物理Gate Transfer
- 通常World Changeの二重State切替
- Iris World Generation
- LeafGrapple移動物理の再実装
- BetterStructures生成
- EliteMobs Gameplay／Instance Lifecycle
- MVIの通常Player State管理

---

## 11. Ruined Frontier連携境界

EliteMobs Instance WorldとMVI Guild Groupの連携は、次の順に最小方式を選ぶ。

1. 固定Worldの静的MVI登録
2. 承認済みBlueprint名と連番に限定した厳密Regex
3. 前二者で安全に成立しない場合だけAdapter

Adapterは、Conceptに名称があることだけを理由に開発しない。

採用時も限定責務は次に留める。

- 承認済みInstance Worldの検出
- MVI Guild Groupへの追加
- Instance削除後の解除
- Restart時の残留検査
- Audit／Reconcile

Instance作成、Gameplay、Player退出、Respawn、終了およびWorld削除はEliteMobs／Content Packageを正とする。

---

## 12. 通常Player State境界

Frontier Backend内の通常Player StateはMultiverse-Inventoriesを正本とする。

MVI対象候補:

- Inventory
- Armor
- Offhand
- Ender Chest
- Vanilla XP／Level
- Health
- Food／Saturation
- 選定Versionで明示的に承認した追加状態

`Wayfarer_Frontier`は通常Player StateをMariaDBへ複製せず、Gate、Portal、Respawn、Command Teleportを包括監視して二重切替しない。

MainとFrontierはVanilla／Customを問わずItemを共有・移送しない。

Network共有成果は、Waymark、mcMMOおよび別途承認されたItem非依存成果に限定する。

---

## 13. Platform境界

初期想定:

- Main: Paper 26.2／Java 25
- Frontier: Paper 1.21.11／Java 25

原則:

- NMSは原則使用しない。
- 共通LibraryはPure Javaまたは最低共通機能を中心とする。
- Version依存処理はAdapterへ隔離する。
- 外部Plugin Versionと必要機能を起動時に検証する。
- Unsupported RuntimeはFail-fastする。

正確なAPI座標とVersion Matrixは実装作業指示書兼設計仕様書でLockする。

---

## 14. ThreadingとPerformance原則

- Main ThreadでMariaDB I/Oを実行しない。
- Bukkit World／Block／Item／Inventory操作はMain Threadで行う。
- DB I/Oは専用Executorで行う。
- Player Join時に必要なRecordを非同期ロードする。
- 高頻度ProgressはSession Cacheで処理する。
- 通常状態は周期Checkpointし、重要状態は即時確定する。
- Plugin Disable後に非同期Callbackを適用しない。
- Shutdown時は制限時間付きFlushを行う。

正確なExecutor、Queue、Timeout、Checkpoint間隔およびBackpressureは実装仕様で定義する。

---

## 15. Fail-closed

次の場合、該当機能を安全側で停止する。

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
- 不明なTransaction状態

不正な代替Itemの配布や、Data正本を無視した継続動作を行わない。

---

## 16. AuditとReconcile

重要操作は共通Auditへ記録する。

対象例:

- Item発行／再発行／失効
- Identity Validation失敗
- Progress Checkpoint
- Evolution
- Broken化
- Repair／Refund
- Launchpad設置／利用／破壊／期限切れ
- Waystone Lifecycle
- WM取引
- Admin操作
- DB Conflict
- Pending Delivery
- Reconcile

不確実な状態を黙って補正せず、再実行可能な識別子、旧状態、新状態および結果を記録する。

---

## 17. Config方針

Config化する候補:

- World Allowlist
- Balance
- Progress Weight
- Threshold
- Enchant Cap
- Repair価格
- Launchpad使用回数／期限／速度
- Waystone期間／価格
- GUI表示
- Message
- Scheduler間隔

危険設定:

- Schema
- Database接続
- World ID
- Template Identity
- External Plugin Contract

危険設定はHot Reload対象にしない。

Config変更時にDomain再計算が必要なFeatureは、累計Dataを破壊せず再導出する。

---

## 18. Conceptと実装作業指示書の関係

本Concept群の確認完了後、Plugin Repositoryへ次を作成する。

- 実装作業指示書兼設計仕様書
- Gradle Multi-module初期Project
- Database DDL／Migration計画
- API／Class責務
- Event／Threading／Cache設計
- Command／Permission
- GUI／Config Schema
- External Plugin Adapter
- Unit／Integration Test
- Release／Test Server引継ぎ

Codexには、Conceptの責務境界と安全要件を変更しない範囲で、局所的なClass分割、Method名および内部Utilityの裁量を認める。

---

## 19. 実装と試験の引継ぎ

想定Workflow:

```text
Project Wayfarer Concept確認
→ Plugin Repositoryへ設計仕様書を作成
→ IntelliJ IDEA側Codexが実装・Test
→ Release CandidateとPlugin側Test Report
→ VS Code側CodexがProject Test Serverへ統合
→ Project側Test Report
→ 本流で本番受入試験内容を決定
→ Project Wayfarer V0.1.0向け最終判断
```

Plugin RepositoryのZIPは、Concept確認と実装作業指示書兼設計仕様書の完成後に作成する。

---

## 20. 現時点の未確定事項

本Conceptの責務境界を阻害する重大な未決はない。

後続設計でLockするもの:

- Repository正式名称
- Group ID／Package Root
- Gradle／Library Version
- Database DDL
- API公開方式
- Exact Command／Permission
- GUI Layout
- Config Schema
- Test Framework
- CI／Release方式

Worlds BeyondのLaunchpad構造と起動操作などPlayer体験に関わる項目は、下位ConceptのReviewで確定する。

---

## 21. v0.0.2変更概要

- Conceptと実装作業指示書兼設計仕様書を明確に分離した。
- ConceptはProject Wayfarer、実装仕様書は将来のPlugin Repositoryへ置く方針を明文化した。
- Growth Tool v0.0.4、Worlds Beyond Plugin v0.0.2およびRuined Frontier Integration Decision v0.0.1を現行下位Conceptとして整理した。
- Lobby Pluginを初期構成から除外した。
- EliteMobs–MVI Adapterを条件付きArtifactとして明確化した。
- Project Wayfarer現行Frontier Scopeに合わせてMVI、Core、Frontierの責務境界を整理した。
