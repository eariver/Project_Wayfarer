# Project Wayfarer Phase 3 Main恒久World最終生成 指示書

## 1. 目的

Project Wayfarer Ver.0.0.4 RoadmapのPhase 3として、Main Backendの恒久World FamilyをV0.1.0 Alpha向けの最終Generation Baselineへ置き換える。

対象となる論理Dimension：

- Main Overworld
- Main Nether
- Main End

目的：

- Phase 2で導入したBetterStructuresを有効にした状態で、Mainの恒久Dimensionを新規生成する。
- Phase 2の試験Chunk、暫定Spawnおよび暫定World Dataを除去する。
- Main初期Spawn Hubを将来建築できる、安全で承認済みのOverworld Spawnを確定する。
- Main NetherおよびMain Endの管理用Spawnを安全な位置へ設定する。
- 再生成可能なResource World Familyを変更せず、そのDataを完全に維持する。
- V0.1.0へ向けた恒久WorldのSeed、実World名、Storage Path、Spawnおよび生成条件を文書化する。

本タスクは**破壊的なWorld Lifecycle変更**である。

Codexは、実行直前にExact Path、Backup、Seed、Player Data Policy、BetterStructures Spawn Protectionおよび削除／移動対象を提示し、ユーザーの明示承認を得るまでWorld Dataを移動、削除または再生成してはならない。

---

## 2. 同時に行うRepository整理

ユーザーの明示方針により、Codex向け作業指示書は`codex/`へ歴史的実行記録として保存する。

本タスクで次を作成する。

```text
codex/README.md
```

また、本指示書自体を次へ保存する。

```text
codex/Project_Wayfarer_Phase3_Main_Persistent_World_Final_Generation.md
```

`codex/README.md`には最低限、次を記載する。

```markdown
# Codex task instruction archive

このDirectoryには、Project Wayfarerで実際に使用したCodex向け作業指示書を、履歴・監査・再検討のために保存します。

これらは作成時点の作業命令であり、現在のRuntime仕様または実装状態の正本ではありません。完了済み指示書をそのまま再実行してはなりません。

現行状態を判断するときの優先順位：

1. `AGENTS.md`
2. `docs/00-design-guide.md`
3. 対象分野の現行正本文書
4. `versions.yml`
5. `plugin-manifest.yml`
6. `docs/06-acceptance-tests.md`
7. `docs/09-roadmap.md`
8. `codex/`内の歴史的指示書

新しいタスクを開始するときは、必ず最新`main`、現在のRuntime、最新の正式文書および既存変更を確認し、古い指示書との差異があれば現行仕様を優先します。

指示書に記載されたVersion、Path、Permission、Plugin状態、試験条件および未実装事項は、その後のCommitで変更されている可能性があります。
```

さらに保存済み指示書を一覧化し、各項目へ次を記載する。

- Task名
- 実施状況
- 実施日
- 現行正本へのLink
- 再実行禁止
- 後続Taskで置き換えられた事項がある場合の注記

少なくとも次を掲載する。

- Phase 1A Permission Foundation
- Phase 2 BetterStructures Integration
- Phase 3 Main Persistent World Final Generation

`codex/`の指示書を現行仕様の根拠として、`docs/`やManifestより優先してはならない。

---

## 3. 作業基準

最新の`main`を取得し、少なくとも次のCommitを含むことを確認する。

```text
04adff14fdf3e31a730c2471a0c6a809ed82de57
feat: BetterStructuresをMain恒久Worldへ導入
```

開始前に実行する。

```powershell
git status --short
git branch --show-current
git rev-parse HEAD
git fetch
git status -sb
```

確認する。

- Current Branch
- HEAD
- remoteとの差分
- 未Commit変更
- 未追跡ファイル
- Main Runtimeの起動状態
- Velocity／Lobby／Frontierの起動状態
- Java Process
- Docker Infrastructure状態
- Main Paper Version／Build
- Java Version
- BetterStructures Version
- BetterStructures Content Pack
- BetterStructures `ValidWorlds.yml`
- BetterStructures `spawnProtectionRadius`
- Multiverse-Core登録World
- Multiverse-NetherPortals Link
- Main Persistent Worldの実Bukkit名
- Main Persistent Worldの実Storage Path
- Resource Familyの実Bukkit名
- Resource Familyの実Storage Path
- 現在のWorld Seed
- 現在のPlayer Data
- 現在のMain Spawn／Multiverse Spawn
- `.gitignore`
- Backup空き容量

