#!/bin/bash
# Test script for doc-generator MCP server

echo "Testing Documentation Generator MCP Server..."
echo ""

# Check if GEMINI_API_KEY is set
if [ -z "$GEMINI_API_KEY" ]; then
    echo "⚠ GEMINI_API_KEY environment variable not set"
    echo "  The key is configured in .claude/mcp.json for Claude Code"
else
    echo "✓ GEMINI_API_KEY is set"
fi

echo ""
echo "The doc-generator server provides:"
echo "  - generate_function_docs: Create docstrings (Google, NumPy, Sphinx, JSDoc styles)"
echo "  - generate_readme: Create comprehensive README.md"
echo "  - generate_api_docs: Document API endpoints"
echo "  - explain_code: Detailed code explanations for different skill levels"
echo "  - generate_changelog: Create CHANGELOG.md entries"
echo ""
echo "Example usage in Claude Code:"
echo "  'Generate docstring for this function: [paste code]'"
echo "  'Create a README for my project about [description]'"
echo "  'Document these API endpoints: [paste code]'"
echo "  'Explain this code for beginners: [paste code]'"
echo ""
echo "Note: Uses Gemini 2.0 Flash for high-quality documentation"
