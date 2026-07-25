# Project Wayfarer Main Order 6 調整・候補確定・最終Baseline Backup 指示書

## 1. 推奨Sol

```text
high
```

理由：

- Project Wayfarer Ver.0.0.6 Roadmap Order 6を完了し、現在のMain Runtime Candidateを正式なMain Baselineへ昇格させるTaskである。
- BetterStructuresのWeight／Content判断、Runtime Config、生成済みWorldとの整合、Resource Family保護、停止状態の完全Backup、Manifest／SHA-256、Rollbackおよび正本文書を横断する。
- World再生成は含まないが、誤った調整または不完全BackupのままBaselineを宣言すると、後続のCoreProtect、Hub／Gate構築およびFrontier統合の基準を破壊する。
- 調整が必要な場合でも、既生成Chunkには変更が遡及しないため、その影響を明示してユーザー判断を受ける必要がある。
- Order 6完了後は、このMainを前提に後続作業が進むため、単なる文書更新より高い確実性が必要である。

次の場合は推測せず停止する。

- World削除、Region削除、Trim、再生成、Seed変更またはUUID変更が必要になる。
- BetterStructuresのPlugin、Content Pack、FMM、ResourcePackManagerまたはWorldEditのArtifact差替えが必要になる。
- 承認されていないStructure Enable／Disable、Weight、距離、AltitudeまたはWorld Allowlist変更が必要になる。
- 既に自然生成受入へ使用したStructureまたはPackを無効化し、Order 5の証拠が成立しなくなる。
- Resource FamilyのRegion File数またはSHA-256が変化する。
- 停止状態の完全Backupを作成・検証できない。
- Main Container、Backup先、Git RootまたはConfig Pathを一意に解決できない。
- Disk空き容量が安全Marginを含めて不足する。
- Runtime Candidateを採用できない品質上の問題を検出する。
- MariaDB、Redis、Waymark、mcMMO、LuckPermsまたはEvenMoreFish Dataの変更が必要になる。
- Final Baseline宣言前にServerへ第三者Playerが接続する。

`high`より上のSolへ変更する条件はない。上記条件では作業を拡張せず、新しいTaskとユーザー承認を要求する。

---

## 2. 目的

Project Wayfarer Ver.0.0.6 Roadmapの次を完了する。

```text
Order 6:
Main Weight／Content tuning and new baseline
```

実施内容：

1. 現在のMain Runtime Candidateと、Order 4／5で得られた自然生成・配置・Performance証拠を監査する。
2. BetterStructuresのWeight／Contentについて、現状採用、厳密なConfig-only調整、候補棄却のいずれかをユーザーへ提示する。
3. ユーザーが承認した判断だけを実行する。
4. Main／Resource Family、Seed、UUID、Spawn、Portal、PackおよびPlugin Loadを再確認する。
5. 停止状態の完全なMain Baseline Backupを作成し、全PayloadをSHA-256で検証する。
6. 現在のRuntime CandidateをFinal Main Baselineとして正本文書へ昇格させる。
7. Roadmap Order 6を完了し、Order 7 CoreProtectへ引き渡す。

本Task完了後：

```text
Order 4: complete
Order 5: complete
Order 6: complete
Order 7: incomplete
```

とする。

---

## 3. 本Taskに含めないもの

- Main Persistent Familyの再生成
- World／Regionの削除、Trim、Clone、RenameまたはSeed変更
- 新規Chunkを利用した追加の自然生成探索
- BetterStructures Pregeneration
- Chunk Pregenerator
- 手動Schematic Paste
- Plugin／Content／Model／Pack Artifactの更新またはDownload
- CoreProtect導入
- Main Spawn WorldGuard Region
- Hub／Gate構築
- Portal Routing完成
- Resource Reset Bootstrap
- Frontier構築
- MVI
- Wayfarer_Core／Wayfarer_Frontier
- Builder Phase 1B
- Waymark／mcMMO／LuckPerms／EvenMoreFish Data Reset
- MariaDB Dump、Redis AOF、全Networkを含むV0.1.0 Cold Backup
- Isolated Restore Test
- V0.1.0 Release宣言
- V0.1.0 Pre-release Player State Reset
- Roadmap Order 25のV0.1.0 Baseline