既存変更を破棄しない。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- ユーザー承認前のWorld Data移動・削除・再生成
- Resource Worldの削除・再生成
- Lobby／Frontier Worldの変更
- Main Plugin JARの変更
- BetterStructures Contentの変更
- BetterStructures Schematicの編集
- BetterStructuresの追加Pack導入
- EvenMoreFish導入
- CoreProtect導入
- Advanced Portals導入
- Builder Phase 1B実装
- Hub／Gate建築
- Portal Routing
- Resource Reset
- World Borderの恒久変更
- 大規模Pregeneration
- MariaDB／Redis Dataの変更
- LuckPerms Group／Permission変更
- 既存Backupの削除
- World Pathの推測
- `main_end`をFilesystem PathまたはBukkit World名として無確認で使用
- Runtime World、Backup、Player Data、LogのCommit

---

## 4. 現行Baselineとして確認すべき事項

Repository上の論理設計は次であるが、実行時にはRuntimeから再確認する。

### Persistent Main Family

| 論理名 | 想定Bukkit名 |
|---|---|
| Main Overworld | `main` |
| Main Nether | `main_nether` |
| Main End | `main_the_end` |

`main_end`はMultiverse Aliasであり、実Bukkit名またはFilesystem Pathとして使用しない。

### Resource Family

| 論理名 | 想定Bukkit名 |
|---|---|
| Resource Overworld | `resource` |
| Resource Nether | `resource_nether` |
| Resource End | `resource_end` |

Resource Storageは、現行設計ではMain Overworld Container配下のPaper Namespaced Dimension Directoryに存在する可能性がある。

想定例：

```text
servers/main/main/dimensions/minecraft/resource
servers/main/main/dimensions/minecraft/resource_nether
servers/main/main/dimensions/minecraft/resource_end
```

これは想定にすぎない。

Codexは次から実Pathを解決する。

- `Resolve-Path`
- Directory構造
- `level.dat`
- Paper Startup Log
- Multiverse-Core `worlds.yml`
- Multiverse World Info
- Paper World Container
- 実際に存在するRegion／Entity／POI Data
- 必要なら読取専用のLevel Metadata解析

Directory名だけでWorldを判定しない。

---

## 5. 本タスクの承認Gate

## 5.1 事前調査では変更しない

最初の実行では、World Dataを変更せず次を調査する。

- Persistent 3 Dimensionの実Storage Path
- Resource 3 Dimensionの実Storage Path
- PersistentとResourceの包含関係
- Backup対象
- Backup予定Path
- File Count
- Byte Total
- 利用可能Disk容量
- 現在Seed
- 選択可能なSeed Policy
- Player Dataの存在
- 現在Spawn
- BetterStructures Spawn Protection
- Multiverse登録とLink
- 生成時に維持すべきConfig
- 生成後に更新される可能性があるTracked File

調査だけでServer停止が必要な場合は、正常停止してよいが、World Dataを移動しない。

## 5.2 Codexがユーザーへ提示する内容

破壊的処理前に、次を一つの承認表として提示する。

### Generation

- 使用予定Seed
- Seed選択理由
- `server.properties`へ明示的に保存する値
- Overworld／Nether／Endで同一Seedを使用すること
- BetterStructures Version／Pack
- `spawnProtectionRadius`
- BetterStructures有効World
- BetterStructures無効World

### Destructive Scope

- 移動するExact Path
- 新規生成するExact Path
- 保持するResource Exact Path
- 変更しないLobby／Frontier Path
- Player Dataの扱い
- Advancements／Stats／Maps／Scoreboard等の扱い
- Backup Destination
- Backup作成方式
- Backup検証方式
- Rollback方式

### Runtime

