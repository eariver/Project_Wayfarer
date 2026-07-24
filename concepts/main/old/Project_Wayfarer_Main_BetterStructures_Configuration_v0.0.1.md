# Project Wayfarer — Main BetterStructures構成案 v0.0.1

## 0. 文書の位置付け

この文書は、Project Wayfarer本流チャットへ渡すための **Main Backend向けBetterStructures構成選定結果** である。

- 選定基準は、Phase 2B引継ぎ文書を優先する。
- Mainは「恒久生活World＋Vanilla寄りのBetterStructures入門編」とする。
- Frontierの`BetterStructures + EliteMobs`本格攻略Worldへ自然につながる導入体験を目指す。
- 本文書は構成方針と実装入力を定義するが、World再生成・Runtime変更・Repository変更を単独では承認しない。
- 実プレイ上の生成密度、難度、景観はalphaで確認し、Weightを調整する。

---

## 1. 結論

Mainには、次の5 Content PackをDimension・Structure単位で選別導入する。

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack（購入Artifact内部 version 1）
Echoes of the Past version 3
```

視覚拡張として以下を導入する。

```text
BetterStructures Prop Pack
FreeMinecraftModels 2.10.2
ResourcePackManager
```

Mainの位置付けは次のとおり。

```text
生活・建築・長期滞在
＋
Vanilla Item／Vanilla Mob中心のStructure探索
＋
Frontier BS+EM Worldに向けた探索・攻略の導入
```

Custom Boss、Custom Equipment、EliteMobs進行はMainへ持ち込まず、Frontier側に残す。

---

## 2. 確認済みArtifact

| Artifact                          | 内部Version | Schematic数 | SHA-256                                                            |
| --------------------------------- | ----------: | ----------: | ------------------------------------------------------------------ |
| 103 Default Structures            |           5 |         103 | `118D873FDF87BF94EA6CA3036897B10790F5D73E62F8387E75C1AB6A4A360FE0` |
| Exploration Pack                  |           6 |          49 | `963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B` |
| Caves and Lost Civilizations Free |           2 |          49 | `27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677` |
| Adventure Pack（購入版）          |           1 |         107 | `96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C` |
| Echoes of the Past（購入版）      |           3 |         122 | `B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F` |
| BetterStructures Prop Pack        |           — |   55 models | `F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D` |
| FreeMinecraftModels JAR           |      2.10.2 |           — | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` |

Adventureの販売ページ上のRelease表記と、Artifact内`content_packages/adventure_pack.yml`の`version: 1`は一致しない可能性がある。Import判定ではArtifact内部値を正とする。

有料Artifact、Schematic、Prop Model、Plugin JARはGitへ含めず、手動取得・非追跡とする。

---

## 3. 対象World

BetterStructuresを有効にするWorldは、恒久Main Familyのみとする。

```text
main
main_nether
main_the_end
```

無効にするWorld：

```text
resource
resource_nether
resource_end
その他の未知World
```

`plugins/BetterStructures/ValidWorlds.yml`では次を維持する。

```yaml
New worlds spawn structures: false

Valid worlds:
  main: true
  main_nether: true
  main_the_end: true
  resource: false
  resource_nether: false
  resource_end: false
```

---

## 4. 選定規模

選定後の有効Schematic数は次のとおり。Biome Palette、洞窟Variant、方向差分を個別Schematicとして数える。

| Dimension | Default | Exploration |  Caves |  Echoes | Adventure |    合計 |
| --------- | ------: | ----------: | -----: | ------: | --------: | ------: |
| Overworld |      67 |          20 |     24 |      72 |        16 | **199** |
| Nether    |      18 |           4 |      5 |      16 |         5 |  **48** |
| End       |      18 |           8 |      7 |      15 |        10 |  **58** |
| **合計**  | **103** |      **32** | **36** | **103** |    **31** | **305** |

