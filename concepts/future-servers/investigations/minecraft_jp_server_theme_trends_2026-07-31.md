# minecraft.jpランキングから見る日本Minecraftサーバーのテーマ動向

**Status:** Investigation snapshot  
**調査日:** 2026年7月31日  
**対象:** Japan Minecraft Servers（minecraft.jp）のScore順上位60件、Player数順上位20件、新着順上位20件、および主要Serverの個別Page・公式Site  
**目的:** 日本公開Minecraft ServerにおけるTheme、Game Loop、運営形態、技術的訴求の流行を把握し、Project Wayfarerの将来Concept評価に使用する。

> [!IMPORTANT]
> minecraft.jpの順位は純粋な同時接続人数順ではありません。公式Helpによれば、Scoreは登録日数、過去30日間の投票数、個別Pageの共有数、可用性、登録後1週間のBoostから計算されます。本調査では「Score上位＝現在最も遊ばれている」とは解釈せず、Score順、Player数順、新着順を分けて読みます。

> [!NOTE]
> この文書は一時点の市場Snapshotです。順位、Score、Player数、Server仕様および公式Siteは変化します。市場空白は需要を保証しません。

## 1. Executive summary

日本の公開Minecraft Server市場は、現在も明確に**生活Server中心**です。Score上位60件のうち52件、86.7%が「Survival」、33件、55.0%が「Economy」を掲げています。個別説明を読み直して主題を分類すると、約3分の2は恒久生活、経済生活、建築生活、RPG風生活、PvP生活など、生活Serverからの派生として理解できます。

上位Serverの勝ち筋は、単にVanilla生活を提供することではなく、概ね次の二つへ分かれます。

1. **総合Network型**  
   生活、建築、RPG、PvP、銃、Creative等を別Backendとして束ね、同じ入口から選ばせる。
2. **生活＋一本の強いHook型**  
   整地、建築、経済、Casino、独自Item、地球建国、鉄道、最新版追従、Hardcore等、一文で説明できる主題を生活基盤へ載せる。

純粋なRPG、Parkour、銃PvP、Zombie Escape、Extraction FPS、Hardcore等の専門Serverも存在しますが、数は少なく、Score上位では生活系より下に位置しやすい傾向があります。品質だけでなく、少人数時の成立性、投票習慣、恒久資産、Community定着の差が影響していると考えられます。

今回確認した上位Serverでは、次の要素が頻繁に観測されました。ただし、これらは個別の採用率を集計していないため、「標準装備」とまでは断定しません。

- Java EditionとBedrock EditionのCross-play
- 広いClient Version互換
- 保護された恒久建築Worldと定期Reset Resource World
- `/home`、Warp、Web Map等の生活利便性
- mcMMO、Jobs、独自進捗、Quest等の長期Progression
- 投票Point、Gacha券、独自Item等の投票Reward
- Server Resource PackによるMOD不要の独自武器、家具、Model
- Discord、Web Site、Wiki、EventによるGame外Community

Project Wayfarerの観点では、Mainは市場の中心へ真正面から入るため競合が多い一方、Worlds Beyondのような**PEACEFUL探索特化**、Minestomによる**機能を削ったMinecraft**、生態系再生、時間Loop、工場物流、有限資源等は、今回確認した上位60件では明確な主流ではなく、差別化余地があります。

## 2. Methodology

### 2.1 Ranking views

