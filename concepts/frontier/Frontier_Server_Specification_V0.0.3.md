# Project Wayfarer — Frontierサーバ仕様書 V0.0.3

> **状態：設計仕様／実装前**
>
> 本文書は、Project WayfarerのFrontier Backendに複数のThemeを収容するための共通仕様を定義する。
> Theme固有仕様は、次の文書を正とする。
>
> - [Worlds Beyond仕様書 V0.0.3](./Worlds_Beyond_Specification_V0.0.3.md)
> - [Ruined Frontier仕様書 V0.0.3](./Ruined_Frontier_Specification_V0.0.3.md)
>
> 本文書のVersionは設計文書の改訂番号であり、稼働ServerのRelease番号ではない。

---

## 1. 目的

Frontierは、恒久生活拠点であるMainとは異なるルール、World Generation、Progressionおよび移動体験を提供するAdventure Backendである。

V0.0.3では、次の2 Themeを正式な設計対象とする。

| Theme | 中核体験 | 主な技術 |
|---|---|---|
| **Worlds Beyond** | 景観、立体移動、発見、期限付き交通網、プレイヤーによる開拓史 | Iris、LeafGrapple、Wayfarer_Frontier |
| **Ruined Frontier** | 危険な遺跡探索、Boss、Custom Loot、Quest、EliteMobs Progression | BetterStructures、EliteMobs、Primis、Adventurer's Guild |

Frontier共通原則：

1. Mainの通常InventoryとFrontierの通常Inventoryを分離する。
2. Frontier内でもThemeごとにInventory Groupを分離する。
3. MainとFrontier間で移送または換価可能なTheme固有Item、装備、素材およびQuest報酬は、初期段階では共有通貨Waymark（WM）に限定する。
4. mcMMO進行はTheme固有成果ではなくNetwork共通Progressionとして別枠で共有し、Ruined FrontierではGameplay効果も有効とする。
5. Theme固有Item、装備、Quest Item、素材は別ThemeおよびMainへ漏出させない。
6. Player向け名称 **Frontier Lobby**（技術World ID：`frontier_gate`）は中立Hubとし、どのThemeの装備も常駐させない。
7. ThemeのPlugin、WorldおよびContentは明示的Allowlistで隔離し、未知のWorldを自動有効化しない。
8. World IDおよびInventory Group割当の正本は`Wayfarer_Frontier`のTheme Registryとし、各Theme文書や外部Plugin Configはこれを参照・検証する。
9. 既製Pluginで代替できないTheme固有機能は、`Wayfarer_Frontier` Pluginへ実装する。

---

## 2. Theme名称

### 2.1 Worlds Beyond

Irisによる未知の地形、HookとElytraによる移動、プレイヤーが残す一時的な交通設備を主題とするため、**Worlds Beyond**を正式名称とする。

### 2.2 Ruined Frontier

BetterStructuresの大型遺跡、失われた文明、Elite Shrine、DungeonおよびEliteMobsの危険な辺境という構成を最も直接的に表現するため、**Ruined Frontier**を正式名称とする。

Adventurer's GuildおよびPrimisを含むTheme全体の入口名としても矛盾せず、Main側のVanilla寄りBetterStructuresとの差別化も明確である。

---

## 3. 論理導線

```text
Wayfarer Lobby
├─ Main
└─ Frontier Lobby（技術World ID: frontier_gate）
   ├─ Worlds Beyond
   │  ├─ Worlds Beyond Overworld
   │  ├─ Worlds Beyond Nether
   │  └─ Worlds Beyond End
   │
   └─ Adventurer's Guild
      ├─ Ruined Frontier Overworld
      │  ├─ Nether Portal → Ruined Frontier Nether
      │  └─ End Portal    → Ruined Frontier End
      ├─ Primis Adventure
      │  └─ Primis付属Dungeon／Instance
      └─ 将来のEliteMobs Dungeon／Adventure
```

名称およびWorld ID：

