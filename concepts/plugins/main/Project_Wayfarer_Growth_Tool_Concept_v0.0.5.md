# Project Wayfarer Growth Tool Concept v0.0.5

> **状態:** Under Review  
> **保存先:** Project Wayfarer Repository `concepts/plugins/main/`  
> **関連Concept:** `../Project_Wayfarer_Plugin_Concept_v0.0.3.md`  
> **対象Runtime:** Main  
> **想定Runtime Plugin:** `Wayfarer_Main`  
> **初期対象Tool:** Pickaxeのみ  
> **実装状態:** 未着手

---

## 1. 目的

Playerごとに一意なGrowth Pickaxeを提供し、Resource Worldでの採掘によって素材・Enchant・進化回数を成長させる。

Growth Toolは任意の追加Progressionであり、Vanilla ToolのCraft、Enchant、Mendingおよび通常利用を禁止しない。

Growth Toolには次を実装する。

- Tool Identity
- Owner Bind
- 採掘Progress
- Material Evolution
- Enchantment Evolution
- Configに基づく完全再計算
- Broken Tool
- Waymark Full Repair
- 統合GUI
- Admin／Debug
- MariaDB永続化
- Audit／Reconcile

---

## 2. V0.1.0 Scope

Growth Pickaxeと`Wayfarer_Main`をProject Wayfarer V0.1.0 Release Scopeへ含める。

Project本流のRoadmap、Acceptance Test、Backup／RestoreおよびRelease Blocker一覧は、本Conceptと同期して別途更新する。

初期実装に含む:

- Pickaxe
- Playerごとに1本
- Main Backend
- Resource三次元
- Material Evolution
- Efficiency
- Unbreaking
- Fortune
- AdminによるFortune／Silk Touch切替
- Broken状態
- WM修理
- 初回自動配布
- Admin付与／再発行
- Debug Command

後続:

- Axe
- Shovel
- Player向けWM Fortune／Silk Touch切替
- WMによるNetherite化
- Ranking
- Evolution Reward
- Ability
- Cosmetic
- Cross-server利用

---

## 3. Tool Identity

MariaDB上の論理Toolを正本とする。

候補Field:

```text
tool_id
owner_uuid
tool_type
instance_epoch
cumulative_progress_units
active_branch
tool_status
delivery_status
stored_damage
netherite_upgrade_unlocked
netherite_upgraded_at
schema_version
lock_version
created_at
updated_at
last_checkpoint_at
```

`tool_type`初期値:

```text
PICKAXE
```

`active_branch`:

```text
FORTUNE
SILK_TOUCH
```

`tool_status`:

```text
ACTIVE
BROKEN
REVOKED
```

`delivery_status`:

```text
DELIVERED
PENDING
```

`REISSUED`は現在の論理Tool状態として保持しない。ReissueはTransaction／Audit Eventおよび旧Physical Instanceの失効理由として記録する。Reissue後の論理Toolは`ACTIVE`または`BROKEN`を維持する。

Material、Evolution Count、Efficiency Level、Unbreaking Level、Fortune Levelは、累計Progressと現行Configから導出する。

個別Enchant Levelを永続正本として保持しない。

### 3.1 Item PDC

```text
wayfarer:item_type
wayfarer:tool_id
wayfarer:owner_uuid
wayfarer:tool_type
wayfarer:instance_epoch
wayfarer:schema_version
wayfarer:display_revision
```

Lore、Item NameまたはMaterialだけをIdentityに使用しない。

---

## 4. Owner Bind

Growth ToolとBroken Toolに適用する。

- Owner以外は使用不可
- Owner以外はProgress加算不可
- 手動Drop拒否
- Owner以外のPickup拒否
- Container格納拒否
- Anvil拒否
- Grindstone拒否
- Smithing拒否
- Crafting修理拒否
- 同種Tool合成拒否
- Mending付与拒否
- mcMMO等の外部修理拒否
- Item Frame／Armor Stand等への設置拒否
- 死亡Dropから除外
- Admin Reissue後の旧Epoch使用拒否

