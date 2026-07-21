# Project Wayfarer Waymark価格体系改定・EvenMoreFish Shop有効化 Codex指示書

## 1. 目的

Project Wayfarer Ver.0.0.5のWaymark経済について、現在の価格体系を100倍の名目値へ移行し、EvenMoreFish 2.4.3の魚売却GUIを有効化する。

本タスクで実施する。

1. EconomyShopGUIの既存62商品の価格を一律100倍する。
2. 現在の相対価格、売買差およびカテゴリ構成を維持する。
3. EvenMoreFishのVault Economyを有効にする。
4. EvenMoreFishのレアリティ別売却倍率をProject Wayfarer向けに設定する。
5. 一般PlayerへMain Context限定で`/emf shop`を開放する。
6. EvenMoreFish Main MenuへFish Shopボタンを戻す。
7. 魚売却以外の直接WM報酬を無効化する。
8. Economy／Permission／Manifest／Play Guide／Roadmapを実態へ更新する。
9. V0.1.0直前に実施するWM・Player状態初期化を、将来の別タスクとしてRoadmapへ追加する。

本タスクで実施しない。

- 全PlayerのWaymark残高変更
- 現在のWaymark残高の100倍Migration
- Waymark残高の一括0 Reset
- Inventory Reset
- EXP Reset
- Advancement Reset
- Ender Chest Reset
- mcMMO Reset
- EvenMoreFish Journal Reset
- Player Data削除
- Redis Key直接編集
- EconomyShopGUIでの実際の購入／売却試験
- EconomyShopGUIの価格以外の構成変更
- 新しいEconomyShopGUI商品またはカテゴリ追加
- Fishの購入機能
- `/emf sellall`の開放
- Competition報酬
- Bait購入
- Frontier報酬
- Dynamic Pricing
- Global Stock
- Player Shop
- Tax
- 独自Plugin実装
- V0.1.0 Release宣言

---

## 2. 開始Baseline

最新`main`を取得する。

少なくとも次のCommitを含むことを確認する。

```text
b77d3be4746a464261f64336c0e668041257eae0
Phase 4 EvenMoreFish Integration実装Commit
```

現行Baseline：

- Document revision：Ver.0.0.5
- Target server release：V0.1.0 Alpha（未達）
- EconomyShopGUI：7.1.1 Free、Main限定
- RedisEconomy：4.5.12-wayfarer.1
- VaultUnlocked：2.20.2
- EvenMoreFish：2.4.3、Main限定
- EvenMoreFish Journal：専用MariaDB
- EvenMoreFish Economy：現在無効
- EvenMoreFish Competition：無効
- EvenMoreFish Hunting：無効
- EvenMoreFish Lava／Void Fishing：無効
- mcMMO Fishing XP：維持
- mcMMO Loot：EvenMoreFish Catch時は無効
- 一般Playerの`emf.shop`：現在未付与

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
- Main Runtime状態
- EconomyShopGUI Configの現行価格
- EvenMoreFish Runtime Rarity Files
- EvenMoreFish `config.yml.template`
- EvenMoreFish Runtime `config.yml`
- EvenMoreFish `gui/main.yml`
- LuckPermsの現在の`default` Group Main Context
- `.gitignore`
- `docs/10-waymark-economy.md`
- `docs/12-permission-model.md`
- `docs/09-roadmap.md`
- `plugin-manifest.yml`
- `versions.yml`
- `codex/README.md`

既存変更を破棄しない。

禁止：

- `git reset --hard`
- `git clean`
- Force Push
- History Rewrite
- `/reload`
- PlugManX Reload
- Redis Key直接編集
- EconomyShopGUI／RedisEconomy／VaultUnlocked／EvenMoreFishのVersion変更
- Development Buildへの変更
- JARの取得・置換
- 他者の未Commit変更の上書き
- 実価格を推測で変更すること
- 全残高Reset
- Player Data Reset
- V0.1.0完成扱い

---

## 3. Git／Push方針

本タスクは既存`main` Branchへの直接Commit／Pushであり、Pull Requestを作成しない。

GitHub CLI（`gh`）は不要である。

次を行わない。

```text
gh --version
where.exe gh
Get-Command gh
GitHub CLIの検索
GitHub CLIのインストール
PR作成
```

GitHub CLIが存在しないことをWarningまたはBlocking事項として扱わない。

通常のGit Commandを使用する。

```powershell
git add <approved-files>
git commit -m "feat: Waymark価格体系と魚売却を改定"
git push
git rev-parse HEAD
git status -sb
```

GitHub CLIを確認するのは、Pull Request、Issue、GitHub Release等が個別タスクで明示された場合だけとする。

---

# 4. Waymark価格体系の改定方針

## 4.1 名目単位

既存のEconomyShopGUI価格をすべて100倍する。

```text
new_price = old_price × 100
```

目的：

- 最小価格0.01 WMを1 WMへ移行する。
- 通常Itemを整数中心の価格へする。
- EvenMoreFishのサイズ連動価格を扱いやすい桁へ揃える。
- 現在の相対価値と売買差を維持する。
- 既存の裁定条件を変えない。

