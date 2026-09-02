#!/usr/bin/env bash
# PreToolUse hook for Bash. Blocks destructive patterns that have caused real
# damage in past sessions. Exit 2 = block + stderr fed back to the model.
set -euo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

block() {
  printf 'BLOCKED: %s\n\nIf you really need this, ask the user to run it themselves or to approve explicitly. Do not try to work around this guard.\n' "$1" >&2
  exit 2
}

# git reset --hard (has destroyed unstaged work)
if [[ "$cmd" =~ git[[:space:]]+reset[[:space:]]+(--[a-z]+[[:space:]]+)*--hard ]]; then
  block "git reset --hard can destroy unstaged work."
fi

# kubectl delete --all (use label/name filters instead)
if [[ "$cmd" =~ kubectl[[:space:]].*delete.*--all([[:space:]]|$) ]]; then
  block "kubectl delete --all is too broad. Filter by name or label."
fi

# head/tail on command output (per CLAUDE.md: NEVER on bash commands)
# Match: `| head`, `| tail`, `head -N`, `tail -N`, `tail -f`. Allow bare
# `head file.txt` is also forbidden by CLAUDE.md, so catch any invocation.
#if [[ "$cmd" =~ (^|[|;&[:space:]])(head|tail)([[:space:]]|$) ]]; then
#  block "head/tail are forbidden per CLAUDE.md. Read the file with the Read tool, or redirect to a file and grep."
#fi

# lsof -ti:PORT | xargs kill (kills clients per CLAUDE.md)
if [[ "$cmd" =~ lsof[[:space:]]+-ti ]] && [[ "$cmd" =~ kill ]]; then
  block "lsof -ti:PORT | xargs kill kills clients too. Inspect lsof -i:PORT and kill the specific PID."
fi

# rm -rf on dangerous roots
if [[ "$cmd" =~ rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*[[:space:]]+|--recursive[[:space:]]+).*(/|~|\$HOME)([[:space:]]|$) ]]; then
  # Narrow: only flag bare /, ~, $HOME, or /<single-segment>
  if [[ "$cmd" =~ rm[[:space:]]+-[a-zA-Z]*[[:space:]]+(/|~|\$HOME|\$\{HOME\})([[:space:]]|$) ]]; then
    block "rm -rf on a system root is almost certainly wrong."
  fi
fi

exit 0
