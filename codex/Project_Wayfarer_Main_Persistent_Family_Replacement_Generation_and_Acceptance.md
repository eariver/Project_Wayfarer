# Project Wayfarer Main Persistent Family置換生成・限定受入試験 指示書

## 1. 推奨Sol

```text
high
```

理由：

- `main`、`main_nether`、`main_the_end`を置換する破壊的World Lifecycle Taskである。
- Main Container内にResource Familyが同居しており、Persistent／Resourceの分離保持が必要である。
- World、Player Data、Seed、UUID、Spawn、Portal Family、BetterStructures、Resource PackおよびRollbackを横断する。
- 誤ったPath、Resource Data破損、Seed不一致または不完全Backupは、通常のConfig修正では回復できない。
- 実行前と破壊直前の二段階Gateが必要である。

`high`より上のSolへ変更する条件はない。代わりに、Path、Backup、Resource差分、Player Data Policy、Spawn安全性またはPlugin Loadに不確実性がある場合は、推測せず停止してユーザー判断を求める。

---

## 2. 目的

Project Wayfarer Ver.0.0.6 Roadmapの次を実施する。

```text
Order 4:
Main Persistent Family regeneration

Order 5:
Main generation acceptance
```

対象：

```text
main
main_nether
main_the_end
```

目的：

1. 2026-07-25にLoad確認済みとなったMain BetterStructures 5 Pack構成を、最初のChunkから一貫して生成する。
2. 現行の`103 Default Structures`だけで生成されたPersistent Main Familyを、同一Seedの置換候補Worldへ更新する。
3. Resource Familyを完全に維持する。
4. Seed、UUID、Spawn、Portal Family、Resource Packおよび代表的な自然生成を限定範囲で確認する。
5. Roadmap Order 4／5を完了し、Order 6のWeight／Content調整と最終Baseline確定へ引き渡す。

本Taskは**破壊的Task**である。

Codexは、後述の承認Gateを通過するまで、World ContainerまたはPersistent Dimension Dataを移動、削除、置換、Renameまたは再生成してはならない。

---

## 3. 本Taskに含めないもの

- Main BetterStructuresのPack追加または選定変更
- 278件のSelection変更
- Prop Mapping変更
- Entity／Block Entity除去Ruleの拡張
- Weight調整
- Loot調整
- 広範なPregeneration
- World Border変更
- CoreProtect導入
- Hub／Gate建築
- Main Spawn WorldGuard Region作成
- Builder Phase 1B
- Frontier変更
- Ruined Frontier
- Worlds Beyond
- Multiverse-Inventories
- Wayfarer_Core／Wayfarer_Frontier
- Resource Reset
- MariaDB／Redis Migration
- Waymark Reset
- mcMMO Reset
- V0.1.0 Pre-release Player State Reset
- 正式なMain／Frontier Resource Pack Hosting Lock
- Tag／GitHub Release

自然生成の限定受入試験に必要なChunkだけを生成する。構造物探索を目的とした無制限移動やBetterStructures Pregenerationを行わない。

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
git log -7 --oneline
```

最低限、次のCommitを含むこと。

```text
20baf5e77fc5e8a36618c665ef97e314ece4d96a
feat: Main BetterStructures Contentを統合

c6a5d27c5410666c1cde436d1b6986ebbd334cf8
docs: Main BetterStructures統合Commitを記録
```

意図不明な未Commit変更がある場合は停止する。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- Amend
- 未追跡Artifactの一括削除
- 既存Backupの削除
- Repository外Pathの探索
- ユーザーが作成したRepository外コピーへのAccess

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
versions.yml
plugin-manifest.yml
servers/main/server.properties
servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
servers/main/plugins/Multiverse-Core/worlds.yml
servers/main/plugins/Multiverse-NetherPortals/config.yml
```

歴史的参考：

```text
codex/Project_Wayfarer_Phase3_Main_Persistent_World_Final_Generation.md
```

過去Taskをそのまま再実行しない。現行Ver.0.0.6正本、現在Runtimeおよび本指示書を優先する。

---

## 6. 現行Lock値

### 6.1 Main Runtime

```text
Paper 26.2 build 62
Java 25
WorldEdit 7.4.4
BetterStructures 2.6.3
FreeMinecraftModels 2.10.2
ResourcePackManager 2.3.0
```

