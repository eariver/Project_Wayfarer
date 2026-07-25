# Project Wayfarer — Worlds Beyond仕様書 V0.0.5

> **状態：設計仕様／実装前**
>
> 本文書は、Frontier Backend上のIris Theme **Worlds Beyond**のWorld構成、Gameplay、独自Plugin機能、Database、Economyおよび受入試験を定義する。
>
> Frontier共通仕様は、[Frontierサーバ仕様書 V0.0.4](./Frontier_Server_Specification_V0.0.4.md)を参照する。
>
> 独自Plugin責務と実装境界は、[`Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.3.md`](../plugins/frontier/Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.3.md)をDesign Inputとして同期する。
>
> 数値はV0.0.5の初期Balance Baselineであり、すべてConfigから変更可能とする。

---

## 1. Theme Concept

Worlds Beyondは、Irisが生成する未知の地形を、Grappling Hook、Elytraおよび設置式Launchpadで自由に移動するTraversal／Exploration Themeである。

中核思想：

> 敵や管理者配置のLandmarkで目的地を与えるのではなく、地形を移動し、発見し、一時的な設備を残し、プレイヤー自身が交通網と歴史を形成する。

主要体験：

1. Hookで崖、谷、洞窟、浮遊地形を攻略する。
2. HookからElytraへつなぎ、地形の高低差を利用して滑空する。
3. 安価なLaunchpadを設置し、後続Playerも使える痕跡を残す。
4. 有望な場所へWaystoneを設置する。
5. 他Playerが近隣Waystoneを探し、現地へ到達して解禁する。
6. Waystoneを維持、上書き、復活させ、Maintainerの変遷を歴史として残す。
7. 長期間放置されたWaystoneは物理的に消えるが、DB上の歴史は残る。
8. 将来、主要地点間へ恒久的な景観交通を構築する。

---

## 2. World構成

論理World Family：

```text
Worlds Beyond
├─ Overworld
├─ Nether
└─ End
```

Player向け名称と暫定Runtime ID：

| Player向け名称 | 暫定Runtime ID |
|---|---|
| Worlds Beyond Overworld | `frontier_iris` |
| Worlds Beyond Nether | `frontier_iris_nether` |
| Worlds Beyond End | `frontier_iris_the_end` |

World IDはProjectの導入Configで固定し、Multiverse-Core、Multiverse-Inventories、Multiverse-NetherPortals、Irisおよび`Wayfarer_Frontier`の機能別Allowlistで一致させる。Inventory Group割当のRuntime正本はMultiverse-Inventoriesとする。EndのAliasと実Physical Nameが異なる場合、実Bukkit名を使用する。

導線：

```text
Frontier Lobby
  └─ Beyond Gate（物理Gate）
       └─ Worlds Beyond Overworld Safe Entry
          ├─ Nether Portal → Worlds Beyond Nether
          ├─ End Portal    → Worlds Beyond End
          └─ Return Gate   → Frontier Lobby
```

V0.0.5ではTheme選択GUIを使用せず、Frontier Lobbyに設置するBeyond Gateを正規入口とする。Gateの実装方式はFrontier共通仕様でLockする。

`Multiverse-NetherPortals`で三次元を明示的なWorld Familyとして**双方向Link**し、命名規則による自動Linkだけに依存しない。

Link要件：

```text
Worlds Beyond Overworld ↔ Worlds Beyond Nether
Worlds Beyond Overworld ↔ Worlds Beyond End
```

設定Baseline：

```yaml
handle-end-exit-respawn: true
```

- Overworld／Nether間を双方向Linkとして登録する。
- Overworld／End間を双方向Linkとして登録する。
- Stronghold End PortalはWorlds Beyond Endへ接続する。
- End Exit PortalはWorlds Beyond Overworldへ帰還する。
- End Exit時に別ThemeのBed／Respawn Anchorへ移動させない。
- Mob／Item／VehicleのPortal通過を実機確認する。
- Ruined Frontier Familyとは相互接続しない。

World IDはFrontier共通仕様と導入Configで固定し、実装時に実Bukkit World名へ読み替える。Inventory GroupはMultiverse-Inventories Configを正本とする。

---

## 3. World Generation

### 3.1 Generator

- Irisを地形生成Engineとして使用する。
- exact Engine／PackはWorld生成タスクで選定し、VersionとSHA-256を固定する。
- Overworld、Nether、Endを同一Theme Familyとして生成する。
- 管理者が手作業でLandmarkを配置しない。
- Iris以外のStructure GeneratorをV0.0.5では追加しない。
- Vanilla Structureを残すかは採用Engine／Packの仕様を正とし、意図しないLoot Sourceがないか受入試験する。

### 3.2 Seed

- 初回生成時に固定Seedを選定する。
- 生成後はSeed、World UUID、Iris Engine／Pack Versionを記録する。
- Seed変更、World削除、Region Trim、再生成は破壊的タスクとして別途承認する。

### 3.3 Persistence

- Worlds BeyondはPersistent Worldとする。
- 定期Reset／Season制を採用しない。
- Player建築、Waystone履歴および交通設備を長期保存する。
- 新しいIris Packへ無断で差し替えない。

---

## 4. World Rule

初期値：

| Setting | Value |
|---|---|
| Difficulty | `PEACEFUL` |
| PvP | 無効 |
| Keep Inventory | 通常Itemは無効。Worlds Beyond Traversal LoadoutのみOwner Bindで保持／復旧 |
| Mob Griefing | PEACEFUL前提。必要に応じて無効 |
| Fire Tick | Vanilla。Waystone／Launchpadは保護 |
| Natural Regeneration | Vanilla |
| World Border | Config／World生成時に設定 |
| Player Building | 許可 |
| Admin Landmark | 配置しない |

PEACEFUL採用理由：

- CombatよりTraversalを主目的にする。
- Gunpowderの通常Mob Dropを抑え、Firework Rocketを希少な高級移動手段にする。
- 食料・戦闘・装備ProgressionをRuined Frontierと分離する。

花火Craft自体は禁止しない。Structure Loot等で入手したGunpowderは通常Craftに使用できる。

---

## 5. Inventory Group

Worlds Beyond三次元は、Multiverse-Inventoriesの同一`worlds_beyond` Groupへ登録する。

MVIで共有する対象：

- Inventory、Armor、Offhand
- Ender Chest
- Vanilla XP／Level
- Health／Food
- Worlds Beyond Elytra
- Worlds Beyond Grappling Hook
- Launchpad Item
- Vanilla Item
- Worlds Beyond Shop Item

分離対象：

- Main Inventory
- Frontier Lobby Inventory
- Ruined Frontier／Guild Inventory
- EliteMobs Item
- Primis Quest Item

