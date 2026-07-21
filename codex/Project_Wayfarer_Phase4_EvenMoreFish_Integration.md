# Project Wayfarer Phase 4 EvenMoreFish導入 Codex指示書

## 1. 目的

Project Wayfarer Ver.0.0.5 RoadmapのPhase 4として、EvenMoreFishをMain Backendへ導入する。

目的：

- MainのVanilla寄りSurvivalへ、任意参加型のCustom Fishing要素を追加する。
- バニラFishingのTreasure／Junkを維持する。
- MainとResource OverworldでCustom Fishを釣れるようにする。
- mcMMO FishingのXP／Skill進行を維持する。
- 未設計のWaymark収入源、自動CompetitionおよびFish ShopはV0.1.0初期構成へ持ち込まない。
- Journal／Catch StatisticsをMariaDBへ永続化する。
- V0.1.0向けのMain軽量Gameplay要素を完成させる。

本タスクは通常のPlugin Integrationである。

詳細確認の対象は次へ限定する。

- 正式Artifact
- Main限定配置
- Config読込
- World Scope
- MariaDB接続
- 代表的な自然Catch
- mcMMO Fishing XPとの共存
- WM残高が変化しないこと
- Restart後のCatch Statistics／Journal保持
- 一般Player／AdminのPermission境界

全Fish、全Rarity、全Biome、全Bait、全Command、全GUI、全Competition、全Loot Tableまたは長時間のBalance試験は行わない。

---

## 2. 開始Baseline

最新`main`を取得し、少なくとも次のCommitを含むことを確認する。

```text
0e9e491cb3b012c5e194feed5c9f820d5deeca5e
docs: 設計基準をVer.0.0.5へ更新
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
- 他者の作業
- Main Runtimeの起動状態
- Main Paper Version／Build
- Java Version
- mcMMO Version
- VaultUnlocked Version
- RedisEconomy Version
- PlaceholderAPI Version
- MainにEvenMoreFishが未導入であること
- MariaDB Container／Service状態
- Config Renderer／Secret注入方式
- `.gitignore`
- `plugin-manifest.yml`
- `versions.yml`
- `docs/09-roadmap.md`
- `docs/06-acceptance-tests.md`
- `docs/03-operations.md`

既存変更を破棄しない。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- History Rewrite
- 未承認のPlugin Upgrade
- mcMMO／RedisEconomy／VaultUnlocked／PlaceholderAPIのVersion変更
- Lobby／Frontier／VelocityへのEvenMoreFish配置
- Development Build／Jenkins Buildの採用
- Sourceからの自己Build
- CodexによるPlugin JARのInternet Download
- JARのGit Commit
- 自動Competitionの有効化
- Vault Economyの有効化
- EMF Shop／SellallによるWM払い出し
- PlayerPoints／GriefPrevention Economyの有効化
- Lava Fishing／Void Fishingの有効化
- Fish Huntingの有効化
- 新しいCustom Fish／Rarity／Baitの追加
- Default Packの大規模Balance変更
- BuilderへのEvenMoreFish管理権限付与
- `/reload`
- PlugManX
- EMF Debug Database Clean／Drop／Repair Command
- 他Plugin Database Tableの直接変更
- 広範なRegression Test

---

## 3. Git／Push方針

本タスクは既存`main` Branchへの直接Commit／Pushであり、Pull Requestを作成しない。

GitHub CLI（`gh`）は不要である。

次を行わない。

```text
gh --version
where.exe gh
Get-Command gh
GitHub CLIの検索
GitHub CLIのインストール
PR作成
```

GitHub CLIが存在しないことをWarningまたはBlocking事項として扱わない。

通常のGit Commandを使用する。

```powershell
git add <approved-files>
git commit -m "feat: EvenMoreFishをMainへ導入"
git push
git rev-parse HEAD
git status -sb
```

GitHub CLIを確認するのは、Pull Request、Issue、GitHub Release等が個別タスクで明示された場合だけとする。

---

## 4. 正式Artifact

## 4.1 配布元

公式Stable ReleaseをModrinthから手動取得する。

```text
https://modrinth.com/plugin/evenmorefish
```

採用しない。

- Jenkins Development Build
- 非公式Mirror
- Fork
- Spigot上の旧Release
- Source Build
- Snapshot
- Pre-release
- Loader違い
- 改変JAR

## 4.2 Version選定

本指示書作成時点の公式Stable候補：

```text
EvenMoreFish 2.4.1
```

既知の公式情報：

- Release Channel
- Paper／Folia対応
- Minecraft 26.2対応
- Java 21以上
- MIT License
- 2.4系はMinecraft Version別JARを分けない単一Artifact
- 2.4.1は初回Load時Errorの修正Release

ただし、Codex実行時点で公式ModrinthのVersionsを再確認する。

次の場合は自動的に別Versionへ進まず、差分をユーザーへ提示する。

- 2.4.1より新しいStable Releaseが存在
- 対応Minecraft Versionが変更
- Java要件が変更
- Release NotesにDatabase Migration、Config破壊、既知の重大問題がある
- ユーザー配置JARと選定Versionが異なる
- JAR MetadataとFilenameが一致しない
- Paper 26.2対応が公式Metadataから確認できない

新しいStableが単純なBug Fixであり、Paper 26.2／Java 25互換性が明記される場合も、Version、Release NotesおよびArtifact差分を報告してユーザー承認を得る。

---

## 5. 手動Artifact取得

CodexはJARをDownloadしない。

Artifactが存在しない場合、ユーザーへ公式Modrinthから取得して次へ配置するよう依頼する。

推奨Staging Path：

```text
manual-downloads/evenmorefish/
  <official EvenMoreFish jar>