### 6.2 BetterStructures Content

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack internal version 1
Echoes of the Past version 3
BetterStructures Prop Pack 55 Models
```

```text
Source Config: 430
Enabled: 278
Disabled: 152
```

Selectionと変換の正本：

```text
config/main-betterstructures/selection.yml
config/main-betterstructures/prop-id-mapping.yml
config/main-betterstructures/entity-removals.yml
config/main-betterstructures/block-entity-removals.yml
scripts/Prepare-MainBetterStructuresContent.ps1
scripts/Normalize-BetterStructuresProps.ps1
scripts/Test-BetterStructuresSchematicEntities.ps1
scripts/Test-MainBetterStructuresPreflight.ps1
scripts/main_betterstructures_tools.py
```

本Taskでこれらを変更しない。

### 6.3 Seed

```text
164225356311935743
```

同じSeedを明示値として再利用する。

```properties
level-seed=164225356311935743
```

空欄またはRandom Seedへ変更しない。

### 6.4 World名

Persistent Main Family：

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

`main_end`はMultiverse Aliasであり、実Bukkit World名またはFilesystem Pathとして使用しない。

### 6.5 期待Storage Path

現行正本上の期待値：

```text
servers/main/main/dimensions/minecraft/overworld
servers/main/main/dimensions/minecraft/the_nether
servers/main/main/dimensions/minecraft/the_end

servers/main/main/dimensions/minecraft/resource
servers/main/main/dimensions/minecraft/resource_nether
servers/main/main/dimensions/minecraft/resource_end
```

これは実行時に必ず再解決する。

Directory名だけで判定せず、以下を突き合わせる。

- `Resolve-Path`
- `level.dat`
- Paper Startup Log
- Multiverse `worlds.yml`
- Runtime World Info
- Seed
- UUID
- Region／Entity／POI Directory
- Paper World Container構造

実態が異なる場合は停止し、承認を取り直す。

### 6.6 現行Spawn候補

```text
Main Overworld:
  (320, 70, 128)

Main Nether管理Spawn:
  (20.5, 60, -19.5)

Main End管理Spawn:
  (100.5, 49, 0.5)
```

同一Seedのため、これらを第一候補として再利用する。ただし、新しいBetterStructures生成条件を含めて安全性を再確認する。

### 6.7 BetterStructures境界

```yaml
New worlds spawn structures: false

Valid worlds:
  main: true
  main_nether: true
  main_the_end: true
  resource: false
  resource_nether: false
  resource_end: false
