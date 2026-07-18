# Contribution Guide

Project WayfarerへのContributionを検討いただき、ありがとうございます。文書と説明は日本語を基本言語とします。

## Issue

- 新しいIssueを作成する前に、既存Issueに同じ報告や提案がないか確認してください。
- Plugin Version、Minecraft Version、Java Version、および対象Serverを明記してください。
- Config変更では、変更理由、影響範囲、互換性およびRollback方法を説明してください。
- Password、Token、Forwarding Secretなどの秘密情報を記載しないでください。
- Log全文、World、Player Data、Database Data、JARおよび有償Contentを添付しないでください。Logは秘密情報を除去し、問題の把握に必要な範囲だけを掲載してください。
- Pluginの仕様やConfig Keyを根拠とする場合は、Plugin作者の公式文書または公式配布元を示してください。

Security上の問題は公開Issueへ詳細を投稿せず、[Security Policy](SECURITY.md)に従ってください。

## Pull Request

- 1つのPull Requestは1つの目的に限定してください。
- 関連Issue、変更理由、対象Version、検証内容、影響範囲および手動確認事項を記載してください。
- 自動生成Configを無加工のまま大量にCommitしないでください。必要な設定と、その根拠が確認できる最小限のTemplateを提出してください。
- YAML、TOML、JSON、PowerShellおよびDocker Composeは、利用可能なToolで検証してください。
- ViaBackwardsを追加しないでください。
- `resource`、`resource_nether`、`resource_end`でBetterStructuresを有効にしないでください。
- 独自PluginのSource、Gradle／Maven ProjectまたはBuild成果物をこのリポジトリへ追加しないでください。外部拡張の提案は接続仕様として記述してください。
- Pull RequestはReviewの結果、変更または見送りとなる場合があり、必ず採用されるとは限りません。

Contributionを提出した時点で、提出内容を本リポジトリの[MIT License](LICENSE)の下で配布できることを確認したものとします。第三者成果物を提出する場合は、再配布権限と適用条件を明確にしてください。
