# Project Wayfarer Frontier Lock承認後 文書責務分離・追補Commit記録・Acceptance整合修正 指示書

## 1. 推奨Sol

```text
medium
```

### 理由

- 本Taskは、承認済みFrontier Order 8 Lockの内容を変更せず、文書のAuthority、責務分離、Commit記録およびAcceptance表現を整合させるDocumentation-only Taskである。
- Plugin、World、Database、Permission、Resource PackまたはRuntimeを変更しない。
- ただし、承認済みLockの正本、Frontier固有Scope、Network全体のRelease BlockerおよびOwner手動Commitを横断して扱うため、単純な誤字修正より慎重な差分管理が必要である。

### `high`へEscalateして停止する条件

次の場合は本Taskを拡張せず停止する。

- `config/frontier-lock/*-lock.yml`の意味変更が必要になる。
- Artifact Version、SHA-256、World ID、MVI Group、Gate方式、Pack Input、Persistence AuthorityまたはRuntime Boundaryを変更する必要がある。
- Proposal `FRONTIER-LOCK-20260726-003`の再承認、新Proposalまたは新Lock Revisionが必要になる。
- Plugin JAR、Content、World、Runtime Config、Permission、MariaDB、Redis、MVI Runtime DataまたはResource Packを変更する必要がある。
- Server起動またはRuntime検証が必要になる。
- Owner手動Commit `3789daf69c76ef17983ef13d170fe72f92c54b03`をRevert、Amend、Squash、Rebaseまたは意味変更する必要がある。
- Growth PickaxeのProgress方針が、本指示書のExact Acceptance表現と現行Conceptから一意に解釈できない。
- Frontier固有Scopeから削減する情報の移管先が現行正本に存在せず、仕様を失う可能性がある。

---

## 2. 目的

次の三点を修正する。

### A. Frontier固有ScopeにおけるWayfarer_Main記述を適正化する

`docs/14-frontier-v0.1.0-scope.md`にある`Wayfarer_Main`／Growth Pickaxeの詳細仕様を、Frontier固有Scopeとして必要な境界説明と、Network全体のV0.1.0 Release Blocker参照へ整理する。

Project全体として次は維持する。

```text
Wayfarer_Main:
  V0.1.0 required
  Main-only
  Growth Pickaxe owner
  Network-wide Release Blocker
```

Frontier固有Scopeに残す内容：

```text
Wayfarer_Main is a sibling module in the same external Plugin Repository.
It is installed only on Main.
It is forbidden on Frontier.
Growth Pickaxe and all Main Items do not transfer to Frontier.
Detailed Wayfarer_Main scope and acceptance are owned by network／Main authoritative documents.
Wayfarer_Main／Growth Pickaxe remains a Project-wide V0.1.0 Release Blocker,
but is not a Frontier Runtime component or Frontier Theme implementation blocker.
```

つまり、`docs/14`からGrowth Pickaxeを完全に除外しない。

次の区別を明確にする。

```text
Project-wide V0.1.0 blocker:
  yes

Frontier Runtime component:
  no

Frontier Theme implementation detail:
  no

Cross-backend boundary dependency:
  yes
```

### B. Order 8承認後の追補Commitを正式記録する

次のCommitを、Formal Lock ReportとCodex Archiveへ追記する。

```text
fe16ca6c6200732ee4b1960126ecb8f5dcb96795
docs: Frontier Lockの配置とLifecycle境界を明確化
```

このCommitは次を明確化した。

```text
CoreProtect:
  placement: not-selected-not-placed

Ruined Frontier three persistent Worlds:
  lifecycle: persistent-lifecycle-managed
```

これはArtifact、Version、Hash、World ID、Gate、Pack InputまたはScopeの変更ではなく、承認済みLockの配置／Lifecycle表現の明確化である。

### C. Owner手動Commit後のGrowth Pickaxe Acceptance文意を修正する

Owner手動Commit：

```text
3789daf69c76ef17983ef13d170fe72f92c54b03
docs: Plugin ConceptおよびAcceptance 修正
```

は、Player設置Block、Generator生成BlockおよびSilk Touch再設置OreをProgress対象として認める方針を反映した。

