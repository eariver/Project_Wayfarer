# Frontier manual acquisition staging

このDirectoryは、Frontier V0.1.0 Lock候補をUserが公式配布元から手動取得するための、Repository-localかつGit無視対象のStaging場所です。

`README.md`だけをGit管理し、JAR、ZIP、Pack、Model、Contentおよび展開物はCommitしません。CodexはこれらをDownloadしません。

## Phase Aで不足しているArtifact

元の配布Filenameを変更せず、次のSubdirectoryへ配置してください。

| Subdirectory | Candidate | Expected official filename |
| --- | --- | --- |
| `multiverse/` | Multiverse-Inventories 5.3.5 | `multiverse-inventories-5.3.5.jar` |
| `multiverse/` | Multiverse-NetherPortals 5.1.0 | `multiverse-netherportals-5.1.0.jar` |
| `gate/` | Advanced Portals 2.8.0 | `advanced-portals-2.8.0-spigot.jar` |
| `iris/` | Iris 3.9.2 for 1.20.1–1.21.11 | 公式配布時の元Filename |
| `iris/packs/` | IrisDimensions Overworld | 公式Repositoryから取得した元Archive名 |
| `iris/packs/` | IrisDimensions Nether | 公式Repositoryから取得した元Archive名 |
| `iris/packs/` | IrisDimensions End | 公式Repositoryから取得した元Archive名 |
| `elitemobs/` | EliteMobs 10.7.3 | `EliteMobs.jar` |
| `elitemobs/content/` | Adventurer's Guild v8 | `em_adventurers_guild_v8.zip` |
| `elitemobs/content/` | Primis | 公式配布時の元Filename |
| `elitemobs/content/` | Free Elite Shrines | 公式配布時の元Filename |
| `elitemobs/content/` | Dungeoneering Modules Free | 公式配布時の元Filename |
| `worlds-beyond/` | LeafGrapple 1.0.2 | `LeafGrapple.jar` |

BetterHealthBar3は、公式READMEの対応範囲がPaper 1.21.11を明示していないため、今回の取得対象に含めません。

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

Premiumまたはaccount-bound Contentは、Project Wayfarerの同一OwnerがFrontier Backendでも利用できるLicense／利用条件をUserが確認したものだけを配置してください。

## 禁止

- Runtimeの`servers/frontier/plugins/`へ直接配置しない。
- Archiveを展開してGit管理しない。
- 自動UpdaterやPlugin内Download Commandを使わない。
- Filenameを正規化、短縮またはVersion除去しない。
