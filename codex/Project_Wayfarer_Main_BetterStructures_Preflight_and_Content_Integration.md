# Project Wayfarer Main BetterStructures Preflight・Content統合 指示書

## 1. 目的

Project Wayfarer Ver.0.0.6 Roadmapの次の2工程を、一つの非破壊Taskとして実施する。

```text
Order 2:
Main BetterStructures Artifact／Content／Resource Pack Preflight

Order 3:
Main full Content Import and load confirmation
```

本タスクでは、Main向けBetterStructures 5 Pack構成、BetterStructures Prop Pack、FreeMinecraftModelsおよびResourcePackManagerについて、Artifact監査、License／Version／Hash Lock、Runtime Working Copy生成、Structure選定、Prop ID正規化、Content Import、Resource Pack生成・配信Preflightおよび正常Load確認まで行う。

本タスクは、**Persistent Main Familyの再生成直前で停止する。**

本タスクでは以下を行わない。

- `main`、`main_nether`、`main_the_end`の生成、再生成、削除、Trim、Rename、Region削除またはSeed／UUID変更
- Resource Familyの生成、再生成、削除または変更
- 未生成Chunkへ移動して自然生成を試すこと
- Chunk Pregeneration
- CoreProtect導入
- Hub／Gate建築
- Main Spawn WorldGuard Region作成
- FrontierへのBetterStructures導入
- EliteMobs導入
- Frontier Resource Pack作成
- Custom Plugin開発
- Database Migration
- V0.1.0 Pre-release Player State Reset

完了時には、次の破壊的TaskでMain Persistent Familyを再生成してよいかを判定できる証拠を揃える。

---

## 2. 推奨実行モデル

このTaskは二つの内部段階を持つ。

```text
Phase A:
Artifact／License／Compatibility／Hosting／Mapping Lock

Phase B:
Working Copy生成、Config生成、Plugin／Content統合、Load確認
```

Phase Aで必要なArtifactまたは設計判断が不足した場合、Phase Bへ進まず停止する。

Phase AとPhase Bを別のCodex指示書へ分割しない。必要Artifactがユーザーにより追加された後は、同じ割り当て済みTaskを、現行Git状態と前回報告を再確認したうえで再開してよい。

ただし、一度完了・Commit済みとなった本Taskをそのまま再実行してはならない。

---

## 3. Repository

```text
eariver/Project_Wayfarer
```

作業対象は、VS Codeで開かれているProject Wayfarer Repository Root内だけとする。

作業開始時：

```powershell
git status --short
git branch --show-current
git remote -v
git log -5 --oneline
```

以下を確認する。

1. Repository Rootである。
2. Configured Upstreamが意図したRemoteである。
3. 意図不明な未Commit変更がない。
4. 最新の`AGENTS.md`とVer.0.0.6正本文書を読んでいる。
5. Concept本文を非正本の詳細設計入力として確認している。
6. 現在のMain World Baselineが引き続き現行Runtime正本である。
7. Main Runtimeが停止可能な状態である。
8. Playerが接続していないことを、Runtime操作前に確認できる。

最新の整合性修正Commitが履歴に存在すること。

```text
956252f38a433ec350b42a02d7b0606963047a71
docs: Ver.0.0.6文書の整合性を修正

9c3239ca69f55d07c54646f6c92a1533360a3142
docs: Ver.0.0.6整合性修正Commitを記録
```

---

## 4. 正本と設計入力

### 4.1 現行正本

最低限：

```text
AGENTS.md
docs/00-design-guide.md
docs/01-architecture.md
docs/02-installation.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/08-plugin-collection.md
docs/09-roadmap.md
docs/12-permission-model.md
docs/13-main-world-baseline.md
versions.yml
plugin-manifest.yml
THIRD_PARTY.md
```

### 4.2 詳細設計入力

```text
concepts/main/Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md
```

Concept本文は変更しない。

Concept内の旧実装順：

```text
World再生成
→ Content Import
```

は採用しない。

Ver.0.0.6正本の順序：

```text
Artifact検証
→ Runtime Working Copy
→ Structure選定Config
→ Prop／Model ID正規化
→ 全Plugin／Content Import
→ Allowlist／Content Load／Resource Pack Preflight
→ 正常Load確認
→ 別TaskでMain Persistent Family再生成
```

を優先する。

---

## 5. Main正式Scope

