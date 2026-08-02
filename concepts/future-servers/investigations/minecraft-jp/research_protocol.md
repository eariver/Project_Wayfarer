# minecraft.jp継続調査Protocol

**Status:** Draft  
**Document type:** Non-authoritative research protocol  
**Created:** 2026-08-02  
**Applies after:** `minecraft_jp_server_theme_trends_2026-07-31.md`

> [!IMPORTANT]
> この文書は、minecraft.jpおよび公開情報を用いた継続調査の観測・保存・集計方針を定める非正本Conceptです。
> Collector、GitHub Actions、Raw Data Repository、Scheduled PollingまたはProject Wayfarer Runtimeの実装を承認しません。
> 実装へ進む場合は、別途Task設計、権限設計、利用条件確認、Schema定義および受入確認が必要です。

## 1. Purpose

2026年7月31日の初回調査は、日本公開Minecraft Server市場のTheme傾向を探索的に把握するBaselineとして保持します。一方、単一時点のRankingとPlayer数だけでは、平時のPeak、長期変化、Server生存率、Network型と単一Theme型の差を再現可能に比較できません。

本Protocolは、今後の調査を次の4層へ分離します。

1. **Raw snapshot:** 取得元が返した値を改変せず保存する。
2. **Normalized observation:** Stable ID、Timestamp、Source種別等を機械的に整形する。
3. **Derived aggregation:** GitHub Actionsで再生成可能な集計を作る。
4. **Human analysis:** Theme分類、市場解釈、Project Wayfarerへの示唆を人間または本流Chatで判断する。

## 2. Fixed decisions

次を確定事項とします。

- Raw Data Repositoryは恒久的にPublicとする。
- Luna MaxはData収集、Raw File生成、Manifest生成、GitHubへのCommit／Pushまでを担当する。
- GitHub ActionsはSchema検証、機械的な正規化および集計を担当する。
- Theme分類、市場評価、異常値の採否、Project Wayfarer Portfolioへの反映は自動化しない。
- Raw Dataは追記専用とし、過去Fileを上書きしない。
- Derived DataはRaw Dataと集計Codeから再生成可能にする。
- Discord参加後のみ閲覧可能な情報は調査対象外とする。
- 新着Serverは初回、1か月、3か月、6か月で追跡する。
- 定常調査の曜日・時間帯は、平時Calibration完了後に決定する。
- 月次調査は軽量な変化検出、四半期調査は詳細な市場構造分析として分ける。

## 3. Research phases

### 3.1 Phase A: 夏休み参考観測

学校の夏季休業期間中に、14日間の連続Pollingを行います。

目的は次です。

- Collector、Schema、Manifest、Push、Actionsの動作確認
- 曜日・時間帯別Player数の暫定曲線作成
- 夏休み中の昼間人口増加の把握
- 平時観測との比較材料作成

Phase Aは長期休暇の影響を受けるため、定常調査時刻を確定するBaselineには使用しません。

実施開始日はCollectorとPublic Raw Data Repositoryの準備完了後に決定します。

### 3.2 Phase B: 平時Peak Calibration

長期休暇および大型連休から離れた、通常の学校・勤務期間に連続Pollingを行います。

第一候補期間は次です。

```text
2026-10-13T00:00:00+09:00
through
2026-10-25T23:59:59+09:00
```

この期間に大規模なMinecraft Update、主要Server Event、Collector障害等が重なった場合は、同等条件の後続期間へ変更できます。変更理由はManifestまたは調査Reportへ記録します。

Phase Bから次を決定します。

- 平日Peak Window
- 土曜日Peak Window
- 日曜日Peak Window
- Primary Snapshot曜日・時間帯
- Secondary Snapshot曜日・時間帯
- 月次および四半期調査の実行時刻

### 3.3 Phase C: 定常調査

Phase BでPeak Windowを確定した後、次の運用へ移行します。

- **月次:** Primary／Secondary Snapshot周辺の軽量観測
- **四半期:** 7日間のHourly Polling、全掲載一覧取得、個別公開Site確認、分類更新
- **新着追跡:** T0、T1、T3、T6

## 4. Observation scope

### 4.1 Full listing snapshot

Phase開始時・終了時および四半期調査時に、minecraft.jpの全掲載Serverについて取得可能な一覧値を保存します。

全掲載Serverを毎時個別Pingすることは前提としません。

### 4.2 Fixed polling panel

Hourly Polling対象Panelは、Phase開始時に次を統合して作ります。

