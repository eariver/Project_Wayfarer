# Project Wayfarer Phase 2 BetterStructures導入 指示書

## 1. 目的

Project Wayfarer Ver.0.0.4 RoadmapのPhase 2として、Main BackendへBetterStructuresを導入する。

導入目的：

- Mainの恒久Dimensionへ、バニラに馴染む既製Structureを追加する。
- BetterStructuresの生成対象をPersistent Main Familyだけへ限定する。
- 再生成可能なResource FamilyにはBetterStructures由来Structureを生成しない。
- V0.1.0 Alphaに向けたMain恒久World最終生成の前提を整える。

今回の採用Contentは、公式無料Pack **`103 Default Structures`だけ**とする。

今回導入しないもの：

- Dungeoneering Modules Free／Premium
- Exploration Pack
- Adventure Pack
- Elite Shrines
- Caves and Lost Civilizations
- Premium Content
- FreeMinecraftModels／Prop Pack
- EliteMobs連携
- MythicMobs／MMOItems連携
- FrontierへのBetterStructures配置
- Resource WorldへのStructure生成
- 独自Schematic
- Loot／頻度／Generatorの大規模調整
- Main恒久Worldの最終再生成
- Pregeneration本運用
- Builder Phase 1B権限
- Plugin自動更新
- Nightbreak Account／TokenのRepository保存

本タスクはBetterStructuresの通常Integrationだが、World生成Scopeを変更するため、**Persistent Main許可とResource拒否だけはRisk-focusedに確認する**。BetterStructures内部の全Structure、全Loot、全Commandまたは全Generatorの品質保証は行わない。

実装、限定的な確認、Cleanup、文書更新が完了した場合はCommitし、remoteへPushする。

---

## 2. 作業基準

最新の`main`を取得し、少なくとも次のCommitを含むことを確認する。

```text
09ad691727cf4a053e55579e1e6372d5423aa600
feat: 一時昇格型権限基盤を実装
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
- Main Paper Version／Build
- Java Version
- MainのWorldEdit Version
- MainにBetterStructuresが未導入であること
- 現在のBukkit World名
- Persistent FamilyとResource Familyの実World名
- `.gitignore`とArtifact取得方針

既存変更を破棄しない。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- CodexによるPlugin JARまたはContent ZIPのInternet Download
- Nightbreak Tokenの要求、表示またはCommit
- `/bs downloadall`
- `/bs downloadpluginupdate`
- Plugin自動更新
- Content Packの無断追加
- BetterStructuresのLobby／Frontier／Velocity配置
- Resource World有効化
- Main恒久Worldの削除・再生成
- Resource Worldの削除・再生成
- WorldEdit／WorldGuard／LuckPermsのVersion変更
- Builder権限追加
- BetterStructuresの管理権限を`default`または`wayfarer_builder`へ付与
- 無関係なPluginの回帰試験
- JAR、ZIP、Schematic、World、Log、CacheのCommit

---

## 3. 採用Artifact

### 3.1 BetterStructures本体

実行時点で、公式Modrinthまたは公式Nightbreak情報から次を満たす最新Stable Releaseを確認する。

- BetterStructures公式版
- Paper対応
- Minecraft 26.2対応
- Java 25上で動作可能
- 既存WorldEdit 7.4.4をHard Dependencyとして利用可能
- Release Channel
- Source／License／Filename／Plugin Metadataを確認可能

本指示書作成時点の公式候補は`BetterStructures 2.6.2`だが、Codexは実行時点で公式Release一覧を再確認する。

次の場合は勝手に進めず報告する。

- 2.6.2より新しいStable Releaseが存在する
- ユーザー提供JARが最新Stableと異なる
- Minecraft 26.2対応表記がない
- JAR MetadataのVersionとFilenameが一致しない
- WorldEdit 7.4.4と互換性が確認できない
- Java要件がJava 25と両立しない
- Fork、FAWE専用版または非公式再配布である

FAWE／AsyncWorldEdit系Forkを採用しない。既存の公式WorldEdit 7.4.4を使用する。

### 3.2 Content Pack

採用するのは公式無料Content Pack：

```text
103 Default Structures
```

目的：

- Mainのバニラ寄り方針に合う。
- 初期Alphaで過度な戦闘／Boss／Custom Model要素を追加しない。
- BetterStructuresの最小実用構成を作る。

Content Packの正確なFilename、配布Versionまたは更新日時、Source、SHA-256を記録する。

ZIPは展開せず、BetterStructuresの公式Manual Import形式を維持する。

他Packが同じDownload Directoryに存在しても、今回のImportsへ無断でCopyしない。

---

## 4. ユーザーによる手動取得

CodexはArtifactをDownloadしない。

必要Artifactがない場合は、作業を中断してユーザーへ次の配置を依頼する。

推奨Staging Path：

```text
manual-downloads/betterstructures/
  BetterStructures-<version>.jar
  content/
    <103 Default Structures official zip>
