# Project Wayfarer Ver.0.0.6 正式Scope・Roadmap文書更新 指示書

## 1. 目的

Project Wayfarerの正式文書を、ユーザーが承認した最新方針へ更新する。

本タスクは**文書・設計正本の更新だけ**を行う。Plugin導入、Custom Plugin開発、Runtime変更、World生成・再生成、Content Import、Permission変更、Database Migrationその他の実装は行わない。

今回の正式設計改訂番号は、現在の`Ver.0.0.5`から次へ更新する。

```text
Ver.0.0.6
```

`Ver.0.0.6`はServer Releaseではなく、将来の`V0.1.0 Alpha`へ向けた設計改訂である。

---

## 2. Repository

```text
eariver/Project_Wayfarer
```

作業対象は、VS Codeで開かれているProject Wayfarer Repository Root内だけとする。

作業開始時に確認する。

```powershell
git status --short
git branch --show-current
git remote -v
git log -5 --oneline
```

以下を確認する。

1. Repository Rootである。
2. 現在BranchとConfigured Upstreamが意図したもの。
3. 意図不明な未Commit変更がない。
4. 最新の`AGENTS.md`、Root `README.md`、`docs/`、`codex/README.md`を読んでいる。
5. 以下のConceptが存在する。
6. `concepts/`内の文書は今回の設計入力であり、本文を変更しない。

設計入力：

```text
concepts/main/Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md

concepts/frontier/Frontier_Server_Specification_V0.0.4.md
concepts/frontier/Worlds_Beyond_Specification_V0.0.4.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.4.md
```

ConceptのFile名または配置が異なる場合は、勝手に類似Fileを採用せず、Exact Pathを報告して停止する。

---

## 3. ユーザー承認済み方針

以下は本タスクで正式文書へ反映する、ユーザー承認済みのProject方針である。

### 3.1 Main BetterStructures

Mainは、Conceptで選定されたBetterStructures構成を導入する。

対象はMain Persistent Family：

```text
main
main_nether
main_the_end
```

Resource Family：

```text
resource
resource_nether
resource_end
```

ではBetterStructuresを引き続き無効とする。

Main向け採用構成は、Conceptで定義された以下を正式な実装予定Scopeとする。

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack internal version 1
Echoes of the Past version 3
BetterStructures Prop Pack
FreeMinecraftModels
ResourcePackManager
```

Version、License、Artifact Hash、配布元および実際の互換性は導入タスクでLockする。ConceptにあるVersionを、実Artifact確認なしにRuntime正本へ登録しない。

### 3.2 Main World再生成順序

Main Persistent Familyは、追加Contentが最初のChunkから生成される統一Baselineを作るため、別途承認された破壊的タスクで再生成する。

実装順序は次を正とする。

```text
Artifact検証
↓
Runtime Working Copy生成
↓
Structure選別Config作成
↓
Prop／Model ID正規化
↓
BetterStructures、FreeMinecraftModels、ResourcePackManagerおよび全採用Contentを導入
↓
World Allowlist、Content Load、Resource Pack生成・配信Preflight
↓
全Plugin／Contentが正常Loadすることを確認
↓
明示承認された破壊的タスクでMain Persistent Familyを再生成
↓
自然生成、Portal、Spawn、Resource Pack、Resource Family除外を受入試験
↓
必要なWeight／Content調整
↓
新しいMain Persistent World Baselineを確定
↓
CoreProtect導入
```

**Content Importより先にWorldを生成しない。**

現在のMain Persistent World Baselineは、再生成タスクが実行・検証されるまでは現行Runtime正本として維持する。今回の文書更新だけで既存BaselineをSuperseded扱いにしない。

### 3.3 V0.1.0 Frontier Scope

`V0.1.0 Alpha`には、次の両Themeを初期構成案まで実装する。

```text
Ruined Frontier
Worlds Beyond
```

「どちらか一方だけをPlayable Themeとして導入すればよい」という旧方針を廃止する。

両Themeの実装・統合・受入試験をV0.1.0 Release Blockerとする。

### 3.4 Ruined Frontier初期構成

Ruined Frontierは、Conceptのalpha構成をV0.1.0へ採用する。

最低限：

```text
Frontier LobbyのGuild Gate
Adventurer's Guild
Primis
Ruined Frontier Overworld
Ruined Frontier Nether
Ruined Frontier End

