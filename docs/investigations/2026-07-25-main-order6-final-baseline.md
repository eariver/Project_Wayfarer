# Main Order 6 Final Baseline investigation

## Scope and outcome

Project Wayfarer Ver.0.0.6 Roadmap Order 6 audited the replacement-generated
Main family, selected the Weight／Content decision, repeated focused Runtime
validation, and created a verified stopped-state backup.

Outcome:

- Decision A: accept the current Config as-is;
- no Weight, Distance, Offset, Altitude, Structure selection, World allowlist,
  Spawn protection, Content, Model, Pack input, World, Region, Seed, UUID,
  Spawn, Portal, or Player Data change;
- Orders 4–6 complete;
- the 2026-07-25 replacement family is the **Final Main Baseline**;
- Order 7 CoreProtect remains next;
- this is not the V0.1.0 Release Baseline, network cold backup, isolated
  restore, pre-release Player State reset, Tag, or Release.

## Authorization and Git state

| Item | Value |
| --- | --- |
| Date | 2026-07-25 |
| Repository | `D:\MCServers\Project_Wayfarer` |
| Branch | `main` |
| Remote | `https://github.com/eariver/Project_Wayfarer.git` |
| Pre-execution HEAD | `b2eb75a4ee4839e09b8fa4d76270c59b1e8f9f8c` |
| Decision approval | `APPROVE-WAYFARER-MAIN-ORDER6-ACCEPT-AS-IS` |
| Backup approval | `APPROVE-WAYFARER-MAIN-V006-FINAL-BASELINE` |
| Proposal ID | Not applicable |
| Exact Config diff | None |

The worktree initially contained only the user-assigned, untracked Order 6
instruction. Runtime-generated tracked rewrites were identified after the
focused test, compared against the clean starting state, and restored only
after normal shutdown. No user-authored unrelated change was overwritten.

## Decision audit

The enabled selection remained 278 of 430 Structure configurations, with 152
disabled. The accepted packs remained:

1. `103 Default Structures` version 5;
2. `Exploration Pack` version 6;
3. `Caves and Lost Civilizations Free` version 2;
4. `Adventure Pack` internal version 1;
5. `Echoes of the Past` version 3.

Orders 4 and 5 had already produced bounded evidence across three dimensions
and four distinct naturally observed packs. That sample was sufficient to
detect a blocking defect, failed generation, severe over-density, or obvious
performance problem, but not sufficiently broad to justify a numerical
Weight／Distance rebalance. No such defect was found. Changing future
generation behavior without a concrete problem would have introduced an
unnecessary difference between existing and future chunks. Decision A was
therefore recommended and explicitly approved.

The following settings were retained:

- `setupDone: true`;
- `spawnProtectionRadius: 100`;
- `nightbreak.autoDownloadPluginUpdates: false`;
- `main`, `main_nether`, and `main_the_end`: enabled;
- `resource`, `resource_nether`, `resource_end`, and unknown new worlds:
  disabled;
- all current Weight, Distance, Offset, Altitude, and Generator settings.

## Content and artifact locks

Tracked Content Config:

| File | SHA-256 |
| --- | --- |
| `config/main-betterstructures/selection.yml` | `CD087809181C3B5AC0D0721F23596790DE6394A8A1CE2D9095E8D9BDACDEC774` |
| `config/main-betterstructures/prop-id-mapping.yml` | `9880FFF02B28E1BBEDA523EDEFABBB35BB00BD098C1657AC6F410F3581386347` |
| `config/main-betterstructures/entity-removals.yml` | `D8D4B565448D425AE344D99BC49705DED59F6654D04E4082564AD5B4651964E7` |
| `config/main-betterstructures/block-entity-removals.yml` | `324649CE4D18D4CFA822DE64FB68C8793E45CC36BEA878231428BE1CA1F8299B` |

Executable and source artifacts:

