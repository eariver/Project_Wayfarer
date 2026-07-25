# Project Wayfarer Main CoreProtect 導入・受入 指示書

> 状態: 延期（Minecraft 26.2対応Stable版待ち）。Active Runtimeは未導入です。
> 2026-07-26のCE 24.0試行はRuntime拒否後にRollback済みであり、本指示書の
> Acceptanceは未実行です。対応版公開後もそのまま再実行せず、Version、
> Artifact、Config、Database、World別Logging、PermissionおよびMain／Lobby／
> Frontier配置方針を現行仕様に対して再監査してください。

## 1. 推奨Sol

```text
high
```

理由：

- Project Wayfarer Roadmap Order 7として、Final Main Baseline確定後の最初のRuntime変更を行う。
- CoreProtectはWorld変更履歴、Container／Inventory履歴、Lookup、Rollback、Restoreを扱うため、誤操作時にはWorld状態へ直接影響する。
- 専用MariaDB Database／User、Credential、Permission Boundary、Plugin Config、World別Logging Scope、Backup Ownershipを横断する。
- 実受入では限定的ながら実際のRollback／Restoreを行い、Player権限と再起動後Persistenceを確認する。
- 後続のMain Hub／Gate構築、WorldEdit作業、Frontier構築における監査基盤になるため、普通のPlugin導入より厳格な検証が必要である。

次の場合は作業を拡張せず停止する。

- CoreProtect Artifactが公式配布物として確認できない。
- JAR内部Versionが承認候補と異なる。
- Paper 26.2／Java 25でEnableしない。
- MariaDB接続、Schema生成またはConsumer処理が安定しない。
- CoreProtectがSQLite／DuckDB等の意図しない別DatabaseへFallbackする。
- Resource FamilyでLoggingを完全に無効化できない。
- 一般PlayerまたはBuilderがLookup／Rollback／Restore／Purge等を実行できる。
- Rollback／Restoreが指定範囲外を変更する。
- Final Main BaselineのSeed、UUID、Spawn、Region数またはPortal Familyが変化する。
- 新規Regionが生成される。
- CoreProtect導入に伴いWorld、Region、Seed、UUID、PortalまたはBetterStructures Config変更が必要になる。
- CoreProtect以外のPlugin更新、Artifact差替えまたはDatabase Migrationが必要になる。
- CredentialをGitへ安全に除外できない。
- 実データのPurge、Database Dropまたは履歴削除が必要になる。

---

## 2. 目的

Project Wayfarer Ver.0.0.6 Roadmapの次を完了する。

```text
Order 7:
CoreProtect
```

実施内容：

1. 公式CoreProtect Community Edition Artifactを検証する。
2. Main Backendだけへ導入する。
3. 専用MariaDB Databaseと最小権限Userを用意する。
4. Persistent Main FamilyだけをLogging対象にする。
5. Resource FamilyではCoreProtect Loggingを無効化する。
6. CoreProtect管理機能をTemporary Adminだけに限定する。
7. Lookup、Preview、Rollback、Restore、Container Lookupを限定範囲で実地確認する。
8. 再起動後も履歴がMariaDBに保持されることを確認する。
9. Final Main Baselineを変更せず、Order 7完了を記録する。

完了後：

```text
Orders 2–7:
  complete

Final Main Baseline:
  unchanged

Next:
  Order 8 Frontier lock
```

本TaskはCoreProtectのMain導入だけを対象とする。

---

## 3. ユーザーが準備するArtifact

### 3.1 採用候補

```text
CoreProtect Community Edition v24.0
```

候補理由：

- 2026-07-25時点で確認できる最新のCommunity Edition Release。
- Minecraft 26.1系を公式対象に含み、公式CoreProtect配布ページは26.2向けDownload導線を案内している。
- Paperを対応Platformとしている。
- MySQL Storage、Lookup、Rollback、Restore、WorldEdit Loggingを提供する。
- Artistic-2.0 License。

Paper 26.2での採用可否は、Artifact metadataと実Runtime Enableによって最終確認する。

### 3.2 配置先

ユーザーは公式配布元からJARを取得し、次へ置く。

