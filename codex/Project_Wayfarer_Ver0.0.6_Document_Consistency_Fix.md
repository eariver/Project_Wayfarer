# Project Wayfarer Ver.0.0.6 文書整合性修正 指示書

## 1. 目的

Project Wayfarerの`Ver.0.0.6`正式文書更新後に判明した、以下の整合性問題を修正する。

1. Ruined Frontierへ`103 Default Structures`が誤って正式Scopeへ含まれている。
2. `AGENTS.md`内で、通常のResource ResetとMain Persistent Familyの一度限りの再生成方針が競合して読める。
3. `versions.yml`および`plugin-manifest.yml`の文書Revision Metadataが`Ver.0.0.5`のまま残っている。
4. `docs/02-installation.md`に、Frontier Themeが一つだけであるかのような旧Phase 1B表現が残っている。
5. Root `README.md`に、BetterStructuresの現在状態と将来Frontier Scopeを区別しにくい表現がある。

本タスクは**文書・Metadataの整合性修正だけ**を行う。

次は実施しない。

- Plugin導入
- Content Pack取得またはImport
- Runtime Config変更
- World生成、再生成、削除、Trim、Rename
- Permission Runtime変更
- Database Migration
- Custom Plugin開発
- Repository作成
- Resource Pack生成または配信
- `Ver.0.0.7`へのRevision更新

正式Revisionは引き続き`Ver.0.0.6`とする。

---

## 2. Repository

```text
eariver/Project_Wayfarer
```

作業対象は、VS Codeで開かれているProject Wayfarer Repository Root内だけとする。

作業開始時に確認する。

```powershell
git status --short
git branch --show-current
git remote -v
git log -5 --oneline
```

最新Commitとして少なくとも以下が履歴に存在することを確認する。

```text
46729171a34daf6550c8cb629edcc0946a0dfd65
docs: Ver.0.0.6の正式ScopeとRoadmapを更新

2ce0a40e68215b33ab33e84b95cb228b3b382230
docs: Ver.0.0.6更新Commitを記録
```

意図不明な未Commit変更がある場合は停止し、Exact Pathと状態を報告する。

---

## 3. 正式な修正方針

### 3.1 Ruined FrontierのBetterStructures Content

Ruined Frontierの初期正式Scopeでは、次を有効候補とする。

```text
Exploration Pack
Caves and Lost Civilizations Free
Echoes of the Past
Adventure Pack
BetterStructures Prop Pack
Free Elite Shrines
Dungeoneering Modules Free
```

Ruined Frontierでは`103 Default Structures`を**原則無効**とする。

理由：

- Mainで既に体験できるContentである。
- Ruined Frontierの高難度・大型・EliteMobs連携Structureの抽選を希釈する。
- Ruined FrontierはMainとは異なる攻略Themeとして差別化する。

将来、Waypoint、Graveyardその他の個別StructureをRuined Frontierへ採用する場合は、Pack全体を有効化せず、別の正式設計と専用Taskで個別選定する。

Main側の正式Scopeは引き続き次の5 Packであり、変更しない。

```text
103 Default Structures version 5
Exploration Pack version 6
Caves and Lost Civilizations Free version 2
Adventure Pack internal version 1
Echoes of the Past version 3
```

したがって文書内で次を混同しない。

```text
Main = five-Pack
Ruined Frontier = 103 Default Structuresを除く選定Content
```

Ruined Frontierを「five-pack」と表現しない。

### 3.2 ResetとMain再生成の境界

通常のResource Reset Scriptが対象にできるのは、次だけとする。

```text
resource
resource_nether
resource_end
```

一方、Main Persistent Family：

```text
main
main_nether
main_the_end
```

は、`Ver.0.0.6`で承認された置換生成計画に基づく、**別途明示的に割り当てられた一度限りの破壊的Task**でのみ再生成できる。

通常のResource Reset Script、日常運用、汎用Reset Commandまたは曖昧な「reset」指示からMainを対象にしてはならない。

### 3.3 Revision Metadata

`versions.yml`と`plugin-manifest.yml`はRuntime導入状態の正本であり、未導入Pluginを追加してはならない。

ただし、文書Revision Metadataだけは`Ver.0.0.6`へ合わせる。

`versions.yml`：

```yaml
document:
  project: Project Wayfarer
  version: 0.0.6
  date: 2026-07-25
  target_server_release: V0.1.0 Alpha
```

既存の以下は維持する。

```yaml
target_release_status: incomplete
```

Runtime Version、Hash、Placement、Verified Dateその他の導入済み情報を変更しない。

`plugin-manifest.yml`冒頭：

```text
# Project Wayfarer Ver.0.0.6
```

ManifestのPlugin内容、必須・任意区分、Version、Source、Placementを変更しない。

### 3.4 Builder Phase 1Bの依存条件

