# Project Wayfarer — Frontierサーバ仕様書 V0.0.1

> **状態：設計仕様／実装前**
>
> 本文書は、Project WayfarerのFrontier Backendに複数のThemeを収容するための共通仕様を定義する。
> Theme固有仕様は、次の文書を正とする。
>
> - [Worlds Beyond仕様書 V0.0.1](./Worlds_Beyond_Specification_V0.0.1.md)
> - [Ruined Frontier仕様書 V0.0.1](./Ruined_Frontier_Specification_V0.0.1.md)
>
> 本文書のVersionは設計文書の改訂番号であり、稼働ServerのRelease番号ではない。

---

## 1. 目的

Frontierは、恒久生活拠点であるMainとは異なるルール、World Generation、Progressionおよび移動体験を提供するAdventure Backendである。

V0.0.1では、次の2 Themeを正式な設計対象とする。

| Theme | 中核体験 | 主な技術 |
|---|---|---|
| **Worlds Beyond** | 景観、立体移動、発見、期限付き交通網、プレイヤーによる開拓史 | Iris、LeafGrapple、Wayfarer_Frontier |
| **Ruined Frontier** | 危険な遺跡探索、Boss、Custom Loot、Quest、EliteMobs Progression | BetterStructures、EliteMobs、Primis、Adventurer's Guild |

Frontier共通原則：

1. Mainの通常InventoryとFrontierの通常Inventoryを分離する。
2. Frontier内でもThemeごとにInventory Groupを分離する。
3. Mainへ直接持ち帰れる成果は、初期段階では共有通貨Waymark（WM）に限定する。
4. mcMMO進行およびWM残高は、Project全体の既存共有境界に従う。
5. Theme固有Item、装備、Quest Item、素材は別ThemeおよびMainへ漏出させない。
6. Frontier Gateは中立Hubとし、どのThemeの装備も常駐させない。
7. ThemeのPlugin、WorldおよびContentは明示的Allowlistで隔離し、未知のWorldを自動有効化しない。
8. 既製Pluginで代替できないTheme固有機能は、`Wayfarer_Frontier` Pluginへ実装する。

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
└─ Frontier Gate / Frontier Lobby
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

共通導線要件：

- Frontier Gateから各Themeの安全な入口へ移動できる。
- 各ThemeからFrontier Gateへ確実に帰還できる。
- Ruined Frontier Nether／Endへの通常導線は、Overworld内のVanilla Portalを基本とする。
- Frontier GateからRuined Frontier Nether／Endへ直接Gateを設けない。
- Theme間の直接移動は行わず、Frontier GateまたはAdventurer's Guildを経由する。
- Portal、Gateおよび到着地点は、Inventory切替完了後にPlayerを出現させる。

---

## 4. Runtime前提

V0.0.1作成時点のProject基準：

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
| World Administration | Multiverse-Core、WorldEdit、WorldGuard |
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

| Data | Main | Frontier Gate | Worlds Beyond | Ruined Frontier |
|---|---|---|---|---|
| 通常Inventory | Main Local | Neutral | WB Group | Guild Group |
| Ender Chest | Main Local | Neutral | WB Group | Guild Group |
| Vanilla XP／Health／Food | Main Local | Neutral | WB Group | Guild Group |
| Waymark | 共有 | 表示のみ可 | 共有 | 共有 |
| mcMMO | 共有 | 原則使用なし | 共有 | 共有 |
| Theme固有Item | 不可 | 不可 | WB限定 | Guild限定 |
| EliteMobs Progression | 不可 | 不可 | 無効 | Guild限定 |
| Waystone発見履歴 | 不可 | 不可 | DB共有 | 不可 |

---

## 6. Inventory切替要件

Theme別Inventoryは`Wayfarer_Frontier`が担当する。

必要要件：