Multiverse-Core
Multiverse-Inventories
Multiverse-NetherPortals
WorldEdit
WorldGuard
CoreProtect

BetterStructures
EliteMobs
FreeMinecraftModels
ResourcePackManager
BetterHealthBar3の採用試験

BetterStructures Prop Pack
Exploration Pack
Caves and Lost Civilizations Free
Echoes of the Past
Adventure Pack
Free Elite Shrines
Dungeoneering Modules Free
```

Ruined Frontier三次元では、BetterStructuresとEliteMobsの両方を有効にする。

```text
frontier_bs
frontier_bs_nether
frontier_bs_the_end
```

BetterStructures内のEliteMobs Sign、Elite Shrine、Boss、Lootおよび関連Contentが正しく動くことを受入試験する。

### 3.5 Worlds Beyond初期構成

Worlds Beyondは、ConceptのMVP初期構成をV0.1.0へ採用する。

最低限：

```text
Frontier LobbyのBeyond Gate
Iris Overworld
Iris Nether
Iris End
PEACEFUL
Multiverse-Inventories Worlds Beyond Group
Multiverse-NetherPortals World Family Link
Elytra
LeafGrapple
Worlds Beyond Traversal Loadout
Launchpad
Frontier WM Shop
Waystone
Discovery GUI
Teleport GUI
Persistent World運用
Resource Pack連携
```

Iris Engine／Pack、Seed、World Border、LeafGrappleおよび正確なRuntime World名は、専用導入・生成タスクでLockする。

### 3.6 Wayfarer_Core／Wayfarer_Frontier

`Wayfarer_Core`および`Wayfarer_Frontier`は、V0.1.0までに開発・導入する必要がある。

両PluginのSourceは、Project Wayfarer本体Repositoryではなく、別Repositoryで管理する。

Project Wayfarer本体Repositoryには、以下だけを保存する。

- Integration Contract
- Version Constraint
- Plugin Manifest
- Configuration
- Installation Procedure
- Permission Contract
- Database／API Contract
- Acceptance Test
- Release Artifact Hash
- Operational Procedure

Project Wayfarer本体Repository内にJava、Kotlin、Gradle、Maven等のPlugin Source Projectを作成しない。

#### Wayfarer_CoreのV0.1.0責務

最低限：

```text
MariaDB接続基盤
Schema Migration基盤
Waymark Service Adapter
Transaction ID
Idempotency基盤
共通Audit
Player Identity
共通Item Identity基盤
Redis Cache／Lock／PubSub接続基盤
Cross-server Message基盤
Permission Contract基盤
```

RedisをInventoryやGameplay永続Dataの単独正本にしない。

#### Wayfarer_FrontierのV0.1.0責務

最低限：

```text
Worlds Beyond Traversal Loadout
Worlds Beyond固有Item Identity
Launchpad
Waystone
Waystone Discovery GUI
Waystone Teleport GUI
Frontier WM Shop
Admin／Inspect／Reconcile
Audit Adapter
必要性確認後のEliteMobs–MVI Adapter
将来のRuined Frontier WM Reward Adapter基盤
```

通常Inventory保存・復元、通常のWorld変更監視、物理Gate移動、EliteMobs本体機能およびBetterStructures本体機能は再実装しない。

### 3.7 Multiverse-Inventories

Frontier Backend内のWorld Group別Player Stateは、Multiverse-InventoriesをRuntime正本とする。

MVIへ委譲する対象：

```text
Inventory
Armor
Offhand
Ender Chest
Vanilla XP／Level
Health
Food／Saturation
導入Versionで承認された追加Player State
```

初期Group：

```text
neutral
worlds_beyond
guild
```

概念上の割当：

```text
neutral:
  frontier_gate