Phase 1Bは、次が確定した後に実施する。

```text
Ruined Frontier
Worlds Beyond
Multiverse-Inventories
ResourcePackManager
EliteMobs
Wayfarer_Core
Wayfarer_Frontier
採用Gate／Portal方式
Builderが実際に担当するHub／Gate／Theme接続作業
```

「playable Frontier Theme」など、Themeが一つだけであるかのような表現を残さない。

### 3.5 BetterStructuresの現在状態と将来Scope

現在のRuntimeではBetterStructuresはMainだけに導入済みである。

将来のV0.1.0正式Scopeでは、Ruined Frontierにも別途検証したBetterStructuresを導入予定である。

したがって、現在形の文書では次のように区別する。

```text
BetterStructures is currently installed only on Main.
The approved V0.1.0 Ruined Frontier scope requires a separate Frontier installation.
```

「BetterStructuresはMainだけに配置する」という恒久的な禁止表現へ戻さない。

---

## 4. 設計入力

以下のConcept本文を確認する。

```text
concepts/frontier/Ruined_Frontier_Specification_V0.0.4.md
```

確認点：

- `103 Default Structures`は原則無効。
- Mainで体験できること。
- 高難度Structureの抽選希釈を避けること。
- 個別Structure再採用は将来の別判断。
- Alpha初期構成に103 Default Structuresを含めないこと。

Concept本文は変更しない。

Conceptは非正本だが、今回の誤記修正については、ユーザーがConceptに沿った正式修正を明示承認している。

---

## 5. 更新対象

最低限、以下を確認・更新する。

```text
AGENTS.md
README.md
docs/02-installation.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/14-frontier-v0.1.0-scope.md
versions.yml
plugin-manifest.yml
codex/README.md
```

必要に応じて、Repository検索で同じ誤記が見つかった現行正本文書も修正する。

候補：

```text
docs/00-design-guide.md
docs/01-architecture.md
docs/04-play-guide.md
docs/05-external-extensions.md
docs/08-plugin-collection.md
docs/11-deferred-design-items.md
docs/12-permission-model.md
plugin-collection.csv
```

ただし、問題がないFileを機械的に変更しない。

新規作成：

```text
codex/Project_Wayfarer_Ver0.0.6_Document_Consistency_Fix.md
```

---

## 6. `docs/14-frontier-v0.1.0-scope.md`

Ruined Frontier初期Scopeから`103 Default Structures`を削除する。

修正前の趣旨：

```text
103 Default Structures
Exploration Pack
Caves and Lost Civilizations Free
Echoes of the Past
Adventure Pack
```

修正後：

```text
Exploration Pack
Caves and Lost Civilizations Free
Echoes of the Past
Adventure Pack
```

同Sectionへ次の趣旨を追加する。

```text
103 Default Structures is disabled by default in Ruined Frontier because it is
already available on Main and would dilute the Ruined Frontier high-difficulty
Structure pool. Individual Structures may be reconsidered only through a later
approved selection task.
```

Mainの5 Pack Scopeと混同しない。

---

## 7. `docs/09-roadmap.md`

Ruined Frontier alphaの記述から`five-pack`を削除する。

例えば：

```text
approved five-pack／Prop／Shrine／Dungeoneering Content
```

を次のように変更する。

```text
approved Ruined Frontier Structure／Prop／Shrine／Dungeoneering Content
```

または、内容を明示してもよい。

```text
Exploration, Caves and Lost Civilizations Free, Echoes of the Past,
Adventure, Prop Pack, Free Elite Shrines, and Dungeoneering Modules Free
```

Main Phase 2Bの「five-Pack」は正しいため変更しない。

Roadmap内で以下を検索する。

```powershell
git grep -n "five-pack" -- docs/09-roadmap.md
git grep -n "five-Pack" -- docs/09-roadmap.md
git grep -n "103 Default Structures" -- docs/09-roadmap.md
```

MainとRuinedの文脈を区別して判断する。

---

## 8. `docs/06-acceptance-tests.md`

Ruined Frontierの受入試験に、次を追加または明確化する。

```text
103 Default Structures pack is not enabled as a complete Ruined Frontier pack.
```

また、代表Contentの確認対象を次へ合わせる。

- Exploration Pack
- Caves and Lost Civilizations Free
- Echoes of the Past
- Adventure Pack
- BetterStructures Prop Pack
- Free Elite Shrines
- Dungeoneering Modules Free
- EliteMobs Sign／Boss／Loot

Main側の5 Pack受入試験は変更しない。

---

## 9. `AGENTS.md`

次のような現行表現を修正する。

修正前：

```text
Only the Resource family may be targeted by reset operations.
```

修正後の推奨：