- 停止するComponent
- 起動するComponent
- Database／Redisを変更しないこと
- Main Plugin Configを維持すること

## 5.3 必須のユーザー決定

ユーザーへ次を確認する。

### Seed Policy

候補：

1. 現在のMain Seedを再利用
2. ユーザー指定Seed
3. 新規Random Seed

推奨は、特別なSeed要望がなければ**現在のMain Seedを明示値として再利用**すること。

現在Seedを再利用する場合も、`server.properties`の`level-seed`を空欄のままにしない。承認済み数値を明示して、誤って別Seedが生成されることを防ぐ。

### Vanilla Player Data Policy

候補：

1. **完全Reset（推奨）**
   - Inventory
   - Ender Chest
   - Position
   - Health／Food／XP
   - Vanilla Advancements
   - Statistics
   - World-scoped Map／Raid／Scoreboard Data
   - Phase 2試験Data

2. Preserve
   - 別途詳細な移行設計が必要
   - 旧座標、試験Item、Dimension IDおよびSpawn不整合Riskがある
   - 本指示書の標準手順では実行しない

Pre-Alpha Final Baselineとして、推奨は完全Resetである。

LuckPerms Eligibility、mcMMO、Waymark等の外部Database Dataは、このVanilla Player Data Policyの対象外であり変更しない。

### BetterStructures Spawn Protection

現行値：

```text
100 blocks
```

Main Spawn HubにはLobby、Frontierおよび3 Resource Gateを設置予定である。

ユーザーへ次を提示する。

- 半径100 Blockを維持
- Hub計画に合わせて拡大
- 別値を指定

推奨は、Hub外形が未確定である現段階では**100 Blockを維持**し、Hubが収まらない場合はPhase 3完了前にユーザー判断で拡大すること。

## 5.4 明示承認文

Codexは全項目を提示した後、次の完全一致文を要求する。

```text
APPROVE-WAYFARER-MAIN-FINAL-GENERATION
```

この文をユーザーが送る前に、次を実行してはならない。

- World Directory移動
- World Directory削除
- Persistent World再生成
- `level-seed`変更
- Player Data Reset
- Multiverse Spawn変更
- World Spawn変更

承認後に調査結果と実態が変わった場合は、承認を取り直す。

---

## 6. Backup設計

## 6.1 Backup Destination

新規のTask専用Directoryを使用する。

```text
backups/main-final-generation-YYYYMMDD-HHMMSS/
```

既存Directoryを再利用しない。

`.incomplete`を使用する。

例：

```text
backups/main-final-generation-YYYYMMDD-HHMMSS.incomplete/
```

検証成功後にだけ確定名へRenameする。

## 6.2 Backup対象

最低限：

- Main Overworld Containerの変更対象全体
- Main Nether実Storage
- Main End実Storage
- Main Overworld Container内に包含されるResource 3 Dimension
- `servers/main/server.properties`
- `servers/main/bukkit.yml`
- Main Paper Config
- Multiverse-Core `worlds.yml`
- Multiverse-NetherPortals Link Config
- BetterStructures `config.yml`
- BetterStructures `ValidWorlds.yml`
- Main WorldごとのPaper Config
- 実行前のGit HEAD
- 実行前のWorld／Seed／Spawn一覧

Main Overworld ContainerにResource Dimensionが含まれる場合は、Container全体をBackupへ移動またはCopyし、Resource DataもBackup内へ保持する。

## 6.3 Backup Manifest

作成する。

```text
manifest.json
sha256.txt
preflight.txt
```

記録する。

- Timestamp
- Git HEAD
- Source Path
- Backup Path
- File Count
- Byte Total
- 各FileのSHA-256
- World名
- Seed
- Environment
- World UUID
- Level Data Time
- Multiverse Key
- Bukkit名
- Resource／Persistent分類
- Move／Copy方式
- Volume
- Player Data Policy
- BetterStructures Version／Pack／Config Hash
- Main Paper Version
- Java Version

## 6.4 Move／Copy方針

同一Volumeで、安全なDirectory Renameが可能な場合：

