#!/bin/bash
# Test script for code-analyzer MCP server

echo "Testing Code Analyzer MCP Server..."
echo ""

# Test with a sample Python function
TEST_CODE='def process_user_input(user_input):
    result = eval(user_input)
    return result'

echo "Test 1: Simple code analysis (Ollama)"
echo "Analyzing potentially dangerous code..."

python3 -c "
import asyncio
import json
from code_analyzer.server import call_ollama

async def test():
    prompt = '''Analyze this Python code for security issues. Be specific.

Code:
\`\`\`python
$TEST_CODE
\`\`\`

Focus on: security
Provide: 1) Issues found, 2) Severity (high/medium/low), 3) Suggested fixes'''

    result = await call_ollama(prompt)
    print(result)

asyncio.run(test())
" 2>/dev/null || echo "Note: Run via MCP client for full testing"

echo ""
echo "Test 2: To test via MCP protocol, use Claude Code after restart"
echo "Example usage in Claude Code:"
echo "  'Analyze this code for bugs: [paste code]'"
echo ""
echo "The code-analyzer server provides:"
echo "  - analyze_code_simple (Ollama - fast, free)"
echo "  - analyze_code_deep (Gemini - thorough, uses API tokens)"
echo "  - review_diff (Ollama - quick PR reviews)"
