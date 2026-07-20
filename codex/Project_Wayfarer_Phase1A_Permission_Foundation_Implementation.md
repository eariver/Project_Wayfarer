# Project Wayfarer Phase 1A 権限基盤・一時昇格モデル実装 指示書

## 1. 目的

Project Wayfarer Ver.0.0.4の権限設計について、現時点で必要な基盤だけを先行実装する。

今回実装するもの：

- 5つのLuckPerms Group定義
- Builder／Adminへの自己限定Temporary Parent昇格
- Builder資格とAdmin資格の分離
- Adminの全権限
- 恒久OP依存の廃止
- 既存`wayfarer_builder` GroupとWorldGuard Region Member参照の維持
- 現在`wayfarer_builder`へ付与されている暫定管理権限の除去
- 権限基盤の運用・復旧手順
- Roadmap上のPhase 1A／Phase 1B分離

今回実装しないもの：

- Builderの最終Allowlist
- Builder向けWorldEdit権限
- Builder向けMultiverse権限
- Builder向けGamemode権限
- Builder向けTeleport権限
- Builder向けAdvanced Portals権限
- Builder向けFrontier Theme固有権限
- 専用の短縮昇格Command
- 固定された昇格時間
- 降格時のGamemode自動Cleanup
- 独自Plugin
- Plugin JARの追加・変更
- World／Portal／Gateの変更

Builder Roleは今回、**将来のAllowlistを受け入れるための空のRole Container**として整備する。

ただしLobbyおよび`frontier_gate`のWorldGuard Region Memberとしての既存参照は維持し、Builder所属中のPlayerが保護Entry Worldで通常建築できる既存構造を残す。

本タスクはPermission／Security Boundaryの変更であるため、権限境界だけを詳細確認する。無関係なPlugin機能、Economy、mcMMO、TAB等の広範な回帰試験は実施しない。

十分な実装、検証、Cleanup、文書更新が完了した場合はCommitし、remoteへPushする。

---

## 2. 作業基準

最新の`main`を取得し、少なくとも次のCommitを含むことを確認する。

```text
767921630332b38052650fd55fa4df4e6b218ce3
docs: Ver.0.0.4の権限・停止運用表現を補正
```

開始前に確認する。

```powershell
git status --short
git branch --show-current
git rev-parse HEAD
git fetch
git status -sb
```

確認対象：

- Current Branch
- HEAD
- remoteとの差分
- 未Commit変更
- 未追跡ファイル
- 他者の作業
- 現在のRuntime起動状態
- MariaDB／LuckPermsの接続状態
- 全LuckPerms InstanceのVersion
- 現在のOP状態
- 現在のGroup、Parent、Permission、Context、Meta
- Lobby／FrontierのWorldGuard Region Member

既存変更を破棄しない。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- LuckPerms SQL Tableの直接編集
- MariaDBへの手動`UPDATE`／`DELETE`
- LuckPerms Web EditorのReplace Import
- 既存`wayfarer_builder`の削除・再作成
- WorldGuard Region Member参照の削除
- 恒久OPの維持
- Player名／UUIDのRepository記録
- Plugin JARの変更
- World、Portal、Gateの変更
- Builder最終Allowlistの先行実装
- 広いPermissionでの暫定回避
- 無関係なRegression Test

---

## 3. Phase 1AとPhase 1Bの分離

### 3.1 Phase 1A：今回実装

Phase 1Aは権限基盤とAdmin運用を完成させる。

- Group定義
- Eligibility
- Self-only Temporary Parent
- Admin Full Access
- OP廃止
- Builder Role Container
- 既存Builder管理権限の除去
- 権限境界試験
- 文書化

### 3.2 Phase 1B：後続実装

Builderの最終Allowlistは、次が確定した後に別タスクとして実装する。