変更しない。

- 通貨ID：`waymark`
- 表示名：Waymark
- 記号：WM
- RedisEconomy Currency Key：`vault`
- 初期残高：0
- Main／Frontier共有
- EconomyShopGUI Category
- Item数
- Buy／Sell方向
- Shop権限
- Dynamic Pricing無効
- Global Stock無効
- Player Shop無効
- Tax無効

## 4.2 現在の残高

実運用残高はまだ存在しないため、本タスクではMigrationを行わない。

禁止：

- Player残高を100倍する
- 全Player残高を0にする
- Test残高を一括操作する
- Redisを直接編集する

本タスク中の1件の魚売却試験で発生したTest残高だけは、試験前の値へ戻してよい。

---

# 5. EconomyShopGUI改訂価格表

すべて1 ItemあたりのWM価格とする。

## 5.1 資源売却 `sell_resources`

| Material | Sell |
|---|---:|
| DIRT | 1.00 |
| COBBLESTONE | 2.00 |
| COBBLED_DEEPSLATE | 3.00 |
| SAND | 4.00 |
| GRAVEL | 3.00 |
| OAK_LOG | 8.00 |
| SPRUCE_LOG | 8.00 |
| BIRCH_LOG | 8.00 |
| JUNGLE_LOG | 8.00 |
| ACACIA_LOG | 8.00 |
| DARK_OAK_LOG | 8.00 |
| MANGROVE_LOG | 8.00 |
| CHERRY_LOG | 8.00 |
| PALE_OAK_LOG | 8.00 |
| COAL | 10.00 |
| RAW_COPPER | 8.00 |
| RAW_IRON | 25.00 |
| RAW_GOLD | 50.00 |
| REDSTONE | 4.00 |
| LAPIS_LAZULI | 5.00 |
| DIAMOND | 400.00 |
| QUARTZ | 3.00 |

## 5.2 農業品売却 `sell_farming`

| Material | Sell |
|---|---:|
| WHEAT | 2.00 |
| CARROT | 2.00 |
| POTATO | 2.00 |
| BEETROOT | 2.00 |
| NETHER_WART | 2.00 |
| SUGAR_CANE | 3.00 |

## 5.3 Mob素材売却 `sell_mob_drops`

| Material | Sell |
|---|---:|
| BONE | 3.00 |
| ROTTEN_FLESH | 3.00 |
| STRING | 4.00 |
| GUNPOWDER | 8.00 |
| ENDER_PEARL | 20.00 |
| BLAZE_ROD | 35.00 |
| SHULKER_SHELL | 200.00 |

## 5.4 建築資材購入 `buy_building`

| Material | Buy |
|---|---:|
| DIRT | 8.00 |
| COBBLESTONE | 12.00 |
| COBBLED_DEEPSLATE | 18.00 |
| SAND | 25.00 |
| GRAVEL | 20.00 |
| OAK_LOG | 40.00 |
| SPRUCE_LOG | 40.00 |
| BIRCH_LOG | 40.00 |
| JUNGLE_LOG | 40.00 |
| ACACIA_LOG | 40.00 |
| DARK_OAK_LOG | 40.00 |
| MANGROVE_LOG | 40.00 |
| CHERRY_LOG | 40.00 |
| PALE_OAK_LOG | 40.00 |
| STONE_BRICKS | 20.00 |
| GLASS | 30.00 |
| BRICKS | 35.00 |
| TERRACOTTA | 40.00 |
| WHITE_WOOL | 50.00 |

## 5.5 生活用品購入 `buy_supplies`

| Material | Buy |
|---|---:|
| TORCH | 8.00 |
| LANTERN | 60.00 |
| BREAD | 30.00 |
| BONE_MEAL | 10.00 |
| REDSTONE | 25.00 |
| COAL | 50.00 |
| IRON_INGOT | 200.00 |
| GOLD_INGOT | 400.00 |

---

# 6. EconomyShopGUI変更

実際のRepository Pathを確認し、既存5 Shop Fileだけを編集する。

想定：

```text
servers/main/plugins/EconomyShopGUI/shops/sell_resources.yml
servers/main/plugins/EconomyShopGUI/shops/sell_farming.yml
servers/main/plugins/EconomyShopGUI/shops/sell_mob_drops.yml
servers/main/plugins/EconomyShopGUI/shops/buy_building.yml
servers/main/plugins/EconomyShopGUI/shops/buy_supplies.yml
```

変更内容：

- 各既存価格を正確に100倍する。
- Materialを変更しない。
- Item Keyを変更しない。
- Categoryを変更しない。
- GUI Rowを変更しない。
- Product数を変更しない。
- Buy／Sell方向を変更しない。
- Lore、Display、Permissionを不要に変更しない。
- 新しいItemを追加しない。
- FishをEconomyShopGUIへ登録しない。

検査：

