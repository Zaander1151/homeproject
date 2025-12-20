#!/usr/bin/env python3
"""
MCP Code Analysis Server
Delegates code analysis tasks to Ollama (simple) or Gemini (complex)
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
from mcp.types import Tool, TextContent, ImageContent, EmbeddedResource

# Configuration
OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
OLLAMA_CODE_MODEL = os.getenv("OLLAMA_CODE_MODEL", "qwen3:8b")
GEMINI_MODEL = "gemini-2.0-flash-exp"

server = Server("code-analyzer")

async def call_ollama(prompt: str, model: str = OLLAMA_CODE_MODEL) -> str:
    """Call local Ollama for code analysis"""
    async with httpx.AsyncClient(timeout=120.0) as client:
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

async def call_gemini(prompt: str) -> str:
    """Call Gemini API for complex code analysis"""
    if not GEMINI_API_KEY:
        raise ValueError("GEMINI_API_KEY not set")

    async with httpx.AsyncClient(timeout=120.0) as client:
        response = await client.post(
            f"https://generativelanguage.googleapis.com/v1beta/models/{GEMINI_MODEL}:generateContent?key={GEMINI_API_KEY}",
            json={
                "contents": [{"parts": [{"text": prompt}]}]
            }
        )
        response.raise_for_status()
        result = response.json()
        return result["candidates"][0]["content"]["parts"][0]["text"]

@server.list_tools()
async def handle_list_tools() -> list[Tool]:
    """List available code analysis tools"""
    return [
        Tool(
            name="analyze_code_simple",
            description="Quick code analysis using local Ollama (syntax, style, obvious bugs). Fast and free.",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "The code to analyze"
                    },
                    "language": {
                        "type": "string",
                        "description": "Programming language (e.g., python, javascript, yaml)"
                    },
                    "focus": {
                        "type": "string",
                        "description": "What to focus on: syntax, style, bugs, performance",
                        "enum": ["syntax", "style", "bugs", "performance", "all"]
                    }
                },
                "required": ["code", "language"]
            }
        ),
        Tool(
            name="analyze_code_deep",
            description="Deep code analysis using Gemini (security, architecture, complex bugs). More thorough but uses API tokens.",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "The code to analyze"
                    },
                    "language": {
                        "type": "string",
                        "description": "Programming language"
                    },
                    "context": {
                        "type": "string",
                        "description": "Additional context about the codebase or specific concerns"
                    }
                },
                "required": ["code", "language"]
            }
        ),
        Tool(
            name="review_diff",
            description="Review code changes/diff using Ollama for quick feedback",
            inputSchema={
                "type": "object",
                "properties": {
                    "diff": {
                        "type": "string",
                        "description": "Git diff or code changes to review"
                    },
                    "context": {
                        "type": "string",
                        "description": "Context about what changed and why"
                    }
                },
                "required": ["diff"]
            }
        )
    ]

@server.call_tool()
async def handle_call_tool(name: str, arguments: dict) -> list[TextContent]:
    """Handle tool calls"""

    if name == "analyze_code_simple":
        code = arguments["code"]
        language = arguments["language"]
        focus = arguments.get("focus", "all")

        prompt = f"""Analyze this {language} code for {focus}. Be concise and specific.

Code:
```{language}
{code}
```

Focus on: {focus}
Provide: 1) Issues found, 2) Severity (high/medium/low), 3) Suggested fixes"""

        result = await call_ollama(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "analyze_code_deep":
        code = arguments["code"]
        language = arguments["language"]
        context = arguments.get("context", "")

        prompt = f"""Perform a thorough code analysis of this {language} code.

{f'Context: {context}' if context else ''}

Code:
```{language}
{code}
```

Analyze:
1. Security vulnerabilities (injection, XSS, authentication, authorization)
2. Architecture and design patterns
3. Performance bottlenecks
4. Error handling and edge cases
5. Code maintainability and technical debt

Provide detailed findings with severity ratings and remediation steps."""

        result = await call_gemini(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "review_diff":
        diff = arguments["diff"]
        context = arguments.get("context", "")

        prompt = f"""Review these code changes. Focus on potential issues, breaking changes, and improvement suggestions.

{f'Context: {context}' if context else ''}

Diff:
```
{diff}
```

Provide: 1) Issues or concerns, 2) Suggestions, 3) Approval recommendation (approve/request changes)"""

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
                server_name="code-analyzer",
                server_version="0.1.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={},
                ),
            ),
        )

if __name__ == "__main__":
    asyncio.run(main())
