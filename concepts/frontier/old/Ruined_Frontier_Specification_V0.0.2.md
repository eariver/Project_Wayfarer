# Project Wayfarer — Ruined Frontier仕様書 V0.0.2

> **状態：設計仕様／実装前**
>
> 本文書は、Frontier Backend上のBetterStructures＋EliteMobs Theme **Ruined Frontier**の導線、World、Inventory、Content、Resource Pack、保護、Progressionおよび受入試験を定義する。
>
> Frontier共通仕様は、[Frontierサーバ仕様書 V0.0.2](./Frontier_Server_Specification_V0.0.2.md)を参照する。
>
> 本文書は、`Project_Wayfarer_Frontier_BS_EM_Configuration_Proposal`を正式なTheme仕様へ再構成したものである。Content Artifactの実物確認が必要な項目は、実装時に最新版を正としてLockする。

---

## 1. Theme名称

正式名称を**Ruined Frontier**とする。

採用理由：

- BetterStructuresの遺跡、地下文明、Temple、Prison、Mine、ShrineおよびMega Dungeonを包括できる。
- EliteMobsによる危険な辺境という体験を直接表現する。
- Adventurer's Guildから探索へ出る導線と自然に結びつく。
- Primisや将来のDungeonを含んでも名称が狭すぎない。
- MainのVanilla寄りBetterStructuresを「日常世界」、Ruined Frontierを「攻略世界」として明確に分離できる。

---

## 2. Theme Concept

Mainでは、BetterStructuresをVanilla寄りの探索要素として使用する。

Ruined Frontierでは、BetterStructuresを次へ発展させる。

- 高難度／大型Structure
- EliteMobs Boss
- Custom Loot
- Quest
- EliteMobs装備Progression
- Shrine
- 可変Dungeon
- Primisによる導入Adventure
- Adventurer's Guildを中心とする攻略導線

中核Loop：

1. Adventurer's GuildでEliteMobs機能を理解する。
2. Primisで装備、Quest、Boss、通貨を学ぶ。
3. 同じGuild InventoryでRuined Frontier三次元へ出る。
4. BetterStructuresの大型遺跡、Shrine、Dungeonを探索する。
5. EliteMobs Bossと戦い、装備およびProgressionを更新する。
6. 高難度DungeonやPremium Contentへ段階的に進む。
7. Mainへ装備を持ち帰らず、移送または換価可能なTheme固有成果をWMへ限定する。mcMMOはNetwork共通Progressionとして別枠で共有する。

---

## 3. 導線

```text
Frontier Lobby
└─ Adventurer's Guild
   ├─ Ruined Frontier Overworld
   │  ├─ Nether Portal → Ruined Frontier Nether
   │  └─ End Portal    → Ruined Frontier End
   ├─ Primis Adventure
   │  └─ Primis付属Dungeon／Instance
   └─ 将来のEliteMobs Dungeon／Adventure
```

Player向け名称と技術World ID：

| Player向け名称 | 技術World ID／管理方法 |
|---|---|
| Frontier Lobby | `frontier_gate` |
| Adventurer's Guild | `adventurers_guild`（Artifact確認後にLock） |
| Ruined Frontier Overworld | `frontier_bs` |
| Ruined Frontier Nether | `frontier_bs_nether` |
| Ruined Frontier End | `frontier_bs_the_end` |
| Primis／Instance | Content Package IDとEliteMobs Instance Registryで管理 |

World IDおよびInventory Group割当の正本はFrontier共通仕様のTheme Registryとし、本書のIDは初期Baselineとして参照する。

要件：

- Adventurer's GuildはFrontier Lobbyの代替ではなく、Ruined Frontier系Content専用Hubである。
- GuildからRuined Frontier Overworldへ安全に入場できる。
- GuildからNether／Endへ直接Gateを設けない。
- Nether／EndへはRuined Frontier OverworldのVanilla Portalを使用する。
- PrimisはRuined Frontier三次元へ混在させず、独立Adventure Worldとする。
- Primis付属Dungeon／InstanceをGuild Inventory Groupへ含める。
- Guildおよび各WorldからFrontier Lobbyへ安全に帰還できる。

---

## 4. World構成

暫定Runtime ID：

```text
adventurers_guild
frontier_bs
frontier_bs_nether
frontier_bs_the_end
primis
```

