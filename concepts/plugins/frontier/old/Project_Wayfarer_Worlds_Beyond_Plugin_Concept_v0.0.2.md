# Project Wayfarer Worlds Beyond Plugin Concept v0.0.2

> **状態:** Under Review  
> **保存先:** Project Wayfarer Repository `concepts/plugins/frontier/`  
> **関連Concept:** `../Project_Wayfarer_Plugin_Concept_v0.0.2.md`  
> **関連Theme Concept:** `concepts/frontier/Worlds_Beyond_Specification_V0.0.4.md`  
> **対象Runtime:** Frontier  
> **想定Runtime Plugin:** `Wayfarer_Frontier`  
> **実装状態:** 未着手

---

## 1. 目的

本Conceptは、Worlds Beyond MVPのうち独自Pluginが担当する範囲を定義する。

World構成、Iris、MVI Group、Portal Family、Difficulty、Waystone LifecycleおよびTheme全体のGameplayは、Project Wayfarerの現行Worlds Beyond／Frontier ConceptとV0.1.0 Scopeを参照する。

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

- Worlds Beyond初回Loadout
- 恒久Traversal ItemのOwner Bind
- Theme-bound Use
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
- Multiverse-NetherPortalsのPortal Link
- WorldGuard本体
- Resource Pack生成・配信本体
- EliteMobs／BetterStructuresのGameplay

Frontier Backend内の通常Player StateはMultiverse-Inventoriesを正本とする。

---

## 3. Worlds Beyond対象World

概念上のWorld Family:

```text
Worlds Beyond
├─ Overworld
├─ Nether
└─ End
```

初期Runtime ID候補:

```text
frontier_iris
frontier_iris_nether
frontier_iris_the_end
```

正確なBukkit World名は導入タスクでLockする。

`Wayfarer_Frontier`は明示Allowlistに一致するWorldだけをWorlds Beyondとして扱う。未知Worldを自動採用しない。

---

## 4. Traversal Loadout

Worlds Beyond初回入場時に支給する。

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

共通要件:

- Owner以外は使用不可
- 手動Drop拒否
- Container格納拒否
- 他Player Pickup拒否
- Theme外使用拒否
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

1. Worlds Beyond初回入場を検出する。
2. 非同期でLoadout Recordを取得または作成する。
3. PlayerがOnlineかつWorlds Beyond内か再確認する。
4. Main ThreadでItemを付与する。
5. Auditを記録する。

Inventory Full:

- Itemを地面へDropしない。
- 恒久Itemまたは初回LaunchpadをPending Deliveryとして保持する。
- PlayerへInventoryに空きを作るよう通知する。
- Server Console／Auditへ記録する。
- 次回の安全な入場またはAdmin Reconcileで再試行する。

Launchpadの初回無料数は、Pending Deliveryによる未配達分だけ再試行する。配達後の紛失、死亡Drop、手動破棄、設置または使用完了を理由に再支給しない。

---

## 6. Elytra

- Initial Loadoutとして1個支給する。
- `Unbreakable`とする。
- Soulbound／Owner Bindとする。
- Worlds Beyond Allowlist内だけ使用可能とする。
- 他Themeへ持ち出された場合は使用拒否または隔離する。
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
- Theme外使用拒否
- Entity／Player Hook無効化確認
- 採用Versionと必要機能の起動時検証
- 連携不能時Fail-closed

非公開内部Classへ依存する場合はVersion Adapterへ隔離する。

LeafGrappleの移動計算、Hook Projectile、Pull Physics、Cooldown本体はLeafGrappleを正とする。

---

## 8. Navigation Item

Navigation Itemは、Worlds BeyondのWayfarer機能へアクセスする恒久Soulbound Itemとする。

候補機能:

- Discovery GUI
- Teleport GUI
- Frontier WM Shop
- Loadout状態
- Help

Navigation ItemそのものをTeleport Itemとして扱わない。

Teleportは発見済みWaystoneと安全条件を満たす場合だけ、Waystone Domainから実行する。

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

設置成功時だけItemを1個消費する。

設置失敗時はItemを消費しない。

---

## 12. Launchpad設置

初期条件:

- Worlds Beyond Allowlist内
- Solid Block上面
- Template Clearance
- Air以外を上書きしない
- Liquid内でない
- Portal／Gate／Spawn除外範囲外
- World Border内
- WorldGuard禁止Region外
- Waystone／System Structureと非重複
- Chunk Load確認
- 成功時だけItem消費

設置はItem、DB Record、Structureの三者整合を必要とする。

途中失敗時は、二重消費、Item損失、Structureだけ残留、DBだけ残留を防ぐ補償処理を行う。

---

## 13. Launchpad利用

