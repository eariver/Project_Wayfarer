# Project Wayfarer 設計・導入・運用ガイド Ver.0.0.5

## 1. 文書の位置付け

このファイルはProject Wayfarerリポジトリ内の正式な設計基準です。

|区分|値|
|---|---|
|Document revision|Ver.0.0.5|
|更新日|2026-07-21|
|Runtime software versions|`versions.yml`と`plugin-manifest.yml`を正本とする|
|Target server release|V0.1.0 Alpha（未達）|

Ver.0.0.5はPhase 3完了後の実態、V0.1.0 Alphaまでの依存順序、およびMain Spawn保護方針を統合する文書Revisionです。稼働ServerのRelease番号ではなく、`V0.1.0 Alpha`は未達です。Baseline Backupと隔離Restoreを含むBlocker完了時にGit Tag／GitHub Releaseの採用を最終決定します。

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

Lobbyと`frontier_gate`は`__global__` Regionで`passthrough=deny`とし、`build` Flagは使用しません。現行Runtimeでは`wayfarer_builder`だけがRegion Memberとして建築でき、Phase 1Aで既存のWorldEdit／WorldGuard管理権限を除去済みです。MainにはPluginを配置していますが、Project固有Region、Global Flag、MemberおよびOwnerはまだ設定していません。Phase 1Bの最終Builder Allowlistは未実装であり、現行のRegion Member建築と混同しません。

Main Spawn保護は設計済み・未実装です。ユーザーが初期Spawn Hubを概ね整備した後、別タスクで仮称`main_spawn_hub`のExact範囲を承認して適用します。一般PlayerはWorldGuardの標準Membership保護で設置・破壊不可、`wayfarer_builder`はMemberとして建築可、Temporary Adminは管理可とし、`build` Flagは使用しません。Region全体では公開Door／Button等に`use allow`だけを候補とし、広範な`interact allow`や`chest-access allow`は避けます。特殊設備は`main_spawn_tool_station`、`main_spawn_public_storage`、`main_spawn_gate_control`等の高Priorityな小Regionへ分離し、必要なFlagだけを付け、必要性を確認できた場合だけ`passthrough allow`を検討します。

環境保護候補は次のとおりです。これは設計候補であり、適用時にWorldGuard 7.0.17 Runtimeの正確なFlag名を確認します。

```text
pvp deny
tnt deny
creeper-explosion deny
other-explosion deny
wither-damage deny
ghast-fireball deny
enderdragon-block-damage deny
enderman-grief deny
ravager-grief deny
lighter deny
fire-spread deny
```

`mob-spawning`と`mob-damage`はHub内の遊び方確定後に決定します。現行Vanilla `spawn-protection=16`はRegion実装まで維持し、WorldGuardとBuilder Member動作の検証後にだけ、別タスクで0へ統一する候補とします。

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

Passwordを含むRuntime ConfigはGit Ignore対象とし、BackendごとのSanitized Templateから`Render-RedisEconomyConfig.ps1`で生成します。RedisEconomyはPlugManXでReload／Unloadせず正常再起動します。残高の巻き戻り、二重反映または消失はBlocking Data Integrity Failureです。Redis AOFはV0.1.0以降のCold Backup必須対象であり、Redis Containerを正常停止してからVolumeをFilesystem Backupします。Hot／Warm Backup Pluginは採用しません。

### Main Waymarkショップ

EconomyShopGUI 7.1.1 FreeはMainだけに配置し、Vault経由でRedisEconomyの`vault`通貨を使用します。初期ショップは資源売却、農業品売却、Mob素材売却、建築資材、生活用品の5カテゴリ、合計62商品です。価格は1個あたり0.01 WM単位までの固定Alpha Baselineとし、同じ商品の購入価格を売却価格より必ず高くします。

一般プレイヤーには`server=main` Contextでショップ閲覧と5カテゴリの利用権限だけを付与します。一括売却、編集、Reload、Give、Update、Debug、BypassおよびWildcard管理権限は付与しません。Dynamic Pricing、Global Stock、Player Shop、税および自動価格調整は未使用です。Config変更後はMainを正常再起動し、EconomyShopGUI、RedisEconomyおよびVaultUnlockedをReload／Unloadしません。価格の正本は[Waymark Economy](10-waymark-economy.md)です。

