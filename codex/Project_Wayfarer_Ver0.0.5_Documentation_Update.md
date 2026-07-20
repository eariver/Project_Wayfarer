# Project Wayfarer Ver.0.0.5 文書更新 Codex指示書

## 1. 目的

Project Wayfarerの設計・導入・運用文書Revisionを`Ver.0.0.4`から`Ver.0.0.5`へ更新する。

Ver.0.0.5では、次を正式文書へ反映する。

1. Phase 3までに完了した現在のBaseline
2. V0.1.0 Alphaまでに残るRelease Blockerと推奨実施順序
3. Main初期Spawn周辺のWorldGuard保護方針
4. Main初期Spawn保護は、ユーザーによる初期整備が概ね完了した後に実施すること
5. CoreProtectをHub／Gateの本格建築前に導入する推奨順序
6. Builder Phase 1Bを、Advanced Portals・Playable Frontier Theme・Builder担当作業確定後に実施すること
7. V0.2.x以降の独自Plugin構想は別の草案文書へ保存済みだが、V0.1.0の実装対象ではなく、まだ開発に着手しないこと
8. `codex/`内の歴史的指示書と構想草案の位置付け
9. 既存Branchへの直接Commit／PushではGitHub CLIが不要であること

本タスクは**文書・Metadata更新だけ**である。

実施しないもの：

- Plugin導入
- Plugin JAR取得・配置
- WorldGuard Region作成
- `server.properties`変更
- Main SpawnのBlock変更
- EvenMoreFish導入
- CoreProtect導入
- Advanced Portals導入
- Frontier Theme導入
- Builder Phase 1B実装
- Hub／Gate建築
- Portal Routing
- Resource Reset
- 独自Plugin Repository作成
- 独自Plugin Source実装
- 成長Tool実装
- Database Schema追加
- V0.1.0 Release宣言

---

## 2. 作業基準

最新の`main`を取得し、少なくとも次のCommitを含むことを確認する。

```text
8daecd20a829e1bdcf21d1ba6a82405afaf728a3
feat: Main恒久Worldを最終生成
```

開始前に実行する。

```powershell
git status --short
git branch --show-current
git rev-parse HEAD
git fetch
git status -sb
```

確認する。

- Current Branch
- HEAD
- remoteとの差分
- 未Commit変更
- 未追跡ファイル
- 他者の作業
- 現在の文書Revision
- `docs/09-roadmap.md`
- `docs/06-acceptance-tests.md`
- `docs/11-deferred-design-items.md`
- `docs/13-main-world-baseline.md`
- `codex/README.md`
- `versions.yml`
- `plugin-manifest.yml`

既存変更を破棄しない。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- History Rewrite
- Runtime起動
- Runtime Config変更
- JAR／World／Database／Backup操作
- 未実装機能を完了扱いすること
- V0.2.x構想をV0.1.0 Release Blockerへ追加すること
- V0.2.x構想のSource Code作成
- 古いCodex指示書を現行仕様の正本として使用すること

---

## 3. Git／Push方針

本タスクは既存`main` Branchへの直接Commit／Pushであり、Pull Requestを作成しない。

したがってGitHub CLI（`gh`）は不要である。

次を行わない。

```text
gh --version
where.exe gh
Get-Command gh
GitHub CLIの検索
GitHub CLIのインストール
PR作成
```

GitHub CLIがローカルに存在しないことは、WarningでもBlocking事項でもない。

通常のGit Commandを使用する。

```powershell
git add <approved-files>
git commit -m "docs: 設計基準をVer.0.0.5へ更新"
git push
git rev-parse HEAD
git status -sb
```

GitHub CLIを確認するのは、Pull Request、GitHub Issue、GitHub Release等の操作が個別タスクで明示された場合だけとする。

---

## 4. Ver.0.0.5の位置付け

Ver.0.0.5は設計・導入・運用文書のRevisionであり、Server Releaseではない。

正式な表現：

```text
Document revision: Ver.0.0.5
Target server release: V0.1.0 Alpha（未達）
```

Ver.0.0.5で行うこと：

