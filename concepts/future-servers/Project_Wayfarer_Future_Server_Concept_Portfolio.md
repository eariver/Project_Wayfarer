# Project Wayfarer Future Server Concept Portfolio

**Status:** Draft  
**Document type:** Non-authoritative concept portfolio  
**Baseline:** V0.1.0 planned Main, Worlds Beyond and Ruined Frontier  
**Created:** 2026-08-02

> [!IMPORTANT]
> この文書は、将来候補の比較・発想・判断履歴を保存する非正本Conceptです。
> V0.1.0 Scope、Roadmap、Plugin選定、World生成、Runtime変更または実装を承認しません。
> 正式仕様と矛盾する場合は、`docs/`、`versions.yml`、`plugin-manifest.yml`および追跡対象Runtime Configを優先します。

## 1. Purpose

Project WayfarerのV0.1.0では、恒久生活拠点のMain、PEACEFUL探索のWorlds Beyond、高難度攻略のRuined Frontierを用意する計画です。本Portfolioは、その後に検討しうる新規Server、Frontier Theme、Main内Content、Minestom Backendを、具体化前の段階から一か所へ集約します。

本段階では各新規案を単独のGame Loopとして評価します。新規案同士の統合は、各案の中心Loop、Minimum Viable Experience、配置、技術難所が個別に明確になるまで扱いません。ただし、既存のMain、Worlds Beyond、Ruined Frontierに新規案を追加する配置候補は評価できます。

## 2. Existing V0.1.0 baseline

| Existing theme | Primary role | Core loop | Portfolio role |
| --- | --- | --- | --- |
| Main | 恒久生活、建築、保管、経済、帰還地点 | 採集、建築、交流、蓄積 | 新規案との重複とMain内追加適合性を判断する基準 |
| Worlds Beyond | PEACEFULな未知地形探索 | 移動、地形読解、到達、発見 | 非戦闘探索案との重複・拡張性を判断する基準 |
| Ruined Frontier | 廃墟、遺跡、EliteMob、Boss、装備Progression | 戦闘、攻略、Loot、成長 | 戦闘、Dungeon、Hunting案との重複を判断する基準 |

## 3. Evaluation model

各軸は5点満点です。

| Axis | Meaning of a high score |
| --- | --- |
| Solo | 1人または極少人数でも中心Loopが成立する |
| Minecraft fit | Block、地形、建築、採掘、Mob等を使う必然性が強い |
| Distinctiveness | 国内公開ServerおよびWayfarer既存3系統との差が明確 |
| Initial feasibility | 初期版を小さく実装しやすい |
| Sustainable operation | 継続的な手作りContent供給や高密度人口への依存が小さい |
| Portfolio complement | Main、Worlds Beyond、Ruined Frontierが満たさない役割を補う |

総合評価は次を使用します。

- **S:** Projectの新しい柱になりうる。独自性または戦略的必要性が特に高い。
- **A:** 有力候補。単独で中心Loopが成立し、配置または実装の検討価値が高い。
- **B:** 条件付き候補。重複、制作量、対象層、技術難度などを解決する必要がある。
- **C:** 人口増加後、Event用途、または余力がある場合の候補。
- **D:** 現時点ではWayfarerで優先する理由が弱い。

評価は採用順位ではありません。独自性の高い案ほど実装負荷が大きい場合があります。

## 4. Market context

別紙の[minecraft.jp theme trend investigation](investigations/minecraft_jp_server_theme_trends_2026-07-31.md)では、Score上位60件の86.7%がSurvival、55.0%がEconomyを掲げました。上位は高機能生活Serverと複数Backendを束ねるNetwork型が中心です。

一方、PEACEFUL探索特化、工場物流、生態系再生、機能を削ったMinecraft、有限資源、遊牧、災害救助、一人用Roguelike PvE等は明確な主流ではありません。ただし市場空白は需要の証明ではないため、少人数成立性、説明力、初期MVP、継続運用を個別に確認します。