- 元WorldをBackup DirectoryへMoveする。
- Backupを新しい正本として保持する。
- 検証前に削除しない。

別VolumeまたはRename不可の場合：

1. BackupへCopy
2. File Count確認
3. Byte Total確認
4. SHA-256確認
5. SourceをTask専用Quarantine名へRename
6. 新World生成
7. 検証完了までQuarantineを削除しない

Copy未検証の状態でSourceを削除しない。

Backupと新Worldを同じDirectoryへ混在させない。

---

## 7. Resource World保持方式

Main Overworld Container全体を移動すると、Namespaced Resource Dimensionも同時に移動される可能性がある。

その場合は、次の方式を採用する。

1. 全Minecraft Componentを正常停止する。
2. Main Overworld Container全体をBackupへ移動する。
3. Main Nether／End StorageをBackupへ移動する。
4. 新しい空のMain Overworld Containerを作成する。
5. Backup内のResource 3 Dimensionを、確認済みの同一Relative PathへCopyする。
6. Copy後にResource DirectoryごとのFile Count、Byte TotalおよびSHA-256を検証する。
7. Persistent World生成前にResource Directoryが正しい場所へ存在することを確認する。
8. Main起動後、Resource World UUID、Seed、Region Countおよび代表Chunk Hashが変更されていないことを確認する。

Resource Dataを新規生成しない。

Main初回起動前にResourceを復元できないRuntime構造である場合：

- 勝手に起動しない。
- ResourceのAuto-loadを一時変更して回避しない。
- 別の安全な手順を設計してユーザーへ提示する。
- 承認を取り直す。

Resource Directoryに書込みが発生する可能性があるため、Resource保持確認が完了するまでPlayerを接続しない。

---

## 8. 停止手順

破壊的処理時はMinecraft Networkを停止する。

1. 新規接続を止める。
2. 接続Playerがいないことを確認する。
3. Velocityを正常停止する。
4. 約10秒待つ。
5. Main、Frontier、Lobbyへ`save-all flush`相当を実行する。
6. Main、Frontier、Lobbyを正常停止する。
7. 対象Java Processの終了を確認する。
8. World `session.lock`が保持されていないことを確認する。

本タスクではMariaDB／Redis Dataを変更しない。

Infrastructureを停止する必要はないが、Minecraft停止中にDatabase Migration、Redis Restartまたは他Taskを同時実行しない。

強制終了を通常手順にしない。

正常停止できない場合はWorld Dataを変更せず、原因を報告する。

---

## 9. Generation Config

## 9.1 Seed

承認されたSeedを次へ明示する。

```properties
level-seed=<approved-seed>
```

空欄にしない。

確認：

- `level-name=main`
- `level-type=minecraft:normal`
- `generator-settings={}`
- `generate-structures=true`
- `allow-end=true`

他の`server.properties`値を無関係に変更しない。

## 9.2 BetterStructures

維持する。

```yaml
nightbreak:
  autoDownloadPluginUpdates: false
```

維持するWorld Scope：

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

ユーザー承認済みの`spawnProtectionRadius`を設定する。

`103 Default Structures`以外のPackを追加しない。

`setupDone`等のVendor内部Stateを推測で変更しない。

Legacy `minecraft:bed` DataFixer Messageは既知の非Blocking Messageとして扱い、公式Schematicを編集しない。

## 9.3 End Policy

Main Endは通常のPersistent Endとして維持する。

- Ender Dragonを無効化しない。
- Resource End向けのDragon無効設定をMain Endへ適用しない。
- End Gatewayを無効化しない。
- Main EndとResource EndのPolicyを混同しない。

---

## 10. Persistent World Dataの置換

承認後、停止およびBackup検証が完了してから実行する。

### 10.1 移動対象

Runtimeで解決したPersistent Main Storageだけを対象にする。

- Main Overworld persistent data
- Main Nether persistent data
- Main End persistent data

### 10.2 保持対象

- Resource Overworld
- Resource Nether
- Resource End
- Lobby
- Frontier Gate
- Frontier Content
- Plugin Config
- Plugin JAR
- LuckPerms Database
- mcMMO Database
- Redis／Waymark
- EconomyShopGUI Config
- BetterStructures Config／Content
- Multiverse Config
- Multiverse-NetherPortals Config

