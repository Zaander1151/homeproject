# MCP Task Delegation - Usage Guide

## Quick Start

### 1. Setup (One-time)

```bash
cd /home/hazzard/homeproject/mcp-task-delegation
./setup.sh
```

### 2. Restart Claude Code

The MCP servers are configured in `.claude/mcp.json` and load automatically when Claude Code starts.

### 3. Use Naturally

Just talk to Claude normally. It will automatically delegate tasks to the appropriate models.

## How Claude Decides

Claude automatically routes tasks based on:

1. **Task complexity**
   - Simple → Ollama (local, free)
   - Complex → Gemini (more capable)

2. **Task type**
   - Code analysis → code-analyzer
   - File/log processing → file-summarizer
   - Documentation → doc-generator
   - Web search → gemini-search (existing)

3. **Efficiency**
   - Large files → Delegate to save tokens
   - Quick checks → May handle directly

## Example Workflows

### Code Review Workflow

**You:** "Review this code for bugs and security issues"

**What happens:**
1. Claude reads your code
2. Decides if it's simple or complex
3. Simple → Uses `analyze_code_simple` (Ollama, ~5s)
4. Complex → Uses `analyze_code_deep` (Gemini, ~10s)
5. Claude synthesizes results and responds

**Token savings:** 10,000-30,000 Claude tokens per review

### Log Analysis Workflow

**You:** "Analyze these Docker logs and tell me what's wrong"

**What happens:**
1. Claude receives logs
2. Delegates to `file-summarizer` → `analyze_logs` (Ollama)
3. Gets summary, errors, patterns
4. Claude interprets and suggests fixes

**Token savings:** 20,000-50,000 tokens for large logs

### Documentation Workflow

**You:** "Generate a README for this project"

**What happens:**
1. Claude analyzes project structure
2. Delegates to `doc-generator` → `generate_readme` (Gemini)
3. Receives draft documentation
4. Claude refines and formats

**Token savings:** 15,000-25,000 Claude tokens (uses Gemini tokens)

## Explicit Control

You can explicitly request which model to use:

### Force Local Processing

```
"Use local analysis to check this code"
"Summarize this with Ollama"
"Quick local review of these changes"
```

### Force Deep Analysis

```
"Do a thorough security review with Gemini"
"Deep analysis of this architecture"
"Comprehensive documentation for this API"
```

### Check What's Available

```
"What MCP tools do you have for code analysis?"
"Show me available documentation generators"
```

## Common Use Cases

### 1. Daily Development

**Morning standup prep:**
```
"Summarize git logs from yesterday"
→ file-summarizer extracts commits, changes
```

**Pre-commit checks:**
```
"Quick review of my changes"
→ code-analyzer (simple) checks style, bugs
```

**Writing docs:**
```
"Document these new API endpoints"
→ doc-generator creates API docs
```

### 2. Code Review

**PR review:**
```
"Review this diff: [paste git diff]"
→ code-analyzer (review_diff) analyzes changes
```

**Security check:**
```
"Check this authentication code for vulnerabilities"
→ code-analyzer (deep) does security analysis
```

### 3. Debugging

**Log analysis:**
```
"Find all errors in these logs from the past hour"
→ file-summarizer extracts errors with context
```

**Config validation:**
```
"Is this docker-compose.yaml correct?"
→ file-summarizer validates and explains
```

### 4. Documentation

**Function docs:**
```
"Generate Google-style docstring for this function"
→ doc-generator creates comprehensive docstring
```

**Project README:**
```
"Create a README for my home automation project"
→ doc-generator writes professional README
```

**Code explanation:**
```
"Explain this algorithm for a beginner"
→ doc-generator explains at appropriate level
```

## Performance Expectations

### Ollama (Local)

**Pros:**
- Free (no API costs)
- Private (data stays local)
- Fast (3-15s depending on task)
- Unlimited usage

**Cons:**
- Less powerful than Gemini
- Requires GPU
- Models take disk space

**Best for:**
- Quick checks
- Repetitive tasks
- Large file processing
- Privacy-sensitive code

### Gemini (API)

**Pros:**
- More capable
- Better at complex reasoning
- Excellent for writing
- No local resources needed

**Cons:**
- Uses API quota
- Requires internet
- Slightly slower

**Best for:**
- Deep analysis
- High-quality documentation
- Complex reasoning
- Security reviews