```

```text
spawnProtectionRadius: 100
EliteMobs Region integration: disabled
Plugin auto-download: disabled
```

### 6.8 現行Rollback情報

既存Baseline Backup：

```text
backups/main-final-generation-20260721-001501/
```

Manifest SHA-256：

```text
50B0F6244223DA68B752407BBE89127E0CE49645F7673A5FF929EE9C5B8A3C9D
```

Content Preflight Snapshot：

```text
backups/main-betterstructures-preflight-20260725-140012/
```

Manifest SHA-256：

```text
6F118EFA78B7D02BEB31FD4275373B8D69C201FF7341DC539074AE2244A16BAA
```

両方とも削除、移動、上書きまたは再利用しない。

---

## 7. ユーザー側ローカルコピー

ユーザーは本Task開始前に、Repository Root全体または同等の完全なローカルコピーを、Repository外へ作成する予定である。

CodexはRepository外を閲覧・検証しない。

最初にユーザーへ次の確認を求める。

```text
LOCAL-COPY-COMPLETE
```

この確認は、次だけを意味する。

- ユーザーがRepository外コピーを取得済みである。
- ユーザーがコピー完了を自己確認した。
- CodexはそのPathや内容へAccessしない。

この確認だけでは破壊的処理を承認しない。

Repository外コピーは追加の安全策であり、後述するRepository内Ignored Backup、ManifestおよびRollback証拠の代替ではない。

---

## 8. Vanilla Player Data Policy

破壊前に、ユーザーへ次のどちらかを選択させる。

### A. Complete Reset — 推奨

置換対象：

- Inventory
- Armor
- Offhand
- Ender Chest
- Position
- Health
- Food／Saturation
- Vanilla XP／Level
- Advancements
- Statistics
- Player Data
- Map／Raid／Scoreboard等のWorld-scoped Data
- 旧Main Container内の試験Data

維持：

- LuckPerms
- mcMMO
- Waymark
- EvenMoreFish Database
- MariaDB
- Redis
- Plugin Config
- Resource Family

理由：

- V0.1.0前の試験Dataである。
- 旧World UUID、座標、Map、Dimension参照および試験Itemを持ち込まない。
- 今回のWorld置換と整合する。
- Main／Frontierの将来Item境界を汚染しない。

### B. Preserve

本指示書の標準実装では実行しない。

Preserveを選んだ場合：

1. 本Taskを破壊前で停止する。
2. Player Data Migration設計を別途作成する。
3. Inventory、位置、Dimension、Advancement、Stats、MapおよびUUID整合性を個別に検証する。
4. 新しい明示承認を得る。

ユーザーがAを選んだ場合だけ、本指示書の標準生成手順へ進む。

---

## 9. 実行前非破壊Preflight

この段階ではWorld Dataを移動しない。

### 9.1 Git／Runtime

確認：

- Git Working Tree
- Branch／Upstream
- Main Runtime状態
- Velocity／Lobby／Frontier状態
- Java Process
- 接続Player
- Main Paper／Java Version
- Plugin Version
- Disk空き容量
- Backup Directoryの書込み可否
- World `session.lock`
- 現行Log

### 9.2 Content再検証

実行：

```powershell
.\scripts\Test-MainBetterStructuresPreflight.ps1
```

必要に応じて安全なDry Run：

```powershell
.\scripts\Prepare-MainBetterStructuresContent.ps1 -DryRun
.\scripts\Normalize-BetterStructuresProps.ps1 -DryRun
.\scripts\Test-BetterStructuresSchematicEntities.ps1 -DryRun
```

確認：

- Source Hash一致
- 278 Selection
- 未解決Model ID 0
- Entity Blocking Risk 0
- 生成Import ZIP Digest一致
- 5 Pack認識
- FMM 55 Models
- ResourcePackManager Pack生成
- Auto Download無効

Preflightが失敗した場合、Worldを変更せず停止する。

### 9.3 World Identity

各Persistent／Resource Worldについて記録する。

- Bukkit名
- Runtime Key
- Exact Resolved Path
- UUID
- Seed
- Region File数
- Entity File数
- POI File数
- File Count
- Byte Total
- Region SHA-256
- Spawn
- Multiverse Spawn
- Environment
- Generator
- Loaded状態

Resource Familyは全Region SHA-256を記録する。代表Hashだけで済ませない。

### 9.4 Config Snapshot

最低限：

- `server.properties`
- `bukkit.yml`
- Paper Global／World Config
- Multiverse-Core
- Multiverse-NetherPortals
- BetterStructures
- FreeMinecraftModels
- ResourcePackManager
- LuckPermsのSanitized Runtime Identity
- 現行Git HEAD

SecretをReportまたはCommitへ含めない。

---

## 10. 破壊前承認表

CodexはPreflight後、以下を一つの表としてユーザーへ提示する。

### Generation

- Seed
- `level-seed`
- Main Paper／Java
- BetterStructures／WorldEdit
- 5 Pack／278 Selection
- FMM／ResourcePackManager
- Spawn Protection 100
- Main有効World
- Resource無効World
- Resource Pack Preflight状態

### Destructive Scope

- 移動するMain ContainerのExact Path
- 置換するPersistent DimensionのExact Path
- 維持するResource DimensionのExact Path
- 変更しないLobby／Frontier Path
- Player Data Policy
- Backup Destination
- Backup方式
- Manifest方式
- Rollback方式
- 予想File数／Byte数
- 空き容量

### Runtime

- 停止するComponent
- 初回生成で起動するComponent
- Player接続禁止
- Database／Redis非変更
- Plugin／Content非変更
- Weight非変更
- Pregeneration非実施

### Spawn

- 再利用予定の3座標
- 再確認条件
- 安全でない場合の停止条件

---

## 11. 最終承認文

上記表を提示した後、ユーザーへ次の完全一致文を要求する。

```text
APPROVE-WAYFARER-MAIN-V006-REPLACEMENT-GENERATION
```

この文を受け取る前に実行してはならない。

- Minecraft Componentの破壊目的停止
- Main Container移動
- BackupへのWorld移動
- Persistent World削除
- Resource Directory Copy
- `level-seed`変更
- Player Data Reset
- 新Main生成
- Spawn変更
- World UUID更新

承認後にPath、Backup Destination、Player Data Policy、Seed、Content HashまたはRuntime状態が変わった場合は、承認を無効として再提示する。

---

## 12. Task専用Backup

### 12.1 Destination

```text
backups/main-v006-replacement-generation-YYYYMMDD-HHMMSS.incomplete/
```

検証成功後：

```text
backups/main-v006-replacement-generation-YYYYMMDD-HHMMSS/
```

既存Directoryを再利用しない。

### 12.2 推奨方式

Main ContainerとBackupが同一Volumeで、安全なRenameが可能な場合：

1. 全Minecraft Componentを正常停止する。
2. Main Container全体をTask BackupへMoveする。
3. Move後のPayloadを旧WorldのRollback正本とする。
4. 新しいMain Containerを作る。
5. Backup内のResource 3 Dimensionだけを、同じRelative PathへCopyする。
6. Resource Copyを全File SHA-256で検証する。
7. Configは別PayloadとしてCopyし検証する。
8. `.incomplete`を確定名へRenameする。

Move対象は実行時に解決したMain Containerであり、推測Pathを使用しない。

別VolumeまたはRename不可の場合：

1. Full Copy
2. File Count
3. Byte Total
4. 全File SHA-256
5. SourceをTask専用QuarantineへRename
6. 新Container作成
7. Resource復元

未検証Copyを根拠にSourceを削除しない。

### 12.3 Backup対象

最低限：

- Main Container全体
- Persistent 3 Dimension
- Resource 3 Dimension
- Vanilla Player Data
- Advancements
- Stats
- Map／Raid／Scoreboard Data
- `server.properties`
- Bukkit／Paper Config
- Multiverse-Core Config
- Multiverse-NetherPortals Config
- BetterStructures Config／ValidWorlds
- FMM Config
- ResourcePackManager Config
- Content Selection／Mapping Manifest
- 現行Git HEAD
- Versions／Plugin Manifest
- Preflight Report

Plugin JAR、Content Artifact、Working Copyは既にIgnored Sourceとして保持されている。Backupへ含める場合もGitへ含めない。

### 12.4 Manifest

作成：

```text
manifest.json
sha256.txt
preflight.txt
rollback.md
```

記録：

- Timestamp
- Git HEAD
- User local-copy attestation
- Approval phrase
- Seed
- Player Data Policy
- Source／Destination Exact Path
- Move／Copy方式
- Volume
- File Count
- Byte Total
- 全File SHA-256
- World UUID
- Seed
- Spawn
- Runtime Key
- Bukkit名
- Environment
- Region Count
- Resource全Region SHA-256
- Config SHA-256
- Plugin／Content Lock
- Selection／Mapping Digest
- Main Pack Digest
- Rollback手順

Secret値を記録しない。

---

## 13. 正常停止

破壊的処理前：

1. 新規接続を停止する。
2. Playerがいないことを確認する。
3. Velocityを正常停止する。
4. 約10秒待つ。
5. Main／Lobby／Frontierで`save-all flush`相当を実行する。
6. Main／Lobby／Frontierを正常停止する。
7. Java Process終了を確認する。
8. `session.lock`が保持されていないことを確認する。
9. MariaDB／Redisで別Taskが動いていないことを確認する。

Infrastructureを停止する必要はないが、Minecraft停止中にMigration、Redis Restartまたは別のRuntime Taskを実行しない。

正常停止できない場合、World Dataを変更せず停止する。

---

## 14. Resource Family復元

Main Containerを移動した後、新Containerへ次だけを復元する。

```text
resource
resource_nether
resource_end
```

実行時のExact Relative Pathを使用する。

確認：

- UUID一致
- Seed一致
- File Count一致
- Byte Total一致
- 全Region SHA-256一致
- Entity／POI File数一致
- Multiverse登録一致
- Dragon Policy一致
- BetterStructures無効
- `resource_end`の既存Policy維持

Resourceを新規生成しない。

Resource Directoryを初回Main起動前に安全に復元できない場合、Mainを起動せず停止する。

---

## 15. Generation Config

### 15.1 `server.properties`

確認・維持：

```properties
level-name=main
level-seed=164225356311935743
level-type=minecraft:normal
generator-settings={}
generate-structures=true
allow-nether=true
```

End有効設定を確認する。

無関係な値を変更しない。

```text
spawn-protection=16
```

は維持する。

### 15.2 BetterStructures

維持：

```yaml
New worlds spawn structures: false