### 10.3 Overworld Containerの扱い

Main Overworld Container内のうち、Resource Dimension以外をResetする。

標準方式はContainer全体をBackupへ移動し、Resource Dimensionだけを新Containerへ復元してからMainを起動する。

Root-levelで次がReset対象に含まれる可能性がある。

- `level.dat`
- `level.dat_old`
- `uid.dat`
- `region`
- `entities`
- `poi`
- `data`
- `playerdata`
- `advancements`
- `stats`
- `session.lock`
- Overworld Paper World Config
- Persistent Dimension Data

ただし実際のDirectory構造を確認して決定する。

Resource Namespaced DirectoryをReset対象へ含めない。

---

## 11. 初回Generation

1. Resource Directory復元とHash確認を完了する。
2. Mainだけを起動する。
3. PaperがMain Overworld、Nether、Endを生成することを確認する。
4. BetterStructuresがWorldEdit 7.4.4を解決して完全初期化することを確認する。
5. `103 Default Structures`が認識されることを確認する。
6. Persistent 3 Dimensionの実Seedを確認する。
7. Seedが承認値と一致しない場合は直ちにMainを正常停止し、Playerを接続せずRollbackする。
8. Resource 3 Dimensionが再生成されず、既存UUID／Seed／Dataを維持していることを確認する。
9. Mainを正常停止する。
10. 新規生成されたPath、File Count、SeedおよびUUIDを記録する。

初回GenerationでVelocityを起動しない。

通常Playerを接続しない。

BetterStructures Pregeneration Commandを使用しない。

---

## 12. Spawn選定

## 12.1 Main Overworld

初回Generation後、Temporary AdminでMainへ入り、Spawn候補を調査する。

条件：

- 固体Block上
- 十分なHeadroom
- 水中ではない
- Lava／Powder Snow／Void／洞窟内ではない
- 落下Riskが低い
- 初回Join時に窒息しない
- Main Spawn Hubを建築できる連続した空間がある
- Lobby、Frontier、Resource 3 Gateを配置できる
- BetterStructures Spawn Protection範囲と整合する
- 既存Structureを破壊しなくてもHubを建築できる
- 極端に高い山頂や狭い谷底を避ける
- 通常Survival開始地点として成立する

Codexは最大3候補を提示する。

各候補について記録する。

- X／Y／Z
- Biome
- 地形概要
- おおよその整地必要量
- 水辺／洞窟／崖Risk
- BetterStructuresとの距離
- Hub建築適性
- Screenshotを取得できる場合は保存場所
- 推奨順位

ユーザーが候補を承認するまで、正式Spawnを確定しない。

候補提示後、ユーザーから次のいずれかを受け取る。

- 候補番号
- 別座標
- 再調査指示

Spawn承認待ちの間もWorld Dataを削除しない。

## 12.2 Main Spawn設定

承認後：

- Vanilla World Spawnを承認座標へ設定する。
- MultiverseのMain Spawnを同じ安全地点へ設定する。
- Respawn Radiusを確認する。
- Normal Playerの初回Spawnと、BedなしDeath Respawnが安全地点になることを確認する。
- Main Hubは建築しない。
- Gateは作成しない。

Hub建築前のため、最小限の安全確保だけを行う。

自然地形が危険な場合、ユーザー承認を得て一時的な小規模Safety PlatformまたはBarrierを配置してよい。

無断で恒久Hubを建築しない。

## 12.3 Main Nether

Main NetherのMultiverse Spawnを安全な自然地点へ設定する。

確認：

- Block内ではない
- Lava内ではない
- 高所落下しない
- Bedrock内ではない
- 十分なHeadroom
- 最低限の退避空間
- `/mvtp`相当の管理移動で安全

恒久GateまたはHubを建築しない。

## 12.4 Main End

Main EndのMultiverse Spawnを安全な地点へ設定する。

確認：