ただし、現行`docs/06-acceptance-tests.md`の一文は、非対象World／GameMode／Cancelled Breakまで「valid Progress sources」と読めるため、次のExact表現へ置換する。

```markdown
- [ ] `main`, `main_nether`, `main_the_end`, unknown Worlds, Creative／Spectator, and cancelled breaks grant no Progress.
- [ ] Player-placed blocks, generator-produced blocks, and Silk Touch re-placed ores are valid Progress sources. Each successful, non-cancelled `BlockBreakEvent` grants Progress exactly once.
- [ ] Explosion, Piston, WorldEdit, Command, Plugin deletion, and other non-player block removal grant no Progress.
```

上記3行は文意を変更せず、そのまま使用する。

---

## 3. 非目的

本Taskでは次を行わない。

- Order 8を再実行しない。
- Proposal 003を変更しない。
- 新Proposalを作成しない。
- 新しいApproval Tokenを要求しない。
- `config/frontier-lock/*-lock.yml`を変更しない。
- `docs/15-frontier-runtime-lock.md`のLock内容を変更しない。
- Artifact、Version、Hash、World ID、MVI Group、Portal Family、Gate、Pack Inputを変更しない。
- Wayfarer_Main／Growth Pickaxe Gameplay Conceptを変更しない。
- Growth PickaxeのBlock Weight、Evolution ThresholdまたはRepair価格を決定しない。
- Growth PickaxeをProject全体のV0.1.0 Release Blockerから外さない。
- Plugin Repositoryを作成しない。
- Runtime Pluginを導入しない。
- Serverを起動しない。
- World、DB、Permission、PackまたはPlayer Dataを変更しない。
- Owner手動CommitのMarkdown整形を元へ戻さない。
- Concept Versionを増やさない。
- Main Final Baselineを変更しない。

---

## 4. Repositoryと開始状態

Repository：

```text
eariver/Project_Wayfarer
```

開始時：

```powershell
git status --short
git branch --show-current
git remote -v
git log -12 --oneline
git rev-parse HEAD
```

期待HEAD：

```text
3789daf69c76ef17983ef13d170fe72f92c54b03
docs: Plugin ConceptおよびAcceptance 修正
```

直前Commit：

```text
fe16ca6c6200732ee4b1960126ecb8f5dcb96795
docs: Frontier Lockの配置とLifecycle境界を明確化
```

確認：

```powershell
git merge-base --is-ancestor fe16ca6c6200732ee4b1960126ecb8f5dcb96795 3789daf69c76ef17983ef13d170fe72f92c54b03
```

結果が成功しない場合は停止する。

開始時WorktreeがCleanでない場合、Owner差分の目的を特定できなければ停止する。

禁止：

- `git reset --hard`
- `git clean`
- Rebase
- Amend
- Force Push
- History rewrite
- Owner CommitのSquash
- Branch作成
- PR作成
- Tag
- Release

---

## 5. Owner手動Commitの保護

`3789daf...`の変更範囲を確認する。

期待対象：

```text
concepts/plugins/Project_Wayfarer_Plugin_Concept_v0.0.3.md
concepts/plugins/frontier/Project_Wayfarer_Worlds_Beyond_Plugin_Concept_v0.0.4.md
docs/06-acceptance-tests.md
```

維持する判断：

### Plugin全体Concept

- Project本流Roadmap／Acceptance／Backup／Release Blockerへ同期済みという状態
- 一つの外部Gradle Multi-module Repository
- Core／Main／Frontierと条件付きAdapterの配置境界

### Worlds Beyond Plugin Concept

- Related Theme Conceptはv0.0.6
- ElytraはUnbreakable
- Grappling Hookは耐久無効
- Launchpad初期値
- Theme同期完了
- Markdown Table整形

### Growth Pickaxe Progress

次をProgress対象として認める。

- 自然生成Block
- Player設置Block
- Plugin生成Block
- Generator生成Block
- Cobblestone／Stone／Basalt Generator
- Silk Touchで回収して再設置したOre
- Ore再採掘

次はProgress対象外とする。