```

実際の公式Filenameを維持する。

配置後にCodexが確認する。

- Regular File
- ZIP/JARとして読取可能
- `paper-plugin.yml`、Plugin Metadataまたは同等Metadata
- Plugin名
- Version
- API Version
- Main Class
- Hard／Soft Dependencies
- Java Class Version
- SHA-256
- Official Modrinth Releaseとの一致
- 不審な追加Fileがないこと

JARをGitへ追加しない。

---

## 6. 配置Scope

EvenMoreFishを次だけへ配置する。

```text
servers/main/plugins/
```

配置しない。

```text
velocity/plugins/
servers/lobby/plugins/
servers/frontier/plugins/
```

理由：

- Main固有の軽量Gameplay機能である。
- Frontier ThemeのFishing仕様へ影響させない。
- LobbyはGameplay対象外である。
- Velocity Pluginではない。
- `Wayfarer_Main`相当の責務である。

Plugin JARはRuntime ArtifactでありGit非追跡とする。

---

## 7. 初回起動

1. Mainを正常停止する。
2. Artifact Metadata／SHA-256を確認する。
3. JARを`servers/main/plugins/`へ配置する。
4. Mainだけを起動する。
5. EvenMoreFishが正常Enableすることを確認する。
6. 生成Directoryと全Config Fileを記録する。
7. Pluginが認識したVersion、Paper、Java、Vault、mcMMO、PlaceholderAPIを確認する。
8. 自動Competitionが開始していないことを確認する。
9. Mainを正常停止する。
10. 生成Configを採用Policyへ編集する。

Main単体起動が既存Script上で安全にできない場合は通常Network起動を使用してよいが、確認範囲をEvenMoreFishへ限定する。

初回起動時に一般Playerを接続しない。

---

## 8. 採用する初期Gameplay Profile

V0.1.0の初期構成は次とする。

```text
Custom Fish Catch             有効
Vanilla Treasure／Junk        維持
Fish Entity Hunting           無効
Lava Fishing                  無効
Void Fishing                  無効
Scheduled Competitions        無効
Manual Competition運用       V0.1.0では採用しない
Vault／WM Fish Shop           無効
Sellall                       無効
PlayerPoints Economy          無効
GriefPrevention Economy       無効
Bait Catch／Application       有効
Bait購入                      無効
Journal／Catch Statistics     有効
Database                      MariaDB
対象World                     main, resource
Nether／End                   無効
Unknown New Worlds            無効
Locale                        ja
```

このProfileを変更しない。

特に、EvenMoreFishをWaymark供給源として使用する設計はまだ行っていない。

Fish価格、Rarity倍率およびWM Balanceを別途設計するまで、EMFのVault Economyは有効化しない。

---

## 9. Main Config

採用Versionが生成したConfigを正本として編集する。

存在しないKeyを推測で追加しない。

Version管理Keyを変更しない。

## 9.1 Plugin／Locale

```yaml
enabled: true
debug: false
locale: ja
```

Locale変更について公式生成Configが`messages.yml`再生成を要求する場合：

1. Mainを停止する。
2. 生成済み英語`messages.yml`をIgnored Backupへ退避する。
3. `locale: ja`を設定する。
4. Mainを起動して日本語Message Fileを生成する。
5. Mainを正常停止する。
6. 日本語Fileが正常Loadすることを確認する。

Config KeyやIDは英数字を維持し、Display Textだけを日本語化する。

## 9.2 Fishing

```yaml
fishing:
  catch-enabled: true
  catch-only-in-competition: false
  require-custom-rod: false
  only-fish: true
  hunt-enabled: false
  hunt-only-in-competition: false
  hunt-ignore-spawner-fish: true
