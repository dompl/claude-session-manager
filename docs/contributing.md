# Contributing Guide

## Development Setup

1. **Fork the repository** on GitHub

2. **Clone your fork:**

   ```bash
   git clone https://github.com/yourusername/claude-session-manager.git
   cd claude-session-manager
   ```

3. **Create a branch:**

   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Install for development:**
   ```bash
   ./install.sh
   ```

## Code Style

### Shell Scripts

- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Quote variables: `"$VARIABLE"`
- Use `local` for function variables
- Add comments for complex logic
- Use consistent indentation (2 spaces)

**Example:**

```bash
#!/bin/bash
set -e

# Function with proper style
process_session() {
    local session_id="$1"
    local description="$2"

    if [ -z "$session_id" ]; then
        echo "Error: session_id required" >&2
        return 1
    fi

    # Process the session
    echo "Processing session: $session_id"
}
```

### Documentation

- Use clear, concise language
- Include examples for all features
- Keep README.md updated with changes
- Add screenshots when helpful
- Use consistent markdown formatting

### JSON Files

- Use 2-space indentation
- Validate JSON syntax
- Include all required fields

## Testing

### Manual Testing

```bash
# Test installation
./install.sh

# Test basic functionality
claude-save "test session"
claude-list
claude-resume

# Test error conditions
claude-resume nonexistent-session
```

### Shell Script Validation

```bash
# Install shellcheck
brew install shellcheck  # macOS
sudo apt install shellcheck  # Ubuntu

# Check all scripts
shellcheck bin/claude-save
shellcheck bin/claude-resume
shellcheck bin/claude-list
shellcheck install.sh
```

### Cross-Platform Testing

Test on multiple environments:

- macOS with zsh
- macOS with bash
- Ubuntu Linux
- Different Python versions (3.6+)

## Pull Request Process

1. **Update documentation** for any changes
2. **Test on multiple environments**
3. **Run shellcheck** on modified scripts
4. **Update CHANGELOG.md** with your changes
5. **Submit PR** with clear description

### PR Requirements

- [ ] Code follows project style guidelines
- [ ] Documentation updated
- [ ] Shellcheck passes
- [ ] Manual testing completed
- [ ] No breaking changes (unless major version)

## Issue Guidelines

### Bug Reports

Use the bug report template and include:

- Operating system and shell version
- Python version (`python3 --version`)
- Exact error messages
- Steps to reproduce
- Expected vs actual behavior

### Feature Requests

Use the feature request template and include:

- Clear use case description
- Expected behavior
- Why the feature would be valuable
- Implementation suggestions (if any)

## Code Review Process

All contributions require:

- Code review by maintainer
- Passing CI checks
- Updated documentation
- No breaking changes (unless major version bump)

## Development Guidelines

### Adding New Features

1. **Discuss first** - Create an issue to discuss large features
2. **Keep it simple** - Follow Unix philosophy: do one thing well
3. **Maintain compatibility** - Don't break existing workflows
4. **Add documentation** - Update all relevant docs

### Modifying Existing Features

1. **Backward compatibility** - Don't break existing sessions
2. **Migration path** - Provide upgrade instructions if needed
3. **Test thoroughly** - Verify existing functionality still works

### File Structure Changes

When adding new files, update:

- Install script (`install.sh`)
- Documentation structure
- `.gitignore` if needed

## Testing New Features

### Session Management Testing

```bash
# Test session creation
claude-save "test feature"

# Verify files created
ls ~/.claude-sessions/sessions/

# Test restoration
claude-resume

# Test listing
claude-list
```

### Error Handling Testing

```bash
# Test missing files
mv ~/.claude-sessions/recent.json ~/.claude-sessions/recent.json.bak
claude-resume

# Test corrupted JSON
echo "invalid json" > ~/.claude-sessions/recent.json
claude-list
```

## Release Process

### Version Numbering

We use semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes, backward compatible

### Creating Releases

1. **Update version** in relevant files
2. **Update CHANGELOG.md**
3. **Create git tag:**
   ```bash
   git tag -a v1.1.0 -m "Release v1.1.0: Add feature X"
   git push origin v1.1.0
   ```
4. **Create GitHub release** with changelog

## Community

### Communication

- Use GitHub issues for bugs and feature requests
- Be respectful and constructive
- Help other contributors when possible

### Recognition

All contributors are recognized in:

- CHANGELOG.md for their contributions
- GitHub contributors page
- Special thanks for major contributions

## Getting Started

Good first contributions:

- Fix typos in documentation
- Improve error messages
- Add examples to documentation
- Test on different platforms
- Report bugs with detailed information

Thank you for contributing to Claude Session Manager! 🎉
