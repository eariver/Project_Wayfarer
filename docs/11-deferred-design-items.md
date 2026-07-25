# Deferred Design Items - Ver.0.0.6

This document is the source of truth for Project Wayfarer features that Ver.0.0.6 deliberately leaves to operations, existing Plugins, or later design. “V0.1.0 impact” distinguishes an accepted Alpha compromise from a Release Blocker.

## Permission elevation

Phase 1A implemented all five persistent LuckPerms Group definitions. The temporary object is a Player Parent membership in `wayfarer_builder` or `wayfarer_admin`, not the Role Group itself. Existing `wayfarer_builder` was reused and reduced to an empty Role container while its WorldGuard Region membership remained intact. The exact Runtime model is documented in [Permission Model](12-permission-model.md).

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Builder 2時間／Admin 30分を技術的に固定しない | LuckPerms Temporary Parent追加時に実行者が時間を指定し、標準値を運用手順で示す | 非Blocker。権限モデル自体の安全な実装はBlocker | 固定期限の専用昇格Command | 将来候補。V0.1.0では不要 | 権限運用で期限誤りが発生した時 |
| 専用の短い昇格／降格Commandがない | LuckPerms標準CommandとSelf-only Argument制限を使用 | 非Blocker | `/builder on`等を提供する外部独自管理Plugin | あると有用 | 操作負荷または設定保守が問題になった時 |
| 複数RoleへのTemporary Parent所属を技術的に禁止しない | 現在のTemporary Parentを自己解除してから別Roleへ所属する運用 | 非Blocker | Parent所属の状態機械と排他制御 | 厳密な強制には必要 | 複数管理者運用を開始する前 |
| Builder期限切れ時にCreative／Spectatorを自動Cleanupしない | 作業終了時にSurvivalへ戻し、安全地点へ移動してから自己降格する | 非Blocker。ただし手順遵守が必要 | Parent失効Eventを監視する管理Plugin | 自動化には必要 | 降格忘れまたは状態残留が発生した時 |
| 専用の監査UI／Role履歴表示がない | LuckPermsの履歴とServer Logを必要時に確認 | 非Blocker | 昇格理由、操作者、期限、降格結果を記録する管理UI | 高度な監査には必要 | 運用人数増加または監査要件発生時 |
| Builder最終Allowlistが未実装 | Phase 1Aでは保護Entry WorldのRegion Member建築だけを維持し、管理Commandを付与しない | **Blocker**。BuilderによるHub／Gate／Theme接続作業前にPhase 1Bが必要 | 採用Versionと実作業から作る明示的Command Allowlist | 不要 | 両Frontier Theme、Gate方式、MVI、Resource PackおよびBuilder担当作業の確定後 |

## Resource reset bootstrap

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Reset後のReturn Gate構造復元方式が未選定 | 破壊的Resetを通常運用せず、後続タスクで方式を確定する | **Blocker**。復元設計と手順が必要 | User作成WorldEdit Schematic、追跡Template、Idempotent PowerShell／Command | 不要な方式を優先。必要なら将来候補 | Resource Bootstrap設計タスク |
| Gate／Portal定義の再設定が自動化されていない | Exact Worldと座標が決まるまで接続を行わない | **Blocker** | Advanced Portals定義、Script化、構造と設定の組合せ | 原則不要 | Gate Integration後、Reset手順確定時 |
| `resource_end`安全外周島拠点の復元方式が未選定 | Dragon exit portal／End gatewayに依存する導線を採用しない | **Blocker** | 安全地点Schematic、追跡Template、外周島検出を伴うBootstrap | 自動地点選定には候補 | Resource End安全拠点設計タスク |

## Frontier

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| MVI正式Versionと共有Player Stateが未Lock | Concept上の`neutral`／`worlds_beyond`／`guild`境界だけを正本化し、Runtime Configを作らない | **Blocker**。通常Player Stateの正本と移動経路試験が必要 | 採用MVI VersionのGroup／Share Config | 原則不要 | Frontier共通基盤Task |
| EM InstanceのMVI方式が未確定 | 静的登録、厳密Regex、必要時Adapterの順で評価 | **Blocker**。Adapter必要性判断が必要 | MVI Config、必要性が立証された場合だけ独立Artifact `Wayfarer_Frontier_EliteMobsMVI` | 条件付き | EliteMobs Artifact／Instance命名確認後 |
| Worlds Beyond Traversal詳細が未Lock | Elytra、LeafGrapple、Loadout、Launchpadを正式Scopeとし、Artifact／Item契約は未実装 | **Blocker** | Wayfarer_Frontier＋採用LeafGrapple Adapter | 必要 | Worlds Beyond実装Task |
| Ruined Frontier WM報酬Balanceが未Lock | 初期alphaはBoss／Quest報酬を自動導入しない | 非Blocker。Theme本体はBlocker | Vault／Waymark Adapter経由の冪等Reward | 必要 | 実プレイBalance評価後 |
| Theme装備のWM売却変換がない | Theme ItemをWMへ変換せず、Item境界を維持 | 非Blocker | 独立したAllowlist／価格／監査設計 | 必要性を再評価 | Frontier Economy再設計時 |
| Item非依存実績が未実装 | V0.1.0共有候補をTitle、Permission、GUI、Record、Cosmetic、WM等へ限定 | 非Blocker | Wayfarer_Core／Frontierの実績Contract | 将来候補 | 両Theme安定後 |
| Main側実績報酬受取がない | 報酬導線を公開しない | 非Blocker | 一度だけ受取可能なItem非依存Network報酬Service | Cross-server整合性には有力候補 | Theme実績設計と同時 |
| 追加Frontier Gate Utilityがない | Beyond／Guild Gateと安全帰還を優先 | 非Blocker | Storage、回復、Buff、実績表示 | 多くは既成Pluginでも可能 | 両Theme運用後 |