### Main Structure生成

BetterStructures 2.6.3はMainだけに導入し、公式無料Pack `103 Default Structures` version 5だけを使用します。Bukkit実World名`main`、`main_nether`、`main_the_end`の新規Chunkだけを生成対象とし、`resource`、`resource_nether`、`resource_end`および未知の新規Worldは無効です。Plugin JARとContent ZIP／展開済みSchematicは手動取得・Git非追跡で、自動Plugin Downloadは無効です。既定の`spawnProtectionRadius: 100`はユーザー承認のうえ維持しました。

Phase 3 Main最終生成は2026-07-21に完了しています。3つのPersistent DimensionはSeed `164225356311935743`で生成し、Overworld Spawn `(320, 70, 128)`、Nether管理Spawn `(20.5, 60, -19.5)`、End管理Spawn `(100.5, 49, 0.5)`を安全確認済みです。Resource FamilyはUUID、SeedおよびRegion Dataを保持しました。正確なWorld名、Storage Path、World UUID、BackupおよびRollback条件は[Main World Baseline](13-main-world-baseline.md)を正本とします。Hub／Gate構造は未実装です。

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
|WorldGuard|Entry World全体保護|Pluginのみ。Spawn保護は設計済み・未実装|Entry World全体保護|

Waymark共有残高、Main初期Waymarkショップ、mcMMO共有進行およびMain限定BetterStructures基盤は導入済みです。Advanced Portals、EvenMoreFish、EliteMobs、Frontier／Quest等のWaymark報酬およびCross-server Chatは未導入であり、計画上の機能を導入済みとして扱いません。

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

公式配布された通常の既成Pluginでは、Project Wayfarerが担当するIntegrationだけを確認します。

1. 正確なVersionとPlatform
2. 公式配布元
3. 配置先
4. 必須依存関係
5. 対象RuntimeでのEnable
6. Project Wayfarerが作成・変更した主要Configの読込
7. 採用目的を代表するCommand 1件またはGUI Open 1回
8. 起動を阻害する明白なERROR／SEVERE／Exceptionがないこと
9. JAR、Secret、World、Database Data、Log、Cache等のGit除外

通常Pluginでは、全Command、全Config Key、全機能組合せ、Inventory満杯／再接続／二重処理等の例外ケース、Plugin内部品質、無関係な既存PluginおよびNetwork全体のRegressionを要求しません。当該PluginがEnableされ、採用Configが読み込まれ、代表機能を一度利用できれば完了です。

詳細検証はLocal Build、Source改変／互換修正、Project独自Plugin、具体的な不具合、World操作、Database Migration、共有Economy／Progression基盤、Inventory同期／Server間Item移動、Permission／Secret／Security Boundary、接続経路、Protocol変換、Portal／Dimension Routing、Backup／Restore、Failover、不可逆作業およびユーザー明示指定に限定します。回帰試験も変更した基盤へ直接関係する範囲だけを対象とします。

## 10. Ver.0.0.5権限モデル

Phase 1Aの権限基盤は2026-07-20に実装・検証済みです。Phase 1BのBuilder最終Allowlistは未実装であり、V0.1.0 Release Blockerとして残します。正確なRuntime Node、操作例、復旧手順および検証結果は[Permission Model](12-permission-model.md)を正本とします。

|Group|Group definition|Player membership|目的|
|---|---|---|---|
|`default`|恒久|恒久／通常|通常プレイヤー|
|`wayfarer_builder_eligible`|恒久|恒久Eligibility|`default`相当＋自分をBuilderへ一時昇格できる資格|
|`wayfarer_admin_eligible`|恒久|恒久Eligibility|`default`相当＋自分をAdminへ一時昇格できる資格|
|`wayfarer_builder`|恒久Role定義|Temporary Parent|World建築・設定作業|
|`wayfarer_admin`|恒久Role定義|Temporary Parent|Network全体の管理作業|

