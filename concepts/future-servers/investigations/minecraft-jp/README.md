# minecraft.jp research

このDirectoryは、minecraft.jpおよび公開情報を用いた日本Minecraft Server市場の継続調査方針を管理します。

> [!IMPORTANT]
> ここにある文書は非正本の調査資料です。
> Collector、GitHub Actions、Raw Data Repository、Scheduled PollingまたはProject Wayfarer Runtimeの実装を承認しません。

## Current protocol

- [継続調査Protocol](research_protocol.md)
  - 夏休み参考観測、平時Peak Calibration、月次・四半期調査、新着6か月追跡を定義します。
  - Luna Max、GitHub Actions、人間による解析の責務を分離します。
  - Public Raw Data Repository、Immutable Raw、再生成可能なDerived Dataを前提とします。

## Baseline investigation

- [2026年7月31日 minecraft.jp Theme動向調査](../minecraft_jp_server_theme_trends_2026-07-31.md)
  - 初回の探索的Snapshotです。
  - 継続調査Protocol適用前のため、一部のRaw一覧、取得時刻、再現可能性に制約があります。
  - 過去のBaselineとして保持し、新しい方法論へ遡及的に書き換えません。

## Responsibility boundary

| Component | Responsibility |
| --- | --- |
| Luna Max | 収集、Raw生成、Manifest生成、GitHub Push |
| GitHub Actions | Schema検証、正規化、機械集計、Derived生成 |
| Human analysis | Theme分類、異常値判断、市場解釈、Wayfarerへの反映 |

## Planned external repository

RawおよびDerived Dataは、Project本体と分離したPublic Repositoryで管理する計画です。

```text
eariver/Project_Wayfarer_Research_Data
```

Repository作成、Schema、Collector、WorkflowおよびCredential設定は、別Taskとして設計・Reviewします。
