# Project Wayfarer Main第四Pack自然生成受入完了 指示書

## 1. 推奨Sol

```text
medium
```

理由：

- Persistent Main Familyの再生成、削除、Trim、Seed変更またはConfig変更は行わない。
- 現在のRuntime Candidate上で、未生成Chunkを限定的に探索し、既にLoad確認済みのExploration PackまたはAdventure Packから自然生成を1件確認するTaskである。
- World Dataへの追加は新規Chunk／Region生成だけであり、対象と停止条件が明確である。
- 実行結果はOrder 5の残件を閉じるための受入証拠と文書更新に限定される。

次の場合は`high`へEscalateし、実行を停止する。

- World削除、再生成、Trim、Region削除、Seed／UUID変更が必要になる。
- BetterStructuresのWeight、選定Structure、Pack、GeneratorまたはConfig変更が必要になる。
- Resource Familyに新規ChunkまたはRegion生成が発生する。
- 現Runtime CandidateのRollback、差替えまたは旧Baseline復元が必要になる。
- 探索範囲を本指示書の上限を超えて拡大する必要がある。
- 自然生成と手動Paste／既存Structureの区別がつかない。
- Plugin Error、Schematic Error、Model ErrorまたはWorld破損を検出する。

---

## 2. 目的

Project Wayfarer Ver.0.0.6 Roadmap Order 5に残っている、次の一点だけを完了する。

```text
自然生成を確認した異なるBetterStructures Packを、
現在の3 Packから4 Packへ増やす。
```

現在、自然生成確認済み：

```text
Default
Caves and Lost Civilizations Free
Echoes of the Past
```

Load確認済みだが自然生成未確認：

```text
Exploration Pack
Adventure Pack
```

本Taskでは、**Exploration PackまたはAdventure Packのどちらか一方から、選定済みStructureが自然生成したことを1件確認**すれば成功とする。

成功後：

```text
Order 4: complete
Order 5: complete
Order 6: incomplete
Order 7: incomplete
```

とする。

本TaskはFinal V0.1.0 Main Baselineを確定しない。Weight／Content tuning、最終BackupおよびBaseline宣言はOrder 6で行う。

---

## 3. Repository

```text
eariver/Project_Wayfarer
```

作業対象は、VS Codeで開かれているProject Wayfarer Repository Root内だけとする。

開始時：

```powershell
git status --short
git branch --show-current
git remote -v
git log -7 --oneline
```

最低限、次を含むこと。

```text
ef67957414caa958d1552b731325a0c36f9cd182
feat: Main Persistent Family置換候補を生成

ed5fe4de4940986943bce885adaca1ba09010880
docs: Main置換生成Commitを記録
```

意図不明な未Commit変更がある場合は停止する。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- Amend
- World／Backup／Log／ArtifactのCommit
- 完了済み置換生成Taskの再実行

---

## 4. 正本

最低限、次を読む。

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/13-main-world-baseline.md
docs/investigations/2026-07-25-main-betterstructures-content-preflight.md
docs/investigations/2026-07-25-main-v006-replacement-generation.md
versions.yml
plugin-manifest.yml
config/main-betterstructures/selection.yml
servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
```

歴史的指示書は現行正本より優先しない。

```text
codex/Project_Wayfarer_Main_Persistent_Family_Replacement_Generation_and_Acceptance.md
```

---

## 5. 現行Runtime Candidate

### 5.1 Persistent Main Family

```text
Seed:
164225356311935743
```

| Dimension | Bukkit World | UUID | 現行Region数 |
|---|---|---|---:|
| Overworld | `main` | `d868e7ff-6663-492d-a963-f95f00ce6c30` | 11 |
| Nether | `main_nether` | `1225688f-7770-43ed-b1dd-71bd112de3b5` | 11 |
| End | `main_the_end` | `436843c4-2229-4c67-907c-b3a7d1530d71` | 18 |

Spawn：

```text
main:
  (320, 70, 128)

main_nether:
  (20.5, 60, -19.5)

main_the_end:
  (100.5, 49, 0.5)
