#!/bin/bash
# Test script for file-summarizer MCP server

echo "Testing File Summarizer MCP Server..."
echo ""

echo "Test: Checking Ollama connection..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "✓ Ollama is accessible"

    # Check if qwen2.5:7b is available
    if docker exec ollama ollama list | grep -q "qwen2.5:7b"; then
        echo "✓ Model qwen2.5:7b is available"
    else
        echo "⚠ Model qwen2.5:7b not found. Install with:"
        echo "  docker exec ollama ollama pull qwen2.5:7b"
    fi
else
    echo "✗ Ollama is not accessible at http://localhost:11434"
fi

echo ""
echo "The file-summarizer server provides:"
echo "  - summarize_file: Summarize logs, configs, documentation"
echo "  - extract_key_info: Extract errors, warnings, config values, etc."
echo "  - analyze_logs: Deep log analysis for patterns and issues"
echo "  - validate_config: Validate YAML, JSON, INI, TOML configs"
echo ""
echo "Example usage in Claude Code:"
echo "  'Summarize this log file: [paste logs]'"
echo "  'Extract all errors from these logs: [paste logs]'"
echo "  'Validate this docker-compose.yaml: [paste config]'"