| Player向け名称 | 技術World ID／論理ID |
|---|---|
| Frontier Lobby | `frontier_gate` |
| Worlds Beyond | Theme RegistryのWorld Family定義 |
| Adventurer's Guild | `adventurers_guild`（導入Artifact確認後にLock） |
| Ruined Frontier | `frontier_bs`／`frontier_bs_nether`／`frontier_bs_the_end` |

共通導線要件：

- Frontier Lobbyから各Themeの安全な入口へ移動できる。
- 各ThemeからFrontier Lobbyへ確実に帰還できる。
- Ruined Frontier Nether／Endへの通常導線は、Overworld内のVanilla Portalを基本とする。
- Frontier LobbyからRuined Frontier Nether／Endへ直接Gateを設けない。
- Theme間の直接移動は行わず、Frontier LobbyまたはAdventurer's Guildを経由する。
- Portal、Gateおよび到着地点は、Inventory切替完了後にPlayerを出現させる。

---

## 4. Runtime前提

V0.0.3作成時点のProject基準：

| Component | Baseline |
|---|---|
| Frontier Backend | Paper 1.21.11 |
| Java | 25 |
| Proxy | Velocity |
| Frontier Entry World | `frontier_gate` |
| Shared Permission | LuckPerms |
| Shared Economy | RedisEconomy + VaultUnlocked |
| Shared Currency | Waymark（WM） |
| Shared Progression | mcMMO |
| World Administration | Multiverse-Core、Multiverse-NetherPortals、WorldEdit、WorldGuard |
| Block Audit | CoreProtect導入対象 |
| Custom Plugin | Wayfarer_Core、Wayfarer_Frontier |

PluginおよびContentの正式Versionは、導入タスクで固定し、配布元、License、Version、SHA-256、依存関係および受入試験結果を記録する。

---

## 5. WorldおよびInventory Group

### 5.1 Neutral Group

対象：

```text
frontier_gate
```

方針：

- Navigation用Item以外を保持しない。
- Worlds BeyondおよびRuined FrontierのItemを持ち込ませない。
- Ender Chest、XP、Health、FoodをTheme Groupと共有しない。
- Gate移動中の二重Inventory切替を防止する。
- Inventory切替失敗時はThemeへ入場させず、Neutral GroupへFail-closedする。

### 5.2 Worlds Beyond Group

論理対象：

```text
Worlds Beyond Overworld
Worlds Beyond Nether
Worlds Beyond End
```

共有対象：

- Inventory、Armor、Offhand
- Ender Chest
- Vanilla XP／Level
- Health／Food
- Worlds Beyond固有Item
- Elytra、Grappling Hook、Launchpad
- 発見済みWaystone情報はDB管理

Ruined Frontier Groupとは共有しない。

### 5.3 Ruined Frontier / Guild Group

固定対象および許可済み動的Instanceを含む。World IDとGroup割当の正本はTheme Registryとする。

対象：

```text
Adventurer's Guild
Ruined Frontier Overworld
Ruined Frontier Nether
Ruined Frontier End
Primis
Primis付属Dungeon／Instance
Guild配下のEliteMobs Dungeon
```

共有対象：

- Inventory、Armor、Offhand
- Ender Chest
- Vanilla XP／Level
- Health／Food
- EliteMobs装備
- EliteMobs通貨およびProgression
- Quest Item
- PrimisおよびDungeonで取得したItem

Worlds Beyond Groupとは共有しない。

### 5.4 共有されるNetwork Data

| Data | Main | Frontier Lobby | Worlds Beyond | Ruined Frontier |
|---|---|---|---|---|
| 通常Inventory | Main Local | Neutral | WB Group | Guild Group |
| Ender Chest | Main Local | Neutral | WB Group | Guild Group |
| Vanilla XP／Health／Food | Main Local | Neutral | WB Group | Guild Group |
| Waymark | 共有 | 表示のみ可 | 共有 | 共有 |
| mcMMO | Network共有 | 原則使用なし | Network共有 | Network共有・Gameplay効果有効 |
| Theme固有Item | 不可 | 不可 | WB限定 | Guild限定 |
| EliteMobs Progression | 不可 | 不可 | 無効 | Guild限定 |
| Waystone発見履歴 | 不可 | 不可 | DB共有 | 不可 |