通常Inventoryを独自DBへ保存しない。

---

## 5. 初回配布

MainへのPlayer Join時、`Wayfarer_Main`はMain Threadを塞がず、専用Executorから非同期で次を照会する。

```text
owner_uuid + tool_type=PICKAXE
```

Unique制約によりPlayerごとに1本を保証する。

### 5.1 非同期Join Flow

1. `PlayerJoinEvent`では照会Taskの登録だけを行う。
2. MariaDBからTool Recordを非同期で取得する。
3. Recordが存在しない場合は、Unique制約を用いてRace-safeにRecordを作成する。
4. DB処理完了後、PlayerがまだOnlineか再確認する。
5. Item付与とInventory操作だけをMain Threadで行う。
6. 発行結果をAuditへ記録する。

DB処理中にPlayerがLogoutした場合:

- Itemを付与しない。
- 地面へDropしない。
- Record作成済みの場合はPending Deliveryとして扱う。
- 次回Join時に再評価する。

### 5.2 Recordが存在する場合

- Session Cacheへロードする。
- `delivery_status=PENDING`の場合だけ付与を再試行する。
- `tool_status=ACTIVE`または`BROKEN`で`delivery_status=DELIVERED`のRecordに対して自動Reissueしない。
- Item紛失または重複疑いはAdmin Inspect／Reissue対象とする。

### 5.3 Inventory Full

付与時に空きSlotがない場合:

- Itemを地面へDropしない。
- Toolを失効させない。
- Pending Deliveryとして保持する。
- PlayerのChatへ、Inventoryに空きを作り運営へ連絡するよう通知する。
- Server ConsoleへWARN Levelで、Player Name、UUID、Tool IDおよび`INVENTORY_FULL`理由を出力する。
- 次回JoinまたはAdmin Reconcile／Delivery Commandで再試行できる。

Player向け表示例:

```text
成長するピッケルを受け取れませんでした。
インベントリに空きを作り、運営へ連絡してください。
```

Console表示例:

```text
[Wayfarer_Main] Growth Pickaxe delivery pending:
player=<name>, uuid=<uuid>, tool_id=<tool_id>, reason=INVENTORY_FULL
```

`Player#hasPlayedBefore()`だけを配布正本にしない。Plugin導入前から存在するPlayerにも、Tool Recordがなければ配布する。

---

## 6. Progress対象World

Progressを加算するWorld:

```text
resource
resource_nether
resource_end
```

加算しないWorld:

```text
main
main_nether
main_the_end
その他すべて
```

World名はConfig Allowlistで管理し、未知Worldを自動追加しない。

---

## 7. Progress対象Block

MinecraftのPickaxe適正Tagを基準とする。

```text
minecraft:mineable/pickaxe
```

条件を満たすBlockは、自然生成、Player設置、Plugin生成、Generator生成を区別せずProgress対象とする。

明示的に許可する行為:

- Cobblestone Generator
- Stone Generator
- Basalt Generator
- Player設置Block再採掘
- Silk Touchで回収したOreの再設置
- Ore再採掘

鉱石再設置によるProgress獲得も禁止しない。ただしOre Weightを極端に高くしない。

---

## 8. GameMode・Event条件

加算:

- SURVIVAL
- ADVENTUREで実際にBlock破壊が成立した場合

加算しない:

- CREATIVE
- SPECTATOR

共通条件:

- `BlockBreakEvent`がCancelされていない
- Resource三次元
- Main Handに正規Growth Pickaxe
- Owner一致
- Tool ID一致
- Instance Epoch一致
- StatusがACTIVE
- Pickaxe適正Tag対象
- 実際にPlayerの破壊Eventが成立

Explosion、Piston、WorldEdit、Command、Pluginによる直接削除では加算しない。

---

## 9. Progress内部表現

小数誤差を避けるため固定小数点整数を使用する。

初期Scale:

```text
1.000 Progress = 1000 internal units
```

Configは小数表記を許可し、ロード時に整数へ正規化する。

MariaDBには`cumulative_progress_units`を整数で保存する。