```text
manual-downloads/coreprotect/
```

例：

```text
manual-downloads/coreprotect/CoreProtect-24.0.jar
```

**実際の公式Filenameを維持し、手動Renameしない。**

CodexはArtifactをDownloadしない。

### 3.3 公式参照先

```text
https://coreprotect.net/latest
https://modrinth.com/plugin/coreprotect
https://www.curseforge.com/minecraft/bukkit-plugins/coreprotect
https://docs.coreprotect.net/
```

Patreon Build、非公式Mirror、再配布JAR、改変Build、開発Snapshotは使用しない。

### 3.4 Version差異

実行時に公式配布元へCoreProtect CE v24.0より新しいStable Releaseが存在する場合：

1. 自動的に新Versionへ変更しない。
2. v24.0と新VersionのMinecraft／Paper対応、License、変更点を報告する。
3. ユーザーへ採用Versionの判断を求める。
4. 新Versionを承認する新しい明示回答を得るまで停止する。

---

## 4. Repository

```text
eariver/Project_Wayfarer
```

作業対象は、VS Codeで開かれているRepository Root内だけとする。

開始時：

```powershell
git status --short
git branch --show-current
git remote -v
git log -10 --oneline
git rev-parse HEAD
```

最低限、次を含むこと。

```text
7670b98ce4966544381df5e1376de0bdb3fcbaff
docs: Main Final Baselineを確定

bdca2a3cca4c76929f32df8354ebaf0782e4612b
docs: Main Final Baseline Commitを記録
```

開始時HEADは原則：

```text
bdca2a3cca4c76929f32df8354ebaf0782e4612b
```

異なる場合は最新差分を確認する。

意図不明な未Commit変更、未Push CommitまたはRuntime ArtifactのStageがある場合は停止する。

禁止：

- `git reset --hard`
- `git clean`
- Amend
- Rebase
- Force Push
- Tag
- Release
- Branch作成
- PR作成
- Runtime JAR／Database／Log／WorldのCommit

---

## 5. 正本

最低限、次を読む。

```text
AGENTS.md
README.md
docs/00-design-guide.md
docs/01-architecture.md
docs/02-installation.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/12-permission-model.md
docs/13-main-world-baseline.md
docs/investigations/2026-07-25-main-order6-final-baseline.md
versions.yml
plugin-manifest.yml
infrastructure/
scripts/
.gitignore
codex/README.md
```

MariaDB Credential、Sanitized Template、Runtime Render、Docker操作については、既存のLuckPerms、mcMMO、RedisEconomy、EvenMoreFish方式を調査し、Project内の既存Patternを再利用する。

新しいSecret管理方式を独断で追加しない。

---

## 6. 現行Final Main Baseline

### Runtime

```text
Paper:
  26.2 build 62

Java:
  Oracle Java 25.0.3 LTS
```

### Persistent Main Family

| World | UUID | Seed | Region |
|---|---|---:|---:|
| `main` | `d868e7ff-6663-492d-a963-f95f00ce6c30` | `164225356311935743` | 17 |
| `main_nether` | `1225688f-7770-43ed-b1dd-71bd112de3b5` | `164225356311935743` | 11 |
| `main_the_end` | `436843c4-2229-4c67-907c-b3a7d1530d71` | `164225356311935743` | 18 |

Spawn：

```text
main:
  (320, 70, 128)

main_nether:
  (20.5, 60, -19.5)

main_the_end:
  (100.5, 49, 0.5)
```

### Resource Family

| World | Region |
|---|---:|
| `resource` | 8 |
| `resource_nether` | 4 |
| `resource_end` | 4 |

Final Main Baseline Backup：

```text
backups/main-v006-final-baseline-20260725-220745/
```

Manifest SHA-256：

```text
A85A7CCAA2FE2DECCC69CE3E9F862F1281408B4D02E20EFC1E3E31B74D0814A1
```

SHA-list SHA-256：

```text
81593864B49E41FB03F02514C1935DFAF380A1ABFE6FB148897932E328A50C39
```

本TaskはこのBaselineを置換しない。

