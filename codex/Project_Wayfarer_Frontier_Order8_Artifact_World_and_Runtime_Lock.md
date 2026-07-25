# Project Wayfarer Frontier Order 8 Artifact・World・Runtime Lock 指示書

## 1. 推奨Sol

```text
high
```

### 理由

- Roadmap Order 8として、V0.1.0 Frontier実装全体の前提となるPlugin、Content、World ID、Gate方式、Resource Pack、Persistence、License、PermissionおよびRuntime責務境界を固定する。
- MVI、EliteMobs、Iris、BetterStructures、ResourcePackManager、Gate、Custom Pluginなど複数のAuthorityが交差し、誤ったLockは後続のWorld生成、Player State分離、Item隔離、Backup／RestoreおよびBuilder権限へ連鎖する。
- Premium／手動取得Artifact、複数Minecraft Version、二つのTheme、動的Instance、別Backend Resource Packを扱う。
- 本TaskではRuntime導入やWorld生成を行わないが、後続Taskが依存する正式な設計・Artifact Lockを確定するため、通常の文書整理より高い精度が必要である。

### Escalation／停止条件

次の場合は推測せず停止する。

- 公式配布元、License、Versionまたは対応Minecraft／Javaが一意に確認できない。
- 同一Pluginの候補Version間で、Paper 1.21.11、Java 25、Velocityまたは他依存Pluginへの互換性が衝突する。
- Premium ArtifactまたはUser-owned Contentが必要だが、Repository内に正規Artifactがなく、Userによる取得判断が必要になる。
- World IDが導入Artifactの固定名、予約名または既存Worldと衝突する。
- Gate方式がVelocity／Paper 26.2／Paper 1.21.11のすべてを一つの正式構成で満たさない。
- MVIが必要なPlayer State、World GroupまたはEliteMobs Instance命名を安全に扱えない可能性がある。
- Frontier PackのModel ID、CustomModelData／Item Model Component、Shader、FontまたはNamespace衝突を静的に解消できない。
- CoreProtectその他の履歴／Rollback方式をFrontierへ採用する判断に、Runtime試験またはDatabase作成が必要になる。
- Plugin導入、Server起動、World生成、Database Migration、Permission変更または既存Runtime Config変更が必要になる。
- Conceptと正式Scopeが矛盾し、どちらを採用するかUser判断が必要になる。
- V0.1.0 Scopeを拡張するPremium Content、追加Themeまたは新しいCustom Pluginが必要になる。

`high`より上のSolへ変更する条件はない。上記条件ではTask Scopeを拡張せず、Decision GateでUser判断を求める。

---

## 2. 目的

Project Wayfarer Ver.0.0.6 Roadmapの次を完了する。

```text
Order 8:
Frontier lock
```

本Taskの成果は、Frontier V0.1.0実装に必要な次の**正式Lock**である。

1. 現行Frontier Runtime Baseline
2. Plugin／Content候補と採用Version
3. Official Source、License、Artifact Filename、SHA-256
4. Plugin配置と依存関係
5. Frontier World ID
6. MVI GroupとPlayer State Authority
7. Portal FamilyとGate方式
8. Frontier Resource PackのBuild Input、Hosting方針、切替責務
9. Persistent／Lifecycle-managed World境界
10. Database／File／World／Plugin DataのAuthoritative Owner
11. PermissionおよびAdmin／Builder／General Player境界
12. Wayfarer_Core／Wayfarer_FrontierのIntegration Contract
13. 手動取得が必要なArtifact一覧
14. 後続Order 9～16へ引き渡す実装順序

本Taskは**調査・静的Artifact検証・正式文書化のみ**である。

---

## 3. 本Taskで行わないこと

- Plugin JARをRuntimeへ配置しない
- Frontier Serverを起動して互換性試験しない
- MariaDB／Redis Database、User、SchemaまたはKeyを作成しない
- Worldを生成、Import、Clone、Rename、Delete、TrimまたはLoadしない
- MVI GroupをRuntimeへ作成しない
- Multiverse World登録またはPortal Linkを変更しない
- Gateを設置・接続しない
- Resource Packを最終生成・Hosting・配信しない
- EliteMobs ContentをImportしない
- BetterStructures ContentをRuntimeへImportしない
- Iris Worldを生成しない
- LuckPerms Permissionを変更しない
- Builder Phase 1Bを開始しない
- Wayfarer_Core／Wayfarer_Frontier Repositoryを作成しない
- Custom PluginをBuildしない
- EM Adapterを設計・実装しない
- Main／Lobby／Frontier CoreProtectを導入しない
- Final Main Baselineを変更しない
- V0.1.0 Releaseを宣言しない