- Phase 3完了後の実態を正式基準へ統合する
- V0.1.0までの残作業を再整理する
- Main Spawn保護設計を追加する
- V0.2.x構想を明確にV0.1.0 Scope外へ分離する

Ver.0.0.5で行わないこと：

- V0.1.0達成宣言
- Git Tag作成
- GitHub Release作成
- Runtime Version更新
- Plugin Artifact更新

更新日は実作業日を使用する。

---

## 5. 現在の完了Baseline

正式文書へ、少なくとも次が完了済みであることを整合的に記載する。

### Network／Infrastructure

- Velocity Modern Forwarding
- Backend直アクセス制限
- Lobby初期RoutingとFailover
- ViaVersion 5.11.0によるMinecraft 26.2 ClientからFrontier Paper 1.21.11への接続
- MariaDB 11.8
- Redis 8 AOF
- LuckPerms共有Storage
- mcMMO共有Storage
- Waymark共有Storage

### Permission

- Phase 1A完了
- 5つの恒久Group
- Self-only Temporary Builder／Admin Parent
- Admin Full Access
- OP廃止
- 既存`wayfarer_builder`再利用
- Builderは現時点でRole Container
- Builder最終Allowlistは未実装

### Worlds／Gameplay foundation

- Lobby／Frontier Gate Void World
- WorldEdit／WorldGuard
- TAB Proxy構成
- Multiverse Persistent／Resource Family
- mcMMO Main／Frontier共有
- RedisEconomy／VaultUnlocked共有Waymark
- EconomyShopGUI Main固定価格Shop
- BetterStructures Main限定
- `103 Default Structures` version 5
- Main恒久3 Dimension最終生成
- Resource Family保持
- Main／Nether／End安全Spawn確定

Main World Baselineの正本は`docs/13-main-world-baseline.md`とする。

次を正確に維持する。

- Seed：`164225356311935743`
- Main Spawn：`(320, 70, 128)`
- Nether管理Spawn：`(20.5, 60, -19.5)`
- End管理Spawn：`(100.5, 49, 0.5)`
- BetterStructures Spawn Protection：100 Block
- Main End実Bukkit名：`main_the_end`
- `main_end`はMultiverse Alias
- Resource Familyは破壊範囲外で保持済み

---

## 6. V0.1.0までの推奨実施順序

`docs/09-roadmap.md`を、単なる番号列ではなく依存関係が理解できるよう更新する。

### 6.1 Phase 4 - EvenMoreFish

次の実装タスクとして維持する。

- Main限定導入
- 採用Config読込
- 代表CommandまたはCatchを1件確認
- mcMMO Fishingとの明示的Config競合確認
- 網羅試験は行わない

### 6.2 CoreProtectの前倒し

CoreProtectは従来の後段番号を維持してもよいが、実務上は**Hub／Gateの本格建築前に導入する推奨順序**を明記する。

理由：

- Hub／Gate建築開始時点から履歴を記録する
- 誤破壊や荒らし調査に利用できる
- 後から導入しても過去のBlock履歴は取得できない

方針：

- CoreProtectはCold Backupの代替ではない
- BuilderへRollback権限を渡さない
- 原則Admin専用
- 配置BackendとDatabase方針は別タスクで確定
- 正式なRoadmap番号変更が必要なら、文書全体で一貫させる

推奨する実作業順序：

```text
EvenMoreFish
CoreProtect
Playable Frontier Theme選定・導入
Advanced Portals導入・Permission調査
Builder Phase 1B
ユーザーによるHub／Gate建築
Portal Routing
Resource Reset Bootstrap
Integrated Operations
Cold Backup／Isolated Restore
V0.1.0 Baseline
```

### 6.3 Playable Frontier Theme

V0.1.0では1 Themeだけを導入する。

記載する。

- Paper 1.21.11／Java 25互換性
- License／費用／配布方式
- 依存Plugin
- Resource Pack
- World構成
- 代表的なEntrance／Start
- 実際に探索・戦闘・Dungeon・Quest等を遊べるContentであること
- World GeneratorだけではTheme要件を満たさない

V0.1.0では実装しない。