---

## 7. 導入Scope

### 7.1 Plugin配置

```text
Main:
  install

Velocity:
  do not install

Lobby:
  do not install

Frontier:
  do not install in this task
```

Frontier CoreProtectはOrder 11のFrontier shared foundationで、Frontier World／Storage／Permission境界に合わせて別途導入する。

### 7.2 Database

専用Database：

```text
wayfarer_coreprotect_main
```

専用User候補：

```text
wayfarer_coreprotect_main
```

Table Prefix：

```text
co_
```

MariaDB Host：

```text
既存Project Wayfarer MariaDB Service
```

Port：

```text
既存MariaDB Port
```

既存Infrastructure定義から解決し、推測でHost／Portを追加しない。

### 7.3 Database分離

次と共有しない。

- LuckPerms Database
- mcMMO Database
- EvenMoreFish Database
- 将来のWayfarer_Core Database
- Frontier CoreProtect Database

MainとFrontierで同一CoreProtect Database／Prefixを共有しない。

理由：

- CoreProtectはBackendごとに独立したWorld集合とConsumerを持つ。
- 同一Namespaceへの複数Writerを避ける。
- Backup、Retention、Restore、障害境界を分離する。
- Main履歴をFrontier実装から独立して保護する。

---

## 8. Database Provisioning

### 8.1 Preflight

確認：

- MariaDB 11.8 Health
- Existing Database一覧
- Existing User一覧
- `wayfarer_coreprotect_main`の衝突有無
- `co_` Tableの衝突有無
- Current backup／dump ownership
- Secret rendering pattern
- Docker Compose Service名
- Character Set／Collation

DatabaseまたはUserが既に存在する場合、空と推測せず停止して内容を報告する。

### 8.2 Character Set

既存Project DB Policyを優先する。

明示Policyがない場合の候補：

```sql
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci
```

MariaDB Versionがより適切な既存CollationをProjectで使用している場合、それを再利用する。

### 8.3 最小権限

専用Userには、専用Databaseだけに必要な権限を付与する。

候補：

```text
SELECT
INSERT
UPDATE
DELETE
CREATE
ALTER
INDEX
DROP
```

CoreProtectのSchema生成、Rollback state更新、将来のManual Purgeを満たす範囲に限定する。

禁止：

- `*.*`
- GRANT OPTION
- FILE
- PROCESS
- SUPER
- CREATE USER
- SHUTDOWN
- 他Project Databaseへの権限

### 8.4 Credential

- Passwordは十分な長さのRandom Secret。
- Runtime ConfigへだけRenderする。
- Sanitized TemplateではPlaceholderにする。
- Console出力、Report、Commit、Commit Messageへ平文を残さない。
- Git historyにSecretを入れない。
- `.env`等を使う場合は既存Project方式を再利用する。
- LogにConnection URL＋Passwordが出ないことを確認する。

---

## 9. Config方針

### 9.1 Shipped Configを正本にする

CoreProtect JAR内部のDefault `config.yml`を抽出・確認する。

Version 24.0で実在するKeyだけを使用する。

Database Selectorは次の順に決定する。

1. Shipped Configに`database-type`がある場合：

```yaml
database-type: mysql
```

2. Shipped Configに`database-type`がなく、Legacy `use-mysql`がある場合：

```yaml
use-mysql: true
```

存在しないKeyを推測で追加しない。

### 9.2 Database Config

実在Keyへ次を設定する。

```text
Host:
  Project MariaDB

Port:
  Project MariaDB Port

Database:
  wayfarer_coreprotect_main

Username:
  wayfarer_coreprotect_main

Password:
  Runtime Secret

Table Prefix:
  co_
```

SSLは既存Project MariaDB接続Policyに従う。

Localhost／Docker Network内部接続で既存PluginがTLSを使用していない場合、CoreProtectだけ独自TLS構成を追加しない。

### 9.3 Logging対象

有効：

```text
main
main_nether
main_the_end
```

無効：

```text
resource
resource_nether
resource_end
```

理由：