| Artifact | SHA-256 |
| --- | --- |
| BetterStructures 2.6.3 | `AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038` |
| WorldEdit 7.4.4 | `44C97EE6C1DF9AFA127DF3C5A2C6A7108F826FB44AB7B255A7EC4250FEB89B9D` |
| FreeMinecraftModels 2.10.2 | `3369C5EFE385B86460C2A596AB6284FF387874FB846669939B52486659327274` |
| ResourcePackManager 2.3.0 | `240809E885F37866EEB756854958B549C947CC7AEE078269DB0CDB18D97F1F64` |
| 103 Default Structures source | `118D873FDF87BF94EA6CA3036897B10790F5D73E62F8387E75C1AB6A4A360FE0` |
| Exploration Pack source | `963CABA2D8BA31E8DA2E0E73D098A57B66E80D6ECF55BBC92CBD7D04F7F4BA4B` |
| Caves and Lost Civilizations Free source | `27527F2713858EE47029C2AE9DE72D74C164FC52297672DBEEAA81BA62C25677` |
| Adventure Pack source | `96061E1166767BEC12087D55C0A7353AE42B970EFE617ACF4B1AF550BDE6AB4C` |
| Echoes of the Past source | `B2F971EB0B27FA9BBDA6BD6503875718621146CEC7E671F0D05366E918CCB51F` |
| BetterStructures Prop Pack | `F39E9C7B5CACA49462A6CC2634F6C2D49DD0F7498744D7DE7960887CC694C04D` |
| Generated Default import | `A4373A2692590734D7D95051819722ED05985A49668BDADDF83B1999D2964463` |
| Generated Exploration import | `CF9FB95A81ACA8993B1781FC784DB9D14B360E40C5B6C613D31019BC845A91E0` |
| Generated Caves import | `CF3E34EEE926DFDD6C67703013298663227BA71AFFA398ED81DD9A6E421478D9` |
| Generated Adventure import | `13949D75D0E5A813EBE7CCBBF6D0D32D9243424BF183D5B2006FA22F339C1F8A` |
| Generated Echoes import | `63D924CF4BFBA5305C8720418D1684AD809B0FAB0385B7439D2259681AE6E0A7` |

The tracked preflight passed again with 430 source, 278 selected, and 152
disabled configurations. The Schematic dry-run audit reported no blocking
risk. FMM retained 55 Models. Codex downloaded or replaced no executable,
Content archive, Schematic, or Model.

## World identity and preservation

| Dimension | Bukkit world | UUID | Seed | Spawn | Regions |
| --- | --- | --- | --- | --- | ---: |
| Overworld | `main` | `d868e7ff-6663-492d-a963-f95f00ce6c30` | `164225356311935743` | `(320,70,128)` | 17 |
| Nether | `main_nether` | `1225688f-7770-43ed-b1dd-71bd112de3b5` | `164225356311935743` | `(20.5,60,-19.5)` | 11 |
| End | `main_the_end` | `436843c4-2229-4c67-907c-b3a7d1530d71` | `164225356311935743` | `(100.5,49,0.5)` | 18 |

`main_end` remained a Multiverse alias only. Persistent and Resource Portal
links remained family-local.

Resource identity:

| World | UUID | Seed | Regions |
| --- | --- | --- | ---: |
| `resource` | `32497466-e0eb-4992-806d-f58011cad5d8` | `619713275114720998` | 8 |
| `resource_nether` | `3b494c31-7c24-49a6-a6c0-2891643086a0` | `-7678977951546477015` | 4 |
| `resource_end` | `8c140721-4bbf-4fd3-8837-d250fd73bba3` | `-2348607286205551648` | 4 |

All 16 current Resource Region hashes matched the replacement rollback
evidence:

| World | Region | SHA-256 |
| --- | --- | --- |
| `resource` | `r.-1.-1.mca` | `C4A983675A00BE9AEAFA7F5CD2228D35A7688925AA84E3690B3DA803CEB6008B` |
| `resource` | `r.-1.0.mca` | `C60D2C9F8C54F6BC626642C5750FB1D853C31C759871D20A528BE99E9BA2DEE7` |
| `resource` | `r.0.-1.mca` | `B8FBA720C3D154F0602D0042CFC73693652D318AB94C0BCA70ED8D973FD265CF` |
| `resource` | `r.0.0.mca` | `E8C8913F92D64F2F29EAB908463B0C1E3E1B249BA7EA818AD279C30FC76EAD36` |
| `resource` | `r.1.1.mca` | `8114B0E25BB5F3470006FF161DC30BF66E400FE46AE3BF50E0917890B3606899` |
| `resource` | `r.1.2.mca` | `5169E174F49CB666C88C2592F34C75584C55B10EAD60341691FADC7179DF0E9D` |
| `resource` | `r.2.1.mca` | `266AF8F117E5783D1267469CCC28956C04372306818284DAF852259DBFBE6D63` |
| `resource` | `r.2.2.mca` | `3E29503D11C7A7538C94305E89F91DF7A9799B1D4E60EC5D0B5D0CC4B37D6AF0` |
| `resource_nether` | `r.-1.-1.mca` | `1286849D0840F3CD8FAD055453B7D73171D6E307E93E1B18C855F8C30555A1BB` |
| `resource_nether` | `r.-1.0.mca` | `7C1AA5C1D699284ABCAE6627600D5B80771E0221BA5E9E5F2AF44BD6C48A8780` |
| `resource_nether` | `r.0.-1.mca` | `E8D18DEAF282C5EE8E5BF053B644DDA006A8812E172BC1AB992FA4DEE7F51DE0` |
| `resource_nether` | `r.0.0.mca` | `736CCED907BB452EFB247078A98BBD2B9346609C24962B33E9F18A62C3FDE405` |
| `resource_end` | `r.-1.-1.mca` | `730EE80459F99CC43E5C34E5436ACF4FFC5DA7B10AFA91DC411E5AC9AEDD8F3F` |
| `resource_end` | `r.-1.0.mca` | `2BBCAF44D29F7342392061CBB742CB51678C93E17856EACD389E31E15E3108F8` |
| `resource_end` | `r.0.-1.mca` | `513484CDDCEDA63F0DE85F7C25FCE61B8DFAEFDB38FB26CAD2BF01137E21E6B9` |
| `resource_end` | `r.0.0.mca` | `81E139A77174A34EBF24C45AF486E5A28778D8DDF37DDAE357BD3EAE401D4A0E` |