- 変更前価格と変更後価格の対応表をScriptまたは一時処理で比較する。
- 62商品すべてが正確に100倍である。
- Overlap Itemは`buy > sell`を維持する。
- YAMLがParse可能。
- 全Material IDがPaper 26.2で有効。
- 既存Shop Section数が不変。
- 明白なCraft／Smelt／Stonecutting裁定条件が悪化していない。
- 価格以外のDiffがない、または必要な整形差だけである。

一時比較Scriptは、将来の保守価値がない限りCommitしない。

---

# 7. EvenMoreFish売却価格

## 7.1 計算式

EvenMoreFishの通常魚は次で売却価格を決める。

```text
売却価格 = 魚のサイズ × Rarity worth-multiplier × Vault multiplier
```

Vault multiplier：

```yaml
multiplier: 1.0
```

## 7.2 採用Rarity倍率

| Rarity | Weight | Size Range | worth-multiplier | Price Range |
|---|---:|---:|---:|---:|
| Junk | 5 | Sizeなし | 0.0 | 売却不可 |
| Common | 100 | 1～30 | 1.0 | 1～30 WM |
| Rare | 10 | 20～150 | 0.5 | 10～75 WM |
| Epic | 3 | 125～800 | 0.3 | 37.5～240 WM |
| Legendary | 1 | 800～4000 | 0.2 | 160～800 WM |

価格範囲はConfig上のSize境界から算出した参考値である。

実際の売却表示はEvenMoreFishの丸め・表示規則へ従う。

本タスクで独自の丸めPluginまたは価格丸め処理を追加しない。

## 7.3 価格の位置付け

目安：

- Common平均：石炭10 WMと原鉄25 WMの間
- Rare平均：原金50 WM付近
- Epic平均：シュルカーの殻200 WMより低い
- Legendary平均：ダイヤモンド400 WMを少し上回る
- Legendary最大：ダイヤモンド2個相当

高RarityでもSizeによって価格が変わるため、Rarity間の価格範囲の一部重複は許容する。

---

# 8. EvenMoreFish Config変更

Sanitized Template：

```text
servers/main/plugins/EvenMoreFish/config.yml.template
```

Runtime Config：

```text
servers/main/plugins/EvenMoreFish/config.yml
```

Runtime ConfigはGit Ignoreを維持する。

## 8.1 Vault Economy

次へ変更する。

```yaml
economy:
  vault:
    enabled: true
    multiplier: 1.0
  playerpoints:
    enabled: false
    multiplier: 1.0
  griefprevention:
    enabled: false
    multiplier: 1.0
```

変更しない。

- RedisEconomy Provider
- VaultUnlocked
- Database設定
- Locale
- World Scope
- Fishing Scope
- Competition
- Hunt
- Lava／Void Fishing
- mcMMO境界
- Item Protection
- Sell GUI exit behavior

維持：

```yaml
sell-gui:
  sell-over-drop: false
```

GUIを閉じたときに自動売却しない。

## 8.2 Rarity Files

Runtimeで生成済みの正確なFilenameとRarity IDを確認する。

期待するFile：

```text
servers/main/plugins/EvenMoreFish/rarities/junk.yml
servers/main/plugins/EvenMoreFish/rarities/common.yml
servers/main/plugins/EvenMoreFish/rarities/rare.yml
servers/main/plugins/EvenMoreFish/rarities/epic.yml
servers/main/plugins/EvenMoreFish/rarities/legendary.yml
```

実Filenameが異なる場合は推測で新規Fileを作成せず、RuntimeでLoadされているFileを使用する。

変更：

```yaml
# Junk
worth-multiplier: 0.0

# Common
worth-multiplier: 1.0

# Rare
worth-multiplier: 0.5

# Epic
worth-multiplier: 0.3

# Legendary
worth-multiplier: 0.2
```

原則として変更しない。

- Rarity ID
- Weight
- Size
- Fish一覧
- Fish Material
- Requirements
- Broadcast
- Catch Type
- Sort Index
- Journal
- Custom Model
- Fish名

ただし、Vault有効化によって魚売却以外の直接通貨報酬が有効になる項目は除去する。

---

# 9. 魚売却以外のMONEY報酬を禁止

Vault Economyを有効化すると、Vendor Defaultに含まれる`MONEY` Rewardが利用可能になる。

本タスクで許可するWM供給源：

```text
EvenMoreFishのFish Shopによる魚売却だけ
```

許可しない。

- Catch Eventによる直接MONEY
- Interact Eventによる直接MONEY
- Eat Eventによる直接MONEY
- Competition Reward MONEY
- Bait Reward MONEY
- Coin Flip MONEY
- Command経由の通貨付与
- Example ConfigのMONEY
- Sell Eventからの追加MONEY Reward
- PlayerPoints
- Claim Blocks

RuntimeのEvenMoreFish Directoryを検索する。

対象文字列例：

```text
MONEY
money
VAULT
vault
ECONOMY
economy
```

Secret-bearing Main Configの正規Economy Sectionは除外して評価する。

## 9.1 Coinfish

Vendor Default Epic Rarityには、Coinfishの直接MONEY Interactionが含まれる可能性がある。

期待されるVendor例：