### 5.1 Structure Content

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack internal version 1
Echoes of the Past version 3
```

### 5.2 Model／Resource Pack

```text
BetterStructures Prop Pack
FreeMinecraftModels 2.10.2
ResourcePackManager
```

### 5.3 Mainの役割境界

Mainでは次を使用しない。

- EliteMobs
- Elite Shrine
- Dungeoneering Modules
- Custom Boss
- EliteMobs Equipment／Currency／Quest
- Frontier Theme固有Item
- LeafGrapple Asset
- Worlds Beyond Asset

Main Resource PackにFrontier専用Assetを含めない。

---

## 6. World境界

BetterStructuresを有効にする実Bukkit World名：

```text
main
main_nether
main_the_end
```

無効：

```text
resource
resource_nether
resource_end
その他すべての未知World
```

維持するBaseline：

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

`main_end`はMultiverse Aliasであり、BetterStructures Allowlist、Filesystem Pathまたは実World名として使用しない。

本Task中に新しいWorld名が発見された場合、自動認可せず無効として扱い、報告する。

---

# Phase A — Artifact／設計Lock

## 7. Artifact取得ポリシー

`AGENTS.md`の手動取得方針に従う。

Codexは次を自動Downloadしない。

- Plugin JAR
- 有料Content
- 無料Content Pack ZIP
- BetterStructures Prop Pack
- `.schem`
- `.bbmodel`
- Server Binary
- Resource Pack Binary

ユーザーがArtifactを、Repository内のIgnoredなTask専用Staging Directoryへ配置する。

推奨：

```text
manual-downloads/main-betterstructures-v006/
```

実際の既存運用が異なる場合は、Repository内のIgnored Pathを使用してよい。

必要Artifactが欠落、重複、破損、Version不明、Platform不一致またはHash不一致の場合：

1. 自動取得しない。
2. Runtimeを変更しない。
3. 欠けているExact Artifactを列挙する。
4. 公式配布元、必要Version、期待File種別、確認済みHashを報告する。
5. Phase Bへ進まず停止する。

---

## 8. 確認済み設計値との照合

Conceptに記録された期待値：

| Artifact | 内部Version | 数量 | 期待SHA-256 |
|---|---:|---:|---|
| 103 Default Structures | 5 | 103 Schematics | `118D873FDF87BF94EA6CA3036897B10790F5D73E62F8387E75C1AB6A4A360FE0` |
| Exploration Pack | 6 | 49 Schematics | `963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B` |
| Caves and Lost Civilizations Free | 2 | 49 Schematics | `27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677` |
| Adventure Pack | internal 1 | 107 Schematics | `96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C` |
| Echoes of the Past | 3 | 122 Schematics | `B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F` |
| BetterStructures Prop Pack | — | 55 Models | `F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D` |
| FreeMinecraftModels JAR | 2.10.2 | — | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` |

これらは設計入力であり、実Artifactを再計算して一致を確認する。

一致しない場合：

- 直ちに不正と断定しない。
- 配布元更新、再圧縮、File名変更、内部Version変更の可能性を調査する。
- 公式Source、取得日、内部Metadata、Content数、Hash差異を報告する。
- ユーザー承認なしに新Artifactへ置換しない。
- 有料Artifactの内容やBinaryをGitへ記録しない。

Adventure Packは販売ページのRelease表示とArtifact内部`version: 1`が異なる可能性がある。両方を記録する。

---

## 9. License／再配布条件

各Artifactについて最低限次を記録する。

- 正式名称
- 公式配布元
- 作者／Vendor
- 取得経路
- Version
- 内部Version
- Platform
- Licenseまたは利用条件
- 再配布可否
- 改変可否
- Server利用可否
- 生成Resource PackへのAsset統合可否
- SHA-256
- 取得日
- Git追跡可否
- Runtime配置先

有料Pack、Schematic、Model、変換済みWorking Copyおよび生成Resource PackはGit非追跡とする。

RepositoryのMIT Licenseで第三者Artifactを再許諾しない。

必要に応じて`THIRD_PARTY.md`へ、Artifactそのものを含めず、名称、権利者、配布元および適用条件への参照だけを追加する。

Licenseが不明、相互矛盾または生成Pack配信を許可するか不明の場合、Phase Bへ進まず停止する。

---

## 10. ResourcePackManager Lock

ResourcePackManagerの正確な採用Versionが未Lockであるため、公式Sourceだけを使用して調査する。

確認する。