- Main Persistent Familyは永続建築と生活拠点であり、監査・Rollback対象。
- Resource Familyは再生成前提で、大量採掘を記録するとDatabaseを急速に肥大化させる。
- Resource Worldの復旧正本はCoreProtectではなくResource Reset／Bootstrap／Backup手順。

### 9.4 Resource World Override

公式Per-world Config方式を使用する。

候補Filename：

```text
plugins/CoreProtect/resource.yml
plugins/CoreProtect/resource_nether.yml
plugins/CoreProtect/resource_end.yml
```

ただし、Runtimeが認識するExact World名／Config FilenameをCoreProtect起動Logと実地試験で確認する。

各Resource World Overrideでは、JAR内v24.0 Configに存在するすべてのLogging Categoryを無効化する。

例示概念：

```text
block place/break
container transactions
item transactions
inventory transactions
entity kill/spawn/change
chat
commands
sessions
signs
interactions
liquid/fire/explosion
piston/falling block
WorldEdit
```

実際のKey名はShipped Configから抽出する。上記をそのままYAML Keyとして使用しない。

### 9.5 Global Data Minimization

Persistent Mainでは、World復旧に必要な記録を有効にする。

推奨：

```text
Block changes:
  enabled

Container transactions:
  enabled

Inventory transactions:
  enabled

Item transactions:
  enabled

Entity kill／spawn:
  enabled where supported

Sign／interaction:
  enabled

Session:
  enabled

WorldEdit:
  enabled

Chat logging:
  disabled

Command logging:
  disabled
```

理由：

- Chat／Command履歴はWorld rollbackに必須ではない。
- Secret、管理Command、個人的会話の不用意な保存を避ける。
- Block／Container／Inventory／Entity／WorldEditはGrief調査と復旧に直接必要。

Version 24.0のKey構造で一部を独立制御できない場合、実際のConfigを提示してユーザー判断を求める。勝手に広いLoggingへ倒さない。

### 9.6 Update／Telemetry

- 自動JAR Downloadは使用しない。
- Plugin UpdateはProjectの手動Artifact Lock方式を維持する。
- Update checkを無効化できる場合は無効化する。
- bStats等はProjectの既存Telemetry Policyへ従う。
- Donation Key、Patreon KeyまたはNetworking APIを設定しない。
- Automatic Purgeは設定しない。
- Manual Purgeも本Taskでは実行しない。

---

## 10. Tracked／Ignored構成

### 10.1 Runtime

候補：

```text
servers/main/plugins/CoreProtect.jar
servers/main/plugins/CoreProtect/config.yml
servers/main/plugins/CoreProtect/resource.yml
servers/main/plugins/CoreProtect/resource_nether.yml
servers/main/plugins/CoreProtect/resource_end.yml
```

JAR、Runtime Config、Database Cache、LogはGit Ignore対象とする。

### 10.2 Tracked Sanitized Template

既存Project Patternを優先する。

候補：

```text
config/coreprotect/main-config.yml.template
config/coreprotect/resource.yml
config/coreprotect/resource_nether.yml
config/coreprotect/resource_end.yml
```

または既存`config/templates/`等の正式位置。

Templateに平文Credentialを含めない。

### 10.3 Render／Provision Script

必要なら既存方式を拡張する。

候補：

```text
scripts/Initialize-CoreProtectMain.ps1
scripts/Render-CoreProtectMainConfig.ps1
```

ただし、同等の既存Scriptがある場合は新規作成せず拡張する。

Script要件：

- Repository Root境界
- Main-only Placement
- Artifact exact path
- Artifact SHA-256
- Credential未設定拒否
- Existing DB／User衝突拒否
- Dry Run
- Non-zero Exit
- Secret非表示
- Runtime Config Hash
- Resource Override検証
- Velocity／Lobby／Frontier拒否

---

## 11. Artifact Preflight

確認：

- Filename
- File size
- SHA-256
- Archive readability
- `plugin.yml`
- Plugin name
- Main class
- Version
- API Version
- Dependencies／soft dependencies
- Paper／Bukkit target
- License
- Official source
- Signatureまたは公開Hashがある場合は照合

期待：

