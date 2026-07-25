# Plugin Scope and Frontier Lock Revision 003 Resync

## Summary

| Item | Result |
| --- | --- |
| Date | 2026-07-26 |
| Recommended Sol | `high` |
| Pre-execution HEAD | `9abc12ae5f472325933d38c5eacc6050aaf3e6c7` |
| Branch／Remote | `main`／`origin` |
| Current Proposal | `FRONTIER-LOCK-20260726-003` |
| Proposal status | Candidate、exact approval待ち |
| Phase B | 未実行／未承認 |
| Runtime change | なし |

本Taskは、Ownerが更新した最新ConceptとProject正本、Roadmap、Acceptance、
Backup／RestoreおよびFrontier Order 8 Phase A候補をRevision 003へ同期した
文書Taskである。Server、Plugin、World、Portal、MVI、Permission、MariaDB、
RedisおよびResource Packは操作していない。

## Authorityと入力確認

割り当て済み指示書が参照する次のHandoff名は、開始時点のRepositoryおよび
Git履歴に存在しなかった。

- `Project_Wayfarer_Cross_Chat_Concept_Sync_Instructions_v0.0.1(2).md`
- `Project_Wayfarer_Main_Chat_Document_Sync_Handoff_v0.0.1.md`

割り当て済み指示書自体が採用Scopeを全Sectionで具体的に再掲し、Owner Commitが
最新Conceptを保持していたため、存在しない外部Handoffを推測せず、指示書に明記された
ScopeとRepository内の現行ファイルだけを使用した。Gameplay判断の追加やConceptの
Version Upは行っていない。

## Commit履歴監査

次の直線祖先関係を`git merge-base --is-ancestor`で確認し、すべて成功した。

```text
8096335843e4b09d648fe866aa01ca8d5a5c65f3
  → 7f54a2b802cf4a4216a024a7b4048fbe5d8f789e
  → 354052c9dd80d77b8b83c49f783e4d4b7b8755fd
  → a09db72a6ec45b436b59aec6fe6377e4d1c276f1
  → d1158af4d6ff4fee52ac5f5b511181899f00e956
  → 9abc12ae5f472325933d38c5eacc6050aaf3e6c7
```

`a09db72...`は候補YAML、Preflight、ignored staging案内および指示書Archiveだけを
追加したPhase A静的調査で、正式LockやRuntime配置を作成していない。
`d1158af...`はUser配置Artifactの静的証拠とProposal 002候補を更新したが、
`status: candidate`とRuntime検証繰越を維持した。両CommitともServer起動、
World生成、DB／Permission変更またはPhase Bを含まないため、当時のPhase A対応として
適切だった。

Owner Commit `9abc12ae...`は最新Frontier／Theme／Plugin Conceptを追加・Archive化
したCommitとしてそのまま保持した。Reset、Rebase、Amend、Squashまたは履歴書換えは
行っていない。

## 同期したCurrent Contract

### Custom Plugin

- V0.1.0必須は`Wayfarer_Core`、`Wayfarer_Main`、`Wayfarer_Frontier`。
- SourceはProject Wayfarer外の一つのGradle Multi-module Repositoryで管理する。
- `Wayfarer_Core`はMain／Frontier、`Wayfarer_Main`はMainだけ、
  `Wayfarer_Frontier`はFrontierだけへ配置する。
- `Wayfarer_Frontier_EliteMobsMVI`は`ADAPTER_REQUIRED`時だけ追加する独立Runtime
  Artifactであり、`Wayfarer_Frontier`の常設内部Moduleではない。
- 独立Adapterは承認済みInstance検出、MVI Guild登録／解除、Restart残留監査と
  Reconcileだけを担当し、通常Inventory、EliteMobs Lifecycle、Gameplay、退出、
  RespawnおよびWorld削除を担当しない。

### Wayfarer_Main／Growth Pickaxe

Growth PickaxeをMain限定のV0.1.0 Release Blockerとして正式Scopeへ追加した。
MariaDB logical identity、Owner Bind、`resource`／`resource_nether`／`resource_end`
だけのProgress、Material／Enchant Evolution、Broken状態、Waymark Full Repair、
初回非同期配布、Pending Delivery、Audit／Reconcileおよび完全Config再計算を
AcceptanceとBackup／Restoreへ反映した。

Main三次元、Frontierおよび未知WorldはProgress対象外である。Main／Frontier間の
Item移送はなく、Waymark操作はAdapter経由とし、RedisEconomy内部Keyを直接操作しない。
Pre-release ResetでGrowth Tool DataをResetするか保持するかは未決で、別のOwner承認が
必要である。