Static Inspection用の展開物は、Repository内のIgnored `local/work/`配下だけに置く。

---

## 4. Repository

```text
eariver/Project_Wayfarer
```

作業対象はVS Codeで開かれているRepository Root内だけとする。

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
010f4dbfeb6683a3cdbb8e6c6af7f43b0043a95a
docs: CoreProtect延期とRoadmap例外を反映

a0fc98e88aba95116ce0f1ddd60b3576d982d91c
docs: CoreProtect延期Commitを記録
```

開始時HEADは原則：

```text
a0fc98e88aba95116ce0f1ddd60b3576d982d91c
```

異なる場合は最新差分を確認し、本指示書より新しい正本を優先する。

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
- Runtime ArtifactのCommit

---

## 5. 正本と設計入力

### 5.1 正式なSource of Truth

最低限、次を読む。

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
```

### 5.2 非正本のDesign Input

次は詳細設計入力として読むが、そのまま採用しない。

```text
concepts/frontier/Frontier_Server_Specification_V0.0.4.md
concepts/frontier/Worlds_Beyond_Specification_V0.0.4.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.4.md
```

正式ScopeとConceptが異なる場合、正式Scopeを優先する。

Concept由来のVersion、World ID、数値、Plugin名またはContent名は、公式ArtifactとUser承認によってLockされるまで候補である。

---

## 6. 現行Runtime Baseline

### 6.1 Frontier Backend

```text
Software:
  Paper 1.21.11 build 132

Java:
  25

Existing entry world:
  frontier_gate

Current generated world scope:
  frontier_gate only
```

### 6.2 現在導入済みのFrontier関連基盤

現行`versions.yml`、`plugin-manifest.yml`、Runtime Artifactから再確認する。

最低限：

```text
Multiverse-Core 5.7.2
WorldEdit 7.4.4
WorldGuard 7.0.17
LuckPerms 5.5.60
mcMMO 2.3.000
RedisEconomy 4.5.12-wayfarer.1
VaultUnlocked 2.20.2
VoidGen 2.3.8
TAB-Bridge 6.2.2
PlaceholderAPI 2.12.3
```

上記を無条件に再選定しない。Artifact Hash、Placement、正常Load記録を現行正本から引き継ぐ。

### 6.3 未導入

少なくとも次は未導入または未Lockである。

```text
Multiverse-Inventories
Frontier Multiverse-NetherPortals
Iris
Iris World Pack
EliteMobs
BetterStructures on Frontier
FreeMinecraftModels on Frontier
ResourcePackManager on Frontier
BetterHealthBar3
LeafGrapple
Gate／Portal implementation
Frontier history／rollback solution
Wayfarer_Core
Wayfarer_Frontier
Frontier integrated Resource Pack
```

---

## 7. Phase A — 現状Inventory

### 7.1 Repository内Artifact調査

次をInventoryする。

```text
manual-downloads/
local/
servers/frontier/plugins/
servers/main/plugins/
config/
concepts/frontier/
```

Artifactごとに記録：

- Relative Path
- Filename
- Bytes
- SHA-1
- SHA-256
- Archive Readability
- Internal `plugin.yml`／`paper-plugin.yml`
- Internal Version
- Main Class
- API Version
- Dependencies／Soft Dependencies
- Bundled Libraries
- License File
- Content Manifest
- Internal World／Blueprint／Pack名
- Redistributability
- Current Runtime Placement
- Git Ignore status

Premium Contentは内容をReportへ全文転記しない。Metadata、ID、Version、Hash、License／利用条件だけを記録する。

### 7.2 既存Main Artifactの再利用可否

次をFrontierで再利用する候補として監査する。

```text
BetterStructures 2.6.3
FreeMinecraftModels 2.10.2
ResourcePackManager 2.3.0
BetterStructures Prop Pack
Exploration Pack v6
Caves and Lost Civilizations Free v2
Adventure Pack internal v1
Echoes of the Past v3
```

確認：

- 同一JARがPaper 1.21.11／Java 25を公式またはArtifact metadata上で対象に含むか
- License上、同一Ownerの別Backendで利用可能か
- 同一Artifactを複製配置できるか
- MainとFrontierで独立Config／Outputを持てるか
- Frontend Packへ同一Namespaceを統合した際の衝突
- MainのSelection／NormalizationをFrontierへ流用してよい部分と、Frontier専用選定が必要な部分
- Premium ArtifactをGitへCommitしない境界

