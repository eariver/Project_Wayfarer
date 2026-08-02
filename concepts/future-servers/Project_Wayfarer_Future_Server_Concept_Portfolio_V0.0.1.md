# Project Wayfarer Future Server Concept Portfolio V0.0.1

**Status:** Draft  
**Document type:** Non-authoritative concept portfolio  
**Target repository:** Project Wayfarer  
**Baseline:** V0.1.0 planned Main, Worlds Beyond and Ruined Frontier  
**Created:** 2026-08-02

> [!IMPORTANT]
> この文書は将来候補の比較・発想・判断履歴を保存する非正本Conceptです。
> V0.1.0 Scope、Roadmap、Plugin選定、World生成、Runtime変更または実装を承認しません。
> 正式仕様と矛盾する場合は`docs/`、`versions.yml`、`plugin-manifest.yml`および追跡対象Runtime Configを優先します。

## 1. Purpose

Project WayfarerのV0.1.0では、恒久生活拠点のMain、PEACEFUL探索のWorlds Beyond、高難度攻略のRuined Frontierを用意する計画です。本Portfolioは、その後に検討しうる新規Server、Frontier Theme、Main内Content、Minestom Backendを、具体化前の段階から一か所へ集約します。

本版では、各新規案を単独のゲームとして評価します。新規案同士の統合は、各案の中心Loop、Minimum Viable Experience、配置、技術難所が個別に明確になるまで扱いません。ただし、既存のMain、Worlds Beyond、Ruined Frontierに新規案を追加する配置候補は評価できます。

## 2. Existing V0.1.0 baseline

| Existing theme | Primary role | Persistence | Core loop | Portfolio role |
| --- | --- | --- | --- | --- |
| Main | 恒久生活、建築、保管、経済、帰還地点 | 長期恒久 | 採集、建築、交流、蓄積 | 新規案との重複と追加適合性を判断する基準 |
| Worlds Beyond | PEACEFULな未知地形探索 | Theme方針に従う | 移動、地形読解、到達、発見 | 非戦闘探索案との重複・拡張性を判断する基準 |
| Ruined Frontier | 廃墟・遺跡・EliteMob・Boss・装備Progression | Theme方針に従う | 戦闘、攻略、Loot、成長 | 戦闘・Dungeon・Hunting案との重複を判断する基準 |

## 3. Evaluation model

### 3.1 Five-point axes

| Axis | Meaning of a high score |
| --- | --- |
| Solo | 1人または極少人数でも中心Loopが成立する |
| Minecraft fit | Block、地形、建築、採掘、Mob等を使う必然性が強い |
| Distinctiveness | 国内公開ServerおよびWayfarer既存3系統との差が明確 |
| Initial feasibility | 初期版を小さく実装しやすい |
| Sustainable operation | 継続的な手作りContent供給や高密度人口への依存が小さい |
| Portfolio complement | Main／Worlds Beyond／Ruined Frontierが満たさない役割を補う |

### 3.2 Overall classes

- **S:** Projectの新しい柱になりうる。独自性または戦略的必要性が特に高い。
- **A:** 有力候補。単独で中心Loopが成立し、配置または実装の検討価値が高い。
- **B:** 条件付き候補。重複、制作量、対象層、技術難度などを解決する必要がある。
- **C:** 人口増加後、Event用途、または余力がある場合の候補。
- **D:** 現時点ではWayfarerで優先する理由が弱い。

評価は採用順位ではありません。特に独自性の高い案ほど実装負荷が大きい場合があります。

## 4. Market context summary

別紙の[minecraft.jp theme trend investigation](investigations/minecraft_jp_server_theme_trends_2026-07-31.md)では、スコア上位60件の86.7%が「サバイバル」、55.0%が「経済」を掲げました。上位は高機能生活Serverと複数Backendを束ねるNetwork型が中心です。

一方、PEACEFUL探索特化、工場物流、生態系再生、機能を削ったMinecraft、有限資源、遊牧、災害救助、一人用Roguelike PvEなどは明確な主流ではありません。ただし市場空白は需要を保証しないため、少人数成立性、説明力、初期MVP、継続運用を個別に確認します。

