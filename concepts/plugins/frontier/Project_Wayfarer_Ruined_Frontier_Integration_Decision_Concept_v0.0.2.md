# Project Wayfarer Ruined Frontier Integration Decision Concept v0.0.2

> **状態:** Under Review  
> **保存先:** Project Wayfarer Repository `concepts/plugins/frontier/`  
> **関連Concept:** `../Project_Wayfarer_Plugin_Concept_v0.0.3.md`  
> **関連Theme Concept:** `concepts/frontier/Ruined_Frontier_Specification_V0.0.5.md`
> **対象:** EliteMobs Instance WorldとMultiverse-Inventories Guild Groupの連携方式  
> **実装状態:** 調査・判断前

---

## 1. 目的

本Conceptは、Ruined FrontierでEliteMobsのDungeon／Instance WorldをMultiverse-Inventoriesの`guild` Groupへ安全に含める方法を選定するDecision Gateを定義する。

目的はAdapterを作ることではない。

次の順序で、最も単純で安全な方式を選ぶ。

```text
1. 固定Worldの静的MVI登録
2. 承認済みBlueprint名＋連番に限定した厳密Regex
3. 前二者で安全に成立しない場合だけEliteMobs–MVI Adapter
```

ConceptにAdapter名が存在することだけを理由に実装してはならない。

---

## 2. 背景

Ruined Frontierの`guild` Groupは、概念上次を共有する。

- Adventurer's Guild
- Primis
- Ruined Frontier Overworld
- Ruined Frontier Nether
- Ruined Frontier End
- 承認済み固定Dungeon
- 安全性を確認したEliteMobs Instance

通常Player Stateの正本はMVIである。

`Wayfarer_Frontier`またはAdapterは、Inventory保存・復元やProfile切替を再実装しない。

EliteMobs Instanceの生成、Gameplay、終了、Player退出およびWorld削除はEliteMobs／Content Package Lifecycleを正とする。

---

## 3. Decision原則

- 最小権限
- 最小Code
- 最小Version依存
- Fail-closed
- 明示Allowlist
- 正確なWorld Identity
- Restart／Reconnect耐性
- 同時Instance耐性
- 削除後の残留防止
- MVI通常処理の再実装禁止
- EliteMobs内部Database／Config直接変更禁止

静的登録またはRegexで要件を満たす場合、Adapterを採用しない。

---

## 4. 調査対象

実装前調査でLockする。

### EliteMobs

- 採用Version
- Paper 1.21.11／Java 25互換性
- 採用Content Package
- 固定World／Clone／Temporary Instanceの区別
- Blueprint ID
- Runtime World名
- 同時Instance命名
- 作成Event
- Load完了Event
- 終了Event
- World削除Event
- Restart時の復元
- Disconnect／Reconnect
- Instance終了時のPlayer移動
- API安定性
- License／Artifact Hash

### Multiverse-Inventories

- 採用Version
- Groupへの固定World登録
- World名Pattern／Regex対応
- Regex適用Timing
- Runtime Group再読込
- 動的追加・解除API
- World削除後の扱い
- Profile切替Timing
- Restart時のGroup復元
- Unsupported World時のFail動作
- API安定性

### Project環境

- 正確なBukkit World名
- `guild` Group Config
- Gate／Portal／Respawn導線
- Frontier Lobby／Worlds Beyondとの分離
- Backup／Restore
- Admin Teleportの制限
- Test Player DataのReset範囲

---

## 5. Option A: 固定World静的登録

採用条件:

- EliteMobs Contentが固定Worldとして導入される。
- World名が導入時に確定する。
- MVI Configへ静的登録できる。
- Restart後も同一Worldとして扱われる。
- World削除／再生成が通常Lifecycleではない。

評価:

- 最も単純
- Custom Code不要
- MVI Configが正本
- Version依存が最小

固定Worldで要件を満たす場合はOption Aを採用し、Decisionを終了する。

---

## 6. Option B: 厳密Regex

採用条件:

- Instance World名が安定した命名規則を持つ。
- 承認済みBlueprint IDを識別できる。
- 連番またはInstance UUID部分を安全に限定できる。
- 未承認WorldへPatternが一致しない。
- MVIがWorld作成後にPatternを正しく適用する。
- World削除後に不正なProfile残留を起こさない。
- 同時Instanceでも衝突しない。

Regex原則:

```text
^<approved-blueprint-prefix>-<strict-instance-suffix>$
```

禁止:

- `.*`
- Frontier全Worldへ一致するPattern
- Blueprintを区別しないPrefix
- Case／Separatorが曖昧なPattern
- 将来の未知Worldを自動採用するPattern

Regexで安全に成立する場合はOption Bを採用し、Adapterを実装しない。

---

## 7. Option C: EliteMobs–MVI Adapter

Option A／Bが不十分であることをEvidenceで示した場合だけ採用する。

採用理由の例:

- Runtime World名が安全なRegexで表現できない。
- Instance生成後にMVIへ明示登録が必要。
- Instance終了時にGroup解除が必要。
- Restart時に残留登録を再構築する必要がある。
- MVIのPattern適用TimingがInstance Lifecycleに間に合わない。

「Adapterの方が柔軟そう」という理由だけでは採用しない。

---

## 8. Adapterの限定責務

採用時の責務:

- EliteMobsの承認済みInstance生成通知を受ける。
- Blueprint／Package／World名をAllowlist検証する。
- World Load完了を確認する。
- MVI `guild` Groupへ追加する。
- Instance終了／World削除後に解除する。
- Restart時に承認済みActive Instanceを再検査する。
- 残留登録を検出する。
- Audit／Reconcileする。

担当しない:

- Instance World作成
- World Clone
- EliteMobs Enable
- Dungeon Gameplay
- Boss／Loot／Quest
- Player退出先
- Respawn
- Inventory保存／復元
- MVI Profile実装
- EliteMobs内部Config変更
- EliteMobs Database更新
- Content Package書換え
- World削除

---

## 9. Allowlist

AdapterまたはRegexは、承認済みContentだけを対象とする。

概念Field:

```text
content_package_id
blueprint_id
world_name_pattern
mvi_group_id
enabled
schema_revision
```

未知Package、未知Blueprint、未知World名はFail-closedする。

単に`frontier`、`dungeon`、`instance`等を含むことだけでは承認しない。

---

## 10. Lifecycle

検証対象Lifecycle:

```text
Instance Request
→ World Create／Clone
→ World Load
→ EliteMobs Enable
→ MVI Group Membership成立
→ Player Entry
→ Gameplay
→ Player Exit
→ Instance Complete／Abort
→ World Unload
→ World Delete
→ MVI Membership解除
```

各段階で、次を確認する。

- Playerが正しいGuild Profileを使用する。
- Frontier Lobby Profileが混入しない。
- Worlds Beyond Profileが混入しない。
- Main Itemが存在しない。
- Instance削除後にGroup登録が残らない。
- 再接続後に古いProfileを上書きしない。

---

## 11. Restart／Failure

### 11.1 全Option共通

- InstanceなしでRestart
- Active Instance中にRestart
- Instance作成直後にRestart
- Player滞在中にDisconnect
- Player滞在中にBackend停止
- World Unload失敗
- World Delete失敗
- 同時複数Instance
- 同一Blueprint複数Instance
- World名衝突
- 不正World名
- Frontier Lobby／Worlds BeyondとのMVI Profile分離
- Main BackendとのBackend／Network境界によるItemおよびPlayer State非共有
- World削除後のMembership残留

### 11.2 `STRICT_REGEX`採用時

- 承認済みBlueprint名だけが一致
- 未承認Blueprintが不一致
- 連番／UUID境界
- Case／Separator境界
- 同時Instance命名
- Restart後のPattern適用
- 将来の未知Worldを自動採用しない

### 11.3 `ADAPTER_REQUIRED`採用時

- MVI API失敗
- EliteMobs API／Event失敗
- Event重複
- Event欠落
- Adapter Disable／Enable
- Unsupported Version
- Restart時Reconcile
- 残留登録の検出・解除

不確実なMembershipでPlayerをInstanceへ入場させない。

