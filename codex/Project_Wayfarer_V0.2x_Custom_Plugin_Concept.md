# Project Wayfarer V0.2.x以降 独自Plugin構想草案

> **状態：構想草案／実装未着手**
>
> 本文書は、Project WayfarerのV0.2.x以降で検討する独自Pluginの機能境界と、Main向け「成長する専用Tool」の初期案を保存するための参考文書です。
>
> V0.1.0 Alphaの実装対象、Release Blocker、確定仕様、開発開始承認、Database Migration承認またはArtifact配布承認ではありません。
>
> 実装時には、最新Runtime Version、Paper API、経済Balance、運用実績および別途承認された正式設計を基に再設計します。

---

## 1. 目的

Project Wayfarerで将来必要になる独自機能を、Server固有責務とNetwork共通責務に分離して開発可能にする。

主な目的：

- 既成Pluginでは表現しにくいProject固有機能を実装する
- Main／Frontier間の共有機能を一箇所へ集約する
- Lobby／Main／Frontier固有機能を分離する
- Database、Item Identity、Audit、Migration等の共通基盤を再利用する
- Plugin間の循環依存を避ける
- Minecraft／Paper Version差を局所化する
- V0.1.0のVanilla寄り体験を維持しつつ、V0.2.x以降に長期Progressionを追加する

---

## 2. 想定Plugin構成

製品／機能区分：

```text
Wayfarer_Core Plugin
Wayfarer_Lobby Plugin
Wayfarer_Main Plugin
Wayfarer_Frontier Plugin
```

### Wayfarer_Core

2つ以上のServerに関係する機能を担当する。

主な候補：

- Network共通Database接続
- Schema Migration
- Redis Cache／PubSub
- Waymark Service Adapter
- 共通Player Identity
- 共通Item Identity
- Network共通Audit
- Cross-server Message
- Theme Achievement共通部分
- Main側Achievement Reward受取
- Server間Lock
- Transaction ID
- 共通Command／Permission Contract

### Wayfarer_Lobby

Lobby固有機能を担当する。

候補：

- 初回案内
- Server選択GUI
- Lobby専用NPC
- Maintenance表示
- Lobby Tutorial
- Hub案内
- Lobby内Interaction
- 接続先状態表示

### Wayfarer_Main

Main固有機能を担当する。

候補：

- 成長する専用Tool
- Tool修理／復旧／再発行GUI
- Main固有Custom Item
- Waymark Sink
- Main Teleport／Waypoint
- Main Utility
- Main Hub設備
- Main固有Progression

本書の成長Tool案は`Wayfarer_Main`へ実装する想定とする。

### Wayfarer_Frontier

Frontier固有機能を担当する。

候補：

- Theme選択
- Theme入口／退出
- Theme別進行
- Theme別Inventory
- 初回Loadout
- Frontier Achievement
- Frontier Gate Utility
- Theme固有Item
- Theme別Reward
- Theme Lifecycle

---

## 3. Source／Build構成案

1つのGradle Multi-module Repositoryを想定する。

```text
wayfarer-plugins/
├─ settings.gradle.kts
├─ build.gradle.kts
├─ build-logic/
├─ wayfarer-common/
├─ wayfarer-core/
├─ wayfarer-lobby/
├─ wayfarer-main/
└─ wayfarer-frontier/
```

### `wayfarer-common`

Runtime Pluginではなく内部Libraryとする。

候補：

- Config Loader
- Adventure Component／Message
- PDC Utility
- UUID／ID Utility
- Database Utility
- Migration Framework
- Transaction Utility
- Scheduler Wrapper
- Audit Model
- Exception Model
- Test Fixture
- Serialization

単なる共通Codeをすべて`Wayfarer_Core`のRuntime責務へ入れない。

### 依存方向

```text
Wayfarer_Lobby    ─┐
Wayfarer_Main     ─┼─> Wayfarer_Core
Wayfarer_Frontier ─┘

Wayfarer_Core ─X─> Server固有Plugin
```

禁止：

- CoreからMain／Lobby／Frontierへの依存
- MainとFrontierの相互依存
- Plugin間の循環依存
- CoreへServer固有GUIやGameplay Logicを混在
- NMS依存を共通層へ配置