---

## 6. Inventory切替要件

Theme別Inventoryは`Wayfarer_Frontier`が担当する。

必要要件：

1. World／Theme境界をTheme Registryの明示的Allowlistで定義する。
2. Player UUIDごとにGroup別Stateを永続化する。
3. Inventory、Armor、Offhand、Ender Chest、XP、Health、Foodを原子的に近い手順で保存・復元する。
4. `PlayerTeleportEvent`、`PlayerPortalEvent`、`PlayerRespawnEvent`、`PlayerChangedWorldEvent`、`PlayerJoinEvent`、`PlayerQuitEvent`、Server StopおよびInstance強制退出を境界検査対象とする。
5. Bed、Respawn Anchor、End Exit、Void死亡、`/kill`、EliteMobs Dungeon Teleport、Primis Package Portal、Multiverse Teleport、Admin Teleportおよび再接続でGroup境界を迂回させない。
6. 同一Playerの並行切替をLockし、Inventory切替完了前にTeleport／Portal／Respawnを成立させない。
7. 保存失敗時に移動を中止する。
8. 復元失敗時にNeutral Groupへ隔離し、Admin Auditへ記録する。
9. Item Identity検証を行い、Theme外Itemを除去または隔離する。
10. 旧Backupや複製ItemによるTheme境界突破を検出できる拡張余地を持つ。
11. 動的Instanceは許可済みContent Package IDと生成Eventまたは確実な検出手段に基づき、Inventory／Theme境界へ一時登録する。World名Prefixだけでは承認しない。
12. Instanceの生成、有効化、Dungeon Gameplay、Package固有Respawn、終了およびWorld削除はEliteMobsのContent Package Lifecycleを正とする。
13. `Wayfarer_Frontier`はInstance終了通知または確実な検出に応じ、Player退避、Inventory保存、Group登録解除および未完了Transitionの回復を担当する。EliteMobsの内部Config、DatabaseまたはContent Package Fileを直接変更しない。

MariaDBを正本とし、必要に応じてRedisをLock／Cacheに使用する。RedisだけをInventoryの永続正本にしない。

権限境界：

一般Playerへ次のEliteMobs Teleport権限を明示的に拒否する。

```text
elitemobs.adventurersguild.teleport
elitemobs.dungeon.tp
elitemobs.teleport.spawn
```

- `elitemobs.user`等のBundle Permissionを付与する場合でも、上記NodeをLuckPermsで個別に`false`とする。
- Guild、PrimisおよびDungeonへの通常導線は、Guild内NPC、PortalまたはWayfarer管理Gateを使用する。
- Permission拒否だけをInventory境界の安全性根拠にせず、`/em quit`、Package固有退出、死亡Respawnおよび強制TeleportもEvent側でGroup境界を検査する。
- `/mv tp`その他の管理Teleport権限を一般Playerへ付与しない。
- Admin TeleportでもInventory Group境界検査を迂回しない。
- 通常運用でOPを使用しない。

LuckPerms設定例は仕様上の意図を示す参考とし、正式CommandとNode構成は導入するEliteMobs／LuckPerms Versionで再確認する。

```text
/lp group default permission set elitemobs.adventurersguild.teleport false
/lp group default permission set elitemobs.dungeon.tp false
/lp group default permission set elitemobs.teleport.spawn false
```

---

## 7. Economyおよび成果還元

### 7.1 Waymark

WMはMainとFrontierで共有する。

Frontier側のWM用途：

- Worlds BeyondのLaunchpad購入
- Worlds BeyondのFlight Duration 3 Firework Rocket購入
- Worlds BeyondのWaystone Placement Tool購入
- Waystone維持、上書き、復活
- 将来のRuined Frontier Utility、Quest、Reward

