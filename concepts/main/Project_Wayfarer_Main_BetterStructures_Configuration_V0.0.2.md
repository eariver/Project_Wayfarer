# Project Wayfarer — Main BetterStructures構成案 V0.0.2

> **状態：構成選定仕様／実装前**
>
> 本文書は、Project WayfarerのMain Backendへ導入するBetterStructures Content、Structure選別、Weight、World適用範囲、Resource Pack、Portal Familyおよび受入試験を定義する。
>
> Frontier側の正本：
>
> - `Frontier_Server_Specification_V0.0.3.md`
> - `Ruined_Frontier_Specification_V0.0.3.md`
> - `Worlds_Beyond_Specification_V0.0.3.md`
>
> 本文書のVersionは設計文書の改訂番号であり、稼働ServerのRelease番号ではない。

---

## 0. V0.0.2の変更概要

旧文書`Project_Wayfarer_Main_BetterStructures_Configuration_v1.md`を、Frontier V0.0.3の確定方針へ整合させた。

主な変更：

1. 文書Version表記を`V0.0.2`へ統一した。
2. 旧称「Frontier BS+EM World」を正式名称**Ruined Frontier**へ置換した。
3. MainとRuined Frontierの役割分担を明確化した。
4. Main End／Netherから、Ruined Frontierの象徴とする大型・高Mob密度Structureを一部除外した。
5. 有効Schematic数を305件から278件へ縮小した。
6. Main BackendのPersistent Family／Resource Family Portal Linkを明記した。
7. MainとFrontierのInventory、Waymark、mcMMO、Resource Pack境界を明記した。
8. End内のBetterStructures PortalをMain Familyへ帰還させる受入試験を追加した。

構成方針の変更であり、Runtime変更、World再生成、Repository変更またはContent Importを単独で承認するものではない。

---

## 1. Mainの位置付け

Mainは、Project Wayfarerの恒久生活Worldである。

中核体験：

```text
恒久生活・建築・経済
＋
Vanillaに馴染む景観と文明痕跡
＋
Vanilla Mob／Vanilla Loot中心の軽～中規模Structure探索
＋
Ruined Frontierへ進む前のBetterStructures導入体験
```

Mainへ導入しないもの：

- EliteMobs
- Elite Shrine
- Dungeoneering Modules
- Custom Boss
- EliteMobs装備／通貨／Quest
- Ruined Frontier固有Item
- Frontier Theme固有Item

MainとRuined Frontierの役割：

| 項目             | Main                             | Ruined Frontier                         |
| ---------------- | -------------------------------- | --------------------------------------- |
| 主目的           | 生活、建築、長期滞在、軽い探索   | 攻略、Boss、Quest、装備Progression      |
| Difficultyの意味 | Vanilla生活Worldとしての通常危険 | HARDを前提とする攻略World               |
| BetterStructures | 景観、生活跡、軽～中規模遺跡     | 大型、高Mob密度、Shrine、Dungeon        |
| Mob              | Vanilla Mob                      | Vanilla Mob＋EliteMobs                  |
| Loot             | Vanilla系                        | EliteMobs Custom Lootを含む             |
| Progression      | Vanilla／mcMMO／Main Economy     | EliteMobs Progression＋Network共有mcMMO |
| Inventory        | Main Local                       | Guild Group                             |
| Resource Pack    | Main専用Pack                     | Frontier統合Pack                        |

同一ConceptのStructureが両方に存在すること自体は禁止しない。ただし、Mainでは低Weight、Vanilla戦闘、景観寄りとし、Flagship、Mega Dungeon、Dungeon Towers等の象徴的な大型攻略施設はRuined Frontierへ優先的に残す。

---

## 2. 結論