---

## 4. Platform差への対応

現行想定：

- Lobby：Paper 26.2
- Main：Paper 26.2
- Frontier：Paper 1.21.11
- Java：25

CoreのPaper共通機能は、Frontierを含む最低共通APIで動作させる。

Version固有処理が必要な場合：

```text
wayfarer-core-api
wayfarer-core-paper-modern
wayfarer-core-paper-legacy
wayfarer-core-velocity
```

のようなAdapter分離を検討する。

機能区分としての`Wayfarer_Core`を維持しつつ、Platform別Artifactを作成してよい。

NMSは原則使用しない。

使用が避けられない場合：

- Version Adapterへ隔離
- 明示的な対応Matrix
- Integration Test
- Fail-fast
- Unsupported Version拒否

---

## 5. Data Ownership

### MariaDB

永続的な正本として使用する候補：

- Tool Identity
- Tool Progress
- Evolution Rank
- Broken状態
- Reward発行
- Reward消費
- Repair Transaction
- Reissue Epoch
- Achievement
- Audit
- Schema Version

既存`wayfarer_network` Databaseを使用するか、独自Plugin専用Databaseを作成するかは実装設計で決定する。

### Redis

補助用途に限定する。

候補：

- Cache
- Pub/Sub
- Distributed Lock
- Temporary Session
- Invalidation
- Server間通知

Redisだけを永続的なTool進行の正本にしない。

### External systems

- Waymark：Vault API経由でRedisEconomyを利用
- LuckPerms：正式APIまたはPermission Check
- mcMMO：直接Database操作しない
- CoreProtect：必要な場合のみ正式API／Queryを検討

他PluginのDatabase Tableを直接更新しない。

---

# 6. 成長する専用Tool構想

## 6.1 基本思想

Mainでは、バニラToolを使い続ける選択肢を残す。

専用Toolは強制ではなく、長期ProgressionとWaymark消費Loopを選択したPlayer向けの追加要素とする。

対象Tool：

```text
Pickaxe
Axe
Shovel
```

バニラTool：

- 通常Craft
- 通常Enchant
- 通常Mending
- 通常修理
- 通常消滅

専用Tool：

- Owner Bind
- 採掘Progress
- Evolution
- Over-enchant候補
- Broken状態
- WM修理
- 再発行
- 死亡時保持

---

## 6.2 Tool Identity

ItemStack自体ではなく、Database上の論理Toolを正本とする。

Playerごとに原則3系統：

```text
PICKAXE
AXE
SHOVEL
```

候補Field：

```text
tool_id
owner_uuid
tool_type
instance_epoch
evolution_rank
effective_enchantment_level
durability
max_durability
broken
created_at
updated_at
schema_version
optimistic_lock_version
```

ItemStackにはPersistentDataContainerで最低限を格納する。

```text
wayfarer:item_type
wayfarer:tool_id
wayfarer:owner_uuid
wayfarer:tool_type
wayfarer:instance_epoch
wayfarer:schema_version
```

Item LoreだけをIdentityに使用しない。

---

## 6.3 Instance Epoch

再発行時に`instance_epoch`を増加させる。

例：

```text
旧Tool epoch = 4
再発行後 epoch = 5
```

Epoch 4のItemが後から見つかっても無効とする。

目的：

- 紛失Toolと再発行Toolの二重存在防止
- Item複製への耐性
- 古いBackup／Inventoryから戻ったItemの失効
- Reissue履歴監査

失効Item検出時の候補：

- 使用拒否
- 赤いLoreを付与
- 安全な回収
- GUIで状態表示
- Admin Audit通知

---

## 6.4 採掘Progress

専用Toolを使って対象Blockを破壊するとProgressを加算する。

基本条件候補：

- `BlockBreakEvent`がCancelされていない
- Survival Mode
- Main Backend
- 有効なOwner Tool
- Tool種別に適したBlock
- Brokenではない
- Epochが最新
- Owner本人が使用

Creative、Spectator、管理操作、PluginによるBlock削除は対象外。

### Weight

単純なBlock数だけでなく、BlockごとのWeightをConfig化可能にする。

例：