```yaml
Coinfish:
  item:
    material: SUNFLOWER
    lore:
    - Gives $50 when flipped
  requirements:
    reward-type: MONEY
  interact-event:
  - MONEY:50
```

Project Wayfarerでは、Coinfishを通常のEpic Fishとして残してよいが、直接WM報酬を除去する。

実施：

- `interact-event`の`MONEY:50`を除去する。
- `requirements.reward-type: MONEY`を除去する。
- `$50`を与えると記載したLoreを削除または通常の装飾Loreへ置換する。
- Rarity、Material、名称、通常売却対象としての性質は維持する。
- Coinfishを別の通貨源にしない。

他にも直接MONEY項目が存在する場合、同じ方針で無効化する。

Example Competitionは既に無効であり、実Competitionとして登録しない。

直接MONEY項目が予想以上に多い場合は自動修正を続けず、一覧をユーザーへ報告する。

---

# 10. Rarity Config追跡

現在`.gitignore`はRarity Directory全体をIgnoreしている。

Project採用価格を正本化するため、5つの採用Rarity Fileだけを追跡する。

現在のようなDirectory全体Ignore：

```gitignore
servers/main/plugins/EvenMoreFish/rarities/
```

を、実Filename確認後にExact FileをUnignoreできる形へ変更する。

想定：

```gitignore
servers/main/plugins/EvenMoreFish/rarities/*
!servers/main/plugins/EvenMoreFish/rarities/junk.yml
!servers/main/plugins/EvenMoreFish/rarities/common.yml
!servers/main/plugins/EvenMoreFish/rarities/rare.yml
!servers/main/plugins/EvenMoreFish/rarities/epic.yml
!servers/main/plugins/EvenMoreFish/rarities/legendary.yml
```

追跡する5 FileにはSecretが含まれないことを確認する。

追跡しない。

- `_example.yml`
- Addon Rarity
- Generated Backup
- Cache
- Data
- Runtime DB
- Secret
- Debug Dump

追跡するRarity Fileは現在のEvenMoreFish 2.4.3 Runtimeから取得し、Price Policyと直接MONEY無効化以外を不要に再整形しない。

---

# 11. EvenMoreFish Main GUI

現在のMain MenuからShop Buttonが除外されている。

次を追加する。

Layout：

```yaml
layout:
- '126515621'
- '23     32'
- '4 t s h 4'
- '4  j b  4'
- '23     32'
- '1265x5621'
```

Shop Button：

```yaml
open-shop:
  item:
    material: gold_ingot
    displayname: <gold>» Open Fish Shop
    lore:
    - ''
    - <gray>Sell the fish you catch to
    - <gray>earn Waymark.
    - ''
  character: s
  click-action: open-shop
```

既存GUIのLanguage／Styleへ合わせて、日本語化してもよい。

ただし、`click-action: open-shop`と`character: s`は採用Versionの正式Actionを使用する。

変更しない。

- Fish Toggle
- Help
- Bait
- Journal
- Exit
- GUI Version Key

`version`を変更しない。

---

# 12. Permission

一般PlayerへMain Context限定で次を追加する。

```text
emf.shop
```

対象：

```text
group.default
server=main
```

確認する。

- `emf.shop = true` on `server=main`
- Lobby／Frontier／VelocityではGlobal付与なし
- `emf.sellall`は未付与
- `emf.admin`は未付与
- Debug Database Permission未付与
- Builderへ管理Permission追加なし
- Temporary AdminはGlobal `*`で管理可能
- OP不要

既存のEvenMoreFish Player Permissionは維持する。

`docs/12-permission-model.md`の`default` Group Authorityを更新する。

EconomyShopGUIの既存6 Permissionは変更しない。

---

# 13. EconomyShopGUI受入確認

デバッグおよび実売買試験は最小限にする。

## 13.1 Static確認

必須：

- 62商品の価格が正確に100倍。
- Category数不変。
- Product数不変。
- Buy／Sell方向不変。
- YAML Parse成功。
- Material Validation成功。
- Buy／Sell Spread維持。
- 価格以外の意図しないDiffなし。
- `docs/10-waymark-economy.md`とConfigが一致。

## 13.2 Runtime確認

Mainを正常Restartする。

一般PlayerまたはTemporary AdminでEconomyShopGUIを開く。

確認する。

- Shop GUIが開く。
- 5 Categoryが表示される。
- 各Categoryの代表Item 1件で新価格表示を確認する。
- Consoleに起動Blocking ERROR／SEVERE／Exceptionなし。

代表候補：

```text
sell_resources: DIAMOND 400 WM
sell_farming: WHEAT 2 WM
sell_mob_drops: SHULKER_SHELL 200 WM
buy_building: OAK_LOG 40 WM
buy_supplies: IRON_INGOT 200 WM
```

実施しない。

- Item購入
- Item売却
- WM残高前後比較
- Inventory満杯試験
- 62 ItemすべてのGUI目視
- `/sellall`
- Sell GUI
- Editor
- Reload
- Transaction Log試験
- Redis直接確認
- 広範なRegression

EconomyShopGUIは、価格がConfigとGUIへ反映されたことだけをRuntimeで確認すればよい。