Mainには次の5 Content Packを、Dimension・Structure単位で選別導入する。

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack（購入Artifact内部 version 1）
Echoes of the Past version 3
```

視覚拡張：

```text
BetterStructures Prop Pack
FreeMinecraftModels 2.10.2
ResourcePackManager
```

MainではCustom BossやCustom Equipmentを使用しない。

---

## 3. Runtimeおよび確認済みArtifact

### 3.1 Main Runtime Baseline

| Component                        | Baseline                 |
| -------------------------------- | ------------------------ |
| Main Backend                     | Paper 26.2 build 62      |
| Java                             | 25.0.3 LTS               |
| BetterStructures                 | 2.6.3                    |
| WorldEdit                        | 7.4.4                    |
| Multiverse-Core                  | 5.7.2                    |
| Multiverse-NetherPortals         | 5.0.5                    |
| Persistent Seed                  | `164225356311935743`     |
| BetterStructures Spawn Exclusion | Main Spawnから100 blocks |
| Main End実Bukkit名               | `main_the_end`           |
| Main End Alias                   | `main_end`               |

`main_end`はMultiverse Aliasであり、Filesystem PathまたはBetterStructures Allowlist名として使用しない。

### 3.2 Artifact

| Artifact                          | 内部Version | Schematic数 | SHA-256                                                            |
| --------------------------------- | ----------: | ----------: | ------------------------------------------------------------------ |
| 103 Default Structures            |           5 |         103 | `118D873FDF87BF94EA6CA3036897B10790F5D73E62F8387E75C1AB6A4A360FE0` |
| Exploration Pack                  |           6 |          49 | `963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B` |
| Caves and Lost Civilizations Free |           2 |          49 | `27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677` |
| Adventure Pack（購入版）          |           1 |         107 | `96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C` |
| Echoes of the Past（購入版）      |           3 |         122 | `B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F` |
| BetterStructures Prop Pack        |           — |   55 models | `F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D` |
| FreeMinecraftModels JAR           |      2.10.2 |           — | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` |

Adventure販売ページ上のRelease表記と、Artifact内`content_packages/adventure_pack.yml`の`version: 1`が異なる可能性がある。Import判定ではArtifact内部値を使用し、配布元Release、取得日、SHA-256を別途記録する。

有料Artifact、Schematic、Prop Model、Plugin JARおよび生成Resource Pack BinaryをGitへ含めない。

---

## 4. World適用範囲

### 4.1 BetterStructures Allowlist

有効：

```text
main
main_nether
main_the_end
```

無効：

```text
resource
resource_nether
resource_end
その他の未知World
```

Baseline：

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

`main_end` Aliasを追加しない。

重要Generatorでは、可能な場合にGenerator YAML側にも`validWorlds`を設定し、二重防御とする。

### 4.2 Main Portal Family

`Multiverse-NetherPortals`でPersistent FamilyとResource Familyを明示的に分離する。

```text
Persistent Family:
  main ↔ main_nether
  main ↔ main_the_end

Resource Family:
  resource ↔ resource_nether
  resource ↔ resource_end
```

要件：

- Overworld／Netherを双方向Linkする。
- Overworld／Endを双方向Linkする。
- Persistent FamilyとResource Familyを交差Linkしない。
- `handle-end-exit-respawn: true`をBaselineとする。
- Main Stronghold End Portalは`main_the_end`へ接続する。
- Main End Exit Portalは`main`へ帰還する。
- Resource End Exit Portalは`resource`へ帰還する。
- BetterStructures内に配置されたEnd Portal Blockは`main`へ帰還する。
- 命名規則による自動Linkだけに依存せず、実Bukkit World名を確認する。
- Mob、Item、VehicleのPortal通過挙動を受入試験する。

Main内は同一InventoryであるためPortal移動にInventory切替は発生しない。ただし、Main／Resource／Frontierの接続先誤りを許容しない。

---

## 5. Network境界

### 5.1 Inventory

```text
Main:
  Main Local Inventory

Frontier Lobby:
  Neutral Group

Worlds Beyond:
  Worlds Beyond Group

Ruined Frontier／Guild:
  Guild Group
```

Mainの通常Inventory、Ender Chest、Vanilla XP、Health、FoodをFrontierへ共有しない。

Frontier ItemをMainへ持ち込まず、Main ItemをGuild Groupの初期装備として持ち込まない。

### 5.2 Network共有Data

```text
Waymark:
  MainとFrontierで共有

mcMMO:
  MainとFrontierで共有
  Ruined FrontierでもGameplay効果を許容
```

Mainで蓄積したmcMMO LevelはPlayerの鍛錬成果としてRuined Frontierでも有効とする。