通常Player Stateの保存・復元はMultiverse-Inventoriesへ委譲する。`Wayfarer_Frontier`はWorlds Beyond Inventoryを独自DBへ保存せず、Portal、Gate、RespawnおよびCommand Teleportを包括監視して独自切替しない。

Waystoneの設置、発見、維持および履歴はInventoryとは別のGameplay Dataであり、MariaDBを正本とする。

`Wayfarer_Frontier`は自身が発行するElytra、Grappling Hook、Navigation Item、LaunchpadおよびWaystone Placement ToolのIdentityとTheme外使用制限だけを管理する。

---

## 6. Worlds Beyond Traversal Loadout

Worlds Beyond初回入場時に、`Wayfarer_Frontier`が次を支給する。ここでいうTraversal Loadoutは`Wayfarer_Core`とは無関係な、Worlds Beyond用の基本移動装備を意味する。恒久支給品と消耗品を区別し、無料再支給による複製を防止する。

| Item | 初期仕様 |
|---|---|
| Elytra | 1、破壊不能、Theme限定 |
| Grappling Hook | 1、LeafGrapple正規Item、耐久無効 |
| Launchpad | 初回のみ2個、各3回使用。消耗品として再支給しない |
| Navigation Item | Discovery／Teleport／Shop／Loadout／Helpを含む統合Navigation GUIを開くTheme限定Item |

要件：

- Inventoryに空きがない場合はPending Loadoutとして保持する。
- Elytra、Grappling Hook、Navigation ItemをWorlds Beyond Traversal Loadoutとする。
- Worlds Beyond Traversal LoadoutはOwner Bindとし、手動Drop、Container格納、他Player使用およびTheme外移送を拒否する。
- Worlds Beyond Traversal Loadoutは死亡Dropから除外し、Respawn後も保持する。保持に失敗した場合だけPending Deliveryから無料復旧する。
- Reissue時は論理Item ID／Instance Epochを更新し、旧Instanceを無効化して二重存在を防止する。
- Launchpadは消耗品であり、初回2個の配布はPlayerごとに一度だけとする。紛失、死亡、使用完了を理由とする無料再支給は行わない。
- Launchpadは通常のTheme Inventory Itemとして死亡Drop対象とする。System Faultによる消失だけAdmin Recovery対象にできる。
- ItemはPDCでTheme、Item Type、Ownerおよび必要なInstance情報を識別する。
- Theme外へ移動したItemは無効化または隔離する。
- Worlds Beyond Traversal Loadoutの正規復旧をWM消費にしない。
- Navigation ItemはGUI入口であり、任意座標をItemへ保存して直接Teleportする機能を持たない。TeleportはWaystone Domainの検証を必ず経由する。

---

## 7. Grappling Hook

### 7.1 採用候補

**LeafGrapple 1.0.2**をV0.0.5の第一候補とする。

正式採用条件：

- Paper 1.21.11／Java 25でEnableする。
- Main Hand／Off Handで正常に動作する。
- HookからElytraへ自然に移行できる。
- Player／Entity Hookを無効化できる。
- Theme外で使用できない。
- Restart後もPDC Item Identityが維持される。
- 異常加速、接続解除、落下Damage異常を起こさない。

Smoke Test不合格時はAeroGrapple等を再評価する。

### 7.2 初期Config

```yaml
hooks:
  worlds_beyond:
    display-name: "Wayfarer's Grappling Hook"
    item-material: FISHING_ROD
    max-distance: 32.0
    max-pull-distance: 48.0
    launch-speed: 1.4
    pull-acceleration: 0.06
    max-pull-speed: 1.0
    cooldown-ticks: 10

    durability:
      enabled: false

    entity-hook:
      enabled: false
```

値は使用感試験後に調整する。

### 7.3 連携

`Wayfarer_Frontier`はLeafGrapple本体を再実装せず、Adapterを介して正規Hook Itemを生成する。

要件：

- 対応Versionを固定する。
- 非公開内部Classへ直接依存する場合はAdapterへ隔離する。
- 起動時にPlugin Versionと必要機能を検証する。
- 連携不能時はWorlds BeyondをFail-closedし、不正な代替Itemを配布しない。
- Entity／Player Hookは常に無効とする。

---

## 8. ElytraおよびFirework Rocket

### 8.1 Elytra

- 初期支給する。
- Unbreakableまたは耐久を自動維持する。
- Theme外へ持ち出せない。
- 紛失時は有効Instanceが存在しないことを確認し、旧Instanceを失効させたうえで無料復旧する。
- HookおよびLaunchpadと組み合わせる。
- Fireworkなしでも地形を利用して移動できる設計とする。

### 8.2 Firework Rocket

Vanilla Craftは禁止しない。

WM Shop販売品：

| Field | Value |
|---|---|
| Price | 200 WM |
| Amount | 1 |
| Flight Duration | 3 |
| Firework Star | なし |
| Explosion | なし |
| Purpose | Elytra推進 |

Flight Duration 3を「高価だが場所を選ばない携帯推進剤」と位置付ける。

---

## 9. Launchpad

### 9.1 Concept

Launchpadは、Playerが現地へ設置してElytra射出に使う、安価で一時的な公共設備である。

中核仕様：

- 配置後はItemへ回収できない。
- 全Playerが公共利用できる。
- 任意Playerが手動破壊できる。
- 手動破壊時にItemをDropしない。
- 使用回数上限と放置期限を持つ。
- Active StateはMariaDBを正本とする。
- 設置、利用、手動破壊、自動削除およびAdmin操作をAuditへ残す。
- Playerの通常Block Break以外の環境要因から保護する。

### 9.2 Shop／Balance

| Field | Initial Value |
|---|---:|
| Price | 30 WM |
| Amount | 1 |
| Max successful uses | 3 |
| Initial free amount | 2 |
| Expiration | 30 days without use |
| Horizontal velocity | 2.5 |
| Vertical velocity | 1.2 |
| Use cooldown | 2 seconds |
| Max active per player | 0（上限なし） |
| WM per launch | 最大3回使用時に実質10 WM |

Launchpad Itemは通常のWorlds Beyond Theme Inventory Itemとして死亡Drop対象とし、恒久Traversal Loadoutの無料Reissue対象にしない。

### 9.3 初期Player体験Baseline／設置

初期実装Baseline：

- Structureは単一Blockとする。
- Materialは`LIGHT_WEIGHTED_PRESSURE_PLATE`（金の感圧板）とする。
- Custom Modelを初期必須としない。
- Item使用位置をOriginとする。
- Playerの設置時向きを射出方向として保存する。

設置条件：

- 固体Blockの上面へ設置する。
- 対象Block位置がAirである。
- Air以外を上書きしない。
- Liquid、Portal、World Border外、禁止Regionへ設置しない。
- Waystone構造物、Gate、Spawn安全範囲および既存Launchpadと重複させない。
- 射出方向に安全な初期空間がある。
- 設置成功時のみItemを1個消費する。
- 失敗時は理由を表示し、Itemを消費しない。
- Item、DB Recordおよび単一Blockの三者をExactly-once／Compensation原則で整合させる。