Main Runtime ConfigをFrontierへそのままCopyしない。

---

## 8. Phase A — 公式情報調査

Artifact候補ごとに、公式配布元または公式Repositoryだけを使用する。

調査項目：

```text
Project Name
Edition
Latest Stable Version
Selected Candidate Version
Release Date
Minecraft Compatibility
Paper／Bukkit／Velocity Compatibility
Java Requirement
Dependency Versions
Official Download Source
License
Source Repository
API availability
Configuration documentation
Permission documentation
Known incompatibility
Maintenance status
Artifact filename
Official checksums if available
```

Forum転載、非公式Mirror、第三者再配布、検索Resultだけを採用根拠にしない。

Release metadataとProject説明が矛盾する場合、Artifact単位のRelease metadataと実JAR metadataを優先し、矛盾をReportする。

---

## 9. Lock対象Component

次を個別Lock Proposalへ含める。

## 9.1 Multiverse-Inventories

必須。

確認：

- Paper 1.21.11／Java 25対応
- Multiverse-Core 5.7.2との互換性
- `neutral`、`worlds_beyond`、`guild` Group
- Inventory
- Armor
- Offhand
- Ender Chest
- Vanilla XP／Level
- Health
- Food／Saturation
- GameModeその他の共有可否
- Per-world／Group Config syntax
- Static World登録
- RegexまたはWildcard機能の実在
- Player profile storage path／format
- Async save／shutdown behavior
- API
- World delete／unload behavior
- Respawn、Portal、Teleport、Reconnect behavior
- Backup ownership

MVIが通常Player Stateの唯一のRuntime正本である。

Wayfarer_Frontierが通常InventoryをMariaDBへ保存する案を採用しない。

## 9.2 Multiverse-NetherPortals

Frontierへ導入する候補をLockする。

第一候補は、現行Mainで使用中のVersionを再評価する。

```text
Multiverse-NetherPortals 5.0.5
```

確認：

- Paper 1.21.11
- Multiverse-Core 5.7.2
- Family-local explicit links
- End Portal／Exit behavior
- Mob／Item／Vehicle behavior
- `handle-end-exit-respawn`
- Cross-family防止
- Config backup owner
- MainとFrontierの独立Config

## 9.3 Gate／Proxy Portal

次を比較する。

第一候補：

```text
Advanced Portals
```

必要条件：

- Velocity component
- Paper 26.2 Lobby／Main backend component
- Paper 1.21.11 Frontier backend component
- 一つの正式Version／配布Packageでの整合
- Physical Portal／Gate
- Safe destination
- Backend switching
- Permission
- Cooldown
- Vehicle／Passenger方針
- Offline destination behavior
- Reconnect behavior
- Resource Pack切替との順序
- MVI World changeとの整合
- Admin-only creation／editing
- Builderに与える必要がある最小Node
- Config backup owner
- License

Advanced Portalsが要件を満たさない場合だけ、比較対象を提示する。独断で別Pluginへ変更しない。

Order 8ではGate方式とComponent配置をLockする。Exact Portal座標、形状、Destination座標、Builder Permission allowlistは後続Order 16～20で確定する。

## 9.4 Iris

Worlds Beyond用。

確認：

- Paper 1.21.11／Java 25対応Plugin Version
- License
- Distribution条件
- Engine／Pack Format
- Overworld／Nether／End対応
- Multiverse／existing-world import method
- Fixed Seed
- Persistent World operation
- World Border
- Upgrade policy
- Pack-specific license
- Pack artifact hash
- Generated World backup owner
- SupportされるWorld ID
- Vanilla Structure挙動
- Resource Pack requirementの有無

Iris Engine／Packは一括してLock Proposalへ提示する。

適切な三次元Packが未選定の場合、最大3候補の比較表を作成してUser判断を求める。

## 9.5 LeafGrapple

Conceptの第一候補：

```text
LeafGrapple 1.0.2
```

確認：

- Paper 1.21.11／Java 25
- Official source
- License
- Main Hand／Offhand
- Player／Entity Hook無効化
- Item生成API
- PDC保持
- World allowlist
- Durability無効化
- Elytra移行
- Config範囲
- Resource Pack asset
- CustomModelData／Item Model Component
- Restart behavior
- Theme外使用拒否をCustom Plugin側で実装可能か

1.0.2が不適切な場合は、理由と代替候補を提示する。