worlds_beyond:
  Worlds Beyond Overworld
  Worlds Beyond Nether
  Worlds Beyond End

guild:
  Adventurer's Guild
  Ruined Frontier Overworld
  Ruined Frontier Nether
  Ruined Frontier End
  Primis
  承認済み固定Dungeon
  検証済みEliteMobs Instance
```

`Wayfarer_Frontier`は通常InventoryをMariaDBへ保存せず、MVIのProfile保存・復元を再実装しない。

### 3.8 EliteMobsとMVIの連携

EliteMobs InstanceのMVI対応は、次の順で最小実装を選ぶ。

```text
固定WorldのMVI静的登録
↓
承認済みBlueprint名＋連番に限定した厳密Regex
↓
不足すると確認された場合だけEliteMobs–MVI Adapter
```

Roadmapへ、独立した事前確認項目として次を追加する。

```text
EMアダプタの必要性判断
```

確認内容：

- EliteMobs正式Version
- 対象Content Package
- 固定World／複製World／一時Worldの判定
- Blueprint名
- Instance World命名規則
- MVI静的登録可否
- MVI Regex仕様
- 同時Instance
- Instance終了
- Restart
- Disconnect／Reconnect
- World削除後
- MVI API
- EliteMobs生成／削除Event
- Adapterなしで安全に成立するか

Adapterは必要性が確認された場合だけ開発する。

### 3.9 Main／Frontier間の完全なItem分離

MainとFrontier間では、**Vanilla Itemを含む全Itemを共有・移送しない。**

共有・移送しない対象：

```text
Inventory
Armor
Offhand
Ender Chest
Vanilla Item
EliteMobs Item
Custom Loot
Quest Item
Theme固有Item
素材
Vanilla XP／Level
Health
Food／Saturation
```

Main、Frontier Lobby、Worlds Beyond、Ruined Frontierは、それぞれBackendまたはMVI GroupによってPlayer Stateを分離する。

Network全体で共有する成果は、次に限定する。

```text
Waymark
mcMMO Progression
将来別途承認されるItem非依存の実績
将来別途承認されるItem非依存の実績報酬
```

実績報酬は、別途承認されない限りItem移送経路にしない。

初期候補：

- 称号
- Permission
- GUI表示
- Ranking表示
- Achievement Record
- Cosmetic Unlock
- Waymark
- 非Item型の機能解禁

### 3.10 ResourcePackManager

ResourcePackManagerは、MainおよびFrontierのResource Pack配信基盤として導入対象とする。

MainとFrontierは別Packとする。

Roadmapおよび実装前Lock項目へ、最低限次を追加する。

```text
ResourcePackManager正式Version
Main Pack構成
Frontier Pack構成
Pack生成方式
Pack Hosting方式
Hosting URL
Pack Hash
Minecraftが要求するHash形式
配信を必須にするか
Client拒否時の挙動
Download失敗時の挙動
Main↔Frontier切替時のReload方式
Backend再接続時の挙動
FreeMinecraftModels出力統合
BetterStructures Prop Pack統合
EliteMobs Model統合
BetterHealthBar Asset統合
LeafGrapple Asset統合（採用時）
CustomModelData／Item Model Component競合
Model ID競合
Shader／Font競合
Pack容量
Download時間
Cache更新
Rollback
生成Pack、Model、Content ArtifactのGit非追跡
```

---

## 4. 更新対象

最低限、次を更新する。

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/10-waymark-economy.md
docs/12-permission-model.md
docs/13-main-world-baseline.md
codex/README.md
```

新規作成：

```text
docs/14-frontier-v0.1.0-scope.md
codex/Project_Wayfarer_Ver0.0.6_Formal_Scope_and_Roadmap_Update.md
```

Repository内検索を行い、現在状態を示す`Ver.0.0.5`参照を特定する。