- [Score順](https://minecraft.jp/servers/score) 上位60件
- [Player数順](https://minecraft.jp/servers/player) 上位20件
- [新着順](https://minecraft.jp/servers/recent) 上位20件
- 各Serverのminecraft.jp個別Page
- 情報が不足する場合は公式Site、Wiki、Portal

### 2.2 Classification

minecraft.jpのTagは自己申告であり、「Mini-game」「RPG」「Survival」の粒度もServerごとに異なります。そのため二段階で分類しました。

1. **Tag集計:** Survival、Economy、PvP、Mini-game等の出現数を集計。
2. **主題の再分類:** 個別説明を読み、Playerが最初に認識する中心Loopを生活、建築、Network複合、銃PvP等へ手作業で分類。

本調査で「生活系派生」とした範囲には、生活、生活・経済、生活・建築、建築生活、Vanilla生活、RPG風生活、PvP生活、Season生活、および生活Backendを主軸とするNetwork複合を含めます。境界事例を含む手作業分類であるため、Executive summaryでは厳密値ではなく「約3分の2」として扱います。

### 2.3 Limitations

- 順位、Score、Player数は常時変動します。
- 調査時刻により瞬間同時接続数は大きく変わります。
- Player数表示はPing応答やProxyのServer List表示に依存し、実態とずれる場合があります。
- 新着順は新規開設と完全には一致せず、登録、再登録、情報更新の影響を受ける可能性があります。
- Tagは自己申告であり、実際の主役と一致しない場合があります。
- Whitelist型、配信者Community、外部SNS中心のServerは投票Rankingに表れにくい場合があります。

## 3. Quantitative tag analysis

### 3.1 Score top 20

| Tag | Count | Ratio |
| --- | ---: | ---: |
| Survival | 19 | 95.0% |
| Economy | 10 | 50.0% |
| Mini-game | 10 | 50.0% |
| Creative | 7 | 35.0% |
| PvP | 6 | 30.0% |
| Firearms | 5 | 25.0% |
| Parkour | 4 | 20.0% |
| RPG | 2 | 10.0% |
| Whitelist | 1 | 5.0% |

### 3.2 Score top 60

| Tag | Count | Ratio |
| --- | ---: | ---: |
| Survival | 52 | 86.7% |
| Economy | 33 | 55.0% |
| PvP | 20 | 33.3% |
| Mini-game | 15 | 25.0% |
| Creative | 13 | 21.7% |
| Firearms | 11 | 18.3% |
| Parkour | 9 | 15.0% |
| RPG | 8 | 13.3% |
| Whitelist | 4 | 6.7% |

### 3.3 Recent top 20

| Tag | Count | Ratio |
| --- | ---: | ---: |
| Survival | 18 | 90.0% |
| Economy | 14 | 70.0% |
| Mini-game | 8 | 40.0% |
| Creative | 5 | 25.0% |
| PvP | 5 | 25.0% |
| RPG | 5 | 25.0% |
| Whitelist | 4 | 20.0% |
| Firearms | 3 | 15.0% |
| Parkour | 2 | 10.0% |

### 3.4 Interpretation

- Survivalはほぼ前提条件で、上位20件では95%、上位60件でも86.7%です。
- Economyは半数以上に存在し、新着順では70%です。新規参入者も「生活＋経済」を安全な基本形として選ぶ傾向があります。
- PvPは約3分の1ですが、説明を読むとPvP専門より生活Serverの追加機能である場合が多くあります。
- Mini-gameは上位20で50%ですが、総合Networkや生活Serverの副Contentを含みます。
- RPGは上位60で13.3%に留まり、市場全体の中心ではありません。
- Firearmsは18.3%存在しますが、上位の多くは銃専門ではなく総合Serverの一要素です。
- 新着順ではRPGとWhitelistがやや増えますが、中心構造は依然として生活、経済、複合型です。

## 4. Dominant patterns

### 4.1 Life server is the default product

現在の生活Serverは単なるVanilla Survivalではありません。今回確認した上位生活Serverでは、恒久建築World、定期Reset Resource World、保護、Economy、Player Shop、Home、Warp、Web Map、mcMMO、Jobs、独自Progression、投票Reward、Event、Discord、Cross-play等が頻繁に観測されました。

まんまみーやはVanilla感を残しながら保護、週次Reset Resource World、mcMMO、爆速Minecart、Elevator、独自進捗、観光Stamp Rally、氷上Boat Raceを備えます。できたてServerはEconomy Balance、保護、Upgradeを前面に出します。

Essentials、Economy、保護、mcMMOを揃えるだけでは差別化になりません。Wayfarer MainはNetwork全体の恒久拠点、保管、交流、帰還地点として説明する必要があります。

### 4.2 High-ranked servers often become multi-backend networks

アジ鯖は長期生活、Season開拓、銃FPS、Creativeを同一Networkで提供します。Nekozouneko Serverも軽量生活、地球Map建国、月次Reset型高速生活、王道Survivalを選択可能にしています。EXR-Networkは都市鉄道、TheLow RPG、Survivalを分けます。

Network型には、Themeに飽きてもCommunityを保持できる、Brandと投票を集約できる、長期生活と短期Contentを両立できる、VersionとBalanceをBackendごとに分離できる利点があります。

一方、小規模Networkでは各Backendへ人口が分散します。新規ProjectではServer数そのものを価値にせず、一人でも成立するBackendを優先する必要があります。

### 4.3 Building remains a strong independent theme

朱サバ、おやさい鯖、建築の森、Universal Minecraft Studios、マインクラフト建築部等、建築系は複数存在します。

- 生活建築型: 資材を集め、Economyを回しながら恒久Worldへ建てる。
- 建築補助型: Flight、資材購入、編集機能、ArmorStand、Art Map等を提供する。
- 共同都市型: 一つの都市・地域を複数人で継続制作する。
- 再現建築型: Theme Park、都市、実在施設等を高精度再現する。
- 観光型: Stamp Rally、自動Tour、Web Map、Galleryで既存建築を再利用する。

建築は一人でも成立し、成果がServer資産として残り、後から来たPlayerが観光できます。このため人口が少ない時期にもContentが失われにくい性質があります。

### 4.4 Repetitive work can become progression

整地鯖は、本来は手段である整地をLevel、Skill、Reward、Effect、Rankingによって目的化しています。反復作業は、数値が積み上がる、効率が上がる、Visualが変わる、他者と比較できる、成果がWorldへ残る、Event Boostがある場合に長期Contentとなりえます。

これは工場物流、Cookie Clicker型設備育成、採掘、倉庫整理、農業等のConceptに追い風です。

### 4.5 Economy is used for progression and retention

Ranking上位のEconomyは、Player間自由市場だけを意味しません。採掘品のServer売却、Jobs、資材購入、機能Upgrade、Casino、Gacha、Auction、投票Reward等に使われます。

Man10 Serverは「億万長者」を明確な目標とし、採掘販売、商売、Casinoを中心Loopへまとめています。Economyは長期ProgressionとCurrency Sinkの役割を持ちます。

人口が少ない新規ServerでPlayer間市場だけに依存すると流動性が不足するため、NPC需要、固定依頼、Server買い取り等が必要です。

### 4.6 Voting is integrated into game progression

minecraft.jpのScoreには直近30日投票数が含まれ、Votifierで投票結果をServerへ通知できます。上位ServerはGacha券、独自Item、強化Tool、投票Point、Currency、Effect、連続投票Grade等をRewardとして使います。

Score上位はTheme人気だけでなく、投票導線と既存Community規模にも影響されます。Rankingを需要調査に使う場合、この内生性を分離する必要があります。

### 4.7 Server resource packs replace many client-mod requirements

Client MODを必須にする上位Serverは少なく、代わりにServer Resource Packで独自武器、銃、家具、Gacha景品、季節Model、Cosmetic、UI、Sound、Mob外観を表現します。

参加障壁を下げられる一方、配布、Version互換、Model管理、初回Download時間が運用課題です。

### 4.8 Cross-play and broad version compatibility are acquisition infrastructure

上位にはJava/Bedrock対応を明示するServerが多く、古いVersionから最新相当まで広いClient範囲を表示するNetworkもあります。友人同士のEdition差を吸収し、UpdateできないPlayerを残し、複数Backendを単一入口で提供できます。

ただし古いClient対応は新Item、Block、UIの利用制限を伴います。WayfarerがTrue Latest Backendを設ける場合、ViaBackwardsを導入せず、新仕様を完全に遊べることを価値にできます。

### 4.9 Seasons address the new-player gap

恒久生活Serverは既存資産が増えるほど、新規Playerが追いつきにくくなります。毎Season新Worldで再出発する、月次Resetして一部資産だけ継承する、Resource Worldだけ定期Resetする等の形式が見られます。

Season制は人口再集結、Economy Reset、Update導入、新規参加者の公平性に有効ですが、建築の恒久保存とは相性が悪いため、生活本体と別Backendまたは別Worldに分ける例が多くあります。

### 4.10 PvP, firearms and mini-games are population-dependent

上位60件ではPvP 33.3%、Firearms 18.3%、Mini-game 25.0%ですが、多くは生活またはNetworkの副要素です。専門例にはZombie Escape、銃撃戦、Kit/FFA、Extraction FPS、銃PvP、Parkourがあります。

専門Serverは説明しやすい反面、同時参加者がいないと成立しにくくなります。HouCraftが一人でも遊べる洞窟探索を併設していることは、この弱点への対策と読めます。

WayfarerでANNI、FPS、純PvPを早期投入する優先度が低いという判断は、この傾向と整合します。

### 4.11 RPG is not the dominant category

専用RPGとしてTheLow、BTC RPG等が見られますが、上位60件のRPG Tagは13.3%です。多くは総合Network内の独立RPG Backend、または生活ServerへQuest、Magic、Level、Equipmentを加えたRPG風Survivalです。

専用RPGはMap、Story、Enemy、Equipment、Quest、Balanceの継続制作が必要です。Ruined Frontierのように既製Content PackageとPluginを活用する方式は、独自RPGを全面制作するより現実的です。

### 4.12 Niche specialization increases below the top ranks

中位以下には、整地、建築、非MOD鉄道、地球Map建国、Zombie Escape、銃PvP、Extraction FPS、Hardcore、Parkour、農業、地下社会、都市計画、再現建築、東方Project、地図絵Slot等、一文で説明できる専門Themeが増えます。

専門Themeほど同時接続、Content制作、説明不足の影響を受けやすく、上位定着には「一人でも進む」「恒久成果が残る」「投票を日課化できる」等の補助構造が必要です。

## 5. Score rank and player-count rank are different signals

minecraft.jpのScore順位とPlayer数順位は一致しません。Player数順ではWhitelist型の大規模再現建築Serverが上位に出る一方、Score順位は低く投票数が少ない例があります。

この差から次が分かります。

1. 投票RankingはBrand忠誠度と日課設計に強く影響される。
2. 外部SNS、配信者、制作Community、Whitelist型は投票が少なくても人口を持ちうる。
3. 瞬間同時接続は時刻、Event、Ping表示仕様で大きく変わる。
4. Score上位Themeを、そのまま日本人が最も遊んでいるThemeとは断定できない。
5. 上位60件と新着20件の双方で生活・経済が支配的なため、大局としての生活中心傾向は頑健である。

## 6. Recent-server trends

新着順上位20件でもSurvival 90%、Economy 70%で、新規参入も既存市場の基本形を踏襲しています。目立ったHookには「帰って来れる場所」、ゆったり生活、都市計画、村長System、地下社会、便利なVanilla、生活＋Dungeon、生活＋RPG、季節Event、独自Pluginがあります。

運営側は最初から巨大な独自Gameを作るより、生活基盤を用意し、独自Pluginを少しずつ追加する方を選びやすいと読めます。一方、複数Tagを掲げるだけでは既存上位との差別化が難しく、「何をする場所か」を一文で説明できる主題が必要です。

## 7. Project Wayfarer comparison

| Wayfarer element | Similar market theme | Competition | Assessment |
| --- | --- | ---: | --- |
| Main | Economy、生活、建築、mcMMO、Resource World | 非常に高い | 基盤として必要だが単独では埋没しやすい |
| Worlds Beyond | PEACEFUL、Iris地形、立体移動、探索 | 低い | 上位60件に明確な同型が見当たらず強い差別化 |
| Ruined Frontier | 遺跡、EliteMob、Boss、Quest、装備Progression | 中程度 | RPG風生活やDungeonと競合するが高難度専用Themeとして説明可能 |
| Velocity Network | アジ鯖、Nekozouneko、EXR等 | 高い | 市場実績はあるが人口分散に注意 |
| Waymark限定横断 | 投票通貨、Network共通Reward | 中程度 | 通常Itemを共有しない点がBalance維持に有効 |

### 7.1 Main

Mainに必要な保護、Economy、Resource World、mcMMO、建築、投票Rewardは、今回確認した上位生活Serverで頻繁に観測される要素です。Mainの役割は市場にないGameではなく、Wayfarer全体の恒久拠点、保管、交流、共通Progressionとして定義すべきです。

### 7.2 Worlds Beyond

今回の調査で最も競合が少ないThemeです。探索を掲げる生活Serverは多い一方、戦闘を排除し、独自地形と移動Mechanicを主役にしたThemeは上位で確認できませんでした。

「PEACEFUL＝簡単」ではなく、「移動、地形読解、到達、発見」をGameにする説明ができれば、国内市場で明確な空白を狙えます。

### 7.3 Ruined Frontier

RPG、Dungeon、独自Mob、Bossは既存市場にも存在するため、単にRPG要素があるという説明では弱くなります。廃墟探索、高難度、装備Progression、死亡・撤退判断等、Playerが何を繰り返すかを明確にする必要があります。

## 8. Position of proposed concepts

| ID | Concept | Nearest observed pattern | Market density | Differentiation | Note |
| --- | --- | --- | ---: | ---: | --- |
| FUT-01 | True Latest | Latest life、Vanilla-like life | Medium | High | Plugin都合で遅れないことを制度化できる |
| FUT-02 | Parkour | Chelcy等 | Medium | Medium | Course品質と更新頻度が勝負 |
| FUT-03 | ANNI-like | 下位に類似例 | Low | Medium | 市場空白より人口要件が問題 |
| FUT-04 | FPS | Gun PvP、LeonGunWar、Kamikaze | Medium | Low-Medium | 専門競合と同時接続依存 |
| FUT-05 | Gambling | Man10、MOFUCRAFT | High | Low | Main内Currency Sinkに自然 |
| FUT-06 | OneBlock | 上位60で明確な専門例なし | Low | High | 少人数成立性が強い |
| FUT-07 | Roguelike Expedition | Extraction FPSが部分近似 | Low | High | PvE中心なら独自性が高い |
| FUT-08 | Base Defense / Horde | 明確な上位例なし | Low | High | Minecraft基本操作との相性がよい |
| FUT-09 | Rotating Challenge World | Season生活が部分近似 | Low | High | 継続的なRule供給が必要 |
| FUT-10 | Archaeology / Excavation | 遺跡探索の一要素 | Low | High | 主役化すれば差別化可能 |
| FUT-11 | Instanced Dungeon | RPG、Dungeon Server | Medium | Medium | Ruined Frontierと重複しやすい |
| FUT-12 | Nomadic Survival | 明確な例なし | Low | High | 定住型生活の反転 |
| FUT-13 | Jobs / Contracts | 生活Serverの標準追加要素 | High | Low | 独立Themeより共通基盤向き |
| FUT-14 | Factory and Logistics Simulation | 明確な専門例なし | Low | Very high | 大型実装だが市場空白 |
| FUT-15 | Asymmetric Cooperation | 明確な例なし | Low | High | 固定人数要件が弱点 |
| FUT-16 | Puzzle / Escape | 配布Map、Event | Low | Medium-High | 消費型Contentで制作負荷が高い |
| FUT-17 | Cookie Clicker-like Factory | 整地型Progressionが近い | Low | High | 日本市場の作業Progressionと相性がよい |
| FUT-18 | Minestom Limited Minecraft | 明確な例なし | Very low | Very high | 最も独自だが継続開発が運営になる |
| FUT-19 | Village / Colony Management | 村長、都市計画が部分近似 | Low | High | NPC AIと状態管理が重い |
| FUT-20 | Ecosystem Restoration | 明確な例なし | Very low | Very high | 国内市場でほぼ未開拓 |
| FUT-21 | Cartography / Surveying | 観光、地図、鉄道が部分近似 | Low | High | Worlds Beyondに自然 |
| FUT-22 | Construction Contracts | 建築Eventが部分近似 | Medium | High | 自動判定できれば独自 |
| FUT-23 | Monster Research / Hunting | RPG Bossが近い | Medium | High | 痕跡と調査を主役にする必要 |
| FUT-24 | Time-loop World | 明確な例なし | Very low | Very high | 強いがScenario消費型 |
| FUT-25 | Finite-resource Survival | Hardcore、Anarchyが部分近似 | Low | High | 小さな実装で体験を変えやすい |
| FUT-26 | Merchant / Caravan | Economy、Railwayが部分近似 | Medium | Medium-High | Warp制約とNPC需要が必要 |
| FUT-27 | Disaster Response / Rescue | 明確な例なし | Very low | Very high | 短編Missionとして独自 |
| FUT-28 | Redstone / Logic Challenges | 建築、技術Community | Low | Medium | 対象層は狭い |
| FUT-29 | Warehouse Sorting / Logistics Work | 明確な例なし | Very low | High | 小規模でも成立 |
| FUT-30 | Minecraft Board Game | Mini-game | Medium | Low-Medium | Minecraftで行う必然性は弱い |

## 9. Apparent market gaps

今回の上位60件と新着20件では、次のThemeはほぼ確認できませんでした。

1. 非戦闘の探索特化
2. 工場、物流、生産最適化
3. 生態系再生等の環境Simulation
4. 機能制限を主役にしたMinecraft
5. 有限性、移動性を主役にしたSurvival
6. 災害対応、救助
7. 一人で成立するRoguelike PvE
8. OneBlockのInstance運用

市場空白は需要を保証しませんが、生活、Economyの模倣よりProject固有の説明を作りやすくなります。

## 10. Implications for Project Wayfarer

### 10.1 V0.1.0 priorities are reasonable

Main、Worlds Beyond、Ruined Frontierは生活、探索、戦闘を分担します。通常Inventoryを分離し、Waymark等の限定要素だけを共有する設計は、複数ThemeのBalance崩壊を避ける点で合理的です。

### 10.2 Main should not compete on feature count

国内上位の生活Serverは長年の建築、成熟したEconomy、Discord人口、Wiki、投票習慣を持ちます。新規Mainが同じ土俵で機能数を競うのは不利です。

Mainは恒久拠点、建築・保管、安全なEconomy、他Themeから帰る場所、Waymarkの利用先、Project全体の展示とCommunityへ集中すべきです。

### 10.3 True Latest is practical differentiation

最新版対応を掲げる生活Serverは存在しますが、長期Mainとは別に、最低限Pluginで新要素を完全に試せることを制度化したNetworkは多くありません。

- Mainは資産とPlugin互換を優先する。
- Latestは公式Updateへの即応を優先する。
- 古いClient互換を切り、新Block、Itemを完全利用する。
- Season成果だけWaymark等へ変換する。

長期運営上の技術的問題をPlayer価値へ変換できます。

### 10.4 Minestom Limited Minecraft is a flagship candidate

「Minecraftの機能を削り、Player要望で追加する」Serverは今回の調査範囲で確認できませんでした。既存の独自Plugin生活Serverとは発想が逆で、説明力が高くあります。

一方、要望が無制限の開発要求にならないよう、採用Category、実装保証、投票、技術Tree、Season終了条件を設計する必要があります。

### 10.5 Work progression should not be underestimated

整地鯖の長期上位実績は、単純作業でもProgression、演出、比較、恒久成果を与えれば成立することを示します。Cookie Clicker-like Factory、Warehouse Sorting / Logistics Work、Agriculture、Mining、Logisticsは日本市場と相性がよい可能性があります。

### 10.6 Population-dependent concepts should remain deferred

ANNI、FPS、純PvP、Asymmetric Cooperationは競合の有無より人口密度が問題です。Wayfarerでも同時参加者を要求する企画はCommunity形成後に検討する方が安全です。

## 11. Conclusion

minecraft.jpから見た日本Minecraft Server市場は、生活、Economyを基盤に、建築、独自Item、RPG、PvP、Mini-gameを付加する構造が支配的です。上位は長期運営と投票習慣を持つ総合Networkまたは高機能生活Serverで、新着Serverも同じ型を踏襲しています。

Project Wayfarerが単に便利な生活Server、独自要素の多いServerを名乗っても差別化は難しくあります。一方、現在の構想には市場空白と重なるものが複数あります。

- Worlds Beyondの非戦闘探索
- FUT-01 True Latest
- FUT-18 Minestom Limited Minecraft
- FUT-14 Factory and Logistics Simulation
- FUT-20 Ecosystem Restoration
- FUT-25 Finite-resource Survival
- FUT-12 Nomadic Survival
- FUT-27 Disaster Response / Rescue
- FUT-07 Roguelike Expedition
- FUT-06 OneBlock

V0.1.0ではMainを安定した帰還地点として完成させ、Worlds BeyondとRuined Frontierで生活以外の理由を提示します。その後、True Latestのような低Cost・高説明力のBackendを追加し、Minestom Limited MinecraftやFactory and Logistics Simulationのような大型独自案を長期開発する戦略が有力です。

## Appendix A. Score top 60 theme classification

| Rank | Server | Primary category | minecraft.jp tags | Summary |
| ---: | --- | --- | --- | --- |
| 1 | まんじゅうサーバー (Man10 Server) | 経済・複合 | Economy / Survival / Creative / PvP / Mini-game / Firearms / Parkour | 億万長者を目指すEconomyを中心にDungeon、採掘販売、商売、Casino、銃、PvP、Fishingを束ねる。 |
| 2 | アジ鯖 | Network複合 | Economy / Survival / Creative / PvP / RPG / Firearms / Parkour | 長期生活、Season開拓、銃FPS、Creative等の複数Backend。 |
| 3 | まんまみーや | 生活 | Survival | Vanilla感を残した恒久生活。保護、Resource World、mcMMO、観光、進捗、Race。 |
| 4 | できたてサーバー | 生活・経済 | Economy / Survival / Mini-game | Economy Balance、土地保護、Upgrade、投票Reward。 |
| 5 | 整地鯖 | 作業特化 | Survival / Mini-game | 整地と建築をLevel、Skill、RewardでGame化。 |
| 6 | 朱サバ | 建築 | Economy / Survival / Creative / Mini-game | 建築補助、資材売買、作品Tour、Art Map、Auction。 |
| 7 | もりのパーティ！ | 生活・最新版 | Survival | 最新Minecraftでのゆったり生活。 |
| 8 | EXR-Network | Network複合 | Survival / Creative / RPG | 非MOD鉄道、都市開発、TheLow RPG、Survival。 |
| 9 | KotaServer | 生活 | Survival | Single感覚とMulti生活の両立。 |
| 10 | ごろごろ鯖 | 生活 | Economy / Survival | まったり型Economy生活。 |
| 11 | MOFUCRAFT!!! | 生活＋独自要素 | Economy / Survival / Mini-game / Firearms | Resource Pack独自Model、武器、Gacha、Slot、季節Event。 |
| 12 | Nekozouneko Server | Network複合 | Economy / Survival / PvP / Mini-game | 軽量生活、地球Map建国、月次Reset型、王道生活。 |
| 13 | おやさい鯖 | 建築 | Economy / Survival / Creative / Mini-game | 建築専門。 |
| 14 | kasu world | Network複合 | Economy / Survival / Creative / PvP / Mini-game / Firearms / Parkour | 複数Genreを掲げる総合生活型。 |
| 15 | 節電鯖 | 恒久Vanilla生活 | Survival | 2011年以来のWorld継続を価値にする。 |
| 16 | 東方サーバー | IP Theme生活 | Survival / PvP | 東方Project ThemeのCommunity型。 |
| 17 | とりあえずMinecraft Server | 生活・建築 | Economy / Survival / Creative / Mini-game | 長期運営の生活、建築＋α。 |
| 18 | Kaede Zombie Escape | 対戦Mini-game | PvP / Mini-game / Firearms / Parkour | Zombie Escape特化。 |
| 19 | OWL_server | 小規模生活 | Survival / Whitelist | 少人数、建築、まったり型。 |
| 20 | 美味ぽん酢 Server | 生活・娯楽 | Survival | 初心者歓迎の複合娯楽生活。 |
| 21 | AMiT Server | 生活 | Economy / Survival | Resource収集中心の生活。 |
| 22 | おこ鯖。 | 生活・建築 | Survival / Creative | Java/Bedrockの自由生活。 |
| 23 | ちゃぶだいさ～ば～ | 生活 | Economy / Survival | 新規歓迎Community生活。 |
| 24 | Kamikaze War Server | 銃PvP | Survival / PvP / Firearms | MOD不要の銃撃戦。 |
| 25 | ほとけ鯖 | Network複合 | Economy / Survival / PvP / Mini-game / RPG | 複合生活、対戦、RPG。 |
| 26 | 建築の森サーバー | 共同建築 | Creative | 都市を共同制作するCreative特化。 |
| 27 | HouCraft | 銃PvP＋探索 | Economy / PvP / RPG / Firearms / Parkour | 銃撃戦と一人でも遊べる洞窟探索。 |
| 28 | かぼすサーバー | 生活・建築 | Survival / Creative | のんびり建築と冒険。 |
| 29 | 経済屋2.5期β | 国家・戦争 | Economy / Survival / PvP / Whitelist | 生活Economyと国家戦争。 |
| 30 | Rezxis Network | Network複合 | Economy / Survival / Creative / PvP / Mini-game / RPG / Firearms / Parkour | Player Realmsと複数RPG。 |
| 31 | くらげ鯖 | 生活 | Survival | Soloでも共同でも遊べる生活。 |
| 32 | BTC RPG | RPG | Economy / RPG | 専用RPG。 |
| 33 | ruru鯖 | 小規模生活 | Economy / Survival | 小規模Economy生活。 |
| 34 | Unknown Network | 生活 | Economy / Survival | 自由、快適性を訴求する生活。 |
| 35 | Escape from Crafterz | Extraction FPS | Economy / Survival / PvP / Firearms | Tarkov型探索、Loot、装備購入、PvP、Market。 |
| 36 | スピ鯖 | RPG風生活 | Economy / Survival / PvP / RPG | 生活にRPG、PvPを付加。 |
| 37 | 鼻毛鯖 | 生活＋PvP | Economy / Survival / PvP / Parkour | 生活を基盤にPvP、Parkourを追加。 |
| 38 | AsiaMC | 生活 | Economy / Survival | Economy生活。 |
| 39 | MCPlayNetwork〈蛇鯖〉 | Vanilla生活 | Survival | 最低限のRuleで自由に遊ぶ。 |
| 40 | Freiheit Server 3rd | 生活＋Mini-game | Survival / Mini-game | 建築生活と地図絵Slot。 |
| 41 | MinCraServer Verβ | RPG風生活 | Economy / Survival | 剣と魔法を加えた高難度生活。 |
| 42 | RoomMC | 生活 | Economy / Survival / PvP | 難しくない生活。 |
| 43 | はっぴーさーばー2 | RPG風生活 | Economy / Survival / RPG | RPG風Survival。 |
| 44 | ChelcyNetwork | Parkour＋整地 | Survival / Mini-game / Parkour | 大規模Parkourと整地。 |
| 45 | Shinmachi-server | 都市生活 | Economy / Survival | 都市生活型。 |
| 46 | わくわく★ハードコアサバイバル | Hardcore | Survival / PvP | 死亡即終了のAnarchy＋Hardcore。 |
| 47 | ケーキサーバー | 生活 | Survival | 初心者歓迎の王道生活。 |
| 48 | Universal Minecraft Studios Server | 再現建築 | Creative / Whitelist | 大規模、高再現度の共同制作。 |
| 49 | Camelot Server | Season生活 | Survival | Season制生活。 |
| 50 | ねこサーバーβ | 建築生活 | Economy / Survival | 建築系生活。 |
| 51 | とら鯖 Re:Birth | Network複合 | Economy / Survival / PvP / Mini-game / Firearms | Java/Bedrock対応の複合生活。 |
| 52 | 5dollar.serv.nu | 生活 | Economy / Survival / PvP | 家具要素を持つ生活。 |
| 53 | Rin84.myserver.gs | 不明 | 記載なし | 一覧上の説明、Tag不足。 |
| 54 | おいでよ！マイクラの森 | 生活 | Economy / Survival | まったり生活。 |
| 55 | マインクラフト建築部 | 建築 | Economy | 建築Community。 |
| 56 | SHUNserver2 | Vanilla生活 | Survival / Whitelist | 小規模Vanilla。 |
| 57 | losteden.net | 高難度生活 | Economy / Survival / Creative / Parkour | 高難度、自由を掲げる生活。 |
| 58 | Strike Gun PvP II | 銃PvP | PvP / Firearms | 銃PvP特化。 |
| 59 | 弱肉強食サーバー | PvP生活 | Survival / PvP | 対人を含む生活。 |
| 60 | noasaba | 生活 | Survival | 程よい王道Survival。 |

## Appendix B. Principal references

- [Japan Minecraft Servers Score ranking](https://minecraft.jp/servers/score)
- [Japan Minecraft Servers Player ranking](https://minecraft.jp/servers/player)
- [Japan Minecraft Servers Recent ranking](https://minecraft.jp/servers/recent)
- [Japan Minecraft Servers Help](https://minecraft.jp/help)
- [Man10 Server](https://minecraft.jp/servers/dan5.red)
- [アジ鯖](https://minecraft.jp/servers/mc.azisaba.net)
- [まんまみーや](https://minecraft.jp/servers/play.manmamiya.work)
- [できたてサーバー](https://minecraft.jp/servers/dekitateserver.com)
- [整地鯖](https://minecraft.jp/servers/play.seichi.click)
- [朱サバ](https://minecraft.jp/servers/5382f96f4ddda109d00041a8)
- [EXR-Network](https://minecraft.jp/servers/mc.eximradar.jp)
- [MOFUCRAFT](https://minecraft.jp/servers/mofucraft.net)
- [Nekozouneko Server](https://minecraft.jp/servers/nekozouneko.net)
- [Kaede Zombie Escape](https://minecraft.jp/servers/play.kze.network)
- [HouCraft](https://minecraft.jp/servers/HouCraft.cf)
- [Escape from Crafterz](https://minecraft.jp/servers/mc.efcrafterz.net)

## Appendix C. Metrics for future re-investigation

- Score上位100件のTag比率
- 各Serverの順位、Score、直近30日投票
- 瞬間同時接続ではなく1週間の平均とPeak
- 新着Serverの6か月後生存率
- Java/Bedrock Cross-play比率
- 最新版対応までの日数
- 単一Theme型とNetwork型の順位推移
- 投票Rewardの有無
- Resource Pack必須率
- Season制、Reset制の採用率