- Block内Spawnなし
- 窒息なし
- Void即落下なし
- Dragon Fightを不必要に開始・完了させない
- Default Obsidian Platformまたは安全なMain Island地点を利用
- `/mvtp`相当の管理移動で安全

過去のMain End直接Spawn窒息問題を解消する。

Resource End外周島Bootstrapは本タスクの対象外。

---

## 13. 限定Generation範囲

大規模Pregenerationを行わない。

生成してよい範囲：

- Paperが自動生成するSpawn周辺
- Spawn候補確認に必要な限定Chunk
- Nether／End安全Spawn確認に必要な限定Chunk
- BetterStructuresが正常に動作することを確認するための少量の新規Chunk

Phase 2で既にBetterStructures自然生成を確認済みであるため、本タスクでStructureを探すための広範な探索は不要。

World Borderを変更しない。

Chunk Pregenerator Pluginを追加しない。

BetterStructures `/bs pregenerate`を本タスクで使用しない。

---

## 14. 受入確認

## 14.1 Destructive Boundary

- ユーザー承認文を取得済み。
- 承認内容と実行内容が一致。
- Backup確定済み。
- Persistent 3 Dimensionだけが置換対象。
- Resource 3 Dimensionは保持。
- Lobby／Frontierは未変更。
- Player Data Policyが承認どおり。
- Seedが承認どおり。
- BetterStructures Spawn Protectionが承認どおり。

## 14.2 Backup

- Backup Directoryが存在。
- `.incomplete`から確定済み。
- File Count一致。
- Byte Total一致。
- SHA-256 Manifest作成済み。
- Persistent旧Worldを復元可能。
- Resource旧Dataを復元可能。
- Config Backupあり。
- Backupを削除していない。

## 14.3 Persistent Generation

- Main Overworld新規生成。
- Main Nether新規生成。
- Main End新規生成。
- 3 DimensionのSeedが承認値と一致。
- Bukkit実World名が設計どおり。
- Multiverse Keyが設計どおり。
- BetterStructures有効Worldが設計どおり。
- Main Endは通常Dragon Policy。
- Phase 2試験Chunkが新Baselineへ混入していない。

## 14.4 Resource Preservation

Resourceごとに確認する。

- World UUID不変
- Seed不変
- File Count／Byte Totalが合理的に一致
- 代表Region File SHA-256不変
- 代表ChunkのBlock／位置が維持
- Multiverse登録維持
- Nether／End Link維持
- BetterStructures無効
- Resource End Dragon Policy維持
- Resource Worldを新規生成していない

Main起動によりMetadata Timestamp等の最小変更が発生した場合は、変更Fileを特定し、World Contentが変わっていないことを説明する。

不明な差分がある場合はBlockingとする。

## 14.5 Spawn

- Main Overworld Spawnをユーザー承認済み。
- 初回Spawn安全。
- BedなしRespawn安全。
- Main Nether管理Spawn安全。
- Main End管理Spawn安全。
- Main End窒息なし。
- Hub／Gate未実装。
- Temporary Safety Structure以外の建築なし。

## 14.6 Plugin Boundary

- BetterStructures 2.6.3正常Enable。
- 103 Default Structures version 5認識。
- WorldEdit 7.4.4 Dependency解決。
- Persistent Mainだけ有効。
- Resource無効。
- Unknown World無効。
- 自動Plugin Download無効。
- 既知のlegacy bed DataFixer Message以外に起動阻害ERROR／SEVERE／Exceptionなし。

## 14.7 Restart

Mainを正常Restartする。

Restart後：

- Seed不変
- Spawn不変
- Multiverse Spawn不変
- Resource保持
- Multiverse Link維持
- BetterStructures Scope維持
- Main End安全
- Startup Blocking Errorなし

必要に応じてVelocity経由でMainへ1回接続し、承認済みMain Spawnへ安全に到着することを確認する。

Network全体の広範なRegression Testは行わない。

確認不要：

- EconomyShopGUI全取引
- mcMMO全Skill
- TAB全表示
- Frontier Theme
- 全BetterStructures Structure
- 全Loot
- 全Biome
- Resource Reset
- Portal Routing
- Backup／Restore全体