本Taskで確定するのは**Main World／ContentのFinal Main Baseline**であり、Network全体のRelease Baselineではない。

---

## 4. Repository

```text
eariver/Project_Wayfarer
```

作業対象は、VS Codeで開かれているProject Wayfarer Repository Root内だけとする。

開始時：

```powershell
git status --short
git branch --show-current
git remote -v
git log -10 --oneline
git rev-parse HEAD
```

最低限、次を含むこと。

```text
bb782bc57d44ba38b448d3087eeb03132e56d5d8
docs: Main第四Pack自然生成受入を完了

b2eb75a4ee4839e09b8fa4d76270c59b1e8f9f8c
docs: Main第四Pack受入Commitを記録
```

開始時HEADは原則として次である。

```text
b2eb75a4ee4839e09b8fa4d76270c59b1e8f9f8c
```

異なる場合は、差分と理由を確認し、現行正本が本指示書より新しいか判断する。意図不明な変更、未Push CommitまたはUntracked Artifactがある場合は停止する。

禁止：

- `git reset --hard`
- `git clean`
- Amend
- Rebase
- Force Push
- Tag
- GitHub Release
- Branch作成
- PR作成
- World／Backup／Log／JAR／Content／Generated PackのCommit

---

## 5. 正本

最低限、次を読む。

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/02-installation.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/13-main-world-baseline.md
docs/investigations/2026-07-25-main-betterstructures-content-preflight.md
docs/investigations/2026-07-25-main-v006-replacement-generation.md
docs/investigations/2026-07-25-main-fourth-pack-natural-generation.md
config/main-betterstructures/selection.yml
config/main-betterstructures/prop-id-mapping.yml
config/main-betterstructures/entity-removals.yml
config/main-betterstructures/block-entity-removals.yml
servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
servers/main/plugins/FreeMinecraftModels/config.yml
servers/main/plugins/ResourcePackManager/config.yml
servers/main/plugins/Multiverse-Core/worlds.yml
servers/main/plugins/Multiverse-NetherPortals/config.yml
versions.yml
plugin-manifest.yml
codex/README.md
```

参照可能な完了済みTask：

```text
codex/Project_Wayfarer_Main_BetterStructures_Preflight_and_Content_Integration.md
codex/Project_Wayfarer_Main_Persistent_Family_Replacement_Generation_and_Acceptance.md
codex/Project_Wayfarer_Main_Fourth_Pack_Natural_Generation_Acceptance.md
```

完了済みTaskをそのまま再実行しない。

---

## 6. 現行Baseline候補

### 6.1 Runtime

```text
Paper:
  26.2 build 62

Java:
  Oracle Java 25.0.3 LTS

Seed:
  164225356311935743
```

### 6.2 Persistent Main Family

| Dimension | Bukkit World | UUID | Region数 |
|---|---|---|---:|
| Overworld | `main` | `d868e7ff-6663-492d-a963-f95f00ce6c30` | 17 |
| Nether | `main_nether` | `1225688f-7770-43ed-b1dd-71bd112de3b5` | 11 |
| End | `main_the_end` | `436843c4-2229-4c67-907c-b3a7d1530d71` | 18 |

Storage：

```text
servers/main/main/dimensions/minecraft/overworld
servers/main/main/dimensions/minecraft/the_nether
servers/main/main/dimensions/minecraft/the_end
```

Spawn：

```text
main:
  (320, 70, 128)

main_nether:
  (20.5, 60, -19.5)

main_the_end:
  (100.5, 49, 0.5)
```

### 6.3 Resource Family

| World | Region数 |
|---|---:|
| `resource` | 8 |
| `resource_nether` | 4 |
| `resource_end` | 4 |

Resource FamilyではBetterStructuresを無効のまま維持する。

### 6.4 BetterStructures Working Set

```text
BetterStructures 2.6.3
WorldEdit 7.4.4
FreeMinecraftModels 2.10.2
ResourcePackManager 2.3.0
```

```text
Source Structure Config:
  430

