# Micro Frontier / Giant World Concept

**Status:** Draft  
**Document type:** Non-authoritative future server concept  
**Candidate ID:** FUT-31  
**Natural placement:** Independent Backend or future Frontier Theme  
**Created:** 2026-08-12

> [!IMPORTANT]
> この文書はProject Wayfarerの将来候補を保存するConceptです。
> V0.1.0 Scope、Roadmap、Runtime、Plugin、World生成、Player属性、Data境界または実装を変更・承認しません。
> 技術的実現性は別途PoCと現行Minecraft／Server API確認を行うまで確定しません。

## 1. Core concept

Playerを通常より大幅に小さくし、通常Minecraftでは何でもない1 Blockの段差、木、家、洞窟、Mob等を巨大な地形・構造物・生物として体験するSurvival／Exploration案です。

単に「小さいPlayerでMinecraftを遊ぶ」ことを目的にはしません。中心Game Loopは次のように定義します。

> 小さな身体で巨大なMinecraft世界へ進出し、越えられない地形を攻略して交通路と前哨基地を築き、活動圏を少しずつ拡大する。

Scale変更自体は視覚的なHookであり、長期的なGame Playは移動Infrastructure、Landmark攻略、拠点網構築および新たな移動能力の解放によって成立させます。

## 2. Origin of the idea

初期案では、Worldを構成する1 Blockそのものが非常に巨大な世界を想定しました。

実現方式としては大きく次の2案があります。

1. Player Scaleを縮小し、通常Blockを相対的に巨大化する。
2. Generatorを変更し、複数の通常Blockを一つの巨大な論理Blockとして配置する。

後者では、例えば`4 x 4 x 4`または`8 x 8 x 8`の同一Block集合を一つのMacroblockとして扱えば、遠景では巨大なVoxelで構成されたWorldに見せられます。

ただし、初期実装ではPlayer Scale方式の方がWorld Generator全面変更を避けやすい可能性があります。本ConceptではまずPlayer Scale方式を第一候補とし、Macroblock Generatorは将来の拡張または代替案として保持します。

## 3. Design problem

Playerを小さくするだけでは、一時的な驚きはあっても長期Game Loopになりません。

特に次の問題があります。

- 通常距離が極端に遠く感じられ、移動が苦痛になる。
- 1 Blockの段差や溝が頻繁な障害になる。
- 普通のSurvivalと同じ目標ではScale変更に意味がない。
- 採掘速度やBlock破壊の見え方がScale感と矛盾する可能性がある。
- 通常ScaleのMobが強大すぎる可能性がある。
- 移動負荷だけ増やすと「面倒なMinecraft」になる。

したがって、移動困難を消すのではなく、移動困難そのものをProgressionへ変換します。

## 4. Primary progression: expanding the reachable world

通常MinecraftのTool Tier Progressionに加えて、活動圏そのものを成長させます。

初期例:

```text
徒歩
→ 足場・階段・梯子
→ Bridge / Rope / Zipline
→ Elevator / Minecart
→ Gliderまたは別の長距離移動手段
→ 拠点間Fast Travel
```

初回は数Block先の森でさえ遠征になります。

Playerは一度攻略した経路に橋、階段、梯子、Safe House、輸送路等を残し、同じ移動を次回から短縮します。その結果、World自体が「未踏の巨大地形」から「Infrastructureで接続された活動圏」へ変化します。

Player能力だけではなく、建築したInfrastructureそのものをProgressionとして扱うことが本Conceptの主要な特徴です。

## 5. Landmark progression

「何をすれば進むか」を明確にするため、主要Landmarkへの到達をProgression Goalとします。

候補例:

- 巨大樹
- 湖または河川
- Cave
- Village
- Ruin
- Mountain
- Ocean shore
- Stronghold相当の大型構造物

Progression例:

```text
Spawn Camp
→ 最初の巨大樹へ到達
→ 樹上または根元に前哨基地を開設
→ 新しい移動手段を解放
→ 湖を横断
→ Cave前哨基地を開設
→ 地下資源を確保
→ 遠方Landmarkへ進出
```

