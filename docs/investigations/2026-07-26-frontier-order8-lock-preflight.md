# Frontier Order 8 Lock Preflight

## Summary

| Item | Result |
| --- | --- |
| Date | 2026-07-26 |
| Proposal ID | `FRONTIER-LOCK-20260726-003` |
| Pre-execution HEAD | `354052c9dd80d77b8b83c49f783e4d4b7b8755fd` |
| Branch／Remote | `main`／`origin` |
| Phase | A — static research and candidate lock only |
| Runtime change | None |
| World／DB／Permission change | None |
| Decision Gate | Revision 003 was approved after this Phase A report; see the Formal Lock report |

本Reportは、Order 8の正式Lock前に行ったRepository-local Inventory、Artifact静的確認、公式情報調査および境界候補を記録する。Runtime導入、Server起動、World生成、Database操作、Permission変更、Pack生成は行っていない。

Phase Bは後続のExact Tokenで完了した。Current Lockは
[Frontier Runtime Lock](../15-frontier-runtime-lock.md)と
[Formal Lock Report](2026-07-26-frontier-order8-lock.md)を参照する。

## Revision 003

Proposal 003は、未承認のProposal 002を、Owner Commit
`9abc12ae5f472325933d38c5eacc6050aaf3e6c7`後の現行Conceptと正式Scopeへ
再基底化した現在候補である。

- `previous_proposal: FRONTIER-LOCK-20260726-002`
- `previous_status: superseded-before-approval`
- `phase_b: not-authorized`
- `approval_token_received: false`
- `status: candidate`
- `runtime_validation: deferred`
- 独自Pluginは一つの外部Gradle Multi-module Repositoryに置き、
  `Wayfarer_Core`、`Wayfarer_Main`、`Wayfarer_Frontier`をV0.1.0必須Moduleとする。
- `Wayfarer_Main`はMain限定でGrowth Pickaxeを所有し、Frontierへ配置しない。
- `Wayfarer_Frontier_EliteMobsMVI`は`ADAPTER_REQUIRED`時だけ追加する独立Artifactである。
- Worlds Beyondは`frontier_iris`単一Overworldのまま、Ruined Frontierは三次元を維持する。
- FrontierのBlock History／Rollback製品は未選定で、CoreProtect 24.0は静的候補に留める。
- Proposal 001／002のArtifact判断とHashは維持し、Runtime検証を追加していない。

Proposal 002のTokenは一度も実行されず、Proposal 003へ流用できない。Phase B用正式Lock
File、Runtime Plugin、World、MVI Group、Pack、DatabaseおよびPermissionは作成・変更していない。

## Revision 002（未承認の履歴）

Revision 002はProposal 001を全面的に置き換え、旧Approval Tokenを無効化する。
UserによるArtifact配置と設計判断を反映した主な変更は次のとおり。

- Worlds Beyondは三次元Familyではなく、Iris Overworld
  `frontier_iris`だけで構成する。Nether／End Worldは作成しない。
- IrisDimensions Netherは公式READMEが未完成・利用不可としているため不採用。
- 配置済み`end-main.zip`は内部Environmentが`NORMAL`であり、Worlds Beyond
  の選定範囲外でもあるため不採用。古いIris End代替も取得・使用しない。
- Multiverse-NetherPortalsはMainと揃えた5.0.5をRuined Frontier Familyだけに使用する。
- BetterHealthBar 4.1.0のUser-owned premium Artifactを候補採用した。
- Primisの固定World IDは`em_primis`と`em_primis_wormhole`である。
- Adventurer's Guildの正規Artifact Linkは公式`/em setup` Flowでのみ取得できる。
  Phase AはServerを起動しないため、Artifact LockだけをOrder 11／12へ繰り越す。

この決定は候補Lockへの反映であり、`concepts/`の非正本資料そのものは今回変更しない。
現行の正式文書に残る「Iris三次元」表現は、Revision 002の正式Approvalを受けた
Phase BでSource of Truthとともに整合させる。

## Current Frontier baseline

- Paper `1.21.11 build 132`
- Java `25`
- bind `127.0.0.2:25568`
- `level-name=frontier_gate`
- Multiverse登録は`frontier_gate`だけ
- `frontier_gate`はVoidGen Entry World
- Velocity modern forwarding

現行Frontier Plugin JARは次の10件で、Order 8候補JARはまだ配置されていない。

```text
LuckPerms-Bukkit-5.5.60.jar
mcmmo.jar
multiverse-core-5.7.2.jar
PlaceholderAPI-2.12.3.jar
RedisEconomy-4.5.12-wayfarer.1.jar
TAB-Bridge.v6.2.2.-.Bukkit.jar
VaultUnlocked-2.20.2.jar
VoidGen-2.3.8.jar
worldedit-bukkit-7.4.4.jar
worldguard-bukkit-7.0.17.jar
```