Mainへの初期成果還元方針：

- Frontierで得た装備、素材、Quest ItemをMainへ移送しない。
- MainとFrontier間で移送または換価可能なTheme固有報酬はWMに限定する。
- mcMMOは報酬移送ではなくNetwork共通Progressionとして別枠で共有する。
- Theme Achievementや記念品のMain表示は後続Phaseとする。

### 7.2 Economy Transaction

`Wayfarer_Frontier`はVault API経由でWMを操作し、RedisEconomyの内部Dataを直接変更しない。

WM操作要件：

- Transaction ID
- Idempotency
- 二重請求防止
- 二重Refund防止
- Database更新失敗時の補償Refund
- Unknown状態のAudit
- Admin Reconcile
- Main Threadでの同期Database I/O禁止

---

## 8. Custom Plugin責務

### 8.1 Wayfarer_Core

共通基盤：

- MariaDB接続
- Schema Migration
- Redis Cache／Lock／PubSub
- Waymark Service Adapter
- Player Identity
- 共通Item Identity
- Transaction ID
- 共通Audit
- Cross-server Message
- Permission Contract

### 8.2 Wayfarer_Frontier

Frontier固有責務：

```text
Wayfarer_Frontier
├─ Theme Registry（World ID／Group割当の正本）
├─ Gate／Theme Entry
├─ Teleport／Portal／Respawn Boundary Guard
├─ Theme別Inventory
├─ EliteMobs Instance Boundary Registry
├─ Initial Loadout
├─ Worlds Beyond Module
│  ├─ Waystone
│  ├─ Waystone Discovery GUI
│  ├─ Waystone Teleport GUI
│  ├─ Launchpad
│  └─ Frontier WM Shop
├─ Ruined Frontier Adapter
├─ Theme Item Boundary
├─ Theme Lifecycle
├─ Administration
└─ Audit Adapter
```

Ruined FrontierのBetterStructures／EliteMobs本体機能を再実装しない。World Allowlist、Inventory境界、Gate、WM接続、Theme Item漏出防止および必要なAdapterのみ担当する。

---

## 9. 外部Plugin責務

| Plugin／Content | 責務 |
|---|---|
| Iris | Worlds Beyondの地形生成 |
| LeafGrapple | Worlds BeyondのGrappling Hook挙動 |
| BetterStructures | Ruined Frontier三次元のStructure生成 |
| EliteMobs | Ruined FrontierのBoss、Loot、Quest、Progression |
| Primis | EliteMobs導入Adventure |
| Adventurer's Guild | Ruined Frontier系Hub |
| FreeMinecraftModels | EliteMobs／Prop Model |
| ResourcePackManager | Frontier統合Resource Pack |
| Multiverse-NetherPortals | 各Theme World FamilyのOverworld／Nether／End双方向Link、End Exit Respawn管理 |
| WorldGuard | Hub、Gate、Theme境界、Boss Region保護 |
| CoreProtect | 永続WorldおよびHubのBlock Audit |
| Wayfarer_Frontier | Theme統合、Inventory、独自Gameplay、WM取引 |

Portal共通要件：

- `Multiverse-NetherPortals`のWorld Linkは、各Theme FamilyについてOverworld／NetherおよびOverworld／Endを双方向で登録する。
- `handle-end-exit-respawn: true`をBaselineとする。
- End Exit Portalの帰還先は、同一ThemeのLinked Overworldに限定する。
- 別Themeに設定されたBed／Respawn AnchorをCross-theme帰還先として使用させない。
- 命名規則による自動Linkだけに依存せず、Theme RegistryのWorld IDと実Bukkit World名を照合する。
- Ruined FrontierとWorlds BeyondのWorld Familyを相互接続しない。

未知のWorldへ自動適用するPlugin設定は禁止する。

---

## 10. Resource Pack

Frontier Backendは統合Resource Packを配信可能とする。

