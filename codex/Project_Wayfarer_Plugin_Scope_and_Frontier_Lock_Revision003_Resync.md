# Project Wayfarer Plugin Scope同期・文書整合修正・Frontier Lock Phase A Revision 003 指示書

## 1. 推奨Sol

```text
high
```

### 理由

- Project Wayfarer V0.1.0の必須Custom Plugin、Roadmap、Acceptance、Backup／Restore、Pre-release Reset、Frontier正式ScopeおよびOrder 8 Phase A候補を横断して同期する。
- Owner手動Commitにより、`Wayfarer_Main`／Growth PickaxeのV0.1.0昇格、Worlds BeyondのOverworld単一World化、EliteMobs–MVI Adapterの独立Artifact境界などが更新された。
- 現行正本には、Worlds Beyond三次元構成、旧Concept Version、Core／Frontierだけを必須Custom Pluginとする記述が残っている。
- Frontier Lock Proposal `FRONTIER-LOCK-20260726-002`はPhase B未承認であり、最新ConceptとRoadmapへ再基底化したRevision 003が必要である。
- Runtime変更は行わないが、後続のPlugin Repository、MVI、World生成、Portal、Resource Pack、BackupおよびRelease Blockerが依存するため、文書Taskとして高い慎重さが必要である。

### Escalation／停止条件

次の場合は作業を拡張せず停止する。

- Plugin JAR、Content、Runtime Config、World、Portal、MVI Group、Permission、MariaDB、RedisまたはResource Packを変更する必要がある。
- Server起動またはRuntime互換性試験が必要になる。
- Frontier Lock Phase Bを実行する必要がある。
- 旧Token `APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-002`を承認済みとして扱う必要がある。
- Growth Tool、Worlds Beyond、Ruined FrontierまたはAdapterのGameplay判断を添付文書以上に変更する必要がある。
- Phase Aで静的確認済みArtifactのVersion／Hash／採否を変更する必要がある。
- Owner手動CommitをRevert、Amend、Squash、Rebaseまたは書き換える必要がある。
- 現行HEADが前提Commitを含まない、または意図不明な未Commit変更がある。
- ConceptのVersion Upが必須と判断される。
- Growth Tool DataをPre-release ResetでResetするか保持するかの決定が必要になる。

---

## 2. 目的

次を一つの文書同期Taskとして実施する。

1. 指定された6 Commitの親子関係と変更Scopeを確認する。
2. CodexのPhase A対応が、Owner手動Commitを上書きせず、Runtimeを変更せず、承認待ちで停止したことを確認・記録する。
3. `Wayfarer_Main`／Growth PickaxeをProject Wayfarer V0.1.0 Release Scopeへ正式追加する。
4. 独自Plugin Sourceを一つの外部Gradle Multi-module Repositoryで管理する方針を正本へ同期する。
5. 最新Plugin／Frontier Conceptの明白な参照・同期状態の不整合を修正する。
6. Worlds Beyondを`frontier_iris`単一Overworldとして正本へ同期する。
7. Ruined FrontierのOverworld／Nether／End三次元構成を維持する。
8. EliteMobs–MVI Adapterを`ADAPTER_REQUIRED`時だけ追加する独立Runtime Artifactとして統一する。
9. Frontierの履歴／Rollback製品を未選定状態へ統一し、CoreProtectを事前採用済みにしない。
10. Frontier Lock Proposal 002を未承認の履歴として保持し、Proposal 003へ再基底化する。
11. Phase Bを実行せず、Proposal 003の承認待ちで停止する。

---

## 3. 添付指示のAuthority

次の添付文書を読む。

```text
Project_Wayfarer_Cross_Chat_Concept_Sync_Instructions_v0.0.1(2).md
Project_Wayfarer_Main_Chat_Document_Sync_Handoff_v0.0.1.md
```

採用する範囲：

- Cross Chat指示のSection 2「Project本流チャット向け指示」
- Main Chat Document Sync Handoffの全Section

Cross Chat指示のSection 3は、Owner手動Commitでv0.0.5／v0.0.6／v0.0.4まで進展しているため、そのまま再実行しない。最新Repository状態とMain Chat Handoffを優先する。

優先順位：

1. Project Ownerが最新Concept／Decision Recordおよび本Taskで明示した判断
2. 現行`docs/`
3. 現行Frontier Server／Theme Concept
4. 現行Plugin Concept
5. 旧Concept／Archive

本Taskは、既にOwner判断へ反映済みのScopeを文書間で同期するTaskであり、Runtime実装承認ではない。

---

## 4. Repositoryと開始状態

Repository：

```text
eariver/Project_Wayfarer
```

開始時：

```powershell
git status --short
git branch --show-current
git remote -v
git log -15 --oneline
git rev-parse HEAD
```

期待HEAD：

```text
9abc12ae5f472325933d38c5eacc6050aaf3e6c7
docs: Frontier＆PluginのConcept修正
```

期待する直線Commit列：

