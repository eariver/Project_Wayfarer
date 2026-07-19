# Project Wayfarer 設計・導入・運用ガイド Ver.0.0.3

## 1. 文書の位置付け

このファイルはProject Wayfarerリポジトリ内の正式な設計基準です。

|区分|値|
|---|---|
|Document revision|Ver.0.0.3|
|更新日|2026-07-20|
|Runtime software versions|`versions.yml`と`plugin-manifest.yml`を正本とする|
|Future server release|未決定|

Ver.0.0.3は設計・導入・運用文書の改訂番号であり、稼働ServerのRelease番号ではありません。現段階ではGit TagおよびGitHub Releaseを作成しません。

## 2. Projectの目的とScope

Project Wayfarerは、ユーザー本人と関係者による小規模運用を想定したMinecraft Networkです。

- Lobbyは初期接続、待機、案内および障害時のFailoverを担当する。
- Mainは恒久生活、建築、保管および通常Survivalの拠点とする。
- Frontierは既製Adventure Contentを扱う独立した環境とする。
- LABは将来の検証用Componentとし、承認された導入タスクまで起動対象にしない。

このリポジトリはConfig、設計、導入・運用Script、Version制約および外部PluginとのIntegration情報の正本です。独自PluginのSource、Build ProjectおよびRelease成果物は含めず、必要なPluginごとに別Repositoryで開発・Releaseします。

## 3. 現在のNetwork構成

```text
Minecraft Client 26.2
        |
        v
Velocity :25565 / Java 25
  |-- Lobby :25566 / Paper 26.2 / Java 25
  |-- Main :25567 / Paper 26.2 / Java 25
  `-- Frontier :25568 / Paper 1.21.11 / Java 25