---

# 14. EvenMoreFish受入確認

## 14.1 Static確認

- Vault Economy有効。
- Vault multiplier 1.0。
- PlayerPoints無効。
- GriefPrevention無効。
- 5 Rarity倍率が採用値。
- Junk売却不可。
- Fish Shop Button追加。
- `emf.shop` Main Context付与。
- `emf.sellall`未付与。
- 直接MONEY Rewardなし。
- Competition無効。
- Hunt無効。
- Lava／Void無効。
- World Scope不変。
- MariaDB不変。
- mcMMO境界不変。

## 14.2 GUI確認

Roleなし一般Playerで確認する。

- `/emf gui`が開く。
- Fish Shop Buttonが表示される。
- Shop Buttonから売却GUIが開く。
- `/emf shop`でも売却GUIが開く。
- `/emf sellall`は拒否される。
- Admin Commandは拒否される。

## 14.3 魚1件の実売却

EvenMoreFishは実際の魚を1つだけ売却して確認する。

魚の取得方法：

1. 既存の正常な自然Catch Fishがある場合はそれを使用する。
2. なければTemporary AdminでCommon Fishを1個だけ発行する。
3. 発行後はAdmin Roleを解除し、一般Player権限で売却する。

推奨：

```text
Common Fish 1個
```

手順：

1. 試験Playerの売却前残高をCleanup用に内部記録する。
2. `/emf shop`またはMain GUIのShop Buttonを開く。
3. EvenMoreFish Fishを1個だけ売却Slotへ置く。
4. 売却操作を確定する。
5. Fish ItemがInventoryから除去されたことを確認する。
6. 売却成功MessageまたはGUI Feedbackを確認する。
7. ConsoleにExceptionがないことを確認する。
8. Test Playerの残高をRedisEconomyの正式Admin Commandで売却前値へ戻す。
9. 残ったTest Fishを削除する。
10. Temporary Admin Parentを解除する。

受入条件として要求しない。

- 売却後の正確なWM残高
- 計算式と実残高の厳密一致
- 全Rarity売却
- 最小／最大Size売却
- Junk売却
- Multiple Fish
- Stack売却
- Inventory満杯
- Reconnect
- Restart中Transaction
- `/emf sellall`
- Shop exit auto-sell
- EconomyShopGUIとの同時Transaction
- Redis AOF確認
- MariaDB Row確認

売却が成功し、Fishが消費され、Errorがなければ代表機能確認として十分とする。

## 14.4 Restart

設定変更後はMainを正常Restartする。

確認する。

- EconomyShopGUI Enable
- EvenMoreFish Enable
- Vault Provider認識
- Fish Shop GUI Open
- Competition開始なし
- Database正常
- mcMMO正常
- Startup Blocking Errorなし

---


# 15. Persistent Nether／End追加構造物のRoadmap追加

## 15.1 現在の状態

現行BetterStructures 2.6.3と公式無料Pack`103 Default Structures` version 5は、次のPersistent Main Dimensionの新規Chunkで有効である。

```text
main
main_nether
main_the_end
```

ただし、現行Roadmapには次の専用タスクが存在しない。

```text
Nether向け追加構造物Packの選定・導入
End向け追加構造物Packの選定・導入
```

現在のPhase 2完了は、`103 Default Structures`をPersistent Main Familyへ導入したBaselineを意味するだけであり、Nether／End専用または重点的なStructure拡張の完了を意味しない。

## 15.2 Roadmap上の位置

`docs/09-roadmap.md`のDependency-based execution orderへ、次を追加する。

推奨順序：

```text
1. CoreProtect
2. Persistent Nether／End Structure Expansion
3. Playable Frontier Theme
4. Advanced Portals
5. Builder Phase 1B
6. User Hub／Gate construction
7. Main Spawn protection
8. Portal Routing
9. Resource Reset Bootstrap
10. Integrated operations
11. Cold Backup／Isolated Restore
12. V0.1.0 Pre-release Player State Reset
13. V0.1.0 Baseline
```

既存Phase番号の履歴を壊さないため、正式Phase名は次を推奨する。

```text
Phase 2B - Persistent Nether／End structure expansion
```

Dependency Tableの順序を実務上の正本とする。

本タスク後の次の実装Taskは引き続きCoreProtectである。

Nether／End追加構造物タスクはCoreProtect完了後、Playable Frontier Theme選定前に実施する。

## 15.3 V0.1.0への位置付け

Persistent Nether／End Structure ExpansionをV0.1.0 Release Blockerへ追加する。

理由：

- Structure Pack追加後も既存Chunkへ遡及生成されない。
- 導入が遅いほど、既に探索されたChunkと追加後の新規Chunkで生成内容が不均一になる。
- Public Alpha開始前にDimensionの生成Baselineを確定する方が安全である。
- Main Persistent Nether／Endは再生成しない方針である。
- Resource Familyへ追加Structureを生成しない境界を維持する必要がある。

V0.1.0 Release Blocker表記：

```text
Persistent Main Nether／End additional-structure pack selection and integration
```