- `main`
- `main_nether`
- `main_the_end`
- unknown Worlds
- Creative
- Spectator
- Cancelled BlockBreakEvent
- Explosion
- Piston
- WorldEdit
- Command
- Pluginによる直接削除
- その他の非Player Block removal

Owner手動CommitをRevertしない。

---

## 6. Frontier Scope責務分離

対象：

```text
docs/14-frontier-v0.1.0-scope.md
```

### 6.1 Shared Frontier foundation

現行の次の趣旨：

```text
Wayfarer_Core, Wayfarer_Main, and Wayfarer_Frontier integration contracts
```

を、Frontier側に実際に配置するModuleと、Repository sibling境界へ分ける。

推奨表現：

```text
- Wayfarer_Core and Wayfarer_Frontier integration contracts from one external
  Gradle Multi-module Repository;
- Wayfarer_Main is a Main-only sibling module in the same Repository. It is not
  installed on Frontier and is referenced here only to preserve the cross-backend
  item／state boundary and the Project-wide V0.1.0 dependency;
- the conditional independent Wayfarer_Frontier_EliteMobsMVI Artifact only if
  the formal decision is ADAPTER_REQUIRED.
```

### 6.2 `Wayfarer_Main responsibilities` Section

現在のGrowth Pickaxe詳細を、短い境界＋Project-wide blocker参照Sectionへ置換する。

推奨Heading：

```text
## 7. Wayfarer_Main project dependency and cross-backend boundary
```

推奨内容：

```text
Wayfarer_Main is a required Project Wayfarer V0.1.0 sibling Plugin and remains
a Project-wide Release Blocker. It is Main-only and is not a Frontier Runtime
component.

Its detailed Growth Pickaxe scope, persistence, delivery, evolution, repair,
acceptance, backup／restore and pre-release reset policy are authoritative in
the network／Main source-of-truth documents, including the Roadmap and
Acceptance Tests.

Frontier requirements are limited to:

- do not install Wayfarer_Main on Frontier;
- do not transfer Growth Pickaxe or any Main Item into Frontier;
- do not treat MVI as a Main／Frontier cross-backend profile mechanism;
- keep Wayfarer_Main data out of Frontier normal Player State;
- preserve the one external multi-module Repository boundary;
- preserve Wayfarer_Main／Growth Pickaxe as a Project-wide V0.1.0 dependency
  without duplicating its detailed Main specification here.
```

後続Section番号を連番へ調整する。

### 6.3 Frontier Release Blockers

`docs/14`のRelease Blocker一覧では、Wayfarer_Mainを完全削除しない。

現在のMain-only詳細表現を、短いProject-wide依存参照へ置換する。

置換前候補：

```text
- Main-only Growth Pickaxe and its detailed acceptance／backup boundary;
```

置換後候補：

```text
- Project-wide completion of Main-only Wayfarer_Main／Growth Pickaxe under the
  network／Main Roadmap, Acceptance and backup／restore authorities; Frontier
  requires only non-placement and cross-backend isolation;
```

または同等の簡潔な表現を使用する。

次を明確にする。

```text
Wayfarer_Main:
  Project-wide Release Blocker
  not a Frontier Theme implementation component
  not installed on Frontier
  relevant to Frontier through dependency and isolation only
```

Project全体のV0.1.0 Release BlockerとしてのWayfarer_Main／Growth Pickaxeは、次で詳細を維持する。

```text
README.md
AGENTS.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
versions.yml
plugin-manifest.yml
```

これらからWayfarer_Mainを削除または弱体化しない。

---

## 7. Acceptance修正

対象：

```text
docs/06-acceptance-tests.md
```

`Wayfarer_Main／Growth Pickaxe`の`Progress and evolution`を確認する。

現行の曖昧な一文を削除し、次の3行へExact置換する。

```markdown
- [ ] `main`, `main_nether`, `main_the_end`, unknown Worlds, Creative／Spectator, and cancelled breaks grant no Progress.
- [ ] Player-placed blocks, generator-produced blocks, and Silk Touch re-placed ores are valid Progress sources. Each successful, non-cancelled `BlockBreakEvent` grants Progress exactly once.
- [ ] Explosion, Piston, WorldEdit, Command, Plugin deletion, and other non-player block removal grant no Progress.
```

