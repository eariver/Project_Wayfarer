# Project Wayfarer Worlds Beyond Plugin Concept v0.0.4

> **状態:** Under Review  
> **保存先:** Project Wayfarer Repository `concepts/plugins/frontier/`  
> **関連Concept:** `../Project_Wayfarer_Plugin_Concept_v0.0.3.md`  
> **関連Theme Concept:** `concepts/frontier/Worlds_Beyond_Specification_V0.0.6.md`（Frontier検討チャットで同期改訂）  
> **対象Runtime:** Frontier  
> **想定Runtime Plugin:** `Wayfarer_Frontier`  
> **実装状態:** 未着手

---

## 1. 目的

本Conceptは、Worlds Beyond MVPのうち独自Pluginが担当する範囲を定義する。

World構成、Iris、MVI Group、Difficulty、Waystone LifecycleおよびTheme全体のGameplayは、Project Wayfarerの現行Worlds Beyond／Frontier ConceptとV0.1.0 Scopeを参照する。

本Conceptは、既製Pluginの機能を再実装せず、次のWayfarer固有機能へ責務を限定する。

- Traversal Loadout
- Elytra／LeafGrappleのIdentityとSoulbind
- Navigation Item
- Launchpad
- Frontier WM Shop
- WaystoneのWayfarer固有Domain
- Discovery／Teleport GUI
- Pending Delivery
- Admin／Reconcile／Audit

---

## 2. 責務境界

`Wayfarer_Frontier`が担当する。

- `frontier_iris`初回Loadout
- 恒久Traversal ItemのOwner Bind
- `frontier_iris`-bound Use
- Reissue／Instance失効
- LeafGrapple Adapter
- Launchpad設置／利用／削除
- Waystone設置／Discovery／Lifecycle／Teleport
- Frontier WM Shop
- Waymark TransactionのIdempotency
- Pending Delivery
- Admin Inspect／Repair／Remove／Reconcile
- Audit

担当しない。

- 通常Inventory、Armor、Offhand、Ender Chest、XP、Health、Foodの保存・復元
- MVI Profile切替
- 物理Beyond Gate移動
- 通常Portal／Respawn／World Changeの包括監視
- Iris World Generation
- LeafGrappleの移動物理
- Worlds Beyond向けNether／End Portal FamilyまたはMultiverse-NetherPortals連携
  （Overworld単一World構成のため要求しない）
- WorldGuard本体
- Resource Pack生成・配信本体
- EliteMobs／BetterStructuresのGameplay

Frontier Backend内の通常Player StateはMultiverse-Inventoriesを正本とする。

---

## 3. Worlds Beyond対象World

Worlds BeyondはOverworld単一World構成とする。

```text
Worlds Beyond
└─ Overworld
```

初期Runtime ID候補:

```text
frontier_iris
```

次はWorlds Beyondへ含めない。

```text
frontier_iris_nether
frontier_iris_the_end
任意のNether Environment World
任意のThe End Environment World
未承認World
```

正確なBukkit World名は導入タスクでLockする。

`Wayfarer_Frontier`は、明示Allowlistに完全一致するOverworldだけをWorlds Beyondとして扱う。Prefix、部分一致、Environmentまたは類似名だけで未知Worldを自動採用しない。

初期Allowlist概念:

```yaml
themes:
  worlds-beyond:
    worlds:
      - frontier_iris
```

対象外Worldでは、次をFail-closedする。

- Traversal Loadout初回発行
- Worlds Beyond恒久Itemの使用
- Launchpad設置・利用
- Waystone設置・Discovery・Teleport
- Frontier WM Shop
- Navigation GUIからのWorlds Beyond操作

---

## 4. Traversal Loadout

`frontier_iris`への初回入場時だけ支給する。

| Item | 種別 | 初期仕様 |
|---|---|---|
| Elytra | 恒久 | 1、Unbreakable、Soulbound |
| Grappling Hook | 恒久 | 1、LeafGrapple正規Item、耐久無効、Soulbound |
| Navigation Item | 恒久 | 1、GUI入口、Soulbound |
| Launchpad | 消耗品 | 初回のみ2個、各設置後3回使用 |