### Frontier Theme boundary

- Worlds BeyondはIris Overworld `frontier_iris`一つだけ。
- `frontier_iris_nether`と`frontier_iris_the_end`は作成・登録しない。
- Worlds BeyondにMNP Link、Nether／End fallbackまたは別World fallbackを設けない。
- Ruined Frontierは`frontier_bs`、`frontier_bs_nether`、
  `frontier_bs_the_end`の三次元を維持する。
- MNP 5.0.5はRuined Frontier family-local linkだけに使用する。
- MVI `worlds_beyond` Groupは`frontier_iris`だけ、`guild` GroupはGuild、
  Primis、Ruined三次元および検証済みInstanceを対象とする。
- Main BackendとのItem／Player State分離はBackend／Network境界であり、
  MainをFrontier MVI Profileへ含めない。
- Worlds Beyond Elytraは`Unbreakable`とし、自動耐久維持を代替案として残さない。

### Block History／Rollback

Frontier製品は未選定である。CoreProtect CE 24.0の既知ArtifactとSHA-256は保持したが、
静的候補に留め、導入済み・採用済み・DB検証済みとは記録していない。

## Concept参照同期

- Plugin全体Concept v0.0.3 → Worlds Beyond Plugin v0.0.4
- Worlds Beyond Plugin v0.0.4 → Theme Concept v0.0.6、`Synchronized`
- Ruined Frontier Decision v0.0.2 → Ruined Theme v0.0.5
- Frontier Server v0.0.5
- Worlds Beyond v0.0.6
- Ruined Frontier v0.0.5

`concepts/**/old/`は変更していない。

## Roadmap

Order 1～8を維持し、現在のOrder 9～26を次へ同期した。

```text
9  Plugin Repository foundation + Wayfarer_Core
10 Wayfarer_Main / Growth Pickaxe
11 Wayfarer_Frontier
12 Frontier shared foundation
13 EliteMobs–MVI Adapter necessity decision
14 Ruined Frontier alpha
15 Worlds Beyond MVP
16 Frontier two-Theme integration
17 Final Gate and Permission lock
18 Builder Phase 1B
19 User Hub / Gate construction
20 Main Spawn protection
21 Portal Routing completion
22 Resource Reset Bootstrap
23 Integrated operations
24 Cold Backup / Isolated Restore
25 V0.1.0 Pre-release Player State Reset
26 V0.1.0 Baseline
```

## Proposal historyとDecision Gate

```text
FRONTIER-LOCK-20260726-001:
  status: superseded

FRONTIER-LOCK-20260726-002:
  status: superseded-before-approval
  phase_b: not-executed
  approval_token_received: false

FRONTIER-LOCK-20260726-003:
  status: candidate
  phase_b: not-authorized
  approval_token_received: false
  runtime_validation: deferred
```

Proposal 001／002の履歴をPreflight Reportに保持した。Proposal 002用Tokenは実行されて
おらず、無効である。ArtifactのVersion、採否およびSHA-256は変更していない。

現在のReserved Tokenは次であるが、本Taskでは使用しない。

```text
APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-003
```

## Phase B非実施

次の正式Lock Fileが存在しないことを確認した。

```text
docs/15-frontier-runtime-lock.md
config/frontier-lock/artifact-lock.yml
config/frontier-lock/world-id-lock.yml
config/frontier-lock/runtime-boundary-lock.yml
config/frontier-lock/resource-pack-input-lock.yml
config/frontier-lock/persistence-authority-lock.yml
```

Candidate YAMLはすべてProposal 003、`status: candidate`、
`phase_b: not-authorized`、`approval_token_received: false`、
`runtime_validation: deferred`である。

## Runtime非変更

本Taskの変更対象はMarkdownとYAMLだけであり、次を変更していない。

- `servers/main/`、`servers/frontier/`、`servers/lobby/`、`velocity/`
- Plugin JAR、Content Archive、World、Player Data、Log、Cache、Secret
- MariaDB、Redis、LuckPerms、MVI Runtime Data
- Runtime Resource PackおよびProtected Port

Serverを起動せず、ArtifactをDownload、Copy、再HashまたはStageしていない。

## Remaining decision

Proposal 003はPhase Aの現在候補であり、Order 8は完了していない。次の作業はUserによる
Proposal 003の確認である。承認する場合のみ、別MessageでReserved Tokenを完全一致で
送信する。Growth Tool Reset方針、Frontier History製品、Adapter必要性、外部Repository
の正確な名前／Group ID／Versioning／CIは、指定された後続Taskで決定する。
