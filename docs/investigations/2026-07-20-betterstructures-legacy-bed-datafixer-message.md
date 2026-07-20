# BetterStructures legacy bed DataFixer message

## Summary

BetterStructures 2.6.3へ公式無料`103 Default Structures` version 5をImportすると、Minecraft 26.2上で`Unsupported key: minecraft:bed`がERROR Levelとして反復記録されます。Pluginはその後`Supported server version detected: v26`および`BetterStructures fully initialized!`まで到達し、自然生成、Resource除外、正常再起動、生成Structure保持に成功しました。このIntegrationでは起動阻害Errorではなく、公式Pack内のlegacy Block Entity IDをDataFixerが処理するときの非阻害Messageとして記録します。

## 対象

- BetterStructures: 2.6.3
- BetterStructures JAR SHA-256: `AA63FEF786CD55663BFF832BBD60C01C55C6E3A18603201C6D48FBA025782038`
- Content: `103 Default Structures` version 5
- Content archive SHA-256: `118D873FDF87BF94EA6CA3036897B10790F5D73E62F8387E75C1AB6A4A360FE0`
- Server: Paper 26.2 build 62
- Java: 25.0.3 LTS, 64-bit
- WorldEdit: 7.4.4

## 調査履歴

1. JAR単体初回起動ではBetterStructuresが正常初期化し、対象Messageは発生しませんでした。
2. 公式ZIPを生成済み`plugins/BetterStructures/imports/`へそのまま配置しました。PluginはStartup時にZIPをImportし、103個の`.schem`と対応YAMLを配置してImportsをCleanupしました。
3. Import直後と正常再起動後の両方で同じ`minecraft:bed` Messageを確認しました。その他のERROR／SEVERE／Exceptionはありませんでした。
4. Import済みSchematicのGZip展開データを読み取り専用で照合し、59ファイルにlegacy文字列`minecraft:bed`が含まれることを確認しました。Config、World名、WorldEdit依存、Content混在または自動Downloadが原因ではありません。
5. Mainの未生成領域を半径256 Blockに限定して生成し、公式Packの`betterstructures_well_grassy`が自然生成しました。Resource Overworldの代表未生成ChunkではStructure通知／配置Logがなく、Resource Nether／EndもConfigで明示的に無効です。
6. Mainを正常停止・再起動し、Plugin完全初期化、Config維持、および生成済み井戸の保持を確認しました。

## 影響評価

確認済みの代表Structureは井戸であり、legacy bed NBTを使用しません。Message対象となるSchematicに含まれるベッドの個別Block Entity変換結果までは、既成Plugin内部品質保証の範囲として網羅検証していません。Plugin全体、Pack認識、自然生成、およびServer起動は阻害されません。

## 運用判断と再確認条件

- 公式SchematicをProject側で書き換えない。
- Messageを隠すために追加Pack、Fork、FAWEまたは自動更新を導入しない。
- BetterStructures本体、103 Default Structures Pack、PaperまたはWorldEditを更新した際に再確認する。
- Phase 3前に`spawnProtectionRadius: 100`と合わせてStartup Logを再確認する。
- 実際にベッドを含むStructureで欠損またはPaste失敗が観測された場合は、上流向け再現情報を採取し、Blocking defectとして別途扱う。
