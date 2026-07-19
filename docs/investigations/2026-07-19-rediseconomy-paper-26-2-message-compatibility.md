# RedisEconomy 4.5.12 / Paper 26.2 Message Compatibility Investigation

- 調査日: 2026-07-19
- 対象Task: Waymark共有経済基盤の導入
- Status: **Wayfarer互換Buildで解決・再検証済み**
- Severity: Resolved Integration Blocker
- Commit / Push: 未実施

## 1. Executive summary

RedisEconomy 4.5.12とVaultUnlocked 2.20.2をMainおよびFrontierへ導入し、共有Redis残高、Vault providerおよび永続化を検証しました。Data経路は正常でしたが、Paper 26.2のMainだけで`/balance`等のRedisEconomy Command応答が表示されませんでした。Paper 1.21.11のFrontierでは同じJAR、同じ言語ファイルおよび実質的に同じConfigで正常に表示されます。

Config、Permission、Command競合、他Plugin、MiniMessage文法およびRedis処理を順番に切り分けた結果、原因はRedisEconomy 4.5.12が同梱するAdventure Platform Bukkit 4.4.1と、Paper 26.2が提供するAdventure API 5.2.0のMessage dispatch互換性であることをBytecode比較により特定しました。

RedisEconomyは`Audience.sendMessage(Component)`を呼びます。Adventure 4.26.1ではこのDefault methodがRedisEconomy側の旧実装へ転送しますが、Adventure 5.2.0ではDefault methodがそのまま`return`するため、例外なしにMessageが破棄されます。

したがって、これはWayfarerの設定漏れではありませんでした。Redis、VaultおよびPlaceholderAPI経由の残高取得は動作していましたが、Main上のRedisEconomy利用者向けCommand feedbackだけが正式版4.5.12では受入不能でした。

その後、ユーザー提供の`RedisEconomy-4.5.12-wayfarer.1.jar`へ差し替えました。このBuildはMessage送信をPaper native `CommandSender.sendRichMessage(String)`へ変更し、不要になったshaded Adventure Platform bridgeを除外しています。Main Paper 26.2とFrontier Paper 1.21.11の双方でCommand feedback、共有残高、Vault providerおよび正常再起動を再検証し、本Blockerは解決しました。

## 2. Scope

### 調査対象

- RedisEconomy 4.5.12
- VaultUnlocked 2.20.2
- Main: Paper 26.2 build 62 / Java 25
- Frontier: Paper 1.21.11 build 132 / Java 25
- Redis 8 Alpine Container
- Main／Frontier間の共有Waymark残高
- RedisEconomyのCommand、Language、Permission、VaultおよびPlaceholderAPI連携

### 対象外

- RedisEconomy JARの改変または再Build
- 非公式Buildの取得
- Paper VersionのDowngrade
- 別Economy Pluginへの移行
- 独自PluginによるMessage送信の補修

## 3. Verified artifacts

| Artifact | Version | Platform | SHA-256 |
| --- | --- | --- | --- |
| RedisEconomy | 4.5.12 | Bukkit / Paper | `7CCD1C5FBC43AB1A3345F4C9705B71AA39FBBBD457647C1808629BC86884E51F` |
| RedisEconomy Wayfarer compatibility build | 4.5.12-wayfarer.1 | Bukkit / Paper | `AB00270CD970A909F54F6EE7C2C47151FB90DB0EA36FA6AB68AC59D939CFCA47` |
| VaultUnlocked | 2.20.2 | Bukkit / Paper | `BD9E7A31F1B2D31A591497174887EEA7AE7E632C6B179DA13E4F0AD732DE2DF7` |

両JARはユーザーが`manual-downloads/`へ手動配置したものを検証して使用しました。CodexによるPlugin JARのDownloadは行っていません。MainとFrontierには同一SHA-256のJARを配置し、LobbyおよびVelocityには配置していません。

## 4. Intended configuration

WayfarerではMainとFrontierが同じRedis namespaceを共有し、LobbyはEconomyへ参加しません。