```

### 5.2 Resource Family

```text
resource
resource_nether
resource_end
```

現行Region数：

```text
8 / 4 / 4
```

Resource Familyでは本Task中に移動、探索、Chunk生成またはRegion生成を行わない。

### 5.3 BetterStructures

```text
BetterStructures 2.6.3
WorldEdit 7.4.4
FreeMinecraftModels 2.10.2
ResourcePackManager 2.3.0
```

```text
Source Config: 430
Enabled: 278
Disabled: 152
```

5 Pack：

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack internal version 1
Echoes of the Past version 3
```

本Taskでは選定、Weight、Prop Mapping、Entity RemovalまたはPack構成を変更しない。

---

## 6. 対象Packの優先順位

### 第一対象

```text
Exploration Pack
```

理由：

- Main Overworldで20 Structureが選定されている。
- Weight 1.0のBridge Cave／Water House系を含む。
- Adventure Packより選定数と高Weight候補が多く、限定探索で確認できる可能性が高い。

### 第二対象

```text
Adventure Pack
```

Exploration Packが先に見つからなくても、Adventure Packの選定済みStructureが自然生成した場合は成功とする。

第四Packの要件は「特定Packの指定」ではなく、既確認3 Pack以外から1 Packを追加確認することである。

---

## 7. 有効な対象Structure

`config/main-betterstructures/selection.yml`を正本とする。

### 7.1 Exploration Pack — Overworld主要候補

Weight 1.0：

```text
betterstructures_exploration_bridgecave_deep
betterstructures_exploration_bridgecave_dripstone
betterstructures_exploration_bridgecave_lush
betterstructures_exploration_bridgecave_shallow

betterstructures_exploration_waterhouse_barren
betterstructures_exploration_waterhouse_desert
betterstructures_exploration_waterhouse_grassland
betterstructures_exploration_waterhouse_tundra
```

その他：

```text
betterstructures_exploration_tower_*                weight 0.4
betterstructures_exploration_temple_*               weight 0.3
betterstructures_exploration_floatingfortress_*     weight 0.15
```

### 7.2 Adventure Pack — Overworld主要候補

```text
betterstructures_adventure_ship_*          weight 0.6
betterstructures_adventure_church_*        weight 0.35
betterstructures_adventure_portalroom_*    weight 0.3
betterstructures_adventure_cloudisland_*   weight 0.15
```

`*`をRuntime Commandへそのまま渡さない。実際の選定IDをManifestから展開してExact Matchで扱う。

---

## 8. 本Taskで変更してはならないもの

- `main`、`main_nether`、`main_the_end`の削除、再生成、Rename、Trim
- Seed
- UUID
- Spawn
- Vanilla Player Data Policy
- BetterStructures `distance*`
- Structure Weight
- Structure Enable／Disable
- Pack Import
- Prop Mapping
- Entity Removal
- Block Entity Removal
- FMM Models
- Resource Pack構成
- ResourcePackManager Hosting方式
- `spawnProtectionRadius: 100`
- `spawn-protection=16`
- Multiverse Link
- Portal
- World Border
- CoreProtect
- Hub／Gate
- Permission
- MariaDB
- Redis
- Resource Family

禁止手段：

- BetterStructures Pregeneration
- Chunk Pregenerator
- 手動Schematic Paste
- Structure Copy
- `/locate`結果だけを自然生成証拠とすること
- 既存Structureを別Packのものとして扱うこと
- Structureを探すためのWorld Border変更
- Resource Worldでの探索
- Region削除による再抽選

---

## 9. Preflight

### 9.1 Runtime状態

確認：

- Main／Lobby／Frontier／Velocity状態
- Player数
- Java Process
- Port
- Git状態
- Disk空き容量
- Main Seed／UUID
- Persistent Region数
- Resource Region数
- BetterStructures World Allowlist
- BetterStructures `warnAdminsAboutNewBuildings`
- Content Pack認識
- FMM Models
- Resource Pack状態

現行Configでは、次を維持する。

```yaml
warnAdminsAboutNewBuildings: true
setupDone: true
protectEliteMobsRegions: false
```

### 9.2 現行Log調査

新規探索前に、現Runtime Candidate生成開始以降のIgnored Runtime Logを検索する。

