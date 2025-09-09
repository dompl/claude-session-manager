# Global Claude Session Manager

## 🎯 Overview

Global commands available from anywhere:
- `claude-save [description]` - Save current session with context
- `claude-resume` - Show list of last 5 save points and restore
- `claude-list` - Show all saved sessions across projects

## 📁 Global Structure

All sessions stored in: `~/.claude-sessions/`

```
~/.claude-sessions/
├── config.json                    # Global configuration
├── sessions/
│   ├── project1-session1.json     # Session metadata
│   ├── project1-session1/         # Session files
│   ├── project2-session2.json
│   └── project2-session2/
└── recent.json                     # Last 5 sessions for quick access
```

## 🚀 Installation

### 1. Install globally (one time setup):

```bash
# Create global directory
mkdir -p ~/.claude-sessions/sessions

# Install the session manager
curl -o ~/.local/bin/claude-save https://raw.githubusercontent.com/[your-repo]/claude-save
curl -o ~/.local/bin/claude-resume https://raw.githubusercontent.com/[your-repo]/claude-resume
curl -o ~/.local/bin/claude-list https://raw.githubusercontent.com/[your-repo]/claude-list

chmod +x ~/.local/bin/claude-*

# Add to PATH if not already (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:~/.local/bin"
```

### 2. Ready to use anywhere:

```bash
# In any project directory
claude-save "fixed gulp sass compilation issues"
claude-save "wordpress theme responsive layout"
claude-save "api integration debugging"

# Show recent sessions and restore
claude-resume
```

## 📋 Command Details

### `claude-save [description]`

**Example:**
```bash
cd ~/my-wordpress-site
claude-save "gulp optimization and sass fixes"
```

**What it does:**
1. Captures current working directory
2. Saves project context (files, git status, etc.)
3. Prompts for conversation details
4. Creates session with unique ID
5. Updates "recent 5" list
6. Auto-rotates old sessions (keeps only 5 recent)

### `claude-resume`

**Shows interactive menu:**
```
🔄 Recent Claude Sessions (Last 5):

1. [2 hours ago] my-wordpress-site: gulp optimization and sass fixes
2. [1 day ago] react-dashboard: api integration debugging  
3. [2 days ago] ecommerce-site: payment gateway setup
4. [3 days ago] portfolio-site: responsive design fixes
5. [1 week ago] blog-theme: custom post types

Select session to restore (1-5) or 'q' to quit:
```

**After selection:**
- Loads complete session context
- Creates `.claude/current-session.md` in current directory
- Provides Claude CLI command to continue

### `claude-list`

**Shows all sessions organized by project:**
```
📚 All Claude Sessions:

📁 my-wordpress-site (3 sessions)
  - gulp optimization and sass fixes (2 hours ago)
  - theme development setup (1 week ago)
  - initial project analysis (2 weeks ago)

📁 react-dashboard (2 sessions)  
  - api integration debugging (1 day ago)
  - component structure planning (1 week ago)

Total: 5 sessions across 2 projects
```

## 🔧 Implementation Files

The system consists of 4 main scripts:
1. `claude-save` - Global session save command
2. `claude-resume` - Interactive session restore
3. `claude-list` - Show all sessions
4. `session-manager.js` - Core session management logic
