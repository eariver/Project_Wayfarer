# Codex task instruction archive

このDirectoryには、Project Wayfarerで実際に使用したCodex向け作業指示書を、履歴・監査・再検討のために保存します。

これらは作成時点の作業命令であり、現在のRuntime仕様または実装状態の正本ではありません。完了済み指示書をそのまま再実行してはなりません。

現行状態を判断するときの優先順位：

1. `AGENTS.md`
2. `docs/00-design-guide.md`
3. 対象分野の現行正本文書
4. `versions.yml`
5. `plugin-manifest.yml`
6. `docs/06-acceptance-tests.md`
7. `docs/09-roadmap.md`
8. ユーザーが現在Sessionで明示的に割り当てたCodex Task
9. `codex/`内の完了済み／歴史的指示書
10. `concepts/`内の参考資料

新しいタスクを開始するときは、必ず最新`main`、現在のRuntime、最新の正式文書および既存変更を確認し、古い指示書との差異があれば現行仕様を優先します。

指示書に記載されたVersion、Path、Permission、Plugin状態、試験条件および未実装事項は、その後のCommitで変更されている可能性があります。

## Conceptと実行承認の境界

`concepts/`は非正本の参考資料であり、Codex Taskではありません。割り当て済みTaskはConceptを設計入力として参照できますが、Task本文が明示的に採用した範囲だけを実装できます。Conceptから要求を推測してTask Scopeを拡張しません。

Conceptと`AGENTS.md`、現行正本、Manifest、Runtimeまたは割り当て済みTaskが矛盾する場合は、解決を推測せず停止して報告します。Conceptを参照したことだけを理由に、正式文書、RoadmapまたはRuntimeを更新しません。

`codex/`に指示書が存在するだけでは実行承認になりません。ユーザーが現在のSessionで特定Taskを明示的に割り当てる必要があります。完了済みTaskはそのまま再実行せず、未実施Taskも現在の前提と現行仕様を確認してから扱います。

## 実行履歴

| Task | 状態 | 実施日 | 現行正本 | 再実行 |
| --- | --- | --- | --- | --- |
| [Bootstrap MariaDB and Redis](001-bootstrap-infrastructure.md) | 完了済みの初期Infrastructure指示 | 2026-07-18 | [Installation](../docs/02-installation.md)、[Operations](../docs/03-operations.md) | そのままの再実行禁止 |
| [Main Resource Routing and Dragon Policy](002-main-resource-routing.md) | 未完了。Ver.0.0.4でHub／Gate構築後の作業へ再設計 | 未実施（2026-07-18保存） | [Architecture](../docs/01-architecture.md)、[Roadmap](../docs/09-roadmap.md) | 前提未充足のため再実行禁止 |
| [Phase 1A Permission Foundation](Project_Wayfarer_Phase1A_Permission_Foundation_Implementation.md) | 完了。Phase 1BのBuilder最終Allowlistは未完了 | 2026-07-20 | [Permission Model](../docs/12-permission-model.md) | そのままの再実行禁止 |
| [Phase 2 BetterStructures Integration](Project_Wayfarer_Phase2_BetterStructures_Integration.md) | 完了 | 2026-07-20 | [Design Guide](../docs/00-design-guide.md#main-structure生成)、[Acceptance Tests](../docs/06-acceptance-tests.md#betterstructures-263-2026-07-20) | そのままの再実行禁止。Phase 3以前の暫定World条件は失効 |
| [Phase 3 Main Persistent World Final Generation](Project_Wayfarer_Phase3_Main_Persistent_World_Final_Generation.md) | 完了 | 2026-07-21 | [Main World Baseline](../docs/13-main-world-baseline.md) | 破壊的処理を含むため再実行禁止 |
| [Ver.0.0.5 Documentation Update](Project_Wayfarer_Ver0.0.5_Documentation_Update.md) | 完了 | 2026-07-21 | [Design Guide](../docs/00-design-guide.md)、[Roadmap](../docs/09-roadmap.md)、[Acceptance Tests](../docs/06-acceptance-tests.md) | そのままの再実行禁止 |
| [Phase 4 EvenMoreFish Integration](Project_Wayfarer_Phase4_EvenMoreFish_Integration.md) | 完了（実装Commit: `b77d3be4746a464261f64336c0e668041257eae0`） | 2026-07-21 | [Design Guide](../docs/00-design-guide.md#evenmorefish)、[Acceptance Tests](../docs/06-acceptance-tests.md#evenmorefish-243-2026-07-21)、[Troubleshooting](../docs/05-troubleshooting.md#evenmorefish) | そのままの再実行禁止。Version／Config更新時は現行仕様で再評価 |
| [Waymark Price Scale and EvenMoreFish Shop](Project_Wayfarer_Waymark_Price_Scale_and_EvenMoreFish_Shop.md) | 完了（実装Commit: `967cf664dd96cdbb6b3b75f3da0497e4674fb816`） | 2026-07-22 | [Waymark Economy](../docs/10-waymark-economy.md)、[Roadmap](../docs/09-roadmap.md)、[Acceptance Tests](../docs/06-acceptance-tests.md#waymark-100x-scale-and-evenmorefish-fish-shop-2026-07-22) | そのままの再実行禁止。価格／Reset／Phase 2Bは現行正本で再評価 |
| [Concepts Governance and Repository Integration](Project_Wayfarer_Concepts_Governance_and_Repository_Integration.md) | 完了（実装Commit: `PENDING`） | 2026-07-24 | `AGENTS.md`、[Concepts](../concepts/README.md)、本Archive | そのままの再実行禁止。Conceptは非正本 |
| [V0.2.x Custom Plugin Concept](Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md) | 構想草案。未着手／設計保留、V0.1.0 Scope外 | 2026-07-21 | 現行正本なし。将来の承認済み正式設計を優先 | 実行Taskではない |
| [Task Template](TASK_TEMPLATE.md) | 作業指示書Template。実行Taskではない | 対象外（2026-07-18保存） | 本Fileと現行正本文書 | TemplateをTaskとして実行禁止 |

保存済み指示書はすべて現行仕様の正本ではなく、新しい作業では上記優先順位による再評価が必要です。
