# Project Wayfarer Concepts管理導入・Codex運用境界更新 指示書

## 1. 目的

Project Wayfarer Repositoryへ、実装前の構想、調査結果、比較、仕様草案および複数Chat間の引継ぎ資料を保存するための`concepts/`階層を正式に導入する。

本タスクでは、ユーザーが手動配置したConcept文書を同一Commitへ含めるとともに、`AGENTS.md`、Repository案内文書、Codex指示書Archiveおよび必要な構成検査を更新し、次の境界を明文化する。

- `concepts/`：非正本の構想・調査・設計候補
- `docs/`：承認済みの現行設計・運用上の正本
- `codex/`：Codexへ実際に割り当てる個別作業指示書と、その実行履歴
- Runtime Config／Manifest：実装済み状態の記録

Codexは`concepts/`を背景資料として参照してよいが、Concept文書そのものを実装命令、Repository変更承認、Runtime変更承認、破壊的処理承認、Release Scope変更またはRoadmap完了根拠として扱ってはならない。

本タスクの変更を検証後、通常のGit CommitおよびPushまで行う。

---

## 2. 前提

Repository：

```text
eariver/Project_Wayfarer
```

作業対象は、VS Codeで開かれているProject Wayfarer Repository Root内だけとする。

作業開始時に以下を確認する。

1. Repository Rootであること。
2. 現在BranchとUpstream。
3. `git status --short`。
4. 最新の`AGENTS.md`、`README.md`、`codex/README.md`。
5. ユーザーが以下のConcept文書と`old/`配下文書を既に手動配置していること。
6. Concept以外に意図不明な未Commit変更がないこと。

想定する構成：

```text
concepts/
├─ frontier/
│  ├─ README.md                         # 本タスクで作成
│  ├─ Frontier_Server_Specification_V0.0.3.md
│  ├─ Worlds_Beyond_Specification_V0.0.3.md
│  ├─ Ruined_Frontier_Specification_V0.0.3.md
│  └─ old/
│     ├─ README.md                      # 本タスクで作成
│     └─ <ユーザーが配置した旧版Concept文書>
├─ main/
│  ├─ README.md                         # 本タスクで作成
│  ├─ Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md
│  └─ old/
│     ├─ README.md                      # 本タスクで作成
│     └─ <ユーザーが配置した旧版Concept文書>
└─ README.md                            # 本タスクで作成
```

以下の現行Concept文書が一つでも見つからない場合は、類似名を推測して処理を続けず、欠けているExact Pathを報告して停止する。

```text
concepts/frontier/Frontier_Server_Specification_V0.0.3.md
concepts/frontier/Worlds_Beyond_Specification_V0.0.3.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.3.md
concepts/main/Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md
```

`old/`が空の場合、ユーザーが配置を忘れた可能性があるため、勝手に空Archiveとして確定せず状況を報告する。ただし、`old/README.md`だけを置く運用がユーザーの配置内容から明確であれば、その状態は許容してよい。

---

## 3. 本タスクで実施すること

1. 手動配置済みConcept文書と旧版文書を確認する。
2. `concepts/README.md`を作成する。
3. `concepts/main/README.md`を作成する。
4. `concepts/main/old/README.md`を作成する。
5. `concepts/frontier/README.md`を作成する。
6. `concepts/frontier/old/README.md`を作成する。
7. `AGENTS.md`へConcept／Task／Source-of-Truth境界を追加する。
8. Root `README.md`へ`concepts/`の役割と入口を追加する。
9. `codex/README.md`へConcept参照ルールと実行承認境界を追加する。
10. `scripts/Test-Layout.ps1`へ、安定したConcept管理入口の存在確認を追加する。
11. 本指示書を`codex/`へ保存し、`codex/README.md`の実行履歴へ登録する。
12. Markdown Link、Repository Layout、Git除外、差分を確認する。
13. 一つのCommitにまとめてPushする。