```text
Plugin:
  CoreProtect

Version:
  24.0

Edition:
  Community Edition

Platform:
  Bukkit／Paper compatible
```

`plugin.yml`が異なるVersionを報告する場合、Filenameを信用せず停止する。

Artifact SHA-256を`versions.yml`と`plugin-manifest.yml`へ記録する。

JARはCommitしない。

---

## 12. Pre-install Snapshot

Final Main Baseline BackupをRollback Sourceとして保持する。

加えて、CoreProtect導入前の次をIgnored Snapshotへ保存する。

```text
servers/main/plugins/
tracked Config candidates
LuckPerms permission export or focused query result
MariaDB database/user existence report
Main Region inventory
Resource Region inventory and SHA-256
```

候補Path：

```text
backups/main-coreprotect-preflight-YYYYMMDD-HHMMSS/
```

World全体を再Copyする必要はない。Final Main Baseline Backupが既に存在するため、本SnapshotはPlugin／Config／Permission／DB Preflight Evidenceに限定する。

---

## 13. Approval Gate

Codexは、実行前に次を報告して停止する。

- CoreProtect Version
- Official source
- JAR Filename
- JAR SHA-256
- Internal plugin.yml Version
- Main placement path
- Database name
- Database user
- Runtime Credential path
- Sanitized Template path
- Database selector key
- Persistent Logging Scope
- Resource Disable method
- Global chat／command Logging方針
- Permission方針
- Pre-install Snapshot path
- Rollback方針
- Expected tracked files
- Expected ignored files

実行Token：

```text
APPROVE-WAYFARER-MAIN-COREPROTECT-V24-INSTALL
```

Tokenがない場合は、Database作成、JAR配置、Runtime Config生成またはServer起動を行わない。

Versionが24.0以外へ変わった場合、このTokenを流用しない。

---

## 14. Installation

承認後：

1. 全Minecraft Component停止を確認する。
2. MariaDB Healthを確認する。
3. Dedicated Database／Userを作成する。
4. Grantを確認する。
5. CoreProtect JARをMainだけへCopyする。
6. Sanitized TemplateからRuntime ConfigをRenderする。
7. Resource World Overrideを配置する。
8. CredentialとRuntime DataがIgnore対象であることを確認する。
9. Mainだけを起動して初回Schema生成を確認する。
10. Mainを正常停止する。
11. Config生成差分を監査する。
12. 意図しないSQLite／DuckDB Database Fileがないことを確認する。
13. Full Networkを通常順序で起動する。

Main初回起動前にDatabase Configを確定し、意図しないEmbedded Databaseへ履歴を書き始めない。

---

## 15. Startup Acceptance

確認：

- CoreProtect Enable
- Version 24.0
- MariaDB接続成功
- Dedicated Database使用
- `co_` Table生成
- Consumer起動
- `/co status`
- No ERROR／SEVERE／Exception
- No fallback DB
- No duplicate table-prefix conflict
- Paper 26.2 compatibility
- Java 25 compatibility
- Existing Plugin正常Enable
- Main Pack正常配信
- BetterStructures／FMM／RPM正常
- Final Main Baseline Region数不変

MariaDBで確認：

- CoreProtect Tableのみが専用Databaseに存在
- Table Prefixが`co_`
- Dedicated User以外の不要Grantなし
- Test前Row count baseline記録

---

## 16. Permission Boundary

### Temporary Admin

許可：

```text
coreprotect.*
```

既存`wayfarer_admin`のTemporary full authorityで利用できることを確認する。

### Builder

許可しない：

```text
inspect
lookup
rollback
restore
teleport
purge
reload
status
consumer
networking
give
```

### General Player

Builderと同様に許可しない。

### 注意

CoreProtectのCommand Handler NodeはVersionによりDefault値がある。

一般Playerが`/co`自体を入力できても、管理Subcommandが実行不能なら機能上は拒否されている。ただし可能ならHelp露出も抑える。

LuckPermsへExplicit Denyを追加する場合、`wayfarer_admin`のWildcardを打ち消さないことをFocused permission checkで確認する。

広範な`default` Denyを独断で追加しない。

---