## 9.6 EliteMobs

Ruined Frontier用。

確認：

- Exact Stable Version
- Paper 1.21.11／Java 25
- License
- Official distribution
- Free／Premium境界
- Adventurer's Guild
- Primis
- Free Elite Shrines
- Dungeoneering Modules Free
- BetterStructures integration
- Sign／Boss ID
- Content Package filename／version
- Internal World names
- Blueprint names
- Instance naming
- Fixed／Cloned／Temporary World lifecycle
- Database／File ownership
- Item identity
- Internal currency
- Quest data
- NPC data
- World allowlist
- Resource Pack assets
- BetterHealthBar integration
- MVI static登録／Regex／API情報
- Restart／disconnect／reconnect behavior

Order 8ではAdapter要否を決定しない。Order 12用に必要なExact Blueprint名、Instance命名、API／Event有無を記録する。

## 9.7 BetterStructures

Ruined Frontier三次元用。

第一候補：

```text
BetterStructures 2.6.3
```

確認：

- Paper 1.21.11／Java 25
- WorldEdit dependency
- EliteMobs integration
- FMM／Prop integration
- Exact Frontier Allowlist
- Unknown World default false
- Content import format
- Config namespace
- Generated Structure ID
- Generator validWorlds
- MainとFrontierの独立Runtime Data
- No retrofit policy
- License

Frontierでは次だけを初期対象とする。

```text
frontier_bs
frontier_bs_nether
frontier_bs_the_end
```

`frontier_gate`、Guild、Primis、Worlds Beyond、Instance、未知Worldでは無効。

## 9.8 BetterStructures Content

初期Ruined Frontier候補：

```text
Exploration Pack
Caves and Lost Civilizations Free
Echoes of the Past
Adventure Pack
BetterStructures Prop Pack
```

次は初期値で全面無効。

```text
103 Default Structures
```

個別Structure採用は別のFormal Decisionが必要。

Order 8ではArtifact Version／Hash／License／SourceとContent分類をLockする。Exact Structure ID、Enable、Weight、Separationは後続のRuined Frontier Content Selection Taskで決定する。

## 9.9 FreeMinecraftModels

第一候補：

```text
FreeMinecraftModels 2.10.2
```

確認：

- Paper 1.21.11／Java 25
- Frontier独立Output
- BetterStructures Prop
- EliteMobs
- BetterHealthBar
- Model namespace
- Generated Pack ownership
- Auto-download disabled
- Shop／Player menu disabled
- License

## 9.10 ResourcePackManager

第一候補：

```text
ResourcePackManager 2.3.0
```

確認：

- Paper 1.21.11／Java 25
- Main 2.3.0との運用整合
- Frontier独立Pack
- Input priority
- Output path
- Hosting方式
- Pack hash
- Minecraft要求Hash形式
- Force／Optional
- Refusal behavior
- Download failure
- Cache
- Backend switch
- Reconnect
- Rollback
- License

Order 8では**Build Input、Merge Priority、Hosting方式、責任境界**をLockする。

実際のFrontier Pack ZIP、最終URL、Size、SHA-1／SHA-256はOrder 11のPack生成後に記録する。

## 9.11 BetterHealthBar3

Ruined Frontier Adoption Test候補。

確認：

- Paper 1.21.11／Java 25
- EliteMobs互換性
- Resource Pack asset
- Placeholder／Protocol依存
- License
- Disable／rollback方法
- Performance
- Player opt-out
- Boss bar／nameplate conflict

Order 8では採用試験対象VersionをLockする。V0.1.0への最終採用は後続Smoke Testで決定できる。

## 9.12 History／Rollback

Frontierについて、次を比較する。

- CoreProtect CEのFrontier Paper 1.21.11対応版
- 他の正式候補
- V0.1.0で未導入のまま進める案

確認：

- Paper 1.21.11／Java 25
- MariaDB
- WorldEdit logging
- MVI／EliteMobs dynamic World
- Per-world logging
- Instance World lifecycle
- Retention
- Permission
- Backupとの役割差
- License

Main／Lobbyの延期を理由にFrontierでも自動的に延期しない。

一方、Order 8だけでRuntime試験やDatabase作成が必要なら、`selected-for-later-validation`までに留める。

## 9.13 Custom Plugins

```text
Wayfarer_Core
Wayfarer_Frontier
```

Order 8ではJAR VersionやSHA-256をLockしない。まだ開発前である。

Lockするもの：