Eligibility Groupは独立して複数人へ付与でき、両方の資格保持も許可します。ただしGameplay権限は`default`相当で、恒久的な実Role、他人の昇格、任意Group／Permission操作は許可しません。自分自身に対する対応RoleのTemporary Parent追加・解除だけをArgument-based Command Permissions等のLuckPerms正式機能で制限します。

`default`と`wayfarer_builder`はPhase 1Aで監査・再利用しました。`wayfarer_builder`を削除、同名再作成またはPrimary Group化せず、Lobby／`frontier_gate`のWorldGuard Global Region Member参照を維持しています。既存の`worldedit.*`／`worldguard.*`管理Permissionは除去済みで、現在のBuilder Role Containerは`default`継承だけです。Region MemberであることとWorldGuard管理Command権限は別の境界です。

`wayfarer_builder_eligible`、`wayfarer_admin_eligible`および`wayfarer_admin`は競合確認後に作成済みです。Role Group定義自体は恒久であり、一時なのはPlayerから`wayfarer_builder`／`wayfarer_admin`へのParent所属です。

Builder所属は2時間、Admin所属は30分を標準運用値としますが、Ver.0.0.5でも技術的に固定しません。実行時に期限を指定し、作業終了時は期限前でも自己降格します。EligibilityはVelocity上の`/lpv`だけへ限定され、永続Parent追加、他人へのRole操作、誤ったRoleおよび任意Group操作を拒否します。複数RoleへのTemporary Parent所属は同時に保持しない運用とします。

`wayfarer_admin`はGlobal `*`によりVelocity、全Paper、Vanilla管理、導入済みPlugin、LuckPerms、Economy、World、PlayerおよびServer停止Commandを含む全権限方式です。全権限はEligibilityではなく、PlayerがAdmin RoleへTemporary Parent所属している間だけ与え、OPには依存しません。一方、停止済みServerの起動、Windows Process、Docker、Database、Cold Backup／Restoreおよび応答不能Serverの復旧はMinecraft Permissionで代替せず、将来の統合PowerShellが担当します。

Phase 1Bの`wayfarer_builder`は明示Allowlist方式です。候補となるWorldEdit、Creative／Survival／Spectator切替およびTeleportはLobby／Main／Frontier、Multiverse-Coreは全Paper Backend、Multiverse-NetherPortalsはMainだけを対象にします。Advanced PortalsのPermission体系、Playable Frontier ThemeおよびBuilderが担当するHub／Gate作業の確定後、採用Versionの実Commandから必要な操作だけを列挙します。

BuilderにはWorldGuard Region管理、Velocity管理、LuckPerms、Economy、Player処分、Server停止、Plugin／Config Reload、Debug／Internal管理またはWildcardを付与しません。World削除、Clone、再生成、Data PurgeおよびImport／Unload等のData Lifecycle操作はAdminだけに残します。Advanced Portals管理は導入時に別途検討します。Phase 1Aではこれらの管理権限がすべて未付与であることを確認済みです。

Builder作業終了時は、保存状態を確認し、Survivalへ戻し、必要なら安全地点へ移動し、Temporary Parentを自己解除して権限消失を確認します。期限切れだけではCreative／Spectator状態が戻らないため、これはV0.1.0でも必要な運用手順です。

## 11. V0.1.0 Alpha完成方針

V0.1.0ではMainのバニラに近いSurvivalを、mcMMO、Waymark、固定価格Shop、BetterStructures、EvenMoreFish等で軽く拡張します。Frontierには拡張性を体験できるPlayable Themeを1つ導入し、Lobby／Main／Frontier／Resourceの必須Gate、権限切替、統合運用Script、Cold Backup／RestoreおよびBaseline Backupを成立させます。大規模な独自Progressionや複数Themeは完成条件にしません。

Frontier ThemeはVer.0.0.5でも未選定です。Paper 1.21.11／Java 25互換性、導入方式、License、費用、依存Plugin、Resource Pack、Content Worldおよび探索／戦闘／Dungeon／Quest等の遊びを比較し、ユーザー承認後に導入します。V0.1.0はFrontier通常Inventoryと共有mcMMOを使用し、WM報酬、Theme実績、Main側報酬、Theme別Inventoryおよび初期装備を実装しません。World Generator単体をPlayable Theme要件達成とは扱いません。