```

- 全Paper Backendは`127.0.0.2`へBindする。
- Player向けEndpointはVelocityだけとする。
- Velocity Modern Forwardingを使用する。
- Lobbyを初期接続先およびFailover先とする。
- ViaVersionはVelocityだけに配置する。
- ViaBackwardsは導入および依存関係への追加を禁止する。

## 4. Infrastructure

Docker ComposeでMariaDB 11.8とRedis 8-alpineを管理します。

|Database|用途|
|---|---|
|`wayfarer_luckperms`|導入済みLuckPerms共有Storage|
|`wayfarer_mcmmo`|導入済みmcMMOのMain／Frontier共有Storage|
|`wayfarer_network`|将来のNetwork機能用に予約|

RedisはMain／FrontierのWaymark共有残高に使用し、AOFを有効にしています。RedisEconomyのPasswordを含むRuntime ConfigはSanitized TemplateからRenderします。Password、Forwarding SecretおよびCredentialは`.env`とIgnored Runtime Configで管理し、追跡文書やGit差分へ含めません。

## 5. 導入済み基盤

### Velocity

- Velocity 4.1.0-SNAPSHOT selected build 8 / Java 25
- ViaVersion 5.11.0
- LuckPerms 5.5.60
- TAB 6.1.0
- VelocityScoreboardAPI 2.1.0

### 全Paper Backend

- Java 25
- LuckPerms 5.5.60
- WorldEdit 7.4.4
- WorldGuard 7.0.17
- TAB-Bridge 6.2.2
- PlaceholderAPI 2.12.3
- Multiverse-Core 5.7.2

### LobbyとFrontier

- VoidGen 2.3.8
- `lobby`および`frontier_gate`はVoid World
- NetherとEndは無効
- Y=63に17x17の仮設Stone安全Platformと金の中心Block
- Spawnは`(0, 64, 0)`
- `keepInventory=true`、`spawnRadius=0`

### WorldGuard

Lobbyと`frontier_gate`は`__global__` Regionで`passthrough=deny`とし、`build` Flagは使用しません。`wayfarer_builder`だけが建築でき、WorldEdit／WorldGuard権限は`server=lobby`および`server=frontier` Contextに限定します。MainにはPluginを配置していますが、Project固有Region、Global Flag、MemberおよびOwnerはまだ設定していません。

### TAB

Proxy Installation方式を採用します。TAB本体とVelocityScoreboardAPIはVelocityだけに、TAB-BridgeとPlaceholderAPIは全Paper Backendだけに配置します。Headerは`Project Wayfarer`、Footerは現在のServer、Network Online人数およびPingです。Sidebar、Bossbar、Layout等は未使用です。PlaceholderAPI Expansionは未導入で、必要になった場合も手動取得方針に従います。

### Multiverse

Multiverse-Core 5.7.2は全Paper Backendだけに配置します。LobbyとFrontierは既存の`lobby`／`frontier_gate` Entry Worldだけを登録し、MainはPersistent FamilyとDisposable Resource Familyを管理します。Multiverse-NetherPortals 5.0.5はMainだけに配置し、Family内のNether／Endを方向ごとに明示Linkします。両Familyを交差させません。

Paper 26.2の実Runtime Keyは`minecraft:overworld`、`minecraft:the_nether`、`minecraft:the_end`、`minecraft:resource`、`minecraft:resource_nether`、`minecraft:resource_end`です。論理名は実World名または文書上の名称として扱い、名前が異なるMain EndだけMultiverse Alias `main_end`を設定します。これらはDirectory名ではありません。既存Worldを論理名へ合わせてRename、Move、Copyまたは再生成しません。

### mcMMO

mcMMO 2.3.000はMainとFrontierだけに配置し、同一のLocal Maven Build JARを使用します。進行はMariaDB Database `wayfarer_mcmmo`とTable Prefix `mcmmo_`で共有します。LobbyとVelocityには配置せず、通常Inventory、Vanilla XP、Health等のBackend固有Dataは共有しません。

Credentialを含むRuntime `config.yml`はGit Ignore対象とし、Main／FrontierそれぞれのSanitized `config.yml.template`から`Render-mcMMOConfig.ps1`で生成します。mcMMOのScoreboardはTABとの競合を避けるため無効です。Server切替時のRollbackまたは古いProfileによる上書きはData Integrity障害として扱い、PlugManXでReload／Unloadせず正常再起動します。

### Waymark

RedisEconomy `4.5.12-wayfarer.1`とVaultUnlocked 2.20.2はMain／Frontierだけに配置します。Project上の論理識別名は`waymark`、表示名はWaymark、単位はWM、RedisEconomyのVault Currency Keyは`vault`です。初期残高は0で、両Backendは共有`clusterId: waymark`と別々のRedis Client Name `main`／`frontier`を使用します。

Passwordを含むRuntime ConfigはGit Ignore対象とし、BackendごとのSanitized Templateから`Render-RedisEconomyConfig.ps1`で生成します。RedisEconomyはPlugManXでReload／Unloadせず正常再起動します。残高の巻き戻り、二重反映または消失はBlocking Data Integrity Failureです。Redis AOFは0.1.0以降のCold Backup必須対象であり、Redis Containerを正常停止してからVolumeをFilesystem Backupします。Hot／Warm Backup Pluginは採用しません。

### Main Waymarkショップ

EconomyShopGUI 7.1.1 FreeはMainだけに配置し、Vault経由でRedisEconomyの`vault`通貨を使用します。初期ショップは資源売却、農業品売却、Mob素材売却、建築資材、生活用品の5カテゴリ、合計62商品です。価格は1個あたり0.01 WM単位までの固定Alpha Baselineとし、同じ商品の購入価格を売却価格より必ず高くします。

一般プレイヤーには`server=main` Contextでショップ閲覧と5カテゴリの利用権限だけを付与します。一括売却、編集、Reload、Give、Update、Debug、BypassおよびWildcard管理権限は付与しません。Dynamic Pricing、Global Stock、Player Shop、税および自動価格調整は未使用です。Config変更後はMainを正常再起動し、EconomyShopGUI、RedisEconomyおよびVaultUnlockedをReload／Unloadしません。価格の正本は[Waymark Economy](10-waymark-economy.md)です。

## 6. Data Boundary

|Data|Lobby|Main|Frontier|
|---|---|---|---|
|通常Inventory|Local|Local|Local|
|Ender Chest／XP／Health|Local|Local|Local|
|LuckPerms|Shared|Shared|Shared|
|TAB|Network|Network|Network|
|Waymark|使用しない|Frontierと共有|Mainと共有|
|Waymark Shop|導入しない|EconomyShopGUI 7.1.1|導入しない|
|mcMMO|導入しない|Frontierと共有|Mainと共有|
|WorldGuard|Entry World全体保護|Pluginのみ・保護未設定|Entry World全体保護|

Waymark共有残高、Main初期WaymarkショップおよびmcMMO共有進行は導入済みです。Advanced Portals、BetterStructures、EvenMoreFish、EliteMobs、Frontier／Quest等のWaymark報酬およびCross-server Chatは未導入であり、計画上の機能を導入済みとして扱いません。

## 7. Plugin取得・導入ポリシー

1. ユーザーが公式SourceからPlugin JARを手動取得する。
2. JARをIgnoredな`manual-downloads/`配下へ配置する。
3. CodexがVersion、Platform、配置先、Metadata、通常のJARとしての読取可否およびSHA-256を確認する。
4. Codexが承認済みJARを対象Runtime Directoryへコピーする。
5. 正確なVersionを一度起動し、生成Configと公式文書を確認してから編集する。

Codexは個別タスクの明示承認なしにJARをDownloadしません。JAR、World、Player Data、Database Data、Secret、LogおよびCacheはCommitしません。Pluginの自動Updateと自動JAR置換は原則無効とし、PlaceholderAPI Expansionにも同じ手動取得方針を適用します。

## 8. Plugin導入タスクの単位

同じ機能領域、依存関係、配置対象、Database／連携境界およびClient受入試験を共有するPlugin群は、一つの検証済みタスクとしてまとめて構いません。

例：

- Multiverse-Core + Multiverse-NetherPortals
- RedisEconomy + VaultUnlocked
- Advanced PortalsのProxy Component + Backend Components

World削除・再生成、Database Migration、共有Progression／Economy、Permission／Security Boundary、Protocol変換、大規模Content Packなど、失敗時の影響や切り分けRiskが大きい作業は独立タスクとします。

## 9. 検証粒度の標準

通常の既成Plugin導入では、Plugin内部の網羅的な品質保証ではなくProject WayfarerへのIntegrationを確認します。

1. VersionとPlatform
2. 配置先と依存関係
3. 対象RuntimeでのEnable
4. 採用目的に関係する主要Config
5. 代表的機能の一度のSmoke Test
6. 既存構成の明らかなRegression有無
7. JAR、Secret、World、Log等のGit除外

全Command、全Config Key、全機能組合せ、同一操作の多数回反復およびPlugin内部実装の品質保証は通常不要です。軽微な設定不備は運用中に発見した時点で後続Commitにより修正できます。

World、Player／Database Data、Economy、共有Progression、Inventory同期、Permission、Secret、接続経路、Protocol変換、Portal／Dimension Family、Backup／Restore、Failoverおよび不可逆な作業は詳細検証を維持します。

## 10. PlugManX将来導入方針

PlugManXはAdministration／Development用途のplanned Componentです。Versionは未選定で、Paper 26.2／Java 25とPaper 1.21.11／Java 25の双方に対応する安定版を導入タスク時に選定します。対象はLobby、Main、Frontierであり、Velocityには配置しません。取得は手動です。

通常運用ではServer Restartを標準とし、PlugManXの全権限は管理者だけに付与します。LuckPerms、WorldEdit、WorldGuard、VoidGen、TAB-Bridge、PlaceholderAPI、Multiverse系、EconomyShopGUI、Economy Provider、Vault系、mcMMO、Library PluginおよびWorld／Database／Protocol／Permissionを管理するPluginは、原則としてReload／Unload対象にしません。

独自Pluginは最初にTest用PluginでPoCし、Listener、Scheduler、Command／Brigadier、Bukkit Service、Database Connection、File Handle、Thread、Static ReferenceおよびCacheを`onDisable()`で確実に解放できることを確認したPluginだけをReload許可対象にします。Ver.0.0.3ではPlugManXを導入しません。

## 11. Roadmapと関連文書

今後の導入候補と依存関係は[Roadmap](09-roadmap.md)で管理します。導入済みVersionとHashは`versions.yml`、配置・取得・依存方針は`plugin-manifest.yml`、運用手順は[Operations](03-operations.md)、検証済み事実は[Acceptance Tests](06-acceptance-tests.md)を参照してください。