- Frontier WM報酬
- Theme Achievement
- Main側Achievement Reward
- Theme別Inventory
- 初回装備配布
- WM装備購入
- 複数Theme

### 6.4 Advanced Portals

Builder Phase 1Bより前に、採用VersionとPermission体系を確定する。

確認対象：

- Velocity／Paper配置
- Portal作成・編集・削除
- Destination設定
- Server転送
- Reload／Debug
- Builderへ渡す操作
- Admin専用操作

### 6.5 Builder Phase 1B

次が確定した後に実施する。

- Advanced Portals Version／Permission
- Playable Frontier Theme
- Builderが担当するHub／Gate／Theme接続作業

候補Allowlist：

- WorldEdit：Lobby／Main／Frontier
- Gamemode：Lobby／Main／Frontier
- Teleport：Lobby／Main／Frontier
- Multiverse-Core：必要な非破壊Commandのみ
- Multiverse-NetherPortals：Mainのみ
- Advanced Portals：承認されたGate編集操作のみ
- Theme管理：Builderが担当する場合だけ

除外：

- WorldGuard Region管理
- Velocity管理
- LuckPerms管理
- Economy管理
- Player処分
- Server Stop
- Wildcard
- Reload／Debug／Internal
- World Create／Import／Unload／Delete／Clone／Regenerate／Purge

Phase 1Bは、BuilderによるHub／Gate／Theme接続作業前のRelease Blockerである。

### 6.6 Hub／Gate建築

ユーザーが手作業で構築・承認する。

- Lobby minimum Hub
- Lobby Main Gate
- Lobby Frontier Gate
- Main initial Spawn Hub
- Main Lobby Return
- Main Frontier Gate
- Main Resource Gate
- Main Resource Nether Gate
- Main Resource End Gate
- Frontier Gate minimum Hub
- Frontier Theme Gate
- Theme Return destination
- 各Resource Return Gate
- Resource End外周島安全拠点

Codexは外観、寸法、座標、向き、素材を推測しない。

### 6.7 Portal Routing

必要Route：

```text
Lobby
├─ Main spawn Hub
└─ Frontier Gate

Main
├─ Lobby
├─ Frontier Gate
├─ resource
├─ resource_nether
└─ resource_end

Frontier Gate
├─ Lobby
├─ Main
└─ Playable Theme

Playable Theme
└─ Frontier Gate

resource
resource_nether
resource_end
└─ Main spawn Hub
```

変更したRouteだけを詳細確認する。

### 6.8 Resource Reset Bootstrap

V0.1.0 Release Blockerとして維持する。

- 安全Arrival
- Spawn／Arrival設定
- Return Gate構造
- Portal再設定
- 必要な保護再設定
- `resource_end`外周島安全拠点
- Idempotent手順
- Exact Runtime Path
- Persistent World拒否

方式候補：

- ユーザー作成WorldEdit Schematic
- Tracked Template
- PowerShell／Command手順
- 将来の独自Plugin
- 承認された組み合わせ

### 6.9 Integrated Operations

正式Interface：

```powershell
Wayfarer.ps1 -Action Start
Wayfarer.ps1 -Action Stop
Wayfarer.ps1 -Action Restart
Wayfarer.ps1 -Action Status
Wayfarer.ps1 -Action Backup
```

必要事項：

- 接続受付停止
- User通知／切断
- Velocity停止
- 約10秒Settling
- Paper Save Flush
- Main／Frontier／Lobby正常停止
- Java Process終了確認
- Infrastructure状態
- `.incomplete`

### 6.10 Cold Backup／Restore

必須：

- MariaDB Dump
- Redis正常停止
- Redis AOF Volume Copy
- Persistent Worlds
- Config
- Frontier Content
- Manifest
- SHA-256
- `.incomplete`
- Isolated Restore
- Restore後の代表確認

### 6.11 V0.1.0 Baseline

最後に実施する。

- 全Release Blocker確認
- Baseline Backup
- Release Commit確定
- Known Limitations
- Git Tag／GitHub Release判断
- `V0.1.0 Alpha`宣言

---

## 7. Main初期Spawn保護方針