```text
8096335843e4b09d648fe866aa01ca8d5a5c65f3
docs: Pluginのコンセプトを追加
Owner manual
  ↓
7f54a2b802cf4a4216a024a7b4048fbe5d8f789e
docs: Pluginコンセプト更新
Owner manual
  ↓
354052c9dd80d77b8b83c49f783e4d4b7b8755fd
docs: 不要ファイル削除漏れ対処
Owner manual
  ↓
a09db72a6ec45b436b59aec6fe6377e4d1c276f1
docs: Frontier Lock候補を調査
Codex
  ↓
d1158af4d6ff4fee52ac5f5b511181899f00e956
docs: Frontier Lock候補を改訂
Codex
  ↓
9abc12ae5f472325933d38c5eacc6050aaf3e6c7
docs: Frontier＆PluginのConcept修正
Owner manual
```

確認：

```powershell
git merge-base --is-ancestor 8096335843e4b09d648fe866aa01ca8d5a5c65f3 7f54a2b802cf4a4216a024a7b4048fbe5d8f789e
git merge-base --is-ancestor 7f54a2b802cf4a4216a024a7b4048fbe5d8f789e 354052c9dd80d77b8b83c49f783e4d4b7b8755fd
git merge-base --is-ancestor 354052c9dd80d77b8b83c49f783e4d4b7b8755fd a09db72a6ec45b436b59aec6fe6377e4d1c276f1
git merge-base --is-ancestor a09db72a6ec45b436b59aec6fe6377e4d1c276f1 d1158af4d6ff4fee52ac5f5b511181899f00e956
git merge-base --is-ancestor d1158af4d6ff4fee52ac5f5b511181899f00e956 9abc12ae5f472325933d38c5eacc6050aaf3e6c7
```

CodexはOwner手動Commitを変更、再作成または巻き戻さない。

禁止：

- `git reset --hard`
- `git clean`
- Rebase
- Amend
- Force Push
- History rewrite
- Owner CommitのSquash
- Branch作成
- PR作成
- Tag／Release
- Runtime ArtifactのCommit

---

## 5. 既存Codex Phase A監査

### 5.1 `a09db72...`

確認対象：

- `.gitignore`
- Order 8指示書Archive
- `codex/README.md`
- `config/frontier-lock/*-candidates.yml`
- Frontier Lock Preflight Report
- `manual-downloads/frontier/README.md`

適切な状態：

- Phase A静的調査のみ
- Candidate YAMLのみ
- Runtime Plugin配置なし
- Server起動なし
- World／DB／Permission変更なし
- Phase Bなし
- Order 8完了化なし

### 5.2 `d1158af...`

確認対象：

- Proposal 001から002へのRevision
- User配置ArtifactのFilename／SHA-256
- Worlds Beyond Overworld-only
- MNP 5.0.5をRuined Frontier Familyだけへ限定
- Advanced Portals／Iris／LeafGrapple／EliteMobs／BetterHealthBarの静的候補
- Adventurer's Guild Artifactの後続繰越
- `codex/README.md`の承認待ち状態

適切な状態：

- `status: candidate`
- `runtime_validation: deferred`
- Phase Bなし
- 正式`*-lock.yml`なし
- Runtime導入なし
- World生成なし
- DB／Permission変更なし

### 5.3 監査結論

Codexの2 Commitは、当時のPhase A対応として適切である。

ただし、その後のOwner Commit`9abc12ae...`と添付同期指示により、Proposal 002のCustom Plugin構成、Concept参照、Roadmap番号および正本文書が現行判断と一致しなくなった。したがってProposal 002を承認せず、Revision 003へ更新する。

---

## 6. Phase BとTokenの保護

旧Proposal：

```text
FRONTIER-LOCK-20260726-001:
  superseded

FRONTIER-LOCK-20260726-002:
  superseded-before-approval
  phase_b: not-executed
  approval_token_received: false
```

旧Token：

```text
APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-002
```

このTokenは無効とする。

禁止：

- Proposal 002のPhase B実行
- Proposal 002を正式Lockへ昇格
- Proposal 002を承認済みと記録
- Proposal 002の履歴削除
- 旧Tokenの流用

新Proposal：

```text
FRONTIER-LOCK-20260726-003
```

新しいReserved Token：

```text
APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-003
```

本Taskでは新Tokenも使用しない。Proposal 003を作成して承認待ちで停止する。

---

## 7. 読む文書

### 7.1 正本

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/02-installation.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/08-plugin-collection.md
docs/09-roadmap.md
docs/10-waymark-economy.md
docs/11-deferred-design-items.md
docs/12-permission-model.md
docs/14-frontier-v0.1.0-scope.md
versions.yml
plugin-manifest.yml
codex/README.md
```

### 7.2 最新Concept

```text
concepts/plugins/Project_Wayfarer_Plugin_Concept_v0.0.3.md
concepts/plugins/main/Project_Wayfarer_Growth_Tool_Concept_v0.0.5.md
concepts/plugins/frontier/Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.4.md
concepts/plugins/frontier/Project_Wayfarer_Ruined_Frontier_Integration_Decision_Concept_v0.0.2.md