## 17. 実地受入

### 17.1 Test場所

条件：

- `main`の既生成Chunk
- Main Spawnから安全に移動可能
- Hub予定地や既存Structureを損傷しない
- 新規ChunkをLoadしない
- WorldGuard Region外
- 既存Block状態を記録できる

Exact XYZをReportへ記録する。

### 17.2 Direct Block Test

Temporary Adminまたは専用Test Playerで：

1. Test Block Aを1個設置する。
2. Test Block Bを1個破壊する。
3. 約数秒待ってConsumer反映を確認する。
4. `/co lookup`でPlayer、時間、半径、Block Actionを限定する。
5. 設置／破壊の両方が表示されることを確認する。
6. `#preview`付きRollbackを実行する。
7. PreviewでWorldが変化しないことを確認する。
8. 同じExact Parameterで実Rollbackする。
9. Block A／Bが元状態へ戻ることを確認する。
10. Exact ParameterでRestoreする。
11. Test行為後の状態へ戻ることを確認する。
12. 最終的に手動またはCoreProtectで導入前状態へ完全Cleanupする。

半径は最小限：

```text
r:3～5
```

時間は最小限：

```text
t:5m
```

UserとBlockをExact指定する。

禁止：

- `r:#global`
- 広いWorld指定
- User省略のRollback
- 長期間Rollback
- Previewなしの広範Rollback
- Hub／Gate／Structureへの試験

### 17.3 Container Test

既生成Chunkに一時Chestを1個設置する。

1. Test Itemを1個入れる。
2. Test Itemを取り出す。
3. `a:container`をExact User／Time／RadiusでLookupする。
4. Transactionが表示されることを確認する。
5. Inventory Rollbackはこの試験では行わない。
6. ChestとTest Itemを完全Cleanupする。

### 17.4 Inspector

Temporary Adminで：

```text
/co inspect
```

- 設置Blockの履歴を確認
- 除去Blockの履歴を確認
- 終了時にInspectorをOFF

### 17.5 Resource World Negative Test

既存`resource` Spawn周辺の既生成Chunkだけを使用する。

1. Region数Beforeを記録する。
2. Test Blockを1個設置して破壊する。
3. Mainへ戻る。
4. Exact User／Time／WorldでLookupする。
5. Resource WorldのActionが記録されていないことを確認する。
6. Test Blockを導入前状態へ戻す。
7. Region数Afterが不変であることを確認する。

`resource_nether`／`resource_end`では実地変更を行わず、Config認識とDatabase Event不在を静的に確認してよい。

### 17.6 Permission Negative Test

Temporary Adminを外した状態で：

- General Player `/co inspect` denied
- General Player `/co lookup` denied
- General Player `/co rollback` denied
- General Player `/co restore` denied
- General Player `/co purge` denied
- Builderも同様にdenied

その後、Temporary Adminを再付与して必要なCleanupだけを行う。

---

## 18. Restart Persistence

受入データの一部を残したまま、正常停止・再起動する。

順序：

1. Playerを安全なMain Spawnへ戻す。
2. Temporary Admin状態を必要に応じて維持したまま切断する。
3. Velocity停止。
4. 約10秒待つ。
5. Paper `save-all flush`。
6. Main、Frontier、Lobby正常停止。
7. Java Process／Port終了確認。
8. MariaDB継続稼働。
9. Lobby、Main、Frontier、Velocity起動。
10. Mainへ再接続。
11. `/co status`。
12. Restart前のExact Test RecordをLookup。
13. 履歴保持を確認。
14. Final Cleanup。
15. Inspector OFF。
16. Survivalへ戻す。
17. Temporary Admin削除。
18. 切断。

終了時、すべてのTest Block／Chest／Itemを除去し、導入前のWorld状態へ戻す。

---

## 19. Performance／Database確認

確認：

- Consumer Queueが継続的に0または正常範囲へ戻る
- TPS／MSPTに明白な異常なし
- MariaDB Connection Errorなし
- Deadlockなし
- Table Lock異常なし
- Main Thread blockingの明白な兆候なし
- Test EventのRow増加
- Resource Negative TestのRow増加なし
- Restart後Lookup成功
- DB size／Table row baseline記録