```yaml
progress:
  pickaxe:
    STONE: 1
    DEEPSLATE: 1
    COAL_ORE: 2
    IRON_ORE: 3
    DIAMOND_ORE: 10

  axe:
    OAK_LOG: 1
    SPRUCE_LOG: 1
    MANGROVE_LOG: 1

  shovel:
    DIRT: 1
    SAND: 1
    GRAVEL: 1
    CLAY: 2
```

実際のWeightはEconomy／Playtest後に決定する。

---

## 6.5 設置Block／自動生成対策

未決事項：

- Player設置Blockの再破壊をCountするか
- Cobblestone Generatorを許容するか
- Tree Farmを許容するか
- TNT／Piston等で露出したBlockをCountするか
- Silk Touchで再設置したOreをCountするか
- Resource WorldとPersistent Mainの両方でCountするか

無限Loop対策候補：

1. Player設置Blockを対象外
2. 一定Blockだけ対象外
3. Weightを極端に低くする
4. Daily Diminishing Return
5. Chunk／Location単位Cooldown
6. CoreProtect等による設置履歴参照
7. Resource Worldだけ高Weight
8. Natural Block判定Cache

CoreProtectを毎Block同期照会すると負荷が高くなるため、採用する場合はCache／Batch／非同期設計が必要。

V0.2.x実装時に別途決定する。

---

## 6.6 RAM管理とCheckpoint

通常のProgress加算はRAMで行う。

ユーザー初期案：

- 約1時間ごと
- Server停止時
- 次回起動時に読込

ただしCrash時の最大1時間消失を避けるため、初期推奨は次とする。

- 5～10分ごとの非同期Checkpoint
- Player Quit時
- Plugin Disable時
- 正常Server停止時
- Evolution Threshold到達時は即時
- Repair／Reissue等の重要操作時は即時

1時間間隔はConfig化できるが、Defaultには推奨しない。

Main ThreadでDatabase I/Oを実行しない。

---

## 6.7 Evolution Reward

一定Progress到達時に、そのToolだけへ使用可能な進化Itemを獲得する。

例：

```text
旅人のピッケル進化核
旅人のアックス進化核
旅人のシャベル進化核
```

PDC候補：

```text
owner_uuid
target_tool_id
target_tool_type
reward_id
reward_sequence
schema_version
```

制約：

- Owner以外使用不可
- 対象Tool Type以外へ使用不可
- 対象`tool_id`以外へ使用不可
- 使用済みReward IDは再利用不可
- 古いEpochへの使用不可
- Broken Toolへの使用可否は仕様で決定

---

## 6.8 進化操作

初期案：

```text
Main Hand：進化Item
Off Hand：対応Tool
右クリック
```

処理候補：

1. Player単位Lock
2. Item PDC検証
3. Owner確認
4. Tool ID確認
5. Epoch確認
6. Broken状態確認
7. Reward未使用確認
8. Database Transaction
9. Evolution Rank更新
10. Reward消費
11. ItemStack再生成
12. Audit記録
13. User通知

二重右クリック、Packet重複、Inventory Event重複、Lag時再送で二重進化しない設計とする。

---

## 6.9 Evolution RankとEnchant Level

最大100 Levelは初期アイデアであり、確定しない。

Efficiency等の実Enchant Level 100は、採掘速度・Server負荷・Economy Balanceへ極端な影響を与える可能性がある。

推奨案：

```text
Evolution Rank：0～100
Effective Enchantment Level：Config Tableで段階的に上昇
```

例：

| Evolution Rank | Efficiency |
|---:|---:|
| 0 | 5 |
| 5 | 6 |
| 10 | 7 |
| 20 | 8 |
| 35 | 9 |
| 50 | 10 |
| 70 | 11 |
| 100 | 12 |

これにより、100段階のProgressionと実際の性能上限を分離できる。

別案：

- Evolution Rank 0～20
- Enchant Level 5～15
- Rankごとに耐久・修理費・Cosmeticも成長

最終値は負荷試験とEconomy設計後に決定する。

---

## 6.10 成長対象Enchant

初期MVPではEfficiencyだけを候補とする。

慎重に扱うもの：

- Fortune
- Silk Touch
- Unbreaking
- Mending