Enabled:
  278

Disabled:
  152

Design Dimension Count:
  191 / 44 / 43

Runtime Generator Dimension Count:
  188 / 47 / 43
```

5 Pack：

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack internal version 1
Echoes of the Past version 3
```

自然生成受入済みPack：

```text
Default
Caves and Lost Civilizations Free
Echoes of the Past
Exploration Pack
```

代表受入Structure：

```text
betterstructures_mine_storage_deep
bs_lostcivilizations_free_circledungeon_dripstone
betterstructures_echoes_wall_nether
betterstructures_echoes_shrine_end
betterstructures_exploration_bridgecave_shallow
```

---

## 7. 既存Backup

### 7.1 Current Runtime Candidate Rollback Source

```text
backups/main-v006-replacement-generation-20260725-154934/
```

Manifest SHA-256：

```text
C79C2FC3ECBA998D875200E1D29B1B82B9BE97808B965E28D74B60108F62B118
```

これは置換前Main ContainerのRollback Sourceであり、現在の`17 / 11 / 18`候補Worldの最終Backupではない。

### 7.2 Legacy Finalized Baseline

```text
backups/main-final-generation-20260721-001501/
```

Manifest SHA-256：

```text
50B0F6244223DA68B752407BBE89127E0CE49645F7673A5FF929EE9C5B8A3C9D
```

Order 6完了後も削除しない。

---

## 8. 基本原則

### 8.1 Sampleの限界

Order 4／5で生成された範囲は受入用の限定Sampleである。

```text
Persistent Region:
  17 / 11 / 18
```

このSampleだけから、低Weight Structureが見つからなかったことを理由にWeightを上げてはならない。

同様に、特定Packの通知が複数出たことだけで、そのPack全体を過密と断定してはならない。

### 8.2 調整の根拠

Config変更を提案できるのは、次のような具体的証拠がある場合だけである。

- 明白なStructure過密
- 同一系統の不自然な近接反復
- 地形との重大なPlacement不良
- 大量Entity
- Missing Model
- Schematic Error
- Pack間で著しく偏った生成頻度
- Server Performanceへの明確な影響
- ユーザーが明示したGameplay方針との不一致
- Selection Manifest上の明白な誤り
- 既に承認済みScopeとの矛盾

「より良さそう」「一般的にはこの値」だけを根拠に変更しない。

### 8.3 既生成Chunk

Weight、Distance、Enable／Disableを変更しても、既に生成済みのChunkには遡及しない。

調整案には必ず次を記載する。

```text
変更前
変更後
対象File
対象Key／Structure ID
根拠
将来Chunkへの影響
既生成Chunkに残る差
Order 5証拠への影響
Rollback方法
```

---

## 9. Phase A — Preflightと調整監査

Phase AはRead-onlyを原則とする。

### 9.1 Git／Runtime

確認：

- Branch
- Remote
- HEAD
- Clean Worktree
- Java Process
- Protected Port
- Player数
- MariaDB Health
- Redis Health
- Main／Lobby／Frontier／Velocity状態
- Disk空き容量
- Main Container容量
- Backup先容量

Backup作成には、少なくとも次を満たすこと。

```text
空き容量 >= Main Container実容量 × 2 + 2 GiB
```

Hardlink、Junction、Symbolic Linkまたは同一Fileへの参照をBackupとして扱わない。

### 9.2 World Identity

停止状態または安全なRead-only手段で確認：

- Seed
- UUID
- Spawn
- Dimension Key
- Storage Path
- Persistent Region数 `17 / 11 / 18`
- Resource Region数 `8 / 4 / 4`
- 全Resource `region/*.mca` SHA-256
- Multiverse登録
- Portal Family Link
- `main_end`がAliasだけであること

### 9.3 Content Lock

確認：