---

## 10. 初期Block Weight Baseline

値は暫定であり、Config化する。

### 10.1 基礎Block

| Category／Block | Progress |
|---|---:|
| COBBLESTONE | 0.25 |
| COBBLED_DEEPSLATE | 0.35 |
| STONE | 1.00 |
| GRANITE | 1.00 |
| DIORITE | 1.00 |
| ANDESITE | 1.00 |
| TUFF | 1.00 |
| CALCITE | 1.00 |
| NETHERRACK | 1.00 |
| BLACKSTONE | 1.00 |
| BASALT／SMOOTH_BASALT | 1.00 |
| DEEPSLATE | 1.25 |
| END_STONE | 1.25 |
| OBSIDIAN／CRYING_OBSIDIAN | 2.00 |

関係:

```text
COBBLESTONE
<
STONE系 = NETHERRACK
<
DEEPSLATE = END_STONE
```

### 10.2 Ore倍率

Ore Progressは概念上、基礎石種WeightとOre倍率から決める。

```text
ore_progress = base_stone_weight × rarity_multiplier
```

初期倍率:

| Ore Group | Multiplier |
|---|---:|
| COAL／NETHER_QUARTZ | 1.50 |
| COPPER | 1.60 |
| REDSTONE | 1.75 |
| IRON | 2.00 |
| LAPIS | 2.10 |
| NETHER_GOLD | 2.00 |
| GOLD | 2.50 |
| DIAMOND | 3.50 |
| EMERALD | 4.00 |
| ANCIENT_DEBRIS | 4.00 |

例:

```text
STONE base Diamond Ore = 1.00 × 3.50 = 3.50
DEEPSLATE Diamond Ore   = 1.25 × 3.50 = 4.375
```

Player設置Oreを再採掘できるため、Ore倍率は希少性を表現しつつも大幅なProgress Farmにならない範囲に抑える。

### 10.3 その他のPickaxe適正Block

Tag対象だが明示表にないBlockは、ConfigのFallback Weightを使用する。

初期値:

```yaml
progress:
  fallback-weight: 1.0
```

Storage Block、装飾Block等を個別に低Weightへ上書きできる。

---

## 11. Evolution Source of Truth

累計Progressを永続的なProgress正本とする。

Evolution Countは、累計ProgressとConfigから生成した累積Thresholdの比較結果として導出する。

```text
evolution_count
= threshold[i] <= cumulative_progress
  を満たす最大のi
```

`threshold[0] = 0`とし、`threshold[i]`はEvolution Count `i`へ到達するために必要な累計Progressを意味する。ProgressがThresholdと等しい場合は到達済みとする。

現行Configから次を完全再計算する。

- Evolution Count
- Material
- Conceptual Efficiency Level
- Conceptual Unbreaking Level
- Conceptual Fortune Level
- Effective Enchantment
- 次の進化Threshold

Config変更による降格を許容する。

DB上の累計Progressは変更しない。

---

## 12. 完全再計算の実装原則

### 12.1 Thresholdの事前計算

素材ThresholdとEnchant進化式／Mapから、Runtime比較に使用する累積Thresholdを生成する。正確なCache生成・遅延拡張方式は実装作業指示書兼設計仕様書でLockする。

```text
threshold[0]
threshold[1]
threshold[2]
...
```

進化回数を変数とする式は、Threshold Cacheを生成または拡張する際に非再帰Loopで評価する。

RuntimeのItem検証時に再帰計算を行わない。

初期必要範囲のThresholdを生成し、現在ProgressがCache末尾を超えた場合は、同一Config Revision内で必要範囲まで遅延拡張する。一度生成したThresholdはCacheして再利用する。

PlayerがToolを手に持った場合、Session Cache上の累計ProgressをThreshold配列へ二分探索し、Evolution Countを算出する。

初期最大付与段階はMaterial 3段階＋Enchant 25段階程度であり、再計算自体は数回の整数比較で完了する。

将来数千段階になっても二分探索を使用する。数値Overflowへ接近した場合はProgress加算をFail-closedし、Critical LogとAuditを記録する。