候補内容：

```text
Frontier Resource Pack
├─ FreeMinecraftModels出力
├─ BetterStructures Prop Pack
├─ EliteMobs Model
├─ EliteMobs Prop Pack（採用時）
├─ BetterHealthBar Asset
├─ LeafGrapple Model（採用時）
└─ Worlds Beyond固有Asset（採用時）
```

方針：

- MainとFrontierは別Packとする。
- Backend移動時のResource Pack Reloadを許容する。
- Worlds BeyondにBS／EM Assetが読み込まれても、World AllowlistによりContentは生成しない。
- Shader、Custom Font、Model ID、CustomModelData、Item Model Componentの競合を検証する。
- V0.0.3のWorlds Beyondは専用Modelを必須としない。
- Content ZIP、Model、SchematicおよびJARをProject RepositoryへCommitしない。

---

## 11. 保護および管理

共通方針：

- `frontier_gate`はWorldGuardで全体保護する。
- Adventurer's GuildおよびPrimisはContent仕様に従って保護する。
- Worlds BeyondのWaystone／Launchpadはシステム管理Blockとして保護する。
- Ruined FrontierのBoss Arena／ShrineはEliteMobs連携Regionで保護する。
- 通常探索地域に不要な全域建築禁止を適用しない。
- BuilderへPlugin管理、Economy、Database、Region管理、Theme Lifecycle権限を付与しない。
- 管理操作はCommand／GUI経由とし、物理Block破壊でシステム状態を変更しない。
- CoreProtectはCold Backupの代替にしない。

---

## 12. Difficultyおよび死亡

| Theme | Difficulty | Death |
|---|---|---|
| Worlds Beyond | PEACEFUL | 通常ItemはVanilla Drop。Core Traversal LoadoutのみOwner Bindで保持／復旧 |
| Ruined Frontier | HARD（暫定） | Vanilla Dropを初期Baselineとする |
| Frontier Lobby | PEACEFUL | 戦闘なし |
| Adventurer's Guild | NORMAL＋通常Mob Spawn禁止 | Hub保護。PEACEFUL由来の無料回復地点にしない |

ResurrectionChest等の死亡補助は後続Phaseとし、V0.0.3では前提にしない。

---

## 13. World Lifecycle

### 13.1 Worlds Beyond

- 初期運用はPersistentとする。
- 定期Reset／Season制を採用しない。
- Waystone履歴、プレイヤー建築、交通網を長期保存する。
- Seed、Iris Engine／PackおよびWorld UUIDを初回生成後に固定する。

### 13.2 Ruined Frontier

- alpha初期運用はPersistentとする。
- 定期Reset／Season制は後続検討とする。
- Content更新は原則として新規Chunkへ適用する。
- 既存Worldの削除、Trim、再生成は独立した破壊的タスクとして承認する。

### 13.3 Instance World

Primis付属DungeonおよびEliteMobs Instanceの生成、有効化、Dungeon Gameplay、Package固有Respawn、終了およびWorld削除は、EliteMobsのContent Package Lifecycleを正とする。CoreProtect、BackupおよびInventory Saveの対象範囲を永続Worldと分離する。

`Wayfarer_Frontier`は、許可済みContent Package ID、生成Eventまたは確実な検出手段を用いる**EliteMobs Instance Boundary Registry**を持つ。

Instance Boundary Registryの責務：

- 生成元が許可済みContent Packageであることを検証する。
- 対象WorldをGuild Inventory Groupへ一時登録する。
- Theme Item Boundaryを適用する。
- Instance終了前にPlayerを安全地点へ退避させる。
- Inventory保存完了後にGroup登録を解除する。
- Crash／Restart後の孤立World、孤立Lockおよび未完了Transitionを検出する。

Instance Boundary Registryは、EliteMobsのWorld生成、Dungeon Gameplay、内部Config、DatabaseまたはContent Package Fileを制御・変更しない。未知WorldはWorld名PrefixだけでGuild Groupへ登録せず、Neutral扱いまたは入場拒否としてFail-closedする。