- 正式Plugin名
- 作者
- 公式配布元
- 最新だけでなくPaper 26.2との互換性
- Java 25
- FreeMinecraftModels 2.10.2との統合
- BetterStructures Prop Packとの統合
- Resource Pack生成方法
- Hosting方式
- SHA-1／SHA-256等、Minecraft Clientへ渡すHash形式
- Clientへの配信方法
- Pack必須設定
- Client拒否時の挙動
- Download失敗時の挙動
- Server／Backend切替時のReload
- Cache更新
- Rollback
- 自動Update
- 必須Dependency
- Port／Firewall要件
- 外部Account／外部Hosting要件
- License

Codexは公式文書を調査してよいが、JARを自動Downloadしてはならない。

### 10.1 bounded selection rule

次の条件をすべて満たす候補が一つだけ存在する場合、Codexはその候補を推奨VersionとしてLockしてよい。

- 公式配布である。
- Paper 26.2または対象APIへの互換性根拠がある。
- Java 25で利用可能。
- FMM／BS Prop Pack統合に必要な機能がある。
- 外部有料Accountを要求しない。
- OS／Firewall／Routerの変更を要求しない。
- Backend Portを外部公開しない。
- Plugin自動更新を無効化できる。
- Repository外への書込みを要求しない。
- Licenseが確認できる。

候補が複数、互換性不明、外部Hosting契約が必要、Port公開が必要、または既存Network設計へ影響する場合は、比較表と推奨案を提示してユーザー判断を待つ。

ユーザー判断前にJAR配置、Port公開、Firewall変更または恒久Hosting設定を行わない。

---

## 11. Resource Pack Hosting境界

Preflightでは、外部公開を伴わない安全な方法を優先する。

許容候補：

- ResourcePackManager自身の安全な既定方式
- 既存のRepository内／Runtime内生成物を、Loopbackまたは既存承認済み経路だけで配信する方式
- 将来の正式Hostingへ置換可能な再現手順

禁止：

- Backend Paper Portの外部公開
- Firewall自動変更
- Router自動設定
- CredentialをGitへ保存
- 未承認のCloud Storage Account作成
- 個人Tokenの要求または記録
- Public Bucketの自動作成
- Hashなし配信
- 自動生成PackのGit Commit

Local Clientでのみ検証可能なHostingは、Preflight用と明記し、V0.1.0正式Hostingと混同しない。

正式Hosting方式が未確定でも、Pack生成、Hash計算、Local配信およびClient読込を安全に検証できるなら、正式Hostingだけを残件として報告してよい。ただし、Main再生成開始前に必要なBlocking条件かを明示する。

---

## 12. Phase A成果物

Repositoryへ追跡可能な情報として、既存構成に適合するPathへ次を作成または更新する。

推奨：

```text
docs/investigations/<date>-main-betterstructures-artifact-preflight.md
```

内容：

- Artifact監査表
- 実測SHA-256
- 内部Version
- Content数
- 公式Source
- License
- ResourcePackManager選定
- Hosting方式
- 未解決事項
- Phase B進行可否
- Git非追跡確認

Task専用のRaw Artifact一覧、秘密情報、購入情報、個人情報または有料File内容を記載しない。

---

# Phase B — Working Copy／統合／Load確認

## 13. Phase B開始条件

次をすべて満たす場合だけPhase Bへ進む。

- 全ArtifactがRepository内Ignored Stagingに存在する。
- Hash、Version、Platform、Source、Licenseが確認済み。
- ResourcePackManager候補がLock済み。
- ResourcePackManager JARをユーザーが手動配置済み。
- Hosting Preflight方式が決定済み。
- `shelf4`／`ladder` Mappingを決定可能なModel情報がある。
- Main Runtimeを安全に停止できる。
- Playerが接続していない。
- 意図不明なGit差分がない。
- 現行Main BaselineとRollback情報が確認できる。

一つでも満たさない場合は停止する。

---

## 14. Pre-change Snapshot

Runtime変更前にMainを正常停止する。

Velocityを停止し、MainへのPlayer接続経路を閉じる。Backend Portを公開しない。

IgnoredなTask専用Backupへ、変更対象のConfig／Plugin Dataだけを保存する。

最低限候補：

```text
servers/main/plugins/BetterStructures/
servers/main/plugins/FreeMinecraftModels/
servers/main/plugins/ResourcePackManager/
servers/main/server.properties
Main Multiverse Config
Main Multiverse-NetherPortals Config
関連するResource Pack Config
```

存在しないPathは「未導入」と記録する。

このTaskではWorld Dataを変更しない。現行Main World Baselineと既存Rollback Backupを削除、移動または置換しない。

Snapshotに以下を記録する。

