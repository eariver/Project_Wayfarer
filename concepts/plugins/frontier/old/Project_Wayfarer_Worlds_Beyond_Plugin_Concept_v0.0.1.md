# Project Wayfarer Worlds Beyond Plugin Concept v0.0.1

> **状態:** 初期Plugin要件差分  
> **親文書:** `Project_Wayfarer_Plugin_Concept_v0.0.1.md`  
> **対象Runtime:** Frontier  
> **実装Plugin:** `Wayfarer_Frontier`  
> **Authority:** Project Wayfarer現行Frontier／Worlds Beyond Conceptを前提とし、本書は独自Plugin関連の更新要件を補足する。

---

## 1. 責務境界

`Wayfarer_Frontier`が担当する。

- Worlds Beyond Traversal Loadout
- Elytra
- LeafGrapple連携
- Navigation Item
- Launchpad
- Frontier WM Shop
- Waystone
- Discovery GUI
- Teleport GUI
- Wayfarer固有Item Identity
- Pending Delivery
- Admin／Audit／Reconcile

担当しない。

- 通常Inventory保存・復元
- MVI Profile切替
- 物理Beyond Gate移動
- 通常Portal／Respawn／World Changeの包括監視
- Iris World Generation
- LeafGrapple物理挙動の再実装
- EliteMobs／BetterStructures本体機能

---

## 2. Traversal Loadout

初回支給候補:

- Elytra
- LeafGrapple正規Hook
- Navigation Item
- Launchpad 2個

Elytra、Hook、Navigation Itemを恒久Traversal Loadoutとする。

Launchpadは消耗品であり、初回配布はPlayerごとに一度だけとする。

---

## 3. Elytra

要件:

- Unbreakable
- Soulbound／Owner Bind
- Worlds Beyond Theme限定
- Drop拒否
- Container格納拒否
- 他Player使用拒否
- 死亡Dropから除外
- Reissue時にInstance Epoch更新
- 旧Instance無効
- Theme外使用拒否
- Pending Delivery／Recovery
- Tool IdentityをPDCとDBで照合

耐久回復ではなく、原則として耐久が減らないItemとする。

---

## 4. LeafGrapple

LeafGrapple本体をForkまたは再実装しない。

Adapter責務:

- 正規Hook Item生成
- 採用Version確認
- 必要API／内部連携確認
- Worlds Beyond Theme限定
- Unbreakable相当
- Soulbound／Owner Bind
- Drop拒否
- Container格納拒否
- 他Player使用拒否
- Death保持
- Reissue／Epoch
- Player／Entity Hook無効
- 連携不能時Fail-closed

Version依存CodeはAdapterへ隔離する。

---

## 5. Launchpad概要

Launchpadは安価で一時的な公共移動設備とする。

- Playerが設置
- 誰でも利用可能
- 配置後にItemとして回収不可
- Playerの手動破壊を許可
- 破壊時にItem Dropなし
- 使用回数上限
- 放置期限
- DB永続化
- Audit
- 自動削除

---

## 6. Launchpad Item

候補PDC:

```text
wayfarer:item_type=LAUNCHPAD
wayfarer:item_instance_id
wayfarer:remaining_uses
wayfarer:schema_version
```

設置成功時だけItemを消費する。

設置失敗時はItemを消費しない。

初回無料Launchpadは紛失、死亡、手動破棄または使用完了を理由に再支給しない。

---

## 7. Launchpad設置

初期条件:

- Worlds Beyond Allowlist
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

Item、DB、Structureの三者をExactly-once／Compensation対象とする。

---

## 8. Launchpad利用

- 全Playerが利用可能
- 成功した射出だけ使用回数を加算
- Horizontal／Vertical VelocityをConfig化
- Elytra自動展開
- 同一Launchpadの同時利用Lock
- Cooldown
- Safe Launch判定
- PlayerがBlockへ埋まらない
- 使用回数上限到達後に削除

使用回数はDBへ保存する。

---

## 9. Launchpad手動破壊

Playerによる通常Block Breakだけを許可する。

- Owner限定にしない
- 誰でも手動破壊可能
- Item Dropなし
- Structure削除
- Active DB Record削除
- Audit保持
- CancelされたBreakでは削除しない
- 二重Breakで二重削除しない

破壊時Event:

```text
LAUNCHPAD_PLAYER_DESTROYED
```

---

## 10. Launchpad環境保護

次では破壊・移動・変形しない。

- Explosion
- Fire／Burn
- Fluid
- Piston／Sticky Piston
- Entity Change Block
- Falling Block
- Block Spread
- Structure Generation
- 通常WorldEdit／FAWE
- Mob Griefing

Pistonでは移動させない。

System／Admin操作は専用経路で保護を迂回する。

---

## 11. 使用回数上限

Config:

```yaml
launchpad:
  max-uses: 3
```

成功した射出後:

```text
successful_use_count += 1
```

`successful_use_count >= max_uses`となった場合:

1. Structure削除
2. Active DB Record削除
3. Audit記録
4. Item Dropなし

Audit Event:

```text
LAUNCHPAD_USES_EXHAUSTED
```

---

## 12. 放置期限

Config:

```yaml
launchpad:
  expire-after-days: 30
```

期限基準:

```text
last_used_atが存在する
→ last_used_at

一度も使用されていない
→ created_at
```

利用されるたびに放置期限を延長する。

Scheduler:

- 周期的に期限到達候補をDB検索
- Chunk／World状態を検証
- Main ThreadでStructure削除
- Active DB Record削除
- Audit
- Restart後にCatch-up

Audit Event:

```text
LAUNCHPAD_EXPIRED
```

---

## 13. Launchpad Database

Active Table候補:

```text
wf_frontier_launchpad
```

Field候補:

```text
launchpad_id
world_id
x
y
z
yaw
placer_uuid
successful_use_count
max_uses_at_creation
created_at
last_used_at
expires_at
state
template_id
schema_version
lock_version
updated_at
```

Active Launchpadが消滅した場合、Active Rowを削除する。

履歴は共通Auditへ保持する。

削除理由:

```text
PLAYER_DESTROYED
USES_EXHAUSTED
EXPIRED
ADMIN_REMOVED
RECONCILED
```

---

## 14. Launchpad Crash Safety

設置Transaction State候補:

```text
PREPARED
ITEM_RESERVED
RECORD_CREATED
STRUCTURE_PLACED
COMMITTED
COMPENSATING
FAILED
```

要件:

- Itemだけ消費されStructureなしを放置しない
- StructureとDBが二重生成されない
- StructureありDBなしをStartup Reconcileで検出
- DBありStructureなしを検出
- 使用回数更新競合をOptimistic Lockで検出
- 削除処理をIdempotentにする

---

## 15. Waystone

Waystone要件はProject Wayfarer現行Worlds Beyond Conceptを継承する。

`Wayfarer_Frontier`責務:

- Placement Tool
- Founder／Maintainer
- Sequence
- PROTECTED／CONTESTABLE／DORMANT／RUINED
- System Structure
- Discovery
- Discovery GUI
- 現地起点Teleport GUI
- Safe Arrival
- WM取引
- History
- Scheduler
- Restart Catch-up
- Admin Repair／Remove／Reconcile

Launchpad仕様変更はWaystone Lifecycleへ適用しない。

---

## 16. Frontier WM Shop

初期販売候補:

- Launchpad
- Flight Duration 3 Firework
- Waystone Placement Tool

要件:

- Worlds Beyond内だけ
- Waymark Adapter
- Transaction ID
- Idempotency
- 二重Click防止
- Item付与失敗時RefundまたはPending Delivery
- Inventory Full対応
- Audit
- RedisEconomy内部Keyを直接編集しない

価格はProject WayfarerのWaymark EconomyとPlaytestで調整する。

---

## 17. Item Identity

恒久Traversal Item:

- ELYTRA
- GRAPPLING_HOOK
- NAVIGATION_ITEM

Instance Record候補:

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

Unique:

```text
player_uuid + theme_id + item_type
```

Reissue時:

- Epoch増加
- 旧Item無効
- 新Itemだけ有効
- Audit

Launchpadは消耗品Instanceとして別Identityを使用する。

---

## 18. MVI境界

MVIが正本:

- Inventory
- Armor
- Offhand
- Ender Chest
- Vanilla XP／Level
- Health
- Food／Saturation

`Wayfarer_Frontier`は通常InventoryをMariaDBへ保存しない。

Gate、Portal、Respawn、Admin Teleport、Reconnect等の通常切替を独自Pluginで二重処理しない。

自身が発行するWayfarer ItemのIdentity、Owner BindおよびTheme外使用だけを追加制御する。

---

## 19. Admin Command候補

```text
/wayfarer frontier admin item inspect <player>
/wayfarer frontier admin item reissue <player> <type>
/wayfarer frontier admin pending inspect <player>
/wayfarer frontier admin launchpad inspect <id>
/wayfarer frontier admin launchpad remove <id>
/wayfarer frontier admin launchpad reconcile
/wayfarer frontier admin waystone inspect <id>
/wayfarer frontier admin waystone repair <id>
/wayfarer frontier admin waystone remove <id>
/wayfarer frontier admin audit ...
```

正確なSyntaxは実装指示書でLockする。

---

## 20. Acceptance Test候補

### Elytra／Hook

- Unbreakable
- Soulbound
- Owner以外使用不可
- Drop不可
- Container不可
- Death保持
- Theme外使用不可
- Reissue後旧Epoch無効
- LeafGrapple異常時Fail-closed

### Launchpad設置

- Air以外を上書きしない
- 失敗時Item非消費
- 成功時Item一度だけ消費
- Restart後もDB／Structure一致

### Launchpad使用

- 誰でも利用可能
- 成功時だけCount
- 同時利用で二重Countなし
- Max Use直後に消滅
- DB Row削除
- Audit保持

### Launchpad破壊

- 任意Playerが手動破壊可能
- Item Dropなし
- DB Row削除
- Audit保持
- Explosion非破壊
- Fire非破壊
- Fluid非破壊
- Piston非移動
- WorldEdit非破壊

### Launchpad期限

- 未使用はCreated基準
- 使用済みはLast Used基準
- 使用で期限延長
- Restart中の期限超過をCatch-up
- 削除後DB Rowなし
- Auditあり

### MVI

- 通常Inventoryを独自DBへ保存しない
- Worlds Beyond三次元でProfile共有
- Frontier Lobby／Guildと分離
- Gate／Portal／Respawn／Reconnectで正常
- Theme Item漏出なし

---

## 21. 未決事項

- Exact Launchpad Template
- Exact Velocity
- Exact Max Uses
- Exact Expiration
- Exact Shop Price
- Exact Initial Free Amount
- LeafGrapple正式Version／API
- GUI Layout
- Permission Node
- Database DDL
- Scheduler間隔
- WorldEdit／FAWE保護Hook
- Pending Delivery UI
- Waystone詳細のPlugin内部実装

数値はConfig化し、v0.0.x Test Server試験で改訂する。

---

## 22. v0.0.1結論

ElytraとLeafGrappleはUnbreakableかつSoulboundとする。

Launchpadは配置後に回収できない。

任意Playerによる手動破壊だけを許可し、環境要因では破壊・移動させない。

Launchpadは使用回数上限または最終使用からの放置期限で消滅する。

消滅時にActive DB Recordを削除し、Audit履歴を保持する。
