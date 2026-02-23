# /analyze Command

Explore and analyze the codebase structure, patterns, and architecture.

## Usage

```
/analyze                    # General codebase overview
/analyze modules            # Focus on module structure
/analyze "how are options defined"  # Answer specific question
```

## Analysis Types

### 1. Structure Analysis
Understand the overall organization:
- Directory layout
- Module hierarchy
- Import relationships

### 2. Pattern Analysis
Find recurring patterns:
- How options are defined
- How modules are imported
- How configuration is structured

### 3. Dependency Analysis
Track relationships:
- What imports what
- What depends on what
- Where values flow

## Workflow

### For Structure Questions
```
1. Glob for file patterns
2. Read key files (default.nix, flake.nix)
3. Map the hierarchy
4. Report findings
```

### For "Where is X" Questions
```
1. Grep for the term
2. Read surrounding context
3. Identify the canonical location
4. Report with file:line references
```

### For "How does Y work" Questions
```
1. Find the definition
2. Find usages
3. Trace the data flow
4. Explain the mechanism
```

## Output Format

Provide clear, structured answers:

```markdown
## Finding: [Brief summary]

### Location
- `path/to/file.nix:42` - Main definition
- `path/to/other.nix:15` - Usage

### Explanation
[How it works]

### Related
- [Other relevant files or patterns]
```

## Common Nix Codebase Questions

- "Where are the darwin modules?"
- "How is home-manager integrated?"
- "What packages are installed?"
- "How do I add a new module?"
- "Where is option X defined?"