- Timestamp
- Git HEAD
- File count
- Byte total
- SHA-256 Manifest
- 対象Path
- 復元手順

BackupはIgnoredとしGitへ含めない。

---

## 15. Original ArtifactとWorking Copy

原本ArtifactはRead-only Sourceとして扱う。

推奨Ignored構成：

```text
local/work/main-betterstructures-v006/
├─ original/
├─ extracted/
├─ normalized/
├─ generated/
├─ reports/
└─ logs/
```

既存のIgnored作業構成がある場合はそれへ合わせる。

原則：

1. Staging Artifactを`original/`へCopyする。
2. OriginalのHashを再確認する。
3. Originalを直接編集しない。
4. Extract／Normalize／Import対象をWorking Copyとして生成する。
5. Scriptを再実行して同じ出力を作れるようにする。
6. Working Copyと生成物はGit非追跡。
7. 有料ArtifactのPath、内容、File名一覧を必要以上に公開文書へ記載しない。

---

## 16. Structure選定

Concept V0.0.2のDimension別選定とWeightを実装する。

最終有効Schematic数の設計値：

| Dimension | Default | Exploration | Caves | Echoes | Adventure | 合計 |
|---|---:|---:|---:|---:|---:|---:|
| Overworld | 67 | 20 | 24 | 64 | 16 | 191 |
| Nether | 18 | 4 | 5 | 14 | 3 | 44 |
| End | 18 | 5 | 4 | 12 | 4 | 43 |
| 合計 | 103 | 29 | 33 | 90 | 23 | 278 |

次のいずれかで再現可能にする。

- Tracked Selection Manifest＋生成Script
- Tracked Transformation Script
- Tracked Allowlist／Weight Overlay
- Vendor Configを直接追跡せず、再生成可能なPatch定義

推奨Tracked成果物：

```text
scripts/Prepare-MainBetterStructuresContent.ps1
config/main-betterstructures/selection.yml
config/main-betterstructures/weights.yml
```

Repository既存規約により、より適切なPathがあれば変更してよい。

必要要件：

- Internal IDのExact Match
- Wildcardを曖昧に展開しない
- Pack／Dimension／Structure Typeを区別
- 選定件数を検証
- 無効対象を明示
- MainにRuined Frontier優先Contentを誤Importしない
- 入力ArtifactのVersion／Hashが違えばFailする
- 生成結果に未知IDがあればFailする
- Concept記載IDが入力に存在しなければFailする
- 実行結果をReportする

Concept本文をParserの唯一の入力にしない。選定内容を明示的なMachine-readable Manifestへ転記し、Review可能にする。

---

## 17. Prop ID正規化

FreeMinecraftModels 2.10.2が`.bbmodel`由来のModel IDを完全一致で解決する前提を実Artifactで再確認する。

既知の状態：

| Pack | Prop Marker | 既知問題 |
|---|---:|---|
| Default | 214 | 一致 |
| Exploration | 116 | 旧PrefixなしID |
| Caves Free | 195 | `alchamytable` 1件 |
| Adventure | 340 | `alchamytable`, `shelf4` 各1件 |
| Echoes | 260 | `ladder` 1件 |

正規化：

```text
旧PrefixなしID
→ bs_prop_pack_<id>

alchamytable
→ bs_prop_pack_alchemy_table
```

`shelf4`と`ladder`は、Schematic内の位置、向き、寸法、周辺Blockおよび候補Modelを確認して、既存Modelへ明示Mappingする。

推測で最も似た名前へ置換しない。

Mappingが一意に決まらない場合：

1. Schematic Binaryを公開せず、候補、位置、寸法、向き、差異を報告する。
2. 該当Structure IDを示す。
3. 当該Structureを一時無効にする案とMapping候補を示す。
4. ユーザー判断までPhase Bの完了判定を保留する。

Tracked成果物候補：

```text
config/main-betterstructures/prop-id-mapping.yml
scripts/Normalize-BetterStructuresProps.ps1
```

Script要件：

- Original Artifactを書き換えない。
- 入力Hashを検証。
- 置換前後の件数を報告。
- 未解決IDがあれば非Zero Exit。
- 既知ID以外を勝手に置換しない。
- 変換ScriptとMappingのSHA-256を記録。
- 有料変換済みArtifactをGitへ含めない。
- 将来Frontier Working Copyでも再利用可能な一般Mappingと、Main固有選定を分離する。

---

## 18. Schematic Entity監査

購入版Adventure／Echoes等に含まれる通常Entityを監査する。

最低限分類：