- Repository分離
- Java／Paper target
- Plugin ID候補
- Dependency方向
- API／Service ownership
- Database ownership
- Permission namespace
- Config ownership
- MVI非再実装
- Gate非再実装
- EliteMobs Adapter条件
- Resource Pack input ownership
- Item identity boundary
- Audit／Reconciliation boundary
- Release ArtifactをProject Wayfarerへ統合する手順

Order 9／10で正式設計、Repository作成、Build、Releaseを行う。

---

## 10. World ID Lock Proposal

次を初期候補として提示する。

| Purpose | Candidate Bukkit World ID |
|---|---|
| Frontier Lobby | `frontier_gate` |
| Worlds Beyond Overworld | `frontier_iris` |
| Worlds Beyond Nether | `frontier_iris_nether` |
| Worlds Beyond End | `frontier_iris_the_end` |
| Adventurer's Guild | `adventurers_guild` |
| Ruined Frontier Overworld | `frontier_bs` |
| Ruined Frontier Nether | `frontier_bs_nether` |
| Ruined Frontier End | `frontier_bs_the_end` |
| Primis | `primis` |

確認：

- 既存Folder／Multiverse／Level Nameとの衝突
- Plugin予約名
- Artifact内固定World名
- AliasとPhysical Name
- Case sensitivity
- MVI
- MNP
- Iris
- BetterStructures
- EliteMobs
- WorldGuard
- Backup Script
- Custom Plugin allowlist
- Portal Config

EliteMobsの固定Dungeon／Instance World名はArtifactから記録し、推測でRenameしない。

Dynamic InstanceはOrder 12で扱う。

---

## 11. MVI Group Lock Proposal

初期候補：

```text
neutral
worlds_beyond
guild
```

### neutral

```text
frontier_gate
```

### worlds_beyond

```text
frontier_iris
frontier_iris_nether
frontier_iris_the_end
```

### guild

```text
adventurers_guild
frontier_bs
frontier_bs_nether
frontier_bs_the_end
primis
Artifactで確認された固定Dungeon
Order 12で検証済みのEliteMobs Instance
```

共有対象候補：

```text
Inventory
Armor
Offhand
Ender Chest
Vanilla XP／Level
Health
Food／Saturation
```

GameMode、Potion、Bed Spawn、Locationその他は、採用MVI Versionの実KeyとTheme要件を比較してProposalへ含める。

不明なStateを一括共有しない。

---

## 12. Portal Family Lock Proposal

### Worlds Beyond

```text
frontier_iris
  ↔ frontier_iris_nether
  ↔ frontier_iris_the_end
```

Logical links：

```text
frontier_iris <-> frontier_iris_nether
frontier_iris <-> frontier_iris_the_end
```

### Ruined Frontier

```text
frontier_bs <-> frontier_bs_nether
frontier_bs <-> frontier_bs_the_end
```

禁止：

- Worlds BeyondとRuined FrontierのCross Link
- `frontier_gate`のVanilla Nether／End生成
- Main World FamilyとのLink
- General Player向けMultiverse admin teleport
- Gateを使わないTheme間直接移動
- GuildからRuined Nether／Endへの直接Gate

End Exit／Respawnの詳細は採用MNP VersionからExact Configを記録する。

---

## 13. Resource Pack Composition Lock

Frontier PackはMain Packと分離する。

候補Input：

```text
ResourcePackManager base
FreeMinecraftModels output
BetterStructures Prop Pack
EliteMobs assets
Free Elite Shrines assets
Dungeoneering Modules Free assets
Primis assets
Adventurer's Guild assets
BetterHealthBar3 assets
LeafGrapple assets
Wayfarer_Core assets（存在する場合）
Wayfarer_Frontier assets
```

作成する衝突表：

| Namespace／ID | Source A | Source B | Conflict | Resolution Owner |
|---|---|---|---|---|

最低限：

- CustomModelData
- Item Model Component
- Model path
- Texture path
- Font
- Shader
- Language key
- Sound
- Particle
- Namespace
- Pack format
- `pack.mcmeta`

MainとFrontierの同名IDが存在しても、別Backend Packとして安全か、Client cache／switchで問題になるかを評価する。

---

## 14. Persistence／Authority Matrix

次の表を作成する。