## 12. World／Gate完成条件

- Lobby最低限Hub: Login到着、Main Gate、Frontier Gate、安全な案内、既存保護。
- Main初期Spawn Hub: Lobby Return、Frontier Gate、`resource`、`resource_nether`、`resource_end`への独立Gateと安全な初期Spawn／Respawn。
- Frontier Gate Hub: Lobby Return、Main Hub、最初のPlayable ThemeへのGate、Themeからの安全な帰還地点、既存保護、最低限の案内。
- 各Resource World: 安全な到着地点とMain HubへのReturn Gate。
- `resource_end`: Dragon Exit Portal／End Gatewayに依存しない安全な外周島到着地点とReturn Gate。

Hub外観、座標、向き、建築物および安全到着地点はユーザーが手作業で確定します。Codexはそれらが確定するまで接続を推測せず、確定後のGate設定、Spawn設定、必要な保護、検証および文書化を後続タスクで行います。現時点ではHub建築もGate接続も完了していません。

Resource World再生成Workflowは、安全到着、同一または同等のReturn Gate構造、Gate再設定、Spawn／Arrival設定、必要な保護、Main Hubへの帰還確認およびPersistent World非変更をPost-reset Bootstrapとして実行できなければなりません。`resource_end`外周島拠点も復元対象です。Schematic、追跡Template、Idempotent Script／Command、将来の独自Pluginまたは組合せから後続タスクで方式を選定します。

独自Pluginを作らずに残す妥協事項と再検討時期は[Deferred Design Items](11-deferred-design-items.md)を正本とします。

## 13. PlugManX将来導入方針

PlugManXはAdministration／Development用途のplanned Componentです。Versionは未選定で、Paper 26.2／Java 25とPaper 1.21.11／Java 25の双方に対応する安定版を導入タスク時に選定します。対象はLobby、Main、Frontierであり、Velocityには配置しません。取得は手動です。

通常運用ではServer Restartを標準とし、PlugManXの全権限は管理者だけに付与します。LuckPerms、WorldEdit、WorldGuard、VoidGen、TAB-Bridge、PlaceholderAPI、Multiverse系、EconomyShopGUI、Economy Provider、Vault系、mcMMO、Library PluginおよびWorld／Database／Protocol／Permissionを管理するPluginは、原則としてReload／Unload対象にしません。

独自Pluginは最初にTest用PluginでPoCし、Listener、Scheduler、Command／Brigadier、Bukkit Service、Database Connection、File Handle、Thread、Static ReferenceおよびCacheを`onDisable()`で確実に解放できることを確認したPluginだけをReload許可対象にします。Ver.0.0.5ではPlugManXを導入せず、V0.1.0 Release Blockerにも含めません。

V0.2.x以降の独自Plugin構想は`codex/Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md`へ参考草案として保存します。V0.1.0 Alphaの実装対象またはRelease Blockerには含めず、別途承認された正式設計、専用Repositoryおよび実装タスクまで開発、Database Migration、Source作成またはArtifact作成へ着手しません。

## 14. Roadmapと関連文書

V0.1.0までの実施順とBlockerは[Roadmap](09-roadmap.md)で管理します。現時点の次作業はEvenMoreFishで、その後にCoreProtectをHub／Gate本格建築より前へ導入します。Playable Frontier ThemeとAdvanced PortalsのVersion／Permission、Builder担当作業を確定してからPhase 1Bを実施し、ユーザー建築、Main Spawn保護、Routing、Resource Bootstrap、統合運用、Cold Backup／隔離Restore、V0.1.0 Baselineの順に進めます。導入済みVersionとHashは`versions.yml`、配置・取得・依存方針は`plugin-manifest.yml`、運用手順は[Operations](03-operations.md)、検証済み事実と未達Blockerは[Acceptance Tests](06-acceptance-tests.md)、将来課題は[Deferred Design Items](11-deferred-design-items.md)を参照してください。