- Plugin JAR Version／SHA-256
- 5 Pack Archive Version／SHA-256
- Prop Pack
- Selection Manifest
- Prop Mapping
- Entity Removal
- Block Entity Removal
- Generated Import ZIP
- 430／278／152 Count
- FMM 55 Models
- Generated Main Pack
- World Allowlist
- `setupDone: true`
- `spawnProtectionRadius: 100`
- Plugin Auto Download無効

ArtifactまたはSource Archiveの差替えを行わない。

### 9.4 Local Log監査

Current Runtime Candidate生成開始以降のIgnored Runtime Logを監査する。

記録対象：

- BetterStructures自然生成通知
- Exact Structure ID
- Pack
- World
- Generator Type
- XYZ
- Chunk
- Region
- Timestamp
- ERROR／SEVERE／Exception
- failed Schematic
- unresolved Model
- duplicate ID
- TPS／MSPT異常
- Chunk生成異常
- FMM表示異常
- ResourcePackManager異常

可能な範囲で次の表を作る。

| Pack | Dimension | Generator | 通知数 | Exact ID確認数 | 備考 |
|---|---|---|---:|---:|---|

LogだけでExact Pack／IDを一意に判定できないものは、`unknown`として記録し、推測で割り当てない。

### 9.5 既存Structure監査

追加Chunkを生成せず、既に確認済みの座標だけを対象にする。

最低限：

- Default Mine Storage
- Caves Circle Dungeon
- Echoes Nether Wall
- Echoes End Shrine
- Exploration Bridge Cave

確認：

- Structure残存
- 重大な欠損なし
- Missing Textureなし
- 異常Entity密度なし
- Container／Spawner／Propの代表確認
- 再起動後の保持
- Config変更がない場合は再探索不要

新しいRegionを生成してはならない。

### 9.6 Density／Balance評価

次を報告する。

- 生成したRegion数
- 可能なら実生成Chunk数
- 通知数
- Pack別／Generator別分布
- 同一Structureの反復
- Structure間距離
- Surface／Shallow／Deep／Sky／Liquid／Dungeonの傾向
- 観測Sampleの限界
- Performance所見
- Gameplay上の懸念
- 現状のWeight／Distanceを変更する具体的根拠の有無

---

## 10. Phase A Decision Gate

Codexは、次の3案をユーザーへ提示して停止する。

### A — Current Configをそのまま採用

条件：

- 具体的なBlocking defectがない。
- 現在の278 Enabled／152 Disabledを維持できる。
- Global Distance、Offset、Altitude、Spawn Protectionを維持できる。
- 既存の受入証拠が有効である。

これは、具体的な問題が見つからない場合の推奨案である。

承認Token：

```text
APPROVE-WAYFARER-MAIN-ORDER6-ACCEPT-AS-IS
```

### B — 厳密なConfig-only調整

CodexはProposal IDを発行する。

例：

```text
MAIN-ORDER6-TUNING-001
```

ProposalにはExact Diff Tableを含める。

承認Token：

```text
APPROVE-WAYFARER-MAIN-ORDER6-TUNING:<PROPOSAL-ID>
```

例：

```text
APPROVE-WAYFARER-MAIN-ORDER6-TUNING:MAIN-ORDER6-TUNING-001
```

TokenとProposal IDが一致しない場合は実行しない。

### C — Runtime Candidateを棄却

条件：

- Config-only調整では受容できない。
- World再生成またはRegion操作が必要である。
- Order 5証拠を維持できない。
- 重大なWorld品質問題がある。

Token：

```text
REJECT-WAYFARER-MAIN-ORDER6-CANDIDATE
```

Cの場合、本TaskはBaseline Backupを作成せず停止する。別の破壊的Taskを要求する。

ユーザーの沈黙、曖昧な「OK」、過去の生成承認または通常作業許可を、A／Bの承認として扱わない。

---

## 11. Phase B — 承認された判断の実行

### 11.1 Aの場合

変更しない。

- `selection.yml`
- BetterStructures Config
- ValidWorlds
- Content
- Models
- Resource Pack構成
- World
- Region
- Seed
- UUID
- Spawn
- Portal
- Player Data

