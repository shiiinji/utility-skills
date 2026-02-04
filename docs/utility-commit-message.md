# utility-commit-message

スレッドログ（llm-threads の Markdown）または `git diff` から、Conventional Commits 形式のコミットメッセージ（件名+本文）を作ります。

## よくある使い方

### 1) スレッドログに案がある場合（最速）

```bash
python3 src/skills/utility-commit-message/scripts/extract_commit_message_from_thread.py /path/to/thread.md
```

### 2) スレッドログに案がない場合

- スレッドから「何を変えたか」「どのファイルか」「テスト実行」を拾う
- 必要に応じて `git diff` / `git diff --staged` で確認する
- 件名は `<type>(<scope>): <要約>` の形式でまとめる