各Landmarkは単なる観光地点ではなく、新Resource、移動能力、Craft、Infrastructure Upgradeまたは次の地域へのAccessを提供することが望ましいです。

## 6. Existing Minecraft structures as giant spaces

Player Scale方式では、通常サイズのMinecraft構造物をそのまま巨大建造物として利用できる可能性があります。

例えばVillage Houseは、小型Playerから見ると次のような攻略対象になります。

- 基礎部分が壁や崖になる。
- Doorが巨大Gateになる。
- Windowが高所侵入口になる。
- Bed、Chest、Furniture相当のObjectが巨大Platformになる。

これにより、通常Minecraftでは数秒で通過する構造物を探索・侵入・攻略の対象へ変換できます。

この特徴は、専用Mapを大量に手作りせずに巨大世界感を出せる可能性があります。

## 7. Mob scale model

Playerだけを縮小すると、通常ScaleのMobは巨大生物になります。

全Mobをそのまま通常Scaleにすると常時戦闘が成立しない可能性があるため、Mobを役割別にScaleする案を保持します。

### Micro Mob

Playerと近いScale。通常Enemyとして使用します。

### Medium Mob

Playerより数倍大きいElite相当として扱います。

### Normal-size Mob

通常Minecraft Scaleのまま残し、巨大生物、Boss、環境Hazardまたは回避対象として扱います。

通常ZombieやCow等が「倒すべき雑魚」ではなく「遭遇すると逃げる巨大生物」になることで、既存Mobに新しい役割を与えられます。

## 8. Mining and world modification

小型Playerが通常Blockを通常速度で破壊すると、視覚Scaleに対して破壊能力が大きすぎる可能性があります。

候補として次を比較します。

- 初期Mining Speedを低くする。
- Surface Resourceを中心に初期Progressionを構成する。
- Tool Upgradeで巨大地形への掘削能力を上げる。
- 坑道建設をInfrastructureの一部として扱う。
- 後半に機械的または高速な採掘手段を解放する。

単純に全Blockを硬くすると作業量だけ増えるため、Mining速度調整は必ずResource配置、Tool ProgressionおよびObjectiveと合わせて評価します。

## 9. Proposed player journey

### Early game

- Spawn周辺の数Blockを活動圏とする。
- 小型Playerとしての移動と地形Scaleに慣れる。
- 食料、木材、石材等の初期Resourceを確保する。
- 足場、Bridge、階段等で最初の経路を作る。
- 最初のLandmarkへ到達する。

### Mid game

- 数十Block規模へ活動圏を拡大する。
- 複数の前哨基地を作る。
- Rope、Zipline、Minecart、Elevator等の交通設備を構築する。
- 巨大構造物を探索する。
- Medium／Normal-size Mobを攻略または回避する。

### Late game

- 数百Block規模の主要Landmarkを接続する。
- 長距離輸送またはFast Travel Networkを完成させる。
- 高度なResource採掘や大型生物攻略を行う。
- 地図上の主要地域をInfrastructure Networkへ組み込む。

Endgame候補は、World内の主要Landmarkを接続し、巨大世界に一つの文明圏・交通Networkを完成させることです。

## 10. Minimum Viable Experience

初期PoC／MVEでは、World全体を作り込まず、Scale変更がGameとして成立するかを確認します。

候補Scope:

- 独立Test WorldまたはBackend
- 小型Player
- Player movement、jump、reach等のScaleに関係する挙動調整
- 狭い固定Area
- 3種類程度の移動障害
- 1つのLandmark
- 足場、Bridgeまたは梯子による経路構築
- 1種類の小型Enemy
- 1種類の通常Scale巨大Mob
- Spawn Return
- Inventoryは他Backendと分離

MVEの第一目的は「小さいことが面白いか」ではなく、次を確認することです。

1. 初期移動が不快ではなくChallengeとして感じられるか。
2. Infrastructureを作ることで明確に便利になるか。
3. 既存地形や構造物が新しい攻略対象として機能するか。
4. 30分以上続けても一発ネタで終わらない兆候があるか。

## 11. Alternative: Macroblock Generator

Player Scale方式だけで十分な巨大感が得られない場合は、Generator側でWorldをMacro化する案を再検討します。