現在のConfig HashとRuntime Artifact HashをFinal Baselineへ記録する。

### 11.2 Bの場合

承認されたProposalだけを適用する。

許可され得る対象：

```text
config/main-betterstructures/selection.yml
servers/main/plugins/BetterStructures/config.yml
```

必要に応じて、承認済みSelectionから生成されるTracked Manifest値：

```text
versions.yml
plugin-manifest.yml
```

禁止：

- Proposalにない変更
- Source Archive直接編集
- Original Schematic直接編集
- Prop Mapping拡張
- Entity Removal拡張
- Block Entity Removal拡張
- Artifact Download
- Plugin更新
- World Allowlist変更
- Resource World有効化
- `setupDone`変更
- `spawnProtectionRadius`変更
- `protectEliteMobsRegions`有効化
- Player Data変更

Selection変更時：

1. 現行Runtime Working CopyをIgnored Snapshotへ保存する。
2. Trackedな4つのPowerShell Entry Pointと`scripts/main_betterstructures_tools.py`を使用する。
3. Exact Script名はRepositoryから解決し、推測でCommandを作らない。
4. Source SHA-256を再確認する。
5. Selectionを展開する。
6. Prop／Entity／Block Entityの既存Normalization Ruleだけを適用する。
7. Deterministic Buildを2回実施する。
8. 2回のGenerated Import ZIP SHA-256が一致することを確認する。
9. Runtime Importへ反映する。
10. Clean Main RestartでLoadを確認する。
11. Enabled／Disabled Countを記録する。
12. Generated Main PackとFMM Packを再記録する。

### 11.3 Order 5証拠保護

次のいずれかに該当するB案は、本Task内で実行してはならない。

- 受入済み4 Packのいずれかを完全に無効化する。
- 受入済み代表StructureをDisabledへ変更する。
- 受入済み代表StructureのPackを削除する。
- World Allowlistから受入Dimensionを外す。
- 既存受入結果が「採用済みContentの自然生成証拠」でなくなる。

該当する場合は、Order 5再受入を含む別Taskへ分離する。

### 11.4 既生成Chunk

Bを適用してもRegion削除や再生成を行わない。

Final Baseline文書には次を明記する。

```text
既生成の17 / 11 / 18 Regionには、調整前設定で生成されたStructureが含まれる。
調整後設定は、今後初めて生成されるChunkへ適用される。
```

---

## 12. Runtime Validation

A／Bの判断反映後、MainをClean Startする。

最低限：

- Paper 26.2 build 62
- BetterStructures 2.6.3
- WorldEdit 7.4.4
- 5 Pack
- FMM 2.10.2
- 55 Models
- ResourcePackManager 2.3.0
- Multiverse-Core
- Multiverse-NetherPortals
- Existing Gameplay Plugins

確認：

- `Done`
- failed Schematicなし
- unresolved Modelなし
- duplicate IDなし
- startup-blocking Errorなし
- BetterStructures Count一致
- World Allowlist一致
- Main Pack生成
- Client Pack配信
- Lobby → Main接続
- 既存代表Prop表示
- 既存受入Structure保持
- Seed／UUID／Spawn不変
- Portal Family不変
- Persistent Region数不変
- Resource Region数／Hash不変

新しいChunk／Regionを生成しない。

Client作業中は、待機中のPlayerをCreativeまたはSpectatorにする。完了直前にMain Spawnへ戻し、Survivalへ戻し、Temporary Adminを削除して切断する。

---

## 13. Final Baseline Backup Preflight

Runtime Validation成功後、Networkを正常停止する。

順序：

1. 新規接続を防止する。
2. Player数0を確認する。
3. Velocityを正常停止する。
4. 約10秒待つ。
5. 各Paperで`save-all flush`相当を実施する。
6. Main、Frontier、Lobbyを正常停止する。
7. Java Process終了を確認する。
8. Protected Portが閉じていることを確認する。
9. `session.lock`を排他Openできることを確認する。