## Existing Artifact inventory

すべて通常のJAR／ZIPとして読み取り可能で、Git無視対象だった。

| Artifact | Bytes | SHA-1 | SHA-256 | Internal evidence |
| --- | ---: | --- | --- | --- |
| BetterStructures 2.6.3 | 5,826,656 | `F837150EA96CF6DBED81DDA569C22E3928FFE65F` | `AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038` | `plugin.yml`, API 1.21.4, hard dependency WorldEdit |
| FreeMinecraftModels 2.10.2 | 4,187,617 | `B019DCEAECB262CB2722750E0C271874728D39DB` | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` | `plugin.yml`, API 1.21.4 |
| ResourcePackManager 2.3.0 | 6,041,930 | `5FAFBCDA1371E2360DF00D5B2DAA26B1B9575E86` | `240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64` | `plugin.yml`, API 1.21.4 |
| MNP 5.0.5 | 55,764 | `6801ABD1017DAA649EAC27DFB4F15360CB86DBD9` | `7D6364A2B474C2D3C4F8F8C5DCD469D9DE5A5F6F64C43DA39B648C3877AD077D` | `plugin.yml`, Multiverse-Core required |
| CoreProtect CE 24.0 | 1,102,175 | `E8425E63E9F22999B090BEAFBC32BEF46D91EB22` | `66CD362089BB8430E5A018EE77E9B433BF0DC9E65590D5F1A043A78D60415696` | JAR readable; Frontier runtime未検証 |
| BetterStructures Prop Pack | 365,195 | `FE3C08249F29BAEAB6227DBA76BB0662A610013B` | `F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D` | 55 model entries |
| Exploration Pack v6 | 280,303 | `ED3657BBF1EFA518E68B7B6E5081E6D9F5F0652D` | `963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B` | internal version 6 |
| Caves and Lost Civilizations Free v2 | 303,044 | `6446C6A85958C2DAE90A9FF1F014FAFB0BFEAFE6` | `27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677` | internal version 2 |
| Adventure Pack | 709,761 | `B196D7AAFBC8D5097F2728BF85103D01CA3050B2` | `96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C` | internal version 1 |
| Echoes of the Past | 488,216 | `7638A842CFCD5C74168CAC6DD92D5812F709418D` | `B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F` | internal version 3 |

既存Main Runtime Configや生成済みPackはFrontierへCopyしない。再利用対象は、確認済みの同一Artifactと後続Taskで再構成する選定入力だけである。

### Revision 002 user-staged Artifact inventory

すべてUserがIgnored Stagingへ配置したもので、CodexはDownloadしていない。
通常のJAR／ZIPとして開き、Plugin MetadataまたはContent Metadataを確認した。

| Artifact | Bytes | SHA-256 | Static result |
| --- | ---: | --- | --- |
| MVI 5.3.5 | 1,673,897 | `27568B35AEA1042BAEA1FBC0D5256C17B51C596B8F2D166BE35BA1F77E6847A9` | version 5.3.5、MV-Core hard dependency |
| Advanced Portals 2.8.0 | 3,221,235 | `ABD3E4BE48C1F34BC60530AAA344AB8BFFD4146281B8AD33FC83628C93E7287D` | Bukkit／Velocity両Metadataを同一JARで確認 |
| Iris 3.9.2 | 3,619,963 | `46E3CD36B08EE6B24B6EC0ECC38379BEF82DADB861DDEBC10E0E338FDB7A7757` | version 3.9.2-1.20.1-1.21.11 |
| Iris Overworld | 19,613,103 | `0FA29D96D07B19EDBA3EFCA8E10DCEAAE24E94C7651C1ED888E54FA358144056` | dimension `overworld`、Environment `NORMAL`、採用 |
| Iris `end-main.zip` | 19,881,909 | `AFB63C9FB8520926207DE1D380743149CC1F79A2A451ECDB996DA8EC3DE9A430` | Environment `NORMAL`、不採用 |
| LeafGrapple 1.0.2 | 56,175 | `FFE4B3305BB48737E1B6C373698FEFE7121B879FD5B9399F930F5023B5F78833` | ConfigにItem Model／Entity Hook設定あり |
| EliteMobs 10.7.3 | 7,086,808 | `688E93033A36F4168B2F69B8A65921FBB36AFFC047AA9534027724A2E5DA674E` | Paper Metadata確認 |
| Primis | 167,198,324 | `46FDE1DD3A7FF2819FD6DFD0411764FC7B4E3EB997F332ABCADDDA09904E41AD` | meta 39、固定World 2件確認 |
| Free Elite Shrines | 414,334 | `5ABBC796272901199B3F368946FD49B20BDFCFF362104722FDEDA2AB2D7120E5` | version 9、BS／EM Content |
| Dungeoneering Modules Free | 83,724 | `5E946E4A1F1C000F4DD4258E35A5E147D71E32D88C772AEB5E61DCA7D2D709E3` | version 2、BS Content |
| BetterHealthBar 4.1.0 | 3,705,688 | `BA78BDC0A293A8516155D6334437881C4E92D3C4F1D786AB38064EA5B032D5F6` | NMS adapter `v1_21_R1`–`R7`、`v26_R1`／`R2` |

## Official compatibility evidence

公式配布Metadataは2026-07-26に再確認した。Modrinthが公開するFile HashはSHA-1／SHA-512でありSHA-256ではないため、未取得ArtifactのSHA-256は`null`のままにした。

| Component | Candidate | Official evidence | Compatibility | License | Result |
| --- | --- | --- | --- | --- | --- |
| Multiverse-Inventories | 5.3.5 | [Modrinth release](https://modrinth.com/plugin/multiverse-inventories/version/5.3.5) | Paper／1.21.11 listed; MV-Core required | BSD-3-Clause | selected, Artifact verified |
| Multiverse-NetherPortals | 5.0.5 | [Modrinth release](https://modrinth.com/plugin/multiverse-netherportals/version/5.0.5) | Paper／1.21.11 listed | BSD-3-Clause | selected by Main version parity; Artifact verified |
| Advanced Portals | 2.8.0-spigot | [Modrinth release](https://modrinth.com/plugin/advanced-portals/version/OiYxu4ab) | Paper, Velocity, 1.21.11, 26.2 listed | LGPL-3.0-only | package metadata verified |
| Iris | 3.9.2 | [GitHub release](https://github.com/VolmitSoftware/Iris/releases/tag/3.9.2-1.20.1-1.21.11) | release tag explicitly targets 1.20.1–1.21.11; Java 21+ | GPL-3.0 | Engine verified; Worlds Beyond Overworld only |
| LeafGrapple | 1.0.2 | [Modrinth release](https://modrinth.com/plugin/leafgrapple/version/Do80frax) | Paper／1.21.11 listed | MIT | Artifact verified |
| EliteMobs | 10.7.3 | [Modrinth release](https://modrinth.com/plugin/elitemobs/version/D1rNCpLn) | Paper／1.21.11 listed | GPL-3.0-only | Engine and three Content packages verified; Guild deferred |
| BetterStructures | 2.6.3 | [Modrinth release](https://modrinth.com/plugin/betterstructures/version/2.6.3) | Paper／1.21.11 listed | LGPL-3.0-only | existing Artifact selected |
| FreeMinecraftModels | 2.10.2 | [Modrinth release](https://modrinth.com/plugin/free-minecraft-models/version/sQDrL88L) | Paper／1.21.11 listed | GPL-3.0-only | existing Artifact selected |
| ResourcePackManager | 2.3.0 | [Modrinth project](https://modrinth.com/plugin/resourcepackmanager) | Paper／1.21.11 listed | LGPL-3.0-only | existing Artifact selected |
| CoreProtect CE | 24.0 | [Modrinth release](https://modrinth.com/plugin/coreprotect/version/24.0) | Paper／1.21.11 listed | Artistic-2.0 | Artifact candidate for later validation; product unselected |
| BetterHealthBar3 | 4.1.0 | [Spigot resource](https://www.spigotmc.org/resources/116619/) | User-owned release; JAR includes adapters through 1.21 R7 and 26 R2 | premium account-bound terms | selected, runtime validation required |

MNP 5.0.5は現行MainとVersionを揃えるUser判断により選定した。Worlds Beyondは
単一OverworldのためMNP対象外とし、Ruined Frontierの三次元Familyだけを対象にする。

## MVI state and authority

[MVI FAQ](https://mvplugins.org/inventories/reference/faq/)は、Inventory、Offhand、Armor、Ender Chest、Health、Food、XP等の正確なshare keyと、DataがPlugin Directoryに保存されVanilla playerdataを変更しないことを明示する。[MVI API](https://mvplugins.org/inventories/developers/api-usage/)は`groups.yml`、`WorldGroupManager`およびCustom Sharable APIを提供する。

採用候補shareは次に限定する。

```text
inventory_contents
off_hand
armor_contents
ender_chest
hit_points
max_hit_points
food_level
saturation
exhaustion
xp
lvl
total_xp
```

GameModeはMVI share keyとして確認できず、Theme間の自動共有対象にしない。Potion、Bed Spawn、Location、Advancement、Recipe、Statistics、Economyも初期共有しない。World切替、Death／Respawn、Reconnect、Shutdown、EliteMobs InstanceのWildcard／API登録はOrder 12／13の詳細試験へ送る。

通常Player Stateの唯一のRuntime正本はMVIであり、Wayfarer_FrontierがInventoryをMariaDBへ再実装しない。

## World ID collision check

候補8件は、現在のFolder名、`level-name`およびMultiverse登録と完全一致しないことを確認した。

| Purpose | Candidate | Collision |
| --- | --- | --- |
| Entry | `frontier_gate` | existing, retained |
| Worlds Beyond | `frontier_iris` | none; single Overworld only |
| Guild | `adventurers_guild` | none; package fixed name pending |
| Ruined Frontier | `frontier_bs`, `frontier_bs_nether`, `frontier_bs_the_end` | none |
| Primis | `em_primis`, `em_primis_wormhole` | none; package fixed names verified |

`frontier_gate_nether`、`frontier_gate_the_end`、`world`、`world_nether`、`world_the_end`は未登録の既存Legacy Directoryとして除外し、削除・Rename・再利用しない。EliteMobs Content内の固定World／Blueprint／Instance名はArtifact取得後に照合する。

## Portal and Gate proposal

### Portal family

- Worlds Beyond: Portal familyを作らず、`frontier_iris`単独
- Ruined Frontier: `frontier_bs` ↔ `frontier_bs_nether`／`frontier_bs_the_end`
- Theme間、Main、`frontier_gate`およびWorlds BeyondのNether／EndへのLinkは禁止

MNP 5.0.5をRuined FrontierだけのFamily-local explicit link候補とする。End exit、
Mob／Item／Vehicleおよび`handle-end-exit-respawn`の実Keyは生成Config確認後に決める。

### Backend Gate

Advanced Portals 2.8.0を第一候補とする。[公式Portal Tags](https://advancedportals.sekwah.com/docs/portal-tags/)では、`proxy:`がProxy componentを使いVelocityのBungee message channelを不要にし、`permission:`と`cooldown:`を持つ。したがって`bungee:`ではなく`proxy:`を候補Lockとする。

ただし配布Metadataは1個の`advanced-portals-2.8.0-spigot.jar`をPaperとVelocity両方に列挙している。JAR内の各Platform Metadata／Entrypointを実物で確認するまで、同一Fileを4 Runtimeへ配置するとは確定しない。

## Iris Engine and Pack comparison

Engine候補はIris `3.9.2-1.20.1-1.21.11`、Pack候補は
[IrisDimensions/overworld](https://github.com/IrisDimensions/overworld)の
`overworld-master.zip`だけである。内部Dimension ID `overworld`、
Environment `NORMAL`、Pack version 4000を確認した。

Worlds Beyondは`frontier_iris`だけであり、Nether／End WorldやPortal Familyを
持たない。IrisDimensions Netherは公式READMEの未完成警告により不採用。
配置済み`end-main.zip`は内部Environmentが`NORMAL`で、Repository READMEも
Overworld Packとして説明しているため不採用。`IrisDimensions/theend`も
選定範囲外であり、古いPackを代替導入しない。

## EliteMobs Content preflight

EliteMobs Engine 10.7.3と次の三Content Artifactを静的確認した。

| Content | Current evidence | Static result |
| --- | --- | --- |
| Adventurer's Guild | official `/em setup` Flow | Artifact Link／exact version／hash deferred |
| Primis | `primis-primis-adventure.zip` | meta 39; fixed worlds `em_primis`, `em_primis_wormhole` |
| Free Elite Shrines | `free-elite-shrines-free-elite-shrines.zip` | version 9 |
| Dungeoneering Modules Free | `dungeoneering-modules-free-dungeoneering-modules-free.zip` | version 2 |

[Official EliteMobs documentation](https://wiki.nightbreak.io/EliteMobs/dungeon_packager/) states current dungeon packages are world-based. Consequently、MVI static membership、Regex/API handling、fixed/cloned/temporary lifecycle、disconnect/reconnect behavior and backup ownership cannot be inferred from Concept names alone. These are Order 13 acceptance items.

Phase AではServerを起動できないため`/em setup`も実行しない。Adventurer's Guild
だけは、後続OrderでUserが公式Linkから取得してからExact Artifact Lockする。
無許可のAuto-download、Nightbreak account linking、`downloadall`、Content updaterは使用しない。

## BetterStructures reuse boundary

Existing JARs and five Content inputs are hash-verified and may be reused as candidates. Frontier will create independent Plugin data and Pack output.

- `frontier_bs*`だけをallowlist
- unknown world default false
- `frontier_gate`、Worlds Beyond、Guild、Primis、EM Instanceではoff
- full `103 Default Structures` pack is rejected for initial Frontier
- exact Structure ID、enablement、weight、separationはOrder 14
- Main normalization output／Runtime ConfigはCopyしない
- premium／account-bound Packの別Backend利用権はUser confirmation required

## Resource Pack collision preflight

Existing Main priority is `ResourcePackManager > FreeMinecraftModels > BetterStructures`。Frontierは独立Packとし、候補優先度をProject-owned assets、Theme item、EliteMobs、FMM、BetterStructures、RPMの順にする。

| Namespace／ID | Source A | Source B | Static result | Resolution owner |
| --- | --- | --- | --- | --- |
| BetterStructures Prop model IDs | existing FMM input | Frontier reuse | Backend-separated; Client switch test required | Order 12 |
| CustomModelData／Item Model Component | missing EliteMobs | missing LeafGrapple | unresolved | Order 12 |
| Font／Shader | BetterHealthBar 4.1.0 | future combined pack | generated input selected; collision inspection pending | Order 12 |
| Model／Texture path | FMM／BS | missing Elite content | unresolved | Order 12 |
| `pack.mcmeta` | all inputs | RPM generated output | generation deferred | RPM／Order 12 |

[ResourcePackManager official description](https://modrinth.com/plugin/resourcepackmanager) states that duplicate model IDs and GUI font conflicts are resolved by priority rather than semantically merged, and Java players receive backend packs on server switch. Therefore missing inputs must be inspected and a Lobby→Frontier→Main switch test is mandatory.

Order 8では最終ZIP、URL、SHA-1、SHA-256、Sizeを生成しない。Self-host Portを開かず、temporary remote hostingもOrder 12の明示的受入時だけ使用する。

BetterHealthBar 4.1.0のDefault ConfigはSelf-hostを有効にしPort 8163を使うため、
Order 12ではSelf-hostを無効化し、生成されるFont／ShaderをFrontierのRPM Packへ
統合する。Order 8ではConfig生成、Port開放、Pack Buildを行わない。

## History／rollback decision

FrontierのBlock History／Rollback製品は未選定とする。CoreProtect CE 24.0は
`artifact-candidate-for-later-validation`であり、製品採用を意味しない。

- Official metadata includes Paper 1.21.11.
- Existing JAR and SHA-256 are known.
- Mainの失敗はPaper 26.2であり、Frontier 1.21.11を自動延期する根拠にはしない。
- MariaDB、WorldEdit logging、per-world exclusion、retention、dynamic instance exclusionおよびperformanceは未検証。
- World backup／MVI backup／EliteMobs backupの代替にはしない。
- Runtime testやDatabase作成はOrder 8 Scope外。

Dynamic／temporary EliteMobs Instanceは、LifecycleとCleanupが確定するまでlogging対象外とする。

## Persistence and authority

| Data | Authority | Runtime location | Backup owner | Restore order | Cross-server |
| --- | --- | --- | --- | --- | --- |
| `neutral` normal state | MVI | Frontier MVI storage | Frontier backup | before join | No |
| Worlds Beyond normal state | MVI | Frontier MVI storage | Frontier backup | before join | No |
| Guild／Ruined normal state | MVI | Frontier MVI storage | Frontier backup | before join | No |
| World blocks／entities | World files | Frontier worlds | Frontier world backup | before startup | No |
| Waymark | RedisEconomy／Redis AOF | Redis | network cold backup | before backends | Yes |
| mcMMO | MariaDB | `wayfarer_mcmmo` | DB dump | before backends | Yes |
| EliteMobs data | EliteMobs | exact path pending | Frontier backup | Plugin-specific | Guild only |
| Iris definition／world | locked Artifact／world files | Frontier | Frontier backup | before world load | No |
| Resource Pack inputs | Artifact／Config | ignored inputs + tracked Lock | Pack backup | before publish | Backend-specific |
| Waystone／Discovery | future Wayfarer_Frontier | future MariaDB | custom backup | migration first | Worlds Beyond only |
| Audit／Transaction | future Wayfarer_Core | future MariaDB | custom backup | migration first | approved scope |
| History | product unselected; CoreProtect 24.0 is an Artifact candidate | storage pending | separate owner | after world／DB restore | Frontier only |

RedisをInventory、Theme StateまたはEliteMobs Itemの正本にしない。

## Permission boundary

Order 8はPermissionを変更しない。

- Temporary Admin only: MVI／MNP／Gate／Iris／EliteMobs／BetterStructures／FMM／RPM／History／DB／World lifecycle administration
- General Player: approved Gate traversal、Theme gameplay、approved GUI only
- Builder: no new node; exact minimum allowlist is deferred to Order 17／18
- Custom Plugins: `wayfarer.core.*`／`wayfarer.frontier.*` namespaces are future design; no wildcard

## Custom Plugin contract handoff

Order 8でLockする候補境界：

- 独自Plugin Sourceは一つの外部Gradle Multi-module Repositoryで管理する
- `Wayfarer_Core`、`Wayfarer_Main`、`Wayfarer_Frontier`はV0.1.0必須Sibling Module
- `Wayfarer_Main`はMain限定でGrowth Pickaxeを所有し、Frontierへ配置しない
- `Wayfarer_Frontier_EliteMobsMVI`は`ADAPTER_REQUIRED`時だけ追加する独立Runtime Artifact
- Paper 1.21.11／Java 25 target for Frontier-side integration
- MVI、Gate、EliteMobs、RPMの機能を再実装しない
- normal Inventory／ItemはMariaDBへ複製しない
- Wayfarer_Frontier owns Worlds Beyond discovery／waystone domain
- Wayfarer_Core owns approved network audit／transaction domain
- EliteMobs Adapter necessity and API/Event contract are deferred to Order 13
- released JAR is later manually staged, hash-locked and installed by Project Wayfarer

## License and acquisition matrix

| Artifact | Class | Present | License／terms | User action |
| --- | --- | ---: | --- | --- |
| MVI／MNP | B／D | Yes | BSD-3-Clause | verified |
| Advanced Portals | B | Yes | LGPL-3.0-only | verified |
| Iris Engine | B | Yes | GPL-3.0 | verified |
| Iris Overworld Pack | B | Yes | Unlicense | verified |
| EliteMobs | B | Yes | GPL-3.0-only | verified |
| EliteMobs free Content | B／terms per package | Partly | package terms | Guild only deferred |
| LeafGrapple | B | Yes | MIT | verified |
| BS／FMM／RPM JARs | D | Yes | LGPL／GPL | hash re-audited |
| BS Content | D | Yes | package terms vary | confirm same-owner Frontier use |
| CoreProtect | D | Yes | Artistic-2.0 | Artifact candidate only; product unselected |
| BetterHealthBar3 | C | Yes | premium account-bound terms | User-owned 4.1.0 selected |
| Wayfarer_Core／Main／Frontier | E | future | future project license | One external multi-module Repository; Order 9～11 |

## Missing Artifact and manual action

Exact staging paths are listed in [`manual-downloads/frontier/README.md`](../../manual-downloads/frontier/README.md).

Missing SHA-256／internal metadata:

1. Adventurer's Guild official package only

Iris Nether／End Artifactは不足ではなく、Worlds Beyondが単一Overworldになった
ため選定対象外である。Adventurer's Guildは公式`/em setup`でLinkを得られる
後続Orderまで、Exact Artifact Lockを既知の残件として繰り越す。

User confirmation required:

- Existing user-owned BetterStructures Prop／Adventure／Echoes artifacts may be used on the same owner's Frontier Backend under their acquisition terms.

## Recommended Lock Proposal

Proposal: `FRONTIER-LOCK-20260726-003`

### Component decision table

`pending`はAdventurer's Guildだけに残る既知の後続Artifact Lockを意味する。

| Component | Selected／Unselected | Exact Version | Official Source | License | Artifact Filename | SHA-256 | Compatibility | Placement | Dependencies | World scope | Persistence owner | Permission owner | Pack input | Manual acquisition | Deferred validation | Rollback boundary | Known limitation／Timing |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MVI | Selected | 5.3.5 | Modrinth／GitHub | BSD-3-Clause | `multiverse-inventories-5.3.5.jar` | `27568B35AEA1042BAEA1FBC0D5256C17B51C596B8F2D166BE35BA1F77E6847A9` | Paper 1.21.11／Java 25 runtime-unverified | Frontier | MV-Core 5.7.2 | all Frontier via 3 groups | MVI | Admin | No | No | Order 12 | restore MVI before join | Static metadata verified |
| MNP | Selected | 5.0.5 | Modrinth／GitHub | BSD-3-Clause | `multiverse-netherportals-5.0.5.jar` | `7D6364A2B474C2D3C4F8F8C5DCD469D9DE5A5F6F64C43DA39B648C3877AD077D` | Paper 1.21.11／Java 25 runtime-unverified | Frontier | MV-Core 5.7.2 | Ruined Frontier family only | MNP Config + worlds | Admin | No | No | Order 12 | restore Config with worlds | Main version parity |
| Advanced Portals | Selected | 2.8.0-spigot | Modrinth／Codeberg | LGPL-3.0-only | `advanced-portals-2.8.0-spigot.jar` | `ABD3E4BE48C1F34BC60530AAA344AB8BFFD4146281B8AD33FC83628C93E7287D` | Paper 1.21.11／26.2 and Velocity listed | Proxy + 3 Paper | none declared | backend Gate only | Plugin Config | Admin; traversal General | No | No | Order 12／17 | previous Config + disable Gates | Runtime enablement pending |
| Iris Engine | Selected | 3.9.2 | GitHub／Volmit | GPL-3.0 | `Iris-3.9.2-1.20.1-1.21.11.jar` | `46E3CD36B08EE6B24B6EC0ECC38379BEF82DADB861DDEBC10E0E338FDB7A7757` | 1.20.1–1.21.11／Java 21+ | Frontier | none declared | `frontier_iris` only | Iris Artifact + world | Admin | Pack input | No | Order 15 | restore locked Engine／Pack／world | Runtime generation pending |
| Iris Overworld Pack | Selected | version 4000 snapshot | IrisDimensions GitHub | Unlicense | `overworld-master.zip` | `0FA29D96D07B19EDBA3EFCA8E10DCEAAE24E94C7651C1ED888E54FA358144056` | static verified; runtime unverified | Frontier Iris pack | Iris 3.9.2 | `frontier_iris` only | locked Pack + world | Admin | Yes | No | Order 15 | restore exact Pack before world load | No Worlds Beyond Nether／End |
| LeafGrapple | Selected | 1.0.2 | Modrinth／GitHub | MIT | `LeafGrapple.jar` | `FFE4B3305BB48737E1B6C373698FEFE7121B879FD5B9399F930F5023B5F78833` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | none declared | Worlds Beyond only | Plugin Config／Item PDC | Custom Plugin + Admin | Yes | No | Order 15 | disable Plugin and reject Theme item | Defaults require boundary tuning |
| EliteMobs | Selected | 10.7.3 | Modrinth／GitHub | GPL-3.0-only | `EliteMobs.jar` | `688E93033A36F4168B2F69B8A65921FBB36AFFC047AA9534027724A2E5DA674E` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | WE／WG | Guild／RF／Primis／approved Instance | Plugin storage + Content worlds | Admin／adopted player nodes | Yes | No | Order 13／14 | restore Content and Plugin data together | Guild Artifact deferred |
| Elite Content | Selected with Guild deferral | exact recorded versions except Guild | Nightbreak／MagmaGuy | per-package terms | three exact filenames + Guild pending | three hashes recorded; Guild pending | Engine/content runtime-unverified | Frontier imports | EliteMobs／FMM as applicable | Guild／Primis／RF／Instance | Package + worlds + Plugin data | Admin | Yes | Guild only | Order 12／13／14 | package-specific restore | `/em setup` required for Guild Link |
| BetterStructures | Selected | 2.6.3 | Modrinth／GitHub | LGPL-3.0-only | `BetterStructures.jar` | `AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | WE 7.4.4 | `frontier_bs*` only | Plugin data + worlds | Admin | Yes | No | Order 14 | remove from allowlist; no retrofit | Locked after Proposal approval |
| BS Content set | Selected pending terms | v6／v2／v1／v3 + Prop | Nightbreak／existing user-owned | per-package terms | exact existing names | recorded in inventory | Engine runtime-unverified | Frontier BS imports | BS／FMM | `frontier_bs*` only | ignored originals + generated working copy | Admin | Yes | license confirmation | Order 14 | exact original archives | Premium same-owner use confirmation |
| FMM | Selected | 2.10.2 | Modrinth／GitHub | GPL-3.0-only | `FreeMinecraftModels.jar` | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | none | backend asset service | FMM Content/output | Admin | Yes | No | Order 12 | restore Content and output | Independent Frontier output |
| RPM | Selected | 2.3.0 | Modrinth／GitHub | LGPL-3.0-only | `ResourcePackManager.jar` | `240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | pack inputs | backend pack service | RPM Config/output | Admin | Yes | No | Order 12 | previous verified ZIP／Config | URL/hash generated later |
| CoreProtect | Artifact candidate; product unselected | 24.0 | Modrinth／GitHub | Artistic-2.0 | `CoreProtect-CE-24.0.jar` | `66CD362089BB8430E5A018EE77E9B433BF0DC9E65590D5F1A043A78D60415696` | Paper 1.21.11 listed／Java runtime-unverified | Not placed | optional MariaDB | none until separate selection | none | Admin if adopted | No | No | separate history task | no Runtime change | Not adopted; not a backup replacement |
| BetterHealthBar3 | Selected user-owned | 4.1.0 | Spigot | premium account-bound terms | `BetterHealthBar-4.1.0.jar` | `BA78BDC0A293A8516155D6334437881C4E92D3C4F1D786AB38064EA5B032D5F6` | static adapters through 1.21 R7; runtime-unverified | Frontier | soft PAPI／ModelEngine／MythicMobs | Guild／RF／Primis／approved Instance | Plugin Config／RPM Pack | Admin | Yes | No | Order 12 + Order 14 smoke | disable self-host; restore Pack／Config | No Port 8163 |
| Wayfarer_Core | Future | Order 9 release | one future external multi-module repository | future | future | future | target contracts only | Main + Frontier | approved APIs only | network approved scope | future MariaDB | `wayfarer.core.*` | optional own assets | future | Order 9 | release-specific | Deferred to Order 9 |
| Wayfarer_Main | Future | Order 10 release | same future external multi-module repository | future | future | future | Paper 26.2／Java 25 target | Main only | Core／economy contracts | Main Growth Pickaxe only | `wf_main_*` MariaDB | `wayfarer.main.*` | optional own assets | future | Order 10 | release-specific | Never placed on Frontier |
| Wayfarer_Frontier | Future | Order 11 release | same future external multi-module repository | future | future | future | Paper 1.21.11／Java 25 target | Frontier | MVI/AP/EM/RPM APIs | fail-closed allowlist | future MariaDB; never normal inventory | `wayfarer.frontier.*` | own assets | future | Order 11／13 | release-specific | Deferred to Order 11 |
| Wayfarer_Frontier_EliteMobsMVI | Conditional future | only if `ADAPTER_REQUIRED` | same future external multi-module repository | future | future | future | Frontier target | Frontier only if required | MVI／EliteMobs contract | approved Instance registration only | audit／reconcile only | dedicated namespace | No | future | Order 13 | remove Artifact and registrations | Independent Runtime Plugin, not an internal Frontier module |

| Area | Recommendation | Lock timing |
| --- | --- | --- |
| Baseline | Paper 1.21.11 build 132／Java 25／frontier_gate | Locked now |
| MVI | 5.3.5, groups `neutral`／`worlds_beyond`／`guild`, explicit shares | static locked; runtime Order 12 |
| MNP | 5.0.5, Ruined Frontier portal family only | static locked; runtime Order 12 |
| Gate | Advanced Portals 2.8.0 using `proxy:` | static locked; runtime Order 12／17 |
| Iris | Engine 3.9.2 + Overworld Pack; `frontier_iris` only | static locked; runtime Order 15 |
| LeafGrapple | 1.0.2, Worlds Beyond only | static locked; runtime Order 15 |
| EliteMobs | 10.7.3 + specified Content set | Guild Artifact deferred to Order 12／13 |
| BetterStructures | 2.6.3 + four Structure packs + Prop pack; no full 103 | after license confirmation |
| FMM／RPM | 2.10.2／2.3.0, independent Frontier output | selected existing |
| BetterHealthBar3 | User-owned 4.1.0; disable self-host and merge Pack | runtime Order 12 |
| History | Product unselected; CoreProtect 24.0 Artifact candidate | separate selection and validation |
| Custom Plugins | one external multi-module Repository; Core／Main／Frontier required | Order 9～11 |
| Conditional Adapter | independent Artifact only if `ADAPTER_REQUIRED` | Order 13 |
| Gate coordinates／Builder nodes | no exact values | Order 17／18 |

Revision 003の正式Approvalは、Adventurer's GuildのExact Artifact Lockを
Order 12／13へ繰り越す既知の例外を含む。後続の公式`/em setup` Flowで得た
Artifactが要件に合わない場合は、Guild部分を新ProposalへRevisionし、Runtime
導入を停止する。既存user-owned premium Contentの同一Owner利用条件も維持する。

Reserved approval token:

```text
APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-003
```

このTokenはRevision 003全体と、Adventurer's Guild Artifactだけを後続Orderへ
繰り越す例外へのExact Approvalを表す。Proposal 001／002のTokenは無効であり、
Proposal 002のTokenは実行されていない。

## Deferred validation and implementation order

```text
Order 9  Plugin Repository foundation + Wayfarer_Core
Order 10 Wayfarer_Main / Growth Pickaxe
Order 11 Wayfarer_Frontier
Order 12 Frontier shared foundation
Order 13 EliteMobs–MVI Adapter necessity decision
Order 14 Ruined Frontier alpha
Order 15 Worlds Beyond MVP (`frontier_iris` only)
Order 16 Frontier two-Theme integration
Order 17 final Gate and Permission lock
Order 18 Builder Phase 1B
Order 19 User Hub / Gate construction
Order 20 Main Spawn protection
Order 21 Portal Routing completion
Order 22 Resource Reset Bootstrap
Order 23 Integrated operations
Order 24 Cold Backup / Isolated Restore
Order 25 V0.1.0 Pre-release Player State Reset
Order 26 V0.1.0 Baseline
```

## Runtime non-change evidence

- `servers/frontier/plugins/`へ書込みなし
- `servers/frontier/`Worldへ書込みなし
- Main／Lobby Runtimeへ書込みなし
- Server起動なし
- MariaDB／Redis／LuckPerms操作なし
- Protected Port開放なし
- JAR／ZIP／World／Log／DBはStageしない
- Static inspection用ArtifactをDownloadしていない

候補YAMLは設計値であり、生成ConfigのKeyとして直接使用しない。実Configは各Exact Pluginを初回起動して生成後、公式Documentationと照合して作成する。