- Advanced Portalsの採用VersionとPermission体系
- 最初のPlayable Frontier Theme
- Theme導入Pluginと管理Command
- Hub／Gate構築時にBuilderが行う作業
- MultiverseでBuilderへ必要な具体的Command
- WorldEdit／Gamemode／Teleportの実際の運用範囲

Phase 1Bの実施時期は、V0.1.0直前ではなく、**BuilderによるHub／Gate／Theme接続作業を開始する前**とする。

Phase 1Bで検討する候補：

- WorldEdit：Lobby／Main／Frontier
- Creative／Survival／Spectator：全Paper
- Teleport：全Paper
- Multiverse-Core：必要Commandのみ
- Multiverse-NetherPortals：Mainのみ
- Advanced Portals：Gate編集に必要なCommandのみ
- Frontier Theme Plugin：必要な場合だけ

Phase 1Bでも原則として除外する。

- WorldGuard Region管理
- LuckPerms管理
- Economy管理
- Player処分
- Server停止
- Plugin Reload／Unload
- Debug／Internal管理
- World削除／Clone／再生成／Purge／Import／Unload
- Velocity管理
- 無制限Wildcard

---

## 4. 事前BackupとRollback

Permission変更前に`wayfarer_luckperms`のMariaDB Dumpを作成する。

保存先例：

```text
backups/pre-phase1a-permission-model-YYYYMMDD-HHMMSS/
```

最低限記録する。

- Dump Filename
- SHA-256
- 作成日時
- Database名
- 作業開始時HEAD

Backup、Dump、CredentialをGitへCommitしない。

Rollback方針：

1. Bootstrap用ConsoleまたはProcess Accessを、Admin自己昇格の検証完了まで維持する。
2. LuckPerms変更は可能な限りLuckPerms正式Commandで戻す。
3. 自己昇格不能、Admin権限不足、Permission Lockout発生時はConsoleから修復する。
4. SQLを直接編集して応急処置しない。
5. 広範な誤変更またはDatabase破損時だけ、Serverを正常停止し、事前Dumpから隔離Restoreを検討する。
6. Blockingな失敗時は中途半端な権限モデルを残さず、変更前状態へ戻す。

---

## 5. LuckPerms Config

## 5.1 Argument-based Command Permissions

Velocity、Lobby、Main、Frontierの全LuckPerms Instanceで次を明示的に有効化する。

```yaml
argument-based-command-permissions: true
```

対象Template：

- Velocity LuckPerms Sanitized Config Template
- Lobby LuckPerms Sanitized Config Template
- Main LuckPerms Sanitized Config Template
- Frontier LuckPerms Sanitized Config Template

採用中LuckPerms 5.5.60が生成したConfig構造と、実Runtime Metadataを確認して正しい位置へ設定する。

Runtime Configは既存Render手順で生成する。

可能であればRenderer Validationへ次を追加する。

- 全4 Instanceで`argument-based-command-permissions: true`
- 各Instanceの正しい`server`値
- Credential Placeholder残留なし
- Runtime ConfigがGit Ignore対象

既存Rendererを不必要に全面改修しない。

## 5.2 OP依存の廃止

全Paper BackendのLuckPerms Configで、OPを通常運用から無効化する。

採用方針：

```yaml
enable-ops: false
auto-op: false
commands-allow-op: false
```

目的：

- RoleなしPlayerは通常権限だけを持つ。
- Temporary Admin Parentだけで管理権限を得る。
- Admin Parent失効後にOP状態が残らない。
- `/op`／`/deop`へ依存しない。

VelocityにはBukkit OP設定を追加しない。

現在OPのPlayerが存在する場合：

1. Admin自己昇格を先に確認する。
2. Admin Roleで必要な管理権限を確認する。
3. その後にOPを除去する。
4. 全PaperでOPが残っていないことを確認する。

`luckperms.autoop`は使用しない。

---

## 6. Group定義

以下の5 Group定義はすべて恒久的に存在する。