FrontierからMainへ移送または換価可能なTheme固有Item、装備、素材およびQuest報酬は、初期段階ではWaymarkへ限定する。

### 5.3 Resource Pack

- MainとFrontierは別Resource Packとする。
- Backend移動時のResource Pack Reloadを許容する。
- Main PackにはEliteMobs、LeafGrapple、Worlds Beyond固有Assetを含めない。
- Frontier PackにMainと共通するBS Propが含まれても、Backend別に独立生成・配信する。
- Pack Hash、Hosting URL、容量およびReload時間を記録する。

---

## 6. 選定規模

V0.0.2の有効Schematic数：

| Dimension | Default | Exploration |  Caves | Echoes | Adventure |    合計 |
| --------- | ------: | ----------: | -----: | -----: | --------: | ------: |
| Overworld |      67 |          20 |     24 |     64 |        16 | **191** |
| Nether    |      18 |           4 |      5 |     14 |         3 |  **44** |
| End       |      18 |           5 |      4 |     12 |         4 |  **43** |
| **合計**  | **103** |      **29** | **33** | **90** |    **23** | **278** |

V0.0.1相当の旧案から27件を除外した。

| Pack／Dimension  | 除外数 | 主な移管先      |
| ---------------- | -----: | --------------- |
| Exploration End  |      3 | Ruined Frontier |
| Caves End        |      3 | Ruined Frontier |
| Echoes Overworld |      8 | Ruined Frontier |
| Echoes Nether    |      2 | Ruined Frontier |
| Echoes End       |      3 | Ruined Frontier |
| Adventure Nether |      2 | Ruined Frontier |
| Adventure End    |      6 | Ruined Frontier |
| **合計**         | **27** | —               |

有効Schematic数は生成密度倍率ではない。同じGenerator／Structure Type内の候補多様性を示す。実際の発見間隔はGenerator Separation、Structure Type、Biome条件およびWeightで決まる。

---

## 7. Weight方針

|             Weight | Mainでの意味                                |
| -----------------: | ------------------------------------------- |
|              `1.0` | 生活景観、小規模発見、標準的な探索          |
|          `0.5–0.8` | 軽～中規模遺跡                              |
|         `0.25–0.4` | 比較的大型、Mob／Lootが多い、Portal付き     |
|         `0.08–0.2` | 稀なLandmark                                |
| `isEnabled: false` | Ruined Frontier優先、重複過多、Mainに不適合 |

Mainでは、Ruined Frontierの象徴となるStructureを低Weightで残すのではなく、原則として無効化する。

初期値はalpha用であり、実測後に調整する。

---

# 8. Dimension別構成

## 8.1 Overworld

### 8.1.1 103 Default Structures

全67件を有効、`weight: 1.0`とする。

役割：

- BetterStructuresの基本体験
- 小～中規模景観
- 地表、水面、空中、地下の軽い発見
- Vanilla Structure間の空白補完

### 8.1.2 Exploration Pack

| Internal ID pattern                               | Variant                             | Weight | 判断                                    |
| ------------------------------------------------- | ----------------------------------- | -----: | --------------------------------------- |
| `betterstructures_exploration_bridgecave_*`       | `deep, dripstone, lush, shallow`    |  `1.0` | 洞窟景観と軽い探索                      |
| `betterstructures_exploration_waterhouse_*`       | `barren, desert, grassland, tundra` |  `1.0` | 水辺の生活／廃屋景観                    |
| `betterstructures_exploration_tower_*`            | `barren, desert, grassland, tundra` |  `0.4` | 中規模Landmark                          |
| `betterstructures_exploration_temple_*`           | `barren, desert, grassland, tundra` |  `0.3` | Vanilla Mob中心の攻略導入               |
| `betterstructures_exploration_floatingfortress_*` | `barren, desert, grassland, tundra` | `0.15` | 稀な空中要塞。Ruined Frontierの予告要素 |

無効：

```text
flagship_grassland
undergroundtemple_{deep,dripstone,lush,shallow}
watertemplesmall_{barren,desert,grassland,tundra}
well_{barren,desert,grassland,tundra}
```

### 8.1.3 Caves and Lost Civilizations Free