恒久Traversal Loadout:

- Elytra
- Grappling Hook
- Navigation Item

恒久Traversal Loadout共通要件:

- Owner以外は使用不可
- 手動Drop拒否
- Container格納拒否
- 他Player Pickup拒否
- `frontier_iris`以外での使用拒否
- 死亡Dropから除外
- Respawn後も保持
- Instance Epochによる再発行
- 旧Instance失効
- Itemを地面へDropしないRecovery
- MariaDBとPDCによるIdentity確認

Launchpadは消耗品であり、恒久Loadoutと同じ無料復旧規則を適用しない。

---

## 5. 初回配布とPending Delivery

Playerごとに初回配布済み状態を永続化する。

配布Flow:

1. `frontier_iris`への初回入場を検出する。
2. 非同期でLoadout Recordを取得または作成する。
3. PlayerがOnlineかつ`frontier_iris`内か再確認する。
4. Main ThreadでItemを付与する。
5. Auditを記録する。

Inventory Full:

- Itemを地面へDropしない。
- 恒久Itemまたは初回LaunchpadをPending Deliveryとして保持する。
- PlayerへInventoryに空きを作るよう通知する。
- Server Console／Auditへ記録する。
- 次回の`frontier_iris`への安全な入場またはAdmin Reconcileで再試行する。

Launchpadの初回無料数は、Pending Deliveryによる未配達分だけ再試行する。配達後の紛失、死亡Drop、手動破棄、設置または使用完了を理由に再支給しない。

---

## 6. Elytra

- Initial Loadoutとして1個支給する。
- `Unbreakable`とする。
- Soulbound／Owner Bindとする。
- 明示Allowlistの`frontier_iris`内だけ使用可能とする。
- `frontier_iris`外へ持ち出された場合は使用拒否または隔離する。
- 他Playerは装備・使用できない。
- Death Dropから除外する。
- 正規Itemが失われた場合は、旧Instanceを失効させたうえで無料Reissueできる。
- HookおよびLaunchpadから自然に滑空へ移行できる。
- Fireworkがなくても地形差を利用して移動できる体験を維持する。

耐久を自動修理する方式ではなく、初期方針は耐久が減らないItemとする。

---

## 7. LeafGrapple連携

初期候補は、Project Wayfarer現行Conceptで採用候補となっているLeafGrappleとする。

`Wayfarer_Frontier`はLeafGrapple本体をForkまたは再実装しない。

Adapter責務:

- 正規Hook Item生成
- Owner／Theme Identity付与
- 耐久無効
- Soulbound
- `frontier_iris`以外での使用拒否
- Entity／Player Hook無効化確認
- 採用Versionと必要機能の起動時検証
- 連携不能時Fail-closed

非公開内部Classへ依存する場合はVersion Adapterへ隔離する。

LeafGrappleの移動計算、Hook Projectile、Pull Physics、Cooldown本体はLeafGrappleを正とする。

---

## 8. Navigation Item／Navigation GUI

Navigation Itemは、`frontier_iris`内のWorlds Beyond機能へアクセスする恒久Soulbound Itemとする。`frontier_iris`以外ではGUI操作をFail-closedする。

Navigation Itemから統合Navigation GUIを開く。

Navigation GUIに含む機能:

- Discovery GUI
- Teleport GUI
- Frontier WM Shop
- Loadout状態
- Help

Teleport GUIでは、発見済みかつ現在Teleport可能なWaystoneを選択できる。

Teleport実行時はWaystone Domainが次を検証する。

- Destinationが発見済み
- DestinationがPROTECTEDまたはCONTESTABLE等のTeleport可能状態
- Permission
- Cooldown
- Safe Arrival
- Player状態
- Destination Worldが`frontier_iris`と完全一致
- Theme Allowlist

Navigation Item自体が座標を保持して直接Teleportするのではなく、GUI入口とし、Teleport処理はWaystone Domainと安全判定を経由する。現行ScopeのWaystone Teleportは、常に`frontier_iris`内の同一World Teleportとする。

防御的Configとして`allow-cross-dimension: false`を設ける場合、現行Scopeでは対象Worldが1つだけであり、将来の未承認拡張を無効化する安全設定として扱う。

