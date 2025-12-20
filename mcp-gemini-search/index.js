#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { GoogleGenerativeAI } from '@google/generative-ai';

// Initialize Gemini API
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
if (!GEMINI_API_KEY) {
  console.error('Error: GEMINI_API_KEY environment variable is required');
  process.exit(1);
}

const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);

// Create MCP server
const server = new Server(
  {
    name: 'mcp-gemini-search',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Register the list_tools handler
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'gemini_web_search',
        description: 'Search the web using Gemini with Google Search grounding. Returns comprehensive search results with up-to-date information.',
        inputSchema: {
          type: 'object',
          properties: {
            query: {
              type: 'string',
              description: 'The search query to look up on the web',
            },
          },
          required: ['query'],
        },
      },
    ],
  };
});

// Register the call_tool handler
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name !== 'gemini_web_search') {
    throw new Error(`Unknown tool: ${request.params.name}`);
  }

  const { query } = request.params.arguments;

  if (!query || typeof query !== 'string') {
    throw new Error('Invalid query parameter');
  }

  try {
    // Use Gemini 2.0 Flash with Google Search grounding
    const model = genAI.getGenerativeModel({
      model: 'gemini-2.0-flash-exp',
      tools: [{ googleSearch: {} }],
    });

    const result = await model.generateContent(query);
    const response = await result.response;
    const text = response.text();

    // Get grounding metadata if available
    const groundingMetadata = response.candidates?.[0]?.groundingMetadata;
    let searchResults = '';

    if (groundingMetadata?.webSearchQueries) {
      searchResults += '\n\nSearch queries used:\n';
      searchResults += groundingMetadata.webSearchQueries.join('\n');
    }

    if (groundingMetadata?.groundingChunks) {
      searchResults += '\n\nSources:\n';
      groundingMetadata.groundingChunks.forEach((chunk, idx) => {
        if (chunk.web) {
          searchResults += `${idx + 1}. ${chunk.web.title || 'Unknown'}\n   ${chunk.web.uri}\n`;
        }
      });
    }

    return {
      content: [
        {
          type: 'text',
          text: text + searchResults,
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: `Error performing search: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Gemini MCP Search Server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
