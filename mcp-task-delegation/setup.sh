#!/bin/bash
# Setup script for MCP Task Delegation servers

set -e

echo "Setting up MCP Task Delegation servers..."

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Install Python dependencies
echo "Installing Python dependencies..."
./venv/bin/pip install -r requirements.txt

# Make server scripts executable
echo "Making server scripts executable..."
chmod +x code-analyzer/server.py
chmod +x file-summarizer/server.py
chmod +x doc-generator/server.py

# Verify Ollama is accessible
echo "Checking Ollama connection..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "✓ Ollama is accessible"
else
    echo "⚠ Warning: Ollama is not accessible at http://localhost:11434"
    echo "  Make sure Ollama is running: docker ps | grep ollama"
fi

# Check required Ollama models
echo ""
echo "Checking Ollama models..."
REQUIRED_MODELS=("qwen2.5-coder:7b" "qwen2.5:7b")

for model in "${REQUIRED_MODELS[@]}"; do
    if docker exec ollama ollama list | grep -q "${model}"; then
        echo "✓ Model ${model} is installed"
    else
        echo "⚠ Model ${model} is NOT installed"
        echo "  Install with: docker exec ollama ollama pull ${model}"
    fi
done

echo ""
echo "Setup complete!"
echo ""
echo "To test the servers:"
echo "  ./test-code-analyzer.sh"
echo "  ./test-file-summarizer.sh"
echo "  ./test-doc-generator.sh"
echo ""
echo "Servers are configured in .claude/mcp.json and will be available in Claude Code after restart."
