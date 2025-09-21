🧹 Remove obvious and redundant comments from uncommitted code changes.

📍 Unless instructed otherwise, only consider and edit local code changes that are not yet committed to git.

- Look for comments that are obvious or redundant and remove them. Examples of comments that can be removed include:
  - Commented out code.
  - Comments that describe edits like "added", "removed", or "changed" something.
  - Explanations that are just obvious because they are similar to function names.
- Do not delete all comments:
  - Don't remove comments that start with TODO or FIXME.
  - Don't remove comments if doing so would make a scope empty, like an empty catch block or an empty else block.
  - Don't remove comments that suppress linters or formatters, like `// prettier-ignore`
  - Don't remove comments that have build tool meaning, like `//go:build` or `// +build`
- If you find any end-of-line comments, move them above the code they describe. Comments should go on their own lines.