---

## 12. Decision Evidence

Decision Reportに含める。

- EliteMobs Version／Hash
- MVI Version／Hash
- Content Package／Blueprint
- World名Sample
- 固定／Clone／Temporary分類
- MVI Config／Regex能力
- API／Event確認結果
- Test Case
- Expected／Actual
- Log／Screenshot／Config Evidence
- Restart／Reconnect結果
- 同時Instance結果
- Data Leak確認
- 採用Option
- 不採用Optionと理由
- Known Limitation
- Rollback

---

## 13. Decision結果

結果は次のいずれかとする。

### `STATIC_REGISTRATION`

- Adapter不要
- 対象WorldをMVI Configへ固定登録
- Plugin RepositoryへAdapter Moduleを作成しない

### `STRICT_REGEX`

- Adapter不要
- 承認済みPatternをMVI Configへ登録
- Pattern TestをProject Acceptanceへ追加

### `ADAPTER_REQUIRED`

- Evidenceにより前二者が不十分
- Plugin Repositoryの実装作業指示書兼設計仕様書へ限定Adapterを追加
- Adapter ArtifactをFrontierだけへ配置

### `BLOCKED`

- 外部Plugin仕様が確認できない
- 安全な連携方式を選べない
- Ruined Frontier Instance導入を進めない

---

## 14. Acceptance

Optionに関係なく満たす。

- Guild Profileを使用
- Frontier Lobby Profileと分離
- Worlds Beyond Profileと分離
- MainとItem共有なし
- Instance終了後の正常退出
- Restart／ReconnectでData Lossなし
- Duplicationなし
- Stale Profile Overwriteなし
- World削除後の残留なし
- 未承認WorldをGuild Groupへ追加しない
- Admin Shortcutを一般Playerへ付与しない

Adapter採用時追加:

- Event重複で二重登録なし
- 削除Event重複でErrorなし
- Event欠落をReconcileで検出
- Unsupported Versionで起動拒否
- Adapter停止時に不安全な入場を許可しない

---

## 15. Conceptと実装仕様書の境界

本ConceptはDecision Procedureを定義する。

次は調査完了後、採用Optionに応じて別文書へ置く。

### Project Wayfarer Repository

- Decision Report
- 採用Config
- Version／Hash
- Runtime配置
- Acceptance Test
- 運用／Rollback

### Plugin Repository

`ADAPTER_REQUIRED`の場合だけ:

- Adapter実装作業指示書兼設計仕様書
- Source
- API Adapter
- Unit／Integration Test
- Release Artifact
- Plugin固有運用文書

---

## 16. 次の状態への移行条件

本Conceptにおける`Approved for Task Design`は、**Decision Investigation TaskとDecision Report作成の設計を開始してよい状態**を意味する。Adapter実装承認ではない。

本Conceptを`Approved for Task Design`へ移す条件:

- Decision Procedureの内容をProject Ownerが確認
- 調査対象が不足していない
- Adapterを先行実装しない方針に合意

Adapter Implementation TaskとPlugin Repository内Adapter実装作業指示書の作成は、Decision Reportが`ADAPTER_REQUIRED`となった後にだけ開始する。`STATIC_REGISTRATION`または`STRICT_REGEX`の場合はAdapter Moduleを作成しない。

---

## 17. v0.0.2結論

Ruined FrontierのEliteMobs InstanceとMVIの連携は、静的登録、厳密Regex、Adapterの順に評価する。

Adapterは既定解ではない。

`Approved for Task Design`で最初に許可されるのはDecision Investigation Taskであり、Adapter実装ではない。

通常Inventory管理、Instance LifecycleおよびEliteMobs Gameplayは既製Pluginへ委譲し、独自Adapterは必要性が証明された場合にだけ、MVI Group Membershipの追加・解除へ責務を限定する。

---

## 18. Revision History

| Version | 概要 |
|---|---|
| v0.0.1 | 静的登録→厳密Regex→AdapterのDecision Procedureを定義 |
| v0.0.2 | Restart／Failure試験をOption別に分離し、Task DesignとAdapter実装承認を明確に区別 |