| Setting | Main | Frontier | Result |
| --- | --- | --- | --- |
| Redis host | `127.0.0.2` | `127.0.0.2` | 一致 |
| Redis database | `0` | `0` | 一致 |
| `clusterId` | `waymark` | `waymark` | 一致 |
| `clientName` | `main` | `frontier` | 意図した差分 |
| Default currency | `vault` | `vault` | 一致 |
| Display unit | `WM` | `WM` | 一致 |
| Starting balance | `0` | `0` | 一致 |
| Transaction save | enabled | enabled | 一致 |
| Bank feature | disabled | disabled | 一致 |
| Language | `en-US` | `en-US` | 一致 |

Runtime ConfigのPasswordはRepositoryへ記録せず、Sanitized TemplateからRenderします。

- [Main RedisEconomy template](../../servers/main/plugins/RedisEconomy/config.yml.template)
- [Frontier RedisEconomy template](../../servers/frontier/plugins/RedisEconomy/config.yml.template)
- [RedisEconomy renderer](../../scripts/Render-RedisEconomyConfig.ps1)

## 5. Initial runtime verification

MainとFrontierの両方で以下を確認しました。

- RedisEconomy 4.5.12がEnableされる。
- Redisへの認証接続が成功する。
- VaultUnlocked 2.20.2がEnableされる。
- RedisEconomyのDefault currency `vault`がVault Legacy Economy providerとして登録される。
- Startup／ShutdownにRedisEconomy由来のERROR、SEVEREまたはExceptionがない。
- 正常なServer停止時にRedisEconomyが正常にDisableされる。

代表的な起動結果は次のとおりです。Credentialを含む接続文字列は記録していません。

```text
[RedisEconomy] Redis server connected!
[RedisEconomy] Successfully registered RedisEconomy default currency 'vault' as economy provider in Vault
[RedisEconomy] Hooked into Vault!
[Vault] Economy Legacy: RedisEconomy [RedisEconomy]
```

## 6. Data-path results

Message表示問題の調査前後を通して、EconomyのData path自体は正常でした。

1. Main ConsoleからTest accountへ100 WMを付与するとRedis上の残高が100になった。
2. Frontierで同じ残高100 WMを確認できた。
3. Frontier Consoleから25 WMを減算すると75 WMになった。
4. 存在しないPlayerへの`/pay`は`Player not found`となり、送信者残高は75 WMのまま、受取人Accountも作成されなかった。
5. Main Consoleから1 WMを付与すると共有残高は76 WMになった。
6. Frontierでは76 WMを表示できた。
7. Main／FrontierのPlaceholderAPI経由でも`76 WM`を取得できた。
8. Minecraft NetworkとRedis Containerを正常停止・再起動しても76 WMが維持された。
9. Test終了時に76 WMを正規のRedisEconomy管理Commandで減算し、Main／FrontierおよびRedis上で0 WMを確認した。

Redis Dataを直接書き換えず、`FLUSHDB`／`FLUSHALL`も実行していません。試験用Player名とUUIDは公開Reportから除外しています。

Persistence確認時はRedis AOFが有効で、再起動後も残高が維持されました。作成されたKeyは`clusterId: waymark`に対応するRedisEconomyの残高、Account mapping、Transaction counterおよび当該Test transactionだけでした。

## 7. Observed symptom

ClientおよびConsoleで次の差がありました。

| Location | Command / operation | Result |
| --- | --- | --- |
| Lobby | `/balance` | Command自体が存在しない。設計どおり |
| Main | `/balance` | Commandは登録済みだが表示なし |
| Main | `/balance <player>` | Commandは登録済みだが表示なし |
| Main Console | Balance照会／管理Command | Data処理は行われるが応答表示なし |
| Frontier | `/balance` | 残高を正常表示 |
| Frontier Console | Balance照会／管理Command | 応答を正常表示 |

MainではCommand usage、Version情報およびPlaceholderAPI Console parse等、RedisEconomyのLanguage送信経路を通らない出力は表示されました。その一方、`balance`、`balanceOther`、`playerNotFound`および管理結果等、RedisEconomyの`Langs.send`を通る応答が一律に消失しました。

## 8. Investigation history