`frontier_bs*`は技術IDとして維持し、Player向けDisplay NameをRuined Frontierとする。

### 4.1 Generator

初期の暫定第一候補。正式Generatorは実装前Lock項目とする。

| World | Generator |
|---|---|
| Ruined Frontier Overworld | Vanilla Paper Generation＋BetterStructures（暫定） |
| Ruined Frontier Nether | Vanilla Paper Generation＋BetterStructures（暫定） |
| Ruined Frontier End | Vanilla Paper Generation＋BetterStructures（暫定） |
| Adventurer's Guild | EliteMobs Content Package／Imported World |
| Primis | EliteMobs Content Package |
| Instance | EliteMobs Package仕様 |

### 4.2 Seed

- Ruined Frontier三次元は同一World Familyとして固定Seedを使用する。
- Exact Seedは生成タスクで選定する。
- 生成後はSeed、UUID、World名およびPortal Linkを記録する。
- 既存ChunkへStructureをRetrofitしない。
- Region Trim、World削除、再生成は破壊的タスクとして別承認する。

### 4.3 Difficulty

初期値：

| World | Difficulty |
|---|---|
| Ruined Frontier三次元 | `HARD` |
| Adventurer's Guild | `NORMAL`。WorldGuard等で通常Mob Spawn禁止 |
| Primis | Package推奨 |
| Instance | Package推奨 |

Ruined Frontier三次元の目的は危険な攻略であり、Worlds Beyondとの差別化のためHARDをBaselineとする。Adventurer's GuildはGuild GroupのHealth／Foodを共有するためPEACEFULにせず、無料回復地点化を防ぐ。

### 4.4 Portal Family

`Multiverse-NetherPortals`をFrontier Backendへ導入し、Ruined Frontier三次元を明示的なWorld FamilyとしてLinkする。命名規則による自動Linkだけに依存しない。

要件：

- Overworld／Nether間の往復先を明示確認する。
- Stronghold End PortalはRuined Frontier Endへ接続する。
- End Exit PortalはRuined Frontier Overworldへ帰還する。
- BetterStructures内に配置されたEnd Portal Blockも同じWorld Familyへ接続する。
- Portal経由は同一Guild Group内移動として扱い、不要なInventory切替を行わない。
- Mob、Item、VehicleのPortal通過挙動を実機確認する。

---

## 5. Inventory Group

Guild Groupとして次を共有する。

```text
Adventurer's Guild
Ruined Frontier Overworld
Ruined Frontier Nether
Ruined Frontier End
Primis
許可済みPrimis付属Dungeon／Instance
許可済みGuild配下EliteMobs Dungeon
```

共有対象：

- Inventory、Armor、Offhand
- Ender Chest
- Vanilla XP／Level
- Health／Food
- EliteMobs装備
- EliteMobs通貨
- EliteMobs Progression
- Quest Item
- Primis Item
- BS+EM WorldのCustom Loot

分離対象：

- Main
- Frontier Lobby
- Worlds Beyond
- Worlds Beyond Elytra／Hook／Launchpad
- Worlds Beyond Waystone Tool

Primisで得た装備をRuined Frontier三次元で利用できる。Ruined Frontier装備をWorlds BeyondやMainへ持ち込めない。

mcMMOはTheme固有ItemではなくNetwork共通ProgressionとしてMainとFrontierで共有する。Ruined FrontierではSkill、Abilityその他のGameplay効果を有効とし、Mainで蓄積した鍛錬成果による難易度低下を許容する。

Primis付属DungeonおよびEliteMobs Instanceは固定World名だけで管理せず、許可済みContent Package IDとInstance RegistryによりGuild Groupへ動的登録する。未知WorldをPrefix一致だけで自動承認しない。

---

## 6. Plugin構成

初期候補：

```text
Frontier Backend
├─ EliteMobs
├─ BetterStructures
├─ Multiverse-NetherPortals
├─ WorldEdit
├─ WorldGuard
├─ FreeMinecraftModels
├─ ResourcePackManager
├─ BetterHealthBar3
├─ CoreProtect
├─ Wayfarer_Core
└─ Wayfarer_Frontier
```

Content：

```text
BetterStructures Prop Pack（取得済み。実導入時はLicense／Version／Artifactを再確認）
Exploration Pack
Caves and Lost Civilizations Free
Echoes of the Past
Adventure Pack
Free Elite Shrines
Dungeoneering Modules Free
Primis
Adventurer's Guild
```