## 7.1 実施時期

Main Spawn周辺のWorldGuard保護は、ユーザーによる初期Spawn Hubの整備が概ね完了してから実施する。

現時点ではRegionを作成しない。

理由：

- Hub外形が未確定
- Gate／設備位置が未確定
- 早期にRegionを固定すると、境界変更やPriority競合が増える
- ユーザーの建築作業中に不必要な保護制約を発生させない

RoadmapまたはDeferred項目へ、次を明記する。

```text
Main Spawn保護は設計済み・未実装。
ユーザーの初期整備完了後、別タスクでExact Region範囲を承認して適用する。
```

## 7.2 使用Plugin

現行WorldGuard 7.0.17を使用し、新規Pluginは追加しない。

MainにはWorldEdit／WorldGuardが配置済みだが、現時点ではProject固有Regionがない。

## 7.3 Region設計

仮称：

```text
main_spawn_hub
```

正式なRegion名とExact座標は実装タスクで確定する。

基本方針：

- 一般Player：Block設置・破壊不可
- `wayfarer_builder` Member：建築可能
- Temporary Admin：管理可能
- `build` Flagを使用しない
- `block-break deny`／`block-place deny`を全面Flagとして安易に使用しない
- WorldGuardのRegion Membershipによる標準保護を使用する

一般公開Interaction：

```text
use allow
```

これにより公開対象とする候補：

- Door
- Button
- Lever
- Pressure Plate
- Trapdoor
- Lectern等

Region全体へ原則付与しないもの：

```text
interact allow
chest-access allow
```

理由：

- `interact`はEntity／Item Frame／Vehicle等まで広く影響する
- `chest-access`は公開Container以外へ不要

特殊設備は小さな子Regionで許可する。

例：

```text
main_spawn_tool_station
main_spawn_public_storage
main_spawn_gate_control
```

子Region方針：

- 親Regionより高Priority
- 必要なFlagだけAllow
- 建築保護を迂回しない
- 必要なら`passthrough allow`
- Exact設備範囲だけを囲う

### Tool／Utility GUI

将来の専用Tool修理GUI、再発行GUI、Utility Block、NPC等で`interact`が必要になった場合、設備周辺の小Regionだけで許可する。

### Gate

Advanced Portalsが接触型Portalであれば通常Interaction Flagは不要な可能性がある。

Button／NPC／Block右クリック型Gateでは、該当設備だけに`use`または限定的`interact`を許可する。

採用Versionと実Gate方式で確認する。

## 7.4 環境保護

Main Spawn Regionの推奨Flag候補として記録する。

```text
pvp deny
tnt deny
creeper-explosion deny
other-explosion deny
wither-damage deny
ghast-fireball deny
enderdragon-block-damage deny
enderman-grief deny
ravager-grief deny
lighter deny
fire-spread deny
```

`mob-spawning`と`mob-damage`は、Hub内でMob戦闘を残すかによって実装タスクで決定する。

Flag名はWorldGuard 7.0.17 Runtimeで確認し、推測で適用しない。

## 7.5 Vanilla Spawn Protection

現行Main：

```properties
spawn-protection=16
```

WorldGuard Regionの建築・Interaction・Builder Member動作を確認した後、別タスクで次へ変更する候補とする。

```properties
spawn-protection=0
```

目的：

- Vanilla Spawn ProtectionとWorldGuardの二重管理を避ける
- `wayfarer_builder` MemberであるのにVanilla保護で建築不能になる混乱を避ける
- OPを使用しない権限設計と整合させる

WorldGuard Region実装前に`spawn-protection=0`へ変更しない。

## 7.6 受入確認の将来要件

Main Spawn保護実装タスクで確認する。

一般Player：

- Block破壊拒否
- Block設置拒否
- Door／Button等の承認済み`use`成功
- 非公開Container拒否
- WorldGuard管理拒否

Builder：

- Region内建築成功
- Region外は通常Worldルール
- WorldGuard管理Command拒否
- Builder Parent解除後に建築拒否

Admin：

- Region管理可能
- OP不要

環境：

- 承認済み爆発／Fire／Grief保護
- Gate代表動作
- Restart後維持