この数は生成密度が305倍になることを意味しない。同じGenerator／Structure Type内の候補が増え、生成時の選択肢が多様化する。生成間隔自体はGenerator設定によって決まる。

---

## 5. Weightの意味

各Structure YAMLの`weight`は、同一候補群内での相対選択確率として扱う。

|             Weight | Mainでの意味                               |
| -----------------: | ------------------------------------------ |
|              `1.0` | 標準的な景観物、生活系、小～中規模探索     |
|          `0.5–0.8` | 軽～中規模の攻略施設、比較的大きな遺跡     |
|         `0.25–0.4` | 高Mob密度、大型施設、Portal付き施設        |
|         `0.08–0.2` | 非常に稀な巨大Landmark                     |
| `isEnabled: false` | Mainでは不使用。Frontier候補または重複過多 |

初期Weightはalpha用の仮値であり、生成頻度・報酬量・発見間隔に応じて調整する。

---

# 6. Dimension別構成

## 6.1 Overworld

### 6.1.1 103 Default Structures

全67件を有効、`weight: 1.0`のままとする。

役割：

- 小～中規模の景観物
- 地表、空中、水面、地下の基本的な発見
- BetterStructuresの基礎体験
- Vanilla Structure間の空白を補完

### 6.1.2 Exploration Pack

| Internal ID pattern                               | Variant                             | Weight | 判断                                          |
| ------------------------------------------------- | ----------------------------------- | -----: | --------------------------------------------- |
| `betterstructures_exploration_bridgecave_*`       | `deep, dripstone, lush, shallow`    |  `1.0` | 洞窟景観と軽い探索。Caves系と競合しすぎない   |
| `betterstructures_exploration_waterhouse_*`       | `barren, desert, grassland, tundra` |  `1.0` | 水辺の生活・廃屋景観                          |
| `betterstructures_exploration_tower_*`            | `barren, desert, grassland, tundra` |  `0.4` | 高さのあるLandmark。LootとMobが多いため低頻度 |
| `betterstructures_exploration_temple_*`           | `barren, desert, grassland, tundra` |  `0.3` | Vanilla Mob中心の中規模攻略                   |
| `betterstructures_exploration_floatingfortress_*` | `barren, desert, grassland, tundra` | `0.15` | 空中要塞。Container数が多いため稀にする       |

Mainでは無効：

```text
flagship_grassland
undergroundtemple_{deep,dripstone,lush,shallow}
watertemplesmall_{barren,desert,grassland,tundra}
well_{barren,desert,grassland,tundra}
```

理由：FlagshipはMainには過大、Underground Templeは高Mob密度、Small Water TempleはOcean Monumentの役割と競合、WellはDefaultと重複する。

### 6.1.3 Caves and Lost Civilizations Free

| Internal ID pattern                         | Variant                         | Weight | 判断                                |
| ------------------------------------------- | ------------------------------- | -----: | ----------------------------------- |
| `bs_lostcivilizations_free_crystalcave_*`   | `deep, dripstone, lush, normal` |  `1.0` | 景観中心。洞窟探索の主要補完        |
| `bs_lostcivilizations_free_lostlake_*`      | `deep, dripstone, lush, normal` |  `0.8` | 地下湖・遺跡。探索と生活景観に適合  |
| `bs_lostcivilizations_free_circledungeon_*` | `deep, dripstone, lush, normal` |  `0.6` | 小～中規模Vanilla Dungeon           |
| `bs_lostcivilizations_free_prison_*`        | `deep, dripstone, lush, normal` |  `0.5` | 廃監獄。中程度の戦闘                |
| `bs_lostcivilizations_free_verticalcave_*`  | `deep, dripstone, lush, normal` | `0.35` | 縦穴Landmark。Mob数が多いため低頻度 |
| `bs_lostcivilizations_free_ruins_*`         | `deep, dripstone, lush, normal` |  `0.2` | 大型の失われた文明。稀な地下発見物  |

Mainでは無効：