FortuneのOver-enchantはResource供給量とWaymark Economyへ大きく影響する。

Silk TouchとFortuneの排他関係も必要。

候補方針：

- Efficiency：Evolutionで成長
- Unbreaking：固定または段階成長
- Fortune／Silk Touch：別Branchまたは固定選択
- Mending：禁止
- Curse：使用しない

---

## 6.11 耐久0とBroken Tool

専用Toolは耐久0で消滅させない。

破壊到達時：

1. 通常破壊をIntercept
2. Item消滅を防止
3. 同一`tool_id`のBroken Itemへ変換
4. `broken=true`
5. `durability=0`
6. 即時永続化
7. Audit記録

表示例：

```text
壊れた旅人のピッケル
修理設備または専用GUIで復旧できます
```

Broken Toolが維持するもの：

- Owner
- Tool ID
- Tool Type
- Epoch
- Evolution Rank
- Enchant情報
- Cosmetic
- Progress

Broken状態で禁止する候補：

- Block破壊
- Entity攻撃
- Strip
- Path作成
- Flatten
- Anvil
- Grindstone
- Crafting修理
- Smithing
- mcMMO Repair
- mcMMO Salvage
- 他Plugin Repair

---

## 6.12 WM修理／復旧

Main Spawn付近の専用設備またはCommandからGUIを開く。

候補：

```text
/wayfarer tool
/wayfarer tool repair
```

GUI例：

```text
[Pickaxe]
状態：破損
Evolution Rank：32
Efficiency：8
耐久：0 / 2031

[25%修理]
[50%修理]
[完全修理]
[破損から復旧]
[再発行]
[未受取進化Item]
```

価格式候補：

```text
修理費 =
基本料金
+ 欠損耐久率 × 可変料金
+ Evolution Rank倍率
+ Broken復旧追加料金
```

価格はConfig化する。

WaymarkはVault API経由で操作し、RedisEconomy Databaseを直接変更しない。

---

## 6.13 WMとMariaDBの整合性

WM引落しとMariaDB更新は単一ACID Transactionにできない。

補償Transactionが必要。

候補Flow：

1. Tool Lock
2. Transaction ID発行
3. WM残高確認
4. WM引落し
5. MariaDB Tool更新
6. 成功記録
7. DB失敗時WM Refund
8. Refund結果記録
9. User通知
10. Admin Audit

必要要件：

- Idempotency Key
- 二重請求防止
- 二重Refund防止
- Unknown状態の検出
- Manual Reconcile Command
- Audit Log

---

## 6.14 別修理経路の遮断

WM修理を成立させるには専用Toolの迂回修理を防ぐ。

禁止候補：

- Mending
- XP修理
- Anvil素材修理
- 同種Tool合成
- Crafting Grid修理
- Grindstone
- Smithing
- mcMMO Repair
- Salvage
- 他Plugin Repair Command
- Item編集Plugin

バニラToolは従来どおり自由に修理可能。

専用ToolだけPlugin管理とする。

---

## 6.15 Soulbind

最低要件：

- 死亡時にDropしない
- Respawn後に保持
- Inventory Fullでも消失しない
- Owner以外使用不可

完全Owner Bind候補：

- 手動Drop拒否
- Chest投入拒否
- Barrel投入拒否
- Hopper移送拒否
- Bundle／Container Item格納拒否
- Item Frame拒否
- Armor Stand拒否
- 他Player Pickup拒否
- Trade拒否
- Anvil等GUI投入拒否

死亡時保持だけにするか、完全譲渡禁止にするかは正式設計で決定する。

初期推奨は完全Owner Bind。

---

## 6.16 再発行

Tool紛失時にGUIから再発行できる。

再発行で維持するもの：

- Evolution Rank
- Progress
- Broken状態
- Durability
- Enchant
- Cosmetic
- Owner
- Tool ID

変更するもの：

```text
instance_epoch += 1
```

重要：

- Broken Toolを紛失してもBroken状態で再発行
- 再発行を無料修理にしない
- 旧Epoch Itemは失効
- 旧Item発見時も2本運用できない

料金候補：