### 12.2 DBアクセス

Toolを持つたびにMariaDBへ問い合わせない。

- Join時に専用Executorで非同期ロード
- Session Cacheを利用
- Held Item時はRAM上で再計算
- 必要なItem表示更新だけMain Threadで実行

### 12.3 再計算Timing

- Player Join後の非同期Record取得完了時
- Main Handへ持ち替えた時
- Off HandとのSwap後
- Inventory操作でMain Handへ入った時
- Growth ToolでBlockを破壊する直前
- Progress加算後
- Evolution Threshold到達時
- Repair
- Reissue
- Admin操作
- Config Revision変更後、次にMain Handへ持った時

### 12.4 Item更新抑制

次が変わった場合だけItemMeta／Materialを再生成する。

- Config Revision
- Material
- Effective Enchantment
- Evolution Count Lore
- Status
- Branch
- Instance Epoch

変化がなければItemStackを書き換えない。

---

## 13. 完全再計算・進化と耐久

### 13.1 Progress増加によるGameplay Evolution

実際のBlock破壊でProgressが増加し、Evolution Countが1以上増加した場合だけ:

- 新しいMaterial／Enchantを適用
- 耐久を最大まで回復
- 複数段階を一度に越えた場合も1回の最大回復
- Auditへ到達前後のEvolution Countを記録

### 13.2 Config Reconciliation

Threshold、進化式、Map、Enchant上限その他Config変更による完全再計算では、Evolution Countが上昇しても下降しても修理しない。

- ACTIVE Toolは旧Materialの残存耐久率を維持する。
- Material変更時は、旧Materialの残存耐久率を新Materialの最大耐久値へ乗算する。
- 換算後の残存耐久値は整数へ丸め、`1`から新Material最大耐久値までの範囲へClampする。
- ACTIVE ToolのConfig再計算結果として残存耐久値が`0`以下になることを許可しない。
- Config再計算だけを理由に最大耐久へ回復しない。
- BROKEN ToolはBROKENのままにする。
- 降格・昇格の双方で累計Progressを維持する。
- Config ReconciliationをAuditする。

これにより、最大回復はPlayerのProgress増加によって実際に進化した場合だけ発生する。

---

## 14. Material Evolution

初期Material:

```text
WOODEN_PICKAXE
```

基礎Materialの順序:

```text
Wood
→ Stone
→ Iron
→ Diamond
```

初期3回のEvolutionで順番に到達する。

NetheriteはProgressによる自動Evolutionへ含めない。

### 14.1 Netherite Upgrade履歴

将来、Diamond到達後にWMを支払ってNetheriteへ変更できるようにする。

Netherite化は一時的なItem状態ではなく、論理Toolに対する永続Unlockとして扱う。

MariaDB候補:

```text
netherite_upgrade_unlocked BOOLEAN NOT NULL
netherite_upgraded_at TIMESTAMP NULL
```

一度正式なNetherite Upgrade Transactionが成功した場合:

```text
netherite_upgrade_unlocked = true
```

とし、通常のConfig再計算、降格、Reissue、Repairでは`false`へ戻さない。

### 14.2 Config再計算による降格

Netherite Upgrade済みToolが、Threshold／進化式変更によってIron以下の基礎Materialへ降格した場合:

- ゲーム上のItem Materialも再計算結果に従ってWood／Stone／Ironへ降格する。
- Netherite Upgrade履歴はDBへ保持する。
- Netherite Upgrade料金を再請求しない。
- 累計Progressが再びDiamond到達条件を満たした時点で、自動的にNetheriteへ復帰する。

Effective Materialの導出:

```text
if base_material == DIAMOND
   and netherite_upgrade_unlocked == true:
    effective_material = NETHERITE
else:
    effective_material = base_material
```

したがって、Config再計算後も基礎MaterialがDiamond以上である限り、Upgrade済みToolはNetheriteを維持する。

### 14.3 Netherite Upgrade Transaction

将来実装時の要件:

- Diamond到達済み
- 未Upgrade
- Playerの明示操作
- WM消費
- Transaction ID
- Idempotency
- 二重請求防止
- DB更新失敗時Refund／Reconcile
- Upgrade履歴Audit

---

## 15. Enchantment Evolution

Diamond到達後、次の5Step Cycleを繰り返す。

```text
Efficiency
→ Unbreaking
→ Efficiency
→ Unbreaking
→ Fortune
→ Repeat
```

### 15.1 Conceptual Level

進化回数からConceptual Levelを無制限に導出する。

DBへ個別Enchant Levelを保存しない。

### 15.2 初期Effective上限

| Enchantment | Initial Config Cap |
|---|---:|
| Efficiency | X |
| Unbreaking | X |
| Fortune | V |
| Silk Touch | I |

Conceptual LevelがConfig上限を超えても、累計ProgressとEvolution Countは増え続ける。

Itemへ適用するEffective LevelだけをConfig上限へClampする。

Config上限を後から上げれば、次回再計算時に過去のConceptual Levelが反映される。

### 15.3 Fortune

最初のFortune Stepに到達した時点でFortune Iを自動付与する。

初期実装ではPlayerへFortune／Silk Touch選択を求めず、Default BranchをFortuneとする。

---

## 16. Fortune／Silk Touch Branch

DBには`active_branch`を保存する。

初期Default:

```text
FORTUNE
```

### 16.1 Fortune Branch

- Conceptual Fortune LevelをEffective上限まで適用
- Fortune Evolution StepごとにConceptual Levelが増加

### 16.2 Silk Touch Branch

- Silk Touch Iを適用
- FortuneはItemへ適用しない
- Fortune Evolution StepのProgressとEvolution Countは蓄積
- Conceptual Fortune Levelも進行する
- Fortuneへ戻した時に現在のConceptual Fortune Levelを再適用

### 16.3 初期実装

一般PlayerによるWM切替は実装しない。

Adminは対象PlayerのBranchを切り替えられる。

将来:

- Growth Tool統合GUIから切替
- Fortune→Silk TouchにWM消費
- Silk Touch→Fortuneにも少額WM消費
- 二重請求防止
- Transaction／Audit／Refund

---

## 17. Evolution Threshold Baseline

素材進化は早期に到達し、その後は必要Progressを増加させる。

初期累積Threshold案:

| Evolution Count | Result | Cumulative Progress |
|---:|---|---:|
| 0 | Wooden | 0 |
| 1 | Stone | 100 |
| 2 | Iron | 400 |
| 3 | Diamond | 1,200 |

Diamond以降の第`n`回Enchant Evolutionに必要な増分:

```text
required_increment(n)
= enchant_base
+ enchant_linear × n
+ enchant_quadratic × n²
```

初期Config案:

```yaml
evolution:
  material-thresholds:
    stone: 100
    iron: 400
    diamond: 1200

  enchant-progression:
    base: 800
    linear: 200
    quadratic: 40
```

例:

```text
n=1  → 1,040
n=5  → 2,800
n=10 → 6,800
n=25 → 30,800
```

数値はPlaytest用Baselineであり、採掘速度、World消費、WM収益および進化所要時間を測定して改訂する。

---

## 18. Evolution Count表示

Wayfarerが追加するCustom Loreには、現在のEvolution Countだけを表示する。VanillaのEnchantment表示は通常どおり維持する。

例:

```text
Evolution: 12
```

Item Loreへ次を常時表示しない。

- 累計Progress
- 次Threshold
- Full Tool UUID
- 詳細Enchant計算
- 修理価格

詳細は統合GUIで表示する。

---

## 19. Broken Tool

耐久が0になる破壊EventをInterceptし、Item消滅を防ぐ。

変換先:

```text
GRAY_DYE
```

表示例:

```text
壊れた成長のピッケル
```

保持:

- Tool ID
- Owner
- Tool Type
- Instance Epoch
- 累計Progress
- Branch
- Schema Version

DB:

```text
status = BROKEN
```

Broken状態:

- Pickaxeとして使用不可
- Block破壊不可
- Progress加算不可
- Entity攻撃用効果なし
- 外部修理不可
- Drop不可
- Container格納不可
- 死亡時保持
- 統合GUIを開ける
- WM RepairまたはAdmin Repairで復帰

Repair時は現行Configと累計ProgressからMaterial／Enchantを再計算して復元する。

---

## 20. Growth Tool統合GUI

### 20.1 起動

次の条件で開く。

- Main HandにGrowth ToolまたはBroken Tool
- 空中への右クリック
- Block／EntityをTargetにしていない
- Off Handからは起動しない

将来Pickaxe以外が追加された場合も同じ入口を使用する。

### 20.2 Main画面

表示:

- Tool Type
- Status
- Material
- Evolution Count
- Cumulative Progress
- 次のEvolutionまでの必要Progress
- Efficiency
- Unbreaking
- Fortune／Silk Touch
- Durability
- Repair Cost Preview
- Config上限によるClamp状態

操作:

- Repair
- 将来Branch切替
- 将来Netherite Upgrade
- Status／Help

### 20.3 Repair確認

遷移:

```text
統合GUI
→ Repairを選択
→ 費用・結果確認GUI
→ Confirm／Cancel
```

二重Click、GUI再送、Disconnect、Lagで二重請求しない。

Broken Toolでも同じGUIを使用する。

---

## 21. WM Repair

全回復のみを提供する。

### 21.1 Full Repair Base

```text
full_repair_cost(e)
= ceil(
    base_cost_wm
    × (1 + e × evolution_multiplier_per_step)
  )
```

`e`は現在のEvolution Count。

初期値:

```yaml
repair:
  base-cost-wm: 100
  evolution-multiplier-per-step: 0.08
```

例:

| Evolution Count | Full Repair Base |
|---:|---:|
| 0 | 100 WM |
| 3 | 124 WM |
| 10 | 180 WM |
| 28 | 324 WM |

### 21.2 ACTIVE Tool修理

欠損耐久率は副次係数として使用し、極端に安い小修理を防ぐ。

```text
normal_repair_cost
= ceil(
    full_repair_cost(e)
    × max(minimum_charge_ratio, missing_durability_ratio)
  )
```

初期値:

```yaml
repair:
  minimum-charge-ratio: 0.25
```

- 少しだけ損傷していてもFull Repair Baseの25%を最低料金とする。
- Damageが大きいほど最大100%まで上昇する。
- Evolution Countが主な価格係数となる。
- 最大耐久時は修理不可／0 WM。

### 21.3 BROKEN復旧

BROKENは欠損率計算を使用せず、Full Repair BaseとBroken追加料金を使う。

```text
broken_repair_cost
= full_repair_cost(e)
+ broken_flat_surcharge
+ e × broken_surcharge_per_evolution
```

初期値:

```yaml
repair:
  broken:
    flat-surcharge-wm: 100
    surcharge-per-evolution: 5
```

例:

| Evolution Count | Broken Repair |
|---:|---:|
| 0 | 200 WM |
| 3 | 239 WM |
| 10 | 330 WM |
| 28 | 564 WM |

主な価格係数:

1. Evolution Count
2. ACTIVE／BROKEN
3. ACTIVE時だけDamage率を副次適用

### 21.4 External Economy Observation

現行Main EconomyShopGUI Alpha Baseline:

| Item | Sell |
|---|---:|
| Cobblestone | 2 WM |
| Cobbled Deepslate | 3 WM |
| Raw Iron | 25 WM |
| Raw Gold | 50 WM |
| Diamond | 400 WM |

現行のCobblestone／Cobbled Deepslate価格は無限生成に対して高い可能性がある。

Growth Tool修理BalanceのPlaytestと併せ、将来のEconomy改訂候補として次を比較する。

```text
Cobblestone: 0.50 WM前後
Cobbled Deepslate: 0.75 WM前後
```

これは本ConceptだけでEconomyShopGUI価格を変更する決定ではない。Project Wayfarer側の経済改訂タスクで正式決定する。