- Prop Armor Stand
- Zombie
- Skeleton
- Bat
- Item
- Projectile
- Vehicle
- その他Entity
- Spawn Signとの重複候補

Tracked Script候補：

```text
scripts/Test-BetterStructuresSchematicEntities.ps1
```

またはRepository内で再現可能な同等Script。

要件：

- `.schem`のBinaryをGitへ含めない。
- FileごとのEntity TypeとCountをReport。
- Position、Rotation、Persistence関連Tagを可能な範囲で確認。
- Prop Armor Standと通常Entityを区別。
- Unsupported FormatをFailまたは明示的なUnknownにする。
- Sponge Schematic v2／DataVersion 2865を識別。
- Originalを変更しない。

本Taskでは、通常Entityを一律除去しない。

次の場合はMain再生成のBlocking事項として報告する。

- 大量Persistent Entity
- Item／Projectileの保存
- Spawn Signとの明白な二重Spawn
- 読取不能なEntity Data
- 不明なCustom Entity
- 安全性またはTPS Riskを評価できない

除去変換が必要な場合は、別の明示承認または本Task中のユーザー判断を得る。自動で削除しない。

---

## 19. 旧Schematic形式監査

代表対象：

```text
Default:
  cistern_nether

Exploration:
  watertemplesmall_end

Adventure:
  largewatertemple_nether

Echoes:
  seatemple variants
  tower_desert
  temple_desert
```

確認：

- Format
- DataVersion
- WorldEdit 7.4.4での読取
- Block Palette
- Container
- Spawner
- Entity
- Prop Marker
- Portal Block
- 明白な変換Error

本TaskではPersistent WorldへPasteしない。

必要なら、Repository内のIgnoredな隔離検証領域でClipboard Parseまで行う。新しい恒久Worldを生成しない。

一時的な検証WorldやPasteが不可欠になった場合は、自動作成せず、Exact Path、目的、削除方針、Persistent Mainと無関係であることを説明してユーザー承認を待つ。

---

## 20. BetterStructures Config

現在の導入済みBetterStructures 2.6.3を維持する。

確認・設定：

- Plugin Auto Download無効
- Auto Update／Binary Replacement無効
- `New worlds spawn structures: false`
- Main三次元だけ有効
- Resource Family無効
- Unknown World無効
- `spawnProtectionRadius: 100`維持
- EliteMobs Region Integration無効
- MainにEliteMobs ContentをImportしない
- `main_end` AliasをAllowlistへ入れない

Tracked Runtime Configは既存Pathを使用する。

```text
servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
```

Vendor生成Data、Cache、Imported SchematicおよびSession DataはGit非追跡とする。

---

## 21. FreeMinecraftModels導入

ユーザー提供の正式JARを確認し、Main Paperだけへ配置する。

禁止配置：

- Velocity
- Lobby
- Frontier

確認：

- Version 2.10.2
- JAR Metadata
- Platform
- Java 25
- Paper 26.2
- Dependency
- SHA-256
- License
- Enable
- Model Import
- Resource Pack出力
- 起動阻害Errorがないこと

Mainでは一般Player向け家具Menu／Shopを採用しない。

正確なConfigまたはPermission方式を、FMM 2.10.2の公式文書と生成Configで確認する。

一般Playerへ新しい管理権限を付与しない。Phase 1Bを実施しない。

FMM管理権限はTemporary Adminだけが持つ現行全権限境界に従う。

---

## 22. ResourcePackManager導入

ユーザー提供のLock済みJARを確認し、承認された配置先へ置く。

原則としてMain用配信をMain Backendへ限定する。公式設計上Proxy Componentが必要な場合は、既存Network境界と配置を確認し、Taskの明示範囲を超える場合は停止する。

設定：

- Main専用Pack
- FMM出力
- BetterStructures Prop Pack
- Mainで採用したAssetだけ
- EliteMobs Assetなし
- LeafGrapple Assetなし
- Worlds Beyond Assetなし
- 自動Update無効
- CredentialはIgnored Config
- Generated PackはIgnored
- Hashを生成・記録
- Rollback可能
- Client拒否／失敗挙動を記録

外部公開Port、Firewall、Router、Cloud AccountまたはOS設定変更は行わない。

---

## 23. Content Import

Working Copyから、Mainの5 Pack、Prop Packおよび必要ModelだけをImportする。

原本Artifactから直接Importしない。

Import前に再確認：

