# Project Wayfarer Plugin Concepts

このDirectoryは、Project Wayfarerの独自Plugin群に関する非正本Conceptを索引する。

Conceptは実装、Repository作成、Database Migration、Runtime導入またはReleaseを承認しない。

Concept確認完了後に作成するCodex向け**実装作業指示書兼設計仕様書**は、独自Plugin Sourceを管理する別のPlugin Repositoryへ保存する。

## Current design input

- [Plugin Concept v0.0.3](Project_Wayfarer_Plugin_Concept_v0.0.3.md)
  - Plugin群全体、V0.1.0 Scope、Runtime配置、Data／Repository境界を定義する。
- [Main Plugin concepts](main/README.md)
- [Frontier Plugin concepts](frontier/README.md)

## Current status

| Concept | Version | Status |
|---|---:|---|
| Plugin全体 | v0.0.3 | Under Review |
| Growth Tool | v0.0.5 | Under Review |
| Worlds Beyond Plugin | v0.0.3 | Under Review |
| Ruined Frontier Integration Decision | v0.0.2 | Under Review |

Growth Tool／`Wayfarer_Main`はProject Wayfarer V0.1.0 Release Scopeへ正式追加する。Project本流のRoadmap／Acceptance同期は別チャットで実施する。

Worlds Beyond Theme Conceptは、LaunchpadとNavigation GUIの新判断を反映したv0.0.5へ別チャットで同期改訂する。

## Archive

- [Plugin全体旧版](old/README.md)
- 各下位Directoryの`old/`

現在案はVersion番号だけから推測せず、本READMEと各下位READMEを確認する。

## Conceptから実装まで

```text
Concept作成
→ 横断確認
→ Project側Roadmap／Theme Concept同期
→ Approved for Task Design
→ Plugin Repositoryへ実装作業指示書兼設計仕様書
→ IntelliJ IDEA用Project
→ Codex実装・Plugin側Test
→ Project Test Server統合
→ Project側Acceptance
```