```text
flagship_normal
mines_{deep,dripstone,lush,normal}
smalldungeon_{deep,dripstone,lush,normal}
```

理由：FlagshipはContainer 200超、MinesとSmall Dungeonは戦闘密度が高く、Frontier側に適する。

### 6.1.4 Echoes of the Past

#### Weight 1.0：生活・景観・文明痕跡

```text
barn_{barren,desert,grassland,tundra}
camp_{barren,desert,grassland,tundra}
farmland_{barren,desert,grassland,tundra}
house_{barren,desert,grassland,tundra}
islandbig_{barren,desert,grassland,tundra}
islandsmall_{barren,desert,grassland,tundra}
seatemple_{acacia,desert,grassland,tundra}
statue_{barren,desert,grassland,tundra}
tower_{barren,desert,grassland,tundra}
wall_{barren,desert,grassland,tundra}
undergroundmines2_{deep,shallow}
```

すべて`betterstructures_echoes_`をPrefixとする。

#### 軽～中規模探索

| Concept            | Variant                             | Weight |
| ------------------ | ----------------------------------- | -----: |
| `crypt`            | `barren, desert, grassland, tundra` |  `0.6` |
| `dungeontower`     | `barren, desert, grassland, tundra` |  `0.6` |
| `shrine`           | `barren, desert, grassland, tundra` |  `0.7` |
| `surfacemine`      | `barren, desert, grassland, tundra` |  `0.6` |
| `temple`           | `barren, desert, grassland, tundra` |  `0.7` |
| `undergroundmines` | `deep, shallow`                     |  `0.5` |
| `spawnerroom`      | `barren, desert, grassland, tundra` |  `0.5` |
| `mines`            | `barren, desert, grassland, tundra` | `0.15` |

Mainでは無効：

```text
dungeon_{barren,desert,grassland,tundra}
mobchamber_{barren,desert,grassland,tundra}
```

理由：高Mob密度・複数SpawnerでFrontier寄り。

### 6.1.5 Adventure Pack

| Internal ID pattern                        | Variant                             | Weight | 判断                                   |
| ------------------------------------------ | ----------------------------------- | -----: | -------------------------------------- |
| `betterstructures_adventure_ship_*`        | `barren, desert, grassland, tundra` |  `0.6` | 水上の大型船。比較的自然な探索Landmark |
| `betterstructures_adventure_church_*`      | `barren, desert, grassland, tundra` | `0.35` | 廃教会。Echoesの遺跡群と調和           |
| `betterstructures_adventure_portalroom_*`  | `deep, dripstone, lush, shallow`    | `0.35` | 地下の神秘的施設                       |
| `betterstructures_adventure_cloudisland_*` | `barren, desert, grassland, tundra` |  `0.2` | 空中Landmark。Frontierの予告編         |

その他のOverworld Adventure StructureはMainで無効とする。巨大Dungeon、Mansion、Flagship等はFrontier候補。

---

## 6.2 Nether

### 6.2.1 103 Default Structures

全18件を有効、`weight: 1.0`のままとする。

### 6.2.2 Exploration Pack

| Internal ID                                            | Weight | 判断                                         |
| ------------------------------------------------------ | -----: | -------------------------------------------- |
| `betterstructures_exploration_bridgecave_nether`       |  `1.0` | 地下橋梁。既存Nether Structureと役割が異なる |
| `betterstructures_exploration_waterhouse_nether`       |  `1.0` | 溶岩面の中規模建築                           |
| `betterstructures_exploration_floatingfortress_nether` |  `0.5` | 空中攻略拠点                                 |
| `betterstructures_exploration_tower_nether`            | `0.35` | 溶岩海上の巨大塔                             |

その他4件は無効。

### 6.2.3 Caves and Lost Civilizations Free

