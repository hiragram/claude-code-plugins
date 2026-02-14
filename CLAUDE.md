# プロジェクトルール

## コミットメッセージ

このリポジトリでは [Conventional Commits](https://www.conventionalcommits.org/) 形式を使用すること。release-please によるバージョン自動管理のために必須。

**形式:** `<type>(<scope>): <description>`

- `scope` にはプラグイン名（ios-team, project-manager, vibestudio, code-review）を指定する
- 複数プラグインにまたがる変更や、リポジトリ全体の変更は scope を省略してよい

**例:**
- `feat(ios-team): スクリーンショット分析機能を追加`
- `fix(code-review): 空のPR diffのハンドリングを修正`
- `docs(vibestudio): READMEを更新`
- `chore: CI設定を更新`

**バージョンへの影響:**
- `feat:` → MINOR バージョンが上がる
- `fix:` → PATCH バージョンが上がる
- `docs:`, `chore:`, `refactor:` など → バージョンは上がらない（CHANGELOGには記録される）