正式Versionは導入時にPaper 1.21.11／Java 25互換性を確認して固定する。

---

## 7. Plugin適用範囲

### 7.1 BetterStructures

有効：

```text
frontier_bs
frontier_bs_nether
frontier_bs_the_end
```

無効：

```text
frontier_gate
adventurers_guild
primis
許可済みPrimis／EliteMobs Instance
Theme RegistryでRuined Frontier三次元に属さない全World
未知の新規World
```

方針：

- `New worlds spawn structures: false`
- World名の明示的Allowlistを使用する。
- Elite Shrine等の重要GeneratorはGenerator YAML側にも`validWorlds`を設定する。
- World Allowlistを設定してから最初のChunkを生成する。

### 7.2 EliteMobs

有効：

```text
adventurers_guild
frontier_bs
frontier_bs_nether
frontier_bs_the_end
primis
許可済みPrimis付属Dungeon／Instance
許可済みGuild配下EliteMobs Dungeon
```

無効：

```text
frontier_gate
Theme RegistryでGuild Groupに属さない全World
```

許可済みInstanceだけをEliteMobs Instance Registry経由で有効化する。Worlds Beyondでは、Plugin設定とWorldGuardの両方でElite Spawn／Eventを防止する。

---

## 8. BetterStructures Content方針

Mainで採用した103 Default Structuresを全面複製せず、Mainで無効または低Weightにした高難度、大型、高Mob密度Structureを中心にする。

Content Layer：

```text
通常探索・大型遺跡
  Exploration / Caves / Echoes / Adventure

Boss Encounter
  Free Elite Shrines → 101 Premium Shrines

可変大型Dungeon
  Dungeoneering Modules Free → Premium

導入Adventure
  Primis
```

### 8.1 103 Default Structures

初期値：原則無効。

理由：

- Mainで体験できる。
- Ruined Frontierの高難度Structure抽選を希釈しない。
- Themeを危険な辺境として明確化する。

Waypoint、Graveyard等を必要とする場合のみ個別採用を再検討する。

### 8.2 Exploration Pack

攻略施設中心に採用する。

候補：

```text
Overworld:
  flagship
  floatingfortress
  temple
  tower
  undergroundtemple
  bridgecave

Nether:
  floatingfortress
  temple
  tower
  undergroundtemple
  bridgecave
  waterhouse

End:
  bridgecave
  floatingfortress
  temple
  tower
  undergroundtemple
  waterhouse
  watertemplesmall
  well
```

### 8.3 Caves and Lost Civilizations Free

地下攻略中心に採用する。

```text
Overworld:
  flagship
  mines
  ruins
  smalldungeon
  verticalcave
  prison
  circledungeon

Nether:
  mines
  ruins
  smalldungeon
  verticalcave
  prison
  lostlake

End:
  ruins
  mines
  smalldungeon
  verticalcave
  prison
  lostlake
  circledungeon
```

`ruins_end`等の`[elitemobs]` Signを含むStructureは、参照Boss IDが導入Versionで解決できることを確認する。

### 8.4 Echoes of the Past

危険な文明遺跡として採用する。

候補：

```text
dungeon
mobchamber
spawnerroom
dungeontower
crypt
shrine
surfacemine
mines
undergroundmines
```

House／Camp等の生活景観系は必要最小限とする。

### 8.5 Adventure Pack

大型Landmark／高難度施設として採用する。

候補：

```text
dungeontowers
flagship
floatingmansion
largecave
library
mansion
megadungeon
sewers
shrinechamber
undergroundprison
verticaltemple
church
```

Flagship、Mega Dungeon等は低頻度の象徴的発見とする。

### 8.6 Weight

Exact Structure ID、Weight、SeparationおよびDimension条件は、正規取得した最新版Artifactを解析して確定する。

暫定方針：

- Vendor Defaultを出発点とする。
- Mainで使用中の小型Structureを優先的に無効化する。
- Mega Dungeon／Flagshipは通常Structureより低頻度にする。
- ShrineとDungeonが同一Chunk帯へ過密生成されないよう調整する。
- 初期alphaで生成密度、TPSおよび攻略間隔を測定する。
- Artifact固有のWeight単位を確認せず数値を推測しない。