| Internal ID pattern                         | Variant                         | Weight | 判断                      |
| ------------------------------------------- | ------------------------------- | -----: | ------------------------- |
| `bs_lostcivilizations_free_crystalcave_*`   | `deep, dripstone, lush, normal` |  `1.0` | 景観中心                  |
| `bs_lostcivilizations_free_lostlake_*`      | `deep, dripstone, lush, normal` |  `0.8` | 地下湖と文明痕跡          |
| `bs_lostcivilizations_free_circledungeon_*` | `deep, dripstone, lush, normal` |  `0.6` | 小～中規模Vanilla Dungeon |
| `bs_lostcivilizations_free_prison_*`        | `deep, dripstone, lush, normal` |  `0.5` | 中程度の戦闘              |
| `bs_lostcivilizations_free_verticalcave_*`  | `deep, dripstone, lush, normal` | `0.35` | 縦穴Landmark              |
| `bs_lostcivilizations_free_ruins_*`         | `deep, dripstone, lush, normal` |  `0.2` | 稀な大型文明痕跡          |

無効：

```text
flagship_normal
mines_{deep,dripstone,lush,normal}
smalldungeon_{deep,dripstone,lush,normal}
```

### 8.1.4 Echoes of the Past

#### Weight 1.0：生活・景観・文明痕跡

すべて`betterstructures_echoes_`をPrefixとする。

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

#### 軽～中規模探索

| Concept            | Variant                             | Weight |
| ------------------ | ----------------------------------- | -----: |
| `crypt`            | `barren, desert, grassland, tundra` |  `0.6` |
| `dungeontower`     | `barren, desert, grassland, tundra` |  `0.5` |
| `shrine`           | `barren, desert, grassland, tundra` |  `0.7` |
| `surfacemine`      | `barren, desert, grassland, tundra` |  `0.6` |
| `temple`           | `barren, desert, grassland, tundra` |  `0.7` |
| `undergroundmines` | `deep, shallow`                     |  `0.5` |

無効：

```text
dungeon_{barren,desert,grassland,tundra}
mobchamber_{barren,desert,grassland,tundra}
spawnerroom_{barren,desert,grassland,tundra}
mines_{barren,desert,grassland,tundra}
```

`spawnerroom`と`mines`は旧案からRuined Frontierへ移管する。

### 8.1.5 Adventure Pack

| Internal ID pattern                        | Variant                             | Weight | 判断                   |
| ------------------------------------------ | ----------------------------------- | -----: | ---------------------- |
| `betterstructures_adventure_ship_*`        | `barren, desert, grassland, tundra` |  `0.6` | 水上の大型船           |
| `betterstructures_adventure_church_*`      | `barren, desert, grassland, tundra` | `0.35` | Echoesと調和する廃教会 |
| `betterstructures_adventure_portalroom_*`  | `deep, dripstone, lush, shallow`    |  `0.3` | 神秘的な地下施設       |
| `betterstructures_adventure_cloudisland_*` | `barren, desert, grassland, tundra` | `0.15` | 稀な空中Landmark       |

その他のOverworld Adventure Structureは無効とする。

---

## 8.2 Nether

### 8.2.1 103 Default Structures

全18件を有効、`weight: 1.0`とする。

### 8.2.2 Exploration Pack

| Internal ID                                            | Weight |
| ------------------------------------------------------ | -----: |
| `betterstructures_exploration_bridgecave_nether`       |  `1.0` |
| `betterstructures_exploration_waterhouse_nether`       |  `1.0` |
| `betterstructures_exploration_floatingfortress_nether` | `0.45` |
| `betterstructures_exploration_tower_nether`            |  `0.3` |

その他4件は無効。

### 8.2.3 Caves and Lost Civilizations Free

| Internal ID                                      | Weight |
| ------------------------------------------------ | -----: |
| `bs_lostcivilizations_free_crystalcave_nether`   |  `1.0` |
| `bs_lostcivilizations_free_circledungeon_nether` |  `0.6` |
| `bs_lostcivilizations_free_lostlake_nether`      |  `0.5` |
| `bs_lostcivilizations_free_prison_nether`        |  `0.4` |
| `bs_lostcivilizations_free_ruins_nether`         |  `0.2` |