concepts/frontier/Frontier_Server_Specification_V0.0.5.md
concepts/frontier/Worlds_Beyond_Specification_V0.0.6.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.5.md
```

### 7.3 Phase A

```text
codex/Project_Wayfarer_Frontier_Order8_Artifact_World_and_Runtime_Lock.md
docs/investigations/2026-07-26-frontier-order8-lock-preflight.md
config/frontier-lock/artifact-candidates.yml
config/frontier-lock/world-id-candidates.yml
config/frontier-lock/runtime-boundary-candidates.yml
config/frontier-lock/resource-pack-input-candidates.yml
manual-downloads/frontier/README.md
```

---

## 8. Plugin Concept側の文書整合

## 8.1 Plugin全体Concept

対象：

```text
concepts/plugins/Project_Wayfarer_Plugin_Concept_v0.0.3.md
```

修正：

- Current child ConceptのWorlds Beyond Pluginをv0.0.3からv0.0.4へ更新する。
- `Wayfarer_Frontier`責務の参照先をv0.0.4へ更新する。
- Revision概要のCurrent Version表記をv0.0.4へ更新する。
- Gameplay内容は変更しない。
- Concept Versionはv0.0.3のままとする。

## 8.2 Plugin Concept Index

対象：

```text
concepts/plugins/README.md
```

修正：

```text
Worlds Beyond Plugin:
  v0.0.4
```

次の未完了表現を同期済みへ変える。

```text
Worlds Beyond Theme Concept:
  v0.0.6へ同期済み
```

## 8.3 Frontier Plugin Index

対象：

```text
concepts/plugins/frontier/README.md
```

Current：

```text
Worlds Beyond Plugin v0.0.4
Ruined Frontier Integration Decision v0.0.2
```

Related concepts：

```text
concepts/plugins/Project_Wayfarer_Plugin_Concept_v0.0.3.md
concepts/frontier/Worlds_Beyond_Specification_V0.0.6.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.5.md
concepts/frontier/Frontier_Server_Specification_V0.0.5.md
```

ZIP配布物向けの「このPackageだけを収録」「本ZIPには含めない」という表現をRepository Index向けに修正する。

## 8.4 Worlds Beyond Plugin Concept同期状態

対象：

```text
concepts/plugins/frontier/Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.4.md
```

Section 25を次へ変更する。

```text
## 25. Theme Concept同期結果

Status: Synchronized
```

`Worlds_Beyond_Specification_V0.0.6.md`へ反映済みであることを記録する。Overworld単一World、Launchpad、Navigation GUIの一覧は確認一覧として維持してよい。

「今後同期する」「別チャットで同期する」という未完了表現を除去する。

Versionはv0.0.4のままとする。

## 8.5 Ruined Frontier Integration Decision

対象：

```text
concepts/plugins/frontier/Project_Wayfarer_Ruined_Frontier_Integration_Decision_Concept_v0.0.2.md
```

修正：

- Related Theme ConceptをRuined Frontier v0.0.5へ更新する。
- 「Frontier Lobby／Worlds Beyond／MainとのMVI Profile分離」という趣旨を次へ分ける。

```text
Frontier Lobby／Worlds Beyond:
  MVI Profileを分離

Main Backend:
  Backend／Network境界でItemとPlayer Stateを共有しない
```

`Main Itemが存在しない`というLifecycle確認は維持してよい。

Versionはv0.0.2のままとする。

---

## 9. Frontier Concept側の文書整合

## 9.1 EliteMobs–MVI Adapter Artifact境界

対象候補：

```text
concepts/frontier/Frontier_Server_Specification_V0.0.5.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.5.md
```

統一：

```text
通常:
  Wayfarer_Core
  Wayfarer_Frontier

Decision Result = ADAPTER_REQUIRED:
  Wayfarer_Frontier_EliteMobsMVI
  independent Runtime Plugin／Artifact
```

`Wayfarer_Frontier`の常設内部Moduleとして既定化しない。

独立Adapterの責務は次だけに限定する。

- 承認済みInstance World検出
- MVI Guild Group登録
- 削除後解除
- Restart残留検査
- Audit／Reconcile

通常Inventory保存、EliteMobs Instance Lifecycle、Gameplay、退出、RespawnまたはWorld削除を担当しない。

## 9.2 Elytra耐久

対象：

```text
concepts/frontier/Worlds_Beyond_Specification_V0.0.6.md
```

変更前：

```text
Unbreakableまたは耐久を自動維持する
```

変更後：

```text
Unbreakableとする
```

自動修理方式を選択肢として残さない。

## 9.3 Frontier履歴／Rollback

対象候補：

```text
concepts/frontier/Frontier_Server_Specification_V0.0.5.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.5.md
```

統一：

```text
Block History／Rollback:
  Order 8以降に選定
  CoreProtectは候補だが未採用
```

CoreProtectを確定導入済みと読める表現を除去する。

本TaskではCoreProtectを導入・削除・試験しない。

---

## 10. `Wayfarer_Main`／Growth Pickaxeの正式Scope

V0.1.0必須Custom Plugin：

```text
Wayfarer_Core
Wayfarer_Main
Wayfarer_Frontier
```

条件付き：

```text
Wayfarer_Frontier_EliteMobsMVI
  only when ADAPTER_REQUIRED