- Input Hash
- Selection Manifest Hash
- Mapping Hash
- Output件数
- 278有効Schematic
- 無効対象
- 未解決Prop IDなし
- 不明Content Packageなし
- EliteMobs Contentなし
- Frontier Contentなし
- Resource Family無効

有料Artifact、Schematic、Model、Import ZIPおよび生成PackはGit非追跡。

Import後に、BetterStructuresが5 Packを認識することをLog／Runtime Metadataで確認する。

---

## 24. Runtime Load Preflight

### 24.1 起動境界

Player接続を防いだ状態でMainを起動する。

推奨：

1. Velocityを停止。
2. Mainへ直接接続できないLoopback Bindを確認。
3. Playerがいないことを確認。
4. Mainだけを正常起動。
5. Spawn周辺を含め新しいChunkを意図的に生成しない。
6. Test後は正常停止。

Lobby／Frontierを起動する必要がなければ起動しない。

### 24.2 確認

- BetterStructures Enable
- WorldEdit Dependency
- 5 Pack認識
- 278選定結果
- FreeMinecraftModels Enable
- Prop Pack認識
- ResourcePackManager Enable
- Main Pack生成
- Pack Hash
- Config Load
- Resource Family無効
- Unknown World無効
- Auto Download無効
- Auto Update無効
- 未解決Model IDなし
- Duplicate Content IDなし
- Duplicate Model IDなし
- YAML Parse Errorなし
- Startup-blocking ERROR／SEVERE／Exceptionなし
- World Dataを生成・削除していない
- Existing Main Seed／UUID／Spawnが変化していない

### 24.3 Log分類

既知の`minecraft:bed` DataFixer Messageは、現在の103 Default Structures Baselineと同じ既知条件かを確認する。

新しいPack由来Error、Model未解決、Schematic Parse失敗、Duplicate ID、Entity Parse ErrorまたはResource Pack生成失敗を既知警告へ混同しない。

---

## 25. Resource Pack Client Preflight

Client実機確認が必要な場合、CodexはユーザーへExact手順を提示して停止し、結果を待つ。

Playerは既存の安全なMain Spawnだけで確認する。未生成Chunkへ移動しない。

最低限：

- Main接続時にPack Promptまたは必須配信が想定どおり。
- Download成功。
- Hash一致。
- Pack適用成功。
- 代表Propが正しく表示される。
- Missing Texture／紫黒表示なし。
- Client拒否時の挙動。
- Download失敗時の挙動。
- Reconnect時のCache挙動。
- MainからLobbyへ移動した場合の挙動。
- 再度Mainへ戻った場合の挙動。
- Pack容量。
- Download時間。
- Client Logの重大Error。

Frontier統合Packは未実装である。Main／Frontier最終切替試験を本Taskの完了条件にしない。

安全な代表Prop確認に既存WorldへのPasteまたは新規Chunk生成が必要な場合は、自動実行しない。隔離表示方法を提案し、ユーザー承認を待つ。

---

## 26. 再生成可否Gate

本Task完了時に、Main Persistent Family再生成Taskへ進めるかを判定する。

### PASS条件

- 全ArtifactのVersion／Source／License／HashがLock済み。
- ResourcePackManager Versionと配置がLock済み。
- Main Pack生成と安全なPreflight配信が成功。
- 5 Packが正常認識される。
- Structure Selectionが278件で再現可能。
- Prop ID未解決がない。
- `shelf4`／`ladder` Mappingが承認済み。
- Entity監査に未評価Blocking Riskがない。
- 旧Schematicを読取可能。
- Resource FamilyとUnknown Worldが無効。
- EliteMobs／Frontier AssetがMainへ混入していない。
- Main Runtimeが正常起動・停止。
- Existing Main World Identityが変化していない。
- Git追跡対象と非追跡Artifact境界が正しい。
- Rollback手順がある。
- 次の破壊的Taskへ渡すExact Input Manifestがある。

### FAIL／STOP条件

- Artifact欠落またはHash不一致未解決
- License不明
- ResourcePackManager未選定
- Hosting未決定でPreflight不能
- Prop ID未解決
- Schematic Parse Error
- 重複Content／Model ID
- Entity Risk未評価
- Main Pack生成失敗
- Resource Familyが有効
- Unknown Worldが有効
- EliteMobs／Frontier Content混入
- World Identity変化
- 新規Chunk生成
- Runtime起動阻害Error
- Gitへ有料／Binary ArtifactがStageされている

FAIL時はWorld再生成指示書を作成・実行しない。

---

## 27. Tracked成果物

成功時、最低限次を追跡する。

