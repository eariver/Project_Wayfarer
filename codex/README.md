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
8. `codex/`内の歴史的指示書

新しいタスクを開始するときは、必ず最新`main`、現在のRuntime、最新の正式文書および既存変更を確認し、古い指示書との差異があれば現行仕様を優先します。

指示書に記載されたVersion、Path、Permission、Plugin状態、試験条件および未実装事項は、その後のCommitで変更されている可能性があります。

## 実行履歴

| Task | 状態 | 実施日 | 現行正本 | 再実行 |
| --- | --- | --- | --- | --- |
| [Bootstrap MariaDB and Redis](001-bootstrap-infrastructure.md) | 完了済みの初期Infrastructure指示 | 2026-07-18 | [Installation](../docs/02-installation.md)、[Operations](../docs/03-operations.md) | そのままの再実行禁止 |
| [Main Resource Routing and Dragon Policy](002-main-resource-routing.md) | 未完了。Ver.0.0.4でHub／Gate構築後の作業へ再設計 | 未実施（2026-07-18保存） | [Architecture](../docs/01-architecture.md)、[Roadmap](../docs/09-roadmap.md) | 前提未充足のため再実行禁止 |
| [Phase 1A Permission Foundation](Project_Wayfarer_Phase1A_Permission_Foundation_Implementation.md) | 完了。Phase 1BのBuilder最終Allowlistは未完了 | 2026-07-20 | [Permission Model](../docs/12-permission-model.md) | そのままの再実行禁止 |
| [Phase 2 BetterStructures Integration](Project_Wayfarer_Phase2_BetterStructures_Integration.md) | 完了 | 2026-07-20 | [Design Guide](../docs/00-design-guide.md#main-structure生成)、[Acceptance Tests](../docs/06-acceptance-tests.md#betterstructures-263-2026-07-20) | そのままの再実行禁止。Phase 3以前の暫定World条件は失効 |
| [Phase 3 Main Persistent World Final Generation](Project_Wayfarer_Phase3_Main_Persistent_World_Final_Generation.md) | 完了 | 2026-07-21 | [Main World Baseline](../docs/13-main-world-baseline.md) | 破壊的処理を含むため再実行禁止 |
| [Task Template](TASK_TEMPLATE.md) | 作業指示書Template。実行Taskではない | 対象外（2026-07-18保存） | 本Fileと現行正本文書 | TemplateをTaskとして実行禁止 |

保存済み指示書はすべて現行仕様の正本ではなく、新しい作業では上記優先順位による再評価が必要です。
