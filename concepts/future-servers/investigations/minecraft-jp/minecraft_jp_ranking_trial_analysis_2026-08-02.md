# minecraft.jp Ranking Trial分析 2026-08-02

**Status:** Completed trial analysis  
**Document type:** Non-authoritative market investigation  
**Observed at:** 2026-08-02T20:48:05+09:00  
**Run ID:** `45ec07fb-f779-46e0-aea4-123dbca9243a`

> [!IMPORTANT]
> この文書は、単一時点の公開Ranking SnapshotをProject WayfarerのConcept Portfolioへ接続するための調査資料です。
> Serverの長期的成功、収益性、継続率、実際の同時接続Peakまたは各Themeの需要を証明しません。
> Project WayfarerのV0.1.0 Scope、Roadmapまたは実装を変更・承認しません。

## 1. Purpose

2026年7月31日の初回調査では、minecraft.jpのScore上位60件を中心に、日本の公開Minecraft Server市場ではSurvivalとEconomyが広く、生活ServerおよびNetwork型Serverが目立つという探索的Baselineを得ました。

今回のTrialでは、公開Rankingを再現可能なRaw Dataとして保存し、GitHub Actionsで機械集計するPipelineを実際に通しました。本分析の目的は次です。

- 初回調査の主要傾向が、再取得したScore上位30件でも維持されるか確認する。
- Score順、Player順、Recent順が異なる市場側面を示すことを確認する。
- 少人数で開始するProject WayfarerのConcept評価軸へ、観測結果を接続する。
- 今後の不定期調査で再利用可能なData Repositoryと制約を記録する。

## 2. Source data

DataはPublic Repositoryで管理します。

