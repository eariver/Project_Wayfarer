# Investigation Reports

このDirectoryは、Project WayfarerへのIntegration中に見つかった、通常の受入試験だけでは説明できない互換性問題、障害、Data Integrity懸念および再現調査を保存する場所です。

## 目的

- 調査開始時の現象と影響範囲を残す。
- 実施した切り分けを時系列で残し、同じ調査のやり直しを防ぐ。
- 確定した事実、除外した仮説および推論を区別する。
- 上流Projectへ報告できる最小再現情報を残す。
- 修正版導入時の再検証条件を明確にする。

## 収録方針

Report名は原則として`YYYY-MM-DD-<subject>.md`とします。Reportには必要に応じて次を含めます。

1. Summaryと現在のStatus
2. 対象Version、Build、JavaおよびSHA-256
3. 現象、期待結果および影響範囲
4. 調査履歴と使用した読み取り専用Command
5. Config、依存関係、RuntimeおよびData経路の確認結果
6. 除外した原因候補
7. 根本原因または現時点の最有力仮説
8. Workaround、上流報告情報および再検証条件

秘密情報、Player UUID、個人Credential、未加工Log、World DataおよびDatabase Dataは収録しません。必要なLogは秘密情報と個人識別子を除いた最小限の抜粋または要約だけを記載します。

## Reports

| Date | Subject | Status | Report |
| --- | --- | --- | --- |
| 2026-07-19 | RedisEconomy 4.5.12のPaper 26.2 Command応答消失 | Wayfarer互換Buildで解決・再検証済み | [Detailed report](2026-07-19-rediseconomy-paper-26-2-message-compatibility.md) |
| 2026-07-20 | BetterStructures公式Packのlegacy bed DataFixer message | 非阻害・上流Artifact更新時に再確認 | [Detailed report](2026-07-20-betterstructures-legacy-bed-datafixer-message.md) |
| 2026-07-26 | CoreProtect CE 24.0のPaper 26.2 Runtime拒否 | Active Runtime rollback済み・Order 7延期方針へ反映 | [Detailed report](2026-07-26-main-coreprotect-v24-paper-26-2-compatibility.md) |
| 2026-07-26 | Frontier Order 8 Artifact／World／Runtime Lock候補 | Phase A完了・Artifact／承認待ち | [Detailed report](2026-07-26-frontier-order8-lock-preflight.md) |
| 2026-07-26 | Plugin ScopeとFrontier Lock Revision 003再同期 | 文書同期完了・Proposal 003承認待ち | [Detailed report](2026-07-26-plugin-scope-and-frontier-lock-revision003-resync.md) |