- 無料＋長Cooldown
- 少額WM
- 初回無料
- 回数増加料金
- Broken状態に応じた追加料金

---

## 6.17 未受取Reward

Inventory Fullや危険地点で進化Itemを直接Dropしない。

MariaDBへPending Rewardとして保存する。

GUI表示例：

```text
未受取の進化Item：3
```

受取処理：

- Inventory容量確認
- Reward ID Lock
- Item付与
- 付与成功後に`issued=true`
- 失敗時はPending維持

地面Dropは原則行わない。

---

## 6.18 初回配布

候補：

- Main初回Join
- Main Hub GUI
- Quest
- WM購入
- Admin配布
- 各Toolを段階Unlock

バニラTool選択を残すため、自動強制配布よりGUIで任意受取が適切。

初回受取状態をDatabaseへ保存する。

---

## 7. Database草案

候補Table：

```text
wf_main_tool
wf_main_tool_progress
wf_main_tool_reward
wf_main_tool_transaction
wf_main_tool_reissue
wf_main_tool_audit
wf_schema_history
```

### `wf_main_tool`

```text
tool_id
owner_uuid
tool_type
instance_epoch
evolution_rank
effective_enchantment_level
durability
max_durability
broken
created_at
updated_at
lock_version
```

### `wf_main_tool_progress`

```text
tool_id
eligible_break_count
weighted_progress
next_threshold
last_checkpoint_at
updated_at
```

### `wf_main_tool_reward`

```text
reward_id
tool_id
sequence
reward_type
pending
issued
consumed
created_at
issued_at
consumed_at
```

### `wf_main_tool_transaction`

```text
transaction_id
owner_uuid
tool_id
transaction_type
wm_amount
state
created_at
updated_at
failure_code
```

### `wf_main_tool_audit`

```text
audit_id
owner_uuid
tool_id
event_type
server_id
world_id
details_json
created_at
```

UUIDを文字列にするかBinaryにするか、JSON利用、Index、Foreign Key等は正式設計で決定する。

---

## 8. Concurrency／Crash Safety

必要要件：

- Player単位Lock
- Tool単位Lock
- Optimistic Lock
- Reward Sequence Unique制約
- Transaction ID Unique制約
- Epoch検証
- Idempotent Command
- Plugin Disable Flush
- Async DB
- Main Thread Item操作
- Timeout
- Retry上限
- Fail-closed
- Audit

Crash想定：

- Progress RAM未保存
- Reward発行前Crash
- Reward発行後DB更新前Crash
- WM引落し後DB失敗
- Reissue中Crash
- Player Disconnect
- Server Stop
- Database Outage
- Redis Outage

重要操作では即時永続化し、復旧可能な状態機械を持つ。

---

## 9. Permission草案

一般Player候補：

```text
wayfarer.main.tool.use
wayfarer.main.tool.gui
wayfarer.main.tool.repair
wayfarer.main.tool.reissue
wayfarer.main.tool.reward.claim
```

Admin候補：

```text
wayfarer.main.tool.admin.inspect
wayfarer.main.tool.admin.reconcile
wayfarer.main.tool.admin.reissue
wayfarer.main.tool.admin.reset
wayfarer.main.tool.admin.audit
wayfarer.main.tool.admin.reload
```

BuilderへTool管理権限は原則付与しない。

Permission名は正式実装時に確定する。

---

## 10. GUI／Main Spawn保護との関係

Tool GUI設備をMain Spawn Hubへ置く場合、WorldGuardのMain Spawn保護内でInteractionだけを許可する必要がある。

想定子Region：

```text
main_spawn_tool_station
```

方針：

- 外側`main_spawn_hub`は一般Player建築不可
- 公開Door／Button等は`use allow`
- Tool設備だけ小Regionで必要な`interact allow`
- Container公開が必要な場合だけ`chest-access allow`
- 建築保護を迂回しない
- Exact設備範囲だけを許可

このRegionはV0.1.0のMain Spawn保護タスクで先に設計可能だが、Tool Plugin自体はV0.2.xまで導入しない。

---

## 11. Configuration草案

