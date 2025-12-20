# MCP Gemini Search Server

An MCP (Model Context Protocol) server that provides web search capabilities using Google's Gemini API with search grounding.

## Features

- Web search via Gemini 2.0 Flash with Google Search integration
- Returns comprehensive search results with source citations
- Automatic grounding metadata extraction
- Seamless integration with Claude Code

## Installation

1. Install dependencies:
```bash
cd /home/hazzard/homeproject/mcp-gemini-search
npm install
```

2. Set up your Gemini API key:
   - Get an API key from https://aistudio.google.com/app/apikey
   - Add it to your environment or Claude Code MCP configuration

## Configuration for Claude Code

Add this to your Claude Code MCP settings (`.claude/mcp.json`):

```json
{
  "mcpServers": {
    "gemini-search": {
      "command": "node",
      "args": ["/home/hazzard/homeproject/mcp-gemini-search/index.js"],
      "env": {
        "GEMINI_API_KEY": "your-gemini-api-key-here"
      }
    }
  }
}
```

## Usage

Once configured, Claude Code will automatically have access to the `gemini_web_search` tool for web searches. Claude will use this instead of its built-in web search when available.

## Tool: gemini_web_search

**Description:** Search the web using Gemini with Google Search grounding

**Parameters:**
- `query` (string, required): The search query to look up on the web

**Returns:** Search results with source citations and grounding metadata

## Example

When Claude needs to search for information, it will automatically call:
```
gemini_web_search("latest home assistant features 2025")
```

And receive comprehensive results from Gemini including web sources.

## Troubleshooting

- **Server won't start:** Check that GEMINI_API_KEY is set correctly
- **No results:** Verify your API key has access to Gemini 2.0 Flash
- **Permission errors:** Ensure the index.js file is executable (`chmod +x index.js`)

## Model Used

- **Gemini 2.0 Flash Experimental** with Google Search grounding
- Optimized for fast, accurate web searches
- Includes source attribution and grounding metadata