```

配置：

```text
Wayfarer_Core:
  Main
  Frontier

Wayfarer_Main:
  Main

Wayfarer_Frontier:
  Frontier

Wayfarer_Frontier_EliteMobsMVI:
  Frontier
  conditional
```

Growth Pickaxe最低Scope：

```text
Playerごとに1本
Main Backend限定
MariaDB logical identity
Owner Bind
Resource three-dimension progress
Material Evolution
Efficiency
Unbreaking
Fortune
Admin Fortune／Silk Touch切替
Config完全再計算
Broken Tool
Waymark Full Repair
統合GUI
初回自動配布
Pending Delivery
Admin付与／再発行
Audit／Reconcile
```

Progress対象：

```text
resource
resource_nether
resource_end
```

非対象：

```text
main
main_nether
main_the_end
unknown worlds
```

V0.1.0 Scope外：

```text
Axe
Shovel
Player向けWM Fortune／Silk Touch切替
Player向けNetherite Upgrade
Ranking
Evolution Reward
Ability
Cosmetic
Cross-server Tool移送
```

Growth ToolはVanilla Tool利用を禁止しない。

Growth ToolをMainとFrontier間で移送しない。

---

## 11. Plugin Repository境界

独自Plugin Sourceは、Project Wayfarer Repository外の**一つのGradle Multi-module Repository**で管理する。

概念構成：

```text
libraries/
  wayfarer-api
  wayfarer-common
  wayfarer-testkit

integrations/
  wayfarer-leafgrapple-adapter
  wayfarer-elitemobs-mvi-contract
    only if required

plugins/
  wayfarer-core
  wayfarer-main
  wayfarer-frontier
  wayfarer-frontier-elitemobs-mvi
    only if required
```

Project Wayfarer Repository：

- Concept
- Integration Contract
- Runtime placement
- Version／Hash
- Config
- Migration受入
- Backup／Restore
- Project側Test Report

External Plugin Repository：

- Source
- Gradle Project
- Plugin内部設計
- Migration
- Unit／Integration Test
- Build／Release
- Plugin側Test Report

旧正本の「CoreとFrontierをそれぞれ別Repositoryへ置く」と解釈できる記述を、一つの外部Multi-module Repositoryへ修正する。

正確なRepository名、Group ID、Package Root、Module Directory、Versioning、CI／Release方式は後続TaskでLockする。

---

## 12. Roadmap更新

Order 1～8は維持する。

```text
Order 7:
  CoreProtect deferred／non-blocking

Order 8:
  Frontier Lock
  Phase A Revision 003
  approval pending