Exact ID Prefix：

```text
betterstructures_exploration_
betterstructures_adventure_
```

確認対象：

- 実際の自然生成／配置を示すLog
- Admin通知
- Structure ID
- World
- Chunk／座標
- Timestamp

次は証拠にしない。

- Content登録
- Config読込
- Schematic Load
- Import
- Enable一覧
- Command Help
- 手動Paste
- Preflight Test World
- 旧2026-07-21 WorldのLog
- Resource WorldのLog

現Runtime Candidate上で既に自然生成済みのExploration／Adventure Structureが、LogとWorld座標の両方で一意に確認できる場合、新規Region生成を行わず、そのStructureを実地確認して成功としてよい。

---

## 10. 非破壊Command調査

BetterStructuresのRuntime Helpまたは公式Bundled Helpから、次に相当する既存Commandがあるか確認する。

- 自然生成済みStructure一覧
- Structure履歴
- Structure IDと座標
- Nearest／Locate
- Admin通知履歴

存在する場合：

- Command名とPermissionをRuntime Helpで確認する。
- Read-onlyまたは検索専用であることを確認する。
- 存在しないCommandを推測しない。
- Generate、Paste、Pregenerate、Import、ReloadまたはDeleteを含むCommandを使用しない。
- 検索結果だけではなく、実World上の自然生成物を確認する。

Project文書に未記載の管理Commandへ恒久Permissionを追加しない。Temporary Adminで実施する。

---

## 11. 探索戦略

### 11.1 Dimension

本Taskの受入探索は原則として次だけで行う。

```text
main
```

`main_nether`と`main_the_end`は、前Taskで十分にRegionを生成しており、本Taskでは追加探索しない。

Exploration／AdventureのOverworld候補を優先する。

### 11.2 探索開始点

現行の生成済みRegion範囲をRead-onlyで解析し、既生成Chunkの外周を求める。

次の順序を優先する。

1. 現行Region内の未生成Chunk
2. 現行Regionに隣接する新Region
3. それでも必要な場合だけ、外側の新Region

既生成Chunkを横断するだけの移動を繰り返さない。

現在のRegion File名とChunk使用状況から、最短で新規Chunkへ到達する安全な探索経路を決定する。

### 11.3 移動

- Temporary Adminで実施する。
- Spectatorまたは承認済み安全なCreative移動を使用してよい。
- Survivalで危険探索を強制しない。
- Teleportは安全なY座標とChunk Load範囲を確認する。
- Void、岩盤内、Lava内または未確認Block内へTeleportしない。
- Admin通知とServer Logを監視する。
- 対象Structure通知を確認した時点で、追加移動を止める。

探索終了後、PlayerをMain Spawnへ戻し、Survivalへ戻し、Temporary Adminを削除する。

---

## 12. 探索上限

### Stage A

```text
対象:
main Overworldのみ

追加新規Region:
最大8

探索時間:
最大30分

早期終了:
ExplorationまたはAdventureの自然生成を1件確認した時点
```

### Stage B

Stage Aで見つからない場合、停止せず次へ進んでよい。

```text
Stage Aからの累計追加新規Region:
最大16

Stage Aからの累計探索時間:
最大60分

対象:
main Overworldのみ

早期終了:
ExplorationまたはAdventureの自然生成を1件確認した時点
```

### 絶対上限

本Task開始時点から：

```text
Overworld追加Region:
最大16

Nether追加Region:
0

End追加Region:
0

Resource追加Region:
0

探索時間:
最大60分
```

上限はCodexの作業停止基準であり、World Border、BetterStructures設定または通常ゲームプレイ制限として実装しない。

上限到達時に対象Packが見つからない場合：

1. 探索を停止する。
2. Order 5を未完了のまま維持する。
3. 生成したRegion数、探索方向、確認済み通知、候補Structureおよび未確認理由を報告する。
4. 上限拡大、Weight変更、Region削除または再生成を行わない。
5. ユーザーへ次の判断を求める。

---

## 13. 自然生成の証拠

成功には次をすべて必要とする。

