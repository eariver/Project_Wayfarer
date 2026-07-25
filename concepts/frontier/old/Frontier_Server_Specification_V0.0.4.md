# Project Wayfarer — Frontierサーバ仕様書 V0.0.4

> **状態：設計仕様／実装前**
>
> 本文書は、Project WayfarerのFrontier Backendに複数のThemeを収容するための共通仕様を定義する。
> Theme固有仕様は、次の文書を正とする。
>
> - [Worlds Beyond仕様書 V0.0.4](./Worlds_Beyond_Specification_V0.0.4.md)
> - [Ruined Frontier仕様書 V0.0.4](./Ruined_Frontier_Specification_V0.0.4.md)
>
> 本文書のVersionは設計文書の改訂番号であり、稼働ServerのRelease番号ではない。

---

## 1. 目的

Frontierは、恒久生活拠点であるMainとは異なるルール、World Generation、Progressionおよび移動体験を提供するAdventure Backendである。

V0.0.4では、次の2 Themeを正式な設計対象とする。

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
8. Frontier Backend内のPlayer State分離は`Multiverse-Inventories`を正本とし、World Groupと共有対象は同PluginのConfigで管理する。World ID、Portal Linkおよび各Plugin AllowlistはProjectの導入Configと本仕様を基準に相互確認する。
9. 既製Pluginで代替できないTheme固有機能だけを`Wayfarer_Frontier`へ実装する。通常Inventoryの保存・復元、通常のWorld変更監視および物理Gate移動は再実装しない。

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
   ├─ Beyond Gate（物理Gate）
   │  └─ Worlds Beyond Overworld
   │     ├─ Nether Portal → Worlds Beyond Nether
   │     └─ End Portal    → Worlds Beyond End
   │
   └─ Guild Gate（物理Gate）
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
| Worlds Beyond | 導入Configで固定するWorld Family |
| Adventurer's Guild | `adventurers_guild`（導入Artifact確認後にLock） |
| Ruined Frontier | `frontier_bs`／`frontier_bs_nether`／`frontier_bs_the_end` |

共通導線要件：

- Frontier Lobbyには、Worlds Beyondへ接続する**Beyond Gate**と、Adventurer's Guildへ接続する**Guild Gate**を物理的に配置する。
- V0.0.4ではTheme選択GUIを実装しない。GUI化は将来の利便性機能としてDeferredへ置く。
- Gateの実装方式は、Portal Plugin、Command連携または専用構造を比較して実装時にLockする。通常Inventoryの保存・復元は`Multiverse-Inventories`へ委譲する。
- 各ThemeからFrontier Lobbyへ確実に帰還できる物理的またはNPC／Portal導線を用意する。
- Ruined Frontier Nether／Endへの通常導線は、Overworld内のVanilla Portalを基本とする。
- Frontier LobbyからRuined Frontier Nether／Endへ直接Gateを設けない。
- Theme間の直接移動は行わず、Frontier LobbyまたはAdventurer's Guildを経由する。
- Gate、Portal、Respawn、Command Teleportおよび再接続を含む全移動経路で、`Multiverse-Inventories`が期待どおりPlayer Stateを切り替えることを受入試験する。

---

## 4. Runtime前提

V0.0.4作成時点のProject基準：

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
| World Administration | Multiverse-Core、Multiverse-Inventories、Multiverse-NetherPortals、WorldEdit、WorldGuard |
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

- 原則として空の中立Profileとする。Lobby専用の案内Itemを導入する場合も、Theme固有Itemとは別Identityとし、Theme Groupへ持ち越さない。
- Worlds BeyondおよびRuined FrontierのItemを持ち込ませない。
- Ender Chest、XP、Health、FoodをTheme Groupと共有しない。
- Gate移動時も`Multiverse-Inventories`の通常World変更処理へ委譲し、独自Pluginで二重に保存・復元しない。
- MVI未導入、無効化またはGroup Config不整合が判明した状態ではFrontierを一般開放しない。

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