```

Order 9以降を次へ更新する。

| Order | Work | Outcome |
|---:|---|---|
| 9 | Plugin Repository foundation＋Wayfarer_Core | 一つの外部Gradle Multi-module Repositoryの正式設計、共通Contract、Core実装、Test、Release Candidate、Project統合 |
| 10 | Wayfarer_Main／Growth Pickaxe | 実装作業指示書兼設計仕様書、Module実装、Unit／Integration Test、Release Candidate、Main統合、Migration、Config、Detailed Acceptance、Backup／Restore判定 |
| 11 | Wayfarer_Frontier | Module設計、実装、Test、Release Candidate、Frontier統合 |
| 12 | Frontier shared foundation | MVI、Ruined-only MNP、WE／WG確認、FMM、RPM、Frontier Pack、Beyond／Guild Gate foundation |
| 13 | EM Adapter necessity decision | Static登録、厳密Regex、Adapterの順に判断 |
| 14 | Ruined Frontier alpha | Guild、Primis、Ruined Frontier三次元、BetterStructures＋EliteMobs |
| 15 | Worlds Beyond MVP | `frontier_iris`単一World、Traversal、Launchpad、Waystone、WM Shop |
| 16 | Frontier two-Theme integration | MVI分離、Item隔離、Pack切替、Routing、Restart／Reconnect |
| 17 | Final Gate and Permission lock | Exact Gate方式、Route、Player／Builder／Admin Node |
| 18 | Builder Phase 1B | Explicit minimal allowlist |
| 19 | User Hub／Gate construction | Ownerが外観、座標、向き、安全到着を確定 |
| 20 | Main Spawn protection | Exact WorldGuard Region |
| 21 | Portal Routing completion | Lobby／Main／Frontier／Theme／Resource Route |
| 22 | Resource Reset Bootstrap | Resource三次元限定 |
| 23 | Integrated operations | `Wayfarer.ps1` |
| 24 | Cold Backup／Isolated Restore | 全Authorityの復元 |
| 25 | V0.1.0 Pre-release Player State Reset | Custom Plugin Dataを含むExact Reset判断 |
| 26 | V0.1.0 Baseline | Post-reset Backupと全Blocker判定 |

依存関係：

```text
Order 9 Core Contract
├─→ Order 10 Wayfarer_Main
└─→ Order 11 Wayfarer_Frontier
```

Order 10と11は、Core Contractを壊さない範囲で並行可能。

現行正本、Current Candidate、未完了ChecklistのOrder参照だけを更新する。Historical Report、旧Concept、完了済みTask本文の旧番号を機械的に書き換えない。

---

## 13. Growth Pickaxe Detailed Acceptance

`docs/06-acceptance-tests.md`へProject-owned Plugin用のRisk-focused Sectionを追加する。

### Artifact／Repository

- 一つの外部Gradle Multi-module Repository
- `Wayfarer_Main` Release provenance
- Exact Version／SHA-256／Source Commit
- Main-only placement
- Frontier／Lobbyへの誤配置なし
- Migration Version
- Config Version
- JAR／Secret／Runtime Data非追跡

### 非同期Join／Delivery

- Join EventでMain Thread DB I/Oなし
- 非同期Record照会
- Playerごとに初回だけ1本
- Unique constraintとRace safety
- Inventory Full時に地面Dropしない
- Player通知
- Console WARN
- Pending Delivery
- Logout中に付与しない
- Admin Reconcile／Delivery
- Delivered Recordへ自動Reissueしない

### Identity／Owner Bind

- Tool ID
- Owner UUID
- Item Type
- Instance Epoch
- Schema Version
- Owner以外使用／Progress拒否
- Drop拒否
- Pickup拒否
- Container拒否
- Anvil／Grindstone／Smithing／Craft repair拒否
- Mending拒否
- mcMMO等の外部Repair拒否
- Item Frame／Armor Stand拒否
- Death Drop除外
- Reissue後旧Epoch拒否

### Progress

- Resource三次元だけ加算
- Main三次元と未知Worldでは非加算
- `minecraft:mineable/pickaxe`
- Player設置Block
- Cobblestone／Stone／Basalt Generator
- Silk Touch Ore再設置
- Ore再採掘
- SURVIVAL
- 実際に破壊が成立するADVENTURE
- CREATIVE／SPECTATOR非加算
- Cancel Event非加算
- Explosion／Piston／WorldEdit／Command／Plugin直接削除は非加算
- Main Handの正規Growth Pickaxeだけ加算

### Evolution

- Wood → Stone → Iron → Diamond
- Diamond後のEnchant Cycle
- Efficiency X
- Unbreaking X
- Fortune V
- Admin Fortune／Silk Touch切替
- Netherite Upgradeは初期Acceptance外
- Player向けWM Fortune／Silk Touch切替は初期Acceptance外
- 累計ProgressからMaterial／Enchantを導出
- 個別Enchant Levelを永続正本にしない

### Config再計算

- 累計Progress不変
- 新Configで完全再計算
- Material／Enchant降格
- Item表示同期
- Config再計算だけでは修理しない
- ACTIVE換算後の残存耐久は最低1
- 実Progressによる進化だけ全回復
- 危険設定のHot Reload拒否

### Broken／Repair

- Broken Toolは`GRAY_DYE`
- Broken状態で採掘不可
- Main Hand空中右ClickでGUI
- Waymark Full Repair
- 修理後に正規Item再発行
- Transaction ID
- Idempotency
- 二重請求防止
- Failure時RefundまたはReconcile
- Unknown Transactionを黙って完了扱いしない
- Broken状態とDamageのRestart保持

### Persistence／Performance

- MariaDB Migration
- `wf_main_*` ownership
- Session Cache
- 周期Checkpoint
- 重要状態即時保存
- Restart／Reconnect
- Quit Flush
- Timeout付きShutdown Flush
- Disable後Callback非適用
- Main Thread DB I/Oなし
- Audit
- Concurrency conflict
- Reconcile

### Boundary

- Mainだけで有効
- Growth ToolをFrontierへ移送しない
- Main／Frontier item non-transferを維持
- Waymark Adapter経由
- RedisEconomy内部Keyを直接操作しない
- MVI、mcMMO、EliteMobs Databaseを直接更新しない

---

## 14. Backup／RestoreとReset

V0.1.0 Cold Backupへ追加する。

```text
Wayfarer_Core／Main／Frontier Release Artifact
Version
SHA-256
Source Commit
Tracked Config
Sanitized Template
Rendered Config without Secrets
Migration history
Wayfarer custom Plugin MariaDB schemas／data
wf_main_* Schema／Data
Growth Tool logical records
Pending Delivery
Item instance epochs
ACTIVE／BROKEN state
Audit／transaction／reconcile records
Waystone／Launchpad data
Plugin-side Test Report
Project-side Test Report
MVI Profiles
Frontier Worlds
Frontier Pack inputs／outputs／hashes
```

Restore順：

1. MariaDB／Redis foundation
2. Migration version verification
3. MVI data
4. World data
5. Custom Plugin data
6. Plugin Artifact／Config
7. Backend
8. Proxy
9. Reconcile／Health
10. Player Join

Growth Tool Restore確認：

- Tool ID
- Owner
- Epoch
- Progress
- Material／Enchant再導出
- ACTIVE／BROKEN
- Pending Delivery
- Repair Transaction
- 重複発行なし

RedisをInventoryまたはGrowth Toolの正本にしない。

Pre-release Reset：

```text
Growth Tool Data:
  ResetかPreserveか未決
  Ownerの別承認が必要