---

## 9. Elite Shrines

### 9.1 alpha

`Free Elite Shrines`を使用する。

確認項目：

- BetterStructuresによるStructure生成
- EliteMobs Boss Spawn
- Boss ID解決
- Region保護
- Loot
- Power／Level
- FreeMinecraftModels Model
- Restart後の整合性

### 9.2 正式候補

`101 Premium Shrines`最新版を正規取得して選別導入する。

方針：

- 友人提供の旧Artifactは内容評価にのみ使用する。
- 実導入へ流用しない。
- 全101件を無条件で有効にしない。
- Dimension、Boss Level、Role、Model、生成密度で選別する。
- Mainへ導入しない。

---

## 10. Dungeoneering Modules

初期導入：

```text
Dungeoneering Modules Free
```

役割：

- Shrineと異なる連結型／可変型Dungeon
- 反復攻略
- Ruined Frontier Endgameの基礎

確認：

- Module連結
- Boss Module依存
- Dimension
- Dungeon規模
- 生成間隔
- Chunk負荷
- Saved Entity／Spawn Signの二重生成
- Restart後の整合性

Free版の安定性と反復感を確認後、Premiumを追加候補とする。

---

## 11. Primis Adventure

PrimisはBetterStructures Content Packではなく、EliteMobsの専用Adventure WorldとしてGuild配下へ配置する。

役割：

- EliteMobs装備の導入
- EliteMobs通貨の導入
- Quest
- NPC
- Boss
- Guild Groupの初期Progression
- Ruined Frontier自由探索前のTutorial

要件：

- Primisを`frontier_bs`へ混在させない。
- Primis付属Dungeon／InstanceをGuild Inventory Groupへ含める。
- 導入Versionの推奨Level帯、依存関係、World名をArtifactから確定する。
- Primis完了をRuined Frontier入場のHard Requirementにするかは初期Playtest後に決定する。
- 初期alphaでは「推奨導線」とし、完全な入場Lockを設けない。

---

## 12. Adventurer's Guild

Adventurer's GuildはRuined Frontier Theme専用Hubである。

提供機能：

- EliteMobs NPC
- 装備／通貨／進行説明
- Primis入口
- Ruined Frontier Overworld入口
- 将来のDungeon Gate
- Quest
- Arena
- Enchant関連機能
- Frontier Lobbyへの帰還

要件：

- Difficultyを`NORMAL`とする。
- WorldGuard等で通常Mob Spawnを禁止する。
- PEACEFUL由来のHealth／Food自動回復地点にしない。
- BetterStructures自然生成を無効にする。
- Guild Inventory Groupへ含める。
- WorldGuardで保護する。
- Playerによる通常建築を禁止する。
- 公開Interactionだけを許可する。
- Content PackageのNPC／Portal座標を導入時に記録する。

---

## 13. EliteMobs Gameplay

### 13.1 Progression

- Primisで初期装備と基本操作を学ぶ。
- Ruined Frontier三次元で自由探索する。
- Shrine、Dungeon、BossからCustom Lootを得る。
- EliteMobs装備とProgressionをGuild Group内で継続する。
- EliteMobsの内部通貨をGuild Group内で使用する。
- MainおよびWorlds Beyondへ装備を持ち出さない。

### 13.2 Boss Level Curve

Exact Level帯は導入するEliteMobsおよびContent Versionを正とする。

初期方針：

- Primis推奨帯を入口にする。
- Free ShrineをPrimis後の標準Boss帯に合わせる。
- Dungeoneering Modulesを中盤以降へ置く。
- Premium Shrine／Oasis／Dark Cathedral等を後続高難度へ置く。
- Gear Skipが起きないよう、Loot LevelとWorld入口を確認する。
- MainのVanilla装備をGuild Groupへ持ち込ませない。
- Network共有mcMMO進行とGameplay効果を有効とし、Mainで蓄積した鍛錬成果による攻略上の優位を許容する。
- mcMMOを理由とする入場制限、Skill無効化またはPlayer別Difficulty補正は行わない。
- Combat Ability、Party Bonus、Skill Proc等による個人差を前提にalphaでLevel Curveを評価し、Content自体が成立しない場合だけ生成密度やBoss帯を調整する。

### 13.3 Spawn