無効：

```text
mines_nether
smalldungeon_nether
verticalcave_nether
```

### 8.2.4 Echoes of the Past

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
| `dungeontower_nether`     | `0.45` |
| `shrine_nether`           |  `0.7` |
| `statue_netherland`       |  `0.6` |
| `temple_netherland`       |  `0.7` |
| `undergroundmines_nether` |  `0.5` |
| `surfacemine_nether`      |  `0.4` |

すべて`betterstructures_echoes_`をPrefixとする。

無効：

```text
barn_nether
farmland_nether
house_nether
dungeon_nether
mobchamber_nether
spawnerroom_nether
mines_nether
```

`spawnerroom_nether`と`mines_nether`はRuined Frontierへ移管する。Ancient Debrisを含む大当たりStructureをMainへ残さない。

### 8.2.5 Adventure Pack

| Internal ID                                          | Weight |
| ---------------------------------------------------- | -----: |
| `betterstructures_adventure_ship_nether`             | `0.55` |
| `betterstructures_adventure_cloudisland_nether`      |  `0.3` |
| `betterstructures_adventure_largewatertemple_nether` | `0.25` |

無効：

```text
betterstructures_adventure_verticaltemple_nether
betterstructures_adventure_floatingmansion_nether
その他のAdventure Nether Structure
```

Vertical TempleおよびFloating MansionはRuined Frontierの大型攻略Landmarkとして残す。

---

## 8.3 End

Main Endは、「空虚さを維持しつつ、Elytra取得後にも文明痕跡と帰還設備を探す理由がある」状態を目標とする。

Main Endでは、Ruined Frontierの象徴となる巨大Dungeon、高Mob密度塔、Flagship、Mansionを採用しない。

### 8.3.1 103 Default Structures

全18件を有効、`weight: 1.0`とする。

### 8.3.2 Exploration Pack

| Internal ID                                         | Weight | 役割                 |
| --------------------------------------------------- | -----: | -------------------- |
| `betterstructures_exploration_bridgecave_end`       |  `0.3` | 地下橋梁／帰還設備   |
| `betterstructures_exploration_tower_end`            | `0.45` | 中規模Landmark       |
| `betterstructures_exploration_waterhouse_end`       |  `0.6` | 空中建築             |
| `betterstructures_exploration_watertemplesmall_end` |  `0.6` | 小規模空中寺院       |
| `betterstructures_exploration_well_end`             |  `0.7` | 小型発見物／帰還設備 |

無効：

```text
betterstructures_exploration_floatingfortress_end
betterstructures_exploration_temple_end
betterstructures_exploration_undergroundtemple_end
```

高Mob密度の攻略施設はRuined Frontierへ移管する。

### 8.3.3 Caves and Lost Civilizations Free

| Internal ID                                  | Weight | 役割             |
| -------------------------------------------- | -----: | ---------------- |
| `bs_lostcivilizations_free_crystalcave_end`  |  `0.8` | Crystal景観      |
| `bs_lostcivilizations_free_lostlake_end`     | `0.45` | 地下湖／帰還設備 |
| `bs_lostcivilizations_free_mines_end`        |  `0.3` | 地下坑道         |
| `bs_lostcivilizations_free_verticalcave_end` |  `0.3` | 縦穴Landmark     |

無効：

```text
bs_lostcivilizations_free_circledungeon_end
bs_lostcivilizations_free_prison_end
bs_lostcivilizations_free_smalldungeon_end
bs_lostcivilizations_free_ruins_end
```

`ruins_end`はEliteMobs Spawn Signを含むため、Mainでは引き続き無効とする。他3件はRuined Frontierへ移管する。

### 8.3.4 Echoes of the Past