| Group | 今回の扱い |
|---|---|
| `default` | 既存を監査・維持 |
| `wayfarer_builder_eligible` | 未存在なら作成 |
| `wayfarer_admin_eligible` | 未存在なら作成 |
| `wayfarer_builder` | 既存を監査・再利用 |
| `wayfarer_admin` | 未存在なら作成 |

既に存在するGroupは削除・置換せず、Parent、Permission、Context、Metaを監査する。

### 6.1 Inheritance

原則として次を設定する。

- `wayfarer_builder_eligible` -> `default`
- `wayfarer_admin_eligible` -> `default`
- `wayfarer_builder` -> `default`
- `wayfarer_admin` -> `default`

Primary Groupは変更しない。

Eligibility保持Playerも通常Primary Groupは`default`のままとする。

Group Weight、Prefix、Suffix、Trackは今回導入しない。

既存Metaがある場合は勝手に削除せず報告する。

---

## 7. 自己昇格の実行場所

自己昇格／自己降格はVelocity上のLuckPerms Commandへ集約する。

使用Alias：

```text
/lpv
```

理由：

- Network内のどのBackendにいても同じ入口を利用できる。
- Eligibility用Permissionを`server=velocity` Contextへ限定できる。
- Paper側の`/lp`をEligibilityへ開放しない。
- 共有MariaDB／SQL MessagingによりGlobal Temporary Parentを各Backendへ反映できる。

想定操作例：

```text
/lpv user <自分のPlayer名> parent addtemp wayfarer_builder 2h deny
/lpv user <自分のPlayer名> parent removetemp wayfarer_builder

/lpv user <自分のPlayer名> parent addtemp wayfarer_admin 30m deny
/lpv user <自分のPlayer名> parent removetemp wayfarer_admin
```

実際のSyntax、Temporary Modifier、`deny`動作はLuckPerms 5.5.60で確認する。

Player名をRepositoryへ固定しない。

---

## 8. Eligibility Permission

## 8.1 共通原則

Eligibility GroupはGameplay上`default`相当とする。

許可するのは次だけ。

- 自分自身の必要最小限のParent情報確認
- 自分自身への対応Role Temporary Parent追加
- 自分自身からの対応Role Temporary Parent解除
- 必要なGlobal Context利用
- Velocity上で上記Commandを実行するために必要なPermission

許可しない。

- 他Playerの変更
- Group Dataの変更
- Permission Set／Unset
- Permanent Parent Add／Remove／Set
- Parent Clear
- Track操作
- 任意GroupへのTemporary Parent
- Editor
- Import／Export
- Bulk Update
- Group作成／削除
- 任意Context指定
- Paper側LuckPerms管理Command

## 8.2 正確なNodeの確定

LuckPerms 5.5.60の次を使用して、実際に評価されるNodeを確認する。

- Plugin Metadata
- Command Help
- Runtime Permission Check
- `/lpv verbose`
- 採用Versionの公式Documentation

Base Node候補：

```text
luckperms.user.parent.addtemp
luckperms.user.parent.removetemp
luckperms.user.parent.info
luckperms.usecontext.global
```

Argument Checkとして最低限確認する。

- Modify self
- View self
- Modify others拒否
- 対象Group制限
- `addtemp`
- `removetemp`
- Global Context

Node名を推測して設定しない。

### Blocking条件

LuckPerms標準Permissionだけで次を同時に保証できない場合は作業を停止する。

- Self-only
- Matching Roleだけ
- Temporary Parentだけ
- Permanent Parent拒否
- Other Player拒否
- Arbitrary Group拒否

その場合：

- Wildcardを付与しない。
- 任意Group操作を許可しない。
- 広いLuckPerms権限で妥協しない。
- 中途半端なEligibilityをRuntimeへ残さない。
- 確認できたPermission Checkと不足する制約を報告する。
- 専用Command Wrapperまたは独自管理Pluginを将来課題として提示する。
- Commit／Pushしない。