---

## 14. Phase

### Phase F0 — 共通基盤

- Frontier Lobby
- Theme Registry
- Theme別Inventory
- Theme Item Boundary
- WM Adapter
- Gate Safe Return
- Audit
- Frontier Resource Pack基盤

### Phase F1 — 最初のPlayable Theme

ProjectのRelease順序に従い、少なくとも一方をPlayable Themeとして導入する。World GeneratorのみではPlayable完了としない。

### Phase F2 — Worlds Beyond MVP

- Iris三次元
- PEACEFUL
- Elytra
- LeafGrapple
- Launchpad
- Frontier WM Shop
- Waystone
- Discovery／Teleport GUI

### Phase F3 — Ruined Frontier alpha

- Adventurer's Guild
- Primis
- BetterStructures三次元
- EliteMobs
- Exploration Pack
- Caves and Lost Civilizations Free
- 購入済みEchoes of the Past
- 購入済みAdventure Pack
- 購入済みBetterStructures Prop Pack
- Free Elite Shrines
- Dungeoneering Modules Free
- Resource Pack統合

### Phase F4 — EliteMobs系Premium拡張および後続機能

- Worlds Beyond探索実績
- TrainCarts／景観交通
- 101 Premium Shrines
- Dungeoneering Modules Premium
- EliteMobs Prop Pack
- The Oasisおよびその他の有料Adventure／Dungeon
- Theme Achievement
- Main側記念表示
- Frontier WM Reward調整
- Ranking／Champion

---

## 15. Theme比較

| 項目 | Worlds Beyond | Ruined Frontier |
|---|---|---|
| 主題 | 未知の地形と移動 | 危険な遺跡と戦闘 |
| World Generator | Iris | Vanilla系＋BetterStructures |
| Difficulty | PEACEFUL | HARD |
| 戦闘 | 主目的にしない | EliteMobs中心 |
| 移動 | Hook、Elytra、Launchpad | Vanilla移動、Guild／Portal |
| 固有交通 | Waystone | Guild／Primis／Dungeon Gate |
| Player建築 | 許可、交通・拠点形成を推奨 | 通常探索域で許可、Boss Regionは保護 |
| Landmark | 管理者による手作業配置なし | BetterStructures／Content生成 |
| Progression | 発見、維持、歴史 | 装備、Boss、Quest、Level |
| Persistent Data | Waystone DB、履歴 | EliteMobs Progression、Inventory |
| Main還元 | Theme固有成果はWMのみ。mcMMOはNetwork共通 | Theme固有成果はWMのみ。mcMMOはNetwork共通 |
| Inventory | Worlds Beyond Group | Guild Group |

---

## 16. 共通受入試験

### Theme隔離

- [ ] Worlds BeyondでBetterStructuresが生成されない。
- [ ] Worlds BeyondでEliteMobs Spawn／Eventが発生しない。
- [ ] Frontier LobbyでTheme PluginのGameplayが発生しない。
- [ ] Ruined Frontier GroupへWorlds Beyond Itemを持ち込めない。
- [ ] Worlds Beyond GroupへEliteMobs Itemを持ち込めない。
- [ ] 未知の新規Worldが自動でThemeへ登録されない。

### Inventory

- [ ] Theme入場前に正しいInventory Groupへ切り替わる。
- [ ] Theme退出時に元のStateが復元される。
- [ ] Disconnect／RestartをまたいでもGroup別Stateが維持される。
- [ ] Ender Chest、XP、Health、Foodが仕様どおり分離される。
- [ ] mcMMO進行がMain、Worlds Beyond、Ruined Frontier間で同一Playerへ継続する。
- [ ] 切替失敗時にItem Duplicationが発生しない。
- [ ] 切替失敗時はNeutral Groupへ隔離される。

### Economy