---

## 9. Launchpad Concept

Launchpadは、Playerが現地へ設置してElytra射出に使う、安価で一時的な公共設備である。

基本方針:

- 誰でも利用可能
- 設置後にItemへ戻せない
- 任意Playerが手動破壊可能
- 破壊時Item Dropなし
- 使用回数上限あり
- 放置期限あり
- DB永続化
- Audit
- 環境要因から保護
- 使用回数または期限到達で自動削除

---

## 10. Launchpad初期Balance

Project Wayfarer現行Worlds Beyond Conceptの初期Baselineを継承する。

| Parameter | Initial Value |
|---|---:|
| Shop Price | 30 WM |
| Amount per purchase | 1 |
| Initial free amount | 2 |
| Max successful uses | 3 |
| Expiration | 30 days |
| Horizontal velocity | 2.5 |
| Vertical velocity | 1.2 |
| Use cooldown | 2 seconds |
| Auto deploy Elytra | true |
| Max active per player | 0（上限なし） |

すべてConfig化し、Playtestで調整する。

Price、Use CountおよびExpirationの変更を既設Launchpadへ遡及させるかは、実装仕様でSnapshot方針を定義する。

---

## 11. Launchpad Item

未設置Itemは、設置権を表す消耗品とする。

PDC概念:

```text
item_type=LAUNCHPAD
item_instance_id
definition_id
schema_version
```

新仕様では配置後に回収できないため、未設置Itemへ`remaining_uses`を保存しない。

Launchpad Itemは通常のWorlds Beyond Theme Inventory Itemとして死亡Drop対象とする。恒久Traversal Loadoutの死亡保持／無料Reissueを適用しない。System Faultによる消失だけAdmin Recovery対象にできる。

設置成功時だけItemを1個消費する。

設置失敗時はItemを消費しない。

---

## 12. Launchpad設置

初期実装Baseline:

- 単一BlockのLaunchpadとする。
- 見た目は金の感圧板、初期Materialは`LIGHT_WEIGHTED_PRESSURE_PLATE`とする。
- Custom Modelを初期必須にしない。
- Playerの設置時向きを射出方向として保存する。

設置条件:

- Worldが`frontier_iris`と完全一致
- Solid Block上面
- 対象Block位置がAir
- Air以外を上書きしない
- Liquid内でない
- Portal／Gate／Spawn除外範囲外
- World Border内
- WorldGuard禁止Region外
- Waystone／System Structureと非重複
- 既存Launchpadと非重複
- Chunk Load確認
- 成功時だけItem消費

設置はItem、DB Record、Physical Launchpad Blockの三者整合を必要とする。

途中失敗時は、二重消費、Item損失、Launchpad Blockだけ残留、DBだけ残留を防ぐ補償処理を行う。

---

## 13. Launchpad利用

- 全Playerが利用可能
- Playerが金の感圧板へ乗った時に起動する
- Sneak中は起動しない
- 成功した射出だけ使用回数を加算
- 同一Launchpadの同時利用をLock
- Cooldown
- Safe Launch判定
- Elytra自動展開
- PlayerがBlockへ埋まらない
- 使用時に`last_used_at`を更新
- Max Uses到達後に削除

使用回数はMariaDBのActive Launchpad Recordを正本とする。Launchpadは`frontier_iris`でのみ設置・利用でき、Nether、The Endまたは未承認WorldではFail-closedする。

単一Block、Material、TriggerおよびSneak回避は初期実装Baselineであり、テストサーバで使用感Feedbackを収集してv0.0.xで調整できる。配置後回収不可、公共利用、手動破壊時非Dropおよび環境保護という中核方針は維持する。

---

## 14. Launchpad手動破壊

Playerによる通常Block Breakだけを許可する。

- Owner限定にしない。
- 任意Playerが破壊できる。
- Launchpad本体である単一の金の感圧板を破壊対象とする。
- 有効な破壊時はLaunchpad Blockを削除する。
- ItemをDropしない。
- Active DB Recordを削除する。
- Auditを保持する。
- CancelされたBreakでは削除しない。
- 二重Breakで二重削除しない。

