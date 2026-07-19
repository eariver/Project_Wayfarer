# 外部拡張Plugin

## 1. Project Wayfarer本体の責務

Project Wayfarer本体は、Minecraftサーバネットワークの構成、Config、導入・運用Script、設計文書および運用手順を管理します。外部拡張Pluginとの接続が必要な場合、このリポジトリには依存Version、導入手順、接続仕様、Config例および未導入時の代替動作だけを記録します。

このリポジトリでは独自PluginのSourceを設計、実装、Build、TestまたはReleaseしません。

## 2. 外部拡張リポジトリの責務

独自Pluginが必要になった場合は、Pluginごとに別のリポジトリを作成し、Source、Build定義、Test、Release、Plugin固有のIssueおよび変更履歴を管理します。Project Wayfarerとの互換性は、公開されたPluginのVersionと本リポジトリ側の接続仕様を組み合わせて確認します。

外部拡張リポジトリのURLは、実際にリポジトリが作成されるまで記載しません。

## 3. 分離する理由

- サーバ構成とPlugin実装のRelease周期を分離するため
- Plugin単体のLicense、配布物、依存関係および脆弱性対応を明確にするため
- Project WayfarerをJARやBuild成果物を含まない公開可能な構成リポジトリに保つため
- Pluginを利用しない構成でも、サーバ本体の導入と運用を継続できるようにするため

## 4. 外部Pluginの導入手順

外部Pluginを採用するときは、次の順序で記録・検証します。

1. 公式配布元、Licenseおよび対象Minecraft／Paper／Velocity／Java Versionを確認する。
2. 対応する外部PluginのRelease Versionと配布物の検証方法を記録する。
3. 導入先Server、依存Plugin、権限、Network Port、DatabaseおよびRedisの利用範囲を明記する。
4. 配布物は利用者が公式配布元から取得し、指定されたローカルのPlugin配置先へ置く。
5. 正確なPlugin Versionを一度起動し、生成されたConfigと公式文書を確認してからConfigを編集する。
6. 接続仕様、Data境界、権限、失敗時の挙動およびRollback手順を検証する。

## 5. Version互換性の記録

外部Pluginを導入した場合は、少なくとも次を本リポジトリの互換性資料へ記録します。

- 外部Plugin名と正確なRelease Version
- Minecraft、PaperまたはVelocity、およびJavaの対象Version
- Project Wayfarer側で要求する接続仕様の改訂
- 必須・任意の依存PluginとそのVersion
- 導入先ServerとConfigファイル
- 検証日、検証結果、既知の制限およびRollback条件

Version範囲を推測せず、実際に確認した組み合わせを記録します。

## 6. 配布物の原則

外部PluginのJAR、Source、Build成果物および外部リポジトリそのものをProject WayfarerへCommitしません。Git submoduleとして追加する場合も、事前の明示的な承認を必要とします。

## 7. 未導入時の機能縮退

外部拡張Pluginが未導入または互換性未確認の場合、対象機能は無効として扱います。Main、Frontier、Lobbyの基本的な起動、接続および通常Inventoryの分離を未導入の外部拡張へ依存させません。Waymark共有残高とmcMMO共有進行は導入済みですが、独自Plugin Sourceではなく外部PluginのIntegrationとして扱います。GUI、Command、Portalまたは権限から未実装機能へ到達できない構成にします。

## 8. 未実装の外部拡張候補

次の機能は概念設計上の候補であり、現時点では実装されていません。

### 越境保管庫

- MainとFrontierの間で明示的な共有GUIを提供する。
- Waymarkや実績でSlotを解放する。
- Vanilla／共通Itemだけを初期許可し、互換性のないPDC、Custom Model Dataおよび危険なContainerを拒否する。
- MariaDB Lock、冪等なTransaction ID、監査Logおよび未完了処理のRecoveryを要求する。

### 遠征装備

- Main由来で認証された装備だけをFrontierへ持ち出し、Mainへ戻せるようにする。
- Network内で一意なItem IDとLifecycle Stateを持たせる。
- MainとFrontierで同一のRuntime PluginおよびItem定義を要求する。
- 非対応の変更は拒否または隔離する。

### 実績共有

- Frontier側でNetwork実績を記録する。
- Main側は実績を参照し、記念Item、Recipe、施設またはUnlockへ反映する。
- 互換性のないFrontier Itemを直接転送しない。

### その他の候補

- Frontier内のField BagおよびCamp Storage
- 条件付き商品Tableと監査機能を持つShop
- Tutorial、AFK判定、Lobbyへの安全な転送、計画Maintenance時のDrain

これらを採用する際は、API、Data所有権、認可、監査、障害回復およびSecurity境界を別途設計し、独立した外部リポジトリで実装・Releaseします。