## 5. Portfolio overview

| ID | Concept | Natural placement | Solo | MC fit | Distinct | Initial | Sustain | Complement | Class |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| BASE-01 | Main | Existing Backend | 5 | 5 | 2 | 4 | 5 | 5 | Baseline |
| BASE-02 | Worlds Beyond | Existing Frontier Theme | 5 | 5 | 4 | 3 | 4 | 5 | Baseline |
| BASE-03 | Ruined Frontier | Existing Frontier Theme | 4 | 4 | 3 | 2 | 3 | 5 | Baseline |
| FUT-01 | True Latest | Independent Paper/Purpur Backend | 5 | 5 | 4 | 4 | 3 | 5 | S |
| FUT-02 | Parkour | Main or Frontier Content | 5 | 4 | 2 | 4 | 3 | 4 | B |
| FUT-03 | ANNI-like | Independent Event Backend | 1 | 4 | 3 | 2 | 3 | 4 | C |
| FUT-04 | FPS | Independent Event Backend | 1 | 2 | 2 | 2 | 3 | 2 | D |
| FUT-05 | Gambling | Main Content | 5 | 2 | 2 | 4 | 5 | 3 | B |
| FUT-06 | OneBlock | Independent Backend | 5 | 5 | 3 | 3 | 4 | 4 | A |
| FUT-07 | Roguelike Expedition | Frontier Theme or independent Backend | 5 | 5 | 4 | 2 | 3 | 4 | A |
| FUT-08 | Base Defense / Horde | Frontier Theme or independent Backend | 5 | 5 | 4 | 2 | 4 | 5 | A |
| FUT-09 | Rotating Challenge World | Independent seasonal Backend | 5 | 4 | 4 | 3 | 2 | 5 | A |
| FUT-10 | Archaeology / Excavation | Ruined Frontier Content | 5 | 5 | 4 | 3 | 3 | 3 | B |
| FUT-11 | Instanced Dungeon | Ruined Frontier Content or Backend | 5 | 4 | 3 | 2 | 2 | 3 | B |
| FUT-12 | Nomadic Survival | Independent Backend | 5 | 5 | 4 | 2 | 3 | 5 | A |
| FUT-13 | Jobs / Contracts | Main or Frontier common Content | 5 | 4 | 3 | 3 | 4 | 5 | A |
| FUT-14 | Factory and Logistics Simulation | Independent Backend or future LAB | 5 | 5 | 4 | 1 | 4 | 5 | A |
| FUT-15 | Asymmetric Cooperation | Scenario Content | 2 | 4 | 4 | 2 | 2 | 4 | B |
| FUT-16 | Puzzle / Escape | Frontier Scenario Content | 5 | 5 | 4 | 2 | 1 | 4 | B |
| FUT-17 | Cookie Clicker-like Factory | Main Content | 5 | 3 | 4 | 3 | 5 | 5 | A |
| FUT-18 | Minestom Limited Minecraft | Independent Minestom Backend | 5 | 5 | 5 | 1 | 2 | 5 | S |
| FUT-19 | Village / Colony Management | Frontier Theme or independent Backend | 5 | 5 | 4 | 1 | 3 | 5 | A |
| FUT-20 | Ecosystem Restoration | Frontier Theme or independent Backend | 5 | 5 | 5 | 1 | 3 | 5 | A |
| FUT-21 | Cartography / Surveying | Worlds Beyond Content | 5 | 5 | 4 | 3 | 3 | 3 | B |
| FUT-22 | Construction Contracts | Main Content | 5 | 5 | 4 | 2 | 3 | 5 | A |
| FUT-23 | Monster Research / Hunting | Ruined Frontier Content | 5 | 5 | 4 | 2 | 2 | 3 | B |
| FUT-24 | Time-loop World | Independent Scenario Backend | 5 | 4 | 5 | 1 | 1 | 5 | B |
| FUT-25 | Finite-resource Survival | Independent Backend | 5 | 5 | 4 | 4 | 3 | 5 | A |
| FUT-26 | Merchant / Caravan | Main or Frontier Content | 5 | 5 | 3 | 3 | 3 | 4 | B |
| FUT-27 | Disaster Response / Rescue | Frontier Scenario Content | 5 | 5 | 4 | 2 | 2 | 5 | A |
| FUT-28 | Redstone / Logic Challenges | Main or future LAB Content | 5 | 5 | 3 | 3 | 3 | 4 | B |
| FUT-29 | Warehouse Sorting / Logistics Work | Main Content or Backend | 5 | 4 | 4 | 3 | 4 | 5 | A |
| FUT-30 | Minecraft Board Game | Main or Lobby recreation Content | 5 | 2 | 3 | 2 | 4 | 3 | C |