---

## 4. 本タスクで実施しないこと

- Concept本文の設計内容を正式仕様へ昇格すること
- Concept本文を要約・改稿・校正すること
- Concept文書のVersion番号変更
- Concept文書のFile名変更
- Concept文書を`docs/`へ移動すること
- Main BetterStructures構成の実装
- BetterStructures、EliteMobs、Iris Engineの導入
- Frontier Worldの作成
- MainまたはFrontier Worldの生成、再生成、Trim、削除
- RoadmapのPhase順序変更
- V0.1.0 Release Blockerの追加・削除・完了
- `docs/00-design-guide.md`等の現行正本文書へConcept内容を反映すること
- `versions.yml`または`plugin-manifest.yml`へ未導入Pluginを登録すること
- Plugin JAR、Content Pack、World、Log、Database Data等のCommit
- 別Repositoryの作成
- 独自Plugin Source Projectの作成
- 既存`codex/Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md`の移動
- Concept内容に基づくRuntime操作またはPermission変更

`Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md`は直近Phaseの重要な設計入力だが、この文書自体は実装指示書ではない。実装は後続の、ユーザーが明示的に割り当てる専用`codex/`指示書で行う。

---

## 5. Concept文書の権限モデル

### 5.1 `concepts/`

`concepts/`には以下を保存する。

- 構想
- 調査結果
- 候補比較
- 未確定仕様
- 複数Chat間の引継ぎ
- 採用前の設計案
- 不採用案と判断理由
- 将来Release向けの検討
- 現行正本へ未反映の設計更新案

`concepts/`の文書は、内容が詳細であっても非正本とする。

Concept文書は、単独では以下を承認しない。

- 実装
- Repository変更
- Plugin／Content取得
- Runtime Config変更
- Server操作
- World生成／再生成／Trim／削除
- Database Migration
- Permission変更
- Roadmap変更
- Release Scope変更
- 別Repository作成
- Software Artifact作成
- Commit／Push
- 破壊的操作

### 5.2 `docs/`

`docs/`は、承認済みの現行設計、運用方針、受入基準および現行状態の正本とする。

Conceptが`docs/`と矛盾する場合、Conceptを理由に`docs/`を上書きしてはならない。

### 5.3 `codex/`

`codex/`は以下を保存する。

- ユーザーがCodexへ割り当てる個別作業指示書
- 完了済み指示書の監査用Archive
- 実行履歴

ただし、`codex/`にFileが存在するだけでは実行承認にならない。

ユーザーが現在Sessionで特定の指示書を明示的に割り当てた場合だけ、その指示書を実行対象とする。

### 5.4 Conceptから実装への昇格

標準Flow：

```text
Chatで調査・検討
↓
concepts/へ保存
↓
本体設計Chatで横断評価
↓
ユーザーが採用範囲を承認
↓
必要に応じてRoadmap／正式仕様を更新
↓
codex/へ個別実行指示書を作成
↓
ユーザーが当該指示書をCodexへ明示的に割当
↓
実装・検証・Commit／Push
↓
docs／Manifest／Acceptance Testsを実態へ更新
```

`Approved for Task Design`のようなConcept状態が将来導入されても、それは「Codex実行指示書を設計してよい」という意味に留まり、実装承認にはならない。

---

## 6. `AGENTS.md`更新要件

既存Ruleを維持し、適切な位置へ新しいSectionを追加する。

Section名の推奨：

```markdown
## Concept and task document boundary
```

少なくとも次を明記する。