## 15.4 将来の専用Integration Task要件

別途Codex指示書を作成し、次を調査・承認する。

### Artifact／Content選定

- BetterStructures 2.6.3と互換性があること
- Paper 26.2／Java 25で利用可能であること
- 公式または信頼できる配布元
- Release／Content Version
- License
- 無料／有料
- Manual Acquisition可否
- Filename
- SHA-256
- 必須依存
- Resource Pack要否
- Custom Mob／Boss／Item要否
- `103 Default Structures`との重複
- Structure ID競合
- Loot Table
- Generation Frequency
- Biome／Dimension条件
- 既存Chunkへの影響

第一候補はBetterStructures用のDimension-specific Content Packとするが、適切なPackがない場合に別PluginやDatapackへ自動的に切り替えない。

候補比較後、ユーザー承認を得る。

### Content方針

優先：

- Vanillaに馴染む外観
- 探索動機を増やす
- Nether／Endそれぞれに複数の発見要素
- 過剰なLootを持たない
- Boss／Custom Mobを必須にしない
- Client Resource Packを必須にしない
- Existing Vanilla progressionを置換しない

個別承認なしに導入しない。

- Premium Pack
- Custom Boss
- EliteMobs連携
- MythicMobs連携
- MMOItems連携
- Command Reward
- WM Reward
- Custom Model
- Resource Pack
- Overpowered Loot
- Vanilla Fortress／Bastion／End Cityの置換
- Dimension Generatorの全面置換

### World Scope

許可候補：

```text
main_nether
main_the_end
```

必要な場合だけ既存`main`への影響を明示評価する。

無効を維持する。

```text
resource
resource_nether
resource_end
unknown new worlds
lobby
frontier_gate
Frontier Theme worlds
```

Resource FamilyはReset対象であり、BetterStructures由来Structureを生成しない現在の方針を維持する。

### World Data方針

禁止：

- `main_nether`削除
- `main_the_end`削除
- World再生成
- Seed変更
- Region File削除
- Chunk Trim
- 既存Chunkへの強制Paste
- Existing Vanilla Structure削除
- Resource Family変更

追加Structureは原則として導入後に生成される新規Chunkだけへ適用する。

既に生成済みのChunkへ遡及配置しない。

### Verification

通常Integrationとして限定的に確認する。

最低限：

- 正確なArtifact／Pack
- Main限定配置
- `main_nether`有効
- `main_the_end`有効
- Resource Nether／End無効
- Unknown World無効
- Startup Blocking Errorなし
- Fresh Nether Chunkで追加Structureを1件確認
- Fresh End Chunkで追加Structureを1件確認
- Existing Spawn／Portal／World UUID／Seed不変
- Restart後Config維持

実施しない。

- 全Structure確認
- 全Biome確認
- 全Loot確認
- 全Generator確認
- 大規模Pregeneration
- 広範なChunk探索
- Loot Balanceの網羅試験
- World全体のRegression

自然生成を確認するための探索範囲は必要最小限にする。

代表Structureが合理的な範囲で見つからない場合、生成頻度を無断で上げず、ConfigとPack条件を報告する。

## 15.5 適切なPackが見つからない場合

次を行わない。

- 不明な配布元から取得
- 非互換Packの強行導入
- Premium Packの無断購入
- Source改変
- Schematicの無断自作
- Overworld PackをNether／Endへ強制適用
- World Generatorの交換
- Blocker完了扱い

調査結果と候補不足を報告し、Release Blockerを未完了のまま維持する。

## 15.6 今回の価格改定Taskで行わないこと

本タスクではRoadmapと関連文書へ計画を追加するだけとする。

実施しない。

- Structure Pack Download
- BetterStructures Content Import
- BetterStructures Config変更
- `ValidWorlds.yml`変更
- World起動を伴うStructure確認
- Nether／End探索
- Chunk生成
- World Backup
- World変更
- Plugin追加
- Phase 2B完了扱い


# 16. V0.1.0直前の初期化方針

本タスクでは初期化を実施しない。

`docs/09-roadmap.md`のV0.1.0 Baseline直前へ、別途承認が必要な破壊的Taskとして追加する。

仮称：

```text
V0.1.0 Pre-release Player State Reset
```

実施時期：

```text
全Gameplay／Portal／Hub／Permission／Backup機能試験完了後
かつ
最終Baseline Backup作成直前
```

最低限のユーザー要件：

- 全Player Waymark残高を0 WMへReset
- MainのPlayer Inventoryを初期化
- Armor／Offhandを初期化
- Vanilla EXP Level／Total／Progressを初期化
- Vanilla Advancementを初期化

将来TaskでExact Scopeを明示承認する。

未確定であり、今回決めないもの：

- Ender Chest
- Health／Hunger
- Position
- Bed Spawn
- Statistics
- Recipe Book
- Lobby Player Data
- Frontier Player Data
- mcMMO Level／XP
- EvenMoreFish Journal／Statistics
- LuckPerms Eligibility
- Temporary Role履歴
- Waymark Transaction History
- Resource World Player Position

将来Taskの必須条件：