```text
Only the Resource family may be targeted by routine Resource reset scripts or
normal reset operations.

The Main persistent family may be regenerated only by the separately assigned
Ver.0.0.6 replacement-generation task, after every approved Content dependency
loads and all destructive-task requirements are satisfied.
```

さらに、Main再生成について以下を維持する。

- 対象は`main`、`main_nether`、`main_the_end`だけ。
- Resource Familyを含めない。
- Exact resolved pathを報告する。
- BackupとRollback evidenceが必要。
- 正常Shutdownが必要。
- 明示承認が必要。
- Content Load確認前に生成しない。
- 現行Baselineは新Baseline確定まで正本。

同時に、Ruined FrontierのContent構成に関する記述がある場合は、103 Default Structuresを全Pack採用として扱わない。

---

## 10. `versions.yml`

次のMetadataだけを更新する。

```yaml
document:
  project: Project Wayfarer
  version: 0.0.6
  date: 2026-07-25
  target_server_release: V0.1.0 Alpha
  target_release_status: incomplete
```

変更禁止：

- Runtime Version
- Build
- SHA-256
- Placement
- Verified Date
- Plugin設定
- 未導入Pluginの追加
- Planned Pluginの導入済み登録

YAML構文を検証する。

Repositoryに既存YAML Parserまたは検査Scriptがある場合だけ使用する。外部PackageをInstallしない。

---

## 11. `plugin-manifest.yml`

冒頭Commentを次へ更新する。

```text
# Project Wayfarer Ver.0.0.6
```

Manifest本文は変更しない。

未導入の次を追加しない。

- Multiverse-Inventories
- ResourcePackManager
- EliteMobs
- Iris
- Wayfarer_Core
- Wayfarer_Frontier
- Frontier BetterStructures Content

これらはArtifact Lock／導入Taskで正式に追加する。

---

## 12. `docs/02-installation.md`

Phase 1B説明を更新する。

旧表現例：

```text
after the Advanced Portals permissions, playable Frontier Theme, and Builder
Hub／Gate work are known
```

新しい趣旨：

```text
after both Ruined Frontier and Worlds Beyond, MVI, ResourcePackManager,
EliteMobs, Wayfarer_Core／Wayfarer_Frontier, the adopted Gate／Portal
implementation, and the exact Builder-owned Hub／Gate／Theme connection work
are known
```

Advanced Portalsを採用済みと断定しない。現在は採用Gate方式のLock前である。

---

## 13. Root `README.md`

現在状態を示すBetterStructures記述を、将来Scopeと競合しないよう修正する。

例えば、決定一覧の：

```text
BetterStructuresはMainだけに配置し
```

を次の趣旨へ変更する。

```text
BetterStructuresは現在Mainだけに導入済みであり、Persistent Main Family
だけを有効化する。V0.1.0のRuined Frontierでは、別途検証したFrontier
導入を行う。
```

READMEを長大化しない。

Root README内の以下は維持する。

- 現在のMain Runtimeは103 Default Structuresだけ。
- V0.1.0計画は未実装。
- Ruined Frontier／Worlds Beyondの両方が対象。
- Conceptは非正本。
- 未導入Pluginを導入済みと書かない。

---

## 14. Repository横断検索

以下を実行する。

```powershell
git grep -n "103 Default Structures"
git grep -n "five-pack"
git grep -n "five-Pack"
git grep -n "Only the Resource family may be targeted"
git grep -n "playable Frontier Theme"
git grep -n "one playable Frontier"
git grep -n "BetterStructuresはMainだけ"
git grep -n "Ver\\.0\\.0\\.5"
git grep -n "version: 0\\.0\\.5"
```

各結果を次の分類に分ける。

### 修正対象

- 現在の正式ScopeでRuined Frontierへ103 Default Structures全Packを含めている。
- Ruined Frontierをfive-Packと表現している。
- 通常ResetとMain replacement generationを区別していない。
- 現在方針でFrontier Themeを一つと表現している。
- 現在Revision Metadataが0.0.5。
- BetterStructuresが将来も永久にMain-onlyであるように読める。

### 修正しない

- Mainの5 Pack構成。
- 現行RuntimeではMainだけにBetterStructuresが導入済みという記述。
- 過去のTask名、Commit履歴、Historical Record。
- Concept V0.0.3や旧Archive。
- Ver.0.0.5時点の過去状態を説明する文脈。
- 完了済みCodex指示書本文。

過去の指示書を現在方針に合わせて書き換えない。

---

## 15. `codex/README.md`

本指示書を次で保存する。

```text
codex/Project_Wayfarer_Ver0.0.6_Document_Consistency_Fix.md
```

実行履歴へ登録する。

作業中：

```text
実施中
```

完了後：

```text
完了（実装Commit: <SHA>）
```

現行正本：