Valid worlds:
  main: true
  main_nether: true
  main_the_end: true
  resource: false
  resource_nether: false
  resource_end: false
```

```text
spawnProtectionRadius: 100
autoDownloadPluginUpdates: false
EliteMobs Region integration: disabled
```

5 Pack、278 Selectionおよび既存変換Ruleを変更しない。

### 15.3 FMM／ResourcePackManager

維持：

```text
FMM 2.10.2
BetterStructures Prop Pack 55 Models
FMM Shop disabled
General Player menu denied
ResourcePackManager 2.3.0
forceResourcePack: false
selfHostEnabled: false
preferSelfHost: false
autoHost: true
```

Nightbreak Remote HostingはPreflight用の暫定状態であり、本Taskで正式Hostingへ変更しない。

### 15.4 End Policy

Main End：

- 通常Dragon有効
- End Gateway有効
- Resource End向けPolicyを適用しない

Resource End：

- 現行Policyを変更しない

---

## 16. Persistent Main Family置換

承認、正常停止、Backup確定およびResource復元後に実行する。

### 16.1 Reset対象

- Main Overworld
- Main Nether
- Main End
- Main ContainerのPersistent Root Metadata
- 選択された場合のVanilla Player Data
- Advancements／Stats
- World-scoped Map／Raid／Scoreboard Data

### 16.2 保持対象

- Resource 3 Dimension
- Lobby
- Frontier Gate
- Plugin JAR
- Plugin Config
- BetterStructures Content
- FMM Models
- ResourcePackManager Config
- LuckPerms DB
- mcMMO DB
- Waymark／Redis
- EvenMoreFish DB
- EconomyShopGUI Config
- Backup
- Manual Artifact
- Working Copy
- Git History

Resource Namespaced DirectoryをReset対象に含めない。

---

## 17. 初回Generation

1. Resource復元と全Region Hash確認を完了する。
2. Velocityを起動しない。
3. Lobby／Frontierを起動しない。
4. Mainだけを起動する。
5. BetterStructures、WorldEdit、FMM、ResourcePackManagerのLoad順を確認する。
6. 5 Pack／430 Config／278 Enabledを確認する。
7. Resource Pack生成を確認する。
8. Main Overworld／Nether／Endが新規生成されることを確認する。
9. 3 DimensionのSeedを確認する。
10. Resource 3 Dimensionが再生成されていないことを確認する。
11. Seed、PathまたはResourceに異常があれば、Playerを接続せず正常停止してRollbackする。
12. Mainを正常停止する。
13. 新WorldのUUID、File数、Region数およびPathを記録する。

初回Generationで通常Playerを接続しない。

BetterStructures Pregeneration Commandを使用しない。

---

## 18. Spawn再確認

同一Seedの既存承認座標を優先する。

### 18.1 Overworld

第一候補：

```text
(320, 70, 128)
```

確認：

- 固体Block
- Headroom
- 水／Lava／Powder Snow／Voidでない
- 窒息なし
- 落下Riskなし
- Hub建築余地
- Spawn Protection 100と整合
- BetterStructures Structureが保護半径内にない
- 初回Spawn
- BedなしRespawn

安全なら同座標をVanilla World SpawnとMultiverse Spawnへ設定する。

### 18.2 Nether

第一候補：

```text
(20.5, 60, -19.5)
```

確認：

- Lava／Fire／Bedrock内でない
- 2 Block以上のHeadroom
- 落下Riskなし
- `/mvtp`相当の管理移動で安全

安全ならMultiverse管理Spawnへ設定する。

### 18.3 End

第一候補：

```text
(100.5, 49, 0.5)
```

確認：

- Default Obsidian Platformまたは安全な到着地点
- 窒息なし
- Void即落下なし
- Dragon Fightを不必要に完了しない
- 管理移動で安全

安全ならMultiverse管理Spawnへ設定する。

### 18.4 座標が安全でない場合

勝手に新座標を確定しない。

最大3候補を提示し、ユーザー判断を待つ。

その間、生成済み候補Worldを削除しない。

---

## 19. 限定自然生成受入

### 19.1 原則

- 手動Pasteを自然生成確認の代替にしない。
- `/bs pregenerate`を使用しない。
- Chunk Pregeneratorを導入しない。
- World Borderを変更しない。
- 無制限探索をしない。
- 生成したChunkと座標を記録する。
- 既存の安全な管理Commandだけを使用する。

BetterStructures 2.6.3の公式HelpまたはRuntime Helpで、既存の自然生成済みStructureを検索・Locateする非破壊Commandが確認できる場合は、それを優先する。

存在しないCommandを推測しない。

### 19.2 最低確認

Overworld：

- Default Packの代表1件
- 追加4 Packのうち少なくとも2 Packから各1件
- Propを含む代表Structure 1件
- Spawn Protection 100 Block内にStructureなし

Nether：

- 選定済みContentの代表1件
- PropまたはContainer／Spawnerを含む代表1件
- 管理Spawn安全

End：

- 選定済みContentの代表1件
- Main Endの空虚さを即座に損なう過密生成がない
- End Exit／管理Spawn安全

全体：

- 少なくとも4 Packの自然生成を確認
- 5 PackすべてがLoad済み
- Schematic Parse Error 0
- 未解決Model ID 0
- Duplicate ID 0
- 保存済みegg Itemなし
- stale bed Block Entity Errorなし
- 通常Entityが異常増殖しない
- Representative Prop表示正常

5 Packすべての自然生成を限定範囲で発見できなくても、Load／Selection／Generator登録が正常で、広範探索だけが不足する場合は即Rollbackしない。確認済み範囲と未確認Packを記録し、Order 5を完了にするかユーザー判断を求める。

### 19.3 Bounded Exploration

広範探索に入る前に停止条件を設ける。

以下のいずれかに達したら、追加探索前にユーザーへ報告する。

- 新規生成Regionが各Dimensionで8を超える
- 合計新規Regionが16を超える
- 代表Structure確認のための移動が合計60分を超える
- Client FPS／TPS低下
- Structure密度が明らかに過剰
- 予期しない大型Structure
- 不明なPortal
- Entity異常
- Loot異常

この上限はPregeneration目標ではない。より少ない範囲で確認できた時点で停止する。

---

## 20. Portal Family受入

Multiverse-NetherPortalsの現在設定を維持する。

Persistent Family：

```text
main ↔ main_nether
main ↔ main_the_end
```

Resource Family：

```text
resource ↔ resource_nether
resource ↔ resource_end
```

確認：

- Persistent／Resourceが交差しない
- Main Nether Portal往復
- Main Stronghold／管理用End移動の接続先
- Main End Exitが`main`
- Resource End Exitが`resource`
- `handle-end-exit-respawn`現行値
- `main_end` Aliasを実World名に使っていない
- Item／Mob／Vehicleの広範試験は行わず、変更経路だけを限定確認

BetterStructures Structure内のEnd Portalを自然生成範囲で発見できた場合だけ確認する。発見のために広範探索しない。

---

## 21. Resource Pack受入

Velocityを起動し、通常経路からMainへ接続する前に：

- Main正常起動
- Lobby正常起動
- Velocity正常起動
- Frontierは必要な場合だけ起動
- Temporary Adminを使用
- 直接Backend接続禁止

確認：

- Main Pack提示
- DownloadまたはCache読込
- Hash一致
- 代表Prop表示
- Missing Textureなし
- Main再接続
- Optional拒否時に切断されない
- Client Logに重大Errorなし

正式Main／Frontier切替試験はFrontier Pack導入後へ残す。

Temporary Adminと試験Propを完全にCleanupする。

---

## 22. Resource Family保持確認

生成後およびRestart後に確認する。

- UUID不変
- Seed不変
- Region File数不変
- 全Region SHA-256不変
- Entity／POI File数の不明な減少なし
- Multiverse登録維持
- Nether／End Link維持
- BetterStructures無効
- Resource End Policy維持
- 新規Resource Regionなし

Metadata Timestamp等が変化した場合：

- Exact Fileを記録
- Region Contentが不変であることを示す
- 不明な差分はBlocking

Resource Region Hashが一つでも意図せず変化した場合は、通常Saveによるものと推測せず、Player接続を止めてRollback判定へ進む。

---

## 23. Restart受入

Mainを正常Restartする。

確認：

- Seed
- UUID
- Spawn
- Multiverse Spawn
- BetterStructures 5 Pack
- 278 Selection
- FMM 55 Models
- ResourcePackManager
- Resource Pack Hash
- Resource Family
- Portal Link
- Main End
- Startup ERROR／SEVERE／Exception
- World Save／正常停止

Network全体の広範Regressionは行わない。

確認不要：

- EconomyShopGUI全取引
- mcMMO全Skill
- EvenMoreFish全機能
- TAB全表示
- Frontier Theme
- 全Structure
- 全Loot
- 全Biome
- Resource Reset
- Backup／Restore総合試験

---

## 24. PASS条件

- `LOCAL-COPY-COMPLETE`取得済み
- Final Approval取得済み
- Complete Reset選択済み、または別承認済みPolicy
- Task専用Backup確定
- Backup Manifest／SHA-256成功
- Rollback手順確定
- Main Persistent 3 Dimensionだけを置換
- Resource Family保持
- Seed一致
- World名一致
- 新UUID記録
- 3 Spawn安全
- BetterStructures 5 Pack Load
- 278 Selection
- FMM 55 Models
- ResourcePackManager Pack配信
- Resource Family無効
- Unknown World無効
- 代表自然生成
- Portal Family維持
- Restart成功
- GitへWorld／Backup／Artifactを含めていない
- Roadmap Order 4完了
- Order 5の限定受入が完了または明示的に残件化
- Order 6未完了
- CoreProtect未導入

---

## 25. 即時Rollback条件

次の場合はPlayer接続を止め、原則Rollbackする。

- Seed不一致
- Persistent Path誤認
- Resource Path誤認
- Resource Region Hash変化
- Resource再生成
- Backup不完全
- Manifest不一致
- World UUID衝突
- Main起動不能
- BetterStructures起動不能
- 5 Pack未認識
- Schematic Parse Error
- Player Data Policy違反
- Main End生成異常
- 承認範囲外Directory変更
- Lobby／Frontier World変更
- Plugin／Content Artifact破損
- 不明な大量Entity
- 新WorldにRollback不能な状態

次は即時Rollbackではなく停止・報告候補：

- Spawn候補が安全でない
- 代表Structureを限定範囲で発見できない
- Resource Pack Prompt文言
- Optional Hostingの一時的失敗
- 軽微なPermission不足
- Weight／密度の調整候補
- Client FPSの要調査

---

## 26. Rollback

1. 新規接続を止める。
2. Playerを切断する。
3. 全Minecraft Componentを正常停止する。
4. 新Main ContainerをTask専用Quarantineへ移動する。
5. Backupの旧Main Containerを元のExact Pathへ戻す。
6. Backup時点のConfigを戻す。
7. File Count／Byte Total／SHA-256を確認する。
8. Mainを起動する。
9. 旧Seed、旧UUID、旧Spawn、Resource FamilyおよびPortal Linkを確認する。
10. 原因、実行済み操作、Rollback結果を報告する。

新Worldを削除せずQuarantineへ保持する。

Rollback Backupを削除しない。

別Seedで再試行しない。

失敗を広い削除やConfig初期化で隠さない。

---

## 27. Repository更新

成功または限定受入完了後、実態へ合わせて更新する。

最低限候補：

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/13-main-world-baseline.md
docs/investigations/<date>-main-v006-replacement-generation.md
versions.yml
plugin-manifest.yml
codex/README.md
```