### 9.4 使用

- 全Playerが利用可能とする。
- Playerが金の感圧板の上へ乗った時に起動する。
- Sneak中は起動しない。
- Safe Launch判定を通過した成功射出だけ使用回数へ加算する。
- 射出時にElytraを自動展開する。
- 水平速度と上向き速度はConfig化する。
- 同一Launchpadの同時使用をLockする。
- PlayerがBlockへ埋まらないよう安全判定を行う。
- 使用成功時に`last_used_at`を更新し、放置期限を30日先へ延長する。
- Max Uses到達時にBlockとActive DB Rowを削除し、Auditを保持する。

暫定値：

```yaml
launchpad:
  material: LIGHT_WEIGHTED_PRESSURE_PLATE
  trigger: STEP_ON
  disable-while-sneaking: true
  custom-model-required: false
  max-successful-uses: 3
  horizontal-velocity: 2.5
  vertical-velocity: 1.2
  auto-deploy-elytra: true
  use-cooldown-seconds: 2
  expire-after-days: 30
  extend-expiration-on-use: true
```

### 9.5 Player手動破壊

Playerによる通常Block Breakだけを例外として許可する。

- Owner限定にせず、任意Playerが破壊できる。
- Launchpad本体である単一の金の感圧板を破壊対象とする。
- 有効なBreak時にBlockとActive DB Rowを削除する。
- ItemをDropしない。
- Auditを保持する。
- CancelされたBreakでは削除しない。
- 二重Breakや競合処理で二重削除しない。
- 配置済みLaunchpadを残存回数付きItemへ戻す経路を実装しない。

### 9.6 Expiration／削除

- 一度も使用されていない場合は`created_at`、使用済みの場合は`last_used_at`を放置期限の基準とする。
- 30日間無操作でシステム削除する。
- 利用成功ごとに放置期限を延長する。
- 使用回数上限、放置期限、Player手動破壊、Admin削除またはReconcileで削除する。
- 削除時はBlockとActive DB Rowを削除し、ItemをDropしない。
- Audit履歴はActive Row削除後も保持する。
- 削除前通知は設置者がOnlineの場合のみ任意で行う。
- `max-active-per-player: 0`を初期値とし、0は上限なしを意味する。
- Restart中に期限到達したRecordを起動後にCatch-upする。

### 9.7 環境保護

Playerの有効な通常Block Breakを除き、Launchpadは次から破壊、移動または変形されない。

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

Admin／System削除は専用経路とし、通常Player Breakとは別のAudit Eventを記録する。

---

## 10. Waystone Concept

Waystoneは、Playerが発見した場所に設置する期限付きの公共Teleport拠点である。

Waystoneには二つのPlayer Identityを保持する。

| Identity | 意味 | 変更 |
|---|---|---|
| Founder | 最初にWaystoneを設置したPlayer | 不変 |
| Maintainer | 現在Waystoneを維持しているPlayer | 維持／上書き／復活で変更 |

Founder名とWaystone名は永久に維持する。Maintainerは現地のPlayer HeadとGUI表示に反映する。

---

## 11. Waystone名称

名称形式：

```text
<Founder Name at Creation>'s <Biome Display Name> #<Sequence>
```

例：

```text
Bob's Plains #1
Bob's Plains #2
Bob's Desert #1
```

規則：

- Founder UUIDを正本として保存する。
- Founder Nameは設置時の名前を固定保存する。
- 後のPlayer Name変更でWaystone名を変更しない。
- Sequenceは`Founder UUID × Biome Key`ごとに採番する。
- SequenceはRuin移行後も再利用しない。
- Maintainerが変わっても名称を変更しない。
- Biome Display NameはConfig可能な英語表示名を使用する。
- 未定義BiomeはNamespaced Keyから安全な表示名を生成する。

---

## 12. Waystone State

```text
PROTECTED
   ↓ protected_until
CONTESTABLE
   ↓ active_until
DORMANT
   ↓ ruin_after
RUINED
```

### 12.1 PROTECTED

- Teleport可能。
- Discovery可能。
- 現Maintainer以外は上書き不可。
- Maintainerは期限前でも200 WMで維持更新可能。
- 維持更新でLifecycleを初期化する。

初期期間：14日。

### 12.2 CONTESTABLE

- Teleport可能。
- Discovery可能。
- 誰でも300 WMで上書き可能。
- 上書きしたPlayerが新Maintainerになる。
- Founder、Waystone名、Sequenceは維持する。
- Player Headを新Maintainerへ更新する。
- 上書き後はPROTECTEDへ戻る。

初期期間：14日。

### 12.3 DORMANT

- Teleport不可。
- Teleport GUIに表示しない。
- Discovery GUIに「停止中」として表示する。
- 構造物は現地に残る。
- 誰でも150 WMで復活可能。
- 復活者が新Maintainerになる。
- 復活後はPROTECTEDへ戻る。
- 物理InteractionでDiscovery Recordを作成してよいが、復活前はTeleportできない。

初期Ruin待機期間：180日。

### 12.4 RUINED

- Waystone構造物をシステム削除する。
- TeleportおよびDiscovery対象から除外する。
- DB Record、Founder、Name、Sequence、Historyを削除しない。
- 同一付近への新規Waystone設置を再び許可する。
- RUINED Recordは将来のHistory／Ranking GUIに使用できる。

---

## 13. Lifecycle操作と価格

| Operation | Condition | Cost | Result |
|---|---|---:|---|
| 新規設置 | Placement Tool使用 | 600 WMでTool購入 | PROTECTED |
| 維持更新 | 現地CoreをInteractionしたMaintainer、PROTECTED／CONTESTABLE | 200 WM | PROTECTEDへ更新 |
| 上書き | 現地CoreをInteraction、CONTESTABLE | 300 WM | Maintainer交代、PROTECTED |
| 復活 | 現地CoreをInteraction、DORMANT | 150 WM | Maintainer交代、PROTECTED |
| Teleport | 発見済み、Origin／DestinationがPROTECTEDまたはCONTESTABLE | 0 WM | Destinationへ移動 |

価格関係：

```text
Launchpad 30
<
Dormant復活 150
<
Waystone維持 200
=
Flight 3 Rocket 200
<
Contestable上書き 300
<
Waystone新規設置Tool 600
```

維持、上書きおよび復活は遠隔操作を許可せず、対象Waystoneの現地Coreからのみ実行する。

Dormant復活を維持更新より安くする理由：

- DORMANTへはTeleportできない。
- 復活者は別の移動手段で現地へ到達する必要がある。
- 古い交通拠点の再発見と復旧を促進する。