## 5. Portfolio overview

| ID | Concept | Natural placement | Solo | MC fit | Distinct | Initial | Sustain | Complement | Class |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| BASE-01 | Main | Existing Backend | 5 | 5 | 2 | 4 | 5 | 5 | Baseline |
| BASE-02 | Worlds Beyond | Existing Frontier Theme | 5 | 5 | 4 | 3 | 4 | 5 | Baseline |
| BASE-03 | Ruined Frontier | Existing Frontier Theme | 4 | 4 | 3 | 2 | 3 | 5 | Baseline |
| FUT-01 | True Latest | Independent Paper/Purpur Backend | 5 | 5 | 4 | 4 | 3 | 5 | S |
| FUT-02 | Parkour | Main or Frontier Content | 5 | 4 | 2 | 4 | 3 | 4 | B |
| FUT-03 | ANNI-like | Independent event Backend | 1 | 4 | 3 | 2 | 3 | 4 | C |
| FUT-04 | FPS | Independent event Backend | 1 | 2 | 2 | 2 | 3 | 2 | D |
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
| FUT-24 | Time-loop World | Independent scenario Backend | 5 | 4 | 5 | 1 | 1 | 5 | B |
| FUT-25 | Finite-resource Survival | Independent Backend | 5 | 5 | 4 | 4 | 3 | 5 | A |
| FUT-26 | Merchant / Caravan | Main or Frontier Content | 5 | 5 | 3 | 3 | 3 | 4 | B |
| FUT-27 | Disaster Response / Rescue | Frontier Scenario Content | 5 | 5 | 4 | 2 | 2 | 5 | A |
| FUT-28 | Redstone / Logic Challenges | Main or future LAB Content | 5 | 5 | 3 | 3 | 3 | 4 | B |
| FUT-29 | Warehouse Sorting / Logistics Work | Main Content or Backend | 5 | 4 | 4 | 3 | 4 | 5 | A |
| FUT-30 | Minecraft Board Game | Main or Lobby recreation Content | 5 | 2 | 3 | 2 | 4 | 3 | C |

## 6. Concept records

### FUT-01 True Latest

**One-line concept:** Mainの互換性・資産保護とは分離し、Minecraft公式の最新Releaseへ可能な限り早く追従する最小Plugin Server。

**Core loop:** 新しいVanilla要素を未蓄積状態から発見・攻略し、Season目標またはAchievementを達成する。

**Minimum viable experience:** 最新安定Release、最低限の権限・監査・Backup、独立Inventory、短期またはSeason World、Networkへ返す限定Point。

**Strengths:** MainがPlugin都合でVersion固定されても最新要素を提供できる。追加開発が少なくても存在理由がある。古いClient互換を切り、新Item・Blockを完全利用する方針を明示できる。

**Risks:** Release直後のServer Software・Proxy・運用Tool安定性、World更新方針、死亡・Reset、Season終了後の成果処理。

**Current judgement:** S。最も小さく始めやすく、長期Network戦略上の役割が明確。

### FUT-02 Parkour

**One-line concept:** 手作りまたは地形利用のCourseを一人で反復し、完走、Time、Checkpoint、Rankingを競う。

**Minimum viable experience:** 1 Course、Checkpoint、Reset、計時、個人Best。

**Natural existing placement:** Mainの常設競技、Worlds Beyondの移動試験、Ruined Frontier遺跡内Challenge。

**Risks:** 専門Serverとの差別化と継続的なCourse制作。独立Backendにするほどの初期Content量が必要。

**Current judgement:** B。既存Themeの短時間Contentとして有効。

### FUT-03 ANNI-like

**One-line concept:** 複数Teamが採集・防衛・攻撃を分担し、敵Core破壊を目指す長時間Team Game。

**Minimum viable experience:** 複数Team、資源、拠点Core、Phase、Class、Match管理。

**Risks:** 同時参加者が中心条件で、少人数ではGameが成立しない。NPC補充では役割分担と対人判断を代替しにくい。