新規指示書保存：

```text
codex/Project_Wayfarer_Main_Persistent_Family_Replacement_Generation_and_Acceptance.md
```

### 27.1 Baseline表現

Order 6が未完了であるため、文書では次を区別する。

```text
Current Runtime Candidate:
  今回生成したMain Persistent Family

Last Finalized Rollback Baseline:
  2026-07-21 Baseline

Final V0.1.0 Main Baseline:
  未確定。Order 6でWeight／Content調整とBackupを完了後に確定
```

実際のRuntimeが新Worldへ置換された場合、旧Baselineを「現在のRuntime」と書き続けない。

同時に、今回の候補をV0.1.0最終Baselineと断定しない。

### 27.2 記録

- 実施日
- Pre-execution Git HEAD
- Seed
- Player Data Policy
- 新World UUID
- Exact Path
- Spawn
- Region数
- Backup Path
- Backup Manifest Hash
- Resource保持証拠
- BetterStructures／FMM／RPM
- Pack Digest
- 自然生成確認
- Portal確認
- Restart確認
- 残るOrder 6項目

### 27.3 Roadmap

成功時：

```text
Order 4: complete
Order 5: complete
Order 6: incomplete
Order 7 CoreProtect: incomplete
```

限定受入残件がある場合、Order 5を完了にせず、残件をExactに記載する。