| Internal ID                                     | Weight | 役割               |
| ----------------------------------------------- | -----: | ------------------ |
| `betterstructures_echoes_islandbig_end`         | `0.45` | 大型浮島／帰還設備 |
| `betterstructures_echoes_islandsmall_end`       | `0.55` | 小型浮島／帰還設備 |
| `betterstructures_echoes_mines_end`             |  `0.2` | 地表鉱山           |
| `betterstructures_echoes_undergroundmines2_end` | `0.25` | 地下鉱山／帰還設備 |
| `betterstructures_echoes_crypt_end`             | `0.45` | 墓所               |
| `betterstructures_echoes_shrine_end`            |  `0.6` | 小型祠             |
| `betterstructures_echoes_statue_end`            | `0.75` | 文明痕跡           |
| `betterstructures_echoes_surfacemine_end`       | `0.45` | 採掘施設           |
| `betterstructures_echoes_tower_end`             |  `0.6` | 小型Landmark       |
| `betterstructures_echoes_undergroundmines_end`  |  `0.5` | 地下探索           |
| `betterstructures_echoes_temple_end`            |  `0.5` | 小型寺院／帰還設備 |
| `betterstructures_echoes_wall_end`              |  `0.7` | 遺構景観           |

無効：

```text
barn_end
camp_end
farmland_end
house_end
dungeon_end
mobchamber_end
dungeontower_end
spawnerroom_end
seatemple_end
```

Dungeon Tower、Spawner Room、Sea TempleはRuined Frontierへ移管する。

### 8.3.5 Adventure Pack

| Internal ID                                    | Weight | 役割           |
| ---------------------------------------------- | -----: | -------------- |
| `betterstructures_adventure_ship_end`          | `0.35` | 中型飛行船     |
| `betterstructures_adventure_cloudisland_end`   | `0.25` | 浮島／帰還設備 |
| `betterstructures_adventure_portalroom_end`    |  `0.2` | 帰還Portal施設 |
| `betterstructures_adventure_shrinechamber_end` |  `0.3` | 中規模祠       |

無効：

```text
betterstructures_adventure_flagship_end
betterstructures_adventure_dungeontowers_end
betterstructures_adventure_megadungeon_end
betterstructures_adventure_sewers_end
betterstructures_adventure_floatingmansion_end
betterstructures_adventure_verticaltemple_end
その他のAdventure End Structure
```

Flagship、Dungeon Towers、Mega Dungeon、Sewers、Floating Mansion、Vertical TempleはRuined Frontierの象徴的攻略施設としてMainから除外する。

---

# 9. Prop／Resource Pack

## 9.1 Plugin構成

```text
Main Backend
├─ BetterStructures 2.6.3
├─ Multiverse-Core 5.7.2
├─ Multiverse-NetherPortals 5.0.5
├─ WorldEdit 7.4.4
├─ FreeMinecraftModels 2.10.2
├─ ResourcePackManager
├─ BetterStructures Prop Pack
└─ 選定済みStructure Content Pack
```

Main Packは必須配信候補とする。正式な必須設定はClient拒否時の導線を含めて実装タスクでLockする。

### 9.2 Prop ID正規化

FreeMinecraftModels 2.10.2は`.bbmodel`ファイル名由来のModel IDを完全一致で解決する。

確認済み：

| Pack            | Prop Marker | 未解決状態                     |
| --------------- | ----------: | ------------------------------ |
| Default         |         214 | すべて一致                     |
| Exploration     |         116 | 全件が旧PrefixなしID           |
| Caves Free      |         195 | `alchamytable` 1件             |
| Adventure購入版 |         340 | `alchamytable`, `shelf4` 各1件 |
| Echoes購入版    |         260 | `ladder` 1件                   |

実装：

1. 原本ArtifactをRead-onlyで保存する。
2. Runtime Import用Working Copyを作る。
3. 旧IDを`bs_prop_pack_*`へ変換する。
4. `alchamytable`を`bs_prop_pack_alchemy_table`へ変換する。
5. `shelf4`と`ladder`はSchematic内の位置・向き・寸法を確認して既存Modelへ明示Mappingする。
6. Mappingと変換ScriptのSHA-256を記録する。
7. 変換済み有料ArtifactをGitへ含めない。
8. Frontier側Working Copyにも同じMapping規則を使用する。

### 9.3 Permission

MainではFMMのPlayer向け家具Menu／Shopを使用しない。

```text
freeminecraftmodels.menu = false
freeminecraftmodels.shop = false
```

管理権限はTemporary Adminへ限定する。

---

# 10. 技術確認事項

## 10.1 Schematic内通常Entity