## 6. Concept records

### FUT-01 True Latest

Mainの互換性・資産保護とは分離し、Minecraft公式の最新Releaseへ可能な限り早く追従する最小Plugin Serverです。新しいVanilla要素を未蓄積状態から発見・攻略し、Season目標やAchievementを達成します。

MVPは最新安定Release、最低限の権限・監査・Backup、独立Inventory、短期またはSeason World、Networkへ返す限定Pointです。MainがPlugin都合でVersion固定されても最新要素を提供でき、古いClient互換を切って新Item・Blockを完全利用できます。

主な課題はRelease直後のServer Software安定性、World更新、Season終了、死亡・Reset、成果移送です。**S評価**とし、最も現実的な独立Backend候補とします。

### FUT-02 Parkour

手作りまたは地形利用のCourseを一人で反復し、完走、Time、Checkpoint、Rankingを競います。MVPは1 Course、Checkpoint、Reset、計時、個人Bestです。

専門Serverとの差別化と継続Course制作が課題です。独立Backendより、Mainの常設競技、Worlds Beyondの移動試験、Ruined Frontier遺跡内Challengeに向きます。**B評価**です。

### FUT-03 ANNI-like

複数Teamが採集・防衛・攻撃を分担し、敵Core破壊を目指す長時間Team Gameです。複数Team、資源、Core、Phase、Class、Match管理が必要です。

中心価値が人間同士の役割分担と判断にあるため、NPC補充では十分に代替できません。**C評価**とし、人口形成後の日時指定Event候補とします。

### FUT-04 FPS

Minecraft Client上で銃器、Team、Map、Respawn、Hit判定を用いた対戦を提供します。人口依存、専用実装量、Resource Pack負荷に対して、Minecraftで再現する必然性が弱く、国内競合も存在します。**D評価**です。

### FUT-05 Gambling

Main経済内にCasino Chip、Game、Prize、Currency Sinkを提供します。Waymarkを直接賭けず、交換可能範囲を制御した専用Chipと1種類のGameから始めます。

Economy Inflation、期待値、放置・自動操作、実通貨と誤認させない表現が課題です。独立BackendではなくMainの娯楽・Sinkとして**B評価**です。

### FUT-06 OneBlock

1個の再生成Blockから個人またはGroupの島を成長させる少人数向けSurvivalです。MVPは少数の事前作成Worldまたは島、所有者割当、OneBlock Phase、Spawn、Death Return、Inventory分離です。

将来はDynamic World作成、Player/Group紐付け、招待、休眠World Unload、再生成、Seasonへ拡張できます。Multiverse系はWorld操作の下層であり、島Lifecycle、所有権、復元、削除は別途必要です。**A評価**です。

### FUT-07 Roguelike Expedition

持込制限下で未知領域へ入り、Lootを得て生還または途中撤退する一人用PvE遠征です。MVPは1 Mapまたは生成領域、Run初期化、Loot Table、Extraction地点、Death Loss、持帰り枠です。