- Score順上位30件
- Player数順上位20件
- 新着順上位20件
- Project Wayfarerの検討Themeと関連する注目Serverを最大10件

重複はServer／Network Stable IDで除外します。想定規模は40～60 Networkです。

PanelはPhase中に原則固定します。途中で閉鎖・到達不能となったServerも削除せず、状態変化として記録します。新規注目対象は次Phaseで追加します。

### 4.3 Server and backend separation

Ranking、Score、投票、Address等はServer／Network単位で扱います。Game LoopおよびThemeはBackend／Theme単位で扱います。

```text
Server / Network
└─ Backend / Theme
```

Network型Serverを単一Themeとして集計せず、次を分離します。

- Primary Loop: 原則1件
- Secondary Features: 複数可
- Backend／Theme: 複数可

## 5. Polling schedule

Calibration中の基本Scheduleは次です。

| Data | Frequency | Planned timing |
| --- | --- | --- |
| Fixed Panel Server List Ping | Hourly | 毎時07分 JST |
| minecraft.jp Player Ranking | Every 6 hours | 00:17、06:17、12:17、18:17 JST付近 |
| Score、投票、可用性 | Daily | 1日1回 |
| Full listing snapshot | Phase boundary | Phase開始時・終了時 |
| Public official Site review | Quarterly | 詳細調査時 |

Scheduled処理の遅延は失敗と同一視せず、実際の開始・終了Timestampを保存します。

## 6. Raw data rules

Raw Data Repositoryの予定名称は次です。

```text
eariver/Project_Wayfarer_Research_Data
```

Raw Dataは次の原則に従います。

- 1回のPollingにつき一意の`run_id`を使用する。
- TimestampはISO 8601、Timezoneは`Asia/Tokyo`相当のOffset付きで保存する。
- 同じ予定時刻の再実行も別`run_id`として保存する。
- 過去のRaw Fileを更新・削除しない。
- `0 players`、取得失敗、未確認、不明を区別する。
- 取得失敗もManifestへ記録する。
- Server表示名ではなくStable IDで追跡する。
- 取得元を`listed`、`official`、`observed`等で識別可能にする。
- 調査者の推論をRawへ書き込まない。
- 補正が必要な場合は、Raw修正ではなくCorrection Recordを追加する。

推奨状態値は次です。

```text
active
inactive
unreachable
delisted
closed
whitelist
unknown
```

## 7. Luna Max responsibilities

Luna MaxのScheduled Executionは、判断を伴わない定型処理に限定します。

### Required

- Panel／Source Config読込
- Server List Ping
- 指定頻度でのRanking取得
- Raw JSONL／CSV生成
- Run Manifest生成
- Schemaに対する事前検証
- Public Raw Data RepositoryへのCommit／Push
- 取得失敗・部分成功の明示

### Prohibited

- Theme分類
- Serverの成功／失敗判定
- 異常値の恣意的除外
- 過去Rawの上書き
- Wayfarer Concept評価の変更
- 不明値の推測補完
- Collector失敗を`0 players`として保存すること

Luna MaxにはRaw Data Repositoryだけへの最小限のWrite権限を与え、Project Wayfarer本体へのWrite権限を要求しません。

## 8. GitHub Actions responsibilities

GitHub Actionsは、RepositoryへPushされたRaw Dataに対して再現可能な処理だけを行います。

### 8.1 Validation

`raw/**`へのPushを契機として次を検証します。

- JSON Schema／CSV Schema
- 必須Field
- Timestamp形式
- Stable ID形式
- `run_id`重複
- ManifestとRecord件数
- Player数等の型および基本範囲
- Raw Fileの上書き有無

Validation失敗時もRaw Commitは削除しません。該当Runを解析対象外または要確認として識別します。

### 8.2 Daily aggregation

日次集計では次を生成します。

- Network別Hourly値
- Network別平均、中央値、最大値
- 応答成功率
- Fixed Panel全体のPlayer数合計
- Player数中央値およびPercentile
- 上位Networkへの人口集中率
- Version分布
- 欠損・失敗件数

### 8.3 Calibration aggregation

Phase終了時には次を生成します。

- 曜日×時間帯の中央値
- 平日／土曜／日曜別曲線
- Peak Window候補
- 夏休み期間と平時期間の比較
- Network別Peak時刻
- 大型Network除外時の感度分析
- Primary／Secondary Snapshot候補

Actionsは候補を算出しますが、最終的なPeak Window採用判断は行いません。

### 8.4 Periodic aggregation