## Runtime validation

The managed network started in dependency order and all protected listeners
became available. Main reached `Done` on Paper 26.2 build 62. Startup inspection
found no Order 6-related `ERROR`, `SEVERE`, Exception, failed Schematic,
unresolved Model, duplicate ID, or startup-blocking failure.

The user connected through Velocity, entered Main, and confirmed:

- existing Exploration Bridge Cave rendering and its representative Chest;
- existing End Shrine rendering and the Vase Prop;
- no obvious regression.

No additional natural-generation search was performed. Region counts remained
`17 / 11 / 18` and `8 / 4 / 4`. Temporary Admin was removed, the Player was
returned to Main Spawn, changed to Survival only for cleanup, disconnected, and
the network was stopped normally. Velocity stopped first, the settling wait was
observed, Paper saves were flushed, and Main／Frontier／Lobby stopped normally.
No Project Wayfarer Java process or protected listener remained, and Main
`session.lock` opened exclusively.

Current stopped-state generated packs:

| Pack | Bytes | SHA-1 | SHA-256 |
| --- | ---: | --- | --- |
| Main ResourcePackManager | 838,975 | `029689B8355600DAAFD96D2F057AC04A65E1091D` | `741986F729C68F3876BA577969AD7AD85B3120526A9E309F13880C6F606C11CE` |
| FreeMinecraftModels | 799,622 | `2B1C7468D9274235D64F1ECB0888EFAB1E62EA75` | `055FCD07115F254486435550A6439A73B4361CC01E3B523B245FF39681CA1C2C` |

Generated ZIP container hashes may change when the Plugins rebuild them even
with the same selected inputs. Order 6 records the exact stopped-state files
used for this baseline; the locked source, normalized imports, selection, and
runtime load all remained unchanged.

## Config snapshot hashes

The backup captured these exact pre-documentation-update Config files:

| File | SHA-256 |
| --- | --- |
| `servers/main/server.properties` | `57A28D45E358F0C696D076E3119E40C0CE0C8BD252DBD7AB10348D81C9610979` |
| `servers/main/bukkit.yml` | `A72396BBD1B69636B63F990995ED1CE31DF7183AF275868B4D638071FD4C866A` |
| `servers/main/spigot.yml` | `C8EFE9F92344E37571A237290D5A0C6319999011666D7E1CEABE43129839A97C` |
| `servers/main/config/paper-global.yml` | `4ECDF2312EBE2AC11C1FE1FB80D0CF08B435F5045DF5A6B161466095D62453D7` |
| `servers/main/config/paper-world-defaults.yml` | `718A8CC498E48860C85CE552B775D87E80C16746447ED52B5FA84B05508AFB4E` |
| `servers/main/plugins/BetterStructures/config.yml` | `F369FBC8806C52C6795C18082CB8D447FB3DBAF791344EA9D5E6A242444DC56B` |
| `servers/main/plugins/BetterStructures/ValidWorlds.yml` | `1D9AA23DFDDEBDFCD47CE51CDC7A05F2833A615DA2C75F6450566493D411032F` |
| `servers/main/plugins/Multiverse-Core/worlds.yml` | `97369E2FC3504A28E8350A5851D7F530A9B829CF7871704653FCFE82834FE167` |
| `servers/main/plugins/Multiverse-NetherPortals/config.yml` | `A73001B6EEA0CF86755F2AB4FF22296FB328E4A2598F53039809BB0A6F862E48` |
| `servers/main/plugins/FreeMinecraftModels/config.yml` | `8F1AE37CCBA2F91B5C73FA48FCC1266461EDB1900FC7BD569AC455230A7F2BB9` |
| `servers/main/plugins/ResourcePackManager/config.yml` | `46AD1DF456407300C0BA91A47CCAAB0F1E94FD85199634C894AE2BBACBB695BB` |
| `config/main-betterstructures/selection.yml` | `CD087809181C3B5AC0D0721F23596790DE6394A8A1CE2D9095E8D9BDACDEC774` |
| `config/main-betterstructures/prop-id-mapping.yml` | `9880FFF02B28E1BBEDA523EDEFABBB35BB00BD098C1657AC6F410F3581386347` |
| `config/main-betterstructures/entity-removals.yml` | `D8D4B565448D425AE344D99BC49705DED59F6654D04E4082564AD5B4651964E7` |
| `config/main-betterstructures/block-entity-removals.yml` | `324649CE4D18D4CFA822DE64FB68C8793E45CC36BEA878231428BE1CA1F8299B` |
| `versions.yml` | `2E6A17666ABDBB8C44DF7BDA76213AEF41D76FCFEB194EC504ABE61E67E0C744` |
| `plugin-manifest.yml` | `25DF2E60C9C0AC94DE4A4FE098E2354DF17CB84F437DE7D2747ED781B8BF987B` |