```powershell
git grep -n "Ver\.0\.0\.5"
git grep -n "V0\.1\.0"
git grep -n "Playable Frontier"
git grep -n "Phase 2B"
git grep -n "CoreProtect"
git grep -n "Multiverse-Inventories"
git grep -n "ResourcePackManager"
git grep -n "Wayfarer_Core"
git grep -n "Wayfarer_Frontier"
```

現在の正式Revisionを示す箇所だけ`Ver.0.0.6`へ更新する。

更新しない例：

- 過去のCodex Task名
- 完了済みCommit履歴
- Historical Acceptance Record
- ConceptのVersion
- Ver.0.0.5時点の出来事を説明する履歴文
- Archive文書

---

## 5. `docs/14-frontier-v0.1.0-scope.md`

V0.1.0 Frontier Scopeの正式な正本文書として新規作成する。

推奨構成：

```markdown
# Frontier V0.1.0 Scope

## 1. Authority and status
## 2. V0.1.0 completion condition
## 3. Shared Frontier foundation
## 4. Player State and inventory boundary
## 5. Cross-backend data boundary
## 6. Wayfarer_Core responsibilities
## 7. Wayfarer_Frontier responsibilities
## 8. Ruined Frontier initial scope
## 9. Worlds Beyond initial scope
## 10. EliteMobs–MVI decision procedure
## 11. Resource Pack distribution
## 12. Portal and Gate boundary
## 13. Permission boundary
## 14. Persistence and destructive operations
## 15. Release blockers
## 16. Deferred items
## 17. Acceptance summary
```

文書冒頭で、以下を明記する。

- `docs/14-frontier-v0.1.0-scope.md`は、V0.1.0 Frontier Scopeの正式正本。
- Conceptは詳細設計入力だが非正本。
- 実装には個別Codex Taskが必要。
- V0.1.0ではRuined FrontierとWorlds Beyondの両方が必要。
- 両方が受入試験を満たすまでV0.1.0 Frontier Blockerは完了しない。

Concept全文を複製しない。正式Scope、責務境界、Blockerおよび参照関係を簡潔にまとめる。

ConceptへのLink：

```text
../concepts/frontier/Frontier_Server_Specification_V0.0.4.md
../concepts/frontier/Worlds_Beyond_Specification_V0.0.4.md
../concepts/frontier/Ruined_Frontier_Specification_V0.0.4.md
```

Conceptを「正本」と表現しない。

---

## 6. `docs/09-roadmap.md`

Titleおよび現在Revisionを`Ver.0.0.6`へ更新する。

旧方針：

- CoreProtectが即時の次Task
- Phase 2BはNether／End補完だけ
- Main Persistent Worldを再生成しない
- Frontier Themeは一つだけ
- Theme InventoryはDeferred
- Custom Plugin基盤はV0.2.x以降

を廃止・置換する。

### 6.1 推奨Dependency Order

最低限、次の順序をRoadmapの実行順へ反映する。

```text
1. Ver.0.0.6正式文書更新
2. Main BetterStructures Artifact／Content／Resource Pack Preflight
3. Main BetterStructures全採用Content ImportおよびLoad確認
4. Main Persistent Family再生成
5. Main自然生成／Portal／Spawn／Resource Pack受入試験
6. Main Weight／Content調整および新Baseline確定
7. CoreProtect導入
8. Frontier採用Plugin／Artifact／World ID／Gate方式Lock
9. Wayfarer_Core正式設計・別Repository作成・開発
10. Wayfarer_Frontier正式設計・別Repository作成・開発
11. Frontier共通基盤
    - Multiverse-Core
    - Multiverse-Inventories
    - Multiverse-NetherPortals
    - WorldEdit
    - WorldGuard
    - CoreProtect
    - ResourcePackManager
    - Frontier統合Resource Pack
    - Beyond Gate
    - Guild Gate
12. EMアダプタの必要性判断
13. Ruined Frontier alpha実装
14. Worlds Beyond MVP実装
15. Ruined Frontier／Worlds Beyond統合試験
16. Advanced Portalsまたは採用Gate方式の最終Permission Lock
17. Builder Phase 1B
18. User Hub／Gate construction
19. Main Spawn protection
20. Portal Routing完成
21. Resource Reset Bootstrap
22. Integrated operations
23. Cold Backup／Isolated Restore
24. V0.1.0 Pre-release Player State Reset
25. V0.1.0 Baseline
```

