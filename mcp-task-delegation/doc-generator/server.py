#!/usr/bin/env python3
"""
MCP Documentation Generator Server
Uses Gemini for high-quality documentation generation
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
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_MODEL = "gemini-2.0-flash-exp"

server = Server("doc-generator")

async def call_gemini(prompt: str) -> str:
    """Call Gemini API for documentation generation"""
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
    """List available documentation tools"""
    return [
        Tool(
            name="generate_function_docs",
            description="Generate comprehensive docstrings for functions/methods",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "Function/method code to document"
                    },
                    "language": {
                        "type": "string",
                        "description": "Programming language"
                    },
                    "style": {
                        "type": "string",
                        "description": "Documentation style: google, numpy, sphinx, jsdoc",
                        "default": "google"
                    }
                },
                "required": ["code", "language"]
            }
        ),
        Tool(
            name="generate_readme",
            description="Generate README.md for a project",
            inputSchema={
                "type": "object",
                "properties": {
                    "project_name": {
                        "type": "string",
                        "description": "Project name"
                    },
                    "description": {
                        "type": "string",
                        "description": "Brief project description"
                    },
                    "code_samples": {
                        "type": "string",
                        "description": "Sample code or project structure (optional)"
                    },
                    "features": {
                        "type": "string",
                        "description": "List of features (optional)"
                    }
                },
                "required": ["project_name", "description"]
            }
        ),
        Tool(
            name="generate_api_docs",
            description="Generate API documentation from code",
            inputSchema={
                "type": "object",
                "properties": {
                    "api_code": {
                        "type": "string",
                        "description": "API routes/endpoints code"
                    },
                    "framework": {
                        "type": "string",
                        "description": "Framework: fastapi, flask, express, django"
                    }
                },
                "required": ["api_code", "framework"]
            }
        ),
        Tool(
            name="explain_code",
            description="Generate detailed explanation of complex code",
            inputSchema={
                "type": "object",
                "properties": {
                    "code": {
                        "type": "string",
                        "description": "Code to explain"
                    },
                    "language": {
                        "type": "string",
                        "description": "Programming language"
                    },
                    "audience": {
                        "type": "string",
                        "description": "Target audience: beginner, intermediate, expert",
                        "default": "intermediate"
                    }
                },
                "required": ["code", "language"]
            }
        ),
        Tool(
            name="generate_changelog",
            description="Generate CHANGELOG.md entry from changes",
            inputSchema={
                "type": "object",
                "properties": {
                    "changes": {
                        "type": "string",
                        "description": "Description of changes, commits, or diff"
                    },
                    "version": {
                        "type": "string",
                        "description": "Version number (optional)"
                    }
                },
                "required": ["changes"]
            }
        )
    ]

@server.call_tool()
async def handle_call_tool(name: str, arguments: dict) -> list[TextContent]:
    """Handle tool calls"""

    if name == "generate_function_docs":
        code = arguments["code"]
        language = arguments["language"]
        style = arguments.get("style", "google")

        prompt = f"""Generate comprehensive {style}-style docstring for this {language} function.

Code:
```{language}
{code}
```

Include:
1. Brief description
2. Parameters with types and descriptions
3. Return value with type and description
4. Raises/Exceptions (if applicable)
5. Usage example
6. Notes on complexity or edge cases

Format the docstring exactly as it should appear in the code."""

        result = await call_gemini(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "generate_readme":
        project_name = arguments["project_name"]
        description = arguments["description"]
        code_samples = arguments.get("code_samples", "")
        features = arguments.get("features", "")

        prompt = f"""Generate a comprehensive README.md for this project.

**Project Name:** {project_name}
**Description:** {description}
{f'**Features:** {features}' if features else ''}
{f'**Code/Structure:** {code_samples}' if code_samples else ''}

Include:
1. Title and badges (if applicable)
2. Description and purpose
3. Features
4. Installation instructions
5. Usage examples
6. Configuration (if applicable)
7. Contributing guidelines
8. License section

Use professional, clear markdown formatting."""

        result = await call_gemini(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "generate_api_docs":
        api_code = arguments["api_code"]
        framework = arguments["framework"]

        prompt = f"""Generate API documentation for these {framework} endpoints.

Code:
```
{api_code}
```

For each endpoint, document:
1. Method and path
2. Description
3. Request parameters (path, query, body)
4. Request body schema
5. Response format (success and error cases)
6. Status codes
7. Example requests (curl and code)
8. Authentication requirements (if any)

Format as clear, professional API documentation."""

        result = await call_gemini(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "explain_code":
        code = arguments["code"]
        language = arguments["language"]
        audience = arguments.get("audience", "intermediate")

        prompt = f"""Explain this {language} code for a {audience}-level audience.

Code:
```{language}
{code}
```

Provide:
1. High-level overview (what does it do?)
2. Step-by-step walkthrough
3. Key concepts and patterns used
4. Potential gotchas or non-obvious behavior
5. Use cases or when to use this pattern

Adjust technical depth for {audience} audience."""

        result = await call_gemini(prompt)
        return [TextContent(type="text", text=result)]

    elif name == "generate_changelog":
        changes = arguments["changes"]
        version = arguments.get("version", "")

        prompt = f"""Generate a CHANGELOG.md entry for these changes.

{f'Version: {version}' if version else ''}

Changes:
```
{changes}
```

Format following Keep a Changelog standard:
- Categorize changes: Added, Changed, Deprecated, Removed, Fixed, Security
- Use present tense
- Be concise but descriptive
- Include version and date
- Highlight breaking changes"""

        result = await call_gemini(prompt)
        return [TextContent(type="text", text=result)]

    else:
        raise ValueError(f"Unknown tool: {name}")

async def main():
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="doc-generator",
                server_version="0.1.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={},
                ),
            ),
        )

if __name__ == "__main__":
    asyncio.run(main())