- Repository: [eariver/Project_Wayfarer_Research_Data](https://github.com/eariver/Project_Wayfarer_Research_Data)
- Trial Manifest: [`raw/manifests/2026/08/02/2026-08-02T20-48-05+09-00_45ec07fb-f779-46e0-aea4-123dbca9243a.json`](https://github.com/eariver/Project_Wayfarer_Research_Data/blob/main/raw/manifests/2026/08/02/2026-08-02T20-48-05%2B09-00_45ec07fb-f779-46e0-aea4-123dbca9243a.json)
- Raw Commit: [`aef22a80dfaafc723c8f07b6c00e07a0a0ce82b1`](https://github.com/eariver/Project_Wayfarer_Research_Data/commit/aef22a80dfaafc723c8f07b6c00e07a0a0ce82b1)
- Derived Commit: [`774d4cf5c47311089abd746d73293f0194fe3341`](https://github.com/eariver/Project_Wayfarer_Research_Data/commit/774d4cf5c47311089abd746d73293f0194fe3341)
- Score Summary: [`45ec07fb-f779-46e0-aea4-123dbca9243a_score.json`](https://github.com/eariver/Project_Wayfarer_Research_Data/blob/main/derived/ranking-snapshots/2026/08/02/45ec07fb-f779-46e0-aea4-123dbca9243a_score.json)
- Player Summary: [`45ec07fb-f779-46e0-aea4-123dbca9243a_player.json`](https://github.com/eariver/Project_Wayfarer_Research_Data/blob/main/derived/ranking-snapshots/2026/08/02/45ec07fb-f779-46e0-aea4-123dbca9243a_player.json)
- Recent Summary: [`45ec07fb-f779-46e0-aea4-123dbca9243a_recent.json`](https://github.com/eariver/Project_Wayfarer_Research_Data/blob/main/derived/ranking-snapshots/2026/08/02/45ec07fb-f779-46e0-aea4-123dbca9243a_recent.json)

収集範囲は次の70 Ranking Recordです。

| Ranking | Records |
| --- | ---: |
| Score順 | 30 |
| Player数順 | 20 |
| Recent順 | 20 |
| Total | 70 |

Ranking間の重複を`listing_id`で除くと、70 Recordは55 Listingに相当します。Score上位30件とPlayer上位20件の重複は13件、Recent上位20件のうち他2系列にも含まれたものは2件でした。

## 3. Mechanical results

### 3.1 Ranking-level summary

| Ranking | Records | Displayed players total | Mean | Median | Mean Score | 30-day votes total | Mean availability |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Score top 30 | 30 | 681 | 22.7 | 8.0 | 833.96 | 23,404 | 99.03% |
| Player top 20 | 20 | 974 | 48.7 | 30.5 | 824.845 | 20,477 | 98.95% |
| Recent top 20 | 20 | 113 | 5.65 | 1.5 | 123.31 | 469 | 98.85% |

これらのPlayer値はminecraft.jpに掲載された値であり、Project Wayfarer側から各ServerへDirect Server List Pingした結果ではありません。

### 3.2 Tag ratios

| Tag | Score top 30 | Player top 20 | Recent top 20 |
| --- | ---: | ---: | ---: |
| Survival | 28 / 30 = 93.3% | 17 / 20 = 85.0% | 13 / 20 = 65.0% |
| Economy | 16 / 30 = 53.3% | 11 / 20 = 55.0% | 9 / 20 = 45.0% |
| Mini Games | 11 / 30 = 36.7% | 11 / 20 = 55.0% | 7 / 20 = 35.0% |
| Creative | 11 / 30 = 36.7% | 8 / 20 = 40.0% | 3 / 20 = 15.0% |
| PvP | 10 / 30 = 33.3% | 6 / 20 = 30.0% | 5 / 20 = 25.0% |
| Firearms | 7 / 30 = 23.3% | 4 / 20 = 20.0% | 3 / 20 = 15.0% |
| RPG | 5 / 30 = 16.7% | 3 / 20 = 15.0% | 4 / 20 = 20.0% |
| Parkour | 5 / 30 = 16.7% | 4 / 20 = 20.0% | 2 / 20 = 10.0% |
| Whitelist | 2 / 30 = 6.7% | 1 / 20 = 5.0% | 3 / 20 = 15.0% |

Score上位30件のSurvival、Economy、PvP比率は、初回調査のScore上位60件における86.7%、55.0%、33.3%と大きく矛盾しません。CreativeとMini Games等は上位30件で高く見えますが、Sample範囲が異なるため増加傾向とは判定しません。

## 4. Findings

### 4.1 Survival and Economy remain the default market language

Score上位30件の28件、Player上位20件の17件がSurvivalを掲げ、Economyもそれぞれ16件、11件でした。初回調査と合わせると、公開Serverを説明する基本語彙としてSurvivalとEconomyが非常に強いことは再確認できます。

ただし、これは「通常Survivalを作ればPlayerが集まる」という意味ではありません。競合が多く、既存上位Serverは投票、長期運営、機能蓄積、複数Version対応、複数Theme等を持つため、新規Serverが同じ説明だけで差別化することは困難です。

### 4.2 Score is not concurrent population

Player上位20件のうちScore上位30件にも入ったListingは13件でした。残る7件はPlayer上位であってもScore上位30件外です。

具体例として、Player順1位のUniversal Minecraft Studios Serverは143人表示、Score 276.7、30日投票0でした。Player順5位の24san.orgは66人表示、Score 153.6、投票0、Player順6位のja.awayserver.comは65人表示、Score 96.6、投票0でした。

一方、Score上位30件の30日投票23,404票のうち、Score上位10件が19,410票、約82.9%を占めました。Score Rankingは市場への露出、投票導線および継続的なListing活動を含む指標として有用ですが、単一時点のPlayer数と同一視できません。

### 4.3 Displayed population is concentrated

Player上位20件の表示Player合計974人のうち、上位5件が554人、約56.9%、上位10件が795人、約81.6%を占めました。

Score上位30件でも表示Player合計681人のうち、Score上位5件が341人、約50.1%、上位10件が537人、約78.9%でした。

単一Snapshotであるため長期的な集中率とは扱えませんが、少数の大型Listingが観測人口の大半を持ち、残りの多くは1桁から数十人で運営される構造は確認できます。

### 4.4 Recent Ranking is not a reliable new-server population baseline

Recent上位20件のPlayer中央値は1.5人でした。合計113人のうち、ja.awayserver.comの65人が約57.5%を占め、これを除く19件の合計は48人、平均約2.53人です。

さらにja.awayserver.comとBTC RPGはPlayer上位20件にも含まれていました。Recent Rankingを「開設直後のServer」または「新規参入だけの集合」と断定できません。

したがって、Recent Rankingは候補発見用には使用できますが、新規Serverの初期人口、生存率または成長率を評価するには、初回確認日を別途記録して追跡する必要があります。

### 4.5 Public listing metadata has mechanical anomalies and omissions

Player順6位のja.awayserver.comは`65 / 0`と表示されました。Raw DataはSource値を補正せず保存しています。これはDirect Ping結果ではないため、Listed Player数とListed Capacityを独立値として扱います。

Recent上位20件では7件がTagなしでした。Tagは自己申告であり、未設定はThemeなしを意味しません。また、一つのNetworkが複数Backendを持つ場合、Listing TagだけではPrimary Loopを特定できません。

## 5. Implications for Project Wayfarer

### 5.1 Main is a retention foundation, not the primary differentiator

恒久生活、建築、保管、経済を担うMainは、市場の基本期待と整合します。Mainを持つ判断自体は妥当ですが、Survival／Economyであることだけでは独自性になりません。

Wayfarerの差別化は、Mainへ機能を無制限に積み上げるより、Worlds Beyond、Ruined Frontierおよび将来Backendが明確な体験を提供し、Mainが帰還・蓄積・交流地点としてそれらを束ねる構造に置く方が自然です。

### 5.2 Solo viability remains a mandatory design axis

Recent群の低い中央値と、Score上位30件にも0～1人表示のServerが複数あることから、新規Projectは常時多数接続を前提にできません。

Portfolioの`Solo`軸は維持し、次を初期採用条件とします。

- 1人で中心Loopが進行する。
- 2～4人では効率または選択肢が増える。
- 多人数がいなければMatchが開始しない案は初期の柱にしない。
- 非同期に残る建築、Progression、記録、共有目標を持つ。

この観点はFUT-03 ANNI-likeをC、FUT-04 FPSをDとする既存評価を補強します。

### 5.3 Network expansion should be incremental

Player上位には複数Tagを持つNetwork型が多い一方、Player上位20件の7件はScore上位30件外でした。Theme数、Score、投票、Player数の間に単純な一方向関係はありません。

Wayfarerは初期から多数Backendを同時展開するのではなく、Mainと計画済みFrontierを安定させ、独立して説明可能なLoopを一つずつ追加する方針を維持します。各BackendはPlayer数を奪い合う可能性があるため、共通通貨、帰還導線、成果還元、開催期間等でNetwork全体へ接続する必要があります。

### 5.4 Broad version compatibility is common, but not universal

Player上位には`1.7.2-26.2`等の広いVersion範囲を掲げるListingが複数ありました。これは幅広いClientを受け入れる運用が、活動中Networkの一つの戦略であることを示します。

FUT-01 True Latestは、この市場と同じ互換性競争をする案ではありません。Mainの安定性・資産保護と分離し、最新要素を完全利用する短期Backendとして位置付けることで差異が明確になります。Trialは需要を証明しませんが、既存の**S評価を変更せず、差別化軸を「最新Version」ではなく「最新専用・短期・独立Inventory」に置く**ことを補強します。

### 5.5 Secondary tags do not justify standalone backends

Player上位20件ではMini Gamesが11件、ParkourとFirearmsが各4件ありました。しかしTagは複数選択可能であり、それらが主な参加理由とは限りません。

したがって、FUT-02 ParkourをMain／Frontier内ContentとしてB、FUT-04 FPSを人口形成後でも優先度の低いDとする評価を維持します。Mini Game、Parkour、Firearms等は、独立Server化より先に既存Loopを補助する小規模Contentとして検証する方が安全です。

### 5.6 Market whitespace remains unproven demand

OneBlock、Roguelike Expedition、Base Defense、Factory and Logistics、Ecosystem Restoration、Finite-resource Survival等は、minecraft.jpの既存Tagだけでは存在または需要を判定できません。

今回のTrialはこれらのClassを上げ下げする根拠にはしません。独自Conceptは引き続き、説明力、Solo成立性、Minimum Viable Experience、Content供給負荷およびWayfarer既存3系統との補完関係で評価します。

## 6. Portfolio disposition

今回のTrialによるPortfolio Class変更はありません。

| Portfolio area | Disposition |
| --- | --- |
| BASE-01 Main | Baseline維持。市場適合は高いがDistinctivenessが低いという評価を補強 |
| BASE-02 Worlds Beyond | Baseline維持。Mainと異なる非戦闘探索Loopを持つ補完価値を補強 |
| BASE-03 Ruined Frontier | Baseline維持。生活Serverとの差を作る攻略Loopとしての役割を補強 |
| FUT-01 True Latest | S維持。広範Version互換と競わない独立最新Backendとして定義を補強 |
| FUT-02 Parkour | B維持。Standalone需要ではなくSecondary Contentとして観測 |
| FUT-03 ANNI-like | C維持。初期人口依存が大きい |
| FUT-04 FPS | D維持。Firearms Tagの存在だけではStandalone Backendを正当化しない |
| Other S/A/B concepts | 変更なし。Current Tag taxonomyと単一Snapshotでは評価不能 |

## 7. Research repository status

`eariver/Project_Wayfarer_Research_Data`は、今回のTrial完了後にOn holdとしました。

保持しているもの:

- Immutable Raw JSONLとRun Manifest
- JSON SchemaとValidator
- Ranking CollectorとUnit Test
- GitHub Actions用の機械集計Code
- Derived JSON／CSV
- 完了したTrial Config
- Archived Workflow

現在の運用:

- Scheduled Collectionなし
- ActiveなManual Collection Workflowなし
- minecraft.jpの継続自動取得なし
- 必要時の不定期調査だけを個別承認

次回再利用時は、同じRun IDまたは完了Configを再利用しません。新しい調査範囲、Run ID、Source access確認、Dry-run、明示承認およびReview済みWorkflowを用意します。

## 8. Limitations

- 2026年8月2日20:48 JSTの単一Snapshotです。
- 日曜日かつ夏季休業期であり、平時の曜日・時間帯を代表しません。
- Player数はminecraft.jp掲載値で、Direct Pingではありません。
- Score、Player、Recentの70 Recordは独立70 Serverではなく、55 Listingです。
- `server_id`はRegistry未整備のため`null`で、Network／Backend単位のDeduplicationをしていません。
- Recent Rankingの意味をServer開設日と同一視できません。
- Tagは自己申告で、Primary Loopではありません。
- Official Site、Cross-play、Resource Pack、Season、Reset、運営人数等は今回収集していません。
- Player数、Score、投票の時間変化を観測していません。
- marketplace全体または非掲載Serverを代表しません。

## 9. Decision

- Trialは完了とする。
- Raw／Derived DataとCollector基盤は再利用可能な状態で保持する。
- 定期調査は必須とせず、RepositoryはOn holdとする。
- 市場動向を再確認する必要が生じた時だけ、不定期の一回限り調査として再開する。
- Project WayfarerのPortfolio Classは変更せず、Mainの役割、Solo成立性、段階的Network拡張という既存判断を補強するEvidenceとして保存する。