Ruined Frontierの恒久装備成長とは異なり、1回ごとのRunと撤退判断を主役にします。Map、Enemy、Event不足による単調化とData複製対策が課題です。**A評価**です。

### FUT-08 Base Defense / Horde

準備時間に資源採集と建築を行い、攻撃WaveからCoreまたは住民を守ります。小規模Map、Core、Build Phase、Enemy Wave、勝敗、人数ScalingがMVPです。

採掘、Craft、建築、戦闘を全て中心操作に使えます。Mob Pathfinding、Block破壊、Chunk負荷、抜け道対策が難所です。**A評価**です。

### FUT-09 Rotating Challenge World

一定期間ごとに一つの特殊Ruleを持つ短期Worldを開き、共通目標を達成します。水位上昇、夜間のみ安全、狭いInventory、移動するBorder、高度制限などが例です。

MVPは1 Rule、1 World、開始・終了、結果保存、限定Rewardです。継続的なRule設計と検証が必要なため運営負荷があります。**A評価**です。

### FUT-10 Archaeology / Excavation

地図、古文書、地層、痕跡から発掘地点を特定し、遺物を回収・鑑定・展示します。Ruined Frontierの廃墟探索に非戦闘Loopを加え、Mainへ博物館を置く配置が自然です。

手掛かり制作と答え共有による消費が課題です。独立ThemeよりRuined Frontierの深掘り候補として**B評価**です。

### FUT-11 Instanced Dungeon

1人またはPartyごとに初期化されたDungeonで戦闘、Puzzle、分岐、Bossを攻略します。MVPは1 Instance、入退場、Reset、人数Scaling、Loot境界です。

Ruined FrontierおよびEliteMobs Instanceとの重複、Map制作量、Instance Lifecycleが課題です。**B評価**です。

### FUT-12 Nomadic Survival

定住を不利または不可能にし、安全地帯、資源、World Borderを追って移動し続けるSurvivalです。MVPは移動理由を生む1 Mechanic、持越し手段、次の安全地域を示す情報、終了条件です。

通常Minecraftの定住前提を少数Ruleで反転できますが、移動が単なる撤去作業にならないRewardと途中参加設計が必要です。**A評価**です。

### FUT-13 Jobs / Contracts

採集、討伐、調査、輸送、修復、救助等の短時間依頼を受注してRewardを得ます。数種類のTemplate、受注、進捗、完了、再抽選、Reward上限がMVPです。

MainとFrontierの滞在理由を増やす共通Contentであり、独立Backendにはしません。単純日課化とEconomyへの過剰供給が課題です。**A評価**です。

### FUT-14 Factory and Logistics Simulation

設備、加工、電力、搬送、倉庫、注文を物理配置し、生産Networkを最適化します。MVPは原料1種、加工1段、設備2～3種、接続、出力倉庫、固定注文です。

Minecraftの空間と建築を生産設計へ直接使えます。Tick負荷、設備Graph、Chunk Load、Offline処理、所有権、Visualと内部数値の同期が難所です。大型独自Plugin候補として**A評価**です。

### FUT-15 Asymmetric Cooperation

現場、地図、監視、装置等、Playerごとに異なる情報と操作権を持つ協力Scenarioです。MVPは2人、1 Scenario、Role別UIまたは視界、共有目標です。

固定人数、Communication、途中離脱、再Play性が課題です。常設Backendより固定Mission候補として**B評価**です。

### FUT-16 Puzzle / Escape

建築観察、Block、Redstone、Mob仕様、暗号を使い、閉鎖空間または遺跡から脱出します。MVPは1短編Map、Reset、Hint、完了記録です。

一度解くと消費され、継続Map制作が必要です。Ruined Frontierの期間限定または固定Adventureとして**B評価**です。

### FUT-17 Cookie Clicker-like Factory