---

## 8. V0.2.x独自Plugin構想の扱い

別途、次のMarkdownが本タスク入力として提供される。

推奨保存先：

```text
codex/Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md
```

この文書には以下の構想が含まれる。

- `Wayfarer_Core`
- `Wayfarer_Lobby`
- `Wayfarer_Main`
- `Wayfarer_Frontier`
- 共通Library／Multi-module構成
- Main専用の成長Tool草案
- 進化Item
- Over-enchant
- Broken Tool
- WM修理
- Soulbind
- 再発行
- MariaDB永続化
- Redisの補助利用
- Crash／Duplicate／Transaction対策

この文書の位置付け：

- V0.2.x以降の構想草案
- 実装仕様ではない
- 現行Runtimeの正本ではない
- V0.1.0 Release Blockerではない
- 実装開始承認ではない
- Source Repository作成承認ではない
- Database Migration承認ではない
- Plugin Artifact作成承認ではない

Ver.0.0.5の正式文書には、構想の存在とScope外であることだけを記載する。

推奨記載：

```text
V0.2.x以降の独自Plugin構想は`codex/Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md`へ草案として保存する。
V0.1.0 Alphaの実装対象またはRelease Blockerには含めず、別途承認された設計・Repository・実装タスクまで着手しない。
```

現行`docs/11-deferred-design-items.md`の特殊Tool項目と整合させる。

次を変更しない。

- Over-enchanted ToolはV0.1.0非Blocker
- Custom Plugin RepositoryはV0.1.0非Blocker
- LABはV0.1.0非Blocker

---

## 9. `codex/README.md`更新

実行履歴へ次を追加する。

### Ver.0.0.5文書更新指示書

- 状態：完了後は「完了」
- 実施日：実作業日
- 現行正本：更新後のDesign Guide、Roadmap、Acceptance Tests
- 再実行：そのままの再実行禁止

### V0.2.x独自Plugin構想

- 種別：構想草案
- 状態：未着手／設計保留
- 実施日：草案保存日
- 現行正本：なし。将来の承認済み設計が優先
- 再実行：実行Taskではない
- 注記：V0.1.0 Scope外

`codex/README.md`の優先順位規則は維持する。

構想文書を`docs/`正本より上位にしない。

---

## 10. 更新対象

最低限、次を確認・更新する。

- `README.md`
- `AGENTS.md`
- `docs/00-design-guide.md`
- `docs/01-architecture.md`
- `docs/02-installation.md`
- `docs/03-operations.md`
- `docs/04-play-guide.md`
- `docs/06-acceptance-tests.md`
- `docs/09-roadmap.md`
- `docs/11-deferred-design-items.md`
- `docs/13-main-world-baseline.md`
- `codex/README.md`
- `versions.yml`
- `plugin-manifest.yml`

必要に応じて：

- `docs/05-troubleshooting.md`
- `docs/08-plugin-collection.md`
- 文書Index

本指示書を次へ保存する。

```text
codex/Project_Wayfarer_Ver0.0.5_Documentation_Update.md
```

ユーザー提供のV0.2.x構想文書を次へ保存する。

```text
codex/Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md
```

既存の歴史的指示書を変更する必要はない。

---

## 11. 文書Revision更新

文書内のRevision表記を監査する。

更新対象となる現行基準：

```text
Ver.0.0.4
```

更新後：

```text
Ver.0.0.5
```

ただし、次は過去の事実として維持してよい。

- 「Ver.0.0.4で決定した」
- 過去のInvestigation
- 過去の指示書Title
- 完了Commitの履歴
- Phase実施時点の文書Revision

機械的な全文置換をしない。

`versions.yml`と`plugin-manifest.yml`の文書Revision Metadataがある場合は`Ver.0.0.5`へ更新する。

Runtime Plugin Versionは変更しない。

---

## 12. Acceptance Tests更新

`docs/06-acceptance-tests.md`で、実装済みと文書化のみを区別する。

完了済み：

- Phase 1A
- BetterStructures
- Main Final Generation

未完了：