```markdown
The `concepts/` directory contains research notes, comparisons, design
alternatives, discussion handoffs, superseded drafts, and other
non-authoritative planning material.

Files under `concepts/` may be read when relevant for background, rationale,
candidate requirements, and unresolved decisions. They are not implementation
instructions or current sources of truth.

A concept document does not authorize implementation, repository changes,
Plugin or content acquisition, Runtime operations, world lifecycle changes,
database migrations, permission changes, Roadmap completion, release-scope
changes, creation of another repository, or creation of software artifacts.

Executable work must be explicitly assigned by the user and described by a
specific task instruction under `codex/`.

The presence of a file under `codex/` is not by itself authorization to execute
it. The user must identify or clearly assign that task for the current session.

An assigned `codex/` task may cite files under `concepts/` as design input.
Only the scope explicitly adopted by the assigned task may be implemented.

When a concept conflicts with `AGENTS.md`, current source-of-truth documents,
manifests, Runtime state, or the assigned task, do not infer a resolution.
Stop and report the conflict.

Concept documents remain non-authoritative until approved conclusions are
incorporated into current source-of-truth documentation or into a separately
assigned Codex task.
```

既存の文体、行長、Heading番号に合わせて調整してよい。

さらに、以下を明記する。

- `concepts/**/old/`はSuperseded／Historical ConceptのArchive。
- `old/`の内容は現在案として扱わない。
- Version番号が最大のFileを機械的に現行案と決めず、各Directoryの`README.md` Indexを確認する。
- ユーザーは今後Concept文書を手動Commit／Pushする場合がある。
- Concepts-only CommitはRuntime変更や実装承認を意味しない。
- CodexはConcept文書を参照しただけで現行正本文書を自動更新しない。

既存のProject Invariantや安全規則を削除・弱体化しない。

---

## 7. `concepts/README.md`作成要件

Repository全体のConcept運用規則を日本語で記載する。

少なくとも以下を含める。

### 7.1 目的

- 複数Chatで並行検討した内容をRepository内へ集約する。
- 実行指示書や正式仕様とは分離する。
- 採用前の比較、判断理由、旧案を履歴として残す。

### 7.2 権限

明瞭な警告を冒頭近くへ置く。

例：

```markdown
> [!IMPORTANT]
> `concepts/`内の文書は非正本の検討資料です。
> 実装、Runtime変更、World操作、Plugin取得、Roadmap変更またはRelease承認を指示しません。
> 実作業は、ユーザーが明示的に割り当てた`codex/`内の個別指示書に従います。
```

GitHub Markdown上の互換性を考慮し、Alert記法を使用しない方がRepository方針に合う場合は通常の太字警告でもよい。

### 7.3 Directory Index

次をIndexする。

```text
main/
frontier/
```

説明：

- `main/`：Main Server、恒久生活World、Main向けContent等のConcept。
- `frontier/`：Frontier全体、World群、Adventure／Exploration Content等のConcept。
- 各`old/`：改訂で置き換えられた旧Concept。

### 7.4 Lifecycle

推奨状態を記録する。

```text
Draft
Under Review
Candidate
Approved for Task Design
Superseded
Rejected
```

状態をFile名だけから推測しないことも記載する。

### 7.5 Manual Git workflow

ユーザーが今後`concepts/`の文書をCodexを介さず手動Commit／Pushする運用を記載する。

- Concepts-only Commitは通常運用。
- Codexによる実装承認を意味しない。
- Runtime正本更新を伴わない。
- Conceptを実装へ移す際は別のCodex指示書を作る。

### 7.6 Third-party content

- 第三者Plugin JAR、Content Pack、Schematic、World、Resource Pack等を`concepts/`へCommitしない。
- Concept文書内には配布元URL、Version、License、Hash、比較結果等を記録できる。
- RepositoryのMIT Licenseが第三者成果物を再許諾しないことを維持する。

---

## 8. `concepts/main/README.md`作成要件

Main向けConceptのIndexを作る。

現行案として次を掲載する。

```markdown
- [Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md](Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md)
```

説明には以下を含める。

- Mainへ導入するBetterStructures Contentの構成案。
- Main Server自体の位置付けに関する構想を含む。
- 直近Phaseの重要な設計入力。
- ただし非正本であり、実装は別途承認された`codex/`指示書による。
- 現行Runtimeではない。
- `old/`は旧版Archive。