- PackがExplorationまたはAdventureである。
- IDが`selection.yml`でEnabledである。
- Bukkit Worldが`main`である。
- 手動Pasteではない。
- Pregenerationではない。
- 新規Chunkの通常生成に伴う配置、または現Runtime Candidate上で以前に通常生成された配置である。
- Exact Structure ID
- 座標
- Chunk座標
- Region File
- Log／Admin通知
- 実World上の外観確認
- 代表Block／Container／Prop等の存在確認
- Restart後も存在すること

可能ならScreenshotをIgnoredなEvidence Directoryへ保存してよい。ScreenshotをGitへCommitしない。文書には秘密情報やPlayer個人情報を含めない。

---

## 14. Structure受入確認

対象Structureで最低限確認する。

- 著しい欠損がない
- 地形へ異常に埋没していない
- 空中Structureが不自然に切断されていない
- Containerが存在する場合はBlockとして正常
- Spawnerが存在する場合はBlockとして正常
- FMM Propが存在する場合は表示
- Missing Textureなし
- 未解決Model IDなし
- 大量Entityなし
- 保存Item／Projectile異常なし
- 起動阻害Errorなし
- Structure ID重複なし
- WorldEdit Schematic Parse Errorなし

Loot全内容、全Container、全Mob、全VariantまたはBalanceを試験しない。

明らかな配置不良または重大な問題がある場合：

- Structureを勝手にDisableしない。
- Weightを変更しない。
- Regionを削除しない。
- Exact ID、座標、状況を記録し、Order 6の調整候補として報告する。

---

## 15. Resource Family保護

探索前後に確認する。

```text
resource:
  Region 8

resource_nether:
  Region 4

resource_end:
  Region 4
```

最低限：

- Region File数不変
- 全`region/*.mca` SHA-256不変
- BetterStructures無効
- ResourceへPlayer移動なし
- ResourceへChunk Loadを意図的に発生させていない
- Persistent／Resource Portal Link不変

Resource Region Hashが一つでも変化した場合、Taskを失敗として停止する。通常Saveと推測しない。

---

## 16. Restart確認

対象Structure確認後：

1. PlayerをMain Spawnへ戻す。
2. Temporary Adminを削除する。
3. Playerを切断する。
4. Velocityを正常停止する。
5. 約10秒待つ。
6. Paperで`save-all flush`相当を実施する。
7. Main／Lobby／Frontierを正常停止する。
8. Java ProcessとPort終了を確認する。
9. Main／Lobby／Frontierを起動する。
10. Velocityを起動する。
11. Temporary AdminでMainへ接続する。
12. 対象Structureが残っていることを確認する。
13. Propがある場合は表示を確認する。
14. Startup Logを確認する。
15. Main Spawnへ戻し、Survival、Temporary Admin削除、切断を行う。

Network全体の広範Regressionは行わない。

---

## 17. 成功条件

- ExplorationまたはAdventureの自然生成を1件確認
- Enabled Structure ID
- `main`上の通常Chunk生成
- Exact座標／Chunk／Region／Log証拠
- 実World確認
- Restart後も存在
- Schematic／Model／Duplicate Errorなし
- Resource Family Region Hash不変
- Nether／End追加Region 0
- Overworld追加Region16以内
- 探索時間60分以内
- Weight／Config／Pack変更なし
- World再生成／Trim／Paste／Pregenerationなし
- Player／Temporary Admin Cleanup
- Order 5完了
- Order 6未完了
- Final V0.1.0 Baseline未宣言

---

## 18. 失敗／停止条件

- 上限内で対象Packが見つからない
- 自然生成か手動配置か判定不能
- Structure IDがDisabled
- Resource Region差分
- Seed／UUID変化
- BetterStructures Error
- Schematic Parse Error
- FMM Model Error
- 大量Entity
- 不明なPortal
- Player Cleanup不能
- Runtime正常停止不能
- GitへWorld／Log／ArtifactがStageされている

失敗時もRuntime Candidateを再生成、削除またはRollbackしない。発生した新規Regionをそのまま記録し、次の判断を待つ。

---

## 19. Repository更新

成功時、実態に合わせて最低限更新する。

```text
AGENTS.md
README.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/13-main-world-baseline.md
docs/investigations/2026-07-25-main-v006-replacement-generation.md
versions.yml
plugin-manifest.yml
codex/README.md
```