月次・四半期には次を生成します。

- 前月比・前四半期比
- Ranking、Score、投票、Player数変化
- 新規・消失・到達不能Server
- Version変化
- 新着ServerのT1／T3／T6状態
- minecraft.jp Tagの機械集計

Primary Loopや市場評価等の手動分類はActionsの責務外です。

## 9. Peak determination

単日の最大値だけではPeakを決定しません。Fixed Panelについて、曜日区分ごとの同時刻中央値を主要指標とします。

曜日区分は次です。

- 平日: 月曜日～金曜日
- 土曜日
- 日曜日

各区分で最大中央値となる時刻を求め、最大値の95%以上が連続する範囲をPeak Window候補とします。

補助指標として次を確認します。

- 応答Network数
- Player数中央値
- 第75・第90Percentile
- 上位5 Networkへの集中率
- 大型Network除外時の曲線
- Event等の既知の外乱

Primary Snapshotは市場全体の最大Peak、Secondary Snapshotは異なる曜日区分の代表Peakから選びます。

## 10. Monthly and quarterly research

### Monthly

Primary／Secondary Snapshotについて、Peakの前後1時間を含む3点を観測します。

月次調査は次の変化検出を目的とします。

- Player数
- Ranking
- Score
- 投票
- 稼働状態
- Version
- 新規・消失Network

### Quarterly

四半期調査では次を行います。

- 7日間のHourly Polling
- 全掲載一覧Snapshot
- Score／Player／Recent Ranking
- 上位30件と注目Themeの公開情報再確認
- Primary Loop／Secondary Featureの手動再分類
- Cross-play、Resource Pack、Season等の採用状況集計
- 前回との差分Report
- Project Wayfarer Portfolioへの影響評価

## 11. New-server survival tracking

新着Serverは次の時点で追跡します。

```text
T0: 初回確認
T1: 1か月後
T3: 3か月後
T6: 6か月後
```

確認項目は次です。

- minecraft.jp掲載継続
- Server応答
- Player表示
- Scoreおよび投票
- Version更新
- 公開公式Siteの存続
- 当初Themeの維持・変更
- Network化またはSeason更新
- 閉鎖、休止、Whitelist化

6か月後を標準追跡の終点とします。

## 12. Public information boundary

標準調査対象に含めます。

- minecraft.jp
- 認証不要の公開公式Web Site
- 公開Wiki
- 認証不要の公開告知
- 公開GitHub Repository
- 公開SNS投稿

標準調査対象から除外します。

- Discord参加後のみ閲覧できる情報
- Member限定Channel
- 承認制Community内部
- Login必須の非公開情報
- Serverへ無断参加して得る内部情報

公開Pageに表示されたDiscord人数等は補助情報として記録できますが、主要なCommunity規模指標には使用しません。

## 13. Human analysis responsibilities

Derived Dataの解析では次を人間が判断します。

- Data Qualityと異常値の採否
- Peak Windowの確定
- Server／Backend／Themeの分類
- 市場構造と変化の解釈
- 市場空白が未開拓需要か成立困難性かの評価
- Project Wayfarer Concept Portfolioへの反映
- 人間向けMarkdown Report

機械集計の変更で結論が変わる場合は、Raw Dataと集計Codeから再検証します。

## 14. Non-blocking implementation tasks

次はProtocol上の未決定事項ではなく、Collector／Actions実装時に決めるTaskです。今回のConcept BranchのMergeを妨げません。

- Public Raw Data Repositoryの作成
- Collectorの言語、Runtime、Dependency
- Raw／Manifest／Registryの正式Schema
- Stable ID生成規則
- Fine-grained TokenまたはGitHub Appの認証方式
- Branch ProtectionとActions権限
- CollectorのRetry、Timeout、Rate Limit
- minecraft.jpの利用条件、robotsおよび負荷方針の実装前確認
- Phase Aの実開始日
- ActionsのWorkflow、Test、Derived出力形式
- Luna Max向け実行指示書

## 15. Review gate

Collector実装へ進む前に、少なくとも次を確認します。

- Raw Data RepositoryがPublicで作成されている。
- SchemaとSample DataがReview済みである。
- Raw DataがImmutableであることをTestできる。
- `0 players`と取得失敗を区別できる。
- Token権限がRaw Data Repositoryに限定されている。
- GitHub ActionsがRawを変更せずDerivedだけを生成する。
- Collectorが対象Siteへ過剰なRequestを送らない。
- Calibration期間とPanelがManifestで固定されている。