- [ ] WM残高はMainとFrontierで同一である。
- [ ] Frontier購入はVault API経由で引き落とされる。
- [ ] Item付与失敗時にRefundまたはPending状態へ遷移する。
- [ ] 二重Click／Lag／再送で二重購入されない。
- [ ] Test WMは正式手順で復元される。

### Gate

- [ ] 各Themeへ安全に到着できる。
- [ ] 各ThemeからFrontier Lobbyへ帰還できる。
- [ ] Inventory切替前にDestinationへ出現しない。
- [ ] Theme外Itemを持ったままGateを通過できない。
- [ ] Gate移動中にCore Traversal Loadoutの複製、Dropまたは旧Instance復活が起きない。
- [ ] Backend Restart後もRouteが維持される。

### Portal／World Family

- [ ] Multiverse-NetherPortalsの正式Versionを固定できる。
- [ ] `handle-end-exit-respawn: true`が有効である。
- [ ] 各ThemeのOverworld／Nether Linkが双方向である。
- [ ] 各ThemeのOverworld／End Linkが双方向である。
- [ ] Ruined Frontier End Exit PortalがRuined Frontier Overworldへ帰還する。
- [ ] Worlds Beyond End Exit PortalがWorlds Beyond Overworldへ帰還する。
- [ ] End Exit時に別ThemeのBed／Respawn Anchorへ移動しない。
- [ ] Worlds BeyondとRuined FrontierのPortalが相互接続されない。
- [ ] BetterStructures内End PortalからRuined Frontier Endへ接続し、Ruined Frontier Overworldへ帰還する。
- [ ] Portal経由で不要なInventory Group切替が発生しない。
- [ ] Mob、Item、VehicleのPortal通過挙動が許容範囲である。

### Guild

- [ ] Adventurer's GuildはNORMALで動作する。
- [ ] Guild内で通常MobがSpawnしない。
- [ ] Guild滞在だけでPEACEFUL由来の自動回復が発生しない。
- [ ] GuildとRuined Frontier間でHealth／Foodが共有される。

### mcMMO

- [ ] MainとRuined Frontierで同一mcMMO Levelが参照される。
- [ ] Ruined FrontierでmcMMO Gameplay効果が有効である。
- [ ] 高Level Playerが有利になることを仕様として許容する。
- [ ] mcMMO共有がInventory Group切替に影響しない。

### Instance

- [ ] Instanceの生成、有効化、Gameplay、終了およびWorld削除はEliteMobsのContent Package Lifecycleが管理する。
- [ ] 許可済みPackageのInstanceだけがGuild Groupへ一時登録される。
- [ ] 未知Instance Worldが自動登録されない。
- [ ] Instance終了前にPlayerが安全地点へ退避する。
- [ ] Instance終了時にInventoryが失われない。
- [ ] Inventory保存完了後にGroup登録が解除される。
- [ ] Restart後に孤立Instance、孤立Inventory Lockまたは未完了Transitionが残らない。
- [ ] Wayfarer_FrontierがEliteMobs内部Config／Database／Content Packageを変更しない。

### Teleport境界

- [ ] 一般Playerが`elitemobs.adventurersguild.teleport`でGuildへ直接Teleportできない。
- [ ] 一般Playerが`elitemobs.dungeon.tp`でDungeonへ直接Teleportできない。
- [ ] 一般Playerが`elitemobs.teleport.spawn`でEliteMobs Spawnへ直接Teleportできない。
- [ ] `elitemobs.user`付与後も個別拒否Nodeが優先される。
- [ ] `/em quit`またはPackage固有退出でInventory境界を迂回できない。
- [ ] Multiverse CommandでInventory境界を迂回できない。
- [ ] Admin Teleportでも正しいGroup切替が行われる。
- [ ] Bed／Anchor／End Exit／Void死亡で正しいGroupへ復帰する。
- [ ] Inventory切替失敗時はNeutral GroupへFail-closedする。

### Resource Pack