The last two hashes identify the pre-finalization snapshots stored in the
backup. Their tracked files were subsequently updated to record this completed
baseline.

## Backup implementation and validation

`scripts/Invoke-MainV006FinalBaselineBackup.ps1` defaults to Dry Run and
requires both `-Execute` and the exact case-sensitive backup token. It accepts
only direct children matching:

```text
backups/main-v006-final-baseline-YYYYMMDD-HHMMSS.incomplete
```

The script rejects an invalid or escaping path, existing incomplete/final
destination, missing or wrong-case token, Project Wayfarer server Java process,
protected listener, unavailable `session.lock`, missing Config／artifact,
artifact drift, World／Region-count drift, and insufficient disk. The first
Dry Run safely identified the still-open Minecraft Client as a generic Java
process; the guard was corrected to distinguish Project Wayfarer server Java
processes while protected ports and the exclusive world lock remained
authoritative. Invalid path, outside-root, missing token, wrong-case token,
existing destination, protected-port, and server-Java rejection tests passed.

Preflight:

| Item | Value |
| --- | ---: |
| Source Main files | 207 |
| Source Main bytes | 148,994,081 |
| Free disk bytes | 5,701,732,364,288 |
| Required safe minimum | 2,445,471,810 |

Final backup:

| Item | Value |
| --- | --- |
| Path | `backups/main-v006-final-baseline-20260725-220745/` |
| Main payload | 207 files／148,994,081 bytes |
| SHA-list entries | 227 |
| Manifest SHA-256 | `A85A7CCAA2FE2DECCC69CE3E9F862F1281408B4D02E20EFC1E3E31B74D0814A1` |
| SHA-list SHA-256 | `81593864B49E41FB03F02514C1935DFAF380A1ABFE6FB148897932E328A50C39` |
| Source／payload relative paths | All match |
| Source／payload bytes | All match |
| Source／payload SHA-256 | All match |
| Config snapshot SHA-256 | All match |
| Persistent Region counts | `17 / 11 / 18`, all match |
| Resource Region counts | `8 / 4 / 4`, all match |
| Resource Region SHA-256 | 16 of 16 match |
| Finalization | `.incomplete` renamed only after validation |
| Git | Backup ignored |

Evidence files are `preflight.json`, `manifest.json`, `sha256.txt`,
`restore.md`, and `validation.json`. The manifest itself is externally
digested to avoid a self-referential SHA-list entry.

## Restore boundary

Order 6 did not execute a restore. `restore.md` records the required separate
procedure: reject connections; normally stop every component; quarantine the
current Main container; copy the backup world and Config snapshots; verify
file counts, bytes, relative paths, and hashes; verify persistent and Resource
identities; verify Multiverse and Portal family boundaries; then perform a
focused clean-start acceptance. The Final Main Baseline backup and quarantine
must both remain preserved until that future task closes.

## Handoff

Order 6 is complete. Order 7 CoreProtect is next and must finish before
substantial Hub／Gate construction. Main Spawn WorldGuard protection, Hub／Gate
construction, Frontier, integrated operations, full cold backup and isolated
restore, pre-release Player State reset, and the V0.1.0 Release Baseline remain
incomplete.