## Monitoring Usage

### Check Ollama Usage

```bash
# See running tasks
docker stats ollama

# View model usage
docker exec ollama ollama list
```

### Check Gemini Usage

Visit: https://aistudio.google.com/app/apikey

- View API calls
- Monitor quota
- Track costs (currently free tier)

## Troubleshooting

### "Ollama connection failed"

```bash
# Check if running
docker ps | grep ollama

# Restart if needed
cd /home/hazzard/ollama
docker-compose restart
```

### "Model not found"

```bash
# Install missing model
docker exec ollama ollama pull qwen2.5-coder:7b
docker exec ollama ollama pull qwen2.5:7b
```

### "MCP server not responding"

1. Check `.claude/mcp.json` for syntax errors
2. Verify Python dependencies: `pip3 list | grep mcp`
3. Restart Claude Code
4. Check server logs (if available)

### "Gemini API error"

- Check API key in `.claude/mcp.json`
- Verify quota: https://aistudio.google.com/
- Check internet connectivity

## Advanced Usage

### Custom Prompts

You can be very specific about what you want:

```
"Analyze this code for:
1. SQL injection vulnerabilities
2. XSS risks
3. Authentication bypasses
Use deep analysis."
```

### Batch Operations

```
"Review all Python files in src/ for:
- Security issues
- Code style
- Performance bottlenecks"
```

Claude will coordinate multiple MCP calls efficiently.

### Combining Tools

```
"Analyze these logs, then review the code that generated the errors"
```

Claude orchestrates:
1. file-summarizer → analyze_logs
2. Reads relevant code files
3. code-analyzer → analyze_code_deep
4. Synthesizes findings

## Best Practices

### 1. Let Claude Decide

Most of the time, just ask naturally. Claude will choose the right tool.

**Good:**
```
"Review this code for issues"
```

**Over-specific:**
```
"Use the code-analyzer MCP server's analyze_code_simple tool with focus=bugs parameter to check this code"
```

### 2. Provide Context

Help Claude (and the models) understand your needs:

```
"This is authentication code for a public API. Security is critical.
Review for vulnerabilities."
```

### 3. Be Specific About Constraints

```
"Quick local review" → Uses Ollama
"Thorough analysis" → May use Gemini
"Just check syntax" → Simple, fast
```

### 4. Iterate

```
First: "Quick check of this code"
Then: "Now do a deep security review of the authentication part"
```

## Token Savings Examples

### Real-world Scenarios

**Scenario 1: Daily log review**
- Task: Analyze 5000-line Docker log
- Direct Claude: ~60,000 tokens
- With MCP: ~5,000 tokens (file-summarizer does heavy lifting)
- **Savings: ~55,000 tokens**

**Scenario 2: PR review**
- Task: Review 500-line diff
- Direct Claude: ~15,000 tokens
- With MCP: ~3,000 tokens (code-analyzer reviews)
- **Savings: ~12,000 tokens**

**Scenario 3: Documentation**
- Task: Generate README + docstrings for 10 functions
- Direct Claude: ~40,000 tokens
- With MCP: ~8,000 Claude tokens (doc-generator creates docs)
- **Savings: ~32,000 Claude tokens** (uses Gemini instead)

**Monthly savings estimate:**
- Daily PR reviews (20/month): ~240,000 tokens
- Weekly log analysis (4/month): ~220,000 tokens
- Documentation (10/month): ~320,000 tokens
- **Total: ~780,000 tokens/month**

## What This Means

### Without MCP Task Delegation
- Burn through Claude tokens quickly
- Hit rate limits frequently
- Expensive at scale

### With MCP Task Delegation
- Preserve Claude tokens for complex reasoning
- Use free local models (Ollama) for routine tasks
- Use cheaper Gemini for mid-tier tasks
- Claude focuses on orchestration and synthesis

## Getting Help

If something isn't working:

1. Check the main README: `cat README.md`
2. Run setup again: `./setup.sh`
3. Test individual servers: `./test-*.sh`
4. Ask Claude: "Why isn't the code-analyzer working?"

## What's Next?

Future enhancements planned:
- Vision models for screenshot/diagram analysis
- Test generation automation
- Automated refactoring suggestions
- Performance profiling
- Schema validation

Check the README for the full roadmap.