購入版Adventure／Echoesには、Prop Armor Stand以外のZombie、Bat、Skeleton等を保存したSchematicがある。

BetterStructures 2.6.3のEntity Paste処理はWorldEditへ`copyEntities(true)`を渡しているため、通常EntityもPasteされる可能性がある。

確認：

- Prop Armor Standだけが生成されるか
- 通常Entityも生成されるか
- Spawn Signと二重Spawnしないか
- Persistent Entityが過剰に残らないか
- Mob密度とTPS
- Projectile／Item Entityが残らないか

問題が確認された場合、原本を改変せず、Runtime Working Copyから不要Entityを除去する変換工程を検討する。

## 10.2 旧Schematic形式

選定対象にはSponge Schematic v2／DataVersion 2865が含まれる。

主な対象：

```text
Default:
  cistern_nether

Exploration:
  watertemplesmall_end

Adventure:
  largewatertemple_nether

Echoes:
  seatemple各種
  tower_desert
  temple_desert
```

WorldEdit 7.4.4でBlock、Container、Spawner、Entity、Prop位置を代表確認する。

## 10.3 End Portal

Portal付きStructureを採用するが、Main Family内の帰還設備としてのみ評価する。

確認：

- Paste後にPortalとして機能する
- Main Endから`main`へ帰還する
- Resource／Frontierへ接続しない
- Bed／World Spawn選択が想定どおり
- 誤接触が過度に不快でない
- 大面積PortalがClient描画／Chunk負荷を起こさない
- Mob、Item、Vehicleの通過挙動
- End Exit PortalとStructure Portalの挙動差

## 10.4 Loot

Chest／BarrelはBetterStructures GeneratorのTreasure設定から実行時に充填される。

確認：

- Container数が多いStructureの総報酬
- Barrel Loot
- Diamond／Netherite系の出現率
- Elytra／ShulkerのVanilla価値
- Nether Fortress／Bastion／End Cityの探索価値
- MainからRuined Frontierへ持ち込めないこと
- Main内Economyへの供給量

---

# 11. World再生成

追加Pack導入後は、Persistent Main Familyの探索済みChunkと未探索Chunkの世代差を避けるため、再生成を候補とする。

```text
main: 再生成候補
main_nether: 再生成候補
main_the_end: 再生成候補
```

Resource Familyは変更・再生成しない。

再生成は別の破壊的タスクとして明示承認を必要とする。

確認項目：

- Exact Runtime Path
- Seed `164225356311935743`
- World UUID
- Backup／Manifest／Rollback
- Vanilla Player Data Policy
- LuckPerms／mcMMO／Waymarkを変更しないこと
- Main Spawn
- Nether管理Spawn
- End管理Spawn
- BetterStructures Spawn Exclusion 100 blocks
- Multiverse登録
- Persistent／Resource Family双方向Link
- `handle-end-exit-respawn: true`
- `main_the_end`実名と`main_end` Alias
- Resource Family除外
- BetterStructures Import状態
- Resource Pack状態
- 既存Phase 3 Baselineの置換範囲

推奨順：

```text
Content選定／Config生成
↓
Portal Family／Allowlist Preflight
↓
Persistent Main Family再生成
↓
Content Import／Prop Pack統合
↓
受入試験／alpha
↓
Weight調整
↓
CoreProtect／Hub保護の後続タスク
```

---

# 12. alpha受入試験

## 12.1 起動／Import

- [ ] BetterStructuresが5 Packを認識する
- [ ] 有料ArtifactがGit非追跡である
- [ ] 全YAMLが選定表どおりである
- [ ] `New worlds spawn structures: false`
- [ ] `main`, `main_nether`, `main_the_end`だけで生成される
- [ ] Resource Familyで生成されない
- [ ] 未知Worldで生成されない
- [ ] Ruined Frontier用Elite ContentをMainへImportしていない

## 12.2 Portal Family

- [ ] `main ↔ main_nether`が双方向
- [ ] `main ↔ main_the_end`が双方向
- [ ] `resource ↔ resource_nether`が双方向
- [ ] `resource ↔ resource_end`が双方向
- [ ] Persistent FamilyとResource Familyが交差しない
- [ ] `handle-end-exit-respawn: true`
- [ ] Main End Exitが`main`へ帰還する
- [ ] Resource End Exitが`resource`へ帰還する
- [ ] BS Structure Portalが`main`へ帰還する
- [ ] `main_end` Aliasを実World名として誤使用していない