---

## 28. Git非追跡

Commit禁止：

- World Data
- Region
- Entity／POI
- Player Data
- Backup
- Quarantine
- Log
- Plugin JAR
- Content ZIP
- Schematic
- Model
- Generated Resource Pack
- Hosting URL
- Secret
- Database Data
- Redis Data
- ScreenshotにSecretや個人情報が含まれるもの

確認：

```powershell
git status --short
git check-ignore -v <representative-world-path>
git check-ignore -v <backup-path>
git diff --cached --name-status
```

---

## 29. 検証

```powershell
git diff --check
.\scripts\Test-Layout.ps1
```

YAMLをRepository既存手段でParseする。

追加Scriptを作る場合：

- Repository Root境界
- Exact Path
- Allowlist
- Dry Run
- Confirmation token
- Backup必須
- Fail closed
- Non-zero Exit
- Resource Persistent分離
- Log
- Idempotencyまたは再実行拒否
- `main`／`resource`誤指定拒否

を満たす。

破壊Scriptを作る場合、既存汎用Resource Reset ScriptへMain対応を追加しない。Task専用Scriptとする。

---

## 30. Commit／Push

全受入に合格した場合：

推奨Commit Message：

```text
feat: Main Persistent Familyを5 Pack構成で再生成
```

限定受入残件があり、World置換は成功している場合：