```

実際の公式Filenameを維持する。

ユーザーが配置した後、Codexは次を確認する。

### JAR

- Regular File
- ZIP/JARとして読取可能
- `plugin.yml`読取可能
- Plugin名
- Version
- API Version
- Hard Dependency
- Platform
- SHA-256
- Official Releaseとの一致

### Content ZIP

- Regular File
- ZIPとして読取可能
- Archive Traversal等の不正Pathがない
- BetterStructures Content Packとして妥当
- Pack名
- Pack Metadata
- SHA-256
- 公式`103 Default Structures`との一致
- 別Packが混入していない

JAR／ZIPをGitへ追加しない。

---

## 5. 配置Scope

BetterStructures本体を次だけへ配置する。

```text
servers/main/plugins/
```

配置しない。

```text
velocity/plugins/
servers/lobby/plugins/
servers/frontier/plugins/
```

Content ZIPはBetterStructuresが生成したMain Runtime Directory内の公式Import先へCopyする。

想定：

```text
servers/main/plugins/BetterStructures/imports/
```

実際のPlugin生成Directory名と公式Documentationを確認する。

Content ZIPは展開しない。

---

## 6. 初回起動

### 6.1 起動対象

初回生成Config確認ではMainだけを起動してよい。

依存するInfrastructureやProxyが不要なら起動しない。

既存Scriptを確認し、安全にMain単体起動できない場合は、通常Network起動を使用してよい。ただし確認対象をBetterStructures Integrationへ限定する。

### 6.2 初回生成

1. Mainを正常停止する。
2. BetterStructures JARだけをMainへ配置する。
3. Mainを一度起動する。
4. BetterStructuresがWorldEdit Dependencyを解決してEnableされることを確認する。
5. 生成されたDirectory、Config、`ValidWorlds.yml`、Update関連設定、Imports構造を確認する。
6. Mainを正常停止する。

初回時点でContent Packを自動Downloadしない。

Nightbreak Loginを実行しない。

`setupDone`等を推測で直接書き換えない。Manual ImportがPlugin公式手順で成立する範囲だけを採用する。

初回Setup FlowがManual Importを妨げる場合：

- `/bs initialize`の正規Flowを調査する。
- Account Tokenなしで完了できるManual Pathが存在する場合だけ使用する。
- Credential入力が必須なら停止して報告する。
- Config Keyを強制変更してSetup済みに偽装しない。

---

## 7. 更新・Download Policy

BetterStructuresのPlugin JARおよびContentはProject Wayfarerの手動取得方針に従う。

次を無効化する。

- Plugin JARの自動Download
- Startup時のPlugin自動更新
- Contentの無断一括Download
- 保留中Plugin Updateの自動適用

生成Config内に次のKeyまたは同等設定が存在する場合、明示的に`false`とする。

```yaml
nightbreak:
  autoDownloadPluginUpdates: false