| Internal ID                                      | Weight | 判断                      |
| ------------------------------------------------ | -----: | ------------------------- |
| `bs_lostcivilizations_free_crystalcave_nether`   |  `1.0` | Nether地下景観            |
| `bs_lostcivilizations_free_circledungeon_nether` |  `0.6` | 小規模攻略                |
| `bs_lostcivilizations_free_lostlake_nether`      |  `0.5` | 地下湖・Spawner付き発見物 |
| `bs_lostcivilizations_free_prison_nether`        |  `0.4` | 中規模戦闘施設            |
| `bs_lostcivilizations_free_ruins_nether`         |  `0.2` | 大型地下遺跡              |

無効：`mines_nether`, `smalldungeon_nether`, `verticalcave_nether`。

### 6.2.4 Echoes of the Past

#### Weight 1.0

```text
camp_nether
islandbig_nether
islandsmall_nether
seatemple_nether
tower_nether
wall_nether
undergroundmines2_nether
```

#### その他

| Concept                   | Weight |
| ------------------------- | -----: |
| `crypt_nether`            |  `0.6` |
| `dungeontower_nether`     |  `0.6` |
| `shrine_nether`           |  `0.7` |
| `statue_netherland`       |  `0.6` |
| `temple_netherland`       |  `0.7` |
| `undergroundmines_nether` |  `0.5` |
| `spawnerroom_nether`      |  `0.4` |
| `surfacemine_nether`      |  `0.4` |
| `mines_nether`            |  `0.1` |

すべて`betterstructures_echoes_`をPrefixとする。

無効：`barn_nether`, `farmland_nether`, `house_nether`, `dungeon_nether`, `mobchamber_nether`。

`mines_nether`にはAncient Debrisが含まれるが、Main Netherは再生成されない有限探索Worldであり、Weight 0.1の大当たりStructureとして許容する。

### 6.2.5 Adventure Pack

| Internal ID                                          | Weight | 判断             |
| ---------------------------------------------------- | -----: | ---------------- |
| `betterstructures_adventure_ship_nether`             |  `0.6` | 溶岩海の船       |
| `betterstructures_adventure_cloudisland_nether`      | `0.35` | 空中拠点         |
| `betterstructures_adventure_largewatertemple_nether` | `0.35` | 溶岩面の大型建築 |
| `betterstructures_adventure_verticaltemple_nether`   | `0.35` | 地下縦型施設     |
| `betterstructures_adventure_floatingmansion_nether`  | `0.15` | 稀な大型Landmark |

その他13件はMainで無効。

---

## 6.3 End

Endでは「空虚さを残しつつ、長距離探索で文明痕跡・攻略施設・帰還設備を発見できる」状態を目指す。

End Portal Blockを含むStructureは原則として除外しない。実際に帰還Portalとして機能する場合、遠方からOverworldへ帰る一方向の利便設備として評価する。ただし誤接触しやすい構造はalphaで確認する。

### 6.3.1 103 Default Structures

全18件を有効、`weight: 1.0`のままとする。

### 6.3.2 Exploration Pack

| Internal ID                                          | Weight | 主な役割               |
| ---------------------------------------------------- | -----: | ---------------------- |
| `betterstructures_exploration_bridgecave_end`        | `0.35` | Portal床を持つ地下橋梁 |
| `betterstructures_exploration_floatingfortress_end`  |  `0.5` | 空中要塞               |
| `betterstructures_exploration_temple_end`            |  `0.4` | 地表攻略施設           |
| `betterstructures_exploration_tower_end`             |  `0.5` | 塔・帰還Portal         |
| `betterstructures_exploration_undergroundtemple_end` |  `0.3` | 高Mob密度の地下寺院    |
| `betterstructures_exploration_waterhouse_end`        |  `0.7` | 中規模空中建築         |
| `betterstructures_exploration_watertemplesmall_end`  |  `0.7` | 小規模空中寺院         |
| `betterstructures_exploration_well_end`              |  `0.8` | 小型発見物・帰還Portal |

### 6.3.3 Caves and Lost Civilizations Free

