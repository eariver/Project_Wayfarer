# Project Wayfarer concepts

このDirectoryは、複数のChatで並行して検討した構想、調査結果、候補比較、未確定仕様、設計上の判断理由および引継ぎ資料をRepository内へ集約するための入口です。正式仕様や実行指示書から分離したまま、採用前の案と旧案の履歴を保持します。

> [!IMPORTANT]
> `concepts/`内の文書は非正本の検討資料です。
> 実装、Repository／Runtime変更、World操作、Plugin／Content取得、Permission／Database変更、Roadmap変更またはRelease承認を指示しません。
> 実作業は、ユーザーが現在のSessionで明示的に割り当てた`codex/`内の個別指示書に従います。

承認済みの現行設計、運用方針、受入基準および現行状態は`docs/`、`versions.yml`、`plugin-manifest.yml`、追跡対象のRuntime Configを確認してください。Conceptと正本が矛盾する場合、Conceptを根拠に正本を変更せず、差異を報告します。

## Directory index

- [Main concepts](main/README.md)：Main Server、恒久生活World、Main向けContent等のConcept
- [Frontier concepts](frontier/README.md)：Frontier全体、World群、Adventure／Exploration Content等のConcept
- 各Directoryの`old/`：改訂によって置き換えられたSuperseded／Historical Concept

現在案はVersion番号や更新日時から推測せず、各Directoryの`README.md`にあるIndexを確認します。

## Lifecycle

Conceptでは必要に応じて次の状態を使用します。

| 状態 | 意味 |
| --- | --- |
| Draft | 作成途中 |
| Under Review | 横断評価または確認中 |
| Candidate | 採用候補 |
| Approved for Task Design | Codex実行指示書の設計に進めてよい状態。実装承認ではない |
| Superseded | 新しい案に置き換え済み |
| Rejected | 不採用。判断理由の履歴として保持 |

状態はFile名だけから推測しません。`Approved for Task Design`を含め、Conceptの状態だけで実装やRuntime変更は承認されません。

## Conceptから実装まで

標準的な流れは次のとおりです。

```text
調査・検討
→ concepts/へ保存
→ 横断評価と採用範囲の承認
→ 必要な正式仕様／Roadmapの更新
→ codex/へ個別実行指示書を作成
→ ユーザーが現在Sessionで明示的に割当
→ 実装・検証
→ docs／Manifest／Acceptance Testsを実態へ更新
```

Conceptを参照するTaskでは、Task本文が明示的に採用した範囲だけを実装できます。

## Manual Git workflow

ユーザーがConcept文書をCodexを介さず手動でCommit／Pushすることは通常運用です。Concepts-only CommitはRuntime変更、正式仕様更新、Codexによる実装承認またはRelease承認を意味しません。

Conceptを実装へ移す場合は、現行正本との整合を確認し、別のCodex実行指示書を作成して明示的に割り当てます。

## Third-party content

第三者のPlugin JAR、Content Pack、Schematic、World、Resource Packその他のArtifactを`concepts/`へCommitしません。Concept文書には、比較と判断に必要な配布元URL、Version、License、Hashおよび調査結果を記録できます。

Repositoryの[MIT License](../LICENSE)は第三者成果物を再許諾しません。第三者成果物には各権利者のLicenseと利用条件が適用されます。
