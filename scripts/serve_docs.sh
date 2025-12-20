#!/bin/bash
# Simple documentation server for homeproject
# Serves markdown files with automatic rendering

PORT=8888
DOCS_DIR="/home/hazzard/homeproject"

echo "Starting documentation server..."
echo "Access at: http://192.168.40.201:${PORT}"
echo "Press Ctrl+C to stop"

cd "$DOCS_DIR"
python3 -m http.server $PORT --bind 0.0.0.0