- Ruined Frontier三次元でEliteMobsを有効にする。
- Frontier Lobby／Worlds Beyondで無効にする。
- Guild／PrimisはPackage仕様に従う。
- Boss Region外の過剰Elite SpawnをPlaytestで調整する。
- Spawn Signと保存済みEntityの二重Spawnを確認する。

---

## 14. Resource PackおよびModel

Frontier統合Pack：

```text
FreeMinecraftModels出力
BetterStructures Prop Pack
EliteMobs Models
EliteMobs Prop Pack（採用時）
BetterHealthBar Asset
```

方針：

- ResourcePackManagerをFrontier Backendへ配置する。
- BetterStructures Prop MarkerとFMM Model IDを完全一致させる。
- Mainで使用した正規化工程をFrontier Working Copyにも適用する。
- Primis、Shrine、DungeonごとのPackage手順に従う。
- Model ID、Item Model Component、CustomModelData、Shader、Fontの競合を確認する。
- Pack容量とReload時間を測定する。
- Content Artifactおよび生成PackをGitへ含めない。

---

## 15. BetterHealthBar3

候補方針：

- 公式Sourceの固定CommitからBuildする。
- Commit SHA、Build JDK、Gradle Version、JAR SHA-256を記録する。
- Elite／Bossの残HP視認性を上げる。
- 初期alphaではFrontier Backend全体へ適用して検証する。
- Worlds Beyondの景観を損なう場合、World条件またはAddonでGuild Groupへ限定する。
- Player、NPC、Armor Stand、Display Entity、Invisible／Invulnerable Entityを除外する。
- Custom Model MobとHealth Bar位置を確認する。

正式採用はSource、License、Paper 1.21.11互換性および実機試験後とする。

---

## 16. Deathおよび回収

初期Baseline：

- Ruined Frontier三次元はVanilla Death Drop。
- `keepInventory=false`。
- Primis／InstanceはPackage仕様を優先する。
- ResurrectionChest等はV0.0.2必須としない。
- EliteMobs装備喪失がProgressionを破壊する場合のみ死亡補助を再評価する。
- 死亡補助を導入してもMain／Worlds BeyondへのItem移送経路にしない。

---

## 17. Waymarkおよび成果還元

- WM残高はMainとFrontierで共有する。
- EliteMobs内部通貨はGuild Group固有とする。
- EliteMobs Item、Custom Loot、Quest ItemをMainへ移送しない。
- MainとFrontier間で移送または換価可能なTheme固有成果はWMだけとする。
- mcMMOはTheme固有成果ではなくNetwork共通Progressionとして別枠で共有する。
- alpha初期はRuined FrontierからのWM供給を必須にしない。
- Boss／Quest WM RewardはEvenMoreFishおよびMain Economyの実績を確認して後続設定する。
- Rewardを導入する場合、Vault API経由で付与し、EliteMobs DBまたはRedisを直接変更しない。
- Theme間の装備売却によるWM変換は初期仕様に含めない。

---

## 18. WorldGuardおよび保護

- Elite Shrine／Boss ArenaをWorldGuard連携で保護する。
- 通常探索地域は採掘／破壊可能とする。
- Boss戦中だけ保護するRegionと常設保護を区別する。
- Guildは全体保護する。
- PrimisはPackage仕様を尊重する。
- Worlds Beyond Global RegionでElite Spawn／Eventをdenyする。
- Boss終了後のRegion解除／復元を検証する。
- BuilderへBoss Region管理権限を付与しない。
- Admin操作をAuditする。

---

## 19. CoreProtect

Frontier Backendへ導入する。

方針：

- Adventurer's Guild、Gate、Persistent Ruined Frontier Worldの調査と部分Rollbackに使用する。
- Instance WorldのLog量を評価する。
- 自動生成Structureの大量Logが運用を圧迫しないか確認する。
- CoreProtectをCold Backupの代替にしない。
- RollbackはAdmin限定。
- Content Pluginが行うBlock変更との整合性を確認する。

---

## 20. Wayfarer_Frontier責務

`Wayfarer_Frontier`は、Ruined Frontierに対して次を担当する。