直前の条件：

```markdown
- [ ] Progress increments only for the Main Resource Worlds `resource`, `resource_nether`, and `resource_end`, only for valid `minecraft:mineable/pickaxe` blocks broken by the Main-hand canonical Tool.
```

は維持する。

直後の条件：

```markdown
- [ ] Survival and an actually successful Adventure break are handled according to the locked event contract.
```

も維持する。

### 意味上のAcceptance

次を明確にする。

```text
World condition:
  resource／resource_nether／resource_end only

GameMode:
  Survival
  Adventure only when break actually succeeds

Event:
  successful non-cancelled BlockBreakEvent
  exactly once per successful event

Block origin:
  natural
  player-placed
  plugin-generated
  generator-produced
  Silk Touch re-placed ore
  all allowed when the other conditions pass

Non-player removal:
  no progress
```

Player設置Blockの追跡DB、Ore再設置検知、Generator検知またはAnti-farm機構を新たに要求しない。Originを区別せず、成立したPlayerのBlockBreakEventを正本とする。

---

## 8. Formal Lock追補Commit記録

対象：

```text
docs/investigations/2026-07-26-frontier-order8-lock.md
codex/README.md
```

必要に応じて：

```text
docs/15-frontier-runtime-lock.md
```

ただし`docs/15`へ追記する場合も、Lock値やMachine-readable Authorityを変更しない。Commit provenanceの短い注記だけにする。

### 8.1 Formal Lock Report

Summaryまたは専用Sectionへ追加する。

```text
Post-lock clarification commit:
  fe16ca6c6200732ee4b1960126ecb8f5dcb96795

Message:
  docs: Frontier Lockの配置とLifecycle境界を明確化

Clarification:
  - CoreProtect remains unselected and unplaced.
  - frontier_bs, frontier_bs_nether, and frontier_bs_the_end are persistent,
    lifecycle-managed Worlds.
  - No Artifact version, SHA-256, World ID, Gate method, Pack input, MVI authority,
    or approved scope changed.
```

実装Commit`201681ea...`を置換しない。

次の関係を明記する。

```text
Implementation Commit:
  201681ea026936909558839bc4445d9ccb7be567

Archive Commit:
  ebb100afce96cd467e4e4de93b039c3e8ecaf77a

Post-lock clarification:
  fe16ca6c6200732ee4b1960126ecb8f5dcb96795
```

### 8.2 Codex Archive

Order 8 Entryへ、実装Commitとは別Fieldまたは注記として追加する。

例：

```text
完了
実装Commit: 201681ea...
記録Commit: ebb100af...
追補Commit: fe16ca6...
```

既存Archive履歴を削除または書き換えない。

---

## 9. Order 8 Lockの保持

次を変更しない。

```text
Proposal:
  FRONTIER-LOCK-20260726-003

Order 8:
  complete

Runtime validation:
  deferred

Runtime applied:
  false
```

次のMachine-readable Lockは変更禁止。

```text
config/frontier-lock/artifact-lock.yml
config/frontier-lock/world-id-lock.yml
config/frontier-lock/runtime-boundary-lock.yml
config/frontier-lock/resource-pack-input-lock.yml
config/frontier-lock/persistence-authority-lock.yml
```

例外：

- Formattingだけでも本Taskでは変更しない。
- Commit provenanceをMachine-readable Lockへ追加しない。
- `fe16ca6...`の内容は既にLock Fileへ反映済みであるため、再編集しない。

---

## 10. 更新対象

必要最小限：

```text
docs/06-acceptance-tests.md
docs/14-frontier-v0.1.0-scope.md
docs/investigations/2026-07-26-frontier-order8-lock.md
codex/README.md
```

新規Task Archive：

```text
codex/Project_Wayfarer_Frontier_Lock_Post_Approval_Document_Alignment.md
```

新規Investigationは原則不要。

既存Reportへ追記するだけで履歴が十分でない場合のみ、次を作成してよい。