MainのEvenMoreFish売却Baselineとの比較：

| Rarity | 参考売却範囲 | Worlds Beyond価格との関係 |
|---|---:|---|
| Common | 1–30 WM | Launchpad 1個を日常消耗品として購入可能 |
| Rare | 10–75 WM | Launchpad購入、複数回の釣果で復活／維持へ接近 |
| Epic | 37.5–240 WM | Dormant復活、維持、Flight 3 Rocketの主要価格帯 |
| Legendary | 160–800 WM | Contestable上書き、新規Waystone設置の主要価格帯 |

この範囲は魚種、SizeおよびRarity倍率による設定上の参考値であり、時給を保証しない。正式調整は実際の販売数、Player別WM残高および消費頻度を観測して行う。

---

## 14. Waystone設置条件

新規設置時に、Template全体を事前検査する。

初期値：

| Parameter | Value |
|---|---:|
| Minimum horizontal distance | 1000 blocks |
| Template footprint | 5×5 |
| Required clearance | Template Bounding Box全体 |
| Foundation height tolerance | 1 block |
| World border margin | 32 blocks |
| Gate／Spawn exclusion | 256 blocks |

必須条件：

- 同一Worldの既存PROTECTED／CONTESTABLE／DORMANT Waystoneから水平1000 Block以上離れている。
- RUINED Recordは距離判定対象外。
- Template配置範囲がWorld Height内である。
- 構造物が置換する全BlockがAirである。
- 基礎面に十分なSolid Blockがある。
- 基礎面の高低差が許容範囲内である。
- Liquid内ではない。
- Portal、Gate、Spawn、WorldGuard禁止Region外である。
- 他のWaystone、Launchpad、保護構造物と重ならない。
- World Border内である。
- 対象WorldがWorlds Beyond Allowlistに含まれる。
- Chunkが正常にLoadされている。
- 設置成功時のみPlacement Toolを消費する。

距離は同一World内の水平距離を基本とし、Y差は初期判定に含めない。

---

## 15. Waystone構造物

初期Template：

- 5×5 Footprint
- 中央Core
- MaintainerのPlayer Head
- Interaction Block
- 状態表示用Light／Particle
- Dimensionに応じたBlock Palette

状態表現：

| State | Visual |
|---|---|
| PROTECTED | 明るいLight、安定Particle |
| CONTESTABLE | 色／Particle変化 |
| DORMANT | Light消灯、停止中表示、Particle停止 |
| RUINED | 物理構造を全削除 |

外観の最終Block PaletteとSchematicは実装前に別途作成する。Template IDとHead位置はConfig／Template Metadataで管理する。

Waystone StructureはAir以外を上書きしない。

---

## 16. Waystone物理保護

Waystoneの全Blockはシステム以外から破壊／変更不能とする。

保護対象：

- BlockBreakEvent
- BlockPlaceEvent
- Explosion
- Piston
- Fluid
- Fire／Burn
- EntityChangeBlock
- Enderman
- Falling Block
- Block Spread
- Tree／Mushroom Growth
- Structure生成
- WorldEdit／FAWE等の通常操作
- Adminの手動破壊

管理者も専用Command経由で削除／復旧する。WorldEdit／FAWEは通常のBukkit Block Eventだけでは保護できない場合があるため、明示的なMask／Hookまたは操作前検査を実装し、操作後のStructure整合性Auditも行う。

保護範囲は、DB上のOrigin、Rotation、Template IDおよびBounding Boxから復元する。構成Blockを全件DB保存することを必須としない。

---

## 17. Waystone Discovery

### 17.1 Discovery条件

WaystoneをTeleport Destinationとして解禁するには、Playerが現地のWaystoneへ一度以上Interactionする必要がある。

- 新規設置成功操作を現地Interactionとして扱い、FounderのDiscovery Recordを同一Transactionで作成する。
- Maintainer交代でDiscovery状態を失わない。
- WaystoneがDORMANTになってもDiscovery履歴を削除しない。
- RUINED後も履歴はDBへ残す。
- 同名Waystoneが再作成されることはなく、新規IDとして扱う。

### 17.2 未発見Waystone

- Teleport GUIに表示しない。
- 通常の一覧や件数にも含めない。
- Discovery GUIの検索範囲内でのみ表示する。
- 座標と距離をMouse Over Loreへ表示する。
- 現地Interaction前はTeleport不可。

---

## 18. Navigation GUI／Waystone GUI

Navigation ItemからWorlds Beyondの統合Navigation GUIを開く。

Navigation GUIに最低限含む入口：

- Discovery
- Teleport
- Frontier WM Shop
- Loadout
- Help

Navigation ItemはGUI入口であり、任意座標やTeleport先をItem自体へ保存しない。Waystone CoreのInteractionからも関連GUIへ進入できるが、Teleport GUIを現地Core専用にはしない。

### 18.1 Teleport GUI

Navigation ItemまたはWaystone GUIからTeleport GUIへ進入できる。

表示対象：

- Playerが一度以上現地Interactionして発見済みである。
- StateがPROTECTEDまたはCONTESTABLE等のTeleport可能状態である。
- 現在のWorld／DimensionからTeleport可能である。
- Destinationが物理的に存在し、DBと一致する。
- Permission、CooldownおよびTheme Allowlistの事前条件を満たす。

表示しない／選択不可：

- 未発見
- DORMANT
- RUINED
- 別Dimension（初期設定）
- 整合性Error中
- PermissionまたはStateにより利用不能

Icon：

- 現MaintainerのPlayer Head

Lore例：

```text
Bob's Plains #2

Founder: Bob
Maintainer: Alice
Biome: minecraft:plains
Location: X 1840 / Y 72 / Z -620
Status: Protected
Protected for: 3d 14h

First discovered: 2026-07-24
Last maintained: 2026-08-02
```

選択時も一覧生成時の結果を信用せず、Waystone DomainがDestination State、Discovery、Permission、Cooldown、Safe Arrival、Player状態およびWorld／Theme Allowlistを再検証してからTeleportする。

### 18.2 Discovery GUI

検索対象：

- 現在地から半径3000 Block以内。
- 同一World内。
- PROTECTED、CONTESTABLE、DORMANT。
- 発見済み／未発見の両方。
- RUINEDは対象外。

表示：

- Waystone名
- 座標
- 現在地からの水平距離
- State
- Founder
- Maintainer
- DORMANTは「停止中」
- 発見済みか未発見か

Discovery GUIの一覧表示だけではDiscoveryを解禁せず、未発見WaystoneへTeleportできない。統合Navigation GUIからTeleport GUIへ移動した場合も、発見済みWaystoneだけを対象とする。

初期値：

