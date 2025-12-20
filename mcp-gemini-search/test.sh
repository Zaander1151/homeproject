#!/bin/bash
# Test script for Gemini MCP server

echo "Testing Gemini MCP Search Server..."
echo "====================================="
echo ""

# Test if the server can start
export GEMINI_API_KEY="AIzaSyAa6XidjIAEbij_FXZickDeM-VXvEWoQRI"

echo "Starting MCP server (press Ctrl+C after you see 'running on stdio')..."
echo ""

node /home/hazzard/homeproject/mcp-gemini-search/index.js
