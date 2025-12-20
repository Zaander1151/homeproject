#!/usr/bin/env python3
"""
MCP File Summarization Server
Delegates file reading and summarization to Ollama
"""

import os
import sys
import json
import asyncio
import httpx
from typing import Any
from mcp.server.models import InitializationOptions
from mcp.server import NotificationOptions, Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

# Configuration
OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_SUMMARY_MODEL = os.getenv("OLLAMA_SUMMARY_MODEL", "qwen3:8b")

server = Server("file-summarizer")

async def call_ollama(prompt: str, model: str = OLLAMA_SUMMARY_MODEL) -> str:
    """Call local Ollama for summarization"""
    async with httpx.AsyncClient(timeout=180.0) as client:
        response = await client.post(
            f"{OLLAMA_BASE_URL}/api/generate",
            json={
                "model": model,
                "prompt": prompt,
                "stream": False
            }
        )
        response.raise_for_status()
        return response.json()["response"]

@server.list_tools()
async def handle_list_tools() -> list[Tool]:
    """List available file summarization tools"""
    return [
        Tool(
            name="summarize_file",
            description="Summarize file content using local Ollama. Good for logs, configs, documentation.",
            inputSchema={
                "type": "object",
                "properties": {
                    "content": {
                        "type": "string",
                        "description": "File content to summarize"
                    },
                    "file_type": {
                        "type": "string",
                        "description": "Type of file: log, config, code, documentation, json, yaml"
                    },
                    "focus": {
                        "type": "string",
                        "description": "What to focus on in the summary (optional)"
                    }
                },
                "required": ["content", "file_type"]
            }
        ),
        Tool(
            name="extract_key_info",
            description="Extract specific information from file content (errors, warnings, config values, etc.)",
            inputSchema={
                "type": "object",
                "properties": {
                    "content": {
                        "type": "string",
                        "description": "File content to analyze"
                    },
                    "extract": {
                        "type": "string",
                        "description": "What to extract: errors, warnings, config_values, api_endpoints, dependencies"
                    }
                },
                "required": ["content", "extract"]
            }
        ),
        Tool(
            name="analyze_logs",
            description="Analyze log files for errors, patterns, and anomalies",
            inputSchema={
                "type": "object",
                "properties": {
                    "logs": {
                        "type": "string",
                        "description": "Log content to analyze"
                    },
                    "timeframe": {
                        "type": "string",
                        "description": "Timeframe of logs (optional)"
                    }
                },
                "required": ["logs"]
            }
        ),
        Tool(
            name="validate_config",
            description="Validate and explain configuration files (YAML, JSON, INI, etc.)",
            inputSchema={
                "type": "object",
                "properties": {
                    "config": {
                        "type": "string",
                        "description": "Configuration file content"
                    },
                    "format": {
                        "type": "string",
                        "description": "Config format: yaml, json, ini, toml, env"
                    }
                },
                "required": ["config", "format"]
            }
        )
    ]

@server.call_tool()
async def handle_call_tool(name: str, arguments: dict) -> list[TextContent]:
    """Handle tool calls"""

    if name == "summarize_file":
        content = arguments["content"]
        file_type = arguments["file_type"]
        focus = arguments.get("focus", "")

        prompt = f"""Summarize this {file_type} file. Be concise but comprehensive.

{f'Focus on: {focus}' if focus else ''}

Content:
```
{content[:10000]}  # Limit to ~10KB
```

Provide:
1. Main purpose/overview
2. Key points or sections
3. Notable items (errors, warnings, important configs)
4. Recommendations (if applicable)"""

        result = await call_ollama(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "extract_key_info":
        content = arguments["content"]
        extract = arguments["extract"]

        extract_prompts = {
            "errors": "Extract all errors with context. Format: [Line/Time] Error message",
            "warnings": "Extract all warnings with context",
            "config_values": "Extract all configuration key-value pairs",
            "api_endpoints": "Extract all API endpoints/URLs mentioned",
            "dependencies": "Extract all dependencies, imports, or required packages"
        }

        prompt = f"""From this content, {extract_prompts.get(extract, f'extract: {extract}')}.

Content:
```
{content[:15000]}
```

List items in a clear, structured format."""

        result = await call_ollama(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "analyze_logs":
        logs = arguments["logs"]
        timeframe = arguments.get("timeframe", "")

        prompt = f"""Analyze these log files for issues, patterns, and anomalies.

{f'Timeframe: {timeframe}' if timeframe else ''}

Logs:
```
{logs[:15000]}
```

Provide:
1. Error summary (count, types, severity)
2. Warning summary
3. Patterns or recurring issues
4. Anomalies or unusual behavior
5. Root cause analysis (if identifiable)
6. Recommendations"""

        result = await call_ollama(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "validate_config":
        config = arguments["config"]
        format_type = arguments["format"]

        prompt = f"""Validate and explain this {format_type.upper()} configuration file.

Configuration:
```{format_type}
{config}
```

Provide:
1. Syntax validation (any errors?)
2. Explanation of each section/key
3. Potential issues or misconfigurations
4. Security concerns (hardcoded secrets, weak settings)
5. Optimization suggestions"""

        result = await call_ollama(prompt)
        return [TextContent(type="text", text=result)]

    else:
        raise ValueError(f"Unknown tool: {name}")

async def main():
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="file-summarizer",
                server_version="0.1.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={},
                ),
            ),
        )

if __name__ == "__main__":
    asyncio.run(main())