- Theme RegistryをWorld ID／Inventory Group割当の正本として管理
- Guild Group Inventory切替
- `PlayerTeleportEvent`、`PlayerPortalEvent`、`PlayerRespawnEvent`、`PlayerChangedWorldEvent`、Join／Quit／Server Stopを含む境界検査
- Gate入退場
- EliteMobs Instance Registry
- 許可済みPackageのInstance動的登録／解除
- Instance終了時のPlayer退避とInventory保存順序保証
- Theme固有Item漏出防止
- WM Adapter
- 初回案内
- Primis／Ruined Frontier導線表示
- World Allowlist検証
- EliteMobs／BetterStructures Enable状態検証
- Admin Audit
- Theme Lifecycle
- 将来のWM Reward Adapter

直接Teleportおよび権限境界：

- EliteMobsのDungeon直接Teleport、Spawn Teleport等のCross-group権限を一般Playerへ付与しない。
- `/mv tp`その他の管理Teleport権限を一般Playerへ付与しない。
- Primis／Dungeon入口はGuildのNPC、PortalまたはWayfarer管理導線を基本とする。
- Admin TeleportでもInventory Group境界検査を迂回しない。
- 通常運用でOPを使用しない。

担当しない：

- EliteMobs Boss AI
- EliteMobs Loot生成
- BetterStructures Structure生成
- Primis Quest本体
- Dungeoneering Module生成
- FMM Model本体

---

## 21. 追加Content候補

優先順位：

1. Dungeoneering Modules Free
2. Free Elite Shrines
3. Adventurer's Guild
4. Dungeoneering Modules Premium
5. The Oasis
6. The Dark Cathedral
7. 10 Story Mode Dungeons
8. Yggdrasil Realm

| Content | 用途 |
|---|---|
| The Oasis | Primis後の専用Adventure |
| The Dark Cathedral | 単発高難度Dynamic Dungeon、Model／Sound試験 |
| 10 Story Mode Dungeons | 連続Dungeon Campaign |
| Yggdrasil Realm | 高Level Endgame Realm |

初期alphaでContentを広げすぎない。

---

## 22. alpha最小構成

```text
Frontier Lobby
└─ Adventurer's Guild
   ├─ Primis
   └─ Ruined Frontier World Family
      ├─ Overworld
      ├─ Nether
      └─ End
```

購入済みBetterStructures Contentを含むalphaを成立させた後、EliteMobs系Premium Contentを段階追加する。

Plugin／Content：

```text
EliteMobs
BetterStructures
WorldEdit
WorldGuard
FreeMinecraftModels
ResourcePackManager
BetterHealthBar3（採用試験）
CoreProtect
BetterStructures Prop Pack（取得済み。実導入時はLicense／Version／Artifactを再確認）
Exploration Pack
Caves and Lost Civilizations Free
Echoes of the Past
Adventure Pack
Free Elite Shrines
Dungeoneering Modules Free
Primis
Adventurer's Guild
```

正式版候補：

```text
Free Elite Shrines → 101 Premium Shrines最新版へ選別移行
Dungeoneering Modules Premium
EliteMobs Prop Pack
Oasis／個別Dungeon
```

---

## 23. PersistenceおよびReset

初期値：

- Ruined Frontier三次元はPersistent。
- 定期Season Resetなし。
- Structureは新規Chunk生成時に追加する。
- Content更新時に既存Chunkを自動再生成しない。
- Primis／GuildはPackage Worldとして保存する。
- InstanceはPackage Lifecycleに従う。
- Reset／Season制は運用Data取得後の後続検討とする。
- Reset時もEliteMobs Progression、InventoryおよびWMの扱いを別途承認する。

---

## 24. 受入試験

### World隔離

- [ ] BetterStructuresは`frontier_bs`三次元だけで生成される。
- [ ] Worlds Beyond、Guild、Primis、Frontier LobbyでBSが生成されない。
- [ ] EliteMobsはGuild Groupで機能する。
- [ ] Worlds BeyondとFrontier LobbyでElite Spawn／Eventが発生しない。
- [ ] 未知のWorldが自動有効にならない。

### Inventory

- [ ] Guild→Primis→Ruined FrontierでInventoryが共有される。
- [ ] Primis InstanceでもInventory／Progressionが維持される。
- [ ] Guild→Frontier Lobby→Worlds BeyondでGuild Itemが持ち込まれない。
- [ ] Worlds Beyondから戻るとGuild Inventoryが復元される。
- [ ] Ender Chest、XP、Health、Foodが仕様どおり分離される。
- [ ] Item Duplicationが発生しない。

