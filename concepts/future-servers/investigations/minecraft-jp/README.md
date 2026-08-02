# minecraft.jp research

このDirectoryは、minecraft.jpおよび公開情報を用いた日本Minecraft Server市場の調査方針、実行結果およびProject Wayfarerへの示唆を管理します。

> [!IMPORTANT]
> ここにある文書は非正本の調査資料です。
> Project Wayfarer Runtime、Roadmap、Plugin、World、Permission、Databaseまたは実装を変更・承認しません。

## Current status

2026年8月2日のExpanded Ranking Trialは完了しました。Data収集RepositoryはOn holdであり、現在はScheduled CollectionおよびActiveなManual Collection Workflowを持ちません。

定期的な市場観測は必須要件とせず、今後必要になった時だけ、不定期の一回限り調査として再開します。再開には新しい調査範囲、Run ID、Source access確認、Dry-run、明示承認およびReview済みWorkflowが必要です。

## Completed trial analysis

- [2026年8月2日 minecraft.jp Ranking Trial分析](minecraft_jp_ranking_trial_analysis_2026-08-02.md)
  - Score上位30件、Player上位20件、Recent上位20件の70 Recordを分析します。
  - 70 Recordを55 ListingへDeduplicateし、Ranking間の重複、Tag比率、Player集中、ScoreとPlayer数の差を確認します。
  - Main、Solo成立性、段階的Network拡張およびFuture Server Portfolioへの示唆を整理します。
  - Portfolio Classは変更せず、既存評価の根拠を補強します。

## Baseline investigation

- [2026年7月31日 minecraft.jp Theme動向調査](../minecraft_jp_server_theme_trends_2026-07-31.md)
  - 初回の探索的Snapshotです。
  - 継続調査Protocol適用前のため、一部のRaw一覧、取得時刻、再現可能性に制約があります。
  - 過去のBaselineとして保持し、新しい方法論へ遡及的に書き換えません。

## Dormant protocol reference

- [継続調査Protocol](research_protocol.md)
  - 夏休み参考観測、平時Peak Calibration、月次・四半期調査、新着6か月追跡を設計したProtocolです。
  - Luna Max、GitHub Actions、人間による解析の責務を分離します。
  - 現在は運用承認されておらず、定期調査の実施計画ではありません。
  - 将来、継続観測が必要になった場合の設計Referenceとして保持します。

## Research data repository

Raw、Manifest、Collector、Schema、TestおよびDerived Dataは、Project本体と分離したPublic Repositoryで管理します。

- [eariver/Project_Wayfarer_Research_Data](https://github.com/eariver/Project_Wayfarer_Research_Data)
- Current state: On hold
- Completed Trial Run ID: `45ec07fb-f779-46e0-aea4-123dbca9243a`
- Raw Commit: `aef22a80dfaafc723c8f07b6c00e07a0a0ce82b1`
- Derived Commit: `774d4cf5c47311089abd746d73293f0194fe3341`

Historical Raw DataはImmutableとして保持します。完了したConfigとRun IDは再利用しません。

## Responsibility boundary

| Component | Responsibility |
| --- | --- |
| Luna Max or approved collector execution | 明示承認された範囲の収集、Raw生成、Manifest生成、GitHub Push |
| GitHub Actions | Schema検証、正規化、機械集計、Derived生成 |
| Human analysis | Theme分類、異常値判断、市場解釈、Wayfarerへの反映 |

現在は収集実行を保留していますが、この責務分離は将来の不定期調査でも維持します。