Codexは次をユーザーへ提示する。

- Repository Root
- Git HEAD
- Main Container exact path
- Backup incomplete path
- Backup final path
- Main Container file count
- Main Container bytes
- Persistent Region数
- Resource Region数
- Resource Region Hash result
- Seed
- UUID
- Spawn
- Decision A／B
- Proposal ID（Bのみ）
- Config SHA-256
- Artifact SHA-256
- Generated Pack SHA-256
- Disk free
- Copy method
- Rollback method

Final Baseline承認Token：

```text
APPROVE-WAYFARER-MAIN-V006-FINAL-BASELINE
```

このTokenを受けるまでBackup Copy、Baseline宣言または正本文書の完了更新を行わない。

---

## 14. Final Main Baseline Backup

### 14.1 Backup Path

```text
backups/main-v006-final-baseline-YYYYMMDD-HHMMSS.incomplete/
```

検証完了後：

```text
backups/main-v006-final-baseline-YYYYMMDD-HHMMSS/
```

既存Pathを上書きしない。

### 14.2 推奨Script

新規作成：

```text
scripts/Invoke-MainV006FinalBaselineBackup.ps1
```

ScriptはDry RunをDefaultとし、`-Execute`とExact Tokenがない限りCopyしない。

推奨Parameter：

```powershell
-BackupRelativePath
-ConfirmationToken
-Execute
```

### 14.3 Backup Method

停止状態の次を**Copy**する。

```text
servers/main/main/
```

Destination：

```text
payload/world/main/
```

置換生成Taskと異なり、Source Main ContainerをMoveしてはならない。

Copy対象にはResource Familyも含め、停止時点のMain Container全体を保存する。

追加Config Snapshot：

```text
servers/main/server.properties
servers/main/bukkit.yml
servers/main/spigot.yml
servers/main/config/paper-global.yml
servers/main/config/paper-world-defaults.yml
servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
servers/main/plugins/Multiverse-Core/worlds.yml
servers/main/plugins/Multiverse-NetherPortals/config.yml
servers/main/plugins/FreeMinecraftModels/config.yml
servers/main/plugins/ResourcePackManager/config.yml
config/main-betterstructures/selection.yml
config/main-betterstructures/prop-id-mapping.yml
config/main-betterstructures/entity-removals.yml
config/main-betterstructures/block-entity-removals.yml
versions.yml
plugin-manifest.yml
```

### 14.4 Backup Evidence

作成：

```text
preflight.json
manifest.json
sha256.txt
restore.md
validation.json
```

`sha256.txt`はPayloadとEvidenceの全Fileを対象とする。ただし`manifest.json`自身のHashは外部報告値として記録してよい。

Manifest最低項目：

```text
schemaVersion
timestamp
gitHead
approvalToken
order6Decision
proposalId
sourceMainContainer
backupIncompletePath
backupFinalPath
copyMethod
sourceFileCount
sourceByteTotal
payloadFileCount
payloadByteTotal
sha256ListSha256
seed
persistentWorlds
resourceWorlds
regionCounts
resourceRegionHashes
spawn
worldUUIDs
configRelativePaths
configSha256
artifactLocks
generatedPackHashes
selectionCounts
acceptedPacks
acceptedStructures
restoreProcedure
```

### 14.5 Verification

停止状態のSourceとBackup Payloadについて：

- File count一致
- Byte total一致
- Relative path集合一致
- 全File SHA-256一致
- Persistent Region数一致
- Resource Region数一致
- 全Resource Region SHA-256一致
- Config Snapshot SHA-256一致

検証成功後だけ、`.incomplete`をFinal PathへRenameする。

失敗時：

- Sourceを変更しない。
- `.incomplete`をFinal化しない。
- Partial Backupを削除せず、診断用として保持する。
- Baselineを宣言しない。
- ユーザーへ失敗点を報告する。

---

## 15. Restore手順

`restore.md`へ最低限記録する。