---

## 15. Rollback

次の場合はRollbackする。

- Seed不一致
- Resource Data変更
- Resource World再生成
- Persistent World Path誤認
- Main起動失敗
- BetterStructures起動阻害
- World UUID衝突
- Multiverse Link破損
- Main End生成異常
- Backup不完全
- Player Data Policy違反
- 承認範囲外のDirectory変更

Rollback手順：

1. Player接続を止める。
2. 全Minecraft Componentを正常停止する。
3. 新規生成Persistent WorldをQuarantineへ移動する。
4. Backupから旧Main Container／Nether／Endを元のExact Pathへ戻す。
5. Resource DataをBackup時点へ戻す。
6. ConfigをBackup時点へ戻す。
7. File Count／Byte Total／SHA-256を確認する。
8. Mainを起動する。
9. 旧Seed、旧Spawn、Resource WorldおよびLinkを確認する。
10. 原因と現在状態を報告する。

Rollback Backupを削除しない。

失敗を広い削除や新規Seed再試行で誤魔化さない。

---

## 16. Repository更新

## 16.1 Tracked Config

実態に合わせて更新候補を確認する。

- `servers/main/server.properties`
- `servers/main/plugins/Multiverse-Core/worlds.yml`
- Main／Dimension別のTracked Paper Config
- BetterStructures Config
- BetterStructures ValidWorlds

変更が不要なFileを整形だけで書き換えない。

Multiverseの`read-only`項目を手動で推測更新しない。Runtimeが正常に保存した値を確認する。

## 16.2 新規正本文書

次を作成することを推奨する。

```text
docs/13-main-world-baseline.md
```

最低限記載する。

- Phase 3実施日
- Git HEAD
- Main Paper Version／Build
- Java Version
- Seed
- Seed Policy
- Player Data Policy
- BetterStructures Version
- Content Pack
- Spawn Protection Radius
- Persistent Bukkit World名
- Persistent Multiverse Key
- Persistent実Storage Path
- Resource実Storage Path
- Main Overworld Spawn
- Main Nether管理Spawn
- Main End管理Spawn
- World UUID
- Backup Path
- Backup Manifest SHA-256
- Resource保持確認
- Known legacy bed Message
- Main End Policy
- 未実装Hub／Gate
- Rollback手順
- 次のPhase

World Data、Player DataおよびBackupそのものをCommitしない。

## 16.3 既存文書

必要な範囲だけ更新する。

- `README.md`
- `AGENTS.md`
- `docs/00-design-guide.md`
- `docs/01-architecture.md`
- `docs/02-installation.md`
- `docs/03-operations.md`
- `docs/04-play-guide.md`
- `docs/06-acceptance-tests.md`
- `docs/09-roadmap.md`
- `docs/13-main-world-baseline.md`
- `codex/README.md`
- `versions.yml`
- `plugin-manifest.yml`

ManifestにWorld Data自体を列挙しない。

記録候補：

- Main Final Seed
- Bukkit World名
- Spawn座標
- Generation Date
- BetterStructures Generation Baseline
- Player Data Reset Policy
- Backup Manifest
- Resource Preservation
- Phase 3 Status

### Roadmap

Phase 3を実施結果に基づき完了へ更新する。

次のPhase：

```text
Phase 4 - EvenMoreFish
```

Phase 1Bは引き続き未完了であり、BuilderによるHub／Gate／Theme接続作業前に実施する。

### Acceptance Tests

完了候補：

- Exact Path承認
- Backup／Manifest
- Seed
- Persistent 3 Dimension新規生成
- Resource保持
- BetterStructures Scope
- Main Spawn安全
- Main Nether安全
- Main End安全
- Restart
- Rollback可能性

未確認項目を完了扱いしない。

---

## 17. Git除外

確認する。

- `servers/main/main/`
- Main Nether実World Path
- Main End実World Path
- Resource World Path
- `backups/`
- `*.mca`
- Player Data
- Advancements
- Stats
- Session Lock
- Logs
- Crash Reports

新しい実World Pathが既存`.gitignore`で除外されない場合、Exact Pathを追加する。