- [ ] Main／Frontier切替時に正常にReloadする。
- [ ] FMM、BS Prop、EliteMobs、LeafGrapple Assetが競合しない。
- [ ] Worlds Beyondで不要なEntity／Modelが生成されない。
- [ ] Pack容量とDownload時間が許容範囲である。

---

## 17. 実装前Lock項目

Portal：

- Multiverse-NetherPortalsの正式Version
- 双方向Linkの設定方法
- `handle-end-exit-respawn: true`
- 各ThemeのOverworld／Nether／End Link
- End Exit時のBed／Respawn Anchor処理
- BetterStructures内End Portalの接続・帰還先

EliteMobs Instance：

- EliteMobs Content Package Lifecycleを正本とすること
- Instance生成／終了を検出するEventまたは代替手段
- Content Package IDの検証方法
- Guild Groupへの一時登録／解除方法
- Instance削除前のPlayer退避先
- Crash／Restart後の孤立Instance検出方法
- EliteMobs内部Config／Database／Content Packageを変更しないこと

Permission：

- `elitemobs.user`の正式な子Permission構成
- 明示拒否するTeleport Permission Node
- Guild NPC／Portal／Wayfarer Gateによる正規移動導線
- `/em quit`およびPackage固有退出Commandの境界検査方法

これらは設計方針の未決ではなく、導入VersionとArtifactに依存する実装Lock項目である。

---

## 18. 実プレイ評価で確定する項目

次の値・採否はConfigまたはContent選定の暫定値として実装し、本流のProject構築チャットで実プレイ結果を基にLockする。単発の感想ではなく、複数回の移動・攻略、WM収支、Server負荷および複数Player時の挙動を記録する。

| 分野 | 実プレイで確認する事項 | 反映先 |
|---|---|---|
| Inventory境界 | 切替待ち時間、再接続、死亡、Portal、Instance終了時の安全性 | Wayfarer_Frontier Config／実装 |
| Portal | 各World Familyの往復先、End Exit、Vehicle／Mob挙動 | Multiverse-NetherPortals Config |
| Resource Pack | Download／Reload時間、Model競合、Theme移動時の体感 | Frontier Pack構成 |
| Worlds Beyond | Hook速度、Launchpad射出、Waystone距離・期間・価格、探索半径 | Worlds Beyond仕様／Config |
| Ruined Frontier | Structure密度、Level Curve、mcMMO影響、死亡損失、Boss難度 | Ruined Frontier仕様／Content Config |
| Economy | EvenMoreFish収益に対するWM支出頻度、残高推移、価格の重さ | Wayfarer_Frontier Config |
| Performance | Chunk生成、Large Structure、Boss、Instance、DB切替時のTPS／遅延 | Plugin／Content採否 |
| Lifecycle | Persistent運用、Instance削除、将来のReset／Season必要性 | 運用仕様 |

Theme固有の評価項目と暫定値は各Theme仕様書を正とする。

---

## 19. Deferred

- Theme Achievement共通Framework
- Main側Achievement Reward
- Cross-server Transit Vault
- Theme固有Storage
- TrainCarts
- Waystone Ranking／Champion
- Ruined Frontier Season／Reset
- Frontier WM Reward Source
- ResurrectionChest
- Web／Discord表示
- Cross-theme Cosmetic

---

## 20. 実装時の原則

1. 本文書だけでPlugin開発開始を承認したものとは扱わない。
2. Custom PluginのSourceは別Repositoryで管理する。
3. Project Repositoryには接続仕様、Config、Version、導入手順および受入試験を保存する。
4. 有償Contentは正規取得し、ArtifactをGitへ含めない。
5. Theme World名、Seed、Content Pack、Plugin Versionを確定してからChunk生成する。
6. World AllowlistとInventory Groupを最初に設定する。
7. 正常系だけでなく、切替失敗、DB停止、Redis停止、Crashを検証する。
8. V0.0.3の暫定値はConfigから変更可能にする。
9. 実運用Dataを得た後に価格、期間、生成密度および難易度を調整する。