### Portal／World Family

- [ ] Ruined Frontier OverworldからRuined Frontier Netherへ移動する。
- [ ] Ruined Frontier Netherから同じOverworldへ帰還する。
- [ ] Stronghold End PortalはRuined Frontier Endへ接続する。
- [ ] End Exit PortalはRuined Frontier Overworldへ帰還する。
- [ ] BetterStructures内End Portalから正しいWorld Familyへ接続・帰還する。
- [ ] Worlds BeyondとRuined FrontierのPortalが相互接続されない。
- [ ] Portal経由で不要なInventory Group切替が発生しない。
- [ ] Mob、Item、VehicleのPortal通過挙動が許容範囲である。

### Guild

- [ ] GuildはNORMALで動作する。
- [ ] Guild内で通常MobがSpawnしない。
- [ ] Guild滞在だけでPEACEFUL由来の自動回復が発生しない。
- [ ] GuildとRuined Frontier間でHealth／Foodが共有される。

### mcMMO

- [ ] MainとRuined Frontierで同一mcMMO Levelが参照される。
- [ ] Ruined FrontierでmcMMO Skill／Ability効果が有効である。
- [ ] 高Level Playerが有利になることを仕様として許容する。
- [ ] mcMMO共有がInventory Group切替に影響しない。

### Instance

- [ ] 許可済みPackageのInstanceだけがGuild Groupへ登録される。
- [ ] 未知Instance Worldが自動登録されない。
- [ ] Instance終了前にPlayerが安全地点へ退避する。
- [ ] Instance終了時にInventoryが失われない。
- [ ] Restart後に孤立Instanceまたは孤立Inventory Lockが残らない。

### Teleport境界

- [ ] EliteMobs CommandでInventory境界を迂回できない。
- [ ] Multiverse CommandでInventory境界を迂回できない。
- [ ] Admin Teleportでも正しいGroup切替が行われる。
- [ ] Bed／Anchor／End Exit／Void死亡で正しいGroupへ復帰する。
- [ ] Inventory切替失敗時はNeutral GroupへFail-closedする。

### Resource Pack

- [ ] FMM、BS Prop、EliteMobs、Health Barを統合できる。
- [ ] MainとFrontierのBackend切替が正常。
- [ ] Worlds BeyondでModel／Shader競合がない。
- [ ] Pack容量とReload時間が許容範囲。
- [ ] Model IDが欠落／重複しない。

### BetterStructures＋EliteMobs

- [ ] Shrine生成時にBossが正しくSpawnする。
- [ ] 未解決Boss IDがない。
- [ ] Boss Region保護が開始／解除／復元される。
- [ ] Loot／Custom ItemがGuild Group外へ漏れない。
- [ ] Dungeoneering Moduleが正しく連結する。
- [ ] Large Structure生成時のTPSが許容範囲。
- [ ] 保存済みEntityとSpawn Signの二重生成がない。
- [ ] Restart後にBoss／Region／Loot Stateが破損しない。

### Primis／Guild

- [ ] Guild NPC、Portal、Questが正常。
- [ ] Primis導入導線が分かりやすい。
- [ ] PrimisからRuined Frontierへ自然に進める。
- [ ] Level Curveと装備強度がRuined Frontierに適合する。
- [ ] Mainから共有されるmcMMO進行が維持され、EliteMobs Boss MechanicやLootを不当に迂回／重複させない。
- [ ] GuildでBetterStructuresが生成されない。
- [ ] Guild保護を一般Playerが迂回できない。

### BetterHealthBar

- [ ] Elite／BossのHP表示が正常。
- [ ] NPC、Armor Stand、Prop、Display Entityへ誤表示しない。
- [ ] Custom Model Mobと位置がずれない。
- [ ] Worlds Beyondで不要ならWorld制限できる。

### Difficulty／Death

- [ ] Ruined Frontier三次元がHARDで維持される。
- [ ] Vanilla Death Dropが仕様どおり。
- [ ] EliteMobs装備喪失が復帰不能なBalanceにならない。
- [ ] Primis／Instanceの死亡処理がPackage仕様どおり。

---

## 25. 実装前Lock項目