| Internal ID                                   | Weight | 主な役割                |
| --------------------------------------------- | -----: | ----------------------- |
| `bs_lostcivilizations_free_circledungeon_end` |  `0.5` | 円形Dungeon             |
| `bs_lostcivilizations_free_crystalcave_end`   |  `0.8` | Crystal景観・探索       |
| `bs_lostcivilizations_free_lostlake_end`      |  `0.5` | 地下湖・帰還Portal      |
| `bs_lostcivilizations_free_mines_end`         | `0.35` | 地下坑道・Spawner       |
| `bs_lostcivilizations_free_prison_end`        |  `0.5` | End監獄                 |
| `bs_lostcivilizations_free_smalldungeon_end`  |  `0.4` | 小型Dungeon・帰還Portal |
| `bs_lostcivilizations_free_verticalcave_end`  | `0.35` | 縦穴Landmark            |

無効：`bs_lostcivilizations_free_ruins_end`。

理由：16個の`[elitemobs]` Spawn Signを含み、MainにはEliteMobsを導入しないため。Frontierで再評価する。

### 6.3.4 Echoes of the Past

| Internal ID                                     | Weight | 主な役割                        |
| ----------------------------------------------- | -----: | ------------------------------- |
| `betterstructures_echoes_islandbig_end`         |  `0.5` | 大型浮島・帰還Portal            |
| `betterstructures_echoes_islandsmall_end`       |  `0.6` | 小型浮島・帰還Portal            |
| `betterstructures_echoes_mines_end`             | `0.25` | 地表鉱山・帰還Portal            |
| `betterstructures_echoes_undergroundmines2_end` |  `0.3` | 地下鉱山・大規模帰還Portal      |
| `betterstructures_echoes_crypt_end`             |  `0.5` | 墓所                            |
| `betterstructures_echoes_dungeontower_end`      |  `0.5` | 攻略塔                          |
| `betterstructures_echoes_shrine_end`            |  `0.7` | 小型祠                          |
| `betterstructures_echoes_statue_end`            |  `0.8` | 文明痕跡                        |
| `betterstructures_echoes_surfacemine_end`       |  `0.5` | 採掘施設                        |
| `betterstructures_echoes_tower_end`             |  `0.7` | 小型Landmark                    |
| `betterstructures_echoes_undergroundmines_end`  |  `0.6` | 地下探索                        |
| `betterstructures_echoes_spawnerroom_end`       |  `0.5` | 小規模戦闘室                    |
| `betterstructures_echoes_temple_end`            |  `0.6` | 小型寺院・帰還Portal            |
| `betterstructures_echoes_wall_end`              |  `0.8` | 遺構景観                        |
| `betterstructures_echoes_seatemple_end`         | `0.25` | 空中寺院。Mob数が多いため低頻度 |

Main Endでは無効：

```text
barn_end
camp_end
farmland_end
house_end
dungeon_end
mobchamber_end
```

日常的なOverworld建築はEndの異質感を弱めるため除外し、高密度Dungeon／Mob ChamberはFrontierへ送る。

### 6.3.5 Adventure Pack

| Internal ID                                      | Weight | 主な役割                                    |
| ------------------------------------------------ | -----: | ------------------------------------------- |
| `betterstructures_adventure_flagship_end`        | `0.08` | 極めて稀な巨大Flagship。Endの象徴的Landmark |
| `betterstructures_adventure_ship_end`            | `0.45` | 中型飛行船                                  |
| `betterstructures_adventure_cloudisland_end`     | `0.35` | 浮島・帰還Portal                            |
| `betterstructures_adventure_dungeontowers_end`   |  `0.2` | 多層攻略塔                                  |
| `betterstructures_adventure_megadungeon_end`     | `0.15` | 大型地下攻略施設                            |
| `betterstructures_adventure_portalroom_end`      | `0.25` | 大型帰還Portal施設                          |
| `betterstructures_adventure_sewers_end`          | `0.15` | 地下遺構・帰還Portal                        |
| `betterstructures_adventure_floatingmansion_end` | `0.15` | 稀な空中邸宅                                |
| `betterstructures_adventure_verticaltemple_end`  | `0.15` | 高難度縦型寺院                              |
| `betterstructures_adventure_shrinechamber_end`   |  `0.4` | 中規模祠                                    |