手動生産から設備購入、自動生産、倍率、Offline蓄積、Prestigeへ進むIdle Factory Mini-gameです。MVPは1 Resource、手動Action、設備3段階、時間生産、Upgrade、上限付きOffline Rewardです。

Main内の小型継続Contentとして、物理設備を表示しつつ内部は数値計算できます。AFK強制、Inflation、単一最適解、Offline回収偏重が課題です。**A評価**です。

### FUT-18 Minestom Limited Minecraft

Minecraftへ機能を足すのではなく、最小限のBlock、Item、Ruleだけを実装し、Playerの機能Requestによって世界を拡張します。初期状態ではCraft、Storage、Mob、広いWorld等が存在しない構成も可能です。

Playerは現在の制約下で生活し、必要機能を提案・投票・研究し、Releaseされた新機能で次の問題を解きます。MVPはMinestom接続、狭いWorld、Block操作、Inventory、永続Player Data、1種類の機能解放、Request記録です。

Requestは自由でも実装保証せず、調整、既存System組合せ、新規研究案件を分離します。継続開発がGame運営そのものになるため、機能境界、Data Migration、期待値管理が最大の課題です。看板価値として**S評価**です。

### FUT-19 Village / Colony Management

Playerの装備より、住民、住居、食料、職業、施設、防衛を成長させます。MVPは少数NPC、住居判定、食料需要、1職業、人口または幸福指標です。

NPC AI、Pathfinding、Chunk Unload、作業詰まり、死亡復旧、建築判定が難所です。魅力と実装規模の双方が大きく、**A評価**です。

### FUT-20 Ecosystem Restoration

荒廃・汚染した土地へ水、土壌、植生、生物を戻し、環境指標を回復させます。MVPは小区画、土壌・水・植生の3指標、数種類の植物、段階的Visual変化です。

戦闘、Loot、Economy以外の明確なProgressionで、国内市場でも未開拓です。生態系Modelの説明性、単純植林への退化、Simulation負荷、状態可視化が課題です。**A評価**です。

### FUT-21 Cartography / Surveying

未知地域を移動し、地形、標高、Biome、遺跡、安全経路、Waystone候補を正確に記録します。Worlds Beyondの探索を調査成果へ変換する追加Contentです。

座標、Dynmap、既存Map機能が課題を無効化しない制約と、正確性の自動評価が必要です。**B評価**です。

### FUT-22 Construction Contracts

資材、面積、設備、安全性、時間等の要件を満たす建築を設計し、自動検査を受けます。MVPは小型課題1種、専用区画、資材上限、Block/設備条件、提出、検査です。

Mainの建築目標と短時間Challengeに向きます。美観を自動判定せず、機能要件へ限定することが重要です。**A評価**です。

### FUT-23 Monster Research / Hunting

足跡、被害、鳴き声、時間帯、天候等から特定個体を追跡し、準備、罠、弱点を使って討伐します。Ruined Frontierで調査と準備を主役にする追加Contentです。

痕跡生成、個体AI、答え共有、既存EliteMobとの差別化が課題です。**B評価**です。

### FUT-24 Time-loop World

一定時間ごとにWorldとNPCが初期状態へ戻り、Playerの知識または限定記録だけが残るScenarioです。MVPは小規模Map、短いLoop、3～5 Event、1つの恒久記録、最終脱出条件です。

説明力と印象は強い一方、Script・Scenario制作量、一度解かれた後の寿命、多人同期、Reset整合が課題です。常設運営より大型限定Adventureとして**B評価**です。

### FUT-25 Finite-resource Survival

狭いWorld内の鉱石、木材、装備を有限資産とし、回収、修理、再利用、代替を中心にします。MVPは固定小World、Resource総量、再生成制限、回収・修理Rule、終了目標です。

少数Ruleで通常Survivalを大きく変えられ、初期実装は比較的軽い一方、独占、廃棄、荒らし、途中参加、不可逆な詰みが課題です。**A評価**です。