```text
AGENTS.md
docs/09-roadmap.md
docs/14-frontier-v0.1.0-scope.md
versions.yml
plugin-manifest.yml
```

再実行：

```text
そのままの再実行禁止。今後のArtifact Lockまたは実装進行後は現行正本で再評価
```

Commit SHAの自己参照を避けるため、必要なら実装Commitと記録Commitを分ける。

---

## 16. 変更しないもの

- `concepts/`配下の全File
- 現行Main Runtime Config
- Frontier Runtime Config
- `versions.yml`内のRuntime情報
- `plugin-manifest.yml`本文
- `plugin-collection.csv`の導入状態（誤記がなければ変更しない）
- Plugin JAR
- Content Pack
- Resource Pack
- World
- Player Data
- Database Data
- Redis Data
- Log
- Backup
- Secret
- `.env`
- Permission Runtime
- Roadmapの依存順序
- Mainの5 Pack構成
- Ruined FrontierとWorlds BeyondのV0.1.0 Blocker化
- Wayfarer_Core／Wayfarer_FrontierのV0.1.0 Blocker化
- ResourcePackManagerのLock項目
- MVI責務
- 全Item移送禁止
- CoreProtectの実施順序
- Main現行Baseline

---

## 17. 検証

### 17.1 Diff

```powershell
git diff --check
git status --short
git diff --stat
```

### 17.2 Layout

```powershell
.\scripts\Test-Layout.ps1
```

### 17.3 YAML

可能ならRepository既存手段で以下をParseする。

```text
versions.yml
plugin-manifest.yml
```

外部ToolやPackageを新規Installしない。

### 17.4 手動確認

- Ruined Frontier正式Scopeに103 Default Structures全Packが含まれていない。
- Mainの5 Pack Scopeには103 Default Structuresが残っている。
- Ruined Frontierの「five-Pack」表現がない。
- 103 Default Structuresの個別再採用は将来の別Taskである。
- Routine Resource ResetとMain replacement generationが明確に分離されている。
- Mainを通常Reset Scriptの対象にしていない。
- `versions.yml`のDocument Revisionだけが0.0.6。
- `plugin-manifest.yml`のHeaderだけがVer.0.0.6。
- 未導入PluginをManifestへ追加していない。
- Phase 1Bが両Themeと関連基盤を前提にしている。
- READMEが「現在Main-only」と「将来Frontier導入」を区別している。
- Concept本文未変更。
- Runtime未変更。
- Roadmap順序未変更。
- V0.1.0 Scopeを縮小していない。

### 17.5 Staging audit

```powershell
git diff --cached --name-status
git diff --cached --check
```

意図した文書とMetadata以外をStageしない。

---

## 18. Commit／Push

すべての検証に合格した場合、Commitする。

推奨Commit Message：

```text
docs: Ver.0.0.6文書の整合性を修正
```

Push前：

```powershell
git status --short
git branch --show-current
git remote -v
```

Configured Upstreamへ通常Pushする。

禁止：

- Force Push
- Amend
- Tag
- GitHub Release
- 新Branch
- PR作成
- Repository作成

Codex Archiveへ実装Commit SHAを記録する追補Commitが必要な場合：

```text
docs: Ver.0.0.6整合性修正Commitを記録
```

として通常Pushする。

---

## 19. 完了条件

以下をすべて満たす。

- Ruined Frontierから103 Default Structures全Packが除外されている。
- Main 5 Packは変更されていない。
- Ruined Frontierのfive-Pack表現が除去されている。
- Routine Resource ResetとMain replacement generationが明確に分離されている。
- `versions.yml`のDocument Revisionが0.0.6／2026-07-25。
- `plugin-manifest.yml`HeaderがVer.0.0.6。
- Runtime Version／Manifest本文未変更。
- Phase 1Bの依存条件が両Frontier Themeへ更新されている。
- Root READMEが現在Main-onlyと将来Frontier Scopeを区別している。
- Concept本文未変更。
- Runtime未変更。
- `git diff --check`成功。
- `Test-Layout.ps1`成功。
- YAMLに構文破損がない。
- Commit／Push成功。
- 最終Working TreeがClean。

---

## 20. 完了報告

以下を報告する。

1. 実装Commit SHA／Message
2. 記録Commit SHA／Message
3. Branch／Remote
4. 更新File一覧
5. Ruined Frontier Content修正内容
6. Main 5 Packを維持したこと
7. Reset／Main再生成境界の修正内容
8. Revision Metadata修正内容
9. Phase 1B表現修正内容
10. README修正内容
11. 実行した検証
12. Concept本文未変更
13. Runtime／Manifest本文未変更
14. 最終`git status --short`
15. 残る注意事項

完了報告では、Ruined Frontier、Main再生成、MVI、ResourcePackManager、Custom Plugin等を導入済みまたは実装済みと表現しない。