- EvenMoreFish
- CoreProtect
- Frontier Theme
- Advanced Portals
- Builder Phase 1B
- Hub／Gate
- Portal Routing
- Resource Bootstrap
- Integrated Operations
- Cold Backup
- Isolated Restore
- V0.1.0 Baseline

Main Spawn保護：

```text
設計済み・未実装
ユーザーの初期整備完了後に別タスクで適用
```

V0.2.x独自Plugin：

```text
構想草案のみ
V0.1.0受入対象外
```

未実施項目へCheckを付けない。

---

## 13. Deferred Design更新

`docs/11-deferred-design-items.md`へ、必要な範囲で次を追加・補正する。

### Main Spawn保護

| 課題 | 現在の方針 | V0.1.0影響 | 解決候補 | 再検討時期 |
|---|---|---|---|---|
| Main Spawn保護Region未設定 | ユーザーが初期Hubを概ね整備するまでWorldGuard Regionを作らない | Blocker。公開前に保護が必要 | `main_spawn_hub` Membership保護、`use allow`、設備別子Region | Hub整備完了後 |
| Vanilla Spawn Protectionとの二重管理 | 現在`spawn-protection=16`を維持 | Region実装までは許容 | WorldGuard検証後に0へ統一 | Main Spawn保護タスク |

### V0.2.x独自Plugin

現行のOver-enchanted Tool項目を維持し、別草案への参照を追加してよい。

記載：

- V0.1.0非Blocker
- 実装未着手
- V0.2.x候補
- 別途Design Approvalが必要
- `codex/Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md`は参考草案

---

## 14. Repository／Artifact方針

本タスクでCommitしてよいもの：

- Markdown
- YAML／CSV等の文書Metadata
- `codex/`草案

Commitしないもの：

- JAR
- World
- Player Data
- Database Data
- Backup
- Log
- Cache
- Credential
- Screenshot
- Build Artifact
- 独自Plugin Source

V0.2.x構想Markdownは、将来変更される可能性が高い草案であることを冒頭に明記する。

---

## 15. 検査

実行する。

```powershell
git status --short
git diff --check
git diff --stat
git diff
```

Repositoryに存在する文書・Layout検査だけを使用する。

YAML／CSVを変更した場合は構文を確認する。

確認する。

- Ver.0.0.5表記が正式文書で一貫
- V0.1.0は未達
- Phase 3は完了
- Phase 4は未完了
- Main Spawn保護は設計済み・未実装
- Region作成済みと書いていない
- `spawn-protection=0`へ変更済みと書いていない
- CoreProtect導入済みと書いていない
- V0.2.x Pluginを実装済みと書いていない
- V0.2.x PluginをV0.1.0 Blockerにしていない
- V0.2.x構想が`codex/`の草案として登録
- GitHub CLI不要方針が指示書にある
- Secret／Runtime Dataなし
- 古い指示書の履歴を破壊していない

広範なRuntime Testは行わない。

---

## 16. Commit／Push

Commit条件：

- 文書だけの変更
- Revision整合
- Roadmap整合
- Acceptance整合
- Deferred項目整合
- `codex/README.md`整合
- V0.2.x構想保存
- `git diff --check`成功
- Secret／Runtime Dataなし

推奨Commit Message：

```text
docs: 設計基準をVer.0.0.5へ更新
```

既存`main`へ直接Pushする。

```powershell
git push
```

Pull Requestは作成しない。

GitHub CLIは探さない。

Commit後に次を確認する。

```powershell
git rev-parse HEAD
git status -sb
```

---

## 17. 完了報告

報告する。

- 作業開始時HEAD
- 更新後Document Revision
- 更新日
- 更新ファイル
- Roadmapの推奨順序
- Main Spawn保護方針
- Main Spawn保護が未実装であること
- CoreProtect前倒し方針
- V0.2.x構想文書の保存先
- V0.2.x実装未着手
- V0.1.0 Scope外であること
- `codex/README.md`更新
- 実行した検査
- Commit SHA
- Push先Branch
- 次の実装タスクがEvenMoreFishであること

Player名、UUID、Credential、Local Backup詳細は報告へ含めない。