**Current judgement:** C。人口形成後の日時指定Event候補。

### FUT-04 FPS

**One-line concept:** Minecraft Client上で銃器、Team、Map、Respawn、Hit判定を用いた対戦を提供する。

**Risks:** 人口依存、専用実装量、Resource Pack負荷、Minecraftで再現する必然性の弱さ。既存国内競合も存在する。

**Current judgement:** D。現段階のProjectでは優先理由が弱い。

### FUT-05 Gambling

**One-line concept:** Main経済内にCasino Chip、Game、Prize、Currency Sinkを提供する。

**Minimum viable experience:** 直接Waymarkを賭けず、交換可能範囲を制御した専用Chipと1種類のGame。

**Risks:** 経済Inflation、期待値、年齢・表現上の配慮、放置・自動操作、実通貨と誤認させない設計。

**Current judgement:** B。独立BackendではなくMainの娯楽・Sink候補。

### FUT-06 OneBlock

**One-line concept:** 1個の再生成Blockから個人またはGroupの島を成長させる少人数向けSurvival。

**Minimum viable experience:** 少数の事前作成Worldまたは島、所有者割当、OneBlock Phase、Spawn、Death Return、Inventory分離。

**Growth path:** Dynamic World作成、Player/Group紐付け、招待、休眠World Unload、再生成、Season。

**Risks:** Multiverse系はWorld操作の下層に過ぎず、島Lifecycle、所有権、復元、削除を独自に管理する必要がある。

**Current judgement:** A。小規模から成立し、国内上位市場でも明確な専門例が少ない。

### FUT-07 Roguelike Expedition

**One-line concept:** 持込制限下で未知領域へ入り、Lootを得て生還または途中撤退する一人用PvE遠征。

**Minimum viable experience:** 1 Mapまたは生成領域、Run初期化、Loot Table、Extraction地点、Death Loss、持帰り枠。

**Natural existing placement:** Ruined Frontierとは恒久装備成長で差別化し、一回ごとのRunと撤退判断を主役にする場合のみ追加候補。

**Risks:** Map・Enemy・Eventの組合せ不足による単調化。Data復旧と複製対策。

**Current judgement:** A。

### FUT-08 Base Defense / Horde

**One-line concept:** 準備時間に資源採集と建築を行い、攻撃WaveからCoreまたは住民を守る。

**Minimum viable experience:** 小規模Map、Core、Build Phase、1系列の敵Wave、勝敗、人数Scaling。

**Strengths:** 採掘、Craft、建築、戦闘を全て中心操作として使える。1人からGroupへScaling可能。

**Risks:** Mob Pathfinding、Block破壊、Chunk負荷、抜け道、建築自由度と攻略性の両立。

**Current judgement:** A。

### FUT-09 Rotating Challenge World

**One-line concept:** 一定期間ごとに一つの特殊Ruleを持つ短期Worldを開き、共通目標を達成する。

**Example rules:** 水位上昇、夜間のみ安全、狭いInventory、移動するBorder、特定高度制限、死亡時の全体難度上昇。

**Minimum viable experience:** 1 Rule、1 World、開始・終了・結果保存、限定Reward。

**Risks:** 継続的なRule設計・検証・告知が必要。更新停止時に存在意義が弱い。

**Current judgement:** A。

### FUT-10 Archaeology / Excavation

**One-line concept:** 地図、古文書、地層、痕跡から発掘地点を特定し、遺物を回収・鑑定・展示する。

**Natural existing placement:** Ruined Frontierの廃墟探索へ追加する非戦闘Loop。Mainには博物館・展示だけを置ける。

**Risks:** 発掘地点と手掛かりのContent制作、再利用性、答え共有による消費。

**Current judgement:** B。独立Themeより既存Ruined Frontierの深掘り候補。

### FUT-11 Instanced Dungeon

**One-line concept:** 1人またはPartyごとに初期化されたDungeonで戦闘、Puzzle、分岐、Bossを攻略する。

**Minimum viable experience:** 1 Instance、入退場、Reset、人数Scaling、Loot境界。

