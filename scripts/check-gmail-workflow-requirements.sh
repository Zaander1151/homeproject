#!/bin/bash

# Gmail AI Manager - Requirements Checker
# This script verifies that all prerequisites are met

echo "════════════════════════════════════════════════════════"
echo "  Gmail AI Manager - Prerequisites Check"
echo "════════════════════════════════════════════════════════"
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check 1: n8n is running
echo "Checking services..."
if docker ps | grep -q n8n_ai_agent; then
    check_pass "n8n is running"
    N8N_URL="http://localhost:5678"
    echo "   → Access at: $N8N_URL"
else
    check_fail "n8n is NOT running"
    echo "   → Start with: cd /home/hazzard/n8n && docker-compose up -d"
fi

# Check 2: Ollama is running
if docker ps | grep -q ollama; then
    check_pass "Ollama is running"
    OLLAMA_URL="http://localhost:11434"
    echo "   → API endpoint: $OLLAMA_URL"
else
    check_fail "Ollama is NOT running"
    echo "   → Start with: cd /home/hazzard/ollama && docker-compose up -d"
fi

# Check 3: Ollama models
echo ""
echo "Checking Ollama models..."
if docker exec ollama ollama list | grep -q llama3; then
    check_pass "Llama3 models available"
    echo "   Available models:"
    docker exec ollama ollama list | grep llama3 | awk '{print "   →", $1}'
else
    check_warn "No Llama3 models found"
    echo "   → Install with: docker exec ollama ollama pull llama3.2:latest"
fi

# Check 4: Workflow file exists
echo ""
echo "Checking workflow files..."
if [ -f "/mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-build-guide.md" ]; then
    check_pass "Build guide found"
    echo "   → Location: /mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-build-guide.md"
else
    check_fail "Build guide NOT found"
fi

if [ -f "/mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-workflow.json" ]; then
    check_pass "Workflow JSON file found (legacy)"
    echo "   → Location: /mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-workflow.json"
else
    check_warn "Workflow JSON file NOT found (not required)"
fi

if [ -f "/home/hazzard/homeproject/gmail-ai-manager-setup-guide.md" ]; then
    check_pass "Setup guide found"
    echo "   → Location: /home/hazzard/homeproject/gmail-ai-manager-setup-guide.md"
else
    check_fail "Setup guide NOT found"
fi

# Check 5: Network connectivity
echo ""
echo "Checking network connectivity..."
if curl -s http://localhost:5678 > /dev/null 2>&1; then
    check_pass "n8n web interface accessible"
else
    check_warn "n8n web interface not accessible (may be starting up)"
fi

if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    check_pass "Ollama API accessible"
else
    check_warn "Ollama API not accessible (may be starting up)"
fi

# Summary and Next Steps
echo ""
echo "════════════════════════════════════════════════════════"
echo "  Next Steps"
echo "════════════════════════════════════════════════════════"
echo ""
echo "1. Create a Telegram Bot:"
echo "   → Message @BotFather on Telegram"
echo "   → Send: /newbot"
echo "   → Save your bot token"
echo ""
echo "2. Get your Telegram Chat ID:"
echo "   → Message @userinfobot on Telegram"
echo "   → Save your chat ID"
echo ""
echo "3. Set up Google Cloud OAuth:"
echo "   → Visit: https://console.cloud.google.com/"
echo "   → Enable Gmail API and Google Calendar API"
echo "   → Create OAuth 2.0 credentials"
echo "   → Save Client ID and Secret"
echo ""
echo "4. Build workflow in n8n (RECOMMENDED):"
echo "   → Open: http://localhost:5678"
echo "   → Follow the step-by-step guide:"
echo "   → /mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-build-guide.md"
echo ""
echo "   Or import legacy JSON workflow:"
echo "   → Click 'Import from File' in n8n"
echo "   → Select: /mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-workflow.json"
echo ""
echo "5. Configure credentials in n8n:"
echo "   → Gmail OAuth2"
echo "   → Google Calendar OAuth2"
echo "   → Telegram Bot API"
echo "   → Ollama API"
echo ""
echo "6. Read the full setup guide:"
echo "   → cat /home/hazzard/homeproject/gmail-ai-manager-setup-guide.md"
echo "   → Or open in your favorite text editor"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""