```

重要：

- `only-fish: true`により、Custom Fishは魚Catchを置き換える。
- Enchanted Book等のVanilla Treasure／Junkは維持する。
- Fish Entityを倒してCustom Fishを得る機能は無効。
- Custom Rodを必須にしない。
- 通常のFishing Rodで参加可能。

`give-straight-to-inventory`と`random-durability`はVendor Defaultを維持する。

## 9.3 World Scope

採用Versionの正確なKey名を確認して、許可Worldを明示する。

想定：

```yaml
allowed-worlds:
  - main
  - resource
```

許可しない。

```text
main_nether
main_the_end
resource_nether
resource_end
lobby
frontier_gate
将来のFrontier Theme
未知の新規World
```

空Listが「全World」を意味する場合があるため、空のままにしない。

実Bukkit World名を使用する。

`main_end` Aliasを実World名として使用しない。

Main OverworldとResource Overworldだけを初期対象とする。

## 9.4 Dimension Fishing

```yaml
dimension-fishing:
  lava:
    enabled: false
  void:
    enabled: false
```

Lava／Void Fishing用World、Permission、Requirementを設定しない。

## 9.5 Economy

```yaml
economy:
  vault:
    enabled: false
  playerpoints:
    enabled: false
  griefprevention:
    enabled: false
```

理由：

- EMF Fish価格とWaymark供給量が未設計。
- EconomyShopGUIの固定価格Baselineとの関係が未評価。
- V0.1.0で無断の新規WM Faucetを増やさない。

次を確認する。

- `/emf shop`でWMを獲得できない。
- `/emf sellall`でWMを獲得できない。
- Fish Catch時にWM報酬がない。
- Competition RewardからWMが出ない。
- Default Fish／Rarityの`catch-event`にEconomy Rewardが含まれない。
- Default Competition RewardにEconomy Commandが含まれていてもCompetition自体が無効。

Fish Itemの`worth-multiplier`値は、Economy無効状態ではVendor Dataとして維持してよい。

## 9.6 Database

Journal／Catch Statisticsを保持するためDatabaseを有効にする。

論理Database：

```text
wayfarer_evenmorefish
```

Table Prefix：

```text
emf_
```

Config概念：

```yaml
database:
  enabled: true
  type: mysql
  address: <runtime MariaDB host:port>
  database: wayfarer_evenmorefish
  table-prefix: emf_
  username: <runtime secret>
  password: <runtime secret>
  advanced:
    jooq-execute-logging: false
    jooq-render-formatted: false
```

採用Versionの生成Config構造を使用する。

MariaDBはMySQL互換Endpointとして使用する。

### Database User

専用の最小権限Userを作成する。

候補名：

```text
wayfarer_evenmorefish
```

許可範囲：

```text
wayfarer_evenmorefish.*
```

必要なDDL／DMLだけを許可する。

既存Databaseへの権限を与えない。

特に次へ権限を与えない。

- `wayfarer_luckperms`
- `wayfarer_mcmmo`
- MariaDB System Schema
- 他Plugin Database

Root CredentialをRuntime Plugin Configへ使用しない。

SQL Credential、Password、Host固有値はGitへCommitしない。

### Config Template

既存Project方式に従い、Sanitized TemplateとIgnored Runtime Configを分離する。

Repositoryへ保存するTemplateではPlaceholderを使用する。

例：

```text
__WAYFARER_EMF_DB_HOST__
__WAYFARER_EMF_DB_NAME__
__WAYFARER_EMF_DB_USER__
__WAYFARER_EMF_DB_PASSWORD__
```

実際のPlaceholder規約は既存Rendererへ合わせる。

Rendererへ必要最小限のValidationを追加する。

- Runtime Credential Placeholderが残っていない
- Database名が`wayfarer_evenmorefish`
- Table Prefixが`emf_`
- Database有効
- JOOQ Debug Log無効
- Runtime ConfigがGit Ignore対象

Rendererを無関係に全面改修しない。

### Migration

初回Enable時の自動Migrationだけを使用する。

通常の初期導入で次を実行しない。

```text
/emf admin database drop-flyway
/emf admin database repair-flyway
/emf admin database clean-flyway
/emf admin database migrate-to-latest
```

Pluginが自動Migrationに失敗した場合：

- SQL Tableを直接修正しない。
- Debug Database Commandを試行しない。
- Error、Migration Version、作成済みTableを記録する。
- Mainを正常停止する。
- Commit／Pushせず報告する。

## 9.7 Save Interval

Vendor Defaultが次と同等であることを確認する。

```yaml
database:
  advanced:
    save-interval:
      unit: SECONDS
      user-fish-stats: 5
      competition: 5