### 8.1 Config completeness comparison

Exact Plugin Versionが初回生成したConfigを基準にMain／Frontierを比較しました。

- Main／FrontierのRedisEconomy Config差分は意図した`clientName`だけだった。
- `lang: en-US`は両方で同一だった。
- `en-US.yml`は両方に存在し、File内容の差分はなかった。
- Default currency名とCurrencies listが一致していた。
- RedisEconomy 4.5.12が生成しないConfig keyを追加していなかった。
- VaultのConfigは両方とも`update-check: false`だけで同一だった。
- Secret tokenはTemplate内に正確に1回だけ存在し、Render後に残存していなかった。
- Runtime ConfigはGit ignore対象だった。

結論: Config欠落、ServerごとのLanguage差およびTemplate render失敗を除外。

### 8.2 Command and permission comparison

- Main／Frontierの`/help balance`は同じUsageを表示した。
- `/money` aliasも両方で同一だった。
- `rediseconomy.balance`は許可されていた。
- `rediseconomy.pay`は許可されていた。
- Permission不足時のMessageではなく、Command処理後のResponseだけが消失した。
- `commands.yml`にRedisEconomyと競合するAliasはなかった。
- 同名Economy providerや重複JARはなかった。

結論: 未登録Command、Permission不足、Alias競合および重複Pluginを除外。

### 8.3 Log inspection

Command実行前後のMain Logを確認しました。

- Redis接続Errorなし。
- Command execution Exceptionなし。
- Adventure／MiniMessage parse Exceptionなし。
- Vault provider Errorなし。
- Redis transaction失敗なし。
- Server threadのSEVEREなし。

Frontierでは同じCommandが同じLanguage entryから正常に表示されました。

結論: Errorにより途中終了する経路ではなく、無言で終了するMessage経路を疑う根拠となった。

### 8.4 Other-Plugin isolation

Repository内の一時Directoryを使用し、Main Paper 26.2を次のPluginだけで起動しました。

- RedisEconomy 4.5.12
- VaultUnlocked 2.20.2

Redis、Vault providerおよびCommand registrationは成功しましたが、Balance照会、存在しないPlayerの照会およびRedisEconomy管理CommandのLanguage応答は引き続き表示されませんでした。ERRORまたはExceptionもありませんでした。

結論: LuckPerms、PlaceholderAPI、TAB-Bridge、mcMMO、WorldEdit、WorldGuard、Multiverse等の干渉を除外。

### 8.5 MiniMessage isolation

上記の一時最小構成で、`en-US.yml`の関連Messageを一時的に装飾なしのPlain textへ変更しました。

```yaml
playerNotFound: PLAIN PLAYER NOT FOUND
balance: PLAIN BALANCE %balance_short%
balanceOther: PLAIN BALANCE OTHER %player% %balance_short%
```

それでもMainでは何も表示されませんでした。試験後、一時DirectoryはRepository内であることを検証して削除しました。追跡対象のLanguage fileは変更していません。

結論: MiniMessage tag、色指定、改行およびLanguage text内容を除外。

### 8.6 JAR and dependency inspection

RedisEconomy JARをZIP/JARとして読み、ClassとPlugin metadataを確認しました。

- `dev/unnm3d/shaded/kyori/adventure/platform/bukkit/BukkitAudiences.class`を同梱。
- Adventure Platform packageはRedisEconomy namespaceへRelocateされている。
- Adventure API、MiniMessageおよびSerializer APIへの呼出しはServer側の非Relocate classを使用する。
- Upstream `build.gradle`は`adventure-platform-bukkit:4.4.1`をImplementation dependencyとしている。
- Upstream buildは`adventure-api`とMiniMessage等をShadow JARから除外している。

これにより、Platform bridgeはPlugin同梱4.4.1、Core Adventure APIは実行中PaperのVersionという組合せになることを確認しました。

### 8.7 RedisEconomy Message code

`javap -c -p`でRedisEconomy 4.5.12の`dev.unnm3d.rediseconomy.config.Langs`を確認しました。Message送信は次の実装に相当します。

