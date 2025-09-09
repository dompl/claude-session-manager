# Installation Guide

## Quick Install

```bash
git clone https://github.com/dompl/claude-session-manager.git
cd claude-session-manager
./install.sh
```

## Manual Installation

### 1. Create directories:

```bash
mkdir -p ~/.local/bin ~/.claude-sessions/sessions
```

### 2. Copy scripts:

```bash
cp bin/* ~/.local/bin/
chmod +x ~/.local/bin/claude-*
```

### 3. Add to PATH:

```bash
# For bash
echo 'export PATH="$PATH:~/.local/bin"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export PATH="$PATH:~/.local/bin"' >> ~/.zshrc
source ~/.zshrc
```

## Requirements

- **Bash 4.0+** - For main scripts
- **Python 3.6+** - For JSON processing
- **Claude CLI** - For AI interactions (recommended)
- **Git** - For project context capture (optional)

## Verification

After installation, test the commands:

```bash
claude-save --help 2>/dev/null && echo "✅ claude-save installed" || echo "❌ claude-save not found"
claude-resume --help 2>/dev/null && echo "✅ claude-resume installed" || echo "❌ claude-resume not found"
claude-list --help 2>/dev/null && echo "✅ claude-list installed" || echo "❌ claude-list not found"
```

## Directory Structure

After installation, you'll have:

```
~/.claude-sessions/
├── config.json                    # Global configuration
├── recent.json                     # Last 5 sessions for quick access
└── sessions/                       # All session data
    └── [session-files]
```

## Uninstallation

To remove Claude Session Manager:

```bash
rm ~/.local/bin/claude-save
rm ~/.local/bin/claude-resume
rm ~/.local/bin/claude-list
rm -rf ~/.claude-sessions/
```

Then remove the PATH export from your shell config file.