### FUT-26 Merchant / Caravan

地域差のある需要と価格を読み、積載量、経路、危険を管理して商品を輸送します。MVPは2拠点、数商品、価格差、物理Inventory、1移動手段、Server固定需要です。

MainまたはFrontierの地域内Contentに向き、初期はPlayer市場ではなくNPC需要を使います。Teleport、Warp、人口不足市場、Alt利用が課題です。**B評価**です。

### FUT-27 Disaster Response / Rescue

洪水、火災、落盤、崩壊、吹雪等の現場で、Block設置、破壊、流体制御、経路構築により救助します。MVPは1 Map、1災害、救助対象、制限時間、資材上限、Scoreです。

Minecraftの基本操作を戦闘以外のMissionへ転換し、既存3 Themeをよく補完します。Scenario制作、Reset、Fluid/Fire負荷、正解固定が課題です。**A評価**です。

### FUT-28 Redstone / Logic Challenges

限定された部品と面積で論理要件を満たす回路を作り、自動Testします。MVPは1課題、専用区画、部品制限、入力Test、結果判定、Resetです。

Mainの技術試験場または将来LABに向きます。対象層、Version差、Tick timing、Test完全性が課題です。**B評価**です。

### FUT-29 Warehouse Sorting / Logistics Work

到着商品を棚入れ・分類し、注文に従ってPick、梱包、出荷する作業最適化Gameです。MVPは小型倉庫、商品数種、入庫、棚、出庫注文、時間Scoreです。

Factory全体よりScopeを絞り、1人でも実作業として成立します。複数人時は受付、搬送、棚入れ、出荷へ分担できます。単調化、Item Entity負荷、AutomationによるGame崩壊、UI不足が課題です。**A評価**です。

### FUT-30 Minecraft Board Game

Minecraft Worldを立体盤面として使い、Turn制でUnit、資源、拠点を操作します。MVPは小盤面、2陣営またはAI、Turn、移動、勝利条件です。

専用Rule実装量に対してMinecraftで行う必然性が弱く、人口またはAIも必要です。LobbyまたはMainの娯楽候補として**C評価**です。

## 7. Initial conclusions

### Strategic candidates

- **True Latest:** Mainの将来的なVersion停滞を補うNetwork戦略。小規模でも役割が成立する。
- **Minestom Limited Minecraft:** 他Serverで代替しにくい看板候補。継続開発能力が前提。

### Strong independent or Frontier-theme candidates

- OneBlock
- Roguelike Expedition
- Base Defense / Horde
- Rotating Challenge World
- Nomadic Survival
- Factory and Logistics Simulation
- Village / Colony Management
- Ecosystem Restoration
- Finite-resource Survival

### Strong additions to existing themes

- Jobs / Contracts
- Cookie Clicker-like Factory
- Construction Contracts
- Disaster Response / Rescue
- Warehouse Sorting / Logistics Work

### Population-dependent or deferred candidates

- ANNI-like
- FPS
- Asymmetric Cooperation

## 8. Next review questions

次段階でも新規案同士を統合せず、上位候補ごとに次を確認します。

1. Playerが最初の15分、1時間、10時間で何をするか。
2. 1人時に中心Loopが完全に成立するか。
3. Minimum Viable Experienceを既製Plugin中心で作れるか、独自Pluginが必須か。
4. Main内Content、Frontier Theme、独立Backendのどれが自然か。
5. 通常Inventory、Waymark、mcMMO、Cosmetic、Achievementの境界。
6. Worldの恒久性、Reset、Season、Backup、Restore。
7. Version追従とClient互換の方針。
8. 継続的なMap、Quest、Enemy、Rule制作がどの程度必要か。
9. 途中参加、長期離脱、Solo、Group、荒らしへの耐性。
10. 国内市場に類似例が少ない理由が、未開拓需要か成立困難性か。