## EvenMoreFish balance

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Fish購入機能がない | `/emf shop`はCatch済みFishの売却専用とし、Server販売を行わない | 非Blocker | 需要と入手経路を観測した別の承認済みShop | 原則不要 | V0.1.0運用量の観測後 |
| Competitionを実施しない | Scheduled／Manual Competitionをすべて無効化 | 非Blocker | 小規模運用に必要になった場合だけ報酬を含め再設計 | 不要 | 参加人数増加時 |
| AFK Fishing統合方針が未確定 | EvenMoreFish側AFK保護を有効化せず、mcMMOの現行挙動を変更しない | 非Blocker | 実際の濫用が生じた場合に両Pluginの競合をFocused Test | 不要 | 運用上の問題発生時 |
| Bait購入手段がない | CatchしたBaitの適用だけ許可し、購入は提供しない | 非Blocker | Waymark供給量とBait価値を評価した限定Shop | 不要 | Economy再設計時 |
| DynamicなFish価格調整がない | Size×固定Rarity倍率×Vault 1.0を使用 | 非Blocker | Catch量とインフレを観測後に固定倍率を再審査 | 不要 | V0.1.0運用量の観測後 |

Custom Fishingの現行World Scopeは`main`／`resource`だけです。Nether、End、Unknown Worldへの拡張はConfig変更とFocused Testを伴う後続課題です。

## V0.1.0 pre-release reset scope

All Waymark balances, Main inventory, armor/offhand, Vanilla XP, and advancements remain the minimum separately approved reset scope immediately before the final baseline backup. Growth Tool logical records are explicitly undecided between Reset and Preserve and require separate Owner approval. Frontier／MVI Profiles, Theme Loadout state, other custom-Plugin records, Ender Chest, health/hunger, position, bed spawn, statistics, recipe book, mcMMO, EvenMoreFish Journal, LuckPerms history, transaction history, and Resource-world positions require an exact owner-aware decision before reset. None is reset by this documentation revision.

## Main

| 課題 | 現在の妥協策 | V0.1.0への影響 | 将来の解決候補 | 独自Pluginが必要か | 再検討時期 |
|---|---|---|---|---|---|
| Main Hubと各地を結ぶTeleport Systemがない | 徒歩、Vanilla移動、将来の公共Gateを使用 | 非Blocker | 無償／WM消費、Unlock、Cooldown、個人／公共Waypoint、安全地点検証 | 高度な個人Waypointには候補 | Main拠点が広がった時 |
| WMを消費する高度なUtilityがない | 初期Waymark Shopを主要な利用先とする | 非Blocker | Teleport、Storage拡張、Convenience、Cosmetic | 機能ごとに判断 | Waymark供給量の観測後 |
| Over-enchanted Tool等の特殊商品がない | バニラに近いMain進行を優先 | 非Blocker | Plugin／外部独自PluginのItem契約と保守的価格 | Custom Itemなら必要になる可能性 | V0.1.0運用データ取得後 |

## Main Spawn protection

Main Spawn protection is designed but not implemented. The user first completes the initial Hub footprint and equipment layout; a separate approved task then fixes the exact WorldGuard Region and child-region boundaries.

| 課題 | 現在の方針 | V0.1.0影響 | 解決候補 | 再検討時期 |
|---|---|---|---|---|
| Main Spawn保護Region未設定 | ユーザーが初期Hubを概ね整備するまでWorldGuard Regionを作らない | **Blocker**。公開前に保護が必要 | `main_spawn_hub` Membership保護、`use allow`、設備別の限定子Region | Hub整備完了後 |
| Vanilla Spawn Protectionとの二重管理 | 現在`spawn-protection=16`を維持 | Region実装までは許容 | WorldGuardの一般／Builder／Admin境界を検証後、別タスクで0へ統一 | Main Spawn保護タスク |

The outer Region must not use a `build` flag or broad `interact allow`／`chest-access allow`. Environmental deny flags and any child Region are candidates until their exact WorldGuard 7.0.17 names, equipment scope, priority, and acceptance tests are approved.

## Historical V0.2.x custom-Plugin concept

The historical proposals in `codex/Project_Wayfarer_V0.2x_Custom_Plugin_Concept.md` remain a reference draft unless explicitly promoted into current formal documentation. Ver.0.0.6 separately promotes Wayfarer_Core, Wayfarer_Main／Growth Pickaxe, and Wayfarer_Frontier responsibilities as V0.1.0 Blockers, but the historical Concept itself does not authorize external Multi-module Repository creation, development, migration, or artifact work. Every such action still requires a dedicated approved design and task.

## Review rule

Deferred items do not become implemented merely because they are documented here. Every adoption requires a separately approved task with its own data boundary, artifact policy, implementation scope, and proportionate verification. Rows explicitly marked Blocker and Resource Bootstrap remain V0.1.0 Blockers; other entries are accepted Alpha limitations unless the Roadmap is formally revised.