| Data | Authority | Runtime location | Backup owner | Restore order | Cross-server |
|---|---|---|---|---|---|
| Frontier Lobby normal state | MVI `neutral` | selected MVI storage | Frontier backup | MVI before join | No |
| Worlds Beyond normal state | MVI `worlds_beyond` | selected MVI storage | Frontier backup | MVI before join | No |
| Guild normal state | MVI `guild` | selected MVI storage | Frontier backup | MVI before join | No |
| World blocks/entities | World files | Frontier worlds | Frontier world backup | before startup | No |
| Waymark | RedisEconomy／Redis AOF | Redis | network backup | before backends | Yes |
| mcMMO | MariaDB | `wayfarer_mcmmo` | network DB dump | before backends | Yes |
| EliteMobs data | adopted Plugin storage | exact path／DB | Frontier backup | plugin-specific | Guild only |
| Iris engine／pack | artifact + world files | exact paths | Frontier backup | before world load | No |
| Resource Pack inputs | artifact/config | ignored + tracked locks | Pack backup | before publish | Backend-specific |
| Waystone／Discovery | Wayfarer_Frontier MariaDB | future DB | custom-plugin backup | migration first | Worlds Beyond only |
| Audit／Transaction | Wayfarer_Core MariaDB | future DB | custom-plugin backup | migration first | approved scope |
| History／Rollback | selected solution | exact storage | separate owner | after worlds/DB | Frontier only |

RedisをInventoryまたはTheme Stateの正本にしない。

---

## 15. Runtime適用境界

PluginごとにWorld Allowlist表を作る。

最低限：

| Plugin | frontier_gate | Worlds Beyond | Guild | frontier_bs* | Primis | EM Instance | Unknown |
|---|---:|---:|---:|---:|---:|---:|---:|
| MVI | neutral | worlds_beyond | guild | guild | guild | Order 12 | deny |
| MNP | no family | WB family | no family | RF family | package | package | deny |
| Iris | off | on | off | off | off | off | deny |
| BetterStructures | off | off | off | on | off | off | deny |
| EliteMobs | off | off | on | on | on | approved | deny |
| FMM | backend asset service | backend asset service | backend asset service | backend asset service | backend asset service | backend asset service | no gameplay |
| RPM | backend pack service | backend pack service | backend pack service | backend pack service | backend pack service | backend pack service | no world generation |
| LeafGrapple | off | on | off | off | off | off | deny |
| BetterHealthBar3 | off | off | candidate | candidate | candidate | candidate | deny |
| Wayfarer_Frontier | neutral subset | WB features | Guild adapters | RF adapters | Guild adapters | approved adapter only | fail closed |

Exact Config Keyは採用Versionから取得する。表の概念だけをRuntime Configとして使用しない。

---

## 16. License／Acquisition Matrix

各Artifactを次へ分類する。

```text
A:
  Official free artifact
  Codex may download only if existing project policy permits

B:
  User-manual free artifact
  User must place under manual-downloads

C:
  Premium／account-bound artifact
  User must acquire and place manually

D:
  Existing user-owned artifact
  Hash and license re-audit only

E:
  Custom project artifact
  Future separate repository release
```

表：

| Artifact | Class | Official source | License／terms | Selected version | Present | User action |
|---|---|---|---|---|---:|---|

CodexはPremium、account-bound、license-restrictedまたはunknown ArtifactをDownloadしない。

---

## 17. Phase A Deliverables

Phase Aで作成する。

```text
docs/investigations/<date>-frontier-order8-lock-preflight.md
config/frontier-lock/artifact-candidates.yml
config/frontier-lock/world-id-candidates.yml
config/frontier-lock/runtime-boundary-candidates.yml
config/frontier-lock/resource-pack-input-candidates.yml
manual-downloads/frontier/README.md
```

`manual-downloads/frontier/README.md`には取得要求だけを記載し、Artifact自体をCommitしない。

Phase A Reportには次を含める。

- 現行Git HEAD
- 現行Frontier Runtime
- Existing Artifact inventory
- Candidate matrix
- Compatibility evidence
- License evidence
- World ID collision check
- MVI State matrix
- Gate comparison
- Iris Pack comparison
- EliteMobs Content inventory
- Resource Pack collision preflight
- History／Rollback options
- Missing Artifact
- User manual action
- Unresolved decision
- Recommended Lock Proposal

---

## 18. Decision Gate

CodexはPhase A完了後、Runtimeや正本Lockを変更せず停止する。

Proposal ID：

```text
FRONTIER-LOCK-YYYYMMDD-001
```

提示するDecision：

### A — 推奨Proposalを採用

Token：

```text
APPROVE-WAYFARER-FRONTIER-LOCK:<PROPOSAL-ID>
```

### B — 一部修正して再Proposal