```yaml
discovery:
  search-radius: 3000
  search-cooldown-seconds: 30
  sort: DISTANCE_ASC
```

---

## 19. Teleport

TeleportはNavigation Itemから開くTeleport GUIまたはWaystone GUIから開始できる。Navigation Item自体が座標を保持して直接移動させるのではなく、Waystone Domainが毎回安全条件を検証する。

初期条件：

- PlayerがWorlds Beyond Allowlist内にいる。
- Destinationを発見済みである。
- DestinationがPROTECTEDまたはCONTESTABLE等のTeleport可能状態である。
- 同一Dimension／同一Bukkit Worldである。
- Playerが必要Permissionを持つ。
- Cooldown中ではない。
- PlayerがCombat、Fall、Vehicle、Portal移動中等の禁止状態ではない。
- Destination Chunkを安全にLoadできる。
- Safe Arrivalを検証できる。
- 実行直前にDestination State、Discoveryおよび物理構造との整合を再確認できる。

初期値：

```yaml
teleport:
  cost-wm: 0
  cooldown-seconds: 30
  warmup-seconds: 3
  cancel-on-move: true
  cancel-on-damage: true
  allow-cross-dimension: false
```

Teleport先はWaystone Templateに定義された安全位置とし、Core Block上へ直接埋め込まない。

---

## 20. Database

MariaDBを正本とする。

### 20.1 `wf_frontier_waystone`

候補Field：

```text
waystone_id
theme_id
world_id
x
y
z
rotation
template_id

founder_uuid
founder_name_at_creation
maintainer_uuid

biome_key
biome_display_name
founder_biome_sequence
display_name

state
protected_until
active_until
dormant_at
ruin_after
ruined_at

created_at
last_maintained_at
updated_at
lock_version
```

RUINED後もRowを削除しない。

初期Index候補：

```text
(world_id, state, x, z)
(state, protected_until)
(state, active_until)
(state, ruin_after)
(maintainer_uuid, state)
(founder_uuid, created_at)
```

距離検索はBounding Boxで候補を絞った後に正確な水平距離を判定し、全Row走査を避ける。

### 20.2 `wf_frontier_waystone_sequence`

```text
founder_uuid
biome_key
last_sequence
updated_at
```

Unique：

```text
founder_uuid + biome_key
```

Sequenceを減算、再利用、Resetしない。

### 20.3 `wf_frontier_waystone_discovery`

```text
waystone_id
player_uuid
discovered_at
last_interacted_at
last_teleported_at
teleport_count
```

Unique：

```text
waystone_id + player_uuid
```

### 20.4 `wf_frontier_waystone_history`

```text
history_id
waystone_id
event_type
actor_uuid
previous_maintainer_uuid
new_maintainer_uuid
wm_cost
transaction_id
occurred_at
details_json
```

Event例：

```text
CREATED
MAINTAINED
CONTESTED
REACTIVATED
BECAME_CONTESTABLE
BECAME_DORMANT
BECAME_RUINED
DISCOVERED
TELEPORTED
ADMIN_REPAIRED
ADMIN_REMOVED
```

### 20.5 `wf_frontier_launchpad`

Active Launchpadだけを保持し、削除後はActive Rowを削除してAuditを残す。

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
template_id
state
schema_version
updated_at
lock_version
```

- `placer_uuid`は履歴、通知および管理用であり、利用権または手動破壊権を独占しない。
- 使用回数はMariaDBの`successful_use_count`を正本とする。
- Max Uses、期限またはPlayer手動破壊で物理BlockとActive Rowを削除する。
- `LAUNCHPAD_PLACED`、`LAUNCHPAD_USED`、`LAUNCHPAD_PLAYER_DESTROYED`、`LAUNCHPAD_EXPIRED`、`LAUNCHPAD_MAX_USES_REACHED`、Admin／Reconcile EventをAuditへ保持する。

### 20.6 `wf_frontier_theme_player_state`

```text
player_uuid
theme_id
first_joined_at
initial_launchpad_granted
initial_launchpad_granted_at
pending_delivery_json
updated_at
lock_version
```

Unique：

```text
player_uuid + theme_id
```

初回Launchpad配布の一回性と、Inventory Full／System Fault時のPending Deliveryを管理する。

### 20.7 `wf_frontier_core_item_instance`

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

Unique：

```text
player_uuid + theme_id + item_type
```

対象`item_type`は少なくともELYTRA、GRAPPLING_HOOK、NAVIGATION_ITEMとする。Reissue時に`instance_epoch`を増加し、旧Epoch Itemを無効化する。

### 20.8 Ranking拡張

履歴から将来算出可能な指標：

- 最多Waystone Founder
- 最大同時Maintainer数
- 最長単一Waystone維持時間
- 最多Waystone復活数
- 最多上書き数
- 最多発見数
- 最多Teleport数
- 最長存続Waystone
- 年代別Champion

V0.0.5では集計UIを実装しないが、Dataを失わないSchemaとする。

---

## 21. ConcurrencyおよびCrash Safety

Waystone操作：

1. Player／Waystone Lockを取得する。
2. DB Rowを再読込する。
3. Stateと期限を再評価する。
4. WM残高を確認する。
5. Transaction IDを発行する。
6. WMを引き落とす。
7. DBを更新する。
8. Structure／Headを更新する。
9. Auditを記録する。
10. 失敗時はRefundまたはReconcile状態へ遷移する。

新規Waystone設置：

- Placement Toolには一意なItem Instance IDを持たせる。
- Location、距離、Template Clearance、SequenceおよびTool Instanceを一つのPlacement Transactionとして予約する。
- Transactionは少なくとも`PREPARED`、`ITEM_RESERVED`、`STRUCTURE_PLACED`、`COMMITTED`、`COMPENSATING`、`FAILED`を識別できる状態機械とする。
- Structure配置とInventory操作はMain Thread、DB処理は非同期で行う。
- 成功時はWaystone Record、Structure、Placement Tool消費の三者が一度だけ確定する。
- Crash／失敗時はStartup／Player Join Reconcileにより、「Waystoneが存在してToolが消費済み」または「Waystoneが存在せずToolが返却済み」のどちらかへ収束させる。
- Waystoneと返却Toolが同時に残る状態、および両方を失う状態を許可しない。
- Founder UUID×Biome KeyのSequence RowをLockし、失敗済みTransactionで確保したSequenceも原則再利用しない。

Launchpad設置も、Item Instance、DB RecordおよびStructure配置について同じExactly-once／Compensation原則を適用する。

要件：

- 同一Founder／Biomeの同時設置でもSequenceが重複しない。
- 同時上書きは一人だけ成功する。
- WM引落し後に二人目が失敗しても請求しない。
- Server Crash後にUnknown Transactionを検出できる。
- StructureとDB不一致をAdmin Commandで修復できる。
- Main ThreadでDB I/Oを実行しない。
- Bukkit APIによるItem／Block操作はMain Threadへ戻す。
- Lifecycle SchedulerはRestart後に期限超過分をCatch-upする。

---

## 22. Frontier WM Shop

`Wayfarer_Frontier`内にWorlds Beyond専用GUIを実装する。

販売品：

| Item | Price | Amount |
|---|---:|---:|
| Launchpad | 30 WM | 1 |
| Flight Duration 3 Firework Rocket | 200 WM | 1 |
| Waystone Placement Tool | 600 WM | 1 |

要件：

- Worlds Beyond内でのみ購入可能。
- Vault API経由でWMを引き落とす。
- Inventory Full時は購入を確定しないかPending Deliveryへ保存する。
- 二重Clickで二重購入しない。
- ItemはPDCで正規Identityを持つ。
- Placement Toolは新規設置成功時だけ消費する。
- GUI Slot、Material、Display Name、Lore、価格、購入単位をConfig化する。
- EconomyShopGUIへ依存しない。

---

## 23. Initial Config Baseline

```yaml
themes:
  worlds-beyond:
    enabled: true

    worlds:
      overworld: frontier_iris
      nether: frontier_iris_nether
      end: frontier_iris_the_end

    rules:
      difficulty: PEACEFUL
      pvp: false

    loadout:
      elytra:
        enabled: true
        unbreakable: true
      grapple:
        enabled: true
        type: worlds_beyond
        durability: false
      launchpad:
        initial-amount: 2
        initial-grant-once: true
        reissue-on-loss: false

    shop:
      launchpad:
        enabled: true
        price-wm: 30
        amount: 1
        uses: 3

      firework-rocket:
        enabled: true
        price-wm: 200
        amount: 1
        flight-duration: 3
        explosion-effects: false

      waystone-placement-tool:
        enabled: true
        price-wm: 600
        amount: 1

    launchpad:
      material: LIGHT_WEIGHTED_PRESSURE_PLATE
      trigger: STEP_ON
      disable-while-sneaking: true
      custom-model-required: false
      max-successful-uses: 3
      horizontal-velocity: 2.5
      vertical-velocity: 1.2
      auto-deploy-elytra: true
      use-cooldown-seconds: 2
      expire-after-days: 30
      extend-expiration-on-use: true
      allow-player-break: true
      drop-on-player-break: false
      max-active-per-player: 0

    waystone:
      minimum-horizontal-distance: 1000
      discovery-search-radius: 3000

      lifecycle:
        protected-days: 14
        contestable-days: 14
        dormant-before-ruin-days: 180

      costs:
        maintain-wm: 200
        contest-wm: 300
        reactivate-wm: 150

      teleport:
        navigation-item-entry: true
        waystone-core-entry: true
        cost-wm: 0
        cooldown-seconds: 30
        warmup-seconds: 3
        allow-cross-dimension: false