その他8件はMain Endで無効。Mainでは大型Structureを少数に絞り、Adventure Packを「低確率の大発見」に限定する。

---

# 7. Prop／Resource Pack構成

## 7.1 構成

```text
Main Backend
├─ BetterStructures 2.6.3
├─ WorldEdit 7.4.4
├─ FreeMinecraftModels 2.10.2
├─ ResourcePackManager
├─ BetterStructures Prop Pack（55 models）
└─ 選定済みStructure Content Packs
```

MainではResource Packを必須配信として扱う。MainとFrontierはBackend別の独立Packとし、Backend移動時のReloadは許容する。

## 7.2 Prop ID正規化

FreeMinecraftModels 2.10.2は`.bbmodel`ファイル名由来のModel IDを完全一致で解決する。旧PrefixなしIDは自動変換されない。

確認済み状態：

| Pack            | Prop Marker | 未解決状態                       |
| --------------- | ----------: | -------------------------------- |
| Default         |         214 | すべて一致                       |
| Exploration     |         116 | 全件が旧PrefixなしID。正規化必須 |
| Caves Free      |         195 | `alchamytable` 1件               |
| Adventure購入版 |         340 | `alchamytable`, `shelf4` 各1件   |
| Echoes購入版    |         260 | `ladder` 1件                     |

実装方針：

1. 購入・配布Artifact原本をRead-onlyで保存する。
2. Runtime Import用Working Copyを作る。
3. Adventure同梱`script.py`相当のMappingで旧IDを`bs_prop_pack_*`へ変換する。
4. `alchamytable`は`bs_prop_pack_alchemy_table`へ修正する。
5. `shelf4`と`ladder`は周辺構造を確認し、適切な既存Modelへ明示Mappingする。
6. 変換済みArtifactはGitへCommitせず、生成手順・Hash・Mappingのみ文書化する。

## 7.3 権限

Mainでは家具ShopやPlayer設置機能を使用しない。

```text
freeminecraftmodels.menu = false
freeminecraftmodels.shop = false
```

管理権限はTemporary Adminに限定する。

---

# 8. 既知の技術確認事項

## 8.1 Schematic内通常Entity

購入版Adventure／Echoes等には、Prop Armor Stand以外のZombie、Bat、Skeleton等が保存されているものがある。

BetterStructures 2.6.3のEntity Paste処理はメソッド名上はArmor Stand限定だが、WorldEditへ`copyEntities(true)`を渡しており、通常EntityもPasteされる可能性がある。

alphaで確認すること：

- Prop Armor Standだけが生成されるか
- 保存済み通常Entityも生成されるか
- Spawn Signと二重にMobが生成されないか
- 不要なProjectile／Mobが永続化しないか
- Mob密度・TPSへの影響

## 8.2 旧Schematic形式

選定対象にはSponge Schematic v2／DataVersion 2865が11件含まれる。

主な対象：

```text
Default: cistern_nether
Exploration: watertemplesmall_end
Adventure: largewatertemple_nether
Echoes: Sea Temple各種、tower_desert、temple_desert
```

WorldEdit 7.4.4でのBlock変換、Container、Spawner、Prop位置を代表確認する。

## 8.3 End Portal

Portalを含むStructureは原則採用する。以下を受入試験する。

- Paste後にPortalとして機能するか
- 帰還先がMain OverworldのBed／World Spawnか
- 誤接触が過度に不快でないか
- Mob、Item、Vehicleの転送挙動
- 大面積PortalによるChunk／Client描画問題