Event概念:

```text
LAUNCHPAD_PLAYER_DESTROYED
```

---

## 15. Launchpad環境保護

次では破壊・移動・変形しない。

- Explosion
- Fire／Burn
- Fluid
- Piston／Sticky Piston
- Entity Change Block
- Falling Block
- Block Spread
- Tree／Mushroom Growth
- Structure Generation
- 通常WorldEdit／FAWE操作
- Mob Griefing

System／Adminの専用削除経路は保護を迂回できる。

通常のBukkit Eventだけで保護できない外部操作は、採用PluginのAPI／Hookを実装設計で確認する。

---

## 16. Launchpad使用回数と期限

Active Record候補:

```text
launchpad_id
world_id
x
y
z
orientation
placer_uuid
successful_use_count
max_uses_at_creation
created_at
last_used_at
expires_at
definition_id
state
schema_version
lock_version
```

期限基準:

```text
last_used_atがある
→ last_used_at

一度も使用されていない
→ created_at
```

利用されるたびに放置期限を延長する。

削除条件:

- `successful_use_count >= max_uses`
- 放置期限到達
- Player手動破壊
- Admin削除
- Reconcile

削除時:

- Launchpad Block削除
- Active Row削除
- Item Dropなし
- Audit履歴保持

---

## 17. Launchpad Restart／Reconcile

Schedulerは期限到達候補を周期的に検索する。

- DB検索は非同期
- World／Block操作はMain Thread
- Restart中に期限到達したRecordを起動後Catch-up
- DBありLaunchpad Blockなしを検出
- Launchpad BlockありDBなしを検出
- 使用回数競合を検出
- 削除をIdempotentにする

不確実な状態では自動再発行せず、Admin ReconcileとAuditへ送る。

---

## 18. Waystone責務

WaystoneのLifecycle、価格、Discovery、歴史および物理構造はProject Wayfarer現行Worlds Beyond Conceptを参照する。

`Wayfarer_Frontier`が担当する。

- Placement Tool
- Founder／Maintainer
- Sequence
- PROTECTED／CONTESTABLE／DORMANT／RUINED
- System Structure
- Discovery
- Discovery GUI
- 現地操作
- Navigation Itemから起動するTeleport GUI
- `frontier_iris`内の同一World Teleport
- Safe Arrival
- WM取引
- History
- Scheduler
- Restart Catch-up
- Admin Repair／Remove／Reconcile

Launchpadの「任意Playerが手動破壊可能」という仕様をWaystoneへ適用しない。

WaystoneはSystem Structureとして、Adminを含む通常破壊から保護し、専用Commandで管理する。

Waystone RecordとTeleport Destinationは`frontier_iris`に限定する。Nether、The Endまたは未承認Worldを示すRecordは、設置、DiscoveryおよびTeleportの対象として使用しない。

---

## 19. Frontier WM Shop

初期販売候補:

| Item | Initial Price |
|---|---:|
| Launchpad | 30 WM |
| Flight Duration 3 Firework Rocket | 200 WM |
| Waystone Placement Tool | 600 WM |

要件:

- `frontier_iris`内だけ
- Waymark Adapter経由
- Transaction ID
- Idempotency
- 二重Click防止
- Item付与失敗時RefundまたはPending Delivery
- Inventory Full対応
- Audit
- RedisEconomy内部Keyを直接編集しない

Waystone維持、上書き、復活価格はProject Wayfarer現行Worlds Beyond Conceptを参照する。

---

## 20. Item Identity

恒久Traversal Item候補Record:

```text
player_uuid
theme_id
item_type
instance_epoch
state
issued_at
invalidated_at
updated_at
lock_version
```

Unique概念:

```text
player_uuid + theme_id + item_type
```

対象:

- Elytra
- Grappling Hook
- Navigation Item

Reissue時:

- Epoch増加
- 旧Item無効
- 新Itemだけ有効
- Audit

Launchpadは消耗品Instanceとして別Identityを使用する。

Physical Item重複検出等の詳細は、Plugin Repositoryの実装仕様で定義する。

---