このREADMEから`old/README.md`へLinkする。

Concept本文を変更しない。

---

## 9. `concepts/frontier/README.md`作成要件

Frontier向けConceptのIndexを作る。

現行案として次を掲載する。

```markdown
- [Frontier_Server_Specification_V0.0.3.md](Frontier_Server_Specification_V0.0.3.md)
- [Worlds_Beyond_Specification_V0.0.3.md](Worlds_Beyond_Specification_V0.0.3.md)
- [Ruined_Frontier_Specification_V0.0.3.md](Ruined_Frontier_Specification_V0.0.3.md)
```

説明：

### `Frontier_Server_Specification_V0.0.3.md`

- Frontier全体の構想。
- 下位World群や共通境界を横断する上位Concept。
- 正式な現行Frontier仕様ではない。

### `Worlds_Beyond_Specification_V0.0.3.md`

- Iris Engineを使用する探索・観光Worldの構想。
- 導入、World生成、Plugin取得またはRelease Scope承認ではない。

### `Ruined_Frontier_Specification_V0.0.3.md`

- BetterStructures＋EliteMobsを使用するWorld群の構想。
- BetterStructuresまたはEliteMobsの導入承認ではない。

このREADMEから`old/README.md`へLinkする。

Concept本文を変更しない。

---

## 10. `old/README.md`作成要件

以下の両方に作成する。

```text
concepts/main/old/README.md
concepts/frontier/old/README.md
```

役割：

- 改訂により置き換えられたConceptを保存する。
- 現在案ではない。
- Historical rationaleの確認にのみ使う。
- 実装指示、現在仕様、採用候補の正本ではない。
- 新しいConceptから明示的に参照されない限り、要求事項として取り込まない。
- 古いVersionを削除せず、原則として`old/`へ移して履歴を保持する。
- `old/`へ移す際は、対象DirectoryのIndexを更新する。

ユーザーが配置した旧版文書を自動改名・内容変更しない。

---

## 11. Root `README.md`更新要件

既存内容を維持し、以下を追加する。

### 11.1 Repository説明

Repositoryが管理するものに、非正本のConcept／調査／設計候補も含むことを明記する。ただし正式仕様とは区別する。

### 11.2 最初に読む文書

`Concepts`へのLinkを追加する。

例：

```markdown
- [Concepts and design candidates](concepts/README.md)
```

正式設計文書より上位に置かない。`codex/`やInvestigation Reports付近の補助資料として配置する。

### 11.3 Scope

「このRepositoryに含むもの」へ以下を追加する。

- 非正本の構想、候補比較、複数Chat間引継ぎおよび旧設計案

同時に、Conceptが現行正本または実装命令ではないことを明記する。

### 11.4 Concept運用

短いSectionまたは既存Sectionへの追記で、以下を説明する。

- `concepts/`は参照資料。
- `docs/`が承認済み正本。
- 実作業は明示的に割り当てられた`codex/`指示書。
- ユーザーがConcept文書を手動Commit／Pushする場合がある。
- Concepts-only CommitはRuntime変更ではない。

### 11.5 既存記述との整合

現在のREADMEには、V0.2.x独自Plugin構想を`codex/`内の参考草案として記録する記述がある。

本タスクではそのFileを移動しないため、この記述を誤って削除しない。ただし一般Concept運用と例外的な既存Fileの位置付けが矛盾しないよう、必要なら「既存の歴史的例外」として表現を明確化する。

---

## 12. `codex/README.md`更新要件

現在のCodex Archive方針を維持し、以下を追加する。

### 12.1 Conceptとの境界

- `concepts/`は参考資料でありCodex Taskではない。
- Codex TaskはConceptを参照できる。
- Task本文が明示的に採用した範囲だけ実装できる。
- Conceptと正本／Runtime／Taskが矛盾した場合は停止・報告する。
- Conceptから要求を推測してTask Scopeを拡張しない。