---

## 22. Repair Transaction

WMとMariaDBを単一ACID Transactionにできないため、補償処理を行う。

1. Player／Tool Lock
2. Tool再検証
3. Repair Cost確定
4. Transaction ID発行
5. WM残高確認
6. WM引落し
7. DB状態更新
8. Item復元／耐久最大化
9. Audit
10. DB／Item失敗時Refund
11. Refund失敗時Unknown／Reconcile

必須:

- Idempotency
- 二重請求防止
- 二重Refund防止
- Disconnect対応
- Unknown状態
- Admin Reconcile

---

## 23. Checkpoint

通常Progress:

```text
BlockBreakEvent
→ Session Cache加算
→ Dirty
→ Async Checkpoint
```

初期Timing:

- 5分周期
- Evolution到達時
- Broken化時
- Repair時
- Player Quit
- Plugin Disable
- 正常Server停止
- Admin操作

Main ThreadでDB I/Oを行わない。

Crash時は最長Checkpoint間隔分の通常Progressを失う可能性がある。

---

## 24. Admin Command候補

```text
/wayfarer admin tool inspect <player>
/wayfarer admin tool grant <player>
/wayfarer admin tool reissue <player>
/wayfarer admin tool repair <player>
/wayfarer admin tool branch <player> <fortune|silk_touch>
/wayfarer admin tool revoke <player>
/wayfarer admin tool reconcile <player>
```

Grant:

- Tool RecordがないPlayerへ作成・付与
- Recordがある場合は重複発行しない
- Reissueとは分離

Reissue:

- `instance_epoch`を増加
- 旧Item無効
- 累計Progress、Branch、Status方針を維持
- Audit

---

## 25. Debug Command

候補:

```text
/wayfarer admin tool debug progress-next <player>
/wayfarer admin tool debug durability-one <player>
/wayfarer admin tool debug repair-free <player>
```

`progress-next`:

```text
次Threshold internal units - 1
```

へ累計Progressを設定する。

Debug CommandだけをConfig Gate対象とする。

```yaml
debug-commands:
  enabled: false
```

実行条件:

- Admin Permission
- Config `enabled: true`

本番Defaultは無効。

---

## 26. Performance方針

### 26.1 完全再計算

負荷の中心はDBではなく、ItemMeta再生成である。

対策:

- Join時に1回だけ非同期DBロード
- ThresholdをConfigロード時に事前計算
- 二分探索
- 状態変化時だけItem更新
- Block Breakごとに全DB照会しない
- 次ThresholdをSession Cacheへ保持
- 通常Block Breakでは加算とThreshold比較だけ

### 26.2 Join照会

`owner_uuid + tool_type`へUnique Indexを設定する。

1 Joinにつき原則1 Indexed Queryであり、MainのWorld／Player Dataロードと比較して小さい処理にする。

同時Join時もConnection Poolと非同期Executorで処理する。

---

## 27. Acceptance Test候補

### Identity／Distribution

- Join EventのDB処理がMain ThreadをBlockしない
- RecordなしPlayerへ非同期照会完了後に1本だけ発行
- 既存PlayerにもRecordなしなら発行
- 同時処理で重複Recordを作らない
- DB処理中にLogoutした場合はItemを付与せず次回Joinへ持ち越す
- Inventory FullでDropしない
- Inventory Full時にPlayer Chatへ運営連絡案内を表示する
- Inventory Full時にServer ConsoleへPlayer／Tool識別情報付きWARNを出す
- Pending Deliveryを次回JoinまたはAdmin操作で再試行できる
- Recordありで自動Reissueしない
- Epoch不一致Itemを拒否

### Progress

- Resource三次元で加算
- Main三次元で非加算
- Pickaxe Tag対象だけ加算
- Cobblestone Generatorで加算
- Player設置Oreで加算
- Creative／Spectator非加算
- Cancel Event非加算
- Broken非加算

### Evolution