```yaml
tools:
  enabled: true

  types:
    pickaxe:
      enabled: true
      base-material: NETHERITE_PICKAXE
      max-evolution-rank: 100

    axe:
      enabled: true
      base-material: NETHERITE_AXE
      max-evolution-rank: 100

    shovel:
      enabled: true
      base-material: NETHERITE_SHOVEL
      max-evolution-rank: 100

progress:
  checkpoint-seconds: 600
  count-persistent-main: true
  count-resource-worlds: true
  count-player-placed-blocks: false

evolution:
  reward-as-pending-on-full-inventory: true
  allow-while-broken: false

repair:
  currency: vault
  broken-recovery-extra-cost: 10.0

reissue:
  cooldown-seconds: 86400
  cost: 5.0

soulbind:
  keep-on-death: true
  prevent-drop: true
  prevent-storage: true
  prevent-other-player-use: true
```

値は全て草案であり確定しない。

---

## 12. MVP候補

### MVP 1

- Pickaxeだけ
- Main限定
- Owner Bind
- Block Progress
- Pending Evolution Reward
- Efficiency段階成長
- Broken状態
- GUI完全修理
- WM引落し
- Reissue Epoch
- MariaDB
- Audit

### MVP 2

- Axe／Shovel追加
- Weight設定
- Partial Repair
- 詳細GUI
- Admin Inspect
- Reconcile

### 将来

- Branch Evolution
- Fortune／Silk選択
- Cosmetic Model
- Particle
- Achievement
- Tool Name Customization
- Resource Pack
- Cross-server表示
- Web／Discord Audit

---

## 13. 未決事項

実装開始前に決定する。

1. Evolution Rank上限
2. 実Efficiency上限
3. RankとEnchantを分離するか
4. Tool初期Material
5. 進化Threshold
6. Block Weight
7. Player設置Block
8. Generator Farm
9. Persistent Main／Resource双方で成長するか
10. Fortune／Silk Touch
11. Unbreaking
12. Mending禁止
13. Broken Toolの攻撃利用
14. 完全Owner Bind
15. 初回配布
16. Reissue料金
17. Reissue Cooldown
18. 修理価格式
19. Partial Repair
20. Pending Reward中心か物理Item中心か
21. MariaDB Database
22. Redis Lock
23. CoreProtect連携
24. mcMMOとの二重Progressionの許容
25. Paper Version互換
26. Resource Pack
27. Tool名／Lore
28. Migration／Rollback
29. Backup対象
30. Data Retention

---

## 14. V0.1.0との関係

本構想はV0.1.0へ含めない。

V0.1.0で優先するもの：

- EvenMoreFish
- CoreProtect
- Playable Frontier Theme
- Advanced Portals
- Builder Phase 1B
- Hub／Gate
- Portal Routing
- Resource Bootstrap
- Integrated Operations
- Cold Backup
- Isolated Restore
- Baseline Release

成長ToolがV0.1.0へ入らない理由：

- Vanilla寄りMainのBaselineを先に確立する
- Waymark供給量の実測が必要
- mcMMOとのProgression Balance観測が必要
- Repair価格設計に運用Dataが必要
- Custom Plugin Build／Release／Migration基盤が未整備
- Persistent DataとEconomy Transactionの詳細検証が必要
- V0.1.0 Release Blockerを増やさない

---

## 15. 再検討条件

次を満たした後に正式設計へ進む候補とする。

- V0.1.0 Alpha完成
- Baseline Backup／Restore成功
- Main運用Data取得
- Waymark供給／消費量観測
- mcMMO Progression観測
- Main Spawn Hub整備
- CoreProtect導入
- Custom Plugin Repository方針承認
- Paper対応Version決定
- Database Ownership決定
- Test Environment準備

正式設計時には、本草案をそのまま実装せず、最新要件との差分を作成する。

---

## 16. 文書の優先順位

本書は`codex/`に保存する構想草案である。

現行仕様の優先順位：

1. `AGENTS.md`
2. `docs/00-design-guide.md`
3. 対象分野の正式文書
4. `versions.yml`
5. `plugin-manifest.yml`
6. `docs/06-acceptance-tests.md`
7. `docs/09-roadmap.md`
8. 本草案

将来、正式なV0.2.x設計文書が`docs/`へ追加された場合、本草案より正式文書を優先する。