本TaskではLoad Testを行わない。

自動Purge、Manual Purge、Optimize、Migrationを行わない。

Retention Policyは運用Dataを得てから別Taskで決定する。

---

## 20. Rollback

導入失敗時：

1. 新規接続を拒否する。
2. 全Minecraft Componentを正常停止する。
3. CoreProtect JARを削除せずQuarantineへMoveする。
4. CoreProtect Runtime DirectoryをQuarantineへMoveする。
5. Tracked Config／Script変更をRollback候補として提示する。
6. Dedicated MariaDB Database／Userを削除しない。
7. DBはIncident Evidenceとして保持する。
8. MainをCoreProtectなしで起動する。
9. Existing Plugin、Seed、UUID、Spawn、Region数を確認する。
10. Failure Reportを作成する。

Database Drop、Table Drop、Purgeは別の明示承認なしに行わない。

World復旧が必要な異常が発生した場合、Final Main Baseline Backupを使用する別Restore TaskへEscalateする。本Task内でWorld Restoreを実行しない。

---

## 21. Repository更新

最低限：

```text
AGENTS.md
README.md
docs/01-architecture.md
docs/02-installation.md
docs/03-operations.md
docs/06-acceptance-tests.md
docs/09-roadmap.md
docs/12-permission-model.md
docs/13-main-world-baseline.md
versions.yml
plugin-manifest.yml
codex/README.md
```

新規Investigation：

```text
docs/investigations/<date>-main-coreprotect-integration.md
```

本指示書：

```text
codex/Project_Wayfarer_Main_CoreProtect_Integration_and_Acceptance.md
```

必要に応じて：

```text
config/coreprotect/
scripts/Initialize-CoreProtectMain.ps1
scripts/Render-CoreProtectMainConfig.ps1
```

---

## 22. Documentation内容

記録：

- CoreProtect Version
- Edition
- Official source
- License
- JAR Filename
- JAR SHA-256
- Internal plugin.yml metadata
- Paper／Java compatibility
- Placement
- Excluded placements
- Database
- User
- Table Prefix
- Credential ownership
- Config Template
- Runtime Config Hash
- Persistent Logging Scope
- Resource disable Scope
- Chat／Command logging status
- Permission boundary
- Test XYZ
- Lookup result
- Preview result
- Rollback result
- Restore result
- Container result
- Resource negative result
- Restart persistence
- Consumer status
- Database row／size baseline
- Rollback procedure
- Order 7 completion
- Final Main Baseline unchanged

---

## 23. Acceptance Criteria

すべて必要。

### Artifact

- Official CE Artifact
- Version確定
- SHA-256記録
- Archive／plugin.yml正常
- JAR非追跡

### Placement

- Mainのみ
- Velocityなし
- Lobbyなし
- Frontierなし

### Database

- Dedicated MariaDB Database
- Dedicated least-privilege User
- `co_` Prefix
- Secret非追跡
- Unintended Embedded DBなし
- Schema生成成功
- Restart persistence成功

### Scope

- `main` enabled
- `main_nether` enabled
- `main_the_end` enabled
- `resource` disabled
- `resource_nether` disabled
- `resource_end` disabled
- Chat disabled
- Command disabled
- WorldEdit enabled
- Block／Container／Inventory logging enabled

### Permission

- Temporary Admin allowed
- General Player denied
- Builder denied
- No broad new wildcard
- No Console-only operation exposed

### Function

- Status
- Inspector
- Exact Lookup
- Preview
- Limited Rollback
- Limited Restore
- Container Lookup
- Resource negative test
- Restart lookup

### Safety

- New Region 0
- Persistent Region `17 / 11 / 18`
- Resource Region `8 / 4 / 4`
- Seed unchanged
- UUID unchanged
- Spawn unchanged
- Portal Family unchanged
- BetterStructures unchanged
- Test objects cleaned
- Player Survival
- Temporary Admin removed
- Inspector off

### Repository