## 21. MVI境界

`frontier_iris`をWorlds Beyond用MVI Groupへ登録する。

MVIが正本:

- Inventory
- Armor
- Offhand
- Ender Chest
- Vanilla XP／Level
- Health
- Food／Saturation
- 承認した追加Player State

単一World構成であっても、Frontier Backend内では次とのPlayer State分離にMVIを使用する。

- Frontier Lobby
- Ruined Frontier／Guild Group

Main Backendとの分離はMVIではなく、Backend／NetworkのItem非共有境界によって保証する。

`Wayfarer_Frontier`は通常InventoryをMariaDBへ保存しない。

Gate、Respawn、Command Teleport、Reconnect等の通常切替を独自Pluginで二重処理しない。

Worlds BeyondではNether／Endを採用しないため、Worlds Beyond向けMultiverse-NetherPortals連携、Portal FamilyおよびDimension間Profile共有を要求しない。

Vanilla Nether PortalおよびEnd Portalを`frontier_iris`内でどう扱うかはTheme Concept／Runtime設計の責務とし、本Plugin Conceptでは独自Portal処理を追加しない。

自身が発行するWayfarer ItemのIdentity、Owner Bind、`frontier_iris`外での使用拒否および固有Gameplay Dataだけを管理する。

---

## 22. AdminとReconcile

概念上必要な操作:

- Traversal Item Inspect
- Traversal Item Reissue
- Pending Delivery Inspect／Retry
- Launchpad Inspect／Remove／Reconcile
- Waystone Inspect／Repair／Remove／Reconcile
- Transaction Inspect
- Audit検索

正確なCommand SyntaxとPermission Nodeは実装仕様で定義する。

一般Playerへ管理Command、MVI管理、Database管理またはEconomy管理権限を付与しない。

---

## 23. Acceptance観点

### World／Allowlist

- Worlds Beyond対象Worldが`frontier_iris`だけである
- `frontier_iris_nether`を対象として認識しない
- `frontier_iris_the_end`を対象として認識しない
- 任意のNether／The End WorldでWorlds Beyond固有機能がFail-closedする
- 未承認World名をPrefixや部分一致だけで自動採用しない
- Worlds BeyondでMultiverse-NetherPortals連携を要求しない

### Traversal Loadout

- `frontier_iris`への初回入場時だけ初回Loadoutを支給
- Nether／The End／未承認Worldへの入場では支給しない
- Inventory FullでDropしない
- ElytraとHookがUnbreakableである
- Elytra／Hook／Navigation ItemがSoulboundである
- Owner以外使用不可
- Worlds Beyond Itemを`frontier_iris`以外で使用不可
- Death保持
- Reissue後旧Epoch無効
- Navigation ItemからDiscovery／Teleport／Shop／Loadout GUIを開ける
- `frontier_iris`以外ではNavigation GUI操作がFail-closedする
- LeafGrapple異常時Fail-closed

### Waystone／Teleport

- Destinationが`frontier_iris`内に限定される
- Nether／The End／未承認WorldのWaystone Recordを使用できない
- 発見済みWaystoneだけを選択できる
- Teleport可能State、Permission、Cooldown、Safe Arrival、Player状態を検証する
- Cross-dimension Teleportを行わない

### Launchpad

- `frontier_iris`でのみ設置・利用できる
- Nether／The End／未承認Worldでは設置・利用できない
- 設置失敗時Item非消費
- 成功時一度だけ消費
- 単一の金の感圧板として設置
- 感圧板へ乗ると起動
- Sneak中は起動しない
- 誰でも利用可能
- 成功時だけUse Count
- 配置後回収不可
- 任意Playerが金の感圧板を手動破壊
- 破壊時Dropなし
- Explosion／Fire／Fluid非破壊
- Piston非移動
- Max Useで削除
- 30日無操作で削除
- 使用で期限延長
- Active Row削除
- Audit保持
- Restart Catch-up
- DB／Launchpad Block Reconcile

### MVI／Boundary