```

Codexは独断で決めない。

---

## 15. Frontier正本の同期

## 15.1 `docs/14-frontier-v0.1.0-scope.md`

Concept参照：

```text
Frontier Server v0.0.5
Worlds Beyond v0.0.6
Ruined Frontier v0.0.5
Plugin Concept v0.0.3
Worlds Beyond Plugin v0.0.4
Ruined Frontier Integration Decision v0.0.2
```

MVI：

```text
neutral:
  frontier_gate

worlds_beyond:
  frontier_iris only

guild:
  Adventurer's Guild
  Primis
  frontier_bs
  frontier_bs_nether
  frontier_bs_the_end
  approved fixed Dungeons
  verified Instances
```

Worlds Beyond Scope：

```text
Frontier Lobby Beyond Gate
Iris Overworld frontier_iris
PEACEFUL
worlds_beyond MVI Group
Nether／End Portal点火または通過拒否
No fallback
Traversal Loadout
LeafGrapple
Launchpad
Frontier WM Shop
Waystone
Discovery／Teleport GUI
Persistent World
Integrated Resource Pack
```

削除する現行要件：

- Iris Nether
- Iris End
- Worlds Beyond用MNP Link
- Worlds Beyond family-local Nether／End route

Multiverse-NetherPortalsはRuined Frontier Familyだけに使用する。

## 15.2 `docs/09-roadmap.md`

Worlds Beyond MVPをOverworld-onlyへ変更する。

Ruined Frontier三次元とfamily-local Portalを維持する。

Frontier shared foundationのMNPをRuined Frontier用と明記する。

## 15.3 `docs/06-acceptance-tests.md`

共通Frontier：

```text
Ruined Frontier:
  family-local Nether／End Portal boundary

Worlds Beyond:
  no Nether／End world
  no MNP link
  portal activation／travel denied
  no fallback
```

Worlds Beyond Acceptance：

- `frontier_iris`だけをIris Persistent Worldとして使用
- `frontier_iris`だけをMVI `worlds_beyond`へ登録
- `frontier_iris_nether`を作成／登録しない
- `frontier_iris_the_end`を作成／登録しない
- Nether／The End／未知WorldでWorlds Beyond機能がFail-closed
- Worlds Beyond向けMNP Linkなし
- Default／Ruined／Main／未知WorldへFallbackしない
- Beyond Gateは`frontier_iris`だけへ接続
- Frontier Gateへ安全に帰還

Ruined Frontierの三次元／Portal Acceptanceを削除しない。

---

## 16. Proposal 003へ再基底化

対象：

```text
docs/investigations/2026-07-26-frontier-order8-lock-preflight.md
config/frontier-lock/artifact-candidates.yml
config/frontier-lock/world-id-candidates.yml
config/frontier-lock/runtime-boundary-candidates.yml
config/frontier-lock/resource-pack-input-candidates.yml
manual-downloads/frontier/README.md
codex/README.md
```

Current Candidateへ追加：

```yaml
proposal_id: FRONTIER-LOCK-20260726-003
previous_proposal: FRONTIER-LOCK-20260726-002
previous_status: superseded-before-approval
phase_b: not-authorized
approval_token_received: false
status: candidate
runtime_validation: deferred
```

Revision 001／002の履歴はPreflight Reportへ保持する。

更新するもの：

- 最新Concept path／version
- Worlds Beyond Overworld-only
- No WB Nether／End World ID
- No WB MNP Link
- Ruined-only MNP
- one external multi-module Plugin Repository
- `Wayfarer_Main`／Growth PickaxeのV0.1.0 Scope
- 新Order 9～26
- conditional independent Adapter Artifact
- Frontier history／rollbackは候補・未採用
- Runtime validation deferred

維持するもの：

- MVI 5.3.5
- MNP 5.0.5
- Advanced Portals 2.8.0
- Iris 3.9.2
- Iris Overworld Pack
- LeafGrapple 1.0.2
- EliteMobs 10.7.3
- Primis
- Free Elite Shrines
- Dungeoneering Modules Free
- BetterStructures 2.6.3
- BS four-Pack＋Prop候補
- FMM 2.10.2
- RPM 2.3.0
- BetterHealthBar 4.1.0
- CoreProtect 24.0 selected-for-later-validation
- Adventurer's Guild Artifact deferral
- Artifact SHA-256

Artifactが同一なら再Download／再Hash要求を増やさない。

`Wayfarer_Main`をFrontierへの配置候補へ追加しない。Custom Plugin RepositoryのSibling Moduleとしてのみ記録する。

Phase B用正式Fileを作成しない。

---

## 17. 更新対象

最低限確認し、必要箇所だけ更新する。

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/02-installation.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/08-plugin-collection.md
docs/09-roadmap.md
docs/11-deferred-design-items.md
docs/12-permission-model.md
docs/14-frontier-v0.1.0-scope.md
versions.yml
plugin-manifest.yml
codex/README.md

concepts/plugins/Project_Wayfarer_Plugin_Concept_v0.0.3.md
concepts/plugins/README.md
concepts/plugins/frontier/README.md
concepts/plugins/frontier/Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.4.md
concepts/plugins/frontier/Project_Wayfarer_Ruined_Frontier_Integration_Decision_Concept_v0.0.2.md
concepts/frontier/Frontier_Server_Specification_V0.0.5.md
concepts/frontier/Worlds_Beyond_Specification_V0.0.6.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.5.md

docs/investigations/2026-07-26-frontier-order8-lock-preflight.md
config/frontier-lock/artifact-candidates.yml
config/frontier-lock/world-id-candidates.yml
config/frontier-lock/runtime-boundary-candidates.yml
config/frontier-lock/resource-pack-input-candidates.yml
manual-downloads/frontier/README.md
```