Userが変更対象を明示する。

Codexは新Proposal IDを発行し、旧Tokenを無効とする。

### C — Lock不能として停止

条件：

- 必須Artifactが入手不能
- License不明
- 必須互換性なし
- Gate／MVI／Pack境界が成立しない
- V0.1.0 Scope変更が必要

Userの「OK」「進めてください」だけをExact Approval Tokenとして扱わない。

---

## 19. Lock Proposal必須項目

Proposalには次を一つの表で示す。

1. Component
2. Selected／Unselected
3. Exact Version
4. Official Source
5. License
6. Artifact Filename
7. SHA-256
8. Paper／Velocity／Java compatibility
9. Placement
10. Dependencies
11. World scope
12. Persistence owner
13. Permission owner
14. Pack input
15. User manual acquisition
16. Runtime validation deferred task
17. Rollback boundary
18. Known limitation

次も明示する。

```text
Locked now
Deferred to Order 9
Deferred to Order 10
Deferred to Order 11
Deferred to Order 12
Deferred to Order 16
Rejected
```

---

## 20. Phase B — 正式Lock反映

Exact Approval後だけ実施する。

更新：

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
```

新規：

```text
docs/15-frontier-runtime-lock.md
docs/investigations/<date>-frontier-order8-lock.md
config/frontier-lock/artifact-lock.yml
config/frontier-lock/world-id-lock.yml
config/frontier-lock/runtime-boundary-lock.yml
config/frontier-lock/resource-pack-input-lock.yml
config/frontier-lock/persistence-authority-lock.yml
codex/Project_Wayfarer_Frontier_Order8_Artifact_World_and_Runtime_Lock.md
```

候補Fileは、正式Lock後に`*-candidates.yml`を削除またはHistorical sectionへ移す。Approval前後の記録が失われないようInvestigationへ残す。

---

## 21. 正式Lockの意味

Order 8完了は次を意味する。

```text
Selected versions and artifacts:
  approved

World IDs:
  approved

MVI group names and conceptual membership:
  approved

Gate method:
  approved

Resource Pack build inputs and ownership:
  approved

Persistence owners:
  approved

Runtime boundaries:
  approved
```

次を意味しない。

```text
Plugins installed
Worlds generated
MVI configured
Gate connected
Resource Pack generated
EliteMobs imported
Iris world accepted
Custom Plugins developed
Frontier playable
```

Compatibilityは次の状態を区別する。

```text
officially-supported
artifact-statically-verified
runtime-unverified
runtime-verified
rejected
```

Order 8では原則`runtime-unverified`までである。

---

## 22. 後続Taskへの引渡し

Order 8 Reportに、次の順序を明記する。

```text
Order 9:
  Wayfarer_Core formal design／repository／release

Order 10:
  Wayfarer_Frontier formal design／repository／release

Order 11:
  Frontier shared foundation installation
  MVI
  MNP
  WorldEdit／WorldGuard existing verification
  ResourcePackManager
  FMM
  Frontier Pack
  Beyond／Guild Gate foundation

Order 12:
  EliteMobs–MVI Adapter necessity decision

Order 13:
  Ruined Frontier alpha

Order 14:
  Worlds Beyond MVP

Order 15:
  two-Theme integration

Order 16:
  final Gate and Permission lock