**Risks:** Ruined FrontierおよびEliteMobs Instanceとの重複、Map制作量、Instance Lifecycle。

**Current judgement:** B。

### FUT-12 Nomadic Survival

**One-line concept:** 定住を不利または不可能にし、安全地帯・資源・World Borderを追って移動し続けるSurvival。

**Minimum viable experience:** 移動理由を生む1 Mechanic、持越し手段、次の安全地域を示す情報、終了条件。

**Strengths:** 通常Minecraftの定住前提を少数のRuleで反転できる。

**Risks:** 移動が単なる撤去作業にならない報酬設計、Player不在時の進行、途中参加者。

**Current judgement:** A。

### FUT-13 Jobs / Contracts

**One-line concept:** 採集、討伐、調査、輸送、修復、救助などの短時間依頼を受注して報酬を得る。

**Minimum viable experience:** 数種類のTemplate、受注、進捗、完了、再抽選、Reward上限。

**Natural existing placement:** MainとFrontierの滞在理由を増やす共通Content。独立Backendにはしない。

**Risks:** 単純日課化、効率最適解の固定、Economyへの過剰供給。

**Current judgement:** A。単独Server案ではないがPortfolio全体への効果が高い。

### FUT-14 Factory and Logistics Simulation

**One-line concept:** 設備、加工、電力、搬送、倉庫、注文を物理配置し、生産Networkを最適化する。

**Minimum viable experience:** 原料1種、加工1段、設備2～3種、接続、出力倉庫、固定注文。

**Strengths:** Minecraftの空間・建築を生産設計へ直接使える。国内上位市場で明確な専門例が少ない。

**Risks:** Tick負荷、設備Graph、Chunk Load、Offline処理、所有権、Visualと内部数値の同期。独自Pluginとして大型。

**Current judgement:** A。長期大型候補。

### FUT-15 Asymmetric Cooperation

**One-line concept:** 現場、地図、監視、装置など、Playerごとに異なる情報と操作権を持つ協力Scenario。

**Minimum viable experience:** 2人、1 Scenario、Role別UIまたは視界、共有目標。

**Risks:** 固定人数、Voice/Text communication、途中離脱、再Play性。

**Current judgement:** B。常設Backendより固定Mission候補。

### FUT-16 Puzzle / Escape

**One-line concept:** 建築観察、Block、Redstone、Mob仕様、暗号を使い、閉鎖空間または遺跡から脱出する。

**Minimum viable experience:** 1短編Map、Reset、Hint、完了記録。

**Risks:** 一度解くと消費される。継続Map制作が必要。

**Current judgement:** B。Ruined Frontierの期間限定または固定Adventure候補。

### FUT-17 Cookie Clicker-like Factory

**One-line concept:** 手動生産から設備購入、自動生産、倍率、Offline蓄積、Prestigeへ進むIdle Factory Mini-game。

**Minimum viable experience:** 1 Resource、手動Action、設備3段階、時間生産、Upgrade、上限付きOffline報酬。

**Natural existing placement:** Main内の小型継続Content。物理設備を表示しつつ内部は数値計算できる。

**Risks:** AFK強制、Inflation、単一最適解、Server参加よりOffline回収が有利になる設計。

**Current judgement:** A。整地型の作業Progressionと相性がよく、小さく開始可能。

### FUT-18 Minestom Limited Minecraft

**One-line concept:** Minecraftの機能を追加するのではなく、最小限のBlock・Item・Ruleだけを実装し、Playerの機能Requestによって世界を拡張する。

**Initial limitations examples:** Craftなし、Storageなし、Mobなし、狭いWorld、少数Block、9 Slot Inventory、固定Time。

**Core loop:** 現在の制約下で生活し、必要機能を提案・投票・研究し、Releaseされた新機能で次の問題を解く。

**Minimum viable experience:** Minestom接続、狭いWorld、Block操作、Inventory、永続Player Data、1種類の機能解放、Request記録。

**Governance requirement:** Requestは自由提案可能でも実装保証しない。調整、既存System組合せ、新規研究案件を分ける。採用条件、投票、Release、Season終了を運営側が制御する。