実際のRepository規約に合わせてPathを調整してよい。

```text
scripts/Prepare-MainBetterStructuresContent.ps1
scripts/Normalize-BetterStructuresProps.ps1
scripts/Test-BetterStructuresSchematicEntities.ps1
scripts/Test-MainBetterStructuresPreflight.ps1

config/main-betterstructures/selection.yml
config/main-betterstructures/weights.yml
config/main-betterstructures/prop-id-mapping.yml

servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
FreeMinecraftModelsのSanitized Config／Template
ResourcePackManagerのSanitized Config／Template

docs/investigations/<date>-main-betterstructures-artifact-preflight.md
docs/06-acceptance-tests.md
docs/08-plugin-collection.md
docs/09-roadmap.md
docs/13-main-world-baseline.md
versions.yml
plugin-manifest.yml
plugin-collection.csv
THIRD_PARTY.md
codex/README.md
```

全Fileを必ず新規作成するのではなく、必要な再現性を最小の明確な構成で実現する。

`docs/13-main-world-baseline.md`は、現行Baselineを置換しない。計画進捗としてPreflight完了を追記する場合も、現行Seed、UUID、Spawn、Backupを維持する。

---

## 28. Manifest更新

成功し、実際にMain Runtimeへ導入・Enable・Load確認できたComponentだけ更新する。

### `versions.yml`

記録候補：

- FreeMinecraftModels正確なVersion／Hash／Placement／Verified Date
- ResourcePackManager正確なVersion／Hash／Placement／Verified Date
- Main BetterStructures Content Set
- Content Pack内部Version／Hash
- Selection Manifest Version／Hash
- Prop Mapping Version／Hash
- Main Pack Build Input Hash
- Generated Pack Hash
- Hosting Preflight状態

### `plugin-manifest.yml`

実際に導入済みとなったPluginだけ追加する。

Content Pack、Schematic、Model BinaryをManifestへ埋め込まない。

### Runtime状態表現

次を区別する。

```text
installed-and-load-verified
preflight-only
planned
blocked
```

World再生成や自然生成受入を完了扱いにしない。

---

## 29. Roadmap／Acceptance更新

成功時：

- Roadmap Order 2を完了。
- Roadmap Order 3を完了。
- Order 4 Main Persistent Family regenerationは未完了のまま。
- Main generation acceptanceは未完了。
- Weight／Content tuningは未完了。
- New Main Baselineは未完了。
- CoreProtectは未導入。

`docs/06-acceptance-tests.md`では、Preflight／Import／Load確認だけを完了にする。

自然生成、Portal、Spawn、Loot、TPS、Client FPS、Structure Fit、Weight、Resource Family実生成除外、World再生成、Backupおよび新Baselineは未完了にする。

---

## 30. `AGENTS.md`更新

成功時、Current Project Invariantを実態へ更新する。

明記：

- BetterStructures 2.6.3に5 Packの選定Working SetがLoad確認済み。
- FMM／ResourcePackManagerが実際に導入済みならその状態。
- Main Resource PackはPreflight状態。
- Main Persistent Familyはまだ現行Baseline。
- World再生成は未実施。
- Resource Familyは無効。
- 次TaskはMain Persistent Family regeneration。
- 再生成は別途割り当てられた破壊的Taskだけが実行可能。

Phase Aで停止した場合、Runtime導入済み表現へ更新しない。

---

## 31. Git非追跡監査

Commitしてはならない。

- Plugin JAR
- Content Pack ZIP
- 有料Artifact
- Schematic
- `.schem`
- `.bbmodel`
- Model Texture
- 変換済みWorking Copy
- Generated Resource Pack
- Cache
- Runtime Session Data
- Log
- World
- Region File
- Player Data
- Backup
- Secret
- Hosting Credential
- Personal Purchase Information

確認：

```powershell
git status --short
git check-ignore -v <representative-artifact-path>
git diff --cached --name-status
```

必要なIgnore Patternを追加する場合、過剰に一般化せずTask対象Artifactへ限定する。

---

## 32. 検証

### 32.1 Script／Config

```powershell
git diff --check
.\scripts\Test-Layout.ps1
```

追加ScriptごとにSyntax／Help／Safe Dry Runを確認する。

PowerShell Scriptは：

- `Set-StrictMode`
- Error handling
- Exact Path resolution
- Repository Root boundary
- Non-zero exit on mismatch
- Dry-runまたは検査Mode
- Destructive operationなし
- Original Artifact不変
- Repeatability

を満たす。

### 32.2 YAML

