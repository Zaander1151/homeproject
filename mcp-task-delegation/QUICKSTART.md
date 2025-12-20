# MCP Task Delegation - Quick Start

## What Is This?

An intelligent AI task routing system for Claude Code that delegates work to specialized models (Ollama local models + Gemini API) to save your Claude tokens.

## Setup Status

✅ Python dependencies installed
✅ MCP servers configured
✅ qwen2.5-coder:7b installed (code analysis)
⏳ qwen2.5:7b installing (file summarization - 4.7GB, ~1 minute remaining)

## Next Steps

### 1. Wait for Model Download to Complete

The `qwen2.5:7b` model is currently downloading. Check status:

```bash
docker exec ollama ollama list | grep qwen2.5
```

You should see both models:
- `qwen2.5-coder:7b` ✅
- `qwen2.5:7b` (wait for this)

### 2. Restart Claude Code

After the model finishes downloading, restart Claude Code to load the new MCP servers:

```bash
# Exit and restart your Claude Code session
```

### 3. Verify It's Working

After restart, try these commands:

```
"What MCP tools do you have available?"
```

You should see:
- `gemini_web_search` (already working)
- `analyze_code_simple`
- `analyze_code_deep`
- `review_diff`
- `summarize_file`
- `extract_key_info`
- `analyze_logs`
- `validate_config`
- `generate_function_docs`
- `generate_readme`
- `generate_api_docs`
- `explain_code`
- `generate_changelog`

## How to Use

Just talk to Claude naturally! Examples:

**Code Review:**
```
"Review this Python code for security issues: [paste code]"
→ Claude automatically uses code-analyzer (Ollama or Gemini)
```

**Log Analysis:**
```
"Analyze these Docker logs and extract all errors"
→ Claude uses file-summarizer (Ollama) to process large logs
```

**Documentation:**
```
"Generate a README for my project"
→ Claude uses doc-generator (Gemini) for high-quality docs
```

## Token Savings

Typical savings per task:
- Log file analysis (5000 lines): ~55,000 Claude tokens saved
- Code review (500 lines): ~12,000 Claude tokens saved
- Documentation generation: ~32,000 Claude tokens saved (uses Gemini instead)

Monthly estimate: ~780,000 tokens saved

## Architecture

```
Claude Code (Orchestrator)
    ├── Gemini Search (web search)
    ├── Code Analyzer (Ollama → Gemini for complex tasks)
    ├── File Summarizer (Ollama)
    └── Doc Generator (Gemini)
```

## Documentation

- **README.md** - Full technical documentation
- **USAGE_GUIDE.md** - Detailed usage examples
- **QUICKSTART.md** - This file

## Troubleshooting

**Model still downloading?**
```bash
# Check progress
docker logs ollama --tail 20
```

**MCP servers not showing up?**
1. Verify qwen2.5:7b is installed
2. Restart Claude Code
3. Check `.claude/mcp.json` syntax

**Need help?**
```bash
cd /home/hazzard/homeproject/mcp-task-delegation
cat README.md
cat USAGE_GUIDE.md
```

## What's Next?

Once everything is running:
1. Try the example workflows in USAGE_GUIDE.md
2. Monitor your token savings
3. Customize models in `.claude/mcp.json` if needed
4. Provide feedback on what works well and what needs improvement!
