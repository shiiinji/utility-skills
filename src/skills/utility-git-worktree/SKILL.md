---
name: utility-git-worktree
description: git worktree を使って並行開発するための手順（worktree作成/一覧/削除、同一ブランチ同時checkout制約、PRまで）を提供する。Use when you want to create/manage git worktrees for parallel work.
metadata:
  short-description: git worktree helper
---

# Git Worktree Skill

git worktree を使って安全に作業ツリーを増やす/片付ける。

## 必要な入力（不足は質問する）

- 対象リポジトリ（`cwd`）
- ベースにしたいブランチ/コミット（例: `test/1985`）
- worktree の配置先ディレクトリ（例: `../<repo>-worktrees/<name>`）
- （推奨）作業用ブランチ名（例: `test/1985-wt`）

## Workflow

### 0) Preflight（必須）

1. 作業中の変更がある場合は commit / stash してから進める（`git status`）
2. 既存の worktree と checkout 先を確認する（`git worktree list`）
3. ベースブランチがローカルに無い場合は取得する（`git fetch --all --prune`）

### 1) worktree を作る（同一ブランチは同時に使えない）

**原則:** 同じブランチを複数の worktree で同時に checkout はできない。

#### Case A: いまの作業ツリーがベースブランチを checkout 済み（よくある）

ベースブランチから **新しい作業用ブランチ** を作って worktree を追加する。

```bash
git worktree add -b <new-branch> <worktree-path> <base-branch>
```

#### Case B: ベースブランチがどの worktree でも checkout されていない

同じブランチ名のまま worktree を追加できる。

```bash
git worktree add <worktree-path> <base-branch>
```

#### Case C: ベースブランチの checkout を新しい worktree 側へ「移動」したい

1) 既存の作業ツリーで別ブランチに退避 → 2) worktree を作る。

```bash
git checkout <other-branch>
git worktree add <worktree-path> <base-branch>
```

### 2) worktree 側で作業する

```bash
cd <worktree-path>
```

- 以降は通常どおり編集・テスト・commit
- `-b` で新規ブランチを作った場合は upstream を設定して push

```bash
git push -u origin <new-branch>
```

### 3) 完了（PR/マージ）

- PR を作ってレビュー → マージ
- マージ後にブランチや worktree を掃除する（次のセクション）

### 4) worktree を削除する

**削除は「元リポジトリ側（メインの作業ツリー）」で実行するのが安全。**

```bash
cd <repo-root>
git worktree remove <worktree-path>
git worktree prune
```

## Troubleshooting

### `fatal: '<branch>' is already checked out at '<path>'`

- 同じブランチを別 worktree で checkout しようとしている
- **Case A**（新ブランチを切る）か **Case C**（移動する）を使う

### `fatal: '<worktree-path>' already exists`

- 既存ディレクトリがある（空でもNG）
- 別名にするか、不要なら削除してから `git worktree add`

### ブランチ削除できない / どこかで掴まれている

```bash
git worktree list
```

- worktree が残っている場合は先に `git worktree remove` する
