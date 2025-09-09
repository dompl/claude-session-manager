# Claude Global Session Manager

> **Persistent memory for Claude CLI across projects and time**

A global session management system that gives Claude CLI true persistent memory. Save complete conversations with context, resume sessions across projects, and maintain continuity across days, weeks, or months.

## ✨ Features

- 🌍 **Global Access** - Works from any project directory
- 💾 **Complete Session Capture** - Saves entire conversations with Claude
- 🔄 **Smart Resume** - Interactive menu of recent sessions
- 📁 **Project Organization** - Sessions grouped by project
- 🎯 **Context Restoration** - Claude remembers everything from previous sessions
- 🚀 **No Project Setup** - No files needed in individual projects
- ⏰ **Time Travel** - Resume sessions from days, weeks, or months ago

## 🚀 Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/dompl/claude-session-manager.git
cd claude-session-manager

# Run the installation script
./install.sh

# Or install manually
mkdir -p ~/.local/bin ~/.claude-sessions/sessions
cp bin/* ~/.local/bin/
chmod +x ~/.local/bin/claude-*
export PATH="$PATH:~/.local/bin"
```

### Basic Usage

```bash
# Save a session (from any project)
cd ~/my-wordpress-site
claude-save "fixed gulp sass compilation issues"

# Resume recent sessions
claude-resume
# Shows interactive menu of last 5 sessions

# List all sessions
claude-list
# Shows all sessions organized by project
```

## 📋 Commands

### `claude-save [description]`

Saves complete session with project context.

**Example:**
```bash
claude-save "wordpress theme responsive layout fixes"
```

**What it captures:**
- Complete conversation history template
- Current project structure
- Git status and recent commits
- Key configuration files
- Technology stack and context

### `claude-resume`

Interactive menu to restore recent sessions.

**Example output:**
```
🔄 Recent Claude Sessions
════════════════════════════════════════════════════════════════════════

1. [2 hours ago] my-wordpress-site: fixed gulp sass compilation issues
2. [1 day ago] react-dashboard: API integration with authentication  
3. [2 days ago] ecommerce-store: payment gateway setup
4. [1 week ago] portfolio-site: responsive design improvements
5. [2 weeks ago] blog-theme: custom post types integration

Enter session number (1-5) or 'q' to quit:
```

### `claude-list`

Shows all sessions organized by project.

**Example output:**
```
📚 All Claude Sessions
════════════════════════════════════════════════════════════════════════

📁 my-wordpress-site (3 sessions)
  • fixed gulp sass compilation issues
    2024-12-09 14:30 | my-wordpress-site-20241209-143022
  • theme development initial setup  
    2024-12-02 10:15 | my-wordpress-site-20241202-101544

📁 react-dashboard (2 sessions)
  • API integration with authentication
    2024-12-08 09:20 | react-dashboard-20241208-092015
```

## 🎯 How It Works

### Session Save Process

1. **Captures project context** - file structure, git status, key files
2. **Prompts for details** - what you worked on, tech stack, problems solved
3. **Creates session files** - organized in `~/.claude-sessions/sessions/`
4. **Updates recent list** - maintains last 5 sessions for quick access
5. **Generates templates** - for you to fill with complete conversation

### Session Restore Process

1. **Select session** from interactive menu
2. **Loads complete context** - project state and conversation history
3. **Creates restore file** - `.claude-session-restore.md` in current directory
4. **Provides Claude command** - to continue with full context

### Session File Structure

```
~/.claude-sessions/sessions/
├── project-20241209-143022.json           # Session metadata
└── project-20241209-143022/               # Session directory
    ├── context/
    │   └── project-state.md               # Project snapshot
    ├── conversation/
    │   └── session.md                     # Complete conversation
    ├── artifacts/                         # Generated files
    └── restore-instructions.md            # Restore guide
```

## 💡 Workflow Example

### Save Session
```bash
cd ~/wordpress-project
# Work with Claude CLI on gulp optimization...
claude-save "gulp build process optimization and sass restructure"

# Edit the conversation file to include complete discussion:
# ~/.claude-sessions/sessions/wordpress-project-20241209-143022/conversation/session.md
```

### Resume Later (days/weeks/months)
```bash
cd ~/wordpress-project
claude-resume
# Select the session from menu
claude code "Restore session from ./.claude-session-restore.md and continue where we left off"
```

### Result
✅ Claude has complete memory of previous optimization work  
✅ Understands all decisions made and code generated  
✅ Continues seamlessly with full context  
✅ No need to re-explain project structure or goals  

## 🔄 Integration with Claude CLI `/resume`

| Feature | Claude CLI `/resume` | Global Session Manager |
|---------|---------------------|------------------------|
| **Scope** | Current session only | Cross-session, global |
| **Memory** | Recent commands | Complete conversation history |
| **Persistence** | Until CLI restart | Permanent storage |
| **Projects** | Single project | Works across all projects |
| **Context** | Basic continuation | Full working context |

Use **both together**:
- `/resume` for continuing within same CLI session
- `claude-resume` for restoring sessions across time/projects

## 📁 File Structure

```
~/.claude-sessions/
├── config.json                    # Global configuration
├── recent.json                     # Last 5 sessions for quick access
└── sessions/
    ├── project1-session1.json     # Session metadata
    ├── project1-session1/         # Session files
    │   ├── context/
    │   ├── conversation/
    │   ├── artifacts/
    │   └── restore-instructions.md
    └── ...
```

## 🛠 Requirements

- **Bash** - For main scripts
- **Python3** - For JSON processing
- **Claude CLI** - For AI interactions
- **Git** (optional) - For project context capture

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built for [Claude CLI](https://docs.anthropic.com/en/docs/claude-code) by Anthropic
- Inspired by the need for persistent AI conversation memory
- Thanks to the community for feedback and testing

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Usage Examples](docs/usage.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Contributing Guide](docs/contributing.md)

---

**Give Claude persistent memory across all your projects!** ⭐

[![GitHub stars](https://img.shields.io/github/stars/dompl/claude-session-manager.svg?style=social)](https://github.com/dompl/claude-session-manager/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/dompl/claude-session-manager.svg)](https://github.com/dompl/claude-session-manager/issues)
[![GitHub license](https://img.shields.io/github/license/dompl/claude-session-manager.svg)](https://github.com/dompl/claude-session-manager/blob/main/LICENSE)
