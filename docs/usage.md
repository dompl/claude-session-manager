# Usage Guide

## Basic Commands

### Save Session

```bash
claude-save "description of what you worked on"
```

**Interactive mode:**

```bash
claude-save
# Prompts for description and context
```

### Resume Session

```bash
claude-resume
# Shows interactive menu of last 5 sessions
```

### List All Sessions

```bash
claude-list
# Shows all sessions organized by project
```

## Detailed Workflow

### 1. Working with Claude CLI

```bash
cd ~/your-project
claude code "help me optimize the build process"
# ... complete conversation with Claude ...
```

### 2. Save the Session

```bash
claude-save "build process optimization and webpack config"
```

The system will prompt for:

- Technology stack
- Specific problem solved
- How Claude helped
- Files modified
- Next steps

### 3. Complete the Conversation Log

After saving, edit the conversation file:

```bash
~/.claude-sessions/sessions/[session-id]/conversation/session.md
```

Add your complete conversation with Claude including:

- All questions you asked
- All responses Claude provided
- Code generated
- Analysis and recommendations

### 4. Resume Later

```bash
claude-resume
# Select session from menu
claude code "Continue from the session context and work on next steps"
```

## Example Workflows

### WordPress Development

```bash
cd ~/wordpress-site
claude code "help me create a custom Gutenberg block"
# ... work session ...
claude-save "custom Gutenberg block development"

# Days later...
claude-resume
# Select the WordPress session
claude code "Continue with the Gutenberg block - now add styling options"
```

### React Project

```bash
cd ~/react-app
claude code "implement user authentication with JWT"
# ... work session ...
claude-save "JWT authentication and protected routes"

# Later...
claude-resume
# Select the React session
claude code "Add password reset functionality to the auth system"
```

### Node.js API

```bash
cd ~/api-project
claude code "help me add rate limiting and security middleware"
# ... work session ...
claude-save "API security hardening with rate limiting"

# Continue work...
claude-resume
# Select the API session
claude code "Now add API documentation with Swagger"
```

## Best Practices

### 1. Save at Natural Breakpoints

- After completing a feature
- Before trying risky changes
- End of work sessions
- When switching contexts

### 2. Use Descriptive Names

```bash
# Good
claude-save "WordPress custom post types with ACF integration"
claude-save "React hooks refactor for performance optimization"
claude-save "Docker containerization and CI/CD pipeline setup"

# Avoid
claude-save "stuff"
claude-save "work"
claude-save "fixes"
```

### 3. Complete Conversation Files

Always edit the conversation file to include:

- Complete dialogue with Claude
- All code generated
- Decisions made and reasoning
- Problems encountered and solutions

### 4. Regular Cleanup

```bash
# List old sessions
claude-list

# Remove outdated sessions manually
rm -rf ~/.claude-sessions/sessions/old-session-*
```

### 5. Session Naming Convention

Consider using prefixes:

- `feature-` for new features
- `bugfix-` for bug fixes
- `refactor-` for code refactoring
- `setup-` for project setup
- `deploy-` for deployment work

## Advanced Usage

### Cross-Project Context

Sessions work across different projects:

```bash
# Project A
cd ~/project-a
claude-save "authentication system design patterns"

# Project B (can reference Project A patterns)
cd ~/project-b
claude-resume
# Select Project A session
claude code "Apply the authentication patterns from project A to this React app"
```

### Session Chaining

Build upon previous sessions:

```bash
# Session 1
claude-save "database schema design"

# Session 2
claude-save "API endpoints based on schema design"

# Session 3
claude-save "frontend integration with API"
```

### Team Collaboration

Share session contexts:

```bash
# Export session context
cp ~/.claude-sessions/sessions/[session-id] /shared/folder/

# Team member imports context
cp /shared/folder/[session-id] ~/.claude-sessions/sessions/
```

## Integration with Claude CLI `/resume`

Use both systems together:

| Use Case                  | Command                 | When to Use                   |
| ------------------------- | ----------------------- | ----------------------------- |
| Same session continuation | `claude code "/resume"` | Within same CLI session       |
| Cross-session restoration | `claude-resume`         | Days/weeks/months later       |
| Different project context | `claude-resume`         | Working on different projects |
| Quick continuation        | `/resume`               | Just switched terminals       |
| Full context restore      | `claude-resume`         | Need complete memory          |