- Secrets ignored
- Runtime Data ignored
- Docs updated
- Roadmap Order 7 complete
- Final Main Baseline unchanged
- Git diff check
- Layout test
- Clean final status

---

## 24. Stop Conditions

- Wrong Artifact
- Wrong Version
- Unsupported Platform
- Load Error
- MariaDB Error
- Wrong Database
- Wrong Prefix
- Credential leak
- Embedded DB fallback
- Resource logging detected
- Permission leak
- Rollback scope escape
- Restore mismatch
- Consumer stuck
- Test cleanup failure
- Region count drift
- New Region
- Seed／UUID／Spawn drift
- Portal change
- BetterStructures change
- Unexpected Plugin regression
- Git Runtime Artifact staged

停止時に追加修正を推測で行わない。

---

## 25. Git非追跡

Commit禁止：

- CoreProtect JAR
- Runtime CoreProtect Config with password
- CoreProtect Database files
- MariaDB data
- SQL dump containing data
- World
- Region
- POI
- Entity
- Player Data
- Log
- Backup
- Screenshot
- Test Artifact
- Secret
- Generated Cache

確認：

```powershell
git status --short
git check-ignore -v <coreprotect-jar>
git check-ignore -v <runtime-config>
git check-ignore -v <runtime-data>
git check-ignore -v <preflight-backup>
git diff --cached --name-status
```

---

## 26. 検証

```powershell
git diff --check
.\scripts\Test-Layout.ps1
```

YAML Parse：

```text
versions.yml
plugin-manifest.yml
Tracked CoreProtect sanitized templates
```

Scriptを追加した場合：

- Dry Run
- Missing Artifact rejection
- Wrong Version rejection
- Wrong SHA rejection
- Secret missing rejection
- Secret output rejection
- Existing DB collision rejection
- Main-only path boundary
- Velocity／Lobby／Frontier rejection
- Runtime Config Render
- Non-zero Exit

を確認する。

---

## 27. Commit／Push

推奨Implementation Commit：

```text
feat: MainへCoreProtectを導入
```

推奨Archive Commit：

```text
docs: Main CoreProtect導入Commitを記録
```

Push前：

```powershell
git status --short
git log -5 --oneline
git diff --check
.\scripts\Test-Layout.ps1
```

Push後、Remote Commit SHAを確認する。

---

## 28. Codex Archive

`codex/README.md`へ登録する。

作業中：

```text
実施中
```

成功：

```text
完了（実装Commit: <SHA>）
```

停止：

```text
停止（Main CoreProtect未導入）
```

再実行Policy：

```text
完了後はそのまま再実行禁止。
CoreProtect更新、Retention、Purge、Database Migration、Frontier導入またはRestoreは別Task。
```

---

## 29. 完了報告

以下を報告する。

1. Recommended Sol
2. User Approval Token
3. Implementation Commit SHA／Message
4. Archive Commit SHA／Message
5. Branch／Remote
6. CoreProtect Version
7. Edition
8. Official source
9. JAR Filename
10. JAR SHA-256
11. Internal plugin.yml
12. Placement
13. Excluded Placement
14. Database
15. Database User
16. Table Prefix
17. Credential leak check
18. Config Hash
19. Persistent Logging Scope
20. Resource Logging Scope
21. Chat／Command status
22. Permission result
23. Test XYZ
24. Inspector result
25. Lookup result
26. Preview result
27. Rollback result
28. Restore result
29. Container result
30. Resource negative result
31. Restart persistence
32. Consumer status
33. Database baseline
34. Persistent Region counts
35. Resource Region counts
36. Seed／UUID／Spawn
37. Player cleanup
38. Rollback procedure
39. Order 7 status
40. Updated files
41. Validation commands
42. Git exclusion
43. Final `git status --short`

---

## 30. 完了後の正式状態

```text
Orders 2–7:
  complete

Final Main Baseline:
  unchanged

Main CoreProtect:
  installed and accepted

Main Hub／Gate:
  unbuilt

Main Spawn WorldGuard:
  unapplied

Frontier:
  incomplete

Next Roadmap Order:
  8 - Frontier lock

V0.1.0:
  unreleased
```