```text
docs/investigations/<date>-frontier-lock-post-approval-document-alignment.md
```

その場合もFormal Lock Reportを正本として参照する。

---

## 11. Runtime非変更

本Taskで変更しない。

```text
servers/main/
servers/frontier/
servers/lobby/
velocity/
manual-downloads/
local/
infrastructure runtime data
MariaDB
Redis
LuckPerms
MVI runtime data
Worlds
Player Data
Plugin JAR
Content Archive
Generated Pack
Secrets
```

Serverを起動しない。

Protected Portを開かない。

Artifactを再Download、Copy、Extractまたは再Hashしない。

---

## 12. 検証

### Git

```powershell
git status --short
git diff --check
git diff --stat
git diff --cached --name-status
git log -12 --oneline
```

### Layout

```powershell
.\scripts\Test-Layout.ps1
```

### 変更Path

最終Diffが原則次だけであることを確認する。

```text
docs/06-acceptance-tests.md
docs/14-frontier-v0.1.0-scope.md
docs/investigations/2026-07-26-frontier-order8-lock.md
codex/README.md
codex/Project_Wayfarer_Frontier_Lock_Post_Approval_Document_Alignment.md
```

別Investigationを作成した場合はそのPathも許可する。

### Acceptance Exact Text

次の3行がそのまま存在することを確認する。

```text
`main`, `main_nether`, `main_the_end`, unknown Worlds, Creative／Spectator, and cancelled breaks grant no Progress.
Player-placed blocks, generator-produced blocks, and Silk Touch re-placed ores are valid Progress sources.
Explosion, Piston, WorldEdit, Command, Plugin deletion, and other non-player block removal grant no Progress.
```

次の曖昧な組合せが残っていないことを確認する。

```text
main ... are valid Progress sources
Creative／Spectator ... are valid Progress sources
cancelled breaks ... are valid Progress sources
```

### Frontier Scope

検索：

```text
Wayfarer_Main responsibilities
Wayfarer_Main project dependency and cross-backend boundary
Main-only Growth Pickaxe and its detailed acceptance
Wood → Stone → Iron → Diamond
Pending Delivery
Waymark Full Repair
Project-wide Release Blocker
```

`docs/14-frontier-v0.1.0-scope.md`では、Growth Pickaxeの詳細が残っていないことを確認する。

同時に、次の趣旨が短く残っていることを確認する。

```text
Wayfarer_Main is a Project-wide V0.1.0 Release Blocker.
Wayfarer_Main is not installed on Frontier.
Frontier depends on its completion only as a network-wide release dependency
and cross-backend isolation boundary.
```

Network／Main正本ではGrowth Pickaxe詳細を維持する。

### Commit provenance

次がFormal ReportとCodex Archiveに存在することを確認する。

```text
201681ea026936909558839bc4445d9ccb7be567
ebb100afce96cd467e4e4de93b039c3e8ecaf77a
fe16ca6c6200732ee4b1960126ecb8f5dcb96795
```

### Lock非変更

```powershell
git diff 3789daf69c76ef17983ef13d170fe72f92c54b03 -- config/frontier-lock
```

出力が空であること。

次も変更なし。

```text
versions.yml
plugin-manifest.yml
docs/15-frontier-runtime-lock.md
```

`docs/15`へCommit provenance注記が本当に必要な場合だけ、意味変更なしの最小追記を許可する。その場合は理由を報告する。

---

## 13. Commit／Push

推奨Implementation Commit：

```text
docs: Frontier Lock承認後の文書責務を整合
```

推奨Archive Commit：

```text
docs: Frontier Lock文書整合Commitを記録
```

二Commitに分ける場合、Implementation CommitのFull SHAをArchiveへ記録する。

Push前：

```powershell
git diff --check
.\scripts\Test-Layout.ps1
git status --short
git log -8 --oneline
```

Push後、Remote SHAを確認する。

---

## 14. Codex Archive

本Task：

```text
完了（実装Commit: <SHA>）
```

Order 8：