1. 新規接続を拒否する。
2. 全Minecraft Componentを正常停止する。
3. 現行Main Containerを新しいQuarantineへMoveする。
4. Final Baseline Backupの`payload/world/main`を`servers/main/main`へCopyする。
5. Config SnapshotをExact Pathへ復元する。
6. File count、Byte total、SHA-256を検証する。
7. Seed、UUID、Spawn、Region数を確認する。
8. Resource FamilyのUUID、Seed、Region Hashを確認する。
9. Multiverse登録とPortal Familyを確認する。
10. Mainを起動し、Pack、Plugin、代表Structureを確認する。
11. BackupとQuarantineを保持する。

Restoreを本Task内で実行しない。

---

## 16. Final Baseline宣言

Verified Backup完成後、現Runtime Candidateを次へ昇格する。

```text
Final Main Baseline
```

文書上の表現：

```text
Final Main Baseline:
  2026-07-25 replacement-generated Main family
  Order 5 accepted
  Order 6 tuning decision applied
  final stopped-state backup verified

Legacy Rollback Baseline:
  2026-07-21 Main family

Replacement Rollback Source:
  backups/main-v006-replacement-generation-20260725-154934/
```

「Current Runtime Candidate」という表現は、現行Mainについては終了する。

ただし、次を宣言しない。

```text
V0.1.0 Release Baseline
Network Cold Backup Complete
Isolated Restore Complete
Pre-release Player State Reset Complete
V0.1.0 Released
```

---

## 17. 正本文書更新