実際のHeading／Phase番号は既存Roadmapの形式へ合わせてよいが、依存関係を変更しない。

### 6.2 Main Phase 2B

Phase 2Bを、旧「Persistent Nether／End Structure Expansion」から、Main全三次元の正式Content拡張および再生成計画へ更新する。

Scope：

```text
main
main_nether
main_the_end
```

Resource Familyは対象外。

再生成は明示承認された破壊的Taskとしてのみ実行する。

### 6.3 Frontier Blockers

以下をV0.1.0 Release Blockerとして追加する。

- Frontier共通基盤
- Multiverse-Inventories
- ResourcePackManager
- Frontier統合Pack
- Wayfarer_Core
- Wayfarer_Frontier
- EMアダプタ必要性判断
- Ruined Frontier alpha
- Worlds Beyond MVP
- 両ThemeのMVI分離
- Main／Frontier全Item分離
- 両ThemeのPortal Family
- Main↔Frontier Backend移動時のResource Pack切替
- 両ThemeからFrontier Lobbyへの安全な帰還
- Frontier Cold Backup／Restore対象の確定

World Generatorだけ導入した状態をPlayable完了としない。

---

## 7. `AGENTS.md`

既存の安全規則を維持したまま、現在Project Invariantを更新する。

最低限：

- 現在の正式設計Revisionは`Ver.0.0.6`。
- Main BetterStructuresの次Scopeは5 Pack＋Prop／FMM／ResourcePackManager。
- Main Persistent Familyは別途承認された破壊的Taskで再生成予定。
- Content導入・Load確認前にMain Worldを生成しない。
- 現在Baselineは再生成完了まで現行正本。
- CoreProtectは新Main Baseline確定後、Hub／Gate大規模建築前に導入する。
- V0.1.0にはRuined FrontierとWorlds Beyondの両方が必要。
- Wayfarer_Core／Wayfarer_FrontierはV0.1.0 Blocker。
- Plugin Sourceは別Repository。
- Frontierの通常Player StateはMVIが正本。
- Main／Frontier間で全Itemを移送しない。
- 共有はWM、mcMMO、将来承認済みのItem非依存実績／報酬だけ。
- ResourcePackManagerはMain／Frontierの配信基盤候補としてLockが必要。
- Frontier Concept V0.0.4は詳細設計入力であり実装Taskではない。
- Concept本文を自動実装しない既存Ruleを維持する。

削除する旧記述：

- CoreProtectが無条件に次の実装Taskである。
- Phase 2BでMain Persistent Familyを絶対に再生成しない。
- Frontier Themeは一つだけでよい。
- Theme InventoryはV0.1.0 Scope外。
- Custom Plugin基盤はV0.2.x以降だけ。

過去状態を説明する履歴文まで削除しない。

---

## 8. `docs/00-design-guide.md`

次を正式方針として反映する。

- Mainの役割
- Main BetterStructures 5 Pack構成
- Content Load前にWorld生成しない
- Main Persistent Family再生成計画
- Resource Family除外
- Ruined FrontierとWorlds Beyondの役割分離
- MVI Group分離
- Main／Frontier全Item分離
- Waymark／mcMMO共有
- Custom Plugin責務
- Resource Pack分離
- Main／FrontierそれぞれのResourcePackManager
- V0.1.0に両Themeが必要

Conceptの細かな数値や全Structure一覧を正本文書へ複製しない。

---

## 9. `docs/01-architecture.md`

Network ArchitectureおよびData Boundaryを更新する。

推奨図：

