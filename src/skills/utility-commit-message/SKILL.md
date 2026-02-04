---
name: utility-commit-message
description: llm-threads のスレッドログ（Markdown）や git の差分から、Conventional Commits 形式のコミットメッセージ（件名+本文）を作成する。日本語/英語対応。Use when you need to craft a commit message from an LLM thread log and/or the current git changes.
metadata:
  short-description: Commit message helper
---

# Commit Message Skill

コミットメッセージを「コピペでそのまま使える」形で出力する。

## 入力（あるだけでOK）

- スレッドログ（例: `.../Threads/YYYY/MM/DD/*.md`）
- 対象リポジトリ（`cwd`）
- 言語（日本語/英語）
- `git diff` / `git diff --staged` の対象（ステージ済みか）
- **何も指定がない場合**: このチャット（現在のスレッド）の内容を材料にコミットメッセージを作る

## Workflow

### 1) 材料を集める

**スレッドログがある場合**

1. スレッド Markdown を読む。
2. 直近のユーザー要求・変更内容・変更ファイル・テスト実行を拾う。
3. すでにコミットメッセージ案がコードブロックで書かれている場合は、それを最優先で採用する（必要なら微修正）。

**入力が何もない場合（デフォルト）**

1. このチャット（現在のスレッド）から、直近のユーザー要求・変更内容・変更ファイル・テスト実行を拾う。
2. 情報が足りない場合は、`git status -sb` / `git diff --staged` / `git diff` のどれが必要かを短く聞く（または実行して補う）。

**スレッドログから既存メッセージを抜き出す（推奨）**

```bash
python3 src/skills/utility-commit-message/scripts/extract_commit_message_from_thread.py /path/to/thread.md
```

**スレッドログがない場合**

1. `git status -sb`
2. ステージ済みなら `git diff --staged --name-status` と `git diff --staged`
3. 未ステージなら `git diff --name-status` と `git diff`

### 2) type / scope を決める

- **type**: `fix` / `feat` / `refactor` / `docs` / `test` / `chore` / `build` / `ci` / `perf` / `style`
- **scope**: 変更箇所から推測する（例: `backend`, `frontend`, `infra`）。複数領域なら省略してもよい。

### 3) 件名を書く（1行）

Conventional Commits:

```
<type>(<scope>): <要約>
```

要約のルール:
- 主語は省略してよい（命令形/体言止めでOK）
- 何がどう変わるかが一目で分かる表現にする
- なるべく 72 文字前後に収める（厳密でなくてよい）

### 4) 本文を書く（任意・おすすめ）

- 2〜4 行の箇条書きで「重要な変更」と「テスト/検証」を書く
- 実装場所（ファイル名/関数名）が分かるときは含める
- 言語はユーザーの指定に合わせる（指定がなければユーザーの言語に合わせる）

### 5) 出力する

- `text` のコードブロックで、件名+本文をまとめて出す
- 余計な前置きは書かない（そのまま使える状態）

## 例（スレッドログ由来）

```text
fix(backend): ENユーザー新規登録時にlast_login_timeも保存する

- UserEnRepository.create で created_time と同じ時刻を last_login_time にセット
- 退行防止のテストを追加
```