### 12.2 実行承認

- `codex/`に存在するだけでは実行承認ではない。
- ユーザーが現在Sessionで特定Taskを割り当てる必要がある。
- 完了済みTaskは再実行禁止。
- 未実施Taskも、前提と現行仕様を再確認する。

### 12.3 今回のTask登録

本指示書を次のような名称で`codex/`へ保存する。

```text
codex/Project_Wayfarer_Concepts_Governance_and_Repository_Integration.md
```

`codex/README.md`の実行履歴へ登録する。

作業中は状態を以下とする。

```text
実施中
```

実装Commit作成後、同じTask内で可能ならCommit SHAを記録する追補Commitを作る。既存方針に従い、実装Commitと記録Commitを分けてよい。

例：

```text
docs: Concepts管理境界を導入
docs: Concepts導入Commitを記録
```

無理に一CommitへCommit SHAを自己参照させない。

---

## 13. `scripts/Test-Layout.ps1`更新要件

Version付きConcept File名を永続的なRequired Pathとして固定しない。

安定した管理入口だけをRequired Pathへ加える。

```text
concepts/README.md
concepts/main/README.md
concepts/main/old/README.md
concepts/frontier/README.md
concepts/frontier/old/README.md
```

必要に応じて以下を検査する。

- `concepts/README.md`が存在する。
- Main／Frontier Indexが存在する。
- `old/README.md`が存在する。
- Concept管理入口が通常Fileであり、Directoryや壊れたLinkではない。

PowerShell Scriptに過剰なMarkdown Parserを実装しない。

Version付きConcept文書の存在やCurrent Versionは、各Indexと人間のReviewで管理する。将来のVersion更新時に`Test-Layout.ps1`を毎回変更する構造にしない。

既存Layout Testを壊さない。

---

## 14. Concept文書の取扱い

ユーザーが配置した以下の現行Concept本文は、原則としてByte-levelで変更しない。

```text
concepts/frontier/Frontier_Server_Specification_V0.0.3.md
concepts/frontier/Worlds_Beyond_Specification_V0.0.3.md
concepts/frontier/Ruined_Frontier_Specification_V0.0.3.md
concepts/main/Project_Wayfarer_Main_BetterStructures_Configuration_V0.0.2.md
```

旧版Concept本文も変更しない。

許可する操作：

- Gitへ追加
- README IndexからLink
- File存在確認
- Text Fileとしての基本的な安全確認
- 誤って秘密情報や第三者Binaryが含まれていないかの確認

禁止：

- 内容の勝手な修正
- Metadata Headerの追加
- Version改訂
- Heading変更
- File名変更
- `old/`への移動判断
- 内容に基づく正式仕様更新

明白な秘密情報、Credential、Private Key、個人情報、第三者の再配布禁止Artifact、巨大なBase64 Binary等がConcept文書に含まれる場合は、CommitせずExact Pathと問題を報告する。

通常の公開URL、Plugin名、Version、License、Hash、設計説明は許容する。

---

## 15. 文書優先順位

現行状態の判断順序は、既存`codex/README.md`の方針を維持する。

最低限：

1. `AGENTS.md`
2. `docs/00-design-guide.md`
3. 対象分野の現行正本文書
4. `versions.yml`
5. `plugin-manifest.yml`
6. `docs/06-acceptance-tests.md`
7. `docs/09-roadmap.md`
8. 明示的に割り当てられた現行Codex Task
9. 完了済み／歴史的Codex Task
10. `concepts/`内の参考資料

ただし、明示的に割り当てられたCodex Taskであっても、既存正本と矛盾する場合に黙って正本を上書きしない。Taskが正本更新を明確に要求しているか確認し、曖昧なら停止する。