固定Worldは`Multiverse-Inventories`のGuild Groupへ明示登録する。動的Instanceの扱いは、導入するEliteMobs Artifactを確認したうえで、静的登録、承認済みBlueprint名に限定した厳密Regex、または必要時のみ連携Adapterの順で決定する。

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

## 6. Inventory分離および切替要件

### 6.1 正本

Frontier Backend内のWorld Group別Player Stateは、**Multiverse-Inventories（MVI）を正本**とする。

MVIへ委譲する対象：

- Inventory
- Armor
- Offhand
- Ender Chest
- Vanilla XP／Level
- Health
- Food／Saturation
- 導入Versionで共有対象に設定した追加Player State

MainとFrontierは別Paper Backendであるため、通常Player DataはBackend単位で既に分離される。MVIは同一Frontier Backend内のNeutral、Worlds Beyond、Guildの各Groupを分離するために使用する。

`Wayfarer_Frontier`は通常InventoryをMariaDBへ保存せず、MVIの保存・復元処理を再実装しない。

### 6.2 Group Config

初期Group：

```text
neutral:
  frontier_gate

worlds_beyond:
  Worlds Beyond Overworld
  Worlds Beyond Nether
  Worlds Beyond End

guild:
  Adventurer's Guild
  Ruined Frontier Overworld
  Ruined Frontier Nether
  Ruined Frontier End
  Primis
  許可済み固定Dungeon World
  検証済みEliteMobs Instance World
```

- Group名、World名および共有対象はMVI ConfigをRuntime正本とする。
- World IDはMultiverse-Core、MVI、Multiverse-NetherPortals、BetterStructures、EliteMobs、IrisおよびWorldGuardの各Configで一致させる。
- `Wayfarer_Frontier`のWorld AllowlistはWaystone、Launchpad、Traversal Loadout等、自身の機能を有効化する範囲だけに使用する。Inventory Groupの正本にはしない。
- Wildcard／Regexを使用する場合は、承認済みWorldまたはBlueprint名に限定し、未知Worldを包含する広いPatternを禁止する。

### 6.3 通常移動

次の移動に伴う保存・復元はMVIへ委譲する。

- 物理Gate
- Nether／End Portal
- Bed／Respawn Anchor
- End Exit Portal
- Death／Respawn
- Multiverse Teleport
- Admin Teleport
- Plugin Teleport
- Disconnect／Reconnect
- Backend Restart

`Wayfarer_Frontier`はこれらのEventを包括的に横取りしてInventoryを独自切替しない。各経路でMVIが正しく機能することを受入試験し、問題がある経路はPermission、移動導線または外部Plugin Configで閉じる。

### 6.4 Theme固有Item

一般的なItem持ち出し防止はMVIのGroup分離で成立させる。

`Wayfarer_Frontier`が追加で管理するのは、自身が発行する次のItemに限定する。

- Worlds Beyond Elytra
- Grappling Hook
- Navigation Item
- Launchpad
- Waystone Placement Tool
- 将来追加するWayfarer固有Item

これらにはPDC等の独自Item Identityを付与し、Owner Bind、再発行、旧Instance失効、Theme外での使用拒否等を行う。EliteMobs ItemやVanilla Item全般を独自Pluginで走査・隔離しない。

### 6.5 EliteMobs動的Instance

EliteMobsのInstanced Dungeonが動的Worldを生成する場合、次の順でMVI対応を決定する。

1. 導入するEliteMobs VersionとContent Package Artifactを固定する。
2. 対象Contentが固定World、複製World、一時Worldのどれを使用するか確認する。
3. 固定WorldならMVIのGuild Groupへ静的登録する。
4. 動的Worldなら、承認済みBlueprint名と連番だけに限定した厳密Regexで登録できるか確認する。
5. 同時Instance、終了時削除、Restart、再接続およびInventory共有を最小検証Serverで試験する。
6. 静的登録または厳密Regexで安全に成立しない場合に限り、**EliteMobs–MVI Adapter**を実装する。