```java
audiences.sender(sender).sendMessage(
    MiniMessage.miniMessage().deserialize(text)
);
```

同梱されるAdventure Platform 4.4.1の`FacetAudience`は、Adventure 4系の旧dispatch targetである次のSignatureを実装しています。

```text
sendMessage(Identity, Component, MessageType)
```

### 8.8 Adventure API comparison

MainとFrontierが実際に展開したAdventure API JARを`javap`で比較しました。

#### Frontier / Adventure API 4.26.1

`Audience.sendMessage(Component)`は`MessageType.SYSTEM`を付与し、旧`sendMessage` overloadへ転送します。RedisEconomy同梱`FacetAudience`のOverrideへ到達するため、Messageが送信されます。

概略:

```text
Audience.sendMessage(Component)
  -> sendMessage(Component, MessageType.SYSTEM)
  -> sendMessage(Identity.nil(), Component, MessageType)
  -> FacetAudience override
  -> Player / Consoleへ送信
```

#### Main / Adventure API 5.2.0

`Audience.sendMessage(Component)`のBytecodeは次のとおりでした。

```text
public default void sendMessage(Component);
  Code:
     0: return
```

RedisEconomy同梱`FacetAudience`はAdventure 5のこのExact SignatureをOverrideしていません。そのため、RedisEconomyの呼出しはDefault no-opで終了します。

概略:

```text
Audience.sendMessage(Component)
  -> Adventure 5 default implementation
  -> return
  -> Message未送信、Exceptionなし
```

## 9. Root cause

根本原因は次の組合せです。

1. RedisEconomy 4.5.12がAdventure Platform Bukkit 4.4.1を同梱する。
2. Adventure Core APIはJARへ同梱せず、実行中PaperのAPIを使用する。
3. 同梱4.4.1の`FacetAudience`はAdventure 4の旧Message overloadを実装する。
4. Paper 26.2はAdventure API 5.2.0を提供する。
5. Adventure 5.2.0の`Audience.sendMessage(Component)`は、旧overloadへ転送せずDefault no-opとなっている。
6. RedisEconomyの`Langs.send`がExact methodをOverrideしていないAudience objectへ`sendMessage(Component)`を呼ぶ。

このため、Paper 26.2上ではRedisEconomyのLanguage Messageだけが例外なしに消失します。Redis処理、Vault providerおよびPlaceholderAPI expansionは別経路のため動作します。

## 10. Why the published compatibility claim was insufficient

RedisEconomy 4.5.12のSpigotMC更新情報には、26.1および26.2対応と明記されています。この表記自体は確認済みです。

- RedisEconomy updates: https://www.spigotmc.org/resources/rediseconomy%E2%9A%A1-unlimited-currencies-cross-server-open-source.105965/updates
- RedisEconomy source: https://github.com/Emibergo02/RedisEconomy
- Build dependency declaration: https://github.com/Emibergo02/RedisEconomy/blob/main/build.gradle
- Message implementation: https://github.com/Emibergo02/RedisEconomy/blob/main/src/main/java/dev/unnm3d/rediseconomy/config/Langs.java

今回の結果は「Plugin全体がPaper 26.2でLoadしない」という問題ではありません。PluginはEnableされ、Redis、Vault、Command registrationおよびPlaceholderは動作します。Compatibility claimだけでは検出しにくい、利用者向けMessage dispatchに限定された互換性Gapです。

## 11. Configuration omissions review

設定で修正可能な漏れがないか、最後に再確認しました。

| Candidate | Finding | Decision |
| --- | --- | --- |
| Language file不足 | 両Backendに同一Fileあり | 除外 |
| `lang`名不一致 | 両方`en-US` | 除外 |
| Message text不正 | Plain textでも再現 | 除外 |
| Currency名不一致 | `defaultCurrencyName`とListが一致 | 除外 |
| Redis namespace不一致 | 同じ`clusterId`で共有成功 | 除外 |
| Permission不足 | Required permissionは許可 | 除外 |
| Console output抑制 | Free 4.5.12生成Configに該当Keyなし。Playerでも再現 | 除外 |
| Command alias競合 | Main／Frontierで同じ登録、競合なし | 除外 |
| Vault未登録 | Legacy provider登録成功 | 除外 |
| 他Plugin干渉 | 2 Plugin最小構成で再現 | 除外 |
| Server restart不足 | Clean restart後も再現 | 除外 |