```text
完了
Proposal: FRONTIER-LOCK-20260726-003
Runtime validation: deferred
実装Commit: 201681ea...
記録Commit: ebb100af...
追補Commit: fe16ca6...
```

再実行Policy：

```text
本Task完了後はそのまま再実行禁止。
Artifact／World／MVI／Gate／Pack／Authorityの変更は新しいFrontier Lock Revision Task。
Growth PickaxeのGameplay変更は新しいMain Plugin Concept／Design Task。
```

---

## 15. 完了条件

すべて必要。

### Owner Commit

- HEAD起点が`3789daf...`
- `fe16ca6...`が直前祖先
- Owner変更をRevertしていない
- ConceptのMarkdown整形を保持
- Growth Progress方針を保持

### Acceptance

- Resource三次元だけが対象
- Main三次元／unknownは非対象
- Creative／Spectatorは非対象
- Cancelled Breakは非対象
- Player設置Blockは対象
- Generator生成Blockは対象
- Silk Touch再設置Oreは対象
- successful non-cancelled BlockBreakEventごとにExactly once
- 非Player removalは非対象
- 指定されたExact 3行を使用

### Frontier Scope

- Wayfarer_Main詳細を削減
- Main-only sibling boundaryを保持
- Project-wide V0.1.0 Release Blocker参照を保持
- Frontier Runtime componentではないことを明記
- Growth Pickaxe詳細はNetwork／Main正本に残存
- Main／Frontier item non-transferを維持
- Frontier固有Release Blocker一覧でMain詳細を重複しない
- Network全体のBlockerとしてのWayfarer_Mainを弱体化しない

### Formal Lock

- `201681ea...`をImplementation Commitとして維持
- `ebb100af...`をArchive Commitとして維持
- `fe16ca6...`をPost-lock clarificationとして記録
- CoreProtect unselected／unplacedを維持
- Ruined三次元 persistent-lifecycle-managedを維持
- Lock File変更なし
- Proposal 003再承認なし

### Safety

- Runtime変更なし
- Server起動なし
- World変更なし
- DB変更なし
- Permission変更なし
- Artifact変更なし
- Final Main Baseline変更なし
- Clean final status

---

## 16. 完了報告

次を報告する。

1. Recommended Sol
2. Pre-execution HEAD
3. Owner Commit ancestry
4. Owner変更保持
5. Implementation Commit SHA／Message
6. Archive Commit SHA／Message
7. Branch／Remote
8. Updated files
9. Acceptance Exact Text
10. Resource World条件
11. Player-placed Block条件
12. Generator Block条件
13. Silk Touch re-placement条件
14. Exactly-once Event条件
15. Non-player removal条件
16. Frontier Scopeから削減したMain詳細
17. Frontierに残したWayfarer_Main境界
18. Project-wide Release Blocker参照
19. Network／Main正本で維持したGrowth Tool Scope
20. Formal Lock Implementation Commit
21. Formal Lock Archive Commit
22. Post-lock clarification Commit
23. CoreProtect placement
24. Ruined lifecycle
25. Lock File non-change
26. Proposal 003 status
27. Runtime validation status
28. Runtime non-change
29. Layout validation
30. Git exclusion
31. Final `git status --short`

---

## 17. 完了後の正式状態

```text
Order 8 Frontier Lock:
  complete

Proposal:
  FRONTIER-LOCK-20260726-003

Runtime validation:
  deferred

Formal implementation commit:
  201681ea026936909558839bc4445d9ccb7be567

Formal archive commit:
  ebb100afce96cd467e4e4de93b039c3e8ecaf77a

Post-lock clarification commit:
  fe16ca6c6200732ee4b1960126ecb8f5dcb96795

Owner manual commit:
  3789daf69c76ef17983ef13d170fe72f92c54b03
  preserved

Wayfarer_Main:
  V0.1.0 required
  Project-wide Release Blocker
  Main-only
  not a Frontier Runtime component
  detailed scope owned by network／Main documents

Frontier Scope:
  keeps only Project dependency and cross-backend boundary details for Wayfarer_Main

Runtime:
  unchanged

Next Roadmap task:
  Order 9 Plugin Repository foundation＋Wayfarer_Core
```