## 8.3 Builder Eligibility

`wayfarer_builder_eligible`は、自分自身に対する`wayfarer_builder`のTemporary Parent追加・解除だけを許可する。

次は拒否する。

- `wayfarer_admin`
- 他Group
- 永続Parent
- 他Player

## 8.4 Admin Eligibility

`wayfarer_admin_eligible`は、自分自身に対する`wayfarer_admin`のTemporary Parent追加・解除だけを許可する。

次は拒否する。

- `wayfarer_builder`
- 他Group
- 永続Parent
- 他Player

両Eligibilityを保持するPlayerは、それぞれ別Roleとして操作する。

複数Temporary Role同時保持は今回技術的に禁止しない。既存運用ルールとして、現在Roleを解除してから別Roleへ昇格する。

## 8.5 Explicit Deny

Eligibilityへ不要なExplicit `false` Nodeを追加しない。

理由：

- Temporary AdminのWildcardをSpecific Denyが上書きする可能性がある。
- 未付与によるFail-closedを基本とする。

Explicit Denyが不可避の場合は、Admin中にFull Accessを阻害しないことを確認する。

---

## 9. `wayfarer_builder`の今回状態

## 9.1 GroupとRegion Memberの維持

既存`wayfarer_builder`を削除・再作成しない。

維持する。

- Group名
- `default`継承
- Lobby WorldGuard Global Region Member
- `frontier_gate` WorldGuard Global Region Member

Primary Groupとして使用しない。

## 9.2 既存暫定権限の除去

作業前に、`wayfarer_builder`の全Parent、Permission、Context、Metaを記録する。

現在付与されている暫定権限を監査し、少なくとも次を除去する。

- `worldedit.*`
- `worldguard.*`
- WorldGuard管理Permission
- Ver.0.0.4 Phase 1AのBuilder Role Containerに不要な管理Permission

今回の完了時点では、`wayfarer_builder`へ次を付与しない。

- WorldEdit
- Multiverse-Core
- Multiverse-NetherPortals
- Gamemode
- Teleport
- WorldGuard管理
- Advanced Portals
- Frontier Theme管理
- Velocity管理
- LuckPerms
- Economy
- Player処分
- Server停止
- Reload／Debug
- Wildcard

### 9.3 Entry World建築

`wayfarer_builder`のWorldGuard Region Member参照により、Builder所属中にLobbyまたは`frontier_gate`で通常のBlock設置・破壊が可能であることを、承認された安全な1 Blockで確認する。

- 1 Block設置
- 1 Block破壊
- 元の状態へ復元
- WorldGuard管理Commandは拒否
- WorldEdit Commandは拒否

この確認はWorldGuard内部品質の網羅試験ではなく、既存Region Member境界を維持できていることの確認である。

この挙動が成立しない場合は、WorldGuard管理Wildcardを戻さず、Region／Flag／Membershipの原因を調査して報告する。

---

## 10. `wayfarer_admin`の全権限

`wayfarer_admin`へGlobal Full Accessを付与する。

採用候補：

```text
*
```

LuckPermsのWildcard適用設定と、Velocity／Paperでの実際のPermission解決を確認する。

AdminはOPへ依存しない。

Playerは`wayfarer_admin`へTemporary Parentとしてのみ所属する。

Admin所属中の対象：

- Velocity管理
- 全Paper管理
- Vanilla／Paper管理
- LuckPerms管理
- WorldEdit／WorldGuard管理
- Multiverse管理
- RedisEconomy管理
- EconomyShopGUI管理
- mcMMO管理
- Player管理
- `save-all`／`stop`等のRuntime管理Command Permission

破壊的Commandを網羅実行しない。

Permission Check、Help、Info、List等の非破壊的代表操作で確認する。

Admin Parent解除後は、全権限が直ちに失効することを確認する。

---

## 11. Specific Deny監査

`default`および他の恒久Groupに存在するSpecific `false` Nodeを監査する。