過剰なWildcardでTracked Configを隠さない。

---

## 18. Cleanup

Commit前に確認する。

- Temporary Admin Parent解除
- OPなし
- Test Permissionなし
- Playerは通常状態
- Pregeneration Taskなし
- World Border変更なし
- Temporary Seedなし
- Temporary Worldなし
- Quarantine残留の有無を記録
- Backup保持
- Resource Hash確認済み
- Main正常状態
- Velocity接続確認後は正常停止または通常運用状態
- World／Backup／Player DataがStageされていない
- `codex/README.md`追加済み
- Phase 3指示書を`codex/`へ保存済み

---

## 19. Commit前確認

実行する。

```powershell
git status --short
git diff --check
git diff --stat
git diff
```

Repositoryに存在する検査Scriptだけを使用する。

YAML／JSONを変更した場合は安全なParserで構文確認する。

確認：

- Secretなし
- Player名／UUIDなし
- World Dataなし
- Backupなし
- Region Fileなし
- Logなし
- Main Final Seed記録あり
- Spawn座標記録あり
- Resource保持記録あり
- Phase 3完了条件が実態と一致
- Phase 4を実装済みと書いていない
- Phase 1Bを完了扱いしていない
- Hub／Gateを完成扱いしていない
- CoreProtectを導入済みと書いていない
- V0.1.0をRelease済みと書いていない
- `codex/`を正本と記載していない
- 無関係なRegression Test結果なし

---

## 20. Commit／Push条件

次をすべて満たした場合だけCommit／Pushする。

- ユーザーの明示承認取得
- Seed承認
- Player Data Policy承認
- Spawn Protection承認
- Exact Path承認
- Backup確定
- Backup Manifest／SHA-256完成
- Persistent 3 Dimension新規生成
- Seed一致
- Resource 3 Dimension保持
- Resource UUID／Seed／代表Data一致
- BetterStructures Scope正常
- Main Overworld Spawnユーザー承認
- Main Nether Spawn安全
- Main End Spawn安全
- Main End窒息解消
- Restart成功
- Rollback可能
- World／Backup／Player Data Git非追跡
- 文書／Manifest更新
- `codex/README.md`追加
- Phase 3指示書保存
- `git diff --check`成功
- Repository検査成功
- Cleanup完了

Blockingな失敗時：

- Commitしない。
- Pushしない。
- 新WorldをProductionとして公開しない。
- Resource差分を許容しない。
- Backupを削除しない。
- 別Seedで無断再試行しない。
- World Pathを手作業で推測修正しない。
- 失敗内容、現在Path、Backup、Resource状態、Rollback結果を報告する。

推奨Commit Message：

```text
feat: Main恒久Worldを最終生成
```

Commit後に内容を再確認し、Current BranchをremoteへPushする。

禁止：

- Force Push
- History Rewrite
- 無関係変更のCommit
- EvenMoreFishの同時導入
- CoreProtectの同時導入
- Hub／Gate作業の同時実装
- Builder Phase 1Bの同時実装

---

## 21. 完了報告

完了時に次を報告する。

- 作業開始時HEAD
- ユーザー承認内容
- Seed
- Seed Policy
- Player Data Policy
- BetterStructures Spawn Protection
- Persistent Bukkit World名
- Persistent Storage Path
- Resource Storage Path
- Backup Path
- Backup Manifest／SHA-256
- Main Overworld UUID／Seed
- Main Nether UUID／Seed
- Main End UUID／Seed
- Resource UUID／Seed保持結果
- Resource代表Hash結果
- Main Overworld Spawn
- Main Nether Spawn
- Main End Spawn
- BetterStructures起動結果
- Known legacy bed Message
- Restart結果
- Rollback状態
- 変更ファイル
- `codex/README.md`内容
- 実行した検査
- Temporary Admin Cleanup
- Commit SHA
- Push先Branch
- 残課題
- 次のPhaseがEvenMoreFishであること
- Phase 1BがBuilder作業前に残っていること

Player名、UUID、Credential、World Dataそのものは完了報告へ記載しない。
