# Utility Skills

Claude Code / Codex 向けのユーティリティスキル集。

## インストール

```bash
./install.sh
```

スキルが `~/.claude/skills/` と `~/.codex/skills/` にシンボリックリンクされます。

## スキル一覧

| スキル | 説明 | 使用例 |
|--------|------|--------|
| `/utility-commit-message` | スレッドログや差分からコミットメッセージを作る | `/utility-commit-message /path/to/thread.md` |
| `/utility-git-worktree` | `git worktree` で並行開発する手順（作成/一覧/削除など）を案内 | `/utility-git-worktree base=main path=../repo-worktrees/foo branch=foo-wt` |
| `/utility-layered-explainer` | 浅い→深い→第一原理まで、段階的に解説する | `/utility-layered-explainer なぜCORSは無視せずブロックする？` |

## ディレクトリ構造

```
utility-skills/
├── install.sh
└── src/skills/
    ├── utility-commit-message/
    │   └── SKILL.md
    ├── utility-git-worktree/
    │   └── SKILL.md
    └── utility-layered-explainer/
        └── SKILL.md
```