特にEconomyShopGUIの明示DenyがAdmin Full Accessを阻害しないか確認する。

方針：

- 通常Playerの拒否が「未付与」で成立する場合、不要なSpecific Denyは除去候補とする。
- Bukkit Default等を上書きするために必要なDenyは維持する。
- 必要なDenyがAdmin Wildcardを阻害する場合、`wayfarer_admin`へ対応Specific `true`を明示する。
- Admin所属中に導入済みPluginの代表管理Permissionが利用可能であることを確認する。
- BuilderやEligibilityへSpecific Denyを大量追加しない。

Specific Denyの変更は現在の一般Player権限境界へ影響するため、変更理由と結果を文書化する。

---

## 12. Bootstrap対象Player

Eligibilityを付与するPlayerはCodexが推測しない。

実装途中でUser Input待ちへ入り、次を確認する。

- 対象Player名
- 必要な場合はUUID
- 付与するEligibility
  - Builder Eligible
  - Admin Eligible

今回の想定はユーザー本人への両Eligibility付与だが、明示回答を待つ。

Player名／UUIDはRuntime Databaseへ保存してよいが、次へ記録しない。

- Repository
- Documentation
- Commit Message
- Diff
- 完了報告

---

## 13. 推奨実装順序

1. 最新RepositoryとRuntime状態を確認する。
2. LuckPerms Database Dumpを作成する。
3. Group／Permission／Parent／OP／Region Member状態を記録する。
4. LuckPerms TemplateへArgument-based Permission設定を追加する。
5. Group定義を作成または監査する。
6. `wayfarer_builder`から暫定WorldEdit／WorldGuard管理権限を除去する。
7. Builder Role ContainerのRegion Member参照を確認する。
8. Eligibilityの正確なSelf-only NodeをVerboseで確定する。
9. `wayfarer_admin`へFull Accessを設定する。
10. ユーザー確認後、対象PlayerへEligibilityを恒久付与する。
11. Console／既存OPを残したままAdmin自己昇格を確認する。
12. Admin自己昇格が正常なことを確認後、OP依存を除去する。
13. 全Componentを正常再起動する。
14. Security Boundary受入確認を行う。
15. Test Temporary Parent、Test Node、OP、Test DataをCleanupする。
16. 文書を実態へ更新する。
17. Commit前検査を行う。
18. Commit／Pushする。

Bootstrap中はConsoleを使用してよいが、通常運用手順にはしない。

---

## 14. 受入確認

## 14.1 Config

- 全4 LuckPerms InstanceでArgument-based Command Permissionsが有効。
- 全PaperでOPが無効。
- `auto-op`を使用していない。
- 正しいTemplateからRuntime Configが生成される。
- SecretがGitに含まれない。

## 14.2 Group

- 5 Group定義が存在する。
- `default`と既存`wayfarer_builder`を再利用している。
- Group定義自体は恒久。
- PlayerのBuilder／Admin ParentだけがTemporary。
- Primary Groupは変更されていない。
- WorldGuard Region Member参照が維持されている。
- Builderに最終Allowlistがまだ付与されていない。

## 14.3 Eligibilityのみ

Roleなし・Eligibilityのみの状態で確認する。

許可：

- 通常Player機能
- 自分自身への対応Role Temporary Add
- 自分自身からの対応Role Temporary Remove
- 必要最小限の自己Parent確認

拒否：

- 他Player
- 永続Parent
- 間違ったRole
- 任意Group
- Permission Set／Unset
- Group作成／削除
- Editor
- Builder実権限
- Admin実権限

他Player拒否確認に実在Playerがいない場合は、安全なRandom UUID等を使用し、変更・Parent・不要User Recordが残らないことを確認する。

## 14.4 Builder Role Container

短いTemporary Durationで確認する。

例：

```text
2m
```

確認：

