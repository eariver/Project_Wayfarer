# Security Policy

## 対象

このSecurity Policyは、Project Wayfarerが管理する次の領域を対象とします。

- ConfigおよびTemplateの危険な初期値や公開範囲
- ScriptおよびDocker Compose定義
- Permission設定、VelocityとPaper Backend間のNetwork境界
- Password、Token、Forwarding Secret、Private Keyなどの秘密情報漏えい

Paper、Velocityおよび第三者Plugin自体の脆弱性は本リポジトリの対応範囲外です。第三者成果物の脆弱性は、各Projectまたは作者が案内するSecurity報告先へ連絡してください。

## 報告方法

Password、Token、Forwarding Secret、Private Key、個人情報または悪用手順をPublic Issueへ投稿しないでください。

GitHubのPrivate vulnerability reportingがこのリポジトリで利用可能な場合は、それを使用してください。利用できない場合は、秘密情報や再現に必要な機密Dataを含めず、影響範囲と連絡が必要である旨の概要だけをIssueで知らせてください。実在が確認できるPrivate連絡先が用意されるまでは、Emailを推測して送信しないでください。

秘密情報がすでにRepositoryへCommitされている場合も、その値をIssue本文、ScreenshotまたはLogへ転載しないでください。対象ファイル名、Commitの識別に必要な最小限の情報、秘密情報の種類および想定される影響だけを共有してください。
