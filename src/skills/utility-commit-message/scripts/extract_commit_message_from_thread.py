#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


CONVENTIONAL_TYPES = (
    "feat",
    "fix",
    "docs",
    "style",
    "refactor",
    "perf",
    "test",
    "build",
    "ci",
    "chore",
    "revert",
)

SUBJECT_RE = re.compile(
    rf"^({'|'.join(CONVENTIONAL_TYPES)})(\([^)]+\))?(!)?: .+",
    re.IGNORECASE,
)

CODE_FENCE_RE = re.compile(r"```[^\n]*\n(.*?)\n```", re.DOTALL)


def _extract_candidates(markdown: str) -> list[str]:
    candidates: list[str] = []

    for block in CODE_FENCE_RE.findall(markdown):
        text = block.strip("\n")
        if not text.strip():
            continue
        first_line = text.splitlines()[0].strip()
        if SUBJECT_RE.match(first_line):
            candidates.append(text.strip())

    return candidates


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(
        description="Extract the latest Conventional Commits message from an LLM thread markdown.",
    )
    parser.add_argument("thread_md", type=Path, help="Path to thread markdown file")
    args = parser.parse_args(argv)

    try:
        markdown = args.thread_md.read_text(encoding="utf-8")
    except FileNotFoundError:
        print(f"File not found: {args.thread_md}", file=sys.stderr)
        return 2
    except UnicodeDecodeError:
        markdown = args.thread_md.read_text(encoding="utf-8", errors="replace")

    candidates = _extract_candidates(markdown)
    if not candidates:
        print("No Conventional Commits message found in code fences.", file=sys.stderr)
        return 1

    print(candidates[-1])
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))