新規：

```text
docs/investigations/<date>-plugin-scope-and-frontier-lock-revision003-resync.md
codex/Project_Wayfarer_Plugin_Scope_and_Frontier_Lock_Revision003_Resync.md
```

`versions.yml`／`plugin-manifest.yml`：

許可：

- `Wayfarer_Main`を`planned-not-installed`
- one multi-module Repository方針
- Worlds Beyond planned scopeをOverworld-only
- Proposal 003をcandidate／not-approved

禁止：

- Phase A候補Pluginをinstalled／acceptedへ変更
- 未導入JARをCurrent Runtimeへ記録
- Proposal 003をformal lockへ変更
- 未開発Custom PluginのVersion／SHA-256捏造

---

## 18. Version／Archive方針

- 新しいGameplay判断を追加しない。
- 現行Version内の参照・同期状態訂正として更新する。
- 新しいConcept Version Fileを作成しない。
- `old/`の本文を変更しない。
- Archive FileをCurrentへ戻さない。
- Historical Investigationの旧Proposal／Order番号を機械置換しない。
- Current Index、Current Concept、Current正本、Current Candidateだけを修正する。

Version Upが必要と判断した場合は停止し、理由と対象Fileを報告する。

---

## 19. Phase B非実施の機械確認

次が存在しないこと、または本Taskで作成されていないことを確認する。

```text
docs/15-frontier-runtime-lock.md
config/frontier-lock/artifact-lock.yml
config/frontier-lock/world-id-lock.yml
config/frontier-lock/runtime-boundary-lock.yml
config/frontier-lock/resource-pack-input-lock.yml
config/frontier-lock/persistence-authority-lock.yml
```

確認：

- Order 8は`complete`でない。
- Proposal 003は`candidate`。
- `phase_b: not-authorized`。
- `approval_token_received: false`。
- Runtime Artifactは未導入。
- Worldは未生成。
- MVIは未設定。
- Frontier Packは未生成。

---

## 20. Runtime非変更

本Taskで変更しない。

```text
servers/main/
servers/frontier/
servers/lobby/
velocity/
infrastructure runtime data
manual-download artifact files
MariaDB
Redis
LuckPerms data
Worlds
Player Data
Resource Packs
```

Serverを起動しない。

Protected Portを開かない。

JAR、ZIP、World、Log、DB、SecretをStageしない。

---

## 21. 検索と検証

### Git

```powershell
git status --short
git diff --check
git diff --stat
git diff --cached --name-status
.\scripts\Test-Layout.ps1
```

### YAML

Parse：

```text
versions.yml
plugin-manifest.yml
config/frontier-lock/*.yml
```

### Current文書検索

```text
Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.3
Frontier_Server_Specification_V0.0.4
Worlds_Beyond_Specification_V0.0.4
Worlds_Beyond_Specification_V0.0.5
Ruined_Frontier_Specification_V0.0.4
Worlds Beyond Overworld, Nether, and End
Iris Overworld, Nether, and End
frontier_iris_nether
frontier_iris_the_end
family-local Portal links inside Worlds Beyond
Worlds Beyond三次元
All three Worlds
Frontier Lobby／Worlds Beyond／MainとのProfile分離
Unbreakableまたは耐久を自動維持
CoreProtect
EliteMobs–MVI Adapter
Wayfarer_Core and Wayfarer_Frontier
separate Repositories
FRONTIER-LOCK-20260726-002
```

許容：

- `old/`
- Archive
- Revision History
- Superseded Proposal履歴
- Explicit rejected／forbidden list
- Ruined Frontier三次元
- CoreProtect候補・未採用説明
- 条件付き独立Adapter説明

不許容：

- Current Index
- Current Concept
- Current authoritative scope
- Current Roadmap
- Current Acceptance
- Current Candidate
- Current Proposal ID

### 必須存在

```text
Wayfarer_Main
Growth Pickaxe
resource
resource_nether
resource_end
one Gradle Multi-module Repository
frontier_iris only
Ruined Frontier three dimensions
FRONTIER-LOCK-20260726-003
superseded-before-approval
phase_b: not-authorized
approval_token_received: false
```

### Markdown Link

Current文書の相対Link切れを確認する。

### Runtime Non-change

```powershell
git diff --name-only 9abc12ae5f472325933d38c5eacc6050aaf3e6c7..HEAD
```

Runtime Path、JAR、World、Secret、Database Dataが含まれないことを確認する。

---