## 8.4 Loot

Chest／BarrelはBetterStructures GeneratorのTreasure設定から実行時に充填される。固定Custom ItemやCommand Rewardは確認されていない。

導入時に実Runtimeの`generators/`と`treasures/`を確定し、次を確認する。

- Container数が多いStructureの総報酬
- Barrel Loot
- Diamond／Netherite系の出現率
- Adventure Flagship等の報酬過多

---

# 9. World再生成

Phase 2B引継ぎ方針を優先し、追加Pack導入後は恒久Main Familyを再生成して、探索済みChunkと未探索Chunkの世代差を避ける。

```text
main: 再生成候補
main_nether: 再生成候補
main_the_end: 再生成候補
```

実行前に本流チャットで破壊的タスクとして別途承認する。

必須確認：

- Exact Runtime Path
- Seed
- World UUID
- Backup／Rollback
- Player Data
- Spawn再選定
- Multiverse登録
- Nether／End Link
- Resource Family除外
- BetterStructures Import状態
- Prop／Resource Pack状態
- 既存Phase 3 Baselineの置換

推奨Roadmap順：

```text
Phase 2B Content選定・Config生成
↓
Persistent Main Family再生成
↓
受入試験／alpha
↓
CoreProtect
↓
Playable Frontier Theme
```

---

# 10. alpha受入試験

## 起動・Import

- [ ] BetterStructuresが全5 Packを認識する
- [ ] 有料ArtifactはGit非追跡
- [ ] 全YAMLの`isEnabled`／`weight`が選定表どおり
- [ ] 未知Worldが自動有効化されない
- [ ] Resource FamilyでStructureが生成されない

## Resource Pack／Prop

- [ ] ResourcePackManagerがMain Packを配信する
- [ ] Clientが拒否した場合の扱いを確認する
- [ ] Default／Exploration／Caves／Echoes／AdventureのPropが表示される
- [ ] 未解決Model IDがLogに残らない
- [ ] Main→Lobby→Frontier→MainでPackが正しく切り替わる

## Structure

- [ ] 各Pack／Dimension／Structure Typeを最低1件生成確認
- [ ] v2 Schematic代表を確認
- [ ] Container Lootを確認
- [ ] Spawnerを確認
- [ ] 通常Entityの二重生成を確認
- [ ] End Portalの帰還挙動を確認
- [ ] 大型Structureの地形Fitを確認
- [ ] Spawn Protection 100 blocks内に生成されない

## プレイ感

- [ ] Overworldの生活景観が過密でない
- [ ] Nether Fortress／Bastionの価値を損なわない
- [ ] Endの空虚さを残せている
- [ ] MainがFrontierの予告編として機能する
- [ ] Adventure大型建築が頻繁すぎない
- [ ] Loot量が過剰でない
- [ ] TPS、Chunk生成時間、Client FPSに問題がない

---

# 11. Repositoryへ反映する情報

Gitで管理する：

- Plugin Version／SHA
- Content Pack名称／Version／SHA
- Manual Download URLまたは取得手順
- License／Redistribution禁止事項
- `ValidWorlds.yml`
- 選定済みYAMLのConfig値、または再現可能な生成Script
- Prop ID Mapping
- Runtime受入試験結果
- World再生成Baseline

Gitへ含めない：

- 有料ZIP
- `.schem`
- `.bbmodel`
- Plugin JAR
- 変換済み有料Artifact
- 生成済みResource Pack Binary

---

# 12. 本流チャットでの次タスク

1. 選定表からConfig生成方式を決める。
2. Prop Marker正規化Scriptを作る。
3. Main BackendへFMM／ResourcePackManagerを導入する。
4. Content Packを手動Importする。
5. 選定Configを適用する。
6. 恒久Main Family再生成タスクを設計・承認する。
7. alpha受入試験を実施する。
8. Weightを調整し、Phase 2Bを完了判定する。