既存のRepository内手段でParseする。

外部PackageをMachine-wideへInstallしない。

### 32.3 Artifact再現性

同じOriginalとManifestからWorking Copyを再生成し、件数とDigestが一致すること。

### 32.4 Runtime

- Main正常起動
- Main正常停止
- Playerなし
- Velocity停止中の直接Backend非公開
- Plugin Enable
- Content Load
- Pack生成
- Blocking Errorなし
- World Identity不変
- 新規Chunk生成を意図的に行っていない

### 32.5 Diff監査

```powershell
git status --short
git diff --stat
git diff --check
git diff --cached --name-status
git diff --cached --check
```

---

## 33. Commit／Push

### 33.1 Phase Aで停止した場合

Artifact欠落やユーザー判断待ちで停止する場合、原則としてRuntime変更をCommitしない。

有用な調査報告だけが完成し、秘密情報・有料情報・推測を含まない場合は、ユーザーへCommit可否を確認する。自動Commit／Pushしない。

### 33.2 Phase Bまで成功した場合

推奨Commit Message：

```text
feat: Main BetterStructures Contentを統合
```

または、Runtime変更がなくPreflight成果物だけの場合：

```text
docs: Main BetterStructures Preflightを完了
```

本Taskは正常Load確認まで成功した場合に限り、通常Commit／Pushする。

Force Push、Amend、Tag、GitHub Release、Branch作成、PR作成は禁止。

Codex ArchiveへCommit SHAを記録するために追補Commitが必要な場合：

```text
docs: Main BetterStructures統合Commitを記録
```

として通常Pushする。

---

## 34. Codex Archive

本指示書を次へ保存する。

```text
codex/Project_Wayfarer_Main_BetterStructures_Preflight_and_Content_Integration.md
```

`codex/README.md`へ登録する。

作業中：

```text
実施中
```

成功後：

```text
完了（実装Commit: <SHA>）
```

Phase A停止：

```text
停止（Artifact／判断待ち）
```

再実行規則：

```text
Phase A停止後は、追加Artifactと現行Git状態を再監査して同じTaskを再開可能。
完了後はそのまま再実行禁止。
```

---

## 35. 完了条件

以下をすべて満たす場合だけ完了。

- 全ArtifactのVersion／Source／License／Hashを確認。
- ResourcePackManagerをLock。
- 全JAR／Contentをユーザーが手動提供。
- Originalを変更していない。
- Reproducible Working Copy生成。
- 278件のStructure Selectionが一致。
- Weight／Enable状態がConcept V0.0.2と一致。
- Prop ID Mappingが完全解決。
- Entity監査が完了。
- Legacy Schematicを読取可能。
- 5 PackをMain BetterStructuresが認識。
- FMMが正常Enable。
- ResourcePackManagerが正常Enable。
- Main Pack生成・Hash計算成功。
- 安全なPack配信Preflight成功。
- Main三次元だけ有効。
- Resource FamilyとUnknown Worldは無効。
- EliteMobs／Frontier Assetなし。
- Main正常起動・停止。
- 現行Main Seed／UUID／Spawn／World Dataを変更していない。
- Persistent Main Familyを再生成していない。
- 新規Chunk自然生成試験をしていない。
- Runtime ArtifactがGit非追跡。
- Manifest／Docsが実態と一致。
- Roadmap Order 2／3だけ完了。
- Order 4以降は未完了。
- `git diff --check`成功。
- `Test-Layout.ps1`成功。
- Commit／Push成功。
- 最終Working TreeがClean。

---

## 36. 完了報告

以下を報告する。

1. 実装Commit SHA／Message
2. 記録Commit SHA／Message
3. Branch／Remote
4. Artifact監査結果
5. 実測Version／Hash
6. License／再配布条件
7. ResourcePackManager選定
8. Hosting Preflight方式
9. Structure Selection件数
10. Prop Mapping結果
11. Entity監査結果
12. Legacy Schematic監査結果
13. Plugin／Content Load結果
14. Resource Pack生成／配信結果
15. Main／Resource World Allowlist
16. 現行Main World Identity不変
17. Git非追跡確認
18. 更新File
19. 実行した検証
20. Roadmap更新
21. 再生成可否判定
22. 次の破壊的Taskへ渡すLock値
23. 残るBlocking事項
24. 最終`git status --short`

Main Persistent Family、自然生成、Weight調整、新Baseline、CoreProtect、Ruined FrontierまたはWorlds Beyondを「完了」「実装済み」と表現しない。