- Wood→Stone→Iron→Diamond
- Diamond後に5Step Cycle
- 最初のFortune StepでFortune I
- Efficiency X／Unbreaking X／Fortune V Clamp
- Cap超過後もProgressとEvolution Count増加
- Config変更で完全再計算
- Runtime再計算で再帰計算を行わない
- 累計Progressと累積Thresholdの比較でEvolution Countを導出する
- 必要量増加時に降格
- Progress増加によるGameplay Evolution時だけ最大回復
- Config Reconcile時はEvolution Countが上昇しても修理しない
- Material変更を伴うConfig Reconcileでは消費済み耐久率を維持する
- ACTIVE Toolの換算後残存耐久値は最低1となる

### Branch

- Default Fortune
- AdminでSilk Touchへ変更
- Silk中にFortune Stepが進む
- Fortune効果はSilk中に非適用
- Fortuneへ戻すとConceptual Fortuneを再適用

### Broken／Repair

- 耐久0でGRAY_DYEへ変換
- Item消滅なし
- BrokenからGUI起動
- Broken中Progressなし
- ACTIVE Full Repair
- BROKEN復旧
- 二重請求なし
- DB失敗時Refund／Reconcile
- Evolution Countに応じた価格

### GUI

- Main Hand空中右Clickだけで開く
- Block／Entity対象時に開かない
- Off Handで開かない
- 詳細Progress表示
- Repair確認画面
- Duplicate Click耐性


### Deferred／Future Invariant

Netherite UpgradeはV0.1.0初期実装Scope外である。将来機能を実装した時点で、次をAcceptanceへ追加する。

- Netherite Upgrade済みToolがIron以下へ降格してもUpgrade履歴を保持する。
- Upgrade履歴保持Toolが再びDiamond条件へ到達すると、WM再請求なしでNetheriteへ復帰する。
- Upgrade Transactionが二重請求されない。
- DB更新失敗時にRefundまたはReconcileできる。

### Performance

- Main Thread DB I/Oなし
- 高速採掘でTPS／MSPT異常なし
- Config再計算がEvent Loopを阻害しない
- Join StormでDB Pool枯渇なし
- Shutdown Flush完了

---

## 28. 未決事項

Growth Toolの主要Gameplay方針に、Concept作成を阻害する重大な未決事項はない。

v0.0.xで調整する項目:

- Exact Block Weight
- Exact Threshold係数
- Repair価格
- GUI Layout
- Item Name／Lore表現
- Pending Delivery UI
- Netherite Upgradeの初期価格・GUI・実装時期
- Admin Command正式Syntax
- Audit詳細
- Database DDL
- Permission Node
- External Repair遮断の対応Plugin一覧

---

## 29. Concept境界

本ConceptはGrowth ToolのPlayer体験、Progression、永続性、修理、GUI入口および安全要件を定義する。

次はConcept確認後にPlugin Repositoryへ置く実装作業指示書兼設計仕様書で定義する。

- Physical Item Instance ID
- Duplicate Item検出
- MariaDB DDL
- Damage値の正確な保存形式
- Crash Reconcile
- Threshold CacheのClass／同期／上限実装
  （遅延拡張・二分探索・Overflow時Fail-closedというConcept要件は本書で確定）
- Executor／Checkpoint
- Class／Interface
- Exact Command／Permission
- GUI Slot
- Config Schema完全版
- Unit／Integration Test

実装仕様は、本Conceptで確定したGameplay結果を変更してはならない。

---

## 30. Revision History

| Version | 概要 |
|---|---|
| v0.0.1 | Growth Pickaxe、Owner Bind、Resource採掘Progress、DB正本の初期案 |
| v0.0.2 | 完全再計算、非同期Join照会、Pending Delivery、進化時全回復を追加 |
| v0.0.3 | 再計算時残存耐久最低1、Netherite Upgrade履歴と自動復帰を追加 |
| v0.0.4 | Concept体系へ統合し、親文書表記、Threshold境界、Concept／実装仕様書境界を整理 |
| v0.0.5 | V0.1.0正式Scope、Tool／Delivery状態分離、Threshold遅延拡張、Custom Lore、将来Acceptance分離を反映 |