1. World／Theme境界を明示的Allowlistで定義する。
2. Player UUIDごとにGroup別Stateを永続化する。
3. Inventory、Armor、Offhand、Ender Chest、XP、Health、Foodを原子的に近い手順で保存・復元する。
4. Teleport、Disconnect、Crash、Server Stop中の中間状態を検出できる。
5. 同一Playerの並行切替をLockする。
6. 保存失敗時に移動を中止する。
7. 復元失敗時にNeutral Groupへ隔離し、Admin Auditへ記録する。
8. Item Identity検証を行い、Theme外Itemを除去または隔離する。
9. Gate到着前に切替を完了する。
10. 旧Backupや複製ItemによるTheme境界突破を検出できる拡張余地を持つ。

MariaDBを正本とし、必要に応じてRedisをLock／Cacheに使用する。RedisだけをInventoryの永続正本にしない。

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
- MainとFrontier間で共有可能な報酬はWMに限定する。
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
├─ Theme Registry
├─ Gate／Theme Entry
├─ Theme別Inventory
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
| WorldGuard | Hub、Gate、Theme境界、Boss Region保護 |
| CoreProtect | 永続WorldおよびHubのBlock Audit |
| Wayfarer_Frontier | Theme統合、Inventory、独自Gameplay、WM取引 |

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
- V0.0.1のWorlds Beyondは専用Modelを必須としない。
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
| Frontier Gate | PEACEFUL | 戦闘なし |
| Adventurer's Guild | PEACEFULまたはContent推奨値 | Hub保護 |

ResurrectionChest等の死亡補助は後続Phaseとし、V0.0.1では前提にしない。

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

Primis付属DungeonおよびEliteMobs Instanceは、Content PackageのLifecycleを正とする。CoreProtect、BackupおよびInventory Saveの対象範囲を永続Worldと分離する。

---

## 14. Phase

### Phase F0 — 共通基盤

- Frontier Gate
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
- Free Elite Shrines
- Dungeoneering Modules Free
- Resource Pack統合

### Phase F4 — 後続拡張

- Worlds Beyond探索実績
- TrainCarts／景観交通
- Ruined Frontier Premium Content
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
| Main還元 | WMのみ | WMのみ |
| Inventory | Worlds Beyond Group | Guild Group |

---

## 16. 共通受入試験

### Theme隔離

- [ ] Worlds BeyondでBetterStructuresが生成されない。
- [ ] Worlds BeyondでEliteMobs Spawn／Eventが発生しない。
- [ ] Frontier GateでTheme PluginのGameplayが発生しない。
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
- [ ] 各ThemeからFrontier Gateへ帰還できる。
- [ ] Inventory切替前にDestinationへ出現しない。
- [ ] Theme外Itemを持ったままGateを通過できない。
- [ ] Gate移動中にCore Traversal Loadoutの複製、Dropまたは旧Instance復活が起きない。
- [ ] Backend Restart後もRouteが維持される。

### Resource Pack

- [ ] Main／Frontier切替時に正常にReloadする。
- [ ] FMM、BS Prop、EliteMobs、LeafGrapple Assetが競合しない。
- [ ] Worlds Beyondで不要なEntity／Modelが生成されない。
- [ ] Pack容量とDownload時間が許容範囲である。

---

## 17. Deferred

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

## 18. 実装時の原則

1. 本文書だけでPlugin開発開始を承認したものとは扱わない。
2. Custom PluginのSourceは別Repositoryで管理する。
3. Project Repositoryには接続仕様、Config、Version、導入手順および受入試験を保存する。
4. 有償Contentは正規取得し、ArtifactをGitへ含めない。
5. Theme World名、Seed、Content Pack、Plugin Versionを確定してからChunk生成する。
6. World AllowlistとInventory Groupを最初に設定する。
7. 正常系だけでなく、切替失敗、DB停止、Redis停止、Crashを検証する。
8. V0.0.1の暫定値はConfigから変更可能にする。
9. 実運用Dataを得た後に価格、期間、生成密度および難易度を調整する。