```

Competitionは無効だが、Config構造を壊さない。

初期IntegrationではSave Intervalを大きく変更しない。

## 9.8 Item Protection

Vendor Defaultの保護を維持する。

最低限：

```yaml
item-protection:
  prevent-crafting: true
  prevent-consume: true
  prevent-furnace-burn: true
  prevent-cooking: true
  prevent-placing: true
```

EMF ItemをCraft、燃料、設置等で意図せず破壊・変換できない状態を維持する。

Default Fishが`raw-material`を使用する場合の例外挙動は網羅試験しない。

## 9.9 Bait

BaitのCatchとRodへの適用は有効のまま維持してよい。

ただし、WM購入は無効とする。

確認する。

- Bait MenuにPurchase Actionがある場合、価格付き購入を無効化または非表示化する。
- PlayerPoints等の購入を有効化しない。
- Bait Catch Chance等はVendor Default。
- Bait Balanceを変更しない。
- 代表的なBait Catch／Applicationは受入必須ではない。

## 9.10 Competitions

全Scheduled Competitionを無効にする。

各実Competition Configで、採用Versionが公式に対応する方法を使用する。

推奨：

```yaml
disabled: true
```

または、公式仕様に従いFilename先頭を`_`へ変更する。

一つの方法へ統一する。

Example ConfigはPluginが再生成する参考Fileとして扱い、実Competitionとして登録しない。

確認する。

- Startup時にScheduled Competition登録なし。
- 自動Competition開始なし。
- Bossbarなし。
- Competition Rewardなし。
- `/emf next`を一般Playerへ提供しない。
- `/emf top`を一般Playerへ提供しない。

Manual Test Competitionも本タスクでは開始しない。

## 9.11 Update Policy

EvenMoreFishの自動Download／自動置換機能が存在する場合は無効にする。

Update通知だけなら許容してよい。

Plugin JARはProject Wayfarerの手動取得方針に従う。

---

## 10. mcMMO Fishingとの境界

mcMMO 2.3.000はMain／Frontier共有Progressionの正本である。

EvenMoreFish導入後も次を維持する。

- Fishing XP
- Fishing Skill Level
- mcMMO Player Data
- Main／Frontier共有
- Restart Persistence

## 10.1 Loot Ownership

EvenMoreFishの生成Configに存在する次のKeyを確認する。

```yaml
disable-mcmmo-loot: true
```

初期方針：

- `disable-mcmmo-loot: true`を採用する。
- Custom Fish CatchのItem決定はEvenMoreFishに任せる。
- mcMMO Fishing XP／Skill進行は維持する。
- 同一CatchでEMF FishとmcMMO追加Lootが二重配布されないようにする。
- Vanilla Treasure／JunkはEvenMoreFishの`only-fish: true`で維持する。

この構成でmcMMO Fishing XPまで止まる場合はBlockingとする。

無断で`disable-mcmmo-loot: false`へ切り替えて完了扱いしない。

## 10.2 Overfishing／AFK対策

EvenMoreFish Configには、mcMMO Overfishing有効時にEMF側AFK Fishing Protectionが機能しない旨の説明がある。

RuntimeのmcMMO Configを確認する。

- mcMMO Overfishingが有効なら、EMF `exploits.afk-fishing.enabled`は無効のままにする。
- mcMMO Overfishingが無効なら、初期IntegrationではEMF AFK対策も無断で有効化せず、未決事項として文書化する。
- 二つのAnti-AFK機構を同時に有効化しない。
- mcMMO Configを本タスクで変更しない。

本タスクの目的はConflict確認であり、Fishing Anti-AFK Policyの新規設計ではない。

## 10.3 代表確認

自然Catch 1回で確認する。

- EvenMoreFish Custom Fishを取得
- Itemが1個だけ
- 同じCatchで重複mcMMO Lootなし
- mcMMO Fishing XP増加
- Waymark残高不変
- Errorなし

一回のCatchがVanilla Fishになった場合、Custom Fishが出るまで合理的な回数だけ続けてよい。

上限：

```text
最大20 Catch
```

20 Catch以内にCustom Fishが出ない場合：

- Weightを変更しない。
- Admin Giveだけで自然Catch成功扱いしない。
- Config、World Scope、Permission、Rarity Load、mcMMO競合、Logを調査する。
- 原因不明ならCommit／Pushせず報告する。

---

## 11. Permission Model

## 11.1 Admin

Temporary `wayfarer_admin`のGlobal `*`からEvenMoreFish管理を行う。

新しいAdmin Groupを作成しない。

恒久OPを使用しない。

## 11.2 Builder

`wayfarer_builder`へEvenMoreFish権限を追加しない。

Builder Phase 1Bでも、Fishing管理は原則Admin専用とする。

## 11.3 一般Player

LuckPerms `default`へ、Main Context限定で必要最小限のPlayer Permissionを追加する。

採用VersionのPlugin Metadata／Runtime Permission Checkで正確なNodeを確認する。

候補：

```text
emf.gui
emf.help
emf.toggle.fishing
emf.toggle.catchmessage
emf.applybaits
emf.journal
```

付与しない候補：

```text
emf.admin
emf.shop
emf.sellall
emf.top
emf.next
emf.toggle.bossbar
emf.admin.debug.*
```

`requires-fishing-permission: false`を採用するため、`emf.use_rod`は付与しない。

Base `emf.toggle`が複数Toggleをまとめて許可する場合は使用せず、採用Versionで存在するSpecific Toggle Nodeを使用する。

Main Context例：

```text
server=main
```

実際のLuckPerms Server Context値を確認する。

他BackendへGlobal付与しない。

Plugin Metadata上でPlayer PermissionがDefault trueなら、不要な重複Nodeを追加しない。

Permissionを推測しない。

---

## 12. GUI／Command Profile

一般Playerへ提供する候補：

```text
/emf
/emf gui
/emf help
/emf toggle fishing
/emf toggle catchMessage
/emf applybaits
/emf journal
```

提供しない。

```text
/emf shop
/emf sellall
/emf next
/emf top
/emf admin ...
```

Main Menu GUIにShop／Competition項目が表示される場合：

- 採用VersionのGUI Configで非表示化または無効Actionへ変更する。
- ClickしてErrorや無効なEconomy Screenへ入る状態を残さない。
- Journal、Help、Fishing Toggle、Bait等の採用機能だけを表示する。
- GUI Layoutの全面再設計は行わない。

Command AliasはVendor Defaultを維持する。

`/emfa`等のAdmin Shortcutが有効でも、PermissionはAdminだけとする。

---

## 13. Config追跡方針

生成物を分類する。

## 13.1 追跡候補

Projectが意図的に採用する非Secret Configを追跡する。

候補：

```text
servers/main/plugins/EvenMoreFish/config.yml
servers/main/plugins/EvenMoreFish/messages.yml
servers/main/plugins/EvenMoreFish/guis.yml
servers/main/plugins/EvenMoreFish/gui-fillers.yml
servers/main/plugins/EvenMoreFish/baits.yml
servers/main/plugins/EvenMoreFish/rarities/*.yml
servers/main/plugins/EvenMoreFish/competitions/*.yml
```

実際の生成FilenameとDirectoryを使用する。

ただし次を考慮する。

- Example Fileが起動時に毎回再生成される場合、原則追跡しない。
- Vendor Defaultから変更していない大規模Fileは、既存Repository方針と比較して追跡可否を決める。
- Runtime Secretを含む`config.yml`をそのまま追跡しない。
- Sanitized Templateが必要なら既存Renderer方式へ合わせる。
- Config Version Keyを変更しない。
- 日本語Messageの採用差分は追跡してよい。

## 13.2 追跡しない

- EvenMoreFish JAR
- Runtime Credential Config
- Database Password
- Database Dump
- SQLite File
- Cache
- Logs
- Player Data Export
- Runtime Backup
- Generated Addon Cache
- Debug Dump
- Temporary English Messages Backup
- Development Artifact

`.gitignore`へExactな除外を追加する。

過剰なWildcardで採用Configまで除外しない。

---

## 14. MariaDB作業

## 14.1 作成前確認

記録する。

- MariaDB Version
- Existing Database一覧
- Existing User名
- `wayfarer_evenmorefish`が未存在であること
- 名前Conflict
- Current Grants
- Docker／Service状態

Credential値をLogや完了報告へ出さない。

## 14.2 Database作成

既存Infrastructure方式に合わせて次を作成する。

```text
Database: wayfarer_evenmorefish
User: dedicated EvenMoreFish user
Charset: utf8mb4
Collation: existing project-compatible utf8mb4 collation
```

既存Databaseを変更しない。

Migration後に確認する。

- `emf_` PrefixのTableだけが対象Databaseに作成
- 他DatabaseへのTable作成なし
- Flyway／Migration History正常
- Startup Errorなし
- JOOQ Verbose Logなし

Table内容を手動変更しない。

## 14.3 Backup Scope更新

V0.1.0 Cold Backupへ、`wayfarer_evenmorefish` Database Dumpが含まれることを文書化する。

現時点でCold Backup Scriptは未実装なので、実装済みと記載しない。

---

## 15. 受入確認

## 15.1 Artifact／Placement

- 公式Stable Release
- 正確なVersion
- Minecraft 26.2対応
- Java 25でLoad
- SHA-256記録
- Mainだけに配置
- Lobby／Frontier／Velocityに存在しない
- JAR Git非追跡

## 15.2 Enable／Config

- EvenMoreFish正常Enable
- Locale `ja`
- Main Config読込
- Debug無効
- `main`／`resource`だけ許可
- Nether／End／Unknown World無効
- Catch有効
- Hunt無効
- Lava／Void無効
- `only-fish: true`
- Scheduled Competition無効
- 全Economy Provider無効
- Shop／Sellall無効
- MariaDB有効
- Startup Blocking ERROR／SEVERE／Exceptionなし

## 15.3 Admin Command

Temporary Adminで非破壊的代表Commandを一つ確認する。

推奨：

```text
/emf admin version
```

確認：

- Plugin Version
- Admin Permission
- OP不要

`/emf admin reload`は使用しない。

最終確認は正常Main Restartで行う。

## 15.4 一般Player Permission

Roleなし一般Playerで確認する。

成功：

- Custom Fishing
- `/emf`
- 採用したGUI／Help
- Journal
- 承認したToggle
- Bait Application GUI

拒否：

- Admin
- Shop
- Sellall
- Competition Start／End
- Database Debug
- 他Player対象Admin操作

Permission確認のために無関係なLuckPerms Nodeを追加しない。

## 15.5 Natural Catch

`main`または`resource` Overworldで自然Catchを行う。

条件：

- Survival
- 通常Fishing Rod
- Water Fishing
- Admin Roleなし
- 最大20 Catch
- Custom Fishを最低1件確認

記録する。

- World
- Biome
- Fish名
- Rarity
- Catch回数
- Item数
- Catch前後mcMMO Fishing XP
- Catch前後WM Balance
- Console Error

期待：

- EMF Fish 1個
- mcMMO Fishing XP増加
- WM Balance不変
- 重複Lootなし
- Item保護が有効

## 15.6 World Exclusion

Config境界を中心に確認する。

- `main_nether`でCustom Fishing対象外
- `main_the_end`で対象外
- `resource_nether`で対象外
- `resource_end`で対象外

各Dimensionで実釣りを繰り返さない。

採用VersionにWorld判定を表示する安全なDebug／Infoがある場合だけ利用してよい。

Debug Modeを有効化しない。

最低限、Config、Load Logおよび代表的な一つの対象外Worldで判定を確認する。

## 15.7 Database／Restart

1. Custom Fishを1件Catchする。
2. Journal／Statisticsへ反映されたことを確認する。
3. Mainを正常停止する。
4. MariaDBへ保存済みであることをTable存在と非SecretなCountで確認する。
5. Mainを正常起動する。
6. 同一PlayerのJournal／Statisticsが維持されることを確認する。
7. mcMMO Dataが通常どおり維持されることを確認する。
8. WM Balanceが変化していないことを確認する。

Databaseの全Row内容を完了報告へ記載しない。

## 15.8 Vanilla Fishing保持

Config確認：

- `only-fish: true`
- Hunt無効
- Lava／Void無効

Natural Treasureを得るまで長時間Fishingしない。

バニラTreasure／Junk保持はConfigと公式仕様で確認し、実Catchを必須にしない。

## 15.9 Restart

正常Main Restart後：

- EvenMoreFish Enable
- Config Scope維持
- Database接続
- Competition開始なし
- Economy無効
- Permission維持
- Journal維持
- Startup Blocking Errorなし

Network全体の広範なRegression Testは行わない。

確認不要：

- 全Fish
- 全Rarity
- 全Biome
- 全Bait
- 全GUI Slot
- 全Message
- 全Competition
- 全Reward Type
- 全Placeholder
- 全mcMMO Skill
- EconomyShopGUI取引
- BetterStructures生成
- Frontier接続
- Portal
- WorldGuard
- Backup／Restore

---

## 16. Failure／Rollback

Blocking条件：

- Official Artifact不一致
- Paper 26.2非対応
- Java 25 Load失敗
- Main以外へ配置
- MariaDB Migration失敗
- 他Databaseへの誤接続
- Secret露出
- Custom Fishが20 Catch以内に出ない
- mcMMO Fishing XPが増加しない
- 重複Loot
- WM残高が増減する
- Scheduled Competitionが開始
- Shop／Sellallが一般Playerに利用可能
- Journal／StatisticsがRestartで消失
- Startup Blocking Error
- Permission境界違反

Rollback：

1. Playerを切断する。
2. Mainを正常停止する。
3. EvenMoreFish JARをQuarantineへ移動する。
4. EvenMoreFish Runtime DirectoryをBackupへ移動する。
5. LuckPermsへ追加したEMF Player Permissionを戻す。
6. Renderer／Template変更を戻す。
7. Mainを起動する。
8. mcMMO、RedisEconomy、VaultUnlocked、Main起動を代表確認する。
9. `wayfarer_evenmorefish` Databaseは勝手にDropしない。
10. 作成済みDatabase／Userと失敗状態を報告する。

MariaDB Databaseを削除する必要がある場合は別途明示承認を得る。

広いPermission、Economy無効化解除、Weight変更、Development Build等で失敗を誤魔化さない。

---

## 17. Manifest／Version更新

実態に合わせて更新する。

- `versions.yml`
- `plugin-manifest.yml`
- `plugin-collection.csv`
- `docs/08-plugin-collection.md`

EvenMoreFish項目へ最低限記録する。

- Version
- Reported Version
- Channel
- Platform
- Minecraft Compatibility
- Java Requirement
- Runtime Java
- Status：installed-and-verified
- Placement：Main only
- Excluded Placement
- Purpose
- Official Source
- License
- JAR Filename
- SHA-256
- Artifact Acquisition：manual
- Reload Policy：full Main restart only
- Locale：ja
- Allowed Worlds：main, resource
- Excluded Dimensions
- Catch／Hunt／Lava／Void Policy
- `only-fish`
- Competition Policy
- Economy Policy
- MariaDB Database
- Table Prefix
- Credential Policy
- mcMMO Boundary
- Permission Boundary
- Verification Result

現在の`planned-not-installed`項目を、実装結果に基づいて置換する。

---

## 18. 文書更新

必要な範囲だけ更新する。

最低限：

- `README.md`
- `AGENTS.md`
- `docs/00-design-guide.md`
- `docs/01-architecture.md`
- `docs/02-installation.md`
- `docs/03-operations.md`
- `docs/04-play-guide.md`
- `docs/05-troubleshooting.md`
- `docs/06-acceptance-tests.md`
- `docs/08-plugin-collection.md`
- `docs/09-roadmap.md`
- `docs/11-deferred-design-items.md`
- `versions.yml`
- `plugin-manifest.yml`
- `plugin-collection.csv`
- `codex/README.md`

本指示書を次へ保存する。

```text
codex/Project_Wayfarer_Phase4_EvenMoreFish_Integration.md
```

記載する。

- EvenMoreFish Main限定
- 正確なVersion
- Main／Resource Overworldだけ
- Vanilla Treasure／Junk維持
- Fish Hunting無効
- Lava／Void無効
- Competition無効
- WM Economy無効
- Journal／Statistics MariaDB永続化
- mcMMO Fishing XP維持
- Player Command
- Admin-only Command
- Full Restart Policy
- Cold Backup対象Database
- V0.1.0ではFish価格Balanceを未導入

### Roadmap

Phase 4を実施結果に基づき完了へ更新する。

次の実装タスク：

```text
CoreProtect
```

Dependency-based execution orderを維持する。

CoreProtectはHub／Gate本格建築前に導入する。

Playable Frontier ThemeはCoreProtect後。

Main Spawn保護はユーザーの初期Hub整備後。

Phase 1BはTheme／Advanced Portals／Builder作業確定後。

### Acceptance Tests

完了候補：

- Version／Artifact
- Main限定配置
- Config Load
- World Scope
- Custom Fish Catch
- mcMMO XP共存
- No duplicate loot
- No WM change
- MariaDB
- Restart Persistence
- Permission Boundary

未確認項目を完了扱いしない。

### Troubleshooting

最低限記録する。

- Custom Fishが出ない
- Wrong World
- MariaDB接続失敗
- Config Version mismatch
- mcMMO XPが増えない
- Duplicate Loot
- EMF Shopが見える
- Competitionが始まる
- Japanese Message再生成
- JournalがRestartで消える

Debug Database Commandを通常復旧手順にしない。

---

## 19. `codex/README.md`

Phase 4指示書を履歴へ追加する。

- Task：Phase 4 EvenMoreFish Integration
- 状態：完了後は完了
- 実施日
- Commit SHA
- 現行正本：Plugin Manifest、Roadmap、Acceptance Tests
- 再実行禁止
- Note：Version／Configは将来更新される可能性がある

`codex/`をRuntime仕様の正本にしない。

---

## 20. Cleanup

Commit前に確認する。

- Temporary Admin Parent解除
- OPなし
- Test Permissionなし
- Test Competitionなし
- Active Competitionなし
- Debug無効
- JOOQ Debug無効
- Shop／Sellall無効
- Economy全Provider無効
- WM Balance復元不要
- Test Fishの扱いを記録
- 不要なAdmin Give Itemなし
- Main正常状態
- EvenMoreFish JAR非Stage
- Runtime Secret Config非Stage
- Database Credential非Stage
- Log／Cache非Stage
- English Message Backup非Stage
- Lobby／Frontier／VelocityにJARなし

自然CatchしたFishは通常のTest Itemとして破棄してよい。

破棄時にWMへ売却しない。

---

## 21. Commit前検査

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
.\scripts\Render-LocalConfigs.ps1
.\scripts\Test-Layout.ps1
```

存在しないScriptを作業完了のためだけに新設しない。

YAML／CSVを安全なParserで確認する。

確認：

- Secretなし
- JARなし
- Database Dumpなし
- Log／Cacheなし
- EvenMoreFish Main限定
- Version正確
- SHA-256記録
- World Scope正確
- `main_end`と`main_the_end`を混同していない
- Economy無効
- Competition無効
- mcMMO XP維持
- Database正確
- V0.1.0を完成扱いしていない
- CoreProtectを導入済みと書いていない
- Frontier Themeを導入済みと書いていない
- Main Spawn保護を実装済みと書いていない
- V0.2.x独自Pluginへ着手していない
- GitHub CLIを検索していない
- 無関係なRegression Testを行っていない

---

## 22. Commit／Push条件

次をすべて満たした場合だけCommit／Pushする。

- 公式Stable Artifact
- Paper 26.2／Java 25互換
- SHA-256記録
- Main Only配置
- 正常Enable
- Locale `ja`
- Catch有効
- `only-fish: true`
- Hunt無効
- Lava／Void無効
- `main`／`resource`だけ許可
- Unknown World無効
- Economy全Provider無効
- Shop／Sellall無効
- Competition無効
- Dedicated MariaDB接続
- `emf_` Table正常
- Secret非追跡
- Custom Fish自然Catch成功
- mcMMO Fishing XP増加
- Duplicate Lootなし
- WM Balance不変
- Restart後Journal／Statistics維持
- Permission境界正常
- Temporary Admin Cleanup
- Manifest／Version／文書更新
- Phase 4完了
- 次TaskがCoreProtect
- `git diff --check`成功
- Repository検査成功

Blocking失敗時：

- Commitしない。
- Pushしない。
- Development Buildへ切り替えない。
- Weightを上げて自然Catchを誤魔化さない。
- Economyを有効化しない。
- mcMMOを無効化しない。
- Database Debug Clean／Repairを実行しない。
- 広いPermissionを付与しない。
- JAR、Config、Database、PermissionのRollback状態を報告する。

推奨Commit Message：

```text
feat: EvenMoreFishをMainへ導入
```

既存`main`へ直接Pushする。

Pull Requestは作成しない。

GitHub CLIは探さない。

---

## 23. 完了報告

完了時に報告する。

- 作業開始時HEAD
- EvenMoreFish Version／Reported Version
- Official Source
- JAR Filename
- SHA-256
- Paper／Java互換性
- Placement
- Excluded Placement
- Locale
- Allowed Worlds
- Excluded Dimensions
- Catch／Hunt／Lava／Void設定
- `only-fish`
- Competition設定
- Economy設定
- MariaDB Database／Table Prefix
- Credential分離
- mcMMO `disable-mcmmo-loot`
- mcMMO Overfishing確認
- 一般Player Permission
- Admin Permission
- Natural Catch結果
- mcMMO XP前後
- WM Balance前後
- Duplicate Loot結果
- Restart Persistence
- Startup Log結果
- 変更ファイル
- 実行した検査
- Temporary Admin Cleanup
- Commit SHA
- Push先Branch
- Phase 4完了
- 次の実装タスクがCoreProtectであること

Credential、Password、Player名、UUID、Database Row内容は報告へ記載しない。