```text
Velocity
├─ Lobby
├─ Main
│  ├─ Main Persistent Family
│  └─ Resource Family
└─ Frontier
   ├─ frontier_gate / neutral MVI Group
   ├─ Worlds Beyond / worlds_beyond MVI Group
   │  ├─ Overworld
   │  ├─ Nether
   │  └─ End
   └─ Ruined Frontier / guild MVI Group
      ├─ Adventurer's Guild
      ├─ Primis
      ├─ Ruined Frontier Overworld
      ├─ Ruined Frontier Nether
      ├─ Ruined Frontier End
      └─ approved Dungeon / Instance
```

Data Matrix：

| Data | Main | Frontier Lobby | Worlds Beyond | Ruined Frontier |
|---|---|---|---|---|
| Inventory／Armor／Offhand | Main Local | Neutral | WB Group | Guild Group |
| Ender Chest | Main Local | Neutral | WB Group | Guild Group |
| Vanilla XP／Health／Food | Main Local | Neutral | WB Group | Guild Group |
| Waymark | Shared | Shared／display policy | Shared | Shared |
| mcMMO | Shared | No gameplay use | Shared | Shared＋gameplay enabled |
| Item transfer | None | None | None across groups | None across groups |
| Theme Item | Main only | None | WB only | Guild only |
| EliteMobs progression | None | None | Disabled | Guild only |

Wayfarer_Core、Wayfarer_Frontier、MVI、ResourcePackManager、EliteMobs、BetterStructures、Irisの責務を記載する。

---

## 10. `docs/06-acceptance-tests.md`

実装済みAcceptance Recordを変更しない。

将来のV0.1.0 Planned Acceptanceとして、未完了Checklistを追加する。

最低限：

### Main regenerated baseline

- 全採用ContentがWorld生成前にLoad済み
- Main三次元で代表Structure生成
- Resource三次元でBS非生成
- Portal Family維持
- Spawn安全性
- Main Resource Pack配信
- 現行Baseline Backup
- CoreProtect導入後のBlock Audit

### Frontier shared foundation

- MVI三Group
- MVI Profile切替
- 全Item分離
- WM共有
- mcMMO共有
- Resource Pack切替
- Gate安全到着
- Portal Family
- Return route
- Restart／Reconnect

### Ruined Frontier

- BS三次元
- EM三次元
- Guild
- Primis
- Shrines
- Dungeoneering
- Boss ID
- Loot漏出防止
- EM Adapter判断
- Instance Inventory
- Resource Pack
- CoreProtect

### Worlds Beyond

- Iris三次元
- PEACEFUL
- Traversal Loadout
- LeafGrapple
- Elytra
- Launchpad
- WM Shop
- Waystone
- Discovery GUI
- Teleport GUI
- MVI分離
- Persistence
- Resource Pack
- Safe Return

未実装項目を完了扱いにしない。

---

## 11. `docs/10-waymark-economy.md`

次を追加する。

- WMはMain／Frontier共有。
- Item移送の代替となる主要な成果還元経路。
- Main／Frontier間のItem、Inventory、Armor、Offhand、Ender Chest、Vanilla XP等を共有しない。
- mcMMOはEconomy報酬ではなく別枠のNetwork共有Progression。
- Worlds Beyondの初期WM用途。
- Ruined FrontierのBoss／Quest WM Rewardは後続Balance Lock。
- Theme装備のWM売却変換は初期仕様に含めない。
- 将来の実績報酬はItem非依存を初期原則とする。
- RedisEconomy内部Dataを直接編集しない。
- Custom PluginはVault API／正式Adapter経由。

現在のMain価格体系を変更しない。

---

## 12. `docs/12-permission-model.md`

現在実装済みPermissionを変更したように記載しない。

将来のFrontier Permission Boundaryとして追加する。

