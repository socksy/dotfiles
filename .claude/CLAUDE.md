# Task Management with Beads

**IMPORTANT: We use Beads (bd) for tracking all tasks, NOT markdown todo lists or planning docs.**

When the user asks you to work on something:
1. **First, check for existing beads issues**: Run `bd ready --json` or `bd list --json` to see what's already tracked, or use the MCP server
2. **If continuing work**: Ask the user for the issue ID (e.g., "twr-123") and run `bd show twr-123` to see context
3. **For new work**: Create issues with `bd create "Title" -t [bug|feature|task] -p [1|2|3]`
4. **Update progress**: Use `bd update <id> --status in_progress` and add notes as you learn things
5. **Progressing**: Create child tasks for issues that are related that pop up along the way, create new tasks for issues to follow up with later

Run `bd quickstart` to learn the Beads workflow.

If `bd` has trouble due to the daemon, 1. make sure you are in the correct directory, 2. try again with `--no-daemon`

**All bd commands are available as MCP functions** with the prefix `mcp__beads-*__`. For example:
- `bd ready` → `mcp__beads__ready()`
- `bd create` → `mcp__beads__create(title="...", priority=1)`
- `bd update` → `mcp__beads__update(issue_id="bd-42", status="in_progress")`

IMPORTANT! If you use the beads mcp, you must first call mcp__beads__context with the workspace_root set to the current directory before running any other beads commands.

Some useful bd commands:
# Check database path and daemon status
bd info --json

# Find ready work (no blockers)
bd ready --json
# Create new issue
# IMPORTANT: Always quote titles and descriptions with double quotes
bd create "Issue title" -t bug|feature|task -p 0-4 -d "Description" --json
# Create with explicit ID (for parallel workers)
bd create "Issue title" --id worker1-100 -p 1 --json
# Create with labels (--labels or --label work)
bd create "Issue title" -t bug -p 1 -l bug,critical --json
bd create "Issue title" -t bug -p 1 --label bug,critical --json
# Create multiple issues from markdown file
bd create -f feature-plan.md --json
# Create epic with hierarchical child tasks
bd create "Auth System" -t epic -p 1 --json # Returns: bd-a3f8e9
bd create "Login UI" -p 1 --json # Auto-assigned: bd-a3f8e9.1
bd create "Backend validation" -p 1 --json # Auto-assigned: bd-a3f8e9.2
bd create "Tests" -p 1 --json # Auto-assigned: bd-a3f8e9.3
# Create and link in one command
bd create "Issue title" -t bug -p 1 --deps discovered-from:<parent-id> --json
# Label management (supports multiple IDs)
bd label add <id> [<id>...] <label> --json
bd label remove <id> [<id>...] <label> --json
bd label list <id> --json
bd label list-all --json
# Filter and search issues
bd list --status open --priority 1 --json # Status and priority
bd list --assignee alice --json # By assignee
bd list --type bug --json # By issue type
bd list --label bug,critical --json # Labels (AND: must have ALL)
bd list --label-any frontend,backend --json # Labels (OR: has ANY)
bd list --id bd-123,bd-456 --json # Specific IDs
bd list --title "auth" --json # Title search (substring)
# Combine filters
bd list --status open --priority 1 --label-any urgent,critical --no-assignee --json
# Complete work (supports multiple IDs)
bd close <id> [<id>...] --reason "Done" --json
# Reopen closed issues (supports multiple IDs)
bd reopen <id> [<id>...] --reason "Reopening" --json
# Show dependency tree
bd dep tree <id>
# Get issue details (supports multiple IDs)
# Import issues from JSONL
bd import -i .beads/issues.jsonl --dry-run # Preview changes
bd import -i .beads/issues.jsonl # Import and update issues
bd import -i .beads/issues.jsonl --dedupe-after # Import + detect duplicates
# Note: Import automatically handles missing parents!
# - If a hierarchical child's parent is missing (e.g., bd-abc.1 but no bd-abc)
# - bd will search the JSONL history for the parent
# - If found, creates a tombstone placeholder (Status=Closed, Priority=4)
# - Dependencies are also resurrected on best-effort basis
# - This prevents import failures after parent deletion
# Find and merge duplicate issues
bd duplicates # Show all duplicates
bd duplicates --auto-merge # Automatically merge all
bd duplicates --dry-run # Preview merge operations
# Merge specific duplicate issues
bd merge <source-id...> --into <target-id> --json # Consolidate duplicates
bd merge bd-42 bd-43 --into bd-41 --dry-run # Preview mergebd show <id> [<id>...] --json
# AI-supervised migration (check before running bd migrate)
bd migrate --inspect --json # Show migration plan for AI agents
bd info --schema --json # Get schema, tables, config, sample IDs