既存Investigationへ追記するか、次を新規作成してよい。

```text
docs/investigations/<date>-main-fourth-pack-natural-generation.md
```

本指示書を保存する。

```text
codex/Project_Wayfarer_Main_Fourth_Pack_Natural_Generation_Acceptance.md
```

### 19.1 Roadmap

成功時：

```text
Order 4:
complete

Order 5:
complete

Order 6:
incomplete

Order 7:
incomplete
```

### 19.2 Baseline表現

成功後も次を維持する。

```text
Current Runtime Candidate:
2026-07-25 Main Persistent Family

Last Finalized Rollback Baseline:
2026-07-21 Main Persistent Family

Final V0.1.0 Main Baseline:
未確定
```

Order 5完了だけを理由にFinal Baselineへ昇格しない。

### 19.3 記録内容

- 実施日
- Pre-execution Git HEAD
- Target Pack
- Exact Structure ID
- World
- XYZ
- Chunk
- Region
- Log evidence
- Region Count before／after
- Exploration time
- Restart result
- Resource Hash result
- Pack acceptance total
- Order 5 completion
- Order 6 remaining work

---

## 20. Git非追跡

Commit禁止：

- World
- Region
- Entity／POI
- Player Data
- Log
- Screenshot
- Backup
- Plugin JAR
- Content ZIP
- Schematic
- Model
- Generated Pack
- Hosting Data
- Secret
- Database Data
- Redis Data

確認：

```powershell
git status --short
git check-ignore -v <representative-world-path>
git check-ignore -v <representative-log-path>
git diff --cached --name-status
```

---

## 21. 検証

```powershell
git diff --check
.\scripts\Test-Layout.ps1
```

YAMLをRepository既存手段でParseする。

確認：

- `versions.yml`
- `plugin-manifest.yml`
- `selection.yml`
- BetterStructures Config
- ValidWorlds

新しい探索補助Scriptを作る場合：

- Read-only Region解析
- Repository Root境界
- Exact Path
- Persistent Main Allowlist
- Resource拒否
- Delete／Writeなし
- Non-zero Exit
- Region Count Report
- Structure ID Exact Match

を満たす。

World lifecycle、Region削除、Teleport自動実行またはCommand送信Scriptを新規作成しない。

---

## 22. Commit／Push

成功時の推奨Commit Message：

```text
docs: Main第四Pack自然生成受入を完了
```

探索補助Scriptも追加した場合：

```text
test: Main第四Packの自然生成を確認
```

Codex ArchiveへのSHA記録用追補Commit：

```text
docs: Main第四Pack受入Commitを記録
```

失敗時、有用なInvestigationだけをCommitする場合：

```text
docs: Main第四Pack探索結果を記録
```

ただし、ユーザーへCommit可否を確認してから行う。

禁止：

- Force Push
- Amend
- Tag
- GitHub Release
- Branch作成
- PR作成

---

## 23. Codex Archive

`codex/README.md`へ登録する。

作業中：

```text
実施中
```

成功：

```text
完了（実装Commit: <SHA>）
```

上限到達：

```text
停止（第四Pack自然生成未確認）
```

再実行：

```text
完了後はそのまま再実行禁止。
未完了の場合も、追加探索上限はユーザー判断を得た新Taskで再設定する。
```

---

## 24. 完了報告

以下を報告する。

1. 実装Commit SHA／Message
2. 記録Commit SHA／Message
3. Branch／Remote
4. 対象Pack
5. Structure ID
6. World／XYZ
7. Chunk／Region
8. 自然生成証拠
9. 外観／Prop／Container等の確認
10. 探索時間
11. Region数Before／After
12. Nether／End追加Region 0
13. Resource Region Hash
14. Restart結果
15. Runtime Error
16. Player／Temporary Admin Cleanup
17. Order 5状態
18. Order 6残件
19. 更新File
20. 実行した検証
21. Git非追跡確認
22. 最終`git status --short`

Order 6、Final V0.1.0 Main Baseline、CoreProtect、Hub／GateまたはFrontierを完了扱いにしない。