## 12.3 Resource Pack／Prop

- [ ] ResourcePackManagerがMain Packを配信する
- [ ] Default／Exploration／Caves／Echoes／AdventureのPropが表示される
- [ ] 未解決Model IDがLogに残らない
- [ ] FMM Menu／Shopを一般Playerが使用できない
- [ ] Main→Lobby→Frontier→MainでPackが正常に切り替わる
- [ ] Main PackにEliteMobs／LeafGrapple Assetが不要に含まれていない
- [ ] Pack容量とDownload時間が許容範囲

## 12.4 Structure

- [ ] 各Pack／Dimension／Structure Typeを代表生成する
- [ ] v2 Schematic代表を確認する
- [ ] Container／Barrel Lootを確認する
- [ ] Spawnerを確認する
- [ ] 保存済みEntityとSpawn Signの二重生成がない
- [ ] End Portalの帰還挙動が正しい
- [ ] 大型Structureの地形Fitが正常
- [ ] BetterStructures Spawn Exclusion 100 blocks内に生成されない
- [ ] Adventure大型StructureがRuined Frontierとの差別化を損なわない

## 12.5 プレイ感

- [ ] Overworldの生活景観が過密でない
- [ ] Nether Fortress／Bastionの価値を損なわない
- [ ] Endの空虚さを維持できている
- [ ] Elytra取得後の探索理由が増えている
- [ ] MainがRuined Frontierの導入として機能する
- [ ] MainだけでRuined Frontierの大型攻略体験を消費しない
- [ ] Loot量が過剰でない
- [ ] TPS、Chunk生成時間、Client FPSに問題がない

## 12.6 Network境界

- [ ] Main InventoryがFrontierへ共有されない
- [ ] Frontier Theme ItemがMainへ持ち込まれない
- [ ] Waymark残高がMain／Frontierで共通
- [ ] mcMMO LevelがMain／Frontierで共通
- [ ] MainのBS PropはItem移送経路にならない
- [ ] Backend移動失敗時にItem Duplicationが発生しない

---

# 13. Repository管理

Gitで管理する：

- Plugin Version／SHA
- Content Pack名称／Version／SHA
- 配布元URLまたは手動取得手順
- License／Redistribution条件
- `ValidWorlds.yml`
- 選定済みYAML値または再現可能な生成Script
- Prop ID Mapping
- Entity正規化工程を追加する場合のScript
- Multiverse-NetherPortals Link設定
- Resource Pack生成設定
- Runtime受入試験結果
- World再生成Baseline

Gitへ含めない：

- 有料ZIP
- `.schem`
- `.bbmodel`
- Plugin JAR
- 変換済み有料Artifact
- 生成済みResource Pack Binary
- World Data
- Backup Data

---

# 14. 実装前Lock項目

1. ResourcePackManager正式Version
2. Main Pack Hosting
3. Main Pack必須／任意設定
4. Prop `shelf4` Mapping
5. Prop `ladder` Mapping
6. 通常Entity Pasteの実挙動
7. 必要なEntity除去変換
8. Generator YAML／Treasure File
9. Weight／Separation
10. Persistent Main Family再生成承認
11. Player Data Policy
12. Portal双方向Link
13. End Exit設定
14. BetterStructures Portalの帰還先
15. CoreProtect導入時期
16. alpha後のWeight確定

---

# 15. 次タスク

1. V0.0.2選定表からConfig生成Scriptを作成する。
2. Prop Marker正規化Scriptを作成する。
3. Schematic Entity監査Scriptを作成する。
4. Main Resource Pack生成手順を固定する。
5. Persistent／Resource Portal FamilyをPreflightする。
6. Persistent Main Family再生成タスクを設計し、明示承認を得る。
7. Content PackをWorking CopyからImportする。
8. alpha受入試験を実施する。
9. Weight、Loot、生成間隔を調整する。
10. Main BetterStructures構成を実装済みVersionへ更新する。
