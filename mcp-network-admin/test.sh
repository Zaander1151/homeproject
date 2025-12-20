#!/bin/bash

# Test script for Network Administrator Agent MCP Server

set -e

echo "========================================="
echo "Network Administrator Agent - Test Suite"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load environment
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

echo "1. Checking Ollama connection..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Ollama is running"
else
    echo -e "${RED}✗${NC} Ollama is not accessible"
    exit 1
fi

echo ""
echo "2. Checking Qwen3 model..."
if docker exec ollama ollama list | grep -q "qwen3:8b"; then
    echo -e "${GREEN}✓${NC} Qwen3 8B model is installed"
else
    echo -e "${YELLOW}!${NC} Qwen3 8B model not found, pulling..."
    docker exec ollama ollama pull qwen3:8b
fi

echo ""
echo "3. Checking Gemini API key..."
if [ -z "$GEMINI_API_KEY" ]; then
    echo -e "${YELLOW}!${NC} GEMINI_API_KEY not set (Tier 2 tools will not work)"
else
    echo -e "${GREEN}✓${NC} GEMINI_API_KEY is configured"
fi

echo ""
echo "4. Testing safe command execution..."

# Test docker ps
if docker ps > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Can execute Docker commands"
else
    echo -e "${RED}✗${NC} Cannot execute Docker commands"
    exit 1
fi

echo ""
echo "5. Testing network utilities..."

# Test ping
if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} ping is available"
else
    echo -e "${YELLOW}!${NC} ping may not be available"
fi

# Test dig
if command -v dig > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} dig is available"
else
    echo -e "${YELLOW}!${NC} dig is not installed"
fi

echo ""
echo "6. Testing Ollama inference..."

RESPONSE=$(curl -s http://localhost:11434/api/generate -d '{
  "model": "qwen3:8b",
  "prompt": "Say hello in exactly 3 words",
  "stream": false
}')

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Ollama inference working"
    echo "   Response: $(echo $RESPONSE | jq -r '.response' | head -c 50)..."
else
    echo -e "${RED}✗${NC} Ollama inference failed"
    exit 1
fi

echo ""
echo "7. Checking dependencies..."
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}!${NC} Dependencies not installed, running npm install..."
    npm install
else
    echo -e "${GREEN}✓${NC} Dependencies installed"
fi

echo ""
echo "========================================="
echo -e "${GREEN}All tests passed!${NC}"
echo "========================================="
echo ""
echo "The Network Administrator Agent is ready to use."
echo ""
echo "To add to Claude Code, update .claude/mcp.json:"
echo ""
echo '{
  "mcpServers": {
    "network-admin": {
      "command": "node",
      "args": ["/home/hazzard/homeproject/mcp-network-admin/server.js"],
      "env": {
        "OLLAMA_BASE_URL": "http://localhost:11434",
        "OLLAMA_MODEL": "qwen3:8b",
        "GEMINI_API_KEY": "'"$GEMINI_API_KEY"'"
      }
    }
  }
}'
echo ""