- MVI管理はAdmin限定。
- ResourcePackManager管理はAdmin限定。
- Wayfarer_Core／Frontier管理はAdmin限定。
- EM Teleport ShortcutはGeneral Playerへ明示拒否候補。
- Multiverse TeleportをGeneral Playerへ付与しない。
- BuilderへMVI Group管理、Resource Pack管理、EliteMobs内部管理、Database、Economy、Custom Plugin Adminを付与しない。
- Gate通過Permissionは採用Gate方式でLockする。
- Builder Phase 1Bは両Theme、Gate方式、Portal方式、Plugin Permissionが固定された後。
- Wildcard禁止。
- OP非依存。

正確なPermission Nodeは採用Version確認前に断定しない。

---

## 13. `docs/13-main-world-baseline.md`

現在のMain World Baselineが、再生成タスク完了までは現行正本であることを維持する。

追加する計画上の注記：

- Ver.0.0.6で新しいMain BetterStructures構成と再生成計画が承認された。
- 現行Baselineはまだ置換されていない。
- 新Baselineの生成・検証・Backup完了後に本書を更新する。
- 現時点で既存Worldを削除、Trim、再生成、Renameしない。
- 再生成は独立した破壊的Task。
- Resource Familyを再生成対象に含めない。

既存Seed、Spawn、Backup Hash等を削除しない。

---

## 14. Root `README.md`

次を反映する。

- 正式設計Revision `Ver.0.0.6`
- V0.1.0は未完成
- Main再生成計画
- Frontier両Theme
- Wayfarer_Core／Frontier
- MVI
- Main／Frontier全Item分離
- ResourcePackManager
- 新しい`docs/14-frontier-v0.1.0-scope.md`へのLink
- Conceptは非正本の詳細設計入力

READMEを長大な仕様書にしない。

---

## 15. `codex/README.md`

本指示書をArchiveへ登録する。

保存Path：

```text
codex/Project_Wayfarer_Ver0.0.6_Formal_Scope_and_Roadmap_Update.md
```

作業中：

```text
実施中
```

完了後：

```text
完了（実装Commit: <SHA>）
```

現行正本：

```text
AGENTS.md
docs/00-design-guide.md
docs/01-architecture.md
docs/09-roadmap.md
docs/14-frontier-v0.1.0-scope.md
```

再実行：

```text
そのままの再実行禁止。実装進行後は現行Runtimeと正本文書で再評価
```

Commit SHAの自己参照を避けるため、必要なら実装Commitと記録Commitを分ける。

---

## 16. 変更しないもの

- `concepts/`内の全Concept本文
- `concepts/`配下READMEの細かなVersion Index
- `versions.yml`
- `plugin-manifest.yml`
- Runtime Config
- Plugin JAR
- Content Pack
- Resource Pack Binary
- World
- Region File
- Player Data
- Database
- Redis Data
- Permission Runtime
- Current Main Seed
- Current Main Spawn
- Current Main Backup
- Current Main World UUID
- Current Economy価格
- Current EvenMoreFish Config
- Current mcMMO Config
- Current CoreProtect未導入状態
- Custom Plugin Repository
- Custom Plugin Source
- GitHub Repository作成
- GitHub Release
- Tag

未導入Pluginを`versions.yml`や`plugin-manifest.yml`へ「導入済み」として登録しない。

---

## 17. 文書整合性

以下の表現をRepository全体で確認する。

旧表現：

```text
CoreProtect is the next implementation task
Phase 2B is only Nether／End supplementation
Do not regenerate Main persistent worlds for Phase 2B
one playable Frontier theme
theme inventory deferred
Wayfarer custom plugins are V0.2.x-only
Main and Frontier may transfer items
```

現在方針へ更新する。

ただし、過去の決定や履歴を説明する文脈では旧表現を削除しない。現在形のProject InvariantとRoadmapだけを置換する。

---

## 18. 検証

### 18.1 文書検索

```powershell
git grep -n "Ver\.0\.0\.5"
git grep -n "one playable Frontier"
git grep -n "one user-approved playable Frontier"
git grep -n "Theme-specific inventories.*deferred"
git grep -n "never regenerate"
git grep -n "CoreProtect.*next"
git grep -n "ResourcePackManager"
git grep -n "Multiverse-Inventories"
git grep -n "Wayfarer_Core"
git grep -n "Wayfarer_Frontier"
git grep -n "Ruined Frontier"
git grep -n "Worlds Beyond"
```