```

---

## 24. Permission／Administration

Permission名は実装時に最終Lockするが、責務境界は次をBaselineとする。Beyond Gateの通過Permissionは採用するGate／Portal方式側で定義し、`Wayfarer_Frontier`の必須Permissionとはしない。

一般Player候補：

```text
wayfarer.frontier.worlds_beyond.loadout
wayfarer.frontier.worlds_beyond.shop
wayfarer.frontier.worlds_beyond.launchpad.place
wayfarer.frontier.worlds_beyond.launchpad.use
wayfarer.frontier.worlds_beyond.waystone.place
wayfarer.frontier.worlds_beyond.waystone.discover
wayfarer.frontier.worlds_beyond.waystone.teleport
wayfarer.frontier.worlds_beyond.waystone.maintain
```

Admin候補：

```text
wayfarer.frontier.worlds_beyond.admin.inspect
wayfarer.frontier.worlds_beyond.admin.reconcile
wayfarer.frontier.worlds_beyond.admin.waystone.remove
wayfarer.frontier.worlds_beyond.admin.waystone.repair
wayfarer.frontier.worlds_beyond.admin.launchpad.remove
wayfarer.frontier.worlds_beyond.admin.audit
wayfarer.frontier.worlds_beyond.admin.reload
```

方針：

- BuilderへAdmin権限を付与しない。
- General PlayerへGive、Force State、Remove、Refund、ReconcileおよびReloadを許可しない。
- Admin操作はすべてAuditへ記録する。
- Reloadは安全に再読込可能な表示、価格、期間等へ限定し、World名、Schema、Template Identity等の変更はRestartを要求する。
- Critical Dependency、World Allowlist、Template、Database SchemaまたはEconomy Adapterの検証に失敗した場合、Wayfarer固有の購入、支給、設置、Teleportおよび更新操作をFail-closedする。物理Beyond Gateの閉鎖は運用手順または採用するGate Pluginで行い、`Wayfarer_Frontier`が通常Gate移動を直接制御する前提にしない。
- Admin Commandの正確なSyntaxはPlugin設計時に定義するが、Inspect、Reconcile、Structure Repair、System Remove、Pending Delivery確認を必須機能とする。

---

## 25. Player建築

- 通常地域でPlayer建築を許可する。
- 管理者は手作業Landmarkを事前配置しない。
- Playerが景勝地へ山小屋、橋、展望台、滑空台、道、駅、港等を建築することを許容する。
- Mainと競合する恒久生活拠点を禁止するHard RuleはV0.0.5で設けない。
- 大規模Farm、Lag設備、Portal Abuse等はNetwork共通Ruleで制御する。
- WaystoneおよびLaunchpadの保護範囲へ建築できない。
- 将来のTrainCarts路線はPlayerの利用実績が高い拠点間を候補とする。

---

## 26. Future Phase

### Stage 0 — Traversal World

- Iris三次元
- Theme Inventory
- PEACEFUL
- Elytra
- Grappling Hook

### Stage 1 — Disposable Infrastructure

- Launchpad
- Frontier WM Shop
- 公共利用
- Player手動破壊／Expiration

### Stage 2 — Temporary Waystone Network

- Placement
- Lifecycle
- Discovery GUI
- Teleport GUI
- DB History

### Stage 3 — Exploration Record

- Ranking
- Champion
- 道標維持記録
- Player命名／地図表示の再検討
- Waymark Achievement

### Stage 4 — Permanent Transit

- TrainCarts
- TC HangRail
- TC Coasters
- 主要Waystone間の景観交通

Stage 3以降はV0.0.5の実装必須範囲ではない。

---

## 27. 受入試験

### World

- [ ] Iris三次元が正しいEngine／Seedで生成される。
- [ ] Multiverse-NetherPortalsの正式Versionを固定できる。
- [ ] `handle-end-exit-respawn: true`が有効である。
- [ ] Overworld／NetherのLinkが双方向であり、往復先がWorlds Beyond Family内である。
- [ ] Overworld／EndのLinkが双方向である。
- [ ] Stronghold End PortalがWorlds Beyond Endへ接続する。
- [ ] End Exit PortalがWorlds Beyond Overworldへ帰還する。
- [ ] End Exit時に別ThemeのBed／Respawn Anchorへ移動しない。
- [ ] Ruined FrontierのPortalと相互接続されない。
- [ ] Mob、Item、VehicleのPortal通過挙動が許容範囲である。
- [ ] 同一Worlds Beyond Group内のPortal移動で不要なInventory保存／復元が発生しない。
- [ ] Worlds Beyond以外でIris Generatorが適用されない。
- [ ] DifficultyがPEACEFULで維持される。
- [ ] BetterStructures／EliteMobsがWorlds Beyondで発生しない。
- [ ] Frontier LobbyのBeyond Gateから安全に入場できる。
- [ ] Frontier Lobbyへの安全な帰還が可能。

### Inventory

- [ ] Multiverse-InventoriesのWorlds Beyond Groupへ三次元が登録される。
- [ ] Worlds Beyond三次元でInventoryが共有される。
- [ ] Frontier Lobby、Main、Ruined FrontierとInventoryが分離される。
- [ ] Beyond Gate、Portal、Respawn、Admin Teleportおよび再接続でMVI Profileが正しく切り替わる。
- [ ] Wayfarer_Frontierが通常Inventoryを独自DBへ保存しない。
- [ ] Elytra、Hook、LaunchpadをTheme外へ持ち出せない。
- [ ] Death／Restart後もWorlds Beyond Traversal Loadoutを復旧できる。
- [ ] Worlds Beyond Traversal Loadoutは死亡Drop、手動Drop、Container格納および他Player使用ができない。
- [ ] 初回無料Launchpadは一度だけ付与され、紛失／死亡で再支給されない。
- [ ] Reissue後の旧Instanceを使用できず、Item Duplicationが発生しない。

### Grappling Hook

- [ ] Paper 1.21.11／Java 25でLeafGrappleがEnableする。
- [ ] Main Hand／Off Handで使用できる。
- [ ] Entity／PlayerをHookできない。
- [ ] 耐久が減らない。
- [ ] HookからElytraへ自然に移行できる。
- [ ] 異常速度、接続解除、落下Damage異常がない。
- [ ] Theme外で使用できない。

### Launchpad

- [ ] 単一の`LIGHT_WEIGHTED_PRESSURE_PLATE`として設置される。
- [ ] Air以外を上書きしない。
- [ ] 設置失敗時にItemを消費しない。
- [ ] 設置成功時にItem、DB RowおよびBlockが一度だけ確定する。
- [ ] Playerが金の感圧板へ乗ると起動する。
- [ ] Sneak中は起動しない。
- [ ] 任意Playerが利用できる。
- [ ] 成功した射出だけUse Countへ加算される。
- [ ] 3回の成功使用でBlockとActive DB Rowが削除される。
- [ ] 配置後にItemへ回収できない。
- [ ] 任意Playerが手動破壊できる。
- [ ] Player手動破壊時にItemをDropしない。
- [ ] Player手動破壊時にActive DB Rowが削除され、Auditが残る。
- [ ] Explosion、Fire、Fluid、Piston、Entity Change、Growth、Structure Generation、WorldEdit／FAWEおよびMob Griefingで破壊・移動されない。
- [ ] 30日無操作でBlockとActive DB Rowが削除される。
- [ ] 成功使用で放置期限が延長される。
- [ ] Restart中に期限到達したLaunchpadが起動後にCatch-upされる。
- [ ] DB／Block不一致をReconcileできる。

### Waystone Lifecycle

- [ ] 新規設置でFounder／Maintainer／Name／Sequenceが保存される。
- [ ] Founder NameがPlayer Name変更後も固定される。
- [ ] 同一Founder／BiomeでSequenceが単調増加する。
- [ ] PROTECTED中は他Playerが上書きできない。
- [ ] Maintainerが200 WMで更新できる。
- [ ] CONTESTABLEで300 WM上書きできる。
- [ ] DORMANTでTeleportできない。
- [ ] DORMANTを150 WMで復活できる。
- [ ] RUINEDで物理Structureだけが削除される。
- [ ] RUINED後もDB RecordとSequenceが残る。
- [ ] Restart中に期限を越えたWaystoneが正しくCatch-upする。

### Discovery／Teleport

- [ ] Navigation ItemからDiscovery／Teleport／Shop／Loadout／Helpを含む統合Navigation GUIを開ける。
- [ ] Navigation ItemからTeleport GUIへ進入できる。
- [ ] Navigation Item自体が任意座標を保持して直接Teleportしない。
- [ ] 未発見WaystoneがTeleport GUIに表示されない。
- [ ] Discovery GUIに半径内の未発見Waystoneが表示される。
- [ ] Mouse Overで座標と距離を確認できる。
- [ ] DORMANTが「停止中」と表示される。
- [ ] 現地Interaction後だけDestinationとしてTeleport解禁される。
- [ ] Teleport先が発見済みかつ現在Teleport可能なWaystoneに限定される。
- [ ] Teleport実行時にState、Permission、Cooldown、Safe Arrival、Player状態およびTheme Allowlistを再検証する。
- [ ] 維持、上書き、復活を対象Waystoneの現地以外から実行できない。
- [ ] 別DimensionへTeleportできない。
- [ ] DestinationがDormant化した直後にTeleportできない。
- [ ] Unsafe Arrival時はTeleportを中止する。

### Economy

- [ ] Launchpad 30 WM、Rocket 200 WM、Placement Tool 600 WMで購入できる。
- [ ] Maintain 200 WM、Contest 300 WM、Reactivate 150 WMで処理される。
- [ ] Teleportは無料である。
- [ ] 二重Click、Lag、Disconnectで二重請求されない。
- [ ] DB失敗時にRefund／Reconcileできる。

### Protection

- [ ] WaystoneはPlayerの通常破壊を含む全通常変更から保護される。
- [ ] LaunchpadはPlayerの有効な通常Block Breakだけを例外として許可する。
- [ ] WaystoneおよびLaunchpadがExplosion、Fire、Fluid、Piston、Entity Change、Falling Block、Block Spread、Tree／Mushroom Growth、Structure Generation、通常WorldEdit／FAWEおよびMob Griefingで変更されない。
- [ ] Admin／System Removeだけが専用経路で環境保護を迂回できる。
- [ ] StructureとDB不一致をAdminが検出・修復できる。

---

## 28. 実プレイ評価で確定する項目

次の値はV0.0.5の初期BaselineとしてConfig化し、本流のProject構築チャットで実プレイ結果を基にLockする。評価は地上、山岳、渓谷、洞窟、Nether、Endなど複数地形で行い、移動時間、失敗率、WM収支、設置物密度およびServer負荷を記録する。

| 分野 | 初期Baseline | 実プレイで確認する内容 |
|---|---|---|
| Iris Engine／Pack | 実装前選定 | 景観品質、移動可能性、Biome多様性、洞窟／浮遊地形、Loot Source |
| Seed／World Border | 固定Seed／Config | 初期入口周辺の安全性、探索余地、長期容量、極端な地形偏り |
| Grappling Hook | 32／48 block、速度1.4／1.0 | 引き寄せ感、Swing性、上昇力、Elytra移行、酔い・異常加速 |
| Hook Cooldown | 10 tick | 連打感、移動テンポ、Server負荷、Launchpadとの差別化 |
| 初期Launchpad | 2個、3回使用 | 初心者救済量、浪費、公共設備として残る頻度 |
| Launchpad体験 | 金の感圧板／上に乗る／Sneak無効、水平2.5／垂直1.2／2秒Cooldown | 誤発射、視認性、Material、起動判定、離陸成功率、衝突、地形別到達距離、Hook／花火との役割分担 |
| Launchpad価格 | 30 WM | EvenMoreFish収益に対する日用品感、放置設備の増加速度 |
| Launchpad期限 | 30日 | 放置物密度、再利用率、DB／Chunk負荷 |
| 花火価格 | Flight 3を200 WM | 高級緊急移動としての購入頻度、Craft品とのBalance |
| Waystone最小距離 | 1000 block | 密集／疎遠、徒歩・滑空時間、景勝地カバー率 |
| Discovery半径 | 3000 block | 未発見地点の誘導強度、座標表示による探索短縮度 |
| Lifecycle | 14日／14日／180日 | 維持負担、上書き競争、Dormant復活機会、Ruin蓄積 |
| Waystone価格 | 600／200／300／150 WM | Founder取得難度、維持率、奪取頻度、Dormant復活の魅力 |
| Teleport | 無料、30秒Cooldown、3秒Warmup | 利便性、現地移動の形骸化、危険回避、連続利用 |
| Waystone Template | 3×3～5×5候補 | 設置成功率、景観適合、Player建築との干渉、視認性 |
| Discovery／Teleport GUI | 現行案 | 情報量、検索性、Dormant表示、誤操作、ページ数 |
| PEACEFUL | 固定Baseline | 食料・回復の形骸化がTheme意図に合うか、移動への集中度 |
| Player建築 | 許可 | Waystone周辺の過密化、交通設備の自然発生、Mainとの差別化 |
| Performance | Persistent三次元 | Iris生成、Waystone検索、構造物保護、Launchpad累積の負荷 |
| Permanent Transit移行 | 後続Stage | Waystone利用実績からTrainCarts導入時期と路線候補を判断 |

価格変更はEvenMoreFishの実売却額、Player別WM残高推移および購入回数を根拠にする。単に「高い／安い」という感想だけでは変更しない。

LaunchpadのMaterial、視認性、Trigger判定、水平／垂直速度およびCooldownは使用感Feedbackによりv0.0.xで調整できる。一方、配置後回収不可、公共利用、任意Playerの手動破壊、破壊時非Drop、環境保護、使用回数／期限による削除、MariaDB正本およびAuditという中核方針はPlaytestだけを理由に変更しない。

---

## 29. Deferred／実装時確認

Portal実装Lock：

- Multiverse-NetherPortalsの正式Version
- Overworld／NetherおよびOverworld／Endの双方向Link設定方法
- `handle-end-exit-respawn: true`
- End Exit時のBed／Respawn Anchor処理
- Multiverse-Core、MVI、Multiverse-NetherPortals、Irisおよび機能別AllowlistのWorld ID一致
- Beyond Gateの実装方式と到着地点

その他：

- Iris Engine／Packの正式選定
- Seed
- World Border
- Waystone最終Schematic
- Biome表示名Dictionary
- LeafGrapple実機採用
- Resource Pack Model
- 統合Navigation GUI／Discovery／Teleport GUI Item Layout
- Admin Command詳細
- Backup／Restore手順
- Waystone Ranking
- TrainCarts
- Cross-dimension Waystone
- Theme Achievement
- Main側記念表示

---

## 30. V0.0.5変更概要

- Launchpadを配置後回収不可へ変更した。
- Launchpadを任意Playerが手動破壊でき、破壊時にItemをDropしない仕様へ変更した。
- Launchpadの初期実装を単一の`LIGHT_WEIGHTED_PRESSURE_PLATE`とし、上に乗ると起動、Sneak中は起動しないBaselineへ変更した。
- LaunchpadのPlayer手動Breakだけを環境保護の例外とし、Explosion、Fire、Fluid、Piston、Entity Change、Growth、Structure Generation、WorldEdit／FAWEおよびMob Griefingから保護する方針を明確化した。
- LaunchpadのActive StateをMariaDB正本とし、使用回数、期限延長、Active Row削除およびAudit保持を同期した。
- Navigation ItemからDiscovery／Teleport／Shop／Loadout／Helpを含む統合Navigation GUIを開く仕様へ変更した。
- Teleport GUIへNavigation Itemから進入可能とし、発見済みかつ現在Teleport可能なWaystoneだけをWaystone Domainの安全判定経由で利用する仕様へ変更した。
- Acceptance、Initial Config、Database、Future PhaseおよびPlaytest境界をPlugin Concept v0.0.3へ同期した。

---

## 31. 実装時の原則

1. Waystone、Launchpad、Frontier WM Shop、Worlds Beyond Traversal LoadoutおよびWayfarer固有Item Identityは`Wayfarer_Frontier`へ実装する。
2. 通常Inventory、Ender Chest、XP、HealthおよびFoodの保存・復元はMultiverse-Inventoriesへ委譲する。
3. `Wayfarer_Frontier`は通常のGate、Portal、RespawnおよびWorld変更を包括監視してInventoryを独自切替しない。
4. Database、Migration、WM Adapterおよび共通Auditは`Wayfarer_Core`を利用する。
5. LeafGrapple本体をFork／再実装せず、必要な場合だけAdapterを作る。
6. World GenerationはIrisへ任せる。
7. Frontier Lobbyからの初期導線は物理Beyond Gateとし、Theme選択GUIは後続検討とする。
8. 管理者配置LandmarkをGameplay要件にしない。
9. Structure配置はAir以外を上書きしない。
10. Waystoneは専用Lifecycle／System経路で管理し、Launchpadは任意Playerの手動Breakだけを許可してItemをDropしない。
11. Ruin後もWaystone履歴を削除しない。
12. 暫定値はConfigから変更可能にする。
13. Economy調整はEvenMoreFish売却実績とWM残高推移を観測して行う。