設定変更だけで解消できる項目は見つかりませんでした。

## 12. Impact assessment

### 正常に動作するもの

- Main／Frontierの共有Redis残高
- Redis認証と接続
- Redis AOF Persistence
- Vault Legacy Economy provider
- PlaceholderAPI経由の残高取得
- Console管理Commandによる残高変更そのもの
- Frontier上のRedisEconomy Message

### 影響を受けるもの

- Main上の`/balance`等のRedisEconomy Language response
- Main Console上の同じMessage経路
- Main上で成功、失敗、Permission以外の結果を利用者へ通知するRedisEconomy Command
- EconomyShop等を導入する前提となるMainの基本受入試験

### Data integrity

調査範囲では残高の欠落、二重加算、Rollbackまたは不正Account作成はありませんでした。ただし利用者へ結果が表示されない状態では誤操作や重複操作を誘発するため、運用受入は不可とします。

## 13. Upstream report package

上流作者へは次の内容で再現報告できます。

### Environment

```text
RedisEconomy: 4.5.12
Paper: 26.2 build 62
Java: 25.0.3 64-bit
Adventure API supplied by Paper: 5.2.0
VaultUnlocked: 2.20.2
Redis: authenticated standalone Redis 8
```

### Minimal reproduction

1. Paper 26.2 build 62へRedisEconomy 4.5.12とVaultUnlocked 2.20.2だけを配置する。
2. 生成されたRedisEconomy Configへ有効なRedis接続を設定する。
3. Serverを起動し、Redis接続とVault provider登録成功を確認する。
4. `/balance`、`/balance <player>`またはConsoleのBalance照会を実行する。

Expected: Language fileで定義された残高またはError Messageが送信される。

Actual: Commandは登録されData処理も動作するが、Messageが表示されずExceptionも出ない。

Control: 同じRedisEconomy／Vault JARとConfigをPaper 1.21.11 build 132で実行するとMessageが表示される。

### Technical evidence

- `Langs.send` calls `Audience.sendMessage(Component)`.
- RedisEconomy shades Adventure Platform Bukkit 4.4.1 but excludes Adventure API.
- Its `FacetAudience` implements the Adventure 4 message overload.
- Paper 26.2 supplies Adventure API 5.2.0.
- In Adventure 5.2.0, `Audience.sendMessage(Component)` is a default no-op unless the concrete Audience overrides that exact method.
- The bundled Adventure Platform 4.4.1 Audience does not override the exact Adventure 5 method.

## 14. Recommended resolution and outcome

調査時に定めた優先順は次のとおりです。

1. RedisEconomy作者へ本Reportの最小再現とBytecode差を報告する。
2. Adventure 5対応の正式Releaseまたは作者提供の検証可能な修正版を待つ。
3. Userが修正版JARを`manual-downloads/`へ手動配置する。
4. JAR metadata、Source、License、SHA-256および対象Versionを再検証する。
5. Main／Frontierへ同一修正版を配置し、下記Exit criteriaを再実施する。

ユーザーが別Repository／手順で作成した検証可能な互換Buildを手動配置したため、手順3から5を完了しました。Project Wayfarer Repository内へPlugin SourceやBuild Projectは追加していません。

## 15. Exit criteria for a fixed build

- MainとFrontierの両方で`/balance`が値を表示する。
- 存在しないPlayerへの照会または支払いが明確なErrorを表示する。
- Main ConsoleとFrontier Consoleの管理結果が表示される。
- Main／Frontierで残高が同一になる。
- LobbyにEconomy Commandが存在しない。
- PlaceholderAPIとVault providerが引き続き正常に動作する。
- Redis再起動とMinecraft Network再起動後も残高が維持される。
- Startup、Command実行およびShutdownに重大なERROR、SEVEREまたはExceptionがない。
- Test残高とTest accountを正規CommandでCleanupできる。
- JAR、Secret、Log、World、CacheおよびRuntime DataがGitへStageされない。

