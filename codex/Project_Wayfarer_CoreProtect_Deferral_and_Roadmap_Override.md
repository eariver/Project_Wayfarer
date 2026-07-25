# Project Wayfarer CoreProtect延期・Roadmap例外 追補指示書

## 1. 推奨Sol

```text
medium
```

理由：

- 本TaskはRuntime Plugin導入ではなく、CoreProtectの延期とRoadmap／Acceptance条件の更新を行う文書・運用変更である。
- World、Database、Plugin、Permission、Seed、UUID、RegionまたはFinal Main Baselineを変更しない。
- 一方で、V0.1.0のBlocking条件とHub／Gate構築順序を変更するため、単純な文言修正より慎重な整合性確認が必要である。

次の場合は`high`へEscalateして停止する。

- CoreProtect JARの導入、互換性試験またはDatabase作成を行う。
- WorldGuard Regionを実際に作成・変更する。
- Main／Lobby／FrontierのWorld、Permission、Portal、GateまたはRuntime Configを変更する。
- Final Main Baselineを更新または再Backupする。
- Frontier CoreProtect方針まで確定しようとする。

---

## 2. 目的

CoreProtect Community EditionがMain／LobbyのMinecraft 26.2 Runtimeへ未対応であるため、次の方針を正式化する。

```text
Main CoreProtect:
  延期

Lobby CoreProtect:
  延期

V0.1.0 Blocking条件:
  Main／Lobby CoreProtectを除外

既存CoreProtect導入指示書:
  無効化しない
  対応Version公開後の将来Taskとして保持
```

当面のPlayerはProject Owner本人だけであるため、CoreProtect未導入状態でも後続作業を継続できるものとする。

---

## 3. 既存指示書の扱い

次の文書は削除・無効化しない。

```text
codex/Project_Wayfarer_Main_CoreProtect_Integration_and_Acceptance.md
```

状態は次へ変更する。

```text
延期
Upstream Minecraft 26.2対応待ち
未実行
再実行禁止ではなく、前提成立後に再評価
```

既存文書内の採用Version、Artifact、Config、Permission、Database設計は将来実行時に再監査する。

対応Versionが公開された際も、そのまま実行せず、次を再確認する。

- 最新Stable Version
- Minecraft 26.2対応
- Paper 26.2対応
- Java 25対応
- Community Edition／License
- MariaDB Config
- World別Logging
- Permission Node
- Main／Lobby／Frontierの配置方針

---

## 4. Roadmap変更

従来：

```text
Order 6
→ Order 7 CoreProtect
→ Order 8 Frontier lock
```

変更後：

```text
Order 6 complete
→ Order 7 CoreProtect deferred / non-blocking
→ Order 8 Frontier lock
```

Order番号は維持する。

Order 7を完了扱いにはしない。

正式状態：

```text
Order 7:
  deferred
  non-blocking
  upstream compatibility wait

Order 8:
  next active task
```

---

## 5. V0.1.0 Blocking条件

Main／Lobby CoreProtectをV0.1.0 Release Blockerから外す。

ただし、次は維持する。

- CoreProtectはCold Backupの代替ではない。
- WorldGuardは履歴監査やRollbackの代替ではない。
- Main Final Baseline Backupを保持する。
- Hub／Gate構築前後に必要なBackup／Schematicを残す。
- Playerが増える前にCoreProtect再評価を行う。
- Public／Multi-player運用開始前に、対応Versionまたは代替監査手段を再検討する。

---

## 6. Hub／Gate構築方針

CoreProtect未導入でも、Hub／Gate構築を進めてよい。

理由：

```text
当面のPlayer:
  Project Owner本人のみ
```

構築後はWorldGuardで保護する。

### Main

- Hub範囲確定後、`main_spawn_hub` Regionを別Taskで作成する。
- General PlayerのBlock Place／Breakを禁止する。
- `wayfarer_builder`をRegion Memberとして扱う。
- Temporary AdminだけがRegion管理を行う。
- `build` Flagは使用しない。
- Public操作が必要な設備は、小さいChild Regionまたは個別Flagで扱う。
- WorldGuard受入完了まではVanilla `spawn-protection=16`を維持する。
- WorldGuard受入後、別承認Taskで`spawn-protection=0`を検討する。

### Lobby

- 既存のGlobal Region保護を維持する。
- Gate／設備追加時も最小範囲のRegion／Flagだけを追加する。
- BuilderへWorldGuard管理権限を与えない。