```

実際のKey構造は採用Versionの生成Configを正本とし、推測で存在しないKeyを追加しない。

Content Update通知は許容してよいが、自動Download／自動置換は許可しない。

次を実行しない。

```text
/bs downloadall
/bs downloadpluginupdate
/bs downloadallcontent
/bs updatecontent
```

---

## 8. Content Import

初回Config確認後：

1. Mainを停止する。
2. 公式`103 Default Structures` ZIPをImports DirectoryへCopyする。
3. Mainを正常起動する。
4. Startup Importが公式に対応している場合はStartupでImportする。
5. StartupだけではImportされない場合、Temporary AdminでPlugin固有の`/bs reload`を一度だけ使用してImportする。
6. Import後にMainを正常再起動する。
7. PackがInstalled／Enabledとして認識されることを確認する。

PlugManXを使用しない。

Server全体の`/reload`を使用しない。

`/bs reload`を使用した場合も、最終確認は正常Main Restart後に行う。

Imports ZIP、抽出Schematic、Downloaded Package Data、CacheをGitへCommitしない。

---

## 9. World Scope

### 9.1 Fail-closed方針

BetterStructuresの`ValidWorlds.yml`で、未知の新規Worldを自動有効化しない。

設定：

```yaml
New worlds spawn structures: false
```

正確なKey表記と階層は生成ファイルに合わせる。

### 9.2 使用するWorld名

BetterStructuresのWorld設定には、**Bukkitが認識する実World名**を使用する。

次を使用しない。

- Paper Namespaced Runtime KeyをそのままWorld名として推測
- Multiverse Aliasを実World名と誤認
- Filesystem Directory名を無確認で採用
- 文書上のLogical Nameだけを根拠に設定

Main Runtimeで次を確認する。

- `/mv list`
- Server Log
- BetterStructuresが生成した`ValidWorlds.yml`
- 必要ならBukkit／Paper CommandまたはPlugin API相当のWorld List

特にMain Endは、Logical Alias `main_end`と実World名が異なる可能性があるため、実名を確認する。

### 9.3 許可World

Persistent Main Familyの実World名だけを`true`にする。

論理対象：

```text
main
main_nether
main_end
```

Main Endは確認した実Bukkit World名を使用する。

### 9.4 拒否World

Resource Familyの実World名を明示的に`false`にする。

```text
resource
resource_nether
resource_end
```

Main Backendに他Worldが登録されている場合も、明示承認がない限り`false`とする。

最終状態：

- Persistent Main Familyだけ`true`
- Resource Familyはすべて`false`
- 未知の新規WorldはDefault `false`

Generator単位に`validWorlds`が設定されている場合、Global `ValidWorlds.yml`を迂回してResourceへ生成しないことを確認する。既成Packの全Generatorを無用に編集せず、Global World Boundaryを正本とする。

---

## 10. 初期Config方針

V0.1.0のMainはバニラに近い体験を優先する。

今回、次は原則として公式Defaultを維持する。

- Structure生成間隔
- Random Offset
- Loot Table
- Structure Weight
- Y Range
- Mob Spawn
- Pasting Speed
- Spawn Protection Radius

既定値を変更する必要が見つかった場合は、理由を報告してユーザー承認を得る。

Main Spawn Hubの最終規模と座標が未確定のため、`spawnProtectionRadius`を独断で拡大・縮小しない。採用Versionの既定値を記録し、Phase 3のMain最終生成前に再確認する課題として残す。

EliteMobs、MythicMobs、MMOItems、FreeMinecraftModels等の未導入Integrationを有効化しない。

Update Checkingと自動Downloadを区別し、自動Downloadだけは確実に無効化する。

---

## 11. Production Worldへの影響

BetterStructuresは新規Chunk生成時にStructureを配置する。

今回のMain WorldはPhase 3で最終生成予定であるため、本タスクで生成する試験Chunkは暫定Dataとする。

禁止：

- 既存Chunkへ大量の手動Structure配置
- Production Mainの広範なPregeneration
- World Border変更
- Main World削除
- Test後のRegion File手動削除
- Region Fileの部分編集

試験座標は既存拠点や通常利用範囲から十分離し、Exact Worldと座標を記録する。

試験Chunkを手動削除せず、Phase 3の承認済み最終World生成で置換される前提とする。

---

## 12. 限定的な受入確認

### 12.1 Artifact／Placement

- BetterStructuresの正確なVersionを確認。
- JAR Metadataが公式Releaseと一致。
- SHA-256を記録。
- Mainだけに配置。
- WorldEdit 7.4.4 Dependencyを解決。
- Lobby／Frontier／Velocityに存在しない。
- `103 Default Structures`だけが導入されている。
- JAR／ZIP／SchematicがGit管理外。

### 12.2 Enable／Config

- MainでBetterStructuresが正常Enable。
- 採用Configが読込。
- 自動Plugin Downloadが無効。
- `New worlds spawn structures: false`。
- Persistent Main実World名だけ`true`。
- Resource実World名はすべて`false`。
- Startupを阻害するERROR／SEVERE／Exceptionなし。
- `/bs version`または同等の非破壊的代表Commandが成功。

`/bs setup` GUIを確認する場合は、Token入力やDownload操作を行わない。

### 12.3 Positive Persistent Check

Persistent Main Overworldの未生成領域で、BetterStructuresが有効な状態の新規Chunk生成を確認する。

推奨手順：

1. 現在の生成済み範囲を確認する。
2. 通常利用範囲から離れた未生成地点を選ぶ。
3. Temporary Adminで移動する。
4. 最初は半径256 Block以内に限定して新規Chunkを生成する。
5. 公式PackのStructureが自然生成されたか確認する。
6. 見つからない場合だけ、最大半径512 Blockまで一度拡張してよい。
7. World Borderを変更しない。
8. 大規模Pregenerationを行わない。

Plugin固有`/bs pregenerate`を使用する場合：

- `applyWorldBorder=false`
- Persistent Main Overworldだけ
- 最大半径512 Block
- 一度だけ
- Completionを待つ
- Cancel／Failure Logを確認
- Mainを正常Restartしても生成済みStructureが保持されることを確認

自然生成Structureが確認できた場合、1件だけ記録する。

- World実名
- Chunk座標
- Structure／Schematic識別名
- Pack名
- 新規Chunkであること
- Restart後に存在すること

StructureのLoot、Mob、全Block、全Chestを網羅確認しない。

#### Positive Checkが成立しない場合

最大範囲まで確認してもStructureが生成されない場合：

- さらに広範なChunk生成を行わない。
- Generator間隔をProduction Configで変更しない。
- 無関係なPackを追加しない。
- `/bs place`だけで自然生成成功と扱わない。
- Config、Pack Import状態、Generator Enable状態、World名、Biome／Environment条件、Logを調査する。
- 原因が特定できなければCommit／Pushせず報告する。

### 12.4 Resource Exclusion Check

Resource Overworldで未生成Chunkを少量生成し、BetterStructures対象外であることを確認する。

確認：

- `ValidWorlds.yml`で実World名が`false`
- `New worlds spawn structures: false`
- BetterStructuresがResourceを有効Worldとして報告しない
- 新規Resource ChunkにBetterStructures Structureが生成されない
- BetterStructures由来のStructure Place／Paste Logがない

Resource側は広範な負例探索を行わない。Config Boundaryと代表的な新規Chunk確認で完了とする。

Resource Nether／EndはConfig上の`false`を確認すればよく、それぞれでChunk生成試験を繰り返さない。

### 12.5 Restart

Mainを正常Restartする。

Restart後：

- BetterStructures Enable
- Content Pack認識
- World Scope維持
- 自動Download無効
- Positive Structure維持
- 起動阻害Errorなし

Network全体の回帰試験を行わない。

確認不要：

- mcMMO全Skill
- Waymark取引
- EconomyShopGUI売買
- TAB全表示
- Frontier接続
- LuckPerms全Role
- WorldEdit全Command
- 全Structure Pack
- 全Loot Table
- 全Biome／Dimension

---

## 13. Permission

BetterStructuresの管理権限はTemporary AdminだけがGlobal `*`から利用する。

今回、次へBetterStructures Permissionを追加しない。

- `default`
- `wayfarer_builder`
- `wayfarer_builder_eligible`
- `wayfarer_admin_eligible`

Builder Phase 1Bでも、BetterStructures管理CommandをBuilderへ渡す必要性は現時点で想定しない。将来Builderが独自SchematicやGeneratorを管理する要件が発生した場合だけ別途検討する。

通常PlayerへBetterStructures Commandを追加しない。

---

## 14. Git追跡方針

### 14.1 追跡候補

生成内容を確認し、Projectが意図的に採用する非Secret Configだけを追跡する。

最低限候補：

```text
servers/main/plugins/BetterStructures/config.yml
servers/main/plugins/BetterStructures/ValidWorlds.yml
```

実際のCase／Filenameを生成物に合わせる。

ConfigにToken、Account ID、Machine固有Path、Download Session等が含まれる場合は、そのままCommitせずSanitized Template方式を検討する。

### 14.2 追跡しないもの

最低限Git Ignoreへ追加する。

- BetterStructures JAR
- Imports ZIP
- Downloaded Packages
- Package Cache
- Extracted Schematics
- Generated Content Assets
- Update Directory
- Temp Files
- Logs
- Account／Token Data
- Nightbreak Session Data
- Pregeneration Runtime State

生成後のDirectory構造を確認し、過剰なWildcardで追跡対象Configまで隠さない。

外部Contentは無料であってもRepositoryへ再配布しない。Pack名、Source、Version／Timestamp、SHA-256だけをManifestへ記録する。

---

## 15. Manifest／Version更新

実態に合わせて次を更新する。

- `versions.yml`
- `plugin-manifest.yml`
- `plugin-collection.csv`
- 必要なら`docs/08-plugin-collection.md`

BetterStructures項目へ最低限記録する。

- Version
- Reported Version
- Channel
- Platform
- Minecraft Compatibility
- Java Runtime
- Status: installed-and-verified
- Placement: Main only
- Excluded Placement
- Required Dependency: WorldEdit 7.4.4
- JAR Filename
- JAR SHA-256
- Official Source
- License
- Auto Update: disabled
- Reload Policy
- World Scope
- Verification

Content項目：

- Pack Name: 103 Default Structures
- Edition: Free
- Source
- Archive Filename
- SHA-256
- Runtime Import方式
- Redistribution: not committed
- Enabled World Family: Persistent Main only

既存のFrontier条件付きBetterStructures項目は、未導入のまま維持する。

---

## 16. 文書更新

実態へ合わせて必要な文書だけを更新する。

最低限確認：

- `README.md`
- `AGENTS.md`
- `docs/00-design-guide.md`
- `docs/01-architecture.md`
- `docs/02-installation.md`
- `docs/03-operations.md`
- `docs/04-play-guide.md`
- `docs/06-acceptance-tests.md`
- `docs/09-roadmap.md`
- `docs/08-plugin-collection.md`
- `plugin-manifest.yml`
- `plugin-collection.csv`
- `versions.yml`

記載する。

- BetterStructures導入済み
- Main Only
- 103 Default Structuresのみ
- Persistent Main Familyだけ有効
- Resource Family無効
- 未知World Default無効
- Structureは新規Chunkだけに生成
- Auto Download無効
- Content Artifactは手動取得・Git非追跡
- Phase 3でMain恒久Worldを最終生成予定
- Spawn Protection RadiusはPhase 3前に再確認
- Frontier BetterStructuresは未導入
- Builder権限変更なし

Roadmap：

- Phase 2を実施結果に基づき完了へ更新する。
- 次のPhaseはPhase 3「Main恒久World最終生成」とする。
- Phase 3は破壊的作業であり、別途指示・承認が必要。
- Phase 1Bは引き続き未完了だが、Phase 3を阻害しない。

Acceptance Tests：

- BetterStructures Version／Placement／Dependency
- 103 Default Structures認識
- Persistent Main Positive
- Resource Exclusion
- Restart
- Git除外

未確認項目を完了扱いしない。

---

## 17. Cleanup

Commit前に確認する。

- Temporary Admin Parentを解除済み
- Test用Permissionなし
- Test用OPなし
- World Border変更なし
- Pregeneration Task残留なし
- Test用別Packなし
- Importsに103 Default Structures以外なし
- Downloaded Plugin Updateなし
- Automatic Download無効
- Main正常状態
- BetterStructures JAR／ZIP／SchematicがStageされていない
- Token／Account DataがStageされていない
- Resource Worldが無効
- Lobby／Frontier／VelocityにJARなし

---

## 18. Commit前確認

実行する。

```powershell
git status --short
git diff --check
git diff --stat
git diff
```

Repositoryに存在する検査Scriptだけを使用する。

例：

```powershell
.\scripts\Test-Layout.ps1
```

YAMLを変更した場合は、安全なParserで構文確認する。

確認：

- Secretなし
- Nightbreak Tokenなし
- JAR／ZIP／Schematicなし
- World／Region Dataなし
- Log／Cacheなし
- BetterStructuresはMainだけ
- Persistent Mainだけ有効
- Resourceはすべて無効
- 未知World Default無効
- 103 Default Structuresだけ
- Builder Permission変更なし
- Phase 3を実施済みと記載していない
- 無関係な回帰試験結果なし
- 文書とRuntime実態が一致

---

## 19. Commit／Push条件

次をすべて満たした場合だけCommit／Pushする。

- 公式Artifact検証済み
- BetterStructures正確なVersion確認済み
- JAR SHA-256記録済み
- 103 Default Structures SHA-256記録済み
- Main Only配置
- WorldEdit Dependency解決
- BetterStructures正常Enable
- Content Pack認識
- 自動Download無効
- Persistent Main実Worldだけ有効
- Resource実Worldすべて無効
- 未知World Default無効
- Positive Persistent Check成功
- Resource Exclusion Check成功
- Main Restart後正常
- Artifact／World／SecretがGit非追跡
- Manifest／Version／文書更新済み
- `git diff --check`成功
- Repository検査成功
- Temporary Admin／Pregeneration Cleanup済み

Blockingな失敗時：

- Commitしない。
- Pushしない。
- 追加Packで誤魔化さない。
- 生成範囲を無制限に拡大しない。
- Resource Worldを一時有効化しない。
- ConfigをProductionと異なる状態で完了扱いしない。
- JARを自動Downloadしない。
- 失敗理由、Artifact状態、World Scope、生成範囲、Log、Rollback状態を報告する。

推奨Commit Message：

```text
feat: BetterStructuresをMain恒久Worldへ導入
```

Commit後に内容を再確認し、Current BranchをremoteへPushする。

禁止：

- Force Push
- History Rewrite
- 無関係変更のCommit
- Phase 3のWorld再生成を同じCommitで実行
- Builder Phase 1Bの同時実装

---

## 20. 完了報告

完了時に次を報告する。

- 作業開始時HEAD
- BetterStructures Version／Reported Version
- JAR Filename／SHA-256
- Content Pack Filename／SHA-256
- Official Source
- Dependency確認
- Placement
- Excluded Placement
- 採用Config
- Auto Update／Download設定
- 実Bukkit World名
- Persistent Main Allowlist
- Resource Deny List
- Positive StructureのWorld／Chunk／識別名
- Resource Exclusion結果
- Restart結果
- Git Ignore追加
- 変更ファイル
- 実行した検査
- Temporary Admin Cleanup
- Commit SHA
- Push先Branch
- 残課題
- 次のPhaseがMain恒久World最終生成であり、別途破壊的作業承認が必要なこと

Player名、UUID、Credential、Nightbreak Tokenは報告へ記載しない。