- 全Playerが利用可能
- 成功した射出だけ使用回数を加算
- 同一Launchpadの同時利用をLock
- Cooldown
- Safe Launch判定
- Elytra自動展開
- PlayerがBlockへ埋まらない
- 使用時に`last_used_at`を更新
- Max Uses到達後に削除

使用回数はMariaDBのActive Launchpad Recordを正本とする。

使用Triggerと物理構造は、Player体験に関わるため本ConceptのReview中に確定する。

初期候補:

- 小規模な複数Block Structure
- 中央Trigger領域へ乗ると発射
- Sneak中は誤発射防止

確定前に実装作業指示書を作成しない。

---

## 14. Launchpad手動破壊

Playerによる通常Block Breakだけを許可する。

- Owner限定にしない。
- 任意Playerが破壊できる。
- 構成Blockのどれを破壊対象とするかはStructure確定時にLockする。
- 有効な破壊時はStructure全体を削除する。
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
template_id
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

- Structure削除
- Active Row削除
- Item Dropなし
- Audit履歴保持

---

## 17. Launchpad Restart／Reconcile

Schedulerは期限到達候補を周期的に検索する。

- DB検索は非同期
- World／Block操作はMain Thread
- Restart中に期限到達したRecordを起動後Catch-up
- DBありStructureなしを検出
- StructureありDBなしを検出
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
- Teleport GUI
- Safe Arrival
- WM取引
- History
- Scheduler
- Restart Catch-up
- Admin Repair／Remove／Reconcile

Launchpadの「任意Playerが手動破壊可能」という仕様をWaystoneへ適用しない。

WaystoneはSystem Structureとして、Adminを含む通常破壊から保護し、専用Commandで管理する。

---

## 19. Frontier WM Shop

初期販売候補:

| Item | Initial Price |
|---|---:|
| Launchpad | 30 WM |
| Flight Duration 3 Firework Rocket | 200 WM |
| Waystone Placement Tool | 600 WM |

要件:

- Worlds Beyond Allowlist内だけ
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

MVIが正本:

- Inventory
- Armor
- Offhand
- Ender Chest
- Vanilla XP／Level
- Health
- Food／Saturation
- 承認した追加Player State

`Wayfarer_Frontier`は通常InventoryをMariaDBへ保存しない。

Gate、Portal、Respawn、Command Teleport、Reconnect等の通常切替を独自Pluginで二重処理しない。

自身が発行するWayfarer ItemのIdentity、Owner Bind、Theme外使用および固有Gameplay Dataだけを管理する。

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

### Traversal Loadout

- 初回だけ正しく支給
- Inventory FullでDropしない
- Elytra／Hook／Navigation ItemがUnbreakableかつSoulbound
- Owner以外使用不可
- Theme外使用不可
- Death保持
- Reissue後旧Epoch無効
- LeafGrapple異常時Fail-closed

### Launchpad

- 設置失敗時Item非消費
- 成功時一度だけ消費
- 誰でも利用可能
- 成功時だけUse Count
- 配置後回収不可
- 任意Playerの手動破壊
- 破壊時Dropなし
- Explosion／Fire／Fluid非破壊
- Piston非移動
- Max Useで削除
- 30日無操作で削除
- 使用で期限延長
- Active Row削除
- Audit保持
- Restart Catch-up
- DB／Structure Reconcile

### MVI／Boundary

- 通常Inventoryを独自DBへ保存しない
- Worlds Beyond三次元で同一Profile
- Frontier Lobby／Guildと分離
- Main／他ThemeへItem漏出なし
- Gate／Portal／Respawn／Reconnectで二重切替なし

---

## 24. Reviewで確定する項目

Player体験に関わるため、実装作業指示書作成前に確定する。

1. Launchpadの物理構造
2. LaunchpadのTrigger
3. Sneak等の誤発射防止操作
4. 破壊対象Block
5. Custom Modelを初期必須とするか

実装設計でLockする項目:

- Exact DDL
- Transaction State
- Scheduler間隔
- External Plugin Hook
- GUI Layout
- Command／Permission
- Pending Delivery内部表現

---

## 25. v0.0.2変更概要

- ElytraとLeafGrappleをUnbreakableかつSoulboundとして明確化した。
- Launchpadを配置後回収不可へ変更した。
- 任意Playerによる手動破壊と、破壊時Item Dropなしを追加した。
- Explosion、Fire、Fluid、Piston等からの保護を整理した。
- 使用回数、最終使用日時、放置期限およびActive Row削除を明文化した。
- 現行Worlds Beyond Conceptの価格、初回数、使用回数、期限、速度を初期Baselineとして継承した。
- 通常Player StateをMVIへ委譲する責務境界を整理した。
- Conceptと後続実装仕様書の境界を明確化した。