## 16. Repository state at report creation

- Waymark Integration変更は未Commit・未Push。
- RedisEconomyおよびVaultUnlocked JARはGit ignore対象。
- Runtime RedisEconomy ConfigとCredentialはGit ignore対象。
- 調査用最小構成Directoryは検証後に削除済み。
- このReportは秘密情報、Player名、UUIDおよび未加工Logを含まない。
- 最終的なEconomy Integration Commitは、修正版で必須受入試験が完了するまで作成しない方針とした。

## 17. Fixed-build verification (2026-07-19)

### 17.1 Artifact差分

ユーザー提供Artifactを通常のJARとして読み、`plugin.yml`、Entry一覧およびEntry単位のSHA-256を正式版4.5.12と比較しました。

- Reported Version: `4.5.12-wayfarer.1`
- Main Class、CommandおよびPermission metadata: 正式版から変更なし
- Added entries: 0
- Removed entries: 102（relocated Adventure Platform bridgeのClass／Directory entriesと、そのModule metadata）
- Changed entries: 10
  - `Langs.class`と関連Inner Class 3件
  - `plugin.yml`
  - de／es／fr／it／zh Language resource 5件（改行正規化後の意味内容は同一）
- `Langs.send`: Paper APIの`CommandSender.sendRichMessage(String)`を使用
- Main／FrontierのRuntime JAR: 同一SHA-256
- 旧版または重複RedisEconomy Runtime JAR: なし

Paper 26.2とPaper 1.21.11の両方が採用Methodを提供することも確認しました。JARはユーザーが`manual-downloads/economy/`へ配置したものであり、CodexはDownloadしていません。

### 17.2 Isolated startup

MainとFrontierを個別に全Plugin構成で起動し、次を双方で確認しました。

- RedisEconomy `4.5.12-wayfarer.1`がEnable
- Redisへ接続
- VaultUnlocked 2.20.2がEnable
- Vault Legacy Economy providerとして`vault`通貨を登録
- Consoleの残高照会が`0 WM`を表示
- 存在しないPlayerの照会が`Player not found!`を表示
- RedisEconomy／Vault由来の重大なERROR、SEVEREまたはExceptionなし
- Console `stop`による正常停止

### 17.3 Network and client smoke test

Lobby、Main、Frontier、Velocityを通常順で起動しました。Consoleの正規管理CommandでTest Playerを一時的に10 WMとし、Mainで10 WM、通常のVelocity切替後のFrontierでも10 WMを確認しました。Mainでは正式版で消失していた残高応答と存在しないPlayerの応答が表示され、Frontierでも同じ結果でした。ユーザーはMinecraft 26.2 Clientで両Backendの表示と接続に問題がないことを確認しました。

Frontierの正規管理Commandで10 WMを減算し、FrontierとMainの双方で0 WMを確認しました。Redis Keyの直接編集、`FLUSHDB`または`FLUSHALL`は行っていません。

### 17.4 Restart verification

全Minecraft Componentを正常停止後に再起動し、Main／Frontierの双方で次を再確認しました。

- RedisEconomy `4.5.12-wayfarer.1`の再Enable
- Vault Legacy providerの再登録
- 残高0 WMの共有状態
- Mainの残高応答と`Player not found!`応答
- Startup／Shutdownに重大なRedisEconomy／Vault Errorなし

修正範囲はMessage送信経路に限定され、共有残高およびRedis AOF永続性は正式版4.5.12を用いた同一Integration試験で、通常Network再起動と停止中のRedis Container再起動を通して76 WMを維持済みです。Compatibility BuildでのNetwork再起動後も同じData経路とProviderが正常に再接続しました。

### 17.5 Resolution

Section 15の固定Build Exit Criteriaは満たされました。正式版4.5.12の互換性Gapと調査履歴は将来のUpstream更新比較のため残し、Project Wayfarerの採用Buildは`versions.yml`と`plugin-manifest.yml`にHash固定で記録します。調査ReportとIntegration変更は、この時点ではまだCommit／Pushしていません。