- `frontier_iris`がWorlds Beyond用MVI Groupへ登録される
- Frontier Lobby／Guild GroupとMVI Profileが分離される
- Main BackendとはBackend／Network境界によりItemおよびPlayer Stateが共有されない
- Dimension間共有を前提とする処理・試験が存在しない
- 通常Inventoryを独自DBへ保存しない
- Gate／Respawn／Reconnectで二重切替しない
- Main／他ThemeへItem漏出なし

---

## 24. Playtest調整と実装仕様境界

初期実装Baseline:

```text
単一Block
LIGHT_WEIGHTED_PRESSURE_PLATE
上に乗ると起動
Sneak中は起動しない
Custom Modelなし
```

実装後に使用感Feedbackを収集し、誤発射、視認性、速度、Cooldown、Material等をv0.0.xで調整する。

Concept上の中核方針:

- 配置後回収不可
- 公共利用
- 任意Playerの手動破壊
- 破壊時非Drop
- 環境要因から保護
- 使用回数／期限で自動削除
- MariaDB正本とAudit

実装設計でLockする項目:

- Exact DDL
- Transaction State
- Scheduler間隔
- External Plugin Hook
- GUI Layout
- Command／Permission
- Pending Delivery内部表現
- Launchpad Snapshot Field

---

## 25. Theme Concept同期結果

Status: Synchronized

次の内容は`concepts/frontier/Worlds_Beyond_Specification_V0.0.6.md`へ反映済みである。

### Overworld単一World化

- Worlds Beyondは`frontier_iris`だけを使用する
- `frontier_iris_nether`を除外する
- `frontier_iris_the_end`を除外する
- Iris Netherは公式Repositoryの警告を根拠に採用しない
- Iris EndはProject Owner判断で採用しない
- Worlds Beyond向けPortal FamilyおよびMultiverse-NetherPortals連携を削除または非適用化する
- Traversal Loadout初回発行を`frontier_iris`への初回入場だけにする
- MVI Group対象を`frontier_iris`だけにする
- Waystone Teleportを`frontier_iris`内の同一World Teleportへ限定する
- Nether／The End／未承認Worldでは全Worlds Beyond固有機能をFail-closedする

### 既存採用済みDelta

- Launchpadは配置後回収不可
- 任意Playerが手動破壊可能
- 破壊時Item Dropなし
- Explosion／Fire／Fluid／Piston等から保護
- 単一の金の感圧板を初期Baselineとする
- 上に乗ると起動し、Sneak中は起動しない
- Navigation GUIにTeleport GUIを含める
- Navigation ItemからTeleport GUIへ進入できる
- Teleportは発見済みWaystoneとWaystone Domainの安全判定を経由する

本ConceptとTheme Conceptの同期は完了している。Runtime ConfigまたはWorld Dataの変更は、別の明示的な実装Taskを必要とする。

---

## 26. v0.0.4変更概要

> **同Revision内訂正:** Overworld単一World化レビュー後、単一Block Launchpadに残っていた`Structure／template_id`表現、恒久Loadout要件の適用範囲、およびMVIとMain Backend分離の責務表現を明確化した。Gameplay判断とRevision番号は変更していない。


- Worlds BeyondをOverworld単一World構成へ変更した。
- 採用Worldを`frontier_iris`だけに限定した。
- `frontier_iris_nether`および`frontier_iris_the_end`を非採用とした。
- Allowlistを完全一致の単一World Baselineへ変更した。
- Nether、The Endおよび未承認Worldで固有機能をFail-closedする要件を追加した。
- Traversal Loadout初回発行を`frontier_iris`への初回入場だけに限定した。
- MVI Group対象を`frontier_iris`だけに変更し、Frontier Lobby／Guild／Mainとの分離を維持した。
- Worlds Beyond向けPortal FamilyおよびMultiverse-NetherPortals連携を不要とした。
- Waystone Teleportを`frontier_iris`内の同一World Teleportへ限定した。
- Navigation GUI、Launchpad、Soulbind、WM ShopおよびWaystone LifecycleのGameplay仕様は維持した。
- 関連Theme Concept参照を`Worlds_Beyond_Specification_V0.0.6.md`へ更新した。
- Iris Nether除外は公式Repositoryの警告、Iris End除外はProject Owner判断を根拠とした。
