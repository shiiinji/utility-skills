# utility-git-worktree

`git worktree` を使って、同じリポジトリを複数の作業ツリーに分けて並行開発するための手順を案内します。

## 使い方（例）

Claude Code / Codex で `/utility-git-worktree` を呼び、次を渡します（不足は質問されます）。

- 対象リポジトリ（`cwd`）
- ベースにしたいブランチ/コミット（例: `main`）
- worktree の配置先（例: `../<repo>-worktrees/<name>`）
- （推奨）作業用ブランチ名（例: `<name>-wt`）

## よくあるコマンド

### 作業前の確認

```bash
git status
git worktree list
git fetch --all --prune
```

### worktree の追加（新しい作業用ブランチを切る）

```bash
git worktree add -b <new-branch> <worktree-path> <base-branch>
```

### worktree の削除（元リポジトリ側で実行）

```bash
git worktree remove <worktree-path>
git worktree prune
```

## つまずきポイント

### `fatal: '<branch>' is already checked out at '<path>'`

同じブランチは複数 worktree で同時に checkout できません。新しい作業用ブランチを切るか、checkout を別 worktree に「移動」します。
