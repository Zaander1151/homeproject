#!/usr/bin/env bash
# Launch Gemini CLI interactively with full home access and preferred settings

# Absolute path to your home directory
HOME_DIR="$HOME"

# Optional: check that Gemini CLI is installed
if ! command -v gemini &>/dev/null; then
  echo "Error: gemini command not found. Please ensure Gemini CLI is installed and in PATH."
  exit 1
fi

# Launch Gemini
gemini \
  --include-directories "$HOME_DIR"