`concepts/`は常に非正本であり、Version番号や更新日時だけで上位へ昇格しない。

---

## 16. 検証

### 16.1 Pre-commit

以下を実施する。

```powershell
git status --short
git diff --check
.\scripts\Test-Layout.ps1
```

Repositoryに既存のMarkdown Link Check手段があれば実行する。新しいPackageや外部Toolを勝手にInstallしない。

手動で以下を確認する。

- Root READMEから`concepts/README.md`へ移動できる。
- `concepts/README.md`からMain／Frontierへ移動できる。
- Main／Frontier READMEから現行Conceptと`old/README.md`へ移動できる。
- Linkの大文字・小文字がExact Pathと一致する。
- Concept本文に変更が入っていない。
- `AGENTS.md`の既存安全規則が維持されている。
- `codex/README.md`の既存履歴が維持されている。
- `Test-Layout.ps1`がVersion付きConcept名へ依存していない。
- `docs/09-roadmap.md`、Runtime Config、Manifestに不要な変更がない。

### 16.2 Staging audit

Commit前に以下を確認する。

```powershell
git status --short
git diff --stat
git diff --cached --name-status
git diff --cached --check
```

Staged Fileに以下がないこと。

- Plugin JAR
- Server JAR
- Content Pack
- Schematic
- World
- Region File
- Player Data
- Log
- Database Data
- Backup
- Secret
- `.env`
- 有償Content
- 大容量Binary
- 意図しないRuntime Config

Concept配下へMarkdown以外のFileが追加されている場合は、その必要性と権利関係を確認する。今回の想定は文書だけであり、意図不明なBinaryはCommitしない。

---

## 17. Commit／Push

すべての検証に合格し、差分が本タスクだけである場合はCommitする。

推奨Commit Message：

```text
docs: Concepts管理境界を導入
```

Push前に確認する。

```powershell
git branch --show-current
git remote -v
git status --short
```

通常のConfigured UpstreamへPushする。

Force Push、Amend、Tag、GitHub Release、Branch作成、PR作成は行わない。

Codex Archiveへ実装Commit SHAを記録するために追補Commitが必要な場合：

```text
docs: Concepts導入Commitを記録
```

として通常Pushする。

---

## 18. 完了条件

以下をすべて満たした場合に完了。

- ユーザー配置のConcept文書がCommitされている。
- `concepts/README.md`が存在する。
- `concepts/main/README.md`が存在する。
- `concepts/main/old/README.md`が存在する。
- `concepts/frontier/README.md`が存在する。
- `concepts/frontier/old/README.md`が存在する。
- `AGENTS.md`にConceptとTaskの権限境界がある。
- Root `README.md`にConcept入口と非正本性がある。
- `codex/README.md`にConcept参照・Task実行承認ルールがある。
- `scripts/Test-Layout.ps1`が安定したConcept管理入口を検査する。
- Concept本文は変更されていない。
- RoadmapやRuntime正本をConcept内容に合わせて変更していない。
- Layout Testが成功している。
- Git Diff Checkが成功している。
- 秘密情報、JAR、Content、World、Log、DB、BackupがCommitされていない。
- Commit／Pushが成功している。
- 最終Working TreeがCleanである。

---

## 19. 完了報告

以下を報告する。

1. Commit SHAとCommit Message
2. BranchとRemote
3. 追加されたConcept文書一覧
4. 作成したREADME一覧
5. 更新したPolicy／案内／検査File
6. 実行した検証
7. Concept本文を変更していないこと
8. Roadmap／Runtime／Manifestを変更していないこと
9. 最終`git status --short`
10. 残る注意事項

完了報告では、Conceptに記載されたBetterStructures、EliteMobs、Iris Engine等を「導入済み」「採用済み」「承認済み」と表現しない。

次の実作業候補がMain BetterStructures構成であることは記載してよいが、別の専用Codex Taskが必要であることを明記する。