### Frontier

本追補では決定しない。

FrontierのCoreProtect、WorldGuard、MVI、Theme World、DatabaseおよびPermission境界はOrder 8以降で正式決定する。

---

## 7. CoreProtectなしでの代替保全

Hub／Gate構築では次を採用する。

### 構築前

- Final Main Baseline Backupの存在確認
- 対象Region座標記録
- 必要に応じてWorldEdit Schematic取得
- Git管理対象ConfigのClean状態確認

### 構築中

- 大規模変更を小さい作業単位に分ける
- Destructive WorldEdit前にSelection／Region／Commandを再確認
- Undo履歴だけを長期復旧手段として扱わない
- Owner以外へTemporary Adminを付与しない

### 構築後

- 完成SchematicをIgnored Backupとして保存
- Region座標、向き、到着点、設備位置を文書化
- WorldGuard保護を適用
- General Player／Builder／AdminのFocused Test
- Restart後Persistence確認
- 必要に応じて構築後Backupを作成

WorldGuardは予防的保護であり、変更履歴の監査・検索・時点Rollbackは提供しないことを明記する。

---

## 8. 再評価条件

次のいずれかが発生した場合、CoreProtectを再びBlocking候補として評価する。

- Minecraft 26.2対応Stable版が公開された。
- Owner以外のPlayerが参加する。
- Builderが複数人になる。
- Public Server運用を開始する。
- 大規模WorldEdit作業を複数人で行う。
- Grief／誤操作／監査要求が発生する。
- Hub／Gate以外の永続建築が大幅に増える。
- FrontierでCoreProtect採用が正式決定し、Main／Lobbyとの運用統一が有益になる。

---

## 9. 更新対象

最低限、次を更新する。

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/12-permission-model.md
docs/13-main-world-baseline.md
codex/README.md
```

必要に応じて新規作成：

```text
docs/investigations/<date>-coreprotect-deferral.md
```

本追補：

```text
codex/Project_Wayfarer_CoreProtect_Deferral_and_Roadmap_Override.md
```

`versions.yml`と`plugin-manifest.yml`には未導入Plugin Versionを正式採用済みとして記録しない。

---

## 10. 文書表現

正本では次の表現を使う。

```text
CoreProtect:
  Main／Lobbyへの導入はMinecraft 26.2対応Stable版待ち
  現時点では未導入
  V0.1.0のBlocking条件から一時除外
  Owner単独運用を前提
```

避ける表現：

```text
CoreProtect complete
CoreProtect accepted
CoreProtect unnecessary
CoreProtect permanently removed
WorldGuard replaces CoreProtect
```

---

## 11. Codex Archive

既存CoreProtect Task：

```text
延期（Minecraft 26.2対応待ち）
```

本追補：

```text
完了（実装Commit: <SHA>）
```

再実行Policy：

```text
本追補は現行方針変更の記録であり、同内容の再実行不要。
CoreProtect対応版採用時は、既存導入指示書を最新仕様に合わせて再監査する別Taskを作成する。
```

---

## 12. Commit／Push

推奨Commit：

```text
docs: CoreProtect延期とRoadmap例外を反映
```

Archive追補：

```text
docs: CoreProtect延期Commitを記録
```

検証：

```powershell
git diff --check
.\scripts\Test-Layout.ps1
git status --short
```

---

## 13. 完了条件

- CoreProtect導入指示書を削除していない
- Main／Lobby CoreProtectが延期状態
- Order 7がDeferred／Non-blocking
- Order 8が次のActive Task
- V0.1.0 BlockerからMain／Lobby CoreProtectを除外
- Owner単独運用前提を明記
- Hub／Gate構築を許可
- WorldGuard保護方針を明記
- WorldGuardがCoreProtect代替ではないと明記
- Backup／Schematic保全を明記
- Frontier CoreProtect方針を未決定のまま維持
- Runtime変更なし
- Final Main Baseline変更なし
- Plugin／Database／Permission変更なし
- Git検証成功

---

## 14. 完了後の正式状態

```text
Final Main Baseline:
  unchanged

Main CoreProtect:
  deferred
  non-blocking

Lobby CoreProtect:
  deferred
  non-blocking

Hub／Gate construction:
  permitted

Hub／Gate protection:
  WorldGuard required after construction

Next active Roadmap task:
  Order 8 Frontier lock

V0.1.0:
  incomplete
```