- Self Addtemp成功
- Main／Lobby／Frontierへ伝播
- Lobbyまたは`frontier_gate`で通常Block設置／破壊が可能
- Test Blockを元に戻す
- WorldEdit拒否
- WorldGuard管理拒否
- Multiverse管理拒否
- Gamemode管理拒否
- Teleport管理拒否
- LuckPerms管理拒否
- Economy管理拒否
- Player処分拒否
- Server Stop拒否
- Velocity管理拒否
- Self Removetemp成功
- 解除後にEntry World建築権限が失効
- Temporary Parentが残らない

Builder最終Allowlistが未実装であることを正常結果として扱う。

## 14.5 Expiry

BuilderまたはAdminのどちらか一方で、30秒から1分程度のTemporary Parentを使用し自然失効を確認する。

- 期限切れParentが除去される。
- Role権限が失効する。
- 不要なParentが残らない。

両Roleで同じExpiry試験を繰り返さない。

## 14.6 Admin

短いTemporary Adminで確認する。

- Velocityの代表管理Permission
- Paperの代表Vanilla管理Permission
- LuckPerms管理Permission
- 導入済みPluginの代表管理Permission
- Specific DenyでFull Accessが遮断されない
- OPではなくPermissionで動作
- Parent解除後に権限失効
- 恒久Admin Parentなし
- OP残留なし

`stop`、World削除、Database操作等の破壊的Commandは網羅実行しない。

## 14.7 Restart

正常Network Restartを1回行う。

再起動後：

- Eligibility Parentが維持される。
- Test Temporary Builder／Adminが残っていない。
- OPが存在しない。
- 自己昇格が引き続き利用できる。
- Shared LuckPerms変更が全Instanceへ反映される。
- LuckPerms起動Errorがない。

TAB、EconomyShopGUI、mcMMO、RedisEconomy等の広範な回帰試験へ拡大しない。

---

## 15. Cleanup

Commit前に確認する。

- Test Temporary Builderなし
- Test Temporary Adminなし
- Test Random User／Parentなし
- Test Permission Nodeなし
- 恒久OPなし
- Test Block復元済み
- Eligibilityは承認されたPlayerだけ
- Primary Groupは通常状態
- `wayfarer_builder`に最終Allowlist権限なし
- Server正常状態
- Database DumpはIgnored
- Player情報はGitに含まれない

---

## 16. 文書更新

新規正本文書として次を作成することを推奨する。

```text
docs/12-permission-model.md
```

最低限記載する。

- Phase 1A／Phase 1Bの分離
- 5 Group定義
- Groupは恒久、Role ParentだけがTemporary
- 既存`wayfarer_builder`再利用
- Eligibilityの正確なPermission Node
- `/lpv`を使用する理由
- Builder 2時間／Admin 30分の標準値
- Builder Role Containerの現在権限
- Builder最終Allowlistは未実装
- Admin Full Access
- OPを使用しない
- Specific Denyの扱い
- 自己昇格／降格Command例
- Eligibility付与手順
- Bootstrap／Recovery手順
- Rollback手順
- 既知制約
- Phase 1Bの実施条件

関連文書を実態へ更新する。

最低限：

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
- `docs/12-permission-model.md`

### Roadmap

Phase 1を次へ分割する。

```text
Phase 1A - Permission foundation and temporary Admin
Phase 1B - Final Builder allowlist
```

Phase 1Aは実施結果に基づき完了へ更新する。

Phase 1Bは未完了のV0.1.0 Release Blockerとして残す。

Phase 1Bの実施条件：

- Advanced PortalsのPermission体系確認
- Playable Theme選定
- Builderが担当するHub／Gate作業確定

次の機能タスクは引き続きBetterStructuresとする。

### Acceptance Tests

Permission Model項目を次へ分ける。

完了候補：

- Group定義
- Self-only Temporary Parent
- Admin Full Access
- OP廃止
- Existing Builder Group／Region Member維持
- Builder暫定管理権限除去

