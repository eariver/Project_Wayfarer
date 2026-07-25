# Frontier manual acquisition staging

このDirectoryは、Frontier V0.1.0 Lock候補をUserが公式配布元から手動取得するための、Repository-localかつGit無視対象のStaging場所です。

`README.md`だけをGit管理し、JAR、ZIP、Pack、Model、Contentおよび展開物はCommitしません。CodexはこれらをDownloadしません。

## Revision 003の正式Lock状態

Proposal `FRONTIER-LOCK-20260726-003`は正式承認済みです。Proposal 002は
承認前に置き換えられ、そのTokenは使用されていません。Runtime導入は未実施です。

次の手動配置Artifactは静的確認済みです。元Filenameを変更せず、現在の配置を維持してください。

| Subdirectory | Artifact | Result |
| --- | --- | --- |
| `multiverse/` | Multiverse-Inventories 5.3.5 | 確認済み |
| `gate/` | Advanced Portals 2.8.0 | 確認済み |
| `iris/` | Iris 3.9.2 for 1.20.1–1.21.11 | 確認済み |
| `iris/packs/` | IrisDimensions Overworld | 確認済み、Worlds Beyond唯一のWorldに使用 |
| `elitemobs/` | EliteMobs 10.7.3 | 確認済み |
| `elitemobs/content/` | Primis | 確認済み |
| `elitemobs/content/` | Free Elite Shrines | 確認済み |
| `elitemobs/content/` | Dungeoneering Modules Free | 確認済み |
| `worlds-beyond/` | LeafGrapple 1.0.2 | 確認済み |
| `gui/` | BetterHealthBar 4.1.0 | 確認済み、User-owned premium Artifact |

Multiverse-NetherPortalsは、MainとVersionを揃えるUser決定により、既存の
`manual-downloads/worlds/multiverse-netherportals-5.0.5.jar`を再利用します。
このDirectoryへ複製する必要はありません。

Worlds BeyondはIris Overworld `frontier_iris`だけで構成します。Nether／End
Worldおよび対応Iris Packは導入対象ではありません。配置済みの
`iris/packs/end-main.zip`は内部Environmentも要件に合わず、不採用のまま
Runtimeへ配置しません。

## 残る手動取得

Adventurer's Guildの正規Download Linkは、EliteMobsの公式`/em setup` Flowで
提示されます。Order 8ではServerを起動しなかったため、Artifactの取得、
Version、Filename、License、SHA-256確認を承認済み例外としてOrder 12／13へ繰り越します。
公式Flowで取得後、元Filenameのまま`elitemobs/content/`へ配置してください。

## 既存Artifactの再利用候補

次は既に別のIgnored Staging Directoryに存在します。ここへ複製する必要はありません。

- BetterStructures 2.6.3
- FreeMinecraftModels 2.10.2
- ResourcePackManager 2.3.0
- BetterStructures Prop Pack
- Exploration Pack v6
- Caves and Lost Civilizations Free v2
- Adventure Pack internal v1
- Echoes of the Past v3
- CoreProtect CE 24.0

Premiumまたはaccount-bound Contentは、Project Wayfarerの同一OwnerがFrontier
Backendでも利用できるLicense／利用条件をUserが確認したものだけを使用してください。

## 禁止

- Runtimeの`servers/frontier/plugins/`へ直接配置しない。
- Archiveを展開してGit管理しない。
- 自動UpdaterやPlugin内Download Commandを、取得許可なしに使わない。
- Filenameを正規化、短縮またはVersion除去しない。
