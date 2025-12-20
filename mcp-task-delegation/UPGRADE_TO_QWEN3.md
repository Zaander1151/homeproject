# Upgraded to Qwen 3 8B

**Date:** 2025-12-03

## Changes Made

### Model Upgrades
- **code-analyzer**: `qwen2.5-coder:7b` → `qwen3:8b`
- **file-summarizer**: `qwen2.5:7b` → `qwen3:8b`
- **doc-generator**: No change (still uses Gemini)

### Performance Improvements

Qwen 3 8B vs Qwen 2.5 7B benchmarks:
- **MMLU-pro**: 74 vs 45.0 (+64% improvement)
- **GPQA**: 59 vs 36.4 (+62% improvement)
- **MATH**: 90 vs 49.8 (+81% improvement)
- **Coding tasks**: Significant gains across all benchmarks

### VRAM Compatibility

**Hardware:** NVIDIA RTX 5060 (8GB VRAM)
- Qwen 3 8B model size: 5.2GB ✅ Fits comfortably
- Qwen 3 Coder 30B size: 19GB ❌ Too large

**Decision:** Use `qwen3:8b` for both code and general tasks since:
1. Already installed and fits in VRAM
2. Superior performance to qwen2.5-coder:7b
3. Handles both code and general reasoning well

### Files Modified

1. `/home/hazzard/homeproject/mcp-task-delegation/code-analyzer/server.py`
   - Line 21: Updated `OLLAMA_CODE_MODEL` default to `qwen3:8b`

2. `/home/hazzard/homeproject/mcp-task-delegation/file-summarizer/server.py`
   - Line 20: Updated `OLLAMA_SUMMARY_MODEL` default to `qwen3:8b`

3. `/home/hazzard/homeproject/CLAUDE.md`
   - Updated MCP Task Delegation section with new model info
   - Added performance note about Qwen 3 improvements

### What You Need to Do

**Restart Claude Code** to load the updated MCP servers with new model defaults.

The MCP servers will now automatically use `qwen3:8b` which is already installed in your Ollama instance.

### Optional: Environment Variable Override

If you want to use different models, set these in `.claude/mcp.json`:

```json
{
  "mcpServers": {
    "code-analyzer": {
      "env": {
        "OLLAMA_CODE_MODEL": "your-preferred-model"
      }
    },
    "file-summarizer": {
      "env": {
        "OLLAMA_SUMMARY_MODEL": "your-preferred-model"
      }
    }
  }
}
```

### Expected Results

- **Better code analysis**: More accurate bug detection, security review
- **Better log parsing**: Superior pattern recognition and error extraction  
- **Better reasoning**: Improved complex problem-solving
- **Same token savings**: Still offloads from Claude to local Ollama

### References

- [Qwen 3 8B vs Qwen 2.5 7B Comparison](https://blogs.novita.ai/qwen-3-and-qwen-2-5/)
- [Qwen 3 Technical Report](https://arxiv.org/pdf/2505.09388)
- [Qwen 3 Official Announcement](https://qwenlm.github.io/blog/qwen3/)