**Risks:** 継続開発がGame運営そのものになる。機能境界、Data Migration、互換性、Request期待値、普通のMinecraftへの収束。

**Current judgement:** S。最も独自だが、着手容易性ではなく看板価値の評価。

### FUT-19 Village / Colony Management

**One-line concept:** Playerの装備より、住民、住居、食料、職業、施設、防衛を成長させるColony Management。

**Minimum viable experience:** 少数NPC、住居判定、食料需要、1職業、人口または幸福指標。

**Risks:** NPC AI、Pathfinding、Chunk Unload、作業詰まり、死亡復旧、建築判定。

**Current judgement:** A。魅力は高いが実装規模も大きい。

### FUT-20 Ecosystem Restoration

**One-line concept:** 荒廃・汚染した土地へ水、土壌、植生、生物を戻し、環境指標を回復させる。

**Minimum viable experience:** 小区画、土壌・水・植生の3指標、数種類の植物、段階的なVisual変化。

**Strengths:** 戦闘・Loot・経済以外の明確なProgression。国内上位市場でほぼ未開拓。

**Risks:** 生態系Modelの説明可能性、単純植林作業への退化、Simulation負荷、状態可視化。

**Current judgement:** A。

### FUT-21 Cartography / Surveying

**One-line concept:** 未知地域を移動し、地形、標高、Biome、遺跡、安全経路、Waystone候補を正確に記録する。

**Natural existing placement:** Worlds Beyondの探索を「発見した」で終わらせず、調査成果へ変換する追加Content。

**Risks:** 座標・Dynmap・既存Map機能が課題を無効化する。正確性の自動評価。

**Current judgement:** B。独立ServerよりWorlds Beyond適合性が高い。

### FUT-22 Construction Contracts

**One-line concept:** 資材、面積、設備、安全性、時間などの要件を満たす建築を設計し、自動検査を受ける。

**Minimum viable experience:** 小型建築課題1種、専用区画、資材上限、Block/設備条件、提出、検査。

**Natural existing placement:** Mainの建築目標と短時間Challenge。

**Risks:** 美観を自動判定しないこと、機能要件判定の抜け道、区画Reset。

**Current judgement:** A。

### FUT-23 Monster Research / Hunting

**One-line concept:** 足跡、被害、鳴き声、時間帯、天候等から特定個体を追跡し、準備・罠・弱点を使って討伐する。

**Natural existing placement:** Ruined FrontierでBossのHP削りより調査と準備を主役にする追加Content。

**Risks:** 痕跡生成、個体AI、答え共有、既存EliteMobとの差別化。

**Current judgement:** B。

### FUT-24 Time-loop World

**One-line concept:** 一定時間ごとにWorldとNPCが初期状態へ戻り、Playerの知識または限定記録だけが残るScenario。

**Minimum viable experience:** 小規模Map、短いLoop、3～5 Event、1つの恒久記録、最終脱出条件。

**Strengths:** 非常に説明力と印象が強い。

**Risks:** Script・Scenario制作量、一度解かれた後の寿命、多人同期、Reset整合。

**Current judgement:** B。常設運営より大型限定Adventure。

### FUT-25 Finite-resource Survival

**One-line concept:** 狭いWorld内の鉱石・木材・装備を有限資産とし、回収、修理、再利用、代替を中心にする。

**Minimum viable experience:** 固定小World、Resource総量、再生成制限、回収・修理Rule、終了目標。

**Strengths:** 少数のRuleで通常Survivalを大きく変えられ、初期実装が比較的軽い。

**Risks:** 独占、廃棄、荒らし、途中参加者、Worldが不可逆に詰む状態。

**Current judgement:** A。

### FUT-26 Merchant / Caravan

**One-line concept:** 地域差のある需要と価格を読み、積載量・経路・危険を管理して商品を輸送する。

**Minimum viable experience:** 2拠点、数商品、価格差、物理Inventory、1移動手段、Server固定需要。

**Natural existing placement:** MainまたはFrontierの地域内Content。初期はPlayer市場でなくNPC需要を使用する。

