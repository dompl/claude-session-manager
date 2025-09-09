## Description

Brief description of changes made and why.

## Type of Change

- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 💥 Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] 📚 Documentation update
- [ ] 🔧 Refactoring (no functional changes)
- [ ] ⚡ Performance improvement
- [ ] 🧪 Tests (adding or updating tests)

## Changes Made

### Files Modified

- `file1.sh` - Description of changes
- `file2.md` - Description of changes

### New Files Added

- `newfile.sh` - Purpose and description

### Files Removed

- `oldfile.sh` - Reason for removal

## Testing Performed

### Manual Testing

- [ ] Tested installation process (`./install.sh`)
- [ ] Tested `claude-save` command
- [ ] Tested `claude-resume` command
- [ ] Tested `claude-list` command
- [ ] Tested error scenarios

### Automated Testing

- [ ] All existing tests pass
- [ ] Added new tests for new functionality
- [ ] ShellCheck passes on all scripts

### Cross-Platform Testing

- [ ] Tested on macOS
- [ ] Tested on Linux (Ubuntu/Debian)
- [ ] Tested with bash
- [ ] Tested with zsh

### Edge Cases Tested

- [ ] Empty session directory
- [ ] Corrupted JSON files
- [ ] Permission issues
- [ ] Network connectivity issues (if applicable)

## Documentation Updates

- [ ] Updated README.md
- [ ] Updated relevant documentation in `docs/`
- [ ] Added/updated examples
- [ ] Updated installation instructions if needed
- [ ] Added changelog entry

## Backward Compatibility

- [ ] No breaking changes
- [ ] Breaking changes documented with migration guide
- [ ] Existing sessions remain compatible
- [ ] Configuration format unchanged

## Security Considerations

- [ ] No sensitive information exposed in logs
- [ ] File permissions properly set
- [ ] No security vulnerabilities introduced
- [ ] Input validation implemented where needed

## Performance Impact

- [ ] No performance regression
- [ ] Performance improvement (describe below)
- [ ] Acceptable performance trade-off (explain below)

## Review Checklist

### Code Quality

- [ ] Code follows project style guidelines
- [ ] Functions are well-documented with comments
- [ ] Error handling is comprehensive
- [ ] No hardcoded paths or credentials

### User Experience

- [ ] Clear and helpful error messages
- [ ] Consistent command-line interface
- [ ] Good user feedback and progress indicators
- [ ] Maintains workflow consistency

## Related Issues

- Closes #[issue_number]
- Related to #[issue_number]
- Fixes #[issue_number]

## Screenshots/Examples

If applicable, add screenshots or command output examples to demonstrate the changes.

```bash
# Example usage of new feature
claude-new-command "example output"
```

## Additional Notes

Any additional information that reviewers should know:

- Special considerations
- Known limitations
- Future improvement opportunities
- Dependencies or requirements

## Reviewer Guidelines

For reviewers, please check:

- [ ] Code follows bash best practices
- [ ] All error cases are handled
- [ ] Documentation is clear and complete
- [ ] Changes don't break existing functionality
- [ ] Security implications considered

## Post-Merge Tasks

- [ ] Update version number if needed
- [ ] Create release notes
- [ ] Update distribution packages
- [ ] Announce changes to users
