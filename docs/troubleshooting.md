# Troubleshooting Guide

## Common Issues

### Commands not found after installation

**Problem:** `claude-save: command not found`

**Solutions:**

1. **Check PATH:**

   ```bash
   echo $PATH | grep -o "$HOME/.local/bin"
   ```

2. **Add to PATH manually:**

   ```bash
   export PATH="$PATH:~/.local/bin"
   ```

3. **Make permanent:**

   ```bash
   # For bash
   echo 'export PATH="$PATH:~/.local/bin"' >> ~/.bashrc
   source ~/.bashrc

   # For zsh
   echo 'export PATH="$PATH:~/.local/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Restart terminal** or open new terminal window

### Python JSON errors

**Problem:** `json.decoder.JSONDecodeError`

**Solutions:**

1. **Reset session files:**

   ```bash
   rm ~/.claude-sessions/recent.json
   echo '{"sessions": []}' > ~/.claude-sessions/recent.json
   ```

2. **Validate existing JSON:**

   ```bash
   python3 -m json.tool ~/.claude-sessions/recent.json
   ```

3. **If config is corrupted:**
   ```bash
   rm ~/.claude-sessions/config.json
   # Run install.sh again to recreate
   ```

### Permission denied errors

**Problem:** `Permission denied` when running commands

**Solutions:**

1. **Fix script permissions:**

   ```bash
   chmod +x ~/.local/bin/claude-*
   ```

2. **Check directory permissions:**

   ```bash
   ls -la ~/.local/bin/claude-*
   ```

3. **Reinstall if needed:**
   ```bash
   rm ~/.local/bin/claude-*
   ./install.sh
   ```

### Session files corrupted

**Problem:** Cannot load session data

**Solutions:**

1. **Check file existence:**

   ```bash
   ls -la ~/.claude-sessions/sessions/
   ```

2. **Validate JSON files:**

   ```bash
   for file in ~/.claude-sessions/sessions/*.json; do
     echo "Checking $file"
     python3 -m json.tool "$file" > /dev/null
   done
   ```

3. **Backup and reset if needed:**

   ```bash
   cp ~/.claude-sessions/recent.json ~/.claude-sessions/recent.json.backup
   echo '{"sessions": []}' > ~/.claude-sessions/recent.json
   ```

4. **Remove corrupted session:**
   ```bash
   rm ~/.claude-sessions/sessions/corrupted-session-*
   ```

### Install script fails

**Problem:** Installation script errors

**Solutions:**

1. **Check requirements:**

   ```bash
   python3 --version  # Should be 3.6+
   which python3
   ```

2. **Manual installation:**

   ```bash
   mkdir -p ~/.local/bin ~/.claude-sessions/sessions
   cp bin/* ~/.local/bin/
   chmod +x ~/.local/bin/claude-*
   ```

3. **Check disk space:**
   ```bash
   df -h ~
   ```

### Claude CLI integration issues

**Problem:** Sessions don't restore properly in Claude CLI

**Solutions:**

1. **Verify restore file creation:**

   ```bash
   ls -la .claude-session-restore.md
   ```

2. **Check file contents:**

   ```bash
   head -20 .claude-session-restore.md
   ```

3. **Use explicit restore command:**
   ```bash
   claude code "Read and restore the complete session context from .claude-session-restore.md, including all conversation history and project understanding"
   ```

### Empty or missing conversations

**Problem:** Session saved but conversation file is empty

**Solutions:**

1. **Always complete conversation files after saving:**

   ```bash
   # Edit the conversation file
   nano ~/.claude-sessions/sessions/[session-id]/conversation/session.md
   ```

2. **Use the template structure provided in the file**

3. **Include all parts of your Claude conversation**

### macOS specific issues

**Problem:** Commands work in terminal but not in other contexts

**Solutions:**

1. **Check shell configuration:**

   ```bash
   echo $SHELL
   ```

2. **Update the correct config file:**

   ```bash
   # For zsh (macOS default)
   echo 'export PATH="$PATH:~/.local/bin"' >> ~/.zshrc

   # For bash
   echo 'export PATH="$PATH:~/.local/bin"' >> ~/.bash_profile
   ```

3. **Reload configuration:**
   ```bash
   source ~/.zshrc  # or ~/.bash_profile
   ```

### Linux specific issues

**Problem:** Permission issues on Linux

**Solutions:**

1. **Check if ~/.local/bin exists:**

   ```bash
   mkdir -p ~/.local/bin
   ```

2. **Some distributions need explicit PATH setup:**
   ```bash
   echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
   ```

## System Information

### Get system info for bug reports:

```bash
echo "OS: $(uname -s)"
echo "Shell: $SHELL"
echo "Python: $(python3 --version)"
echo "PATH includes ~/.local/bin: $(echo $PATH | grep -o "$HOME/.local/bin" && echo "Yes" || echo "No")"
echo "Claude CLI: $(which claude || echo "Not found")"
```

### Check session system status:

```bash
echo "Session directory: $(ls -d ~/.claude-sessions 2>/dev/null && echo "Exists" || echo "Missing")"
echo "Config file: $(ls ~/.claude-sessions/config.json 2>/dev/null && echo "Exists" || echo "Missing")"
echo "Recent file: $(ls ~/.claude-sessions/recent.json 2>/dev/null && echo "Exists" || echo "Missing")"
echo "Total sessions: $(ls ~/.claude-sessions/sessions/*.json 2>/dev/null | wc -l)"
```

## Getting Help

1. **Check the documentation:**

   - [Installation Guide](installation.md)
   - [Usage Guide](usage.md)

2. **Search existing issues** on GitHub: https://github.com/dompl/claude-session-manager/issues

3. **Create a new issue** with:

   - Output of system information commands above
   - Exact error messages
   - Steps to reproduce the problem
   - What you expected to happen

4. **Provide debug information:**
   ```bash
   # Enable debug mode (if available)
   export CLAUDE_SESSION_DEBUG=1
   claude-save "debug test"
   ```