最低限：

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/02-installation.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/13-main-world-baseline.md
versions.yml
plugin-manifest.yml
codex/README.md
```

新規Investigation：

```text
docs/investigations/<date>-main-order6-final-baseline.md
```

本指示書：

```text
codex/Project_Wayfarer_Main_Order6_Tuning_and_Final_Baseline.md
```

記録内容：

- 実施日
- Pre-execution Git HEAD
- A／B／C判断
- Bの場合のProposal IDとExact Diff
- 調整根拠
- Config Hash
- Artifact Hash
- Selection Count
- Runtime Validation
- Persistent Region数
- Resource Region数／Hash
- Seed
- UUID
- Spawn
- Pack Hash
- Backup Path
- Manifest SHA-256
- SHA list SHA-256
- Payload Count／Bytes
- Restore手順
- Order 6完了
- Order 7残件
- Main Final BaselineとV0.1.0 Baselineの区別

---

## 18. Acceptance Criteria

すべて必要。

### Decision

- Phase A監査完了
- A／B／C提示
- Exact User Token
- 承認外変更なし

### Runtime

- Seed不変
- UUID不変
- Spawn不変
- Persistent Region `17 / 11 / 18`不変
- Resource Region `8 / 4 / 4`不変
- Resource Region Hash不変
- Portal Family不変
- World Allowlist不変
- 新規Region生成なし
- Plugin／Pack正常Load
- Schematic／Model／Duplicate Errorなし
- Client Pack配信成功
- Player Cleanup成功

### Content

- Aでは278／152不変
- Bでは承認済みCountとExact Diff一致
- 受入済み4 Packの証拠を維持
- Original Content不変
- Source Archive不変
- Artifact Version不変
- Deterministic Build一致（BのSelection変更時）

### Backup

- All Minecraft Component stopped
- Protected Port closed
- Complete Main Container copy
- Config Snapshot
- File count一致
- Byte total一致
- 全Payload SHA-256一致
- Manifest
- SHA list
- Restore手順
- `.incomplete`からFinalへのRename
- BackupがGit Ignore対象
- Backup Path／Manifest Hashを文書化

### Documentation

- Order 6 complete
- Order 7 incomplete
- Final Main Baseline宣言
- Legacy Backup保持
- V0.1.0 Release未宣言
- Codex Archive登録
- Git diff check
- Layout test
- Clean Worktree

---

## 19. Failure／Stop Conditions

- A／B Tokenなし
- B Proposal ID不一致
- Final Baseline Tokenなし
- World Identity不一致
- Region数不一致
- Resource Hash不一致
- Unexpected new Region
- Config Drift
- Artifact Drift
- Plugin Load Failure
- Pack Failure
- Schematic Failure
- Model Failure
- Duplicate ID
- Player Cleanup Failure
- Normal Shutdown Failure
- Protected Port残存
- Disk不足
- Backup Copy Failure
- Hash Verification Failure
- `.incomplete`の誤Final化
- GitへRuntime ArtifactがStage
- Order 5証拠失効
- Candidate棄却

Failure時にWorldを削除、Trim、再生成またはRollbackしない。安全な停止状態を維持して報告する。

---

## 20. Git非追跡

Commit禁止：

- World
- Region
- POI
- Entity
- Player Data
- Log
- Screenshot
- Backup
- JAR
- Content ZIP
- Schematic
- Model
- Generated Pack
- Hosting Data
- Secret
- MariaDB Data
- Redis Data
- Temporary Snapshot
- Quarantine

確認：

```powershell
git status --short
git check-ignore -v <backup-path>
git check-ignore -v <world-path>
git check-ignore -v <log-path>
git diff --cached --name-status
```

---

## 21. 検証

```powershell
git diff --check
.\scripts\Test-Layout.ps1
```

YAML Parse：

```text
versions.yml
plugin-manifest.yml
config/main-betterstructures/selection.yml
servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
```

新規Backup Script：

- Dry Run
- Invalid Path rejection
- Existing Destination rejection
- Outside-root rejection
- Missing Token rejection
- Case-sensitive Token
- Running Server rejection
- Open Port rejection
- Missing Config rejection
- Source／Payload Hash verification
- `.incomplete`保持
- Final Rename
- Non-zero Exit on failure

を確認する。

---

## 22. Commit／Push

### Aの場合

推奨Implementation Commit：

```text
docs: Main Final Baselineを確定
```

### Bの場合

調整成功後、Backup前に推奨Commit：

```text
feat: Main BetterStructures調整を確定
```

このCommit SHAをFinal Backup Manifestへ記録する。

Backup／文書確定Commit：

```text
docs: Main Final Baselineを確定
```

### Archive追補Commit

```text
docs: Main Final Baseline Commitを記録
```

Push前：

```powershell
git status --short
git log -5 --oneline
git diff --check
.\scripts\Test-Layout.ps1
```

Push後、RemoteのCommit SHAを確認する。

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

CまたはStop：

```text
停止（Main Runtime Candidate未確定）
```

再実行Policy：

```text
Final Baseline確定後はそのまま再実行禁止。
Weight／Content再調整、World LifecycleまたはBackup再作成は、現行Baselineを前提に別Taskで行う。
```

---

## 24. 完了報告

以下を報告する。

1. Order 6 Decision A／B／C
2. User Approval Token
3. Proposal ID（Bのみ）
4. Exact Config Diff（Bのみ）
5. 実装Commit SHA／Message
6. Baseline Commit SHA／Message
7. Archive Commit SHA／Message
8. Branch／Remote
9. Seed
10. UUID
11. Spawn
12. Persistent Region数
13. Resource Region数
14. Resource Region Hash
15. BetterStructures Count
16. 5 Pack Load
17. FMM Model Count
18. Main Pack SHA-1／SHA-256
19. FMM Pack SHA-1／SHA-256
20. Runtime Error結果
21. Player Cleanup
22. Backup Path
23. Manifest SHA-256
24. SHA list SHA-256
25. Payload File Count
26. Payload Bytes
27. Source／Backup全Hash一致
28. Restore文書
29. Order 6完了
30. Order 7残件
31. 更新File
32. 実行した検証
33. Git非追跡確認
34. 最終`git status --short`

---

## 25. 完了後の正式状態

```text
Orders 2–6:
  complete

Final Main Baseline:
  established

Order 7 CoreProtect:
  next

Main Spawn Hub／Gate:
  unbuilt

Main Spawn WorldGuard Region:
  unapplied

Frontier:
  incomplete

V0.1.0:
  unreleased
```

Order 6完了後の次作業は、Roadmap順序どおりCoreProtectである。
