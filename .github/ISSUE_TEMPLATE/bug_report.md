---
name: Bug report
about: Create a report to help us improve
title: "[BUG] "
labels: bug
assignees: ""
---

## Bug Description

A clear and concise description of what the bug is.

## To Reproduce

Steps to reproduce the behavior:

1. Run command '...'
2. Enter input '...'
3. See error '...'

## Expected Behavior

A clear description of what you expected to happen.

## Actual Behavior

What actually happened instead.

## Error Output

```bash
# Paste the complete error output here
```

## Environment Information

Please provide the following information:

**Operating System:**

- [ ] macOS (version: )
- [ ] Linux (distribution: )
- [ ] Windows (WSL version: )

**Shell:**

- [ ] bash (version: )
- [ ] zsh (version: )
- [ ] Other:

**Python Version:**

```bash
python3 --version
```

**Installation Method:**

- [ ] install.sh script
- [ ] Manual installation
- [ ] Other:

**Claude CLI:**

- [ ] Installed (version: )
- [ ] Not installed
- [ ] Unknown

## System Check Output

Please run these commands and paste the output:

```bash
echo "PATH check: $(echo $PATH | grep -o "$HOME/.local/bin" && echo "✅ Found" || echo "❌ Missing")"
ls -la ~/.local/bin/claude-* 2>/dev/null || echo "Commands not found"
ls -d ~/.claude-sessions 2>/dev/null || echo "Session directory missing"
python3 -c "import json; print('JSON support: ✅')" 2>/dev/null || echo "Python JSON issue"
```

## Session Information (if applicable)

If the bug is related to session management:

**Recent sessions:**

```bash
claude-list 2>/dev/null || echo "Cannot list sessions"
```

**Session files:**

```bash
ls -la ~/.claude-sessions/sessions/ 2>/dev/null || echo "No session files"
```

## Additional Context

Add any other context about the problem here:

- When did this start happening?
- Does it happen consistently or intermittently?
- Have you tried any workarounds?
- Any recent system changes?

## Screenshots

If applicable, add screenshots to help explain your problem.

## Possible Solution

If you have ideas about what might be causing the issue or how to fix it, please share them here.