- 全Player接続拒否
- Minecraft Network正常停止
- Redis／World／Player Dataの事前Backup
- Exact Path確認
- 対象UUID一覧の非Commit管理
- RedisEconomyの正式機能または承認済みMigration
- Redis Key直接編集禁止
- Player Dataの対象FileをExactに特定
- Advancement FileをExactに特定
- Persistent Worldを変更しない
- Reset後の0 WM／空Inventory／0 EXP／Advancement初期状態の代表確認
- Baseline BackupはReset後に取得
- 別のCodex指示書
- 明示的な破壊承認

RoadmapのV0.1.0 Release Blockerへ追加する。

```text
V0.1.0 pre-release Waymark／Vanilla player-state reset
```

現在のTest Player Dataや残高を本タスクで先行Resetしない。

---

# 17. 文書更新

Document revisionはVer.0.0.5のままとする。

RevisionをVer.0.0.6へ上げない。

最低限更新する。

- `README.md`
- `docs/00-design-guide.md`
- `docs/03-operations.md`
- `docs/04-play-guide.md`
- `docs/05-troubleshooting.md`
- `docs/06-acceptance-tests.md`
- `docs/09-roadmap.md`
- `docs/10-waymark-economy.md`
- `docs/11-deferred-design-items.md`
- `docs/13-main-world-baseline.md`
- `docs/12-permission-model.md`
- `versions.yml`
- `plugin-manifest.yml`
- `plugin-collection.csv`
- `codex/README.md`
- `.gitignore`

本指示書を次へ保存する。

```text
codex/Project_Wayfarer_Waymark_Price_Scale_and_EvenMoreFish_Shop.md
```

## 16.1 Waymark Economy文書

`docs/10-waymark-economy.md`を価格の正本として更新する。

記載：

- 価格体系100倍
- Migrationなし
- EconomyShopGUI全価格表
- EvenMoreFish魚売却式
- Rarity倍率
- Price Range
- Junk売却不可
- Fish購入なし
- `/emf shop`
- `/emf sellall`無効
- Fish売却以外のMONEY Reward無効
- Test残高Cleanup
- V0.1.0直前Reset予定
- 価格調整方針

既存の「EvenMoreFish rewardは将来」の記載を、実装済みの魚売却へ更新する。

## 16.2 Play Guide

一般Player向けに記載する。

```text
/emf shop
```

説明：

- 釣ったEvenMoreFishの魚をWMへ売却する。
- 魚のサイズとRarityで価格が変わる。
- Junkは売却不可。
- `/emf sellall`は使用できない。
- FishをServerから購入するShopではない。

## 16.3 Permission Model

`default` GroupのMain Authorityへ`emf.shop`を追加する。

次を付与しないことを明記する。

- `emf.sellall`
- `emf.admin`
- Economy管理
- Debug

## 16.4 Roadmap

Phase 4完了状態は維持する。

Phase 4の追加完了項目として記録する。

- Waymark価格体系100倍
- EvenMoreFish Vault Shop有効
- Rarity価格採用
- 直接MONEY Reward除去
- `emf.shop` Main Context
- 1 Fish売却確認

次の実装Taskは引き続きCoreProtect。

CoreProtectの後、Playable Frontier Themeの前へ`Phase 2B - Persistent Nether／End structure expansion`を追加する。

Phase 2BをV0.1.0 Release Blockerへ追加する。

Phase 2Bは本タスクでは計画追加だけとし、Pack選定、Artifact取得、Import、World変更および生成確認を実施しない。

V0.1.0 Baseline直前にPre-release Player State Resetを追加する。

## 16.5 Deferred Design

EvenMoreFish Fish売却を将来機能から除外する。

引き続きDeferred：

- Frontier WM Reward
- Quest Reward
- Achievement Reward
- Dynamic Pricing
- Fish購入
- Bait購入
- Competition Economy
- Cross-server Shop

---

# 18. Manifest／Metadata

## EconomyShopGUI

更新：

```text
pricing: fixed-alpha-baseline-x100
minimum-standard-vanilla-price: 1 WM
product-count: 62
transaction-verification: config-and-gui-only-no-live-trade
```

Version／SHA-256／Placementは変更しない。

## EvenMoreFish

更新：

```text
economy: vault-enabled
vault-provider: RedisEconomy 4.5.12-wayfarer.1 through VaultUnlocked 2.20.2
vault-multiplier: 1.0
shop: enabled
sellall: disabled
fish-purchase: unsupported-not-implemented
rarity-worth:
  junk: 0.0
  common: 1.0
  rare: 0.5
  epic: 0.3
  legendary: 0.2
direct-money-rewards: disabled
permission: emf.shop at server=main
verification: one-fish-sale-no-exact-balance-assertion
```

Version／SHA-256／Database／World Scope／mcMMO境界は変更しない。

---

# 19. Troubleshooting更新

最低限記載する。

## EconomyShopGUI

- GUIに旧価格が表示される
- Config Fileを間違えている
- Mainを正常Restartしていない
- Cache／Backup Fileを編集している
- YAML Parse Error
- Material Error

