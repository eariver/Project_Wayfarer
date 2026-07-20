# Deferred Design Items - Ver.0.0.4

This document is the source of truth for Project Wayfarer features that a custom Plugin could improve, but which Ver.0.0.4 deliberately leaves to operations, existing Plugins, or later design. “V0.1.0 impact” distinguishes an accepted Alpha compromise from a Release Blocker.

## Permission elevation

All five LuckPerms Group definitions are persistent. The temporary object is a Player Parent membership in `wayfarer_builder` or `wayfarer_admin`, not the Role Group itself. Existing `wayfarer_builder` is reused and reconfigured in place during Phase 1.

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Builder 2時間／Admin 30分を技術的に固定しない | LuckPerms Temporary Parent追加時に実行者が時間を指定し、標準値を運用手順で示す | 非Blocker。権限モデル自体の安全な実装はBlocker | 固定期限の専用昇格Command | 将来候補。V0.1.0では不要 | 権限運用で期限誤りが発生した時 |
| 専用の短い昇格／降格Commandがない | LuckPerms標準CommandとSelf-only Argument制限を使用 | 非Blocker | `/builder on`等を提供する外部独自管理Plugin | あると有用 | 操作負荷または設定保守が問題になった時 |
| 複数RoleへのTemporary Parent所属を技術的に禁止しない | 現在のTemporary Parentを自己解除してから別Roleへ所属する運用 | 非Blocker | Parent所属の状態機械と排他制御 | 厳密な強制には必要 | 複数管理者運用を開始する前 |
| Builder期限切れ時にCreative／Spectatorを自動Cleanupしない | 作業終了時にSurvivalへ戻し、安全地点へ移動してから自己降格する | 非Blocker。ただし手順遵守が必要 | Parent失効Eventを監視する管理Plugin | 自動化には必要 | 降格忘れまたは状態残留が発生した時 |
| 専用の監査UI／Role履歴表示がない | LuckPermsの履歴とServer Logを必要時に確認 | 非Blocker | 昇格理由、操作者、期限、降格結果を記録する管理UI | 高度な監査には必要 | 運用人数増加または監査要件発生時 |

## Resource reset bootstrap

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Reset後のReturn Gate構造復元方式が未選定 | 破壊的Resetを通常運用せず、後続タスクで方式を確定する | **Blocker**。復元設計と手順が必要 | User作成WorldEdit Schematic、追跡Template、Idempotent PowerShell／Command | 不要な方式を優先。必要なら将来候補 | Resource Bootstrap設計タスク |
| Gate／Portal定義の再設定が自動化されていない | Exact Worldと座標が決まるまで接続を行わない | **Blocker** | Advanced Portals定義、Script化、構造と設定の組合せ | 原則不要 | Gate Integration後、Reset手順確定時 |
| `resource_end`安全外周島拠点の復元方式が未選定 | Dragon exit portal／End gatewayに依存する導線を採用しない | **Blocker** | 安全地点Schematic、追跡Template、外周島検出を伴うBootstrap | 自動地点選定には候補 | Resource End安全拠点設計タスク |

## Frontier

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Theme別Inventoryがない | V0.1.0は通常のFrontier Inventoryを使用し、Theme固有ItemをMainへ持ち出す仕組みを設けない | 非Blocker | Theme ID別Inventory保存、境界移動時のAtomic切替 | 安全な実装には有力候補 | 2つ目のTheme検討前 |
| Theme初回装備配布がない | 選定Themeの標準導線または通常Inventoryで開始 | 非Blocker | Theme別Loadoutと一度限り配布状態 | 高度な制御には候補 | 初期Themeの難易度調整後 |
| WMによるTheme装備購入がない | V0.1.0ではFrontier WM報酬・装備Shopを作らない | 非Blocker | Waymark連携装備Shop、Theme別Allowlist | Custom Itemなら候補 | Frontier Economy設計時 |
| Theme実績Databaseがない | V0.1.0では実績を記録しない | 非Blocker | Theme ID／Achievement ID／UUID／進捗／達成日時／受取状態を保存し、Theme削除後も履歴を維持する契約 | 実績統合には必要になる可能性 | 初期Theme評価後 |
| Main側実績報酬受取がない | 報酬導線を公開しない | 非Blocker | 一度だけ受取可能なNetwork報酬Service | Cross-server整合性には有力候補 | Theme実績設計と同時 |
| Frontier Gate Utilityがない | 最低限のHub、案内、往復GateだけをV0.1.0対象とする | 非Blocker | Storage、回復、Buff、Theme選択、WM Shop、実績表示 | 多くは既成Pluginでも可能 | Playable Theme運用後 |

## Main

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Main Hubと各地を結ぶTeleport Systemがない | 徒歩、Vanilla移動、将来の公共Gateを使用 | 非Blocker | 無償／WM消費、Unlock、Cooldown、個人／公共Waypoint、安全地点検証 | 高度な個人Waypointには候補 | Main拠点が広がった時 |
| WMを消費する高度なUtilityがない | 初期Waymark Shopを主要な利用先とする | 非Blocker | Teleport、Storage拡張、Convenience、Cosmetic | 機能ごとに判断 | Waymark供給量の観測後 |
| Over-enchanted Tool等の特殊商品がない | バニラに近いMain進行を優先 | 非Blocker | Plugin／外部独自PluginのItem契約と保守的価格 | Custom Itemなら必要になる可能性 | V0.1.0運用データ取得後 |

## Review rule

Deferred items do not become implemented merely because they are documented here. Every adoption requires a separately approved task with its own data boundary, artifact policy, implementation scope, and proportionate verification. Resource Bootstrap items remain V0.1.0 Blockers; the other entries are accepted Alpha limitations unless the Roadmap is explicitly revised.
