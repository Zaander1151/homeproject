#!/bin/bash

# Setup script for Network Administrator Agent MCP Server

set -e

echo "========================================="
echo "Network Administrator Agent - Setup"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Install Node.js dependencies
echo "1. Installing Node.js dependencies..."
npm install
echo -e "${GREEN}✓${NC} Dependencies installed"
echo ""

# 2. Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "2. Creating .env file..."
    cp .env.example .env
    echo -e "${YELLOW}!${NC} Please edit .env and add your GEMINI_API_KEY"
    echo ""
else
    echo "2. .env file already exists"
    echo ""
fi

# 3. Make scripts executable
echo "3. Making scripts executable..."
chmod +x setup.sh
chmod +x test.sh
chmod +x server.js
echo -e "${GREEN}✓${NC} Scripts are executable"
echo ""

# 4. Verify Ollama is running
echo "4. Checking Ollama..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Ollama is running"
else
    echo -e "${YELLOW}!${NC} Ollama is not running. Start with:"
    echo "    cd /home/hazzard/ollama && docker-compose up -d"
fi
echo ""

# 5. Check for qwen3:8b
echo "5. Checking Qwen3 model..."
if docker exec ollama ollama list | grep -q "qwen3:8b"; then
    echo -e "${GREEN}✓${NC} Qwen3 8B is installed"
else
    echo -e "${YELLOW}!${NC} Qwen3 8B not found. Already pulled earlier."
fi
echo ""

echo "========================================="
echo -e "${GREEN}Setup complete!${NC}"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env and add your GEMINI_API_KEY"
echo "2. Run ./test.sh to verify everything works"
echo "3. Update .claude/mcp.json to load the agent"
echo "4. Restart Claude Code"
echo ""