対応：

- 正本Shop File確認
- Diffで100倍確認
- Main正常Restart
- Reload禁止
- 実Transaction不要

## EvenMoreFish

- Shop Buttonが見えない
- `/emf shop` Permission拒否
- Vault Economy未認識
- Fishを売却Slotへ置けない
- Fish価格が0
- Coinfish等が直接WMを出す
- `/emf sellall`が使えてしまう
- PlayerPoints／Claim Blocksが有効
- Console Exception

対応：

- `emf.shop` Main Context
- VaultUnlocked Provider
- Runtime Config Render
- Rarity File Load
- MONEY Reward検索
- Full Main Restart

Database Debug Commandを通常Troubleshootingにしない。

---

# 20. Cleanup

Commit前に確認する。

- Temporary Admin Parent解除
- OPなし
- Test Fishなし
- Test Player残高を売却前へ復元
- Global Balance変更なし
- `emf.sellall`未付与
- Test Permissionなし
- PlayerPoints無効
- GriefPrevention Economy無効
- Direct MONEY Rewardなし
- Competition無効
- Debug無効
- JAR非Stage
- Runtime Secret Config非Stage
- Redis Data非Stage
- Database Data非Stage
- Log／Cache非Stage
- Backup非Stage
- Player Data非Stage
- V0.1.0 Reset未実行
- Main正常状態

---

# 21. Commit前検査

実行する。

```powershell
git status --short
git diff --check
git diff --stat
git diff
```

Repositoryに存在する検査Scriptを使用する。

YAML／CSVをParserで確認する。

必要に応じて一時比較処理を使い、次を確認する。

- EconomyShopGUI 62価格すべて100倍
- Category／Product不変
- Buy／Sell Spread維持
- Fish倍率正確
- Vault有効
- 他Economy無効
- Direct MONEY Rewardなし
- Main GUI Shop Button
- `emf.shop` Main Context
- `emf.sellall`未付与
- Secretなし
- JARなし
- Player Dataなし
- Runtime Configなし
- Document revision Ver.0.0.5維持
- V0.1.0未達
- CoreProtect未導入
- Pre-release Reset未実行
- GitHub CLIを検索していない

---

# 22. Commit／Push条件

次をすべて満たした場合だけCommit／Pushする。

- EShop全価格が正確に100倍
- EShop Category／Product不変
- EShop YAML正常
- EShop代表価格がGUI表示
- EShop実売買試験を行っていない
- EMF Vault Economy有効
- EMF Vault multiplier 1.0
- EMF他Economy無効
- 5 Rarity倍率正確
- Junk売却不可
- Direct MONEY Rewardなし
- Coinfish直接MONEY無効
- EMF Main GUI Shop Button
- `emf.shop` Main Context
- `emf.sellall`未付与
- Fish 1個の売却成功
- Fish消費確認
- 正確な残高計算をAcceptanceにしていない
- Test残高Cleanup
- Temporary Admin Cleanup
- Main正常Restart
- Startup Blocking Errorなし
- Manifest／Docs更新
- Future Pre-release Resetを記録
- Current balance Migrationなし
- Player Data Resetなし
- `git diff --check`成功
- Repository検査成功

Blocking時：

- Commitしない。
- Pushしない。
- EconomyShopGUIで実売買を繰り返さない。
- EMF全Rarityを試験しない。
- Redisを直接編集しない。
- Permissionを広げない。
- `/emf sellall`を開放しない。
- Direct MONEY Rewardを残したまま完了扱いしない。
- Global BalanceをResetしない。
- Player Dataを削除しない。
- Development Buildへ変更しない。
- 問題、Rollback状態、未完了条件を報告する。

推奨Commit Message：

```text
feat: Waymark価格体系と魚売却を改定
```

既存`main`へ直接Pushする。

Pull Requestは作成しない。

GitHub CLIは探さない。

---

# 23. 完了報告

報告する。

- 作業開始時HEAD
- EconomyShopGUI Version
- Price Scale：100倍
- Product数
- 5 Category
- Price Table更新File
- Config／GUI反映確認
- EShop実Transaction未実施
- EvenMoreFish Version
- Vault Economy状態
- Vault Provider
- Rarity倍率
- Direct MONEY監査結果
- Coinfish処理
- Main GUI Shop Button
- `emf.shop` Permission
- `emf.sellall`拒否
- 売却したFishのRarityと名称
- Fish 1件売却成功
- Fish消費確認
- 正確な売却後残高はAcceptance対象外であること
- Test残高Cleanup
- Main Restart結果
- Startup Log結果
- Document更新
- Persistent Nether／End Structure ExpansionのRoadmap追加
- Phase 2Bの実装未着手
- Future Pre-release Reset記録
- Global Balance未変更
- Player Data未変更
- Temporary Admin Cleanup
- 変更File
- 実行した検査
- Commit SHA
- Push先Branch
- 次の実装TaskがCoreProtectであること

報告へ含めない。

- Player名
- UUID
- Credential
- Password
- Exact Test Balance
- Redis Key
- Database Row
- Player Data Pathの個人情報