```

Order 9／10が長期化する場合でも、Order順序の変更は別のFormal Roadmap Taskで行う。

---

## 23. Security／Permission Lock

Order 8で固定する原則：

### Temporary Admin only

- MVI group／profile／recovery
- MNP administration
- Gate create／edit／delete
- EliteMobs internal admin／teleport shortcuts
- BetterStructures import／reload／generation admin
- RPM build／publish／reload／rollback
- FMM model admin
- Iris world lifecycle
- Database
- Economy administration
- Wayfarer_Core／Frontier admin／reconcile／migration
- History／rollback administration
- WorldGuard Region administration
- Destructive World lifecycle

### General Player

- Approved Gate traversal
- Theme gameplay
- Approved GUI
- No Multiverse admin teleport
- No Plugin admin
- No direct Theme bypass

### Builder

Order 8では権限を付与しない。

Order 16／17で、採用VersionのExact Nodeから必要最小限をAllowlistする。

---

## 24. Git非追跡

Commit禁止：

- JAR
- Premium Content
- Free Content archive
- Iris Pack archive
- EliteMobs Content
- Generated Pack
- Models
- Runtime Config with Secrets
- World
- Region
- Player Data
- Database
- Redis Data
- Logs
- Screenshots
- Unpacked proprietary content
- Download cache
- Temporary static inspection output

確認：

```powershell
git status --short
git check-ignore -v <artifact-path>
git check-ignore -v <local-work-path>
git diff --cached --name-status
```

---

## 25. Validation

### Documentation

```powershell
git diff --check
.\scripts\Test-Layout.ps1
```

### YAML

Parse：

```text
versions.yml
plugin-manifest.yml
config/frontier-lock/*.yml
```

### Artifact Lock

- SHA-256 format
- Duplicate ID
- Duplicate filename
- Missing license
- Missing source
- Missing placement
- Missing dependency
- Version inconsistency
- World ID collision
- MVI group collision
- Pack namespace collision
- Unknown artifact
- Premium artifact Git exclusion

### Runtime Non-change

確認：

- `servers/frontier/plugins/`変更なし
- `servers/frontier/`World変更なし
- `servers/main/`変更なし
- `servers/lobby/`変更なし
- Permission DB変更なし
- MariaDB／Redis変更なし
- Protected Portを開いていない
- Serverを起動していない

---

## 26. Commit／Push

Phase Aは、Decision Gate前にCommitしてよい。

推奨：

```text
docs: Frontier Lock候補を調査
```

User Approval後のPhase B：

```text
docs: Frontier V0.1.0 Runtime Lockを確定
```

Archive：

```text
docs: Frontier Lock Commitを記録
```

Push前：

```powershell
git status --short
git log -5 --oneline
git diff --check
.\scripts\Test-Layout.ps1
```

Push後、Remote SHAを確認する。

---

## 27. Codex Archive

作業開始：

```text
調査中
```

Phase A停止：

```text
承認待ち（Proposal: <ID>）
```

Phase B成功：

```text
完了（実装Commit: <SHA>）
```

Lock不能：

```text
停止（Frontier Lock未成立）
```

再実行Policy：

```text
完了後はそのまま再実行禁止。
Artifact更新、World ID変更、Gate変更、Pack Input変更またはScope変更は新しいLock Revision Task。
```

---

## 28. Userが行う作業

Phase A開始時点では、追加Downloadを先回りして行わなくてよい。

Codexへ本指示書を渡し、Solを`high`にする。

Phase A完了後、Codexが提示する次を確認する。

1. Lock Proposal
2. Missing Artifact一覧
3. Manual acquisition一覧
4. Iris Pack候補
5. Gate方式
6. Frontier history／rollback方針
7. World ID
8. License／利用条件
9. Premium Content再利用可否
10. Exact Approval Token

必要な場合だけ、Codexが指定した公式配布元からArtifactを取得し、指定された`manual-downloads/frontier/`配下へ**元Filenameのまま**配置する。

Userは次を直接編集しない。

- Runtime JAR配置
- MVI Config
- Multiverse World登録
- Portal Link
- Resource Pack Output
- Database
- Permission
- World Folder

---

## 29. Completion Report

報告：

1. Recommended Sol
2. Pre-execution HEAD
3. Phase A Commit
4. Proposal ID
5. Approval Token
6. Phase B Commit
7. Archive Commit
8. Selected Plugin一覧
9. Rejected Plugin一覧
10. Exact Versions
11. Artifact SHA-256
12. Official Sources
13. Licenses
14. Existing／Missing Artifact
15. User manual acquisition
16. World ID Lock
17. MVI Group Lock
18. Player State ownership
19. Portal Family Lock
20. Gate method
21. Iris Engine／Pack Lock
22. EliteMobs／Content Lock
23. BetterStructures／Content Lock
24. FMM／RPM Lock
25. LeafGrapple Lock
26. BetterHealthBar3 test candidate
27. History／rollback decision
28. Resource Pack inputs
29. Pack conflict result
30. Persistence／Authority matrix
31. Runtime boundary matrix
32. Permission boundary
33. Custom Plugin contracts
34. Deferred validation
35. Known limitations
36. Updated files
37. Validation commands
38. Runtime non-change proof
39. Git exclusion proof
40. Final `git status --short`

---

## 30. 完了後の正式状態

```text
Orders 2–6:
  complete

Order 7 CoreProtect:
  deferred / non-blocking

Order 8 Frontier lock:
  complete

Frontier Artifact／World／Runtime contract:
  locked

Runtime installation:
  not started

Frontier Worlds:
  not generated

MVI:
  not configured

Frontier Pack:
  not generated

Next:
  Order 9 Wayfarer_Core
```