未完了：

- Builder WorldEdit
- Builder Multiverse
- Builder Gamemode
- Builder Teleport
- Builder Advanced Portals
- Builder Theme Plugin権限
- Final Builder Allowlist

未確認項目を完了扱いしない。

実Player名／UUIDを文書化しない。

---

## 17. Repository変更

追跡対象候補：

- LuckPerms Sanitized Config Template
- Config Renderer Validation
- Permission Model文書
- README／AGENTS
- Design／Architecture／Installation／Operations／Play Guide
- Acceptance Tests
- Roadmap
- Deferred Design Items

追跡しない。

- Runtime Credential Config
- MariaDB Dump
- LuckPerms Database Data
- Player名／UUID
- Log
- Cache
- JAR
- World
- Backup
- Temporary Export

LuckPerms Exportを作成する場合はIgnoredな調査用とし、Player Dataを含むままCommitしない。

---

## 18. Commit前確認

実行する。

```powershell
git status --short
git diff --check
git diff --stat
git diff
```

Repositoryに存在する検査Scriptだけを実行する。

例：

```powershell
.\scripts\Render-LocalConfigs.ps1
.\scripts\Test-Layout.ps1
```

確認：

- Secretなし
- Runtime Configなし
- Database Dumpなし
- Player名／UUIDなし
- JAR／World／Log／Cacheなし
- GroupとTemporary Parentの表現が正確
- Builder最終Allowlistを実装済みと記載していない
- AdminがOPに依存していない
- Temporary Parent Cleanup済み
- OPなし
- Permission実態と文書が一致
- 無関係なRegression Testを実施していない

---

## 19. Commit／Push条件

次をすべて満たした場合だけCommit／Pushする。

- Pre-change LuckPerms DB Dump作成済み
- Argument-based Permission有効
- 5 Group定義正常
- 既存`wayfarer_builder`再利用
- WorldGuard Region Member維持
- Builder暫定WorldEdit／WorldGuard管理権限除去
- Eligibility Self-only確認
- Other Player拒否
- Permanent Parent拒否
- Arbitrary Group拒否
- Builder Role Container確認
- Admin Full Access確認
- OP依存除去
- Admin解除後の権限失効
- Temporary Expiry確認
- Restart後正常
- Test Parent／Node／OP Cleanup済み
- Builder最終Allowlist未実装のまま
- Secret／DB／Player情報なし
- 文書整合
- `git diff --check`成功
- Repository検査成功

Blockingな失敗時：

- Commitしない。
- Pushしない。
- 広いPermissionで妥協しない。
- 中途半端なEligibilityを残さない。
- Console／BackupによるRecovery可能状態を維持する。
- 失敗したPermission Check、現在状態、Rollback結果を報告する。

推奨Commit Message：

```text
feat: 一時昇格型権限基盤を実装
```

Commit後、内容を再確認しCurrent BranchをremoteへPushする。

禁止：

- Force Push
- History Rewrite
- 無関係Commitの混入
- Player固有情報のCommit
- Builder最終Allowlistの同時実装

---

## 20. 完了報告

完了時に次を報告する。

- 作業開始時HEAD
- LuckPerms Version
- Config変更
- 作成したGroup
- 再利用したGroup
- Eligibilityの正確なPermission Node
- Admin Full Accessの実装方法
- OP除去結果
- Existing Builder Permission除去結果
- WorldGuard Region Member維持結果
- 対象Playerへ付与したEligibilityの種類
- Self-only拒否試験結果
- Builder Role Container試験結果
- Admin試験結果
- Expiry試験結果
- Restart結果
- Cleanup結果
- Specific Deny監査結果
- Pre-change Backup PathとSHA-256
- 変更ファイル
- Commit SHA
- Push先Branch
- Phase 1Bに残した項目
- 次の機能タスクがBetterStructuresであること

Player名、UUID、Credentialは完了報告へ記載しない。
