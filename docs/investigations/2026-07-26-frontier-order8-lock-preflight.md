# Frontier Order 8 Lock Preflight

## Summary

| Item | Result |
| --- | --- |
| Date | 2026-07-26 |
| Proposal ID | `FRONTIER-LOCK-20260726-001` |
| Pre-execution HEAD | `354052c9dd80d77b8b83c49f783e4d4b7b8755fd` |
| Branch／Remote | `main`／`origin` |
| Phase | A — static research and candidate lock only |
| Runtime change | None |
| World／DB／Permission change | None |
| Decision Gate | Candidate prepared; missing Artifacts and license confirmation remain |

本Reportは、Order 8の正式Lock前に行ったRepository-local Inventory、Artifact静的確認、公式情報調査および境界候補を記録する。Runtime導入、Server起動、World生成、Database操作、Permission変更、Pack生成は行っていない。

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

## Official compatibility evidence

公式配布Metadataは2026-07-26に再確認した。Modrinthが公開するFile HashはSHA-1／SHA-512でありSHA-256ではないため、未取得ArtifactのSHA-256は`null`のままにした。

| Component | Candidate | Official evidence | Compatibility | License | Result |
| --- | --- | --- | --- | --- | --- |
| Multiverse-Inventories | 5.3.5 | [Modrinth release](https://modrinth.com/plugin/multiverse-inventories/version/5.3.5) | Paper／1.21.11 listed; MV-Core required | BSD-3-Clause | selected, Artifact pending |
| Multiverse-NetherPortals | 5.1.0 | [Modrinth project](https://modrinth.com/plugin/multiverse-netherportals) | Paper／1.21.11 listed | BSD-3-Clause | selected, Artifact pending |
| Advanced Portals | 2.8.0-spigot | [Modrinth release](https://modrinth.com/plugin/advanced-portals/version/OiYxu4ab) | Paper, Velocity, 1.21.11, 26.2 listed | LGPL-3.0-only | package inspection pending |
| Iris | 3.9.2 | [GitHub release](https://github.com/VolmitSoftware/Iris/releases/tag/3.9.2-1.20.1-1.21.11) | release tag explicitly targets 1.20.1–1.21.11; Java 21+ | GPL-3.0 | Engine selected, binary pending |
| LeafGrapple | 1.0.2 | [Modrinth release](https://modrinth.com/plugin/leafgrapple/version/Do80frax) | Paper／1.21.11 listed | MIT | selected, Artifact pending |
| EliteMobs | 10.7.3 | [Modrinth release](https://modrinth.com/plugin/elitemobs/version/D1rNCpLn) | Paper／1.21.11 listed | GPL-3.0-only | selected, Artifact／Content pending |
| BetterStructures | 2.6.3 | [Modrinth release](https://modrinth.com/plugin/betterstructures/version/2.6.3) | Paper／1.21.11 listed | LGPL-3.0-only | existing Artifact selected |
| FreeMinecraftModels | 2.10.2 | [Modrinth release](https://modrinth.com/plugin/free-minecraft-models/version/sQDrL88L) | Paper／1.21.11 listed | GPL-3.0-only | existing Artifact selected |
| ResourcePackManager | 2.3.0 | [Modrinth project](https://modrinth.com/plugin/resourcepackmanager) | Paper／1.21.11 listed | LGPL-3.0-only | existing Artifact selected |
| CoreProtect CE | 24.0 | [Modrinth release](https://modrinth.com/plugin/coreprotect/version/24.0) | Paper／1.21.11 listed | Artistic-2.0 | selected-for-later-validation |
| BetterHealthBar3 | 3.10.0 | [GitHub release](https://github.com/toxicity188/BetterHealthBar3/releases/tag/3.10.0)／[README](https://github.com/toxicity188/BetterHealthBar3) | README states 1.19.4–1.21.4 only | premium use terms in README | rejected for current Lock |

MNP 5.0.5は現行Mainで使用中だが、5.1.0が2026-07-23に安定版として公開済みである。Order 8では5.0.5を新規Frontier Lockへ流用せず、5.1.0のArtifact確認とRuntime試験を要求する。

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

GameModeはMVI share keyとして確認できず、Theme間の自動共有対象にしない。Potion、Bed Spawn、Location、Advancement、Recipe、Statistics、Economyも初期共有しない。World切替、Death／Respawn、Reconnect、Shutdown、EliteMobs InstanceのWildcard／API登録はOrder 11／12の詳細試験へ送る。

通常Player Stateの唯一のRuntime正本はMVIであり、Wayfarer_FrontierがInventoryをMariaDBへ再実装しない。

## World ID collision check

候補9件は、現在のFolder名、`level-name`およびMultiverse登録と完全一致しないことを確認した。

| Purpose | Candidate | Collision |
| --- | --- | --- |
| Entry | `frontier_gate` | existing, retained |
| Worlds Beyond | `frontier_iris`, `frontier_iris_nether`, `frontier_iris_the_end` | none |
| Guild | `adventurers_guild` | none; package fixed name pending |
| Ruined Frontier | `frontier_bs`, `frontier_bs_nether`, `frontier_bs_the_end` | none |
| Primis | `primis` | none; package fixed name pending |

`frontier_gate_nether`、`frontier_gate_the_end`、`world`、`world_nether`、`world_the_end`は未登録の既存Legacy Directoryとして除外し、削除・Rename・再利用しない。EliteMobs Content内の固定World／Blueprint／Instance名はArtifact取得後に照合する。

## Portal and Gate proposal

### Portal family

- Worlds Beyond: `frontier_iris` ↔ `frontier_iris_nether`／`frontier_iris_the_end`
- Ruined Frontier: `frontier_bs` ↔ `frontier_bs_nether`／`frontier_bs_the_end`
- Theme間、Main、`frontier_gate`のVanilla Nether／EndへのLinkは禁止

MNP 5.1.0をFamily-local explicit linkの候補とする。End exit、Mob／Item／Vehicleおよび`handle-end-exit-respawn`の実Keyは生成Config確認後に決める。

### Backend Gate

Advanced Portals 2.8.0を第一候補とする。[公式Portal Tags](https://advancedportals.sekwah.com/docs/portal-tags/)では、`proxy:`がProxy componentを使いVelocityのBungee message channelを不要にし、`permission:`と`cooldown:`を持つ。したがって`bungee:`ではなく`proxy:`を候補Lockとする。

ただし配布Metadataは1個の`advanced-portals-2.8.0-spigot.jar`をPaperとVelocity両方に列挙している。JAR内の各Platform Metadata／Entrypointを実物で確認するまで、同一Fileを4 Runtimeへ配置するとは確定しない。

## Iris Engine and Pack comparison

Engine候補はIris `3.9.2-1.20.1-1.21.11`である。公式IrisDimensions Organizationから三次元候補を抽出した。

| Proposal | Overworld | Nether | End | License | Assessment |
| --- | --- | --- | --- | --- | --- |
| A — official collection trio | `overworld@78b581c` | `nether@ca28243` | `end@fec65d5` | Unlicense／GPL-3.0 | recommended for Artifact inspection; Nether最終更新が2021年のため未Lock |
| B — official Overworld + Vanilla Nether／End | current Overworld | Vanilla | Vanilla | mixed | rejected; three Iris dimensionsというWorlds Beyond設計を満たさない |
| C — new custom／third-party trio | unselected | unselected | unselected | unknown | rejected; V0.1.0 Scope拡張と新規Pack選定になる |

Official repositories:

- [IrisDimensions/overworld](https://github.com/IrisDimensions/overworld)
- [IrisDimensions/nether](https://github.com/IrisDimensions/nether)
- [IrisDimensions/end](https://github.com/IrisDimensions/end)

Proposal Aを推奨するが、3 Archiveの実物、内部Dimension ID、Pack format、1.21.11 Data、固定Seed利用、Vanilla Structure挙動およびRuntime生成を確認するまでPack Lockは成立しない。

## EliteMobs Content preflight

EliteMobs Engine 10.7.3は選定可能だが、次のContent Artifactが存在しない。

| Content | Current evidence | Static result |
| --- | --- | --- |
| Adventurer's Guild | [official free-content page](https://magmaguy.itch.io/em-free-content) lists `em_adventurers_guild_v8.zip` | Artifact pending |
| Primis | official Content distribution required | filename／version／world ID pending |
| Free Elite Shrines | official Content distribution required | filename／version／blueprint IDs pending |
| Dungeoneering Modules Free | official Content distribution required | filename／version／instance names pending |

[Official EliteMobs documentation](https://wiki.nightbreak.io/EliteMobs/dungeon_packager/) states current dungeon packages are world-based. Consequently、MVI static membership、Regex/API handling、fixed/cloned/temporary lifecycle、disconnect/reconnect behavior and backup ownership cannot be inferred from Concept names alone. These are Order 12 acceptance items.

Auto-download、Nightbreak account linking、`downloadall`、Content updaterは使用しない。

## BetterStructures reuse boundary

Existing JARs and five Content inputs are hash-verified and may be reused as candidates. Frontier will create independent Plugin data and Pack output.

- `frontier_bs*`だけをallowlist
- unknown world default false
- `frontier_gate`、Worlds Beyond、Guild、Primis、EM Instanceではoff
- full `103 Default Structures` pack is rejected for initial Frontier
- exact Structure ID、enablement、weight、separationはOrder 13
- Main normalization output／Runtime ConfigはCopyしない
- premium／account-bound Packの別Backend利用権はUser confirmation required

## Resource Pack collision preflight

Existing Main priority is `ResourcePackManager > FreeMinecraftModels > BetterStructures`。Frontierは独立Packとし、候補優先度をProject-owned assets、Theme item、EliteMobs、FMM、BetterStructures、RPMの順にする。

| Namespace／ID | Source A | Source B | Static result | Resolution owner |
| --- | --- | --- | --- | --- |
| BetterStructures Prop model IDs | existing FMM input | Frontier reuse | Backend-separated; Client switch test required | Order 11 |
| CustomModelData／Item Model Component | missing EliteMobs | missing LeafGrapple | unresolved | Order 11 |
| Font／Shader | BetterHealthBar3 | future combined pack | candidate rejected, no current conflict | later adoption task |
| Model／Texture path | FMM／BS | missing Elite content | unresolved | Order 11 |
| `pack.mcmeta` | all inputs | RPM generated output | generation deferred | RPM／Order 11 |

[ResourcePackManager official description](https://modrinth.com/plugin/resourcepackmanager) states that duplicate model IDs and GUI font conflicts are resolved by priority rather than semantically merged, and Java players receive backend packs on server switch. Therefore missing inputs must be inspected and a Lobby→Frontier→Main switch test is mandatory.

Order 8では最終ZIP、URL、SHA-1、SHA-256、Sizeを生成しない。Self-host Portを開かず、temporary remote hostingもOrder 11の明示的受入時だけ使用する。

## History／rollback decision

CoreProtect CE 24.0を`selected-for-later-validation`とする。

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
| History | CoreProtect candidate | storage pending | separate owner | after world／DB restore | Frontier only |

RedisをInventory、Theme StateまたはEliteMobs Itemの正本にしない。

## Permission boundary

Order 8はPermissionを変更しない。

- Temporary Admin only: MVI／MNP／Gate／Iris／EliteMobs／BetterStructures／FMM／RPM／History／DB／World lifecycle administration
- General Player: approved Gate traversal、Theme gameplay、approved GUI only
- Builder: no new node; exact minimum allowlist is deferred to Order 16／17
- Custom Plugins: `wayfarer.core.*`／`wayfarer.frontier.*` namespaces are future design; no wildcard

## Custom Plugin contract handoff

Order 8でLockする候補境界：

- Wayfarer_Core／Wayfarer_Frontierは別Repository、別Release
- Paper 1.21.11／Java 25 target for Frontier-side integration
- MVI、Gate、EliteMobs、RPMの機能を再実装しない
- normal Inventory／ItemはMariaDBへ複製しない
- Wayfarer_Frontier owns Worlds Beyond discovery／waystone domain
- Wayfarer_Core owns approved network audit／transaction domain
- EliteMobs Adapter necessity and API/Event contract are deferred to Order 12
- released JAR is later manually staged, hash-locked and installed by Project Wayfarer

## License and acquisition matrix

| Artifact | Class | Present | License／terms | User action |
| --- | --- | ---: | --- | --- |
| MVI／MNP | B | No | BSD-3-Clause | manual official acquisition |
| Advanced Portals | B | No | LGPL-3.0-only | manual official acquisition |
| Iris Engine | B | No | GPL-3.0 | manual official acquisition |
| Iris official packs | B | No | Unlicense／GPL-3.0 | manual official acquisition |
| EliteMobs | B | No | GPL-3.0-only | manual official acquisition |
| EliteMobs free Content | B／terms per package | No | package terms require inspection | manual official acquisition |
| LeafGrapple | B | No | MIT | manual official acquisition |
| BS／FMM／RPM JARs | D | Yes | LGPL／GPL | hash re-audited |
| BS Content | D | Yes | package terms vary | confirm same-owner Frontier use |
| CoreProtect | D | Yes | Artistic-2.0 | later runtime validation |
| BetterHealthBar3 | C | No | premium use terms | do not acquire for current Lock |
| Wayfarer_Core／Frontier | E | future | future project license | Order 9／10 |

## Missing Artifact and manual action

Exact staging paths are listed in [`manual-downloads/frontier/README.md`](../../manual-downloads/frontier/README.md).

Missing SHA-256／internal metadata:

1. MVI 5.3.5
2. MNP 5.1.0
3. Advanced Portals 2.8.0 package
4. Iris 3.9.2 binary
5. Iris Overworld／Nether／End candidate archives
6. EliteMobs 10.7.3
7. Adventurer's Guild v8
8. Primis
9. Free Elite Shrines
10. Dungeoneering Modules Free
11. LeafGrapple 1.0.2

User confirmation required:

- Existing user-owned BetterStructures Prop／Adventure／Echoes artifacts may be used on the same owner's Frontier Backend under their acquisition terms.

## Recommended Lock Proposal

Proposal: `FRONTIER-LOCK-20260726-001`

### Component decision table

`pending`のSHA-256は未取得Artifactを意味し、正式Lock前に必ず実物から計算する。

| Component | Selected／Unselected | Exact Version | Official Source | License | Artifact Filename | SHA-256 | Compatibility | Placement | Dependencies | World scope | Persistence owner | Permission owner | Pack input | Manual acquisition | Deferred validation | Rollback boundary | Known limitation／Timing |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| MVI | Selected pending | 5.3.5 | Modrinth／GitHub | BSD-3-Clause | `multiverse-inventories-5.3.5.jar` | pending | Paper 1.21.11／Java 25 runtime-unverified | Frontier | MV-Core 5.7.2 | all Frontier via 3 groups | MVI | Admin | No | Yes | Order 11 | restore MVI before join | Artifact pending; Locked after hash |
| MNP | Selected pending | 5.1.0 | Modrinth／GitHub | BSD-3-Clause | `multiverse-netherportals-5.1.0.jar` | pending | Paper 1.21.11／Java 25 runtime-unverified | Frontier | MV-Core 5.7.2 | WB／RF families | MNP Config + worlds | Admin | No | Yes | Order 11 | restore Config with worlds | 5.0.5 rejected for new Lock |
| Advanced Portals | Selected pending | 2.8.0-spigot | Modrinth／Codeberg | LGPL-3.0-only | `advanced-portals-2.8.0-spigot.jar` | pending | Paper 1.21.11／26.2 and Velocity listed | Proxy + 3 Paper pending inspection | none declared | backend Gate only | Plugin Config | Admin; traversal General | No | Yes | Order 11／16 | previous Config + disable Gates | Platform Entrypoints pending |
| Iris Engine | Selected pending | 3.9.2 | GitHub／Volmit | GPL-3.0 | official original filename pending | pending | 1.20.1–1.21.11／Java 21+ | Frontier | none declared | Worlds Beyond | Iris Artifact + worlds | Admin | Pack only if required | Yes | Order 14 | restore locked Engine／Pack／world | Binary pending |
| Iris 3-Pack | Selected candidate A | exact commits recorded | IrisDimensions GitHub | Unlicense／GPL-3.0 | original archives pending | pending | static and runtime unverified | Frontier Iris packs | Iris 3.9.2 | Worlds Beyond 3 worlds | locked Pack + worlds | Admin | Unknown until inspection | Yes | Order 14 | restore exact Pack before world load | Nether pack age; not Lockable yet |
| LeafGrapple | Selected pending | 1.0.2 | Modrinth／GitHub | MIT | `LeafGrapple.jar` | pending | Paper 1.21.11 listed／Java runtime-unverified | Frontier | none declared | Worlds Beyond only | Plugin Config／Item PDC | Custom Plugin + Admin | Yes | Yes | Order 14 | disable Plugin and reject Theme item | PDC／offhand／model pending |
| EliteMobs | Selected pending | 10.7.3 | Modrinth／GitHub | GPL-3.0-only | `EliteMobs.jar` | pending | Paper 1.21.11 listed／Java runtime-unverified | Frontier | WE／WG | Guild／RF／Primis／approved Instance | Plugin storage + Content worlds | Admin／adopted player nodes | Yes | Yes | Order 12／13 | restore Content and Plugin data together | Instance/API names pending |
| Elite Content | Selected pending | exact package versions pending | Nightbreak／MagmaGuy | per-package terms | original filenames pending | pending | Engine/content runtime-unverified | Frontier imports | EliteMobs／FMM as applicable | Guild／Primis／RF／Instance | Package + worlds + Plugin data | Admin | Yes | Yes | Order 12／13 | package-specific restore | Blueprint and fixed world names pending |
| BetterStructures | Selected | 2.6.3 | Modrinth／GitHub | LGPL-3.0-only | `BetterStructures.jar` | `AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | WE 7.4.4 | `frontier_bs*` only | Plugin data + worlds | Admin | Yes | No | Order 13 | remove from allowlist; no retrofit | Locked after Proposal approval |
| BS Content set | Selected pending terms | v6／v2／v1／v3 + Prop | Nightbreak／existing user-owned | per-package terms | exact existing names | recorded in inventory | Engine runtime-unverified | Frontier BS imports | BS／FMM | `frontier_bs*` only | ignored originals + generated working copy | Admin | Yes | license confirmation | Order 13 | exact original archives | Premium same-owner use confirmation |
| FMM | Selected | 2.10.2 | Modrinth／GitHub | GPL-3.0-only | `FreeMinecraftModels.jar` | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | none | backend asset service | FMM Content/output | Admin | Yes | No | Order 11 | restore Content and output | Independent Frontier output |
| RPM | Selected | 2.3.0 | Modrinth／GitHub | LGPL-3.0-only | `ResourcePackManager.jar` | `240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | pack inputs | backend pack service | RPM Config/output | Admin | Yes | No | Order 11 | previous verified ZIP／Config | URL/hash generated later |
| CoreProtect | Selected for validation | 24.0 | Modrinth／GitHub | Artistic-2.0 | `CoreProtect-CE-24.0.jar` | `66CD362089BB8430E5A018EE77E9B433BF0DC9E65590D5F1A043A78D60415696` | Paper 1.21.11 listed／Java runtime-unverified | Frontier | optional MariaDB | persistent known worlds; no dynamic Instance | CoreProtect DB | Admin | No | No | separate history task | disable Plugin; DB remains separate | Not a backup replacement |
| BetterHealthBar3 | Unselected／Rejected | 3.10.0 | GitHub／Spigot purchase | premium terms | none | n/a | official README only through 1.21.4 | none | none | none | none | none | No | No | future compatible release | none | Rejected |
| Wayfarer_Core | Future | Order 9 release | future separate repository | future | future | future | target contracts only | later manual integration | approved APIs only | network approved scope | future MariaDB | `wayfarer.core.*` | optional own assets | future | Order 9 | release-specific | Deferred to Order 9 |
| Wayfarer_Frontier | Future | Order 10 release | future separate repository | future | future | future | Paper 1.21.11／Java 25 target | Frontier | MVI/AP/EM/RPM APIs | fail-closed allowlist | future MariaDB; never normal inventory | `wayfarer.frontier.*` | own assets | future | Order 10／12 | release-specific | Deferred to Order 10 |

| Area | Recommendation | Lock timing |
| --- | --- | --- |
| Baseline | Paper 1.21.11 build 132／Java 25／frontier_gate | Locked now |
| MVI | 5.3.5, groups `neutral`／`worlds_beyond`／`guild`, explicit shares | after Artifact hash |
| MNP | 5.1.0, two isolated portal families | after Artifact hash |
| Gate | Advanced Portals 2.8.0 using `proxy:` | after package inspection |
| Iris | Engine 3.9.2 + official collection trio candidate | Pack Lock blocked pending artifacts |
| LeafGrapple | 1.0.2, Worlds Beyond only | after Artifact inspection |
| EliteMobs | 10.7.3 + specified Content set | after Content inspection |
| BetterStructures | 2.6.3 + four Structure packs + Prop pack; no full 103 | after license confirmation |
| FMM／RPM | 2.10.2／2.3.0, independent Frontier output | selected existing |
| BetterHealthBar3 | reject current 3.10.0 candidate | Rejected |
| History | CoreProtect 24.0 | selected-for-later-validation |
| Custom Plugins | external repositories and authority boundaries | Order 9／10 |
| Gate coordinates／Builder nodes | no exact values | Order 16／17 |

正式Approvalの前に、missing ArtifactのSHA-256／internal metadataとpremium reuse confirmationを埋める必要がある。Artifactが候補と一致しない場合はProposalをRevisionし、旧Tokenを無効にする。

Reserved approval token:

```text
APPROVE-WAYFARER-FRONTIER-LOCK:FRONTIER-LOCK-20260726-001
```

現時点ではArtifact不足のため、このTokenを送信しない。必要Artifact配置後にCodexが再検証し、Proposalが変更されないことを確認してから使用する。

## Deferred validation and implementation order

```text
Order 9  Wayfarer_Core formal design / repository / release
Order 10 Wayfarer_Frontier formal design / repository / release
Order 11 MVI, MNP, RPM, FMM, Pack and Gate foundation
Order 12 EliteMobs–MVI Adapter necessity decision
Order 13 Ruined Frontier alpha
Order 14 Worlds Beyond MVP
Order 15 two-Theme integration
Order 16 final Gate and Permission lock
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