検索結果を確認し、現在仕様との矛盾が残っていないこと。

### 18.2 Layout／Diff

```powershell
git diff --check
.\scripts\Test-Layout.ps1
git status --short
git diff --stat
```

Repositoryに既存Markdown Link Checkがあれば実行する。外部Toolを新規Installしない。

### 18.3 手動確認

- Concept本文を変更していない。
- Current Runtimeを実装済みと誤記していない。
- Main現行BaselineをSuperseded扱いしていない。
- RuinedとBeyondの両方がV0.1.0 Blocker。
- MVIがInventory正本。
- Wayfarer Pluginが通常Inventoryを再実装しない。
- 全Item移送禁止。
- WM／mcMMO／Item非依存実績だけがNetwork共有候補。
- ResourcePackManagerのLock項目がある。
- Main Content LoadがWorld再生成より前。
- CoreProtectが新Main Baseline後。
- Custom Plugin Sourceは別Repository。
- Conceptが非正本。
- `versions.yml`／`plugin-manifest.yml`未変更。
- 未実装項目をAcceptance済みとしていない。

---

## 19. Commit／Push

すべての検証に合格した場合、Commitする。

推奨Commit Message：

```text
docs: Ver.0.0.6の正式ScopeとRoadmapを更新
```

Push前：

```powershell
git status --short
git branch --show-current
git remote -v
```

Configured Upstreamへ通常Pushする。

禁止：

- Force Push
- Amend
- Tag
- GitHub Release
- 新Branch
- PR作成
- Repository作成

Codex Archiveへ実装Commit SHAを記録する追補Commitが必要な場合：

```text
docs: Ver.0.0.6更新Commitを記録
```

として通常Pushする。

---

## 20. 完了条件

- 正式設計Revisionが`Ver.0.0.6`。
- `docs/14-frontier-v0.1.0-scope.md`が存在。
- Main BetterStructures 5 Pack構成が正式Scope。
- Content Import後にMain Persistent Familyを再生成する順序が正式化。
- 現行Main Baselineは実装完了まで維持。
- CoreProtectが新Main Baseline後。
- Ruined FrontierとWorlds Beyondの両方がV0.1.0 Blocker。
- 両Themeの初期構成が正本文書へ要約されている。
- Wayfarer_Core／FrontierがV0.1.0 Blocker。
- Custom Plugin Sourceは別Repository。
- MVIがFrontier Player Stateの正本。
- Wayfarer Pluginは通常Inventoryを再実装しない。
- Main／Frontier間の全Item移送禁止が明文化。
- WM、mcMMO、Item非依存実績だけが共有成果候補。
- ResourcePackManager Lock項目がRoadmapにある。
- EMアダプタ必要性判断がRoadmapにある。
- Concept本文未変更。
- Runtime未変更。
- Manifest未変更。
- Acceptanceを虚偽に完了扱いしていない。
- `git diff --check`成功。
- `Test-Layout.ps1`成功。
- Commit／Push成功。
- 最終Working TreeがClean。

---

## 21. 完了報告

以下を報告する。

1. 実装Commit SHA／Message
2. 記録Commit SHA／Message
3. Branch／Remote
4. 作成File
5. 更新File
6. Ver.0.0.6へ変更した箇所
7. Roadmapの新しい主要順序
8. V0.1.0 Frontier Blocker
9. Main再生成方針
10. MVI／全Item分離／ResourcePackManagerの反映内容
11. 実行した検証
12. Concept本文未変更
13. Runtime／Manifest未変更
14. 最終`git status --short`
15. 残る実装前Lock項目

完了報告で、Main再生成、Plugin導入、Custom Plugin開発、Ruined Frontier、Worlds Beyond、MVI、ResourcePackManager等を「導入済み」「実装済み」と表現しない。