例えば論理1 Blockを`4 x 4 x 4`の通常Block集合として生成します。

利点:

- 地形そのものを巨大Voxelとして設計できる。
- Player Physicsを極端に変更しなくても巨大World感を出せる。
- 巨大な洞窟、木、山等をGenerator側で制御できる。

課題:

- World高さ制限との整合。
- Noise Generatorの再設計。
- Structure、Biome、Ore、Cave等の再配置。
- 一つの論理Blockを掘るための作業量増加。
- World容量とChunk生成負荷。

Player ScaleとMacroblockを併用するHybrid方式も候補ですが、初期PoCでは扱いません。

## 12. Relationship with existing Wayfarer themes

### Main

恒久生活、保管、経済を担うMainとは中心Loopが異なります。本Conceptは独立Backendとし、通常Inventoryを直接共有しない方が自然です。

### Worlds Beyond

探索という点では重複しますが、Worlds Beyondが未知地形そのものの発見を中心とするのに対し、本Conceptは「巨大で移動困難な既知地形をInfrastructureで攻略する」点を中心にします。

### Ruined Frontier

戦闘や危険地形は含み得ますが、Loot／Boss中心ではなく、移動、到達、経路構築、拠点NetworkがPrimary Loopです。

### Related future concepts

Factory / Logistics、Cartography、Construction Contracts等と一部の操作・Infrastructure思想を共有しますが、本Conceptでは「巨大世界を到達可能に変えること」が中心Loopであり、各Conceptとは統合せず単独評価します。

## 13. Provisional evaluation

現段階の暫定評価です。Portfolio正式評価へ反映する前にPoCを必要とします。

| Axis | Provisional | Reason |
| --- | ---: | --- |
| Solo | 5 | InfrastructureとLandmark攻略は1人で成立可能 |
| Minecraft fit | 5 | Block、地形、建築、Mob、採掘をScale変更で再解釈する |
| Distinctiveness | 5 | 通常Survivalとは空間感覚と中心Progressionが大きく異なる |
| Initial feasibility | 2 | Scale関連Physics、Mob、Mining、Map設計のPoCが必要 |
| Sustainable operation | 4 | Generator／既存地形を活用できれば手作りScenario依存を抑えられる可能性がある |
| Portfolio complement | 5 | Main、Worlds Beyond、Ruined Frontierとは異なるInfrastructure Explorationを提供する |

**暫定Class: A候補。**

独自性だけならS候補になり得ますが、Scale変更後に実際のGame Playが成立するか未確認であるため、現時点ではS評価へ上げません。

## 14. Main risks

### Game design

- 移動がChallengeではなく単なる苦痛になる。
- Infrastructure完成後にGameplayが消える。
- Landmarkが少ないと目的を失う。
- Scale変更が最初だけ面白い一発ネタになる。

### Technical

- Player ScaleにMovement、Jump、Reach、Gravity等が自然に追従しない可能性。
- Vehicle、Projectile、Interaction、Portal等で不整合が生じる可能性。
- Mob ScaleとAI／Collisionの組合せに問題が出る可能性。
- Generator Macro化を採用した場合の実装・負荷増加。

### Operation

- 大規模な交通網がWorld Backup／Resetを難しくする。
- Player間でInfrastructureの所有権や改変権限が衝突する可能性。
- Fast Travel導入が早すぎると中心Loopを破壊する。

## 15. Next questions

1. Player Scaleはどの程度なら移動Challengeと操作性を両立できるか。
2. 通常Minecraft地形をそのまま使って十分な巨大感が出るか。
3. 移動速度、Jump、Reach、Gravity等をどこまで再設計する必要があるか。
4. 最初の30分で作るInfrastructureは何か。
5. Landmark到達によって何を解放するか。
6. MobをどのScale区分で配置するか。
7. Miningをどこまで遅くするか。
8. Fast Travelをいつ解放するか。
9. 恒久World、Season World、Reset型のどれが適切か。
10. Playerが10時間後にも活動圏拡大を続ける理由をどう作るか。

まずは小さなPoC WorldでPlayer Scaleと移動感覚を評価し、その結果からConceptを継続・修正・Rejectするのが適切です。