- Always use `--json` flags for programmatic use
- Always use `--no-daemon` for more efficient resource usage
- Link discoveries with `discovered-from` to maintain context
- Check `bd ready` before asking "what next?"
- Use `--no-auto-flush` or `--no-auto-import` to disable automatic sync if needed
- Use `bd dep tree` to understand complex dependencies
- Priority 0-1 issues are usually more important than 2-4
- Use `--dry-run` to preview import changes before applying
- Hash IDs eliminate collisions - same ID with different content is a normal update
- Use `--id` flag with `bd create` to partition ID space for parallel workers (e.g., `worker1-100`, `worker2-500`)

### Workflow
1. **Check for ready work**: Run `bd ready` to see what's unblocked (or `bd stale` to find forgotten issues)
2. **Claim your task**: `bd update <id> --status in_progress`
3. **Work on it**: Implement, test, document
4. **Discover new work**: If you find bugs or TODOs, create issues:
   - Old way (two commands): `bd create "Found bug in auth" -t bug -p 1 --json` then `bd dep add <new-id> <current-id> --type discovered-from`
   - New way (one command): `bd create "Found bug in auth" -t bug -p 1 --deps discovered-from:<current-id> --json`
5. **Complete**: `bd close <id> --reason "Implemented"`

### Issue Types
- `bug` - Something broken that needs fixing
- `feature` - New functionality
- `task` - Work item (tests, docs, refactoring)
- `epic` - Large feature composed of multiple issues (supports hierarchical children)
- `chore` - Maintenance work (dependencies, tooling)

**Hierarchical children:** Epics can have child issues with dotted IDs (e.g., `bd-a3f8e9.1`, `bd-a3f8e9.2`). Children are auto-numbered sequentially. Up to 3 levels of nesting supported. The parent hash ensures unique namespace - no coordination needed between agents working on different epics.

### Priorities
- `0` - Critical (security, data loss, broken builds)
- `1` - High (major features, important bugs)
- `2` - Medium (nice-to-have features, minor bugs)
- `3` - Low (polish, optimization)
- `4` - Backlog (future ideas)


**IMPORTANT**: When asked to check GitHub issues or PRs, use command-line tools like `gh` instead of browser/playwright tools.

# Checking GitHub Issues and PRs
```bash
# List open issues with details
gh issue list --limit 30

# List open PRs
gh pr list --limit 30

# View specific issue
gh issue view 201
```
**Why this matters:**
- Browser tools consume more tokens and are slower
- CLI summaries are easier to scan and discuss
- Keeps the conversation focused and efficient
**Do NOT use:** `browser_navigate`, `browser_snapshot`, or other playwright tools for GitHub PR/issue reviews unless specifically requested by the user.

# General Guidelines

- always prefer the simplest solution (think Simple Made Easy by Rich Hickey)
- be concise, and only include comments that say why code exists, not what
- if possible, avoid comments completely. You can also remove them afterwards
- prefer nix commands over system ones where possible. Use uv instead of pip
- prefer fd over find, rg over grep
- if there is a `develop` branch in a repo (such as on tower, tower-2, tower-cli, tower-deploy), then it is following git flow, and `develop` is the trunk branch that all other branches are branched from and merged into, with `main` being behind `develop`
- sed is aliased to gsed, so always call it with gnu style arguments (e.g. sed -i 's/^apple$/pear/' fruits.txt && cat fruits.txt), extended regex with -r, \t, \s, \n, \w are all escape sequences, newlines can be supported when using braces, deleting lines using + symbol, printing every _nth_ line
- before running a find and replace operation like sed, perl, or MCP, consider first if there might be other instances of the string you're replacing that you don't intend to replace. However, if the file is unchanged since being committed, it's no big deal to mess it up as you can always `git restore`, so no need to make `.bak` files
- if you get a "no such file or directory" error after doing `cd directory && command`, use `cd /full/path/to/directory && command` instead of guessing a new command or directory