```text
feat: Main Persistent Family置換候補を生成
```

Codex Archive記録用の追補Commit：

```text
docs: Main置換生成Commitを記録
```

禁止：

- Force Push
- Amend
- Tag
- GitHub Release
- 新Branch
- PR作成

Commit／PushはTracked文書、Manifest、Configおよび安全Scriptだけを対象にする。

---

## 31. Codex Archive

`codex/README.md`へ登録する。

作業前：

```text
実施中・破壊承認待ち
```

成功：

```text
完了（実装Commit: <SHA>）
```

生成成功・受入残件：

```text
生成完了／受入継続（実装Commit: <SHA>）
```

Rollback：

```text
Rollback完了（原因: <summary>）
```

再実行：

```text
破壊的処理を含むため、そのままの再実行禁止。
再生成が必要な場合は現行Runtime、Backup、Seed、Contentおよび承認を再評価した新Taskが必要。
```

---

## 32. 完了報告

以下を報告する。

1. 実装Commit SHA／Message
2. 記録Commit SHA／Message
3. Branch／Remote
4. User local-copy attestation
5. Final Approval
6. Player Data Policy
7. Seed
8. 旧／新World UUID
9. Exact Path
10. Backup Path
11. Backup Manifest SHA-256
12. File Count／Byte Total
13. Resource全Region保持結果
14. 新Region数
15. Spawn
16. BetterStructures Load
17. 5 Pack／278 Selection
18. FMM／ResourcePackManager
19. Resource Pack
20. 自然生成確認
21. Portal Family
22. Restart
23. World／Backup Git非追跡
24. Roadmap Order 4／5状態
25. Order 6へ渡す調整候補
26. 残るBlocking／Non-blocking事項
27. 最終`git status --short`

報告では、Order 6、最終V0.1.0 Main Baseline、CoreProtect、Hub／GateまたはFrontierを完了扱いにしない。