1. EliteMobs正式Version
2. BetterStructures正式Version
3. 正規取得Content Artifact
4. Ruined Frontier Generator
5. Ruined Frontier Seed
6. Runtime World名
7. Primis／Guild実World名
8. EliteMobs Level Curve
9. Free Shrine選別
10. 各PackのStructure ID／Weight
11. Dungeoneering Modules依存
12. Resource Pack Hosting
13. BetterHealthBar3採用
14. EliteMobs Prop Pack購入
15. CoreProtect Instance方針
16. Boss／Quest WM Reward
17. Multiverse-NetherPortals正式Version
18. Ruined Frontier World Family Link
19. End Exit Portalの帰還設定
20. BetterStructures内End Portalの扱い
21. EliteMobs Instance World命名規則
22. Instance生成／終了の検出方法
23. Guild Inventory Groupへの動的登録方法
24. Instance削除時のPlayer退避先
25. InstanceのCoreProtect／Backup対象範囲
26. Reset／Season方針

これらはV0.0.2仕様を破棄する未決事項ではなく、ArtifactおよびRuntime依存の実装Lock項目である。

---

## 26. 実プレイ評価で確定する項目

次の項目は導入Artifactの静的確認だけでは確定せず、本流のProject構築チャットで実プレイ結果を基にLockする。各項目はConfigまたはContent選別で変更可能にし、初期alphaの記録を残す。

| 分野 | 暫定方針 | 実プレイで確認する内容 |
|---|---|---|
| Structure密度 | Pack別候補を低～中密度で開始 | 発見頻度、連続生成、景観破壊、移動時間、Chunk生成負荷 |
| Structure選別 | 大型・高難度中心 | Mainとの差別化、単調さ、攻略価値、未解決Boss ID |
| Primis導線 | 推奨だがHard Lockなし | Tutorial理解度、所要時間、Ruined Frontierへの移行の自然さ |
| Boss Level Curve | Primis→Shrine→Module | Solo／複数Player、mcMMO高低差、装備更新速度、Gear Skip |
| Elite Spawn | Guild Groupで有効 | 通常探索時の密度、Boss以外の圧迫感、Server負荷 |
| Loot／Progression | EliteMobs標準を基準 | 装備更新頻度、死亡後の復帰可能性、内部通貨の余剰／不足 |
| Difficulty／Death | HARD＋Vanilla Drop | 理不尽さ、装備喪失による離脱、ResurrectionChest等の必要性 |
| mcMMO | Gameplay効果を許容 | 高Level Playerの優位がContentを無意味化しないか、調整要否 |
| Guild | NORMAL＋Mob Spawn禁止 | 無料回復化していないか、NPC／Portal導線、滞在性 |
| BetterHealthBar3 | alphaで試験 | Boss視認性、Modelずれ、Worlds Beyondへの影響、適用World |
| Resource Pack | Frontier統合Pack | Reload時間、容量、Model／Font／Shader競合、Client安定性 |
| Performance | Persistent三次元 | Large Structure、Boss、Dungeon、Instance時のTPS／Memory |
| Instance Lifecycle | Registryで動的管理 | 生成・退出・再接続・Restart・削除時のInventory安全性 |
| Portal | 明示Link | End Exit、BS内End Portal、Vehicle／Mob挙動、誤接続 |
| WM Reward | alphaでは必須でない | 実際の攻略時間とEvenMoreFish収益を比較した報酬導入要否 |
| Reset／Season | 初期Persistent | 探索済み範囲、Content枯渇、World容量を観測して再検討 |

実プレイ評価で変更した値は、採用理由、試験条件、Player数、装備帯および測定値とともに記録する。

---

## 27. 実装時の原則

1. 友人提供の有料Artifactを実導入しない。
2. 有料Contentは最新版を正規取得する。
3. Content ZIP、Schematic、Model、JARをGitへ含めない。
4. Version、SHA、取得元、Licenseおよび手動導入手順を記録する。
5. World Allowlistを設定してからChunk生成する。
6. Main、Worlds Beyond、Guild間のItem漏出を最優先で試験する。
7. 購入済みBetterStructures Contentを含むalphaを成立させた後、EliteMobs系Premium Contentを追加する。
8. 難度、生成密度、Level Curveを実測して調整する。
9. EliteMobs／BetterStructuresのDBや内部FileをWayfarer Pluginから直接変更しない。
10. World削除、Trim、Resetは独立した破壊的タスクとして扱う。