Adapterを実装する場合の限定責務：

- EliteMobsのInstance生成Eventから、承認済みPackage／BlueprintとInstance World名を取得する。
- MVIのGuild Groupへ対象Worldを追加する。採用Versionが非永続の一時登録を提供する場合は、Instance名をConfigへ恒久蓄積しない方式を優先する。
- EliteMobsのInstance削除Event後に、MVI Groupから対象Worldを解除する。
- Restart後に一時登録だけが残っていないか検査する。

Adapterは以下を担当しない。

- Instance Worldの生成、複製、Loadまたは削除
- Dungeon Gameplay、Boss、Loot、Quest
- Player退出先の決定
- Inventory保存・復元
- EliteMobs内部Config、DatabaseまたはContent Package Fileの変更

これらはEliteMobsまたはMVIの責務とする。

### 6.6 権限境界

一般Playerへ次のEliteMobs Teleport権限を明示的に拒否する。

```text
elitemobs.adventurersguild.teleport
elitemobs.dungeon.tp
elitemobs.teleport.spawn
```

- `elitemobs.user`等のBundle Permissionを付与する場合でも、上記NodeをLuckPermsで個別に`false`とする。
- Guild、PrimisおよびDungeonへの通常導線は、Guild内NPC、Portalまたは承認済みGateを使用する。
- `/em quit`、Package固有退出、死亡Respawnおよび強制TeleportでもMVIのGroup切替が正常に働くことを試験する。
- `/mv tp`その他の管理Teleport権限を一般Playerへ付与しない。
- Admin TeleportでもMVIによる正しいGroup切替が行われることを試験する。
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
├─ Worlds Beyond Module
│  ├─ Worlds Beyond Traversal Loadout
│  ├─ Waystone
│  ├─ Waystone Discovery GUI
│  ├─ Waystone Teleport GUI
│  ├─ Launchpad
│  ├─ Frontier WM Shop
│  └─ Wayfarer固有Item Identity
├─ Administration
├─ Audit Adapter
├─ 将来のRuined Frontier WM Reward Adapter
└─ EliteMobs–MVI Adapter（必要性確認後のみ）
```

担当しない項目：

- Theme選択GUIおよびFrontier Lobbyの物理Gate移動
- 通常Inventory、Ender Chest、XP、Health、Foodの保存・復元
- 通常のTeleport、Portal、RespawnおよびWorld変更の包括監視
- Multiverse-Inventories Groupの通常運用
- EliteMobs Item、Vanilla Itemおよび他Plugin Item全般のIdentity管理
- BetterStructures／EliteMobs本体機能
- EliteMobs Instance Lifecycle

EliteMobs–MVI Adapterは、静的MVI登録または承認済みBlueprint名に限定した厳密Regexで安全に運用できないと確認された場合に限り追加する。

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
| Multiverse-Inventories | Frontier Backend内のWorld Group別Player State保存・復元 |
| Multiverse-NetherPortals | 各Theme World FamilyのOverworld／Nether／End双方向Link、End Exit Respawn管理 |
| WorldGuard | Hub、Gate、Theme境界、Boss Region保護 |
| CoreProtect | 永続WorldおよびHubのBlock Audit |
| Wayfarer_Frontier | Worlds Beyond固有Gameplay、WM取引、Wayfarer固有Item、必要時のみEliteMobs–MVI連携 |

Portal共通要件：

- `Multiverse-NetherPortals`のWorld Linkは、各Theme FamilyについてOverworld／NetherおよびOverworld／Endを双方向で登録する。
- `handle-end-exit-respawn: true`をBaselineとする。
- End Exit Portalの帰還先は、同一ThemeのLinked Overworldに限定する。
- 別Themeに設定されたBed／Respawn AnchorをCross-theme帰還先として使用させない。
- 命名規則による自動Linkだけに依存せず、Multiverse-Core、MVI、Multiverse-NetherPortalsおよび各Theme Plugin Configの実Bukkit World名を一致させる。
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
- V0.0.4のWorlds Beyondは専用Modelを必須としない。
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
| Worlds Beyond | PEACEFUL | 通常ItemはVanilla Drop。Worlds Beyond Traversal LoadoutのみOwner Bindで保持／復旧 |
| Ruined Frontier | HARD（暫定） | Vanilla Dropを初期Baselineとする |
| Frontier Lobby | PEACEFUL | 戦闘なし |
| Adventurer's Guild | NORMAL＋通常Mob Spawn禁止 | Hub保護。PEACEFUL由来の無料回復地点にしない |

ResurrectionChest等の死亡補助は後続Phaseとし、V0.0.4では前提にしない。

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

Primis付属DungeonおよびEliteMobs Instanceの生成、有効化、Dungeon Gameplay、Package固有Respawn、終了、Player退出およびWorld削除は、EliteMobsのContent Package Lifecycleを正とする。CoreProtectおよびBackupの対象範囲は永続Worldと分離する。

Inventory共有方式は次の優先順で決定する。

1. 固定Dungeon WorldをMVI Guild Groupへ静的登録する。
2. 動的Worldが承認済みBlueprint名＋連番で生成される場合、MVIの厳密RegexでGuild Groupへ所属させる。
3. 静的登録またはRegexで、同時Instance、削除、Restartおよび再接続を安全に扱えない場合だけEliteMobs–MVI Adapterを実装する。

現時点ではAdapterの実装を確定しない。**「EMアダプタの必要性判断」**をRuined Frontier alphaの実装前Roadmap項目とする。

Adapter採用時も、MVIがInventory保存・復元の正本であり、EliteMobsがInstance Lifecycleの正本である。Adapterは生成Eventと削除Eventを用いてMVI Groupへの追加・解除だけを仲介し、EliteMobs内部Config、DatabaseまたはContent Package Fileを変更しない。

---

## 14. Roadmap／Phase

### Phase F0 — 共通基盤

- Frontier Lobby
- Beyond Gate／Guild Gateの物理導線
- Multiverse-Core
- Multiverse-Inventories Group Config
- Multiverse-NetherPortals World Family Link
- WM Adapter
- Permission境界
- Frontier Resource Pack基盤
- 受入試験手順

### Phase F1 — 最初のPlayable Theme

ProjectのRelease順序に従い、少なくとも一方をPlayable Themeとして導入する。World GeneratorのみではPlayable完了としない。

### Phase F2 — Worlds Beyond MVP

- Iris三次元
- PEACEFUL
- Worlds Beyond Traversal Loadout
- Elytra
- LeafGrapple
- Launchpad
- Frontier WM Shop
- Waystone
- Discovery／Teleport GUI

### Phase F3 — Ruined Frontier alpha

実装順：

1. Adventurer's Guild、Primis、EliteMobsおよびMVIの採用Versionを固定する。
2. **EMアダプタの必要性判断**を行う。
   - 固定Worldか動的Worldか確認する。
   - Instance World命名規則とBlueprint名を確認する。
   - MVI静的登録または承認済みBlueprint限定Regexを試す。
   - 同時Instance、終了、Restart、再接続およびInventory共有をSmoke Testする。
   - 不足が確認された場合だけEliteMobs–MVI Adapterを設計する。
3. Ruined Frontier alpha Contentを導入する。

alpha構成：

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
- Theme選択GUIの再検討
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
- [ ] 未知の新規Worldが広いWildcard／RegexでTheme Groupへ取り込まれない。

### Inventory／MVI

- [ ] Multiverse-Inventoriesの正式Versionを固定する。
- [ ] Neutral、Worlds Beyond、Guildの各Groupと共有対象がConfigどおりである。
- [ ] Theme入退出時に正しいGroup Profileへ切り替わる。
- [ ] Disconnect／RestartをまたいでもGroup別Stateが維持される。
- [ ] Ender Chest、XP、Health、Foodが仕様どおり分離される。
- [ ] mcMMO進行がMain、Worlds Beyond、Ruined Frontier間で同一Playerへ継続する。
- [ ] Wayfarer_Frontierが通常Inventoryを独自DBへ保存していない。
- [ ] 通常移動EventをWayfarer_Frontierが二重処理していない。
- [ ] MVI無効化またはGroup Config不整合状態でFrontierを一般開放しない。

### Economy

- [ ] WM残高はMainとFrontierで同一である。
- [ ] Frontier購入はVault API経由で引き落とされる。
- [ ] Item付与失敗時にRefundまたはPending状態へ遷移する。
- [ ] 二重Click／Lag／再送で二重購入されない。
- [ ] Test WMは正式手順で復元される。

### Gate

- [ ] Frontier LobbyにBeyond GateとGuild Gateが存在する。
- [ ] Beyond GateからWorlds Beyondの安全地点へ到着できる。
- [ ] Guild GateからAdventurer's Guildの安全地点へ到着できる。
- [ ] 各ThemeからFrontier Lobbyへ帰還できる。
- [ ] Gate移動でMVIが正しいGroup Profileを適用する。
- [ ] Theme選択GUIがなくても導線を理解できる。
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
- [ ] Portal経由でMVIの不要なProfile変更が発生しない。
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
- [ ] mcMMO共有がMVI Group切替に影響しない。

### EliteMobs Instance／Adapter判断

- [ ] 導入するEliteMobs Versionと対象Content Packageを固定する。
- [ ] 対象Dungeonが固定World、複製World、一時Worldのどれか判定する。
- [ ] Instance World名とBlueprint名の規則を記録する。
- [ ] 固定Worldの場合はMVI Guild Groupへの静的登録で共有できる。
- [ ] 動的Worldの場合は承認済みBlueprint名に限定した厳密Regexを試験する。
- [ ] 同時Instance、終了、Restart、再接続および削除後もInventoryが維持される。
- [ ] Regexが安全に成立する場合はAdapterを実装しない。
- [ ] Regexで不足する場合だけ、生成／削除EventとMVI APIを用いるAdapter要件を確定する。
- [ ] Adapter採用時もEliteMobsがLifecycle、MVIがInventory保存・復元を担当する。
- [ ] Wayfarer_FrontierがEliteMobs内部Config／Database／Content Packageを変更しない。

### Teleport／Permission

- [ ] 一般Playerが`elitemobs.adventurersguild.teleport`でGuildへ直接Teleportできない。
- [ ] 一般Playerが`elitemobs.dungeon.tp`でDungeonへ直接Teleportできない。
- [ ] 一般Playerが`elitemobs.teleport.spawn`でEliteMobs Spawnへ直接Teleportできない。
- [ ] `elitemobs.user`付与後も個別拒否Nodeが優先される。
- [ ] `/em quit`またはPackage固有退出でMVIが正しいGroup Profileを適用する。
- [ ] Multiverse Commandを一般Playerが使用できない。
- [ ] Admin TeleportでもMVIが正しいGroup Profileを適用する。
- [ ] Bed／Anchor／End Exit／Void死亡で正しいGroupへ復帰する。

### Resource Pack

- [ ] Main／Frontier切替時に正常にReloadする。
- [ ] FMM、BS Prop、EliteMobs、LeafGrapple Assetが競合しない。
- [ ] Worlds Beyondで不要なEntity／Modelが生成されない。
- [ ] Pack容量とDownload時間が許容範囲である。

---

## 17. 実装前Lock項目

Inventory／Gate：

- Multiverse-Inventories正式Version
- Neutral、Worlds Beyond、Guild GroupのWorld一覧
- 各Groupで共有するPlayer State
- MVI ConfigのBackup／Restore手順
- Beyond Gate／Guild Gateの実装方式
- Gate到着地点および帰還導線
- Theme選択GUIをV0.0.4で実装しないこと

Portal：

- Multiverse-NetherPortalsの正式Version
- 双方向Linkの設定方法
- `handle-end-exit-respawn: true`
- 各ThemeのOverworld／Nether／End Link
- End Exit時のBed／Respawn Anchor処理
- BetterStructures内End Portalの接続・帰還先

EliteMobs Instance／Adapter：

- EliteMobs正式Versionと対象Content Package
- 固定World／複製World／一時Worldの判定
- Blueprint World名とInstance World命名規則
- MVI静的登録の可否
- 承認済みBlueprint名限定Regexの書式と適用Timing
- 同時Instance、終了、Restart、再接続、削除時のSmoke Test
- **EMアダプタの必要性判断**
- Adapterが必要な場合の`WorldInstanceEvent`相当生成Event
- Adapterが必要な場合の`InstancedDungeonRemoveEvent`相当削除Event
- MVI APIによるGroup追加／解除方法、Applicable World再計算Timingおよび一時登録の永続化方針
- EliteMobs内部Config／Database／Content Packageを変更しないこと

Permission：

- `elitemobs.user`の正式な子Permission構成
- 明示拒否するTeleport Permission Node
- Guild NPC／Portal／Gateによる正規移動導線
- `/em quit`およびPackage固有退出CommandでのMVI挙動

これらは設計方針の未決ではなく、導入VersionとArtifactに依存する実装Lock項目である。

---

## 18. 実プレイ評価で確定する項目

次の値・採否はConfigまたはContent選定の暫定値として実装し、本流のProject構築チャットで実プレイ結果を基にLockする。単発の感想ではなく、複数回の移動・攻略、WM収支、Server負荷および複数Player時の挙動を記録する。

| 分野 | 実プレイで確認する事項 | 反映先 |
|---|---|---|
| Inventory境界 | MVI Group共有、再接続、死亡、Portal、Admin Teleport、Instance時の安全性 | Multiverse-Inventories Config／受入試験 |
| Portal | 各World Familyの往復先、End Exit、Vehicle／Mob挙動 | Multiverse-NetherPortals Config |
| Resource Pack | Download／Reload時間、Model競合、Theme移動時の体感 | Frontier Pack構成 |
| Worlds Beyond | Hook速度、Launchpad射出、Waystone距離・期間・価格、探索半径 | Worlds Beyond仕様／Config |
| Ruined Frontier | Structure密度、Level Curve、mcMMO影響、死亡損失、Boss難度 | Ruined Frontier仕様／Content Config |
| Economy | EvenMoreFish収益に対するWM支出頻度、残高推移、価格の重さ | Wayfarer_Frontier Config |
| Performance | Chunk生成、Large Structure、Boss、Instance、MVI Profile切替時のTPS／遅延 | Plugin／Content採否 |
| Lifecycle | Persistent運用、Instance削除、将来のReset／Season必要性 | 運用仕様 |

Theme固有の評価項目と暫定値は各Theme仕様書を正とする。

---

## 19. Deferred

- Theme選択GUI
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
6. Multiverse-InventoriesのGroup ConfigをFrontier一般開放前に完成させる。
7. 通常Inventoryの保存・復元および通常World変更はMVIへ委譲し、Wayfarer Pluginへ再実装しない。
8. Frontier Lobbyの初期導線はBeyond GateとGuild Gateの物理Gateとし、Theme選択GUIは後続検討とする。
9. EliteMobs Instanceは、静的登録、厳密Regex、Adapterの順で最小実装を選ぶ。
10. EMアダプタは必要性試験に不合格となった場合だけ実装する。
11. 正常系だけでなく、MVI Group誤設定、Plugin停止、再接続、Restart、Instance終了を検証する。
12. V0.0.4の暫定値はConfigから変更可能にする。
13. 実運用Dataを得た後に価格、期間、生成密度および難易度を調整する。