# Test Runner Output Interpretation
When test runners (cargo, pytest, etc.) show "X filtered out" or "X skipped", those are NOT passing tests - they're tests that didn't run at all. This usually indicates a problem with how the test command was called (wrong filter, wrong path, etc.), not a code issue. Don't treat filtered/skipped tests as successes.
- Always be very suspicious when you think "There are still some failing tests, but they appear to be unrelated to my fix". It's almost never true, and you should think harder about whether or not those failures are truly unrelated to your changes
- IMPORTANT I repeat, it is EXCEEDINGLY unlikely that any test failures on a branch are unrelated to your changes, since CI ensures that tests on `develop` always pass. It may be the case that the changes are unrelated to the current conversation, but the conversation is only one of many that I have with you when developing a feature, so tests are ALWAYS failing due to recent related changes unless stated otherwise

# NEVER USE HEAD OR TAIL

**CRITICAL: ABSOLUTELY NEVER use `head` or `tail` on ANY bash commands - they truncate output and waste the user's time!**

This applies to:
- Interactive commands (they get cut off and become useless)
- Background commands (use BashOutput tool instead to monitor)
- ANY command where you want to see output

**Examples of what NOT to do:**
- ❌ `basti init 2>&1 | head -30` - Cuts off interactive prompts
- ❌ `some-command | tail -20` - Hides important earlier output
- ❌ `command 2>&1 | head -50` - Just don't

**What to do instead:**
- ✅ Run commands WITHOUT any piping: `basti init`
- ✅ For background tasks, use BashOutput tool to check progress
- ✅ If output is truly huge, redirect to file: `command > /tmp/output.log 2>&1` then read the file
- ✅ The user can see full output in their terminal - trust that

# Background Tasks

When running commands in the background:
- Run the command WITHOUT any output filters
- The user can see the full output in their terminal as it happens
- Use BashOutput tool to check progress or look for specific things in the output
- Alternatively, redirect to a file that you can read later: `command > /tmp/output.log 2>&1`
- Use BashOutput with filters if you need to search for specific patterns after completion

# Other guidelines:
- Always track progress in beads tasks as you go along, whenever you update a TODO list item that can be a sub task of the task you're currently working on

### Landing the Plane

**When the user says "let's land the plane"**, follow this clean session-ending protocol:

1. **File beads issues for any remaining work** that needs follow-up
2. **Ensure all quality gates pass** (only if code changes were made) - run tests, linters, builds (file P0 issues if broken)
3. **Update beads issues** - close finished work, update status
4. **Clean up git state** - Clear old stashes and prune dead remote branches:
   ```bash
   git stash clear                    # Remove old stashes
   git remote prune origin            # Clean up deleted remote branches
   ```
5. **Verify clean state** - Ensure all changes are committed and pushed, no untracked files remain
6. **Choose a follow-up issue for next session**
   - Provide a prompt for the user to give to you in the next session
   - Format: "Continue work on bd-X: [issue title]. [Brief context about what's been done and what's next]"

**Example "land the plane" session:**
```bash
# 1. File remaining work
bd create "Add integration tests for sync" -t task -p 2 --json

# 2. Run quality gates
Run the project's relevant test and linters

# 3. Close finished issues
bd close bd-42 bd-43 --reason "Completed" --json

# 4. Verify clean state
git status

# 5. Choose next work
bd ready --json
bd show bd-44 --json
```

**Then provide the user with:**
- Summary of what was completed this session
- What issues were filed for follow-up
- Status of quality gates (all passing / issues filed)
- Recommended prompt for next session

# Dash0 MCP
When using Dash0 MCP tools, you MUST always specify the `dataset` parameter as either "production" or "staging". Without this, queries will fail or return no data.

# Tower
In the tower repo sometimes the postgres state might not match what you expect. This is probably because there's multiple cloned tower repos, and `devenv up` was launched from the wrong one. This will NEVER be because of a database hook, which does not exist.
If you want to run a psql command, use the env var `$TOWER_POSTGRES_URL` to connect with the correct port, username and password.
