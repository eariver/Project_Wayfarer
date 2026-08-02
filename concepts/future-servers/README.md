# Future server and theme concepts

このDirectoryは、Project Wayfarerの将来候補となる新規Server、Frontier Theme、Main内ContentおよびMinestom Backendの非正本Conceptを索引します。

> [!IMPORTANT]
> `concepts/future-servers/`内の文書は採用前の検討資料です。
> V0.1.0 Scope、Roadmap、Runtime、Plugin取得、World生成、Database、Permissionまたは実装を変更・承認しません。
> 実装へ移す場合は、現行正本との整合確認、採用範囲の承認、正式文書の更新、およびユーザーが現在Sessionで明示的に割り当てる専用`codex/`指示書が必要です。

## Current portfolio

- [Future Server Concept Portfolio](Project_Wayfarer_Future_Server_Concept_Portfolio.md)
  - V0.1.0予定のMain、Worlds Beyond、Ruined Frontierを基準に、これまでに検討した新規案を同一評価軸で整理します。
  - 新規案同士の統合案は扱いません。V0.1.0で計画済みのMain／Worlds Beyond／Ruined Frontierへの配置適合性だけを比較します。
  - 各評価は初期仮説であり、採用順位または実装順を確定しません。

## Investigations

- [minecraft.jp継続調査](investigations/minecraft-jp/README.md)
  - 夏休み参考観測、平時Peak Calibration、月次・四半期調査、新着6か月追跡の方針を管理します。
  - Luna MaxによるRaw収集、GitHub Actionsによる機械集計、人間による市場解釈を分離します。
  - Public Raw Data RepositoryとImmutable Raw Dataを前提とし、Collector実装は別Taskとして扱います。
- [minecraft.jpランキングから見る日本Minecraftサーバーのテーマ動向](investigations/minecraft_jp_server_theme_trends_2026-07-31.md)
  - minecraft.jpのScore順上位60件、Player数順上位20件、新着順上位20件と主要個別Siteを調査した初回市場Snapshotです。
  - RankingのScoreを同時接続人数と同一視せず、生活、経済、Network型の傾向と市場空白を分析します。
  - 継続調査Protocol適用前の探索的Baselineとして保持します。

## File naming

- Gitで履歴を管理するため、索引対象のConcept文書名には版番号を付けません。
- 特定時点の外部調査は、調査対象時点を明示するため日付をFile名に含める場合があります。
- 旧版を別Fileとして残す必要がある場合だけ、`old/`へ移動し、現行Indexから分離します。

## Working rules

1. 一つの新規案は、初期段階では単独のGame Loopとして評価します。
2. 「新規案Aと新規案Bを組み合わせる」は、各案の単独評価が進むまで保留します。
3. 「V0.1.0で計画済みのMain／Worlds Beyond／Ruined Frontierへ新規案を追加する」は配置候補として評価できます。
4. 独立Backend候補はVelocity配下への追加を前提に比較しますが、Paper、Purpurその他のServer softwareは各案の追従速度、機能、互換性および運用要件を確認するまで固定しません。Minestomを前提とする案は別に明示します。
5. 少人数で開始するProjectであるため、1人時の成立性と同時参加者依存を分けて記録します。
6. Conceptの独自性だけでなく、初期実装、継続制作、運用、Version追従、Player Data境界を評価します。
7. 市場に類似例が少ないことを需要の証明とは扱いません。

## Promotion criteria

Portfolio内の案を個別Conceptへ分離する目安は次のとおりです。

- 一文で中心Game Loopを説明できる。
- 1人時と複数人時の成立条件を説明できる。
- Minimum Viable Experienceを定義できる。
- Main内Content、Frontier Theme、独立Backend、Minestom Backendのいずれが自然か比較できる。
- 計画済み3系統との差異と重複を説明できる。
- 初期実装と継続運用の主な難所を列挙できる。
- 採用しない場合にも判断履歴として残す価値がある。

## Lifecycle

上位`concepts/README.md`のLifecycleを使用します。現時点のPortfolioおよび収録案は原則`Draft`です。