**Risks:** Teleport・Warpによる輸送無効化、人口不足市場、放置価格差、Alt利用。

**Current judgement:** B。

### FUT-27 Disaster Response / Rescue

**One-line concept:** 洪水、火災、落盤、崩壊、吹雪等の現場で、Block設置・破壊・流体制御・経路構築により救助する。

**Minimum viable experience:** 1 Map、1災害、救助対象、制限時間、資材上限、Score。

**Strengths:** Minecraftの基本操作を戦闘以外のMissionへ転換する。既存3Themeをよく補完する。

**Risks:** Scenario制作、Reset、Fluid/Fire負荷、正解固定。

**Current judgement:** A。

### FUT-28 Redstone / Logic Challenges

**One-line concept:** 限定された部品と面積で論理要件を満たす回路を作り、自動Testする。

**Minimum viable experience:** 1課題、専用区画、部品制限、入力Test、結果判定、Reset。

**Natural existing placement:** Mainの技術試験場または将来LAB。

**Risks:** 対象層が狭い、Version差、Tick timing、Testの完全性。

**Current judgement:** B。

### FUT-29 Warehouse Sorting / Logistics Work

**One-line concept:** 到着商品を棚入れ・分類し、注文に従ってPick・梱包・出荷する作業最適化Game。

**Minimum viable experience:** 小型倉庫、商品数種、入庫、棚、出庫注文、時間Score。

**Strengths:** Factory全体よりScopeを絞り、1人でも実作業として成立する。複数人時は受付、搬送、棚入れ、出荷へ分担可能。

**Risks:** 単調化、Item entity負荷、AutomationによるGame崩壊、UI不足。

**Current judgement:** A。

### FUT-30 Minecraft Board Game

**One-line concept:** Minecraft Worldを立体盤面として使い、Turn制でUnit、資源、拠点を操作する。

**Minimum viable experience:** 小盤面、2陣営またはAI、Turn、移動、勝利条件。

**Risks:** 専用Rule実装量に対してMinecraftで行う必然性が弱い。人口またはAIが必要。

**Current judgement:** C。LobbyまたはMainの娯楽候補。

## 7. Initial portfolio conclusions

### 7.1 Strategic S candidates

- **True Latest:** Mainの将来的なVersion停滞を補うNetwork戦略。小規模でも役割が成立する。
- **Minestom Limited Minecraft:** 他Serverで代替しにくい看板候補。継続開発能力が前提。

### 7.2 Strong independent or Frontier-theme candidates

- OneBlock
- Roguelike Expedition
- Base Defense / Horde
- Rotating Challenge World
- Nomadic Survival
- Factory and Logistics Simulation
- Village / Colony Management
- Ecosystem Restoration
- Finite-resource Survival

### 7.3 Strong additions to existing themes

- Jobs / Contracts
- Cookie Clicker-like Factory
- Construction Contracts
- Disaster Response / Rescue
- Warehouse Sorting / Logistics Work

### 7.4 Population-dependent or deferred candidates

- ANNI-like
- FPS
- Asymmetric Cooperation

## 8. Next review questions

本版の次段階では、新規案同士を統合せず、上位候補ごとに次を詰めます。

1. Playerが最初の15分、1時間、10時間で何をするか。
2. 1人時に中心Loopが完全に成立するか。
3. Minimum Viable Experienceを既製Plugin中心で作れるか、独自Pluginが必須か。
4. Main内Content、Frontier Theme、独立Backendのどれが自然か。
5. 通常Inventory、Waymark、mcMMO、Cosmetic、Achievementの境界。
6. Worldの恒久性、Reset、Season、Backup、Restore。
7. Version追従とClient互換の方針。
8. 継続的なMap・Quest・Enemy・Rule制作がどの程度必要か。
9. 途中参加、長期離脱、Solo、Group、荒らしへの耐性。
10. 国内市場に類似例が少ない理由が、未開拓需要か成立困難性か。

## 9. Change history

- **V0.0.1 / 2026-08-02:** 初版。V0.1.0既存3系統と、会話中に列挙・評価した30新規案を単一Portfolioへ収録。