## 22. Decision Gate

完了報告で次を提示して停止する。

```text
Proposal:
  FRONTIER-LOCK-20260726-003

Status:
  awaiting exact approval

Phase B:
  not executed

Current valid token:
  APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-003
```

同じ実行内でPhase Bへ進まない。

新TokenはUserが別Messageで明示した場合だけ有効。

---

## 23. Commit／Push

推奨Implementation Commit：

```text
docs: Plugin ScopeとFrontier Lock候補をRevision 003へ同期
```

推奨Archive Commit：

```text
docs: Frontier Lock Revision 003 Commitを記録
```

Commitを不必要に細分化しない。

Push前：

```powershell
git status --short
git log -10 --oneline
git diff --check
.\scripts\Test-Layout.ps1
```

Push後、Remote SHAを確認する。

---

## 24. Codex Archive

本Task：

```text
完了（実装Commit: <SHA>）
```

Order 8：

```text
承認待ち（Proposal: FRONTIER-LOCK-20260726-003）
```

Proposal 002：

```text
superseded-before-approval
```

再実行Policy：

```text
本Task完了後はそのまま再実行禁止。
Proposal 003承認後のPhase Bは、既存Order 8指示書と本RevisionのCurrent Contractに従う別の明示実行とする。
```

---

## 25. 完了条件

### Commit監査

- 6 Commitが直線履歴
- Codex Phase A対応が適切
- Owner Commitを変更・巻戻ししていない
- Runtime変更なし

### Concept

- Plugin全体ConceptがWB Plugin v0.0.4を参照
- Plugin READMEがv0.0.4をCurrent表示
- Frontier Plugin READMEがFrontier v0.0.5、WB v0.0.6、Ruined v0.0.5を参照
- WB Plugin Section 25が`Synchronized`
- Ruined DecisionがRuined v0.0.5を参照
- Main分離をMVI Profile分離として記載しない
- ElytraがUnbreakable
- Adapterが条件付き独立Artifact
- CoreProtectが未採用候補
- Archive未変更

### Project Scope

- Core／Main／FrontierがV0.1.0 required
- one external Gradle Multi-module Repository
- conditional Adapter
- Growth PickaxeがRelease Blocker
- Reset方針未決
- Runtime未実装

### Frontier正本

- `worlds_beyond`は`frontier_iris`だけ
- WB Nether／Endなし
- WB MNP Linkなし
- WB fallback拒否
- Ruined三次元維持
- Ruined-only MNP
- Current Concept Version参照

### Roadmap／Acceptance／Backup

- Order 9～26更新
- Growth Pickaxe Detailed Acceptance
- Custom Plugin Backup／Restore
- Main／Frontier item boundary
- Reset別承認

### Proposal

- 002は未承認の履歴
- 003はCurrent Candidate
- Phase B未実施
- Artifact判断／Hash維持
- Runtime validation deferred
- Exact new Token提示

### Safety

- Server起動なし
- World変更なし
- DB変更なし
- Permission変更なし
- Artifact配置変更なし
- Git除外成功
- Clean final status

---

## 26. 完了報告

次を報告する。

1. Recommended Sol
2. Pre-execution HEAD
3. 6 Commitの親子関係
4. Codex Commit監査結果
5. Owner Commit preservation
6. Implementation Commit SHA／Message
7. Archive Commit SHA／Message
8. Branch／Remote
9. 変更File一覧
10. Concept参照Version更新
11. WB Plugin同期状態
12. Adapter Artifact境界
13. MVIとMain Backend境界
14. Elytra耐久
15. CoreProtect採否表現
16. Worlds Beyond正式Scope
17. Ruined Frontier三次元維持
18. MVI Group差分
19. MNP Scope差分
20. Custom Plugin構成
21. Plugin Repository方針
22. Growth Pickaxe V0.1.0 Scope
23. Roadmap Order 9～26
24. Acceptance追加
25. Backup／Restore追加
26. Reset方針未決
27. Proposal 001状態
28. Proposal 002状態
29. Token 002未実行確認
30. Proposal 003
31. Token 003
32. Artifact選定／Hash維持
33. Runtime non-change
34. 残存旧表現の分類
35. Markdown Link確認
36. YAML／Layout検証
37. Git exclusion
38. Final `git status --short`
39. 未解決事項
40. Next user action

Next user action：

```text
Proposal FRONTIER-LOCK-20260726-003を確認する。
旧002 Tokenは使用しない。
承認する場合は別Messageで次を送る。

APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-003
```

---

## 27. 完了後の状態

```text
Final Main Baseline:
  unchanged

Order 7 CoreProtect:
  deferred／non-blocking

Wayfarer_Main／Growth Pickaxe:
  V0.1.0 Release Blocker
  not implemented
  not installed

External Plugin Repository:
  one Gradle Multi-module Repository
  not created

Order 8 Frontier Lock:
  Phase A Revision 003 complete
  awaiting exact approval
  Phase B not executed

Proposal 002:
  superseded-before-approval
  token never executed

Proposal 003:
  current candidate

Runtime:
  unchanged

Next:
  User review of Proposal 003
```
