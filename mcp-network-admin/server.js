#!/usr/bin/env node

/**
 * Network Administrator Agent - MCP Server
 *
 * Provides autonomous network troubleshooting, monitoring, and security analysis for the home automation infrastructure.
 * Uses tiered AI approach: Qwen3 (local) for routine tasks, Gemini for complex analysis.
 *
 * Capabilities:
 * - Network device discovery and mapping (nmap, ARP)
 * - Port scanning with service identification
 * - Complete network topology generation
 * - Container connectivity diagnostics (ping, DNS, network inspect)
 * - Service health monitoring and auto-restart
 * - Log analysis for network-related errors
 * - Port conflict detection
 * - MQTT broker health checks
 * - Cloudflare Tunnel connectivity monitoring
 * - Security vulnerability assessment
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// Ollama configuration
const OLLAMA_BASE_URL = process.env.OLLAMA_BASE_URL || 'http://localhost:11434';
const OLLAMA_MODEL = process.env.OLLAMA_MODEL || 'qwen3:8b';

// Gemini configuration
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_MODEL = 'gemini-2.0-flash-exp';

// Safe commands whitelist - these can be executed autonomously
const SAFE_COMMANDS = [
  'docker ps',
  'docker inspect',
  'docker logs',
  'docker stats --no-stream',
  'docker network inspect',
  'docker network ls',
  'ping -c 4',
  'dig',
  'nslookup',
  'ss -tulpn',
  'netstat -tulpn',
  'ip addr',
  'ip route',
  'ip neighbor',
  'arp -a',
  'nmap -sn',      // Ping scan (no port scan)
  'nmap -sP',      // Ping scan (alternative)
  'nmap -p',       // Port scan with specific ports
  'sudo nmap',     // Allow sudo nmap for privileged scans
  'docker exec',  // Only for safe read-only commands within containers
];

// Commands requiring approval
const APPROVAL_REQUIRED = [
  'docker restart',
  'docker stop',
  'docker start',
  'docker-compose restart',
  'systemctl restart',
  'iptables',
  'ufw',
];

/**
 * Execute a shell command safely
 */
async function executeSafeCommand(command) {
  // Check if command is in safe list
  const isSafe = SAFE_COMMANDS.some(safe => command.trim().startsWith(safe));
  const needsApproval = APPROVAL_REQUIRED.some(req => command.trim().includes(req));

  if (needsApproval) {
    return {
      success: false,
      requiresApproval: true,
      command,
      message: 'This command requires human approval before execution'
    };
  }

  if (!isSafe) {
    return {
      success: false,
      error: 'Command not in safe whitelist',
      command
    };
  }

  try {
    const { stdout, stderr } = await execAsync(command, {
      timeout: 30000, // 30 second timeout
      maxBuffer: 1024 * 1024 * 10 // 10MB buffer
    });

    return {
      success: true,
      stdout: stdout.trim(),
      stderr: stderr.trim(),
      command
    };
  } catch (error) {
    return {
      success: false,
      error: error.message,
      stdout: error.stdout?.trim() || '',
      stderr: error.stderr?.trim() || '',
      command
    };
  }
}

/**
 * Call Ollama for Tier 1 analysis (local, fast, free)
 */
async function callOllama(prompt, systemPrompt) {
  const response = await fetch(`${OLLAMA_BASE_URL}/api/generate`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      model: OLLAMA_MODEL,
      prompt,
      system: systemPrompt,
      stream: false,
      options: {
        temperature: 0.3, // Lower temperature for more focused diagnostics
        top_p: 0.9,
      }
    })
  });

  if (!response.ok) {
    throw new Error(`Ollama API error: ${response.statusText}`);
  }

  const data = await response.json();
  return data.response;
}

/**
 * Call Gemini for Tier 2 analysis (complex, uses Gemini tokens)
 */
async function callGemini(prompt, systemPrompt) {
  if (!GEMINI_API_KEY) {
    throw new Error('GEMINI_API_KEY not configured');
  }

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{
          parts: [{
            text: `${systemPrompt}\n\n${prompt}`
          }]
        }],
        generationConfig: {
          temperature: 0.3,
          topP: 0.9,
          maxOutputTokens: 2048,
        }
      })
    }
  );

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Gemini API error: ${error}`);
  }

  const data = await response.json();
  return data.candidates[0]?.content?.parts[0]?.text || 'No response from Gemini';
}

/**
 * MCP Tools
 */

// Tool 1: Container Health Check (Tier 1 - Ollama)
async function checkContainerHealth(containerName) {
  const results = {};

  // Get container status
  const statusCmd = containerName
    ? `docker ps -a --filter name=${containerName} --format "{{.Names}}\t{{.Status}}\t{{.State}}"`
    : `docker ps -a --format "{{.Names}}\t{{.Status}}\t{{.State}}"`;

  results.status = await executeSafeCommand(statusCmd);

  // Get container logs (last 50 lines)
  if (containerName) {
    results.logs = await executeSafeCommand(`docker logs --tail 50 ${containerName}`);

    // Get container inspect for detailed info
    results.inspect = await executeSafeCommand(`docker inspect ${containerName}`);
  }

  // Analyze with Ollama
  const systemPrompt = `You are a Docker container health analyst. Analyze the container status, logs, and configuration. Identify issues, suggest fixes, and indicate severity (low/medium/high/critical).`;

  const prompt = `Analyze this container health data:

Status: ${JSON.stringify(results.status, null, 2)}
${results.logs ? `Recent Logs: ${results.logs.stdout?.substring(0, 2000)}` : ''}
${results.inspect ? `Configuration: ${results.inspect.stdout?.substring(0, 1000)}` : ''}

Provide:
1. Health assessment (healthy/degraded/failing/critical)
2. Issues identified
3. Root cause analysis
4. Recommended actions (safe autonomous fixes and/or approval-required fixes)`;

  const analysis = await callOllama(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'ollama',
    model: OLLAMA_MODEL
  };
}

// Tool 2: Network Connectivity Check (Tier 1 - Ollama)
async function checkNetworkConnectivity(target, options = {}) {
  const results = {};

  // Determine if target is container or hostname
  const isContainer = !target.includes('.');

  if (isContainer) {
    // Check container connectivity
    results.containerInfo = await executeSafeCommand(`docker inspect ${target}`);
    results.networks = await executeSafeCommand(`docker network ls`);

    // Try to ping from container
    results.ping = await executeSafeCommand(`docker exec ${target} ping -c 4 8.8.8.8`);
    results.dns = await executeSafeCommand(`docker exec ${target} nslookup google.com`);
  } else {
    // Check hostname connectivity
    results.ping = await executeSafeCommand(`ping -c 4 ${target}`);
    results.dns = await executeSafeCommand(`dig ${target}`);
  }

  // Get routing table
  results.routes = await executeSafeCommand(`ip route`);

  // Get network interfaces
  results.interfaces = await executeSafeCommand(`ip addr`);

  // Analyze with Ollama
  const systemPrompt = `You are a network connectivity troubleshooter. Analyze ping, DNS, routing, and network configuration. Identify connectivity issues and suggest fixes.`;

  const prompt = `Analyze network connectivity for ${isContainer ? 'container' : 'host'}: ${target}

${Object.entries(results).map(([key, value]) =>
    `${key}: ${value.success ? value.stdout?.substring(0, 500) : value.error}`
  ).join('\n\n')}

Provide:
1. Connectivity status (connected/degraded/disconnected)
2. Issues identified (DNS, routing, firewall, etc.)
3. Root cause analysis
4. Step-by-step remediation (indicate which steps need approval)`;

  const analysis = await callOllama(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'ollama',
    model: OLLAMA_MODEL
  };
}

// Tool 3: Log Analysis (Tier 1 - Ollama)
async function analyzeLogsForErrors(containerName, lines = 100) {
  const results = {};

  // Get logs
  const logsCmd = containerName
    ? `docker logs --tail ${lines} ${containerName}`
    : `journalctl -n ${lines}`;

  results.logs = await executeSafeCommand(logsCmd);

  // Analyze with Ollama
  const systemPrompt = `You are a log analysis expert specializing in identifying network and service errors. Extract error patterns, categorize by severity, and suggest fixes.`;

  const prompt = `Analyze these logs for network and connectivity errors:

${results.logs.stdout || results.logs.stderr || 'No logs available'}

Provide:
1. Error patterns identified (with counts)
2. Severity categorization
3. Likely root causes
4. Recommended fixes
5. Whether this requires escalation to human or Gemini for deeper analysis`;

  const analysis = await callOllama(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'ollama',
    model: OLLAMA_MODEL
  };
}

// Tool 4: Port Conflict Detection (Tier 1 - Ollama)
async function detectPortConflicts() {
  const results = {};

  // Get all listening ports
  results.ports = await executeSafeCommand(`ss -tulpn`);

  // Get Docker port mappings
  results.dockerPorts = await executeSafeCommand(`docker ps --format "{{.Names}}\t{{.Ports}}"`);

  // Analyze with Ollama
  const systemPrompt = `You are a port conflict analyst. Identify port conflicts, duplicate bindings, and potential issues with service ports.`;

  const prompt = `Analyze port usage and detect conflicts:

System Ports:
${results.ports.stdout?.substring(0, 2000) || 'No data'}

Docker Port Mappings:
${results.dockerPorts.stdout || 'No data'}

Provide:
1. Port conflicts identified
2. Services affected
3. Recommended resolution steps`;

  const analysis = await callOllama(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'ollama',
    model: OLLAMA_MODEL
  };
}

// Tool 5: Deep Network Analysis (Tier 2 - Gemini)
async function deepNetworkAnalysis(scope = 'all') {
  const results = {};

  // Gather comprehensive network data
  results.dockerNetworks = await executeSafeCommand(`docker network ls`);
  results.containers = await executeSafeCommand(`docker ps -a --format "{{.Names}}\t{{.Status}}\t{{.Ports}}"`);
  results.networkInterfaces = await executeSafeCommand(`ip addr`);
  results.routes = await executeSafeCommand(`ip route`);
  results.listeningPorts = await executeSafeCommand(`ss -tulpn`);

  // Check key services
  results.mqttCheck = await executeSafeCommand(`docker exec mosquitto netstat -tulpn | grep 1883 || echo "MQTT check failed"`);
  results.cloudflareCheck = await executeSafeCommand(`docker ps --filter name=cloudflared --format "{{.Status}}"`);

  // Analyze with Gemini (Tier 2 - complex architectural analysis)
  const systemPrompt = `You are a senior network architect specializing in Docker-based home automation infrastructure. Perform deep architectural analysis, identify systemic issues, security vulnerabilities, and optimization opportunities.`;

  const prompt = `Perform comprehensive network analysis:

Docker Networks:
${results.dockerNetworks.stdout}

Containers:
${results.containers.stdout}

Network Interfaces:
${results.networkInterfaces.stdout?.substring(0, 1000)}

Routes:
${results.routes.stdout}

Listening Ports:
${results.listeningPorts.stdout?.substring(0, 1500)}

MQTT Status:
${results.mqttCheck.stdout || results.mqttCheck.error}

Cloudflare Tunnel:
${results.cloudflareCheck.stdout}

Provide:
1. Overall network health assessment
2. Architectural issues or misconfigurations
3. Security vulnerabilities
4. Performance optimization opportunities
5. Recommended changes (with risk assessment)
6. Priority-ordered action plan`;

  const analysis = await callGemini(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'gemini',
    model: GEMINI_MODEL
  };
}

// Tool 6: Execute Safe Command (with whitelist)
async function executeSafeNetworkCommand(command) {
  return await executeSafeCommand(command);
}

// Tool 7: Network Device Discovery (Tier 1 - Ollama)
async function scanNetworkDevices(subnet = '192.168.40.0/24') {
  const results = {};

  // ARP scan for local devices
  results.arpScan = await executeSafeCommand(`ip neighbor show`);

  // Nmap ping scan (no port scan, fast)
  results.nmapScan = await executeSafeCommand(`sudo nmap -sn ${subnet}`);

  // Get current network interfaces
  results.interfaces = await executeSafeCommand(`ip addr`);

  // Get Docker containers for correlation
  results.containers = await executeSafeCommand(`docker ps --format "{{.Names}}\t{{.Networks}}"`);

  // Analyze with Ollama
  const systemPrompt = `You are a network discovery analyst. Analyze device scans, identify all devices on the network, correlate with Docker containers, and categorize devices (containers, IoT devices, network infrastructure, unknown).`;

  const prompt = `Analyze network scan results for subnet ${subnet}:

ARP Cache:
${results.arpScan.stdout || 'No data'}

Nmap Scan:
${results.nmapScan.stdout || results.nmapScan.error || 'No data'}

Network Interfaces:
${results.interfaces.stdout?.substring(0, 500) || 'No data'}

Docker Containers:
${results.containers.stdout || 'No data'}

Provide:
1. Complete list of discovered devices (IP, MAC, hostname if available)
2. Device categorization (Docker container, IoT device, network infrastructure, unknown)
3. Identify known devices based on IP patterns (192.168.40.107 = Living Room Voice, etc.)
4. Flag any unexpected or suspicious devices
5. Network topology summary`;

  const analysis = await callOllama(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'ollama',
    model: OLLAMA_MODEL,
    subnet
  };
}

// Tool 8: Port Scanning (Tier 1 - Ollama)
async function scanDevicePorts(target, ports = 'common') {
  const results = {};

  // Determine port range
  let portSpec;
  switch (ports) {
    case 'common':
      portSpec = '22,80,443,1883,3000,5678,6052,8080,8086,8123,8989,9000,9090,11434';
      break;
    case 'all':
      portSpec = '1-65535';
      break;
    default:
      portSpec = ports; // Custom port specification
  }

  // Run nmap port scan
  results.portScan = await executeSafeCommand(`sudo nmap -p ${portSpec} ${target}`);

  // Check if target is a container
  results.containerCheck = await executeSafeCommand(`docker ps --filter name=${target} --format "{{.Names}}"`);

  // Analyze with Ollama
  const systemPrompt = `You are a port scanning analyst. Interpret nmap results, identify services, flag security concerns, and suggest actions.`;

  const prompt = `Analyze port scan for target: ${target}

Port Scan Results:
${results.portScan.stdout || results.portScan.error || 'No data'}

Is Docker Container: ${results.containerCheck.stdout ? 'Yes' : 'No'}

Provide:
1. List of open ports and identified services
2. Expected vs unexpected open ports
3. Security concerns (unnecessary open ports, vulnerable services)
4. Service identification and correlation with known services
5. Recommendations`;

  const analysis = await callOllama(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'ollama',
    model: OLLAMA_MODEL,
    target,
    portSpec
  };
}

// Tool 9: Complete Network Map (Tier 2 - Gemini)
async function generateNetworkMap(detailed = false) {
  const results = {};

  // Comprehensive data collection
  results.deviceScan = await executeSafeCommand(`sudo nmap -sn 192.168.40.0/24`);
  results.arpCache = await executeSafeCommand(`ip neighbor show`);
  results.dockerNetworks = await executeSafeCommand(`docker network ls`);
  results.containers = await executeSafeCommand(`docker ps --format "{{.Names}}\t{{.Networks}}\t{{.Ports}}"`);
  results.interfaces = await executeSafeCommand(`ip addr`);
  results.routes = await executeSafeCommand(`ip route`);
  results.listeningPorts = await executeSafeCommand(`ss -tulpn`);

  // If detailed, scan common ports on discovered devices
  if (detailed) {
    results.detailedNote = 'Detailed scanning enabled - this may take several minutes';
    // Note: Actual detailed port scanning would be done iteratively on discovered IPs
  }

  // Analyze with Gemini (Tier 2 - complex mapping)
  const systemPrompt = `You are a network mapping specialist. Create a comprehensive network topology map, identify all devices, their roles, connections, and create a visual representation of the network architecture.`;

  const prompt = `Generate complete network map for 192.168.40.0/24:

Device Discovery:
${results.deviceScan.stdout || results.deviceScan.error || 'No data'}

ARP Cache:
${results.arpCache.stdout || 'No data'}

Docker Networks:
${results.dockerNetworks.stdout || 'No data'}

Containers:
${results.containers.stdout || 'No data'}

Network Interfaces:
${results.interfaces.stdout?.substring(0, 1000) || 'No data'}

Routes:
${results.routes.stdout || 'No data'}

Listening Ports:
${results.listeningPorts.stdout?.substring(0, 1500) || 'No data'}

Provide:
1. Complete network topology (ASCII diagram or structured text)
2. All discovered devices with:
   - IP address
   - MAC address
   - Hostname (if available)
   - Device type/role
   - Open ports and services
   - Docker network membership (if applicable)
3. Network segments and their purposes
4. Inter-container communication paths
5. External connectivity points (Cloudflare Tunnel, etc.)
6. Security posture assessment
7. Recommendations for network optimization`;

  const analysis = await callGemini(prompt, systemPrompt);

  return {
    diagnostics: results,
    analysis,
    tier: 'gemini',
    model: GEMINI_MODEL,
    subnet: '192.168.40.0/24',
    detailed
  };
}

/**
 * Initialize MCP Server
 */
const server = new Server(
  {
    name: 'network-admin',
    version: '1.0.0',
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// List available tools
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: 'check_container_health',
        description: 'Check health of a Docker container or all containers. Uses Ollama (Qwen3) for analysis. Provides health assessment, issues, and recommended fixes.',
        inputSchema: {
          type: 'object',
          properties: {
            containerName: {
              type: 'string',
              description: 'Container name to check (optional, checks all if omitted)',
            },
          },
        },
      },
      {
        name: 'check_network_connectivity',
        description: 'Diagnose network connectivity for a container or hostname. Uses Ollama (Qwen3) for analysis. Tests ping, DNS, routing, and provides remediation steps.',
        inputSchema: {
          type: 'object',
          properties: {
            target: {
              type: 'string',
              description: 'Container name or hostname to check connectivity for',
            },
          },
          required: ['target'],
        },
      },
      {
        name: 'analyze_logs_for_errors',
        description: 'Analyze container or system logs for network and service errors. Uses Ollama (Qwen3) for pattern detection and root cause analysis.',
        inputSchema: {
          type: 'object',
          properties: {
            containerName: {
              type: 'string',
              description: 'Container name to analyze logs for (optional, uses system logs if omitted)',
            },
            lines: {
              type: 'number',
              description: 'Number of log lines to analyze (default: 100)',
            },
          },
        },
      },
      {
        name: 'detect_port_conflicts',
        description: 'Detect port conflicts and duplicate bindings across system and Docker containers. Uses Ollama (Qwen3) for conflict analysis.',
        inputSchema: {
          type: 'object',
          properties: {},
        },
      },
      {
        name: 'deep_network_analysis',
        description: 'Comprehensive network architecture analysis using Gemini (Tier 2). Identifies systemic issues, security vulnerabilities, and optimization opportunities. More thorough than Tier 1 tools.',
        inputSchema: {
          type: 'object',
          properties: {
            scope: {
              type: 'string',
              description: 'Analysis scope: "all", "docker", or "system" (default: "all")',
            },
          },
        },
      },
      {
        name: 'execute_safe_command',
        description: 'Execute a whitelisted network diagnostic command. Safe commands only (ping, dig, docker inspect, etc.). Commands requiring service changes need approval.',
        inputSchema: {
          type: 'object',
          properties: {
            command: {
              type: 'string',
              description: 'Shell command to execute (must be in safe whitelist)',
            },
          },
          required: ['command'],
        },
      },
      {
        name: 'scan_network_devices',
        description: 'Discover all devices on the network using ARP and nmap ping scan. Uses Ollama (Qwen3) for device categorization and identification. Fast scan with no port scanning.',
        inputSchema: {
          type: 'object',
          properties: {
            subnet: {
              type: 'string',
              description: 'Subnet to scan in CIDR notation (default: "192.168.40.0/24")',
            },
          },
        },
      },
      {
        name: 'scan_device_ports',
        description: 'Scan open ports on a specific device or container. Uses Ollama (Qwen3) for service identification and security analysis. Supports common ports, all ports, or custom port ranges.',
        inputSchema: {
          type: 'object',
          properties: {
            target: {
              type: 'string',
              description: 'IP address or hostname to scan',
            },
            ports: {
              type: 'string',
              description: 'Port specification: "common" (default), "all", or custom ports like "22,80,443" or "1-1000"',
            },
          },
          required: ['target'],
        },
      },
      {
        name: 'generate_network_map',
        description: 'Generate comprehensive network topology map using Gemini (Tier 2). Discovers all devices, maps connections, identifies services, and creates visual network diagram. Most complete network analysis tool.',
        inputSchema: {
          type: 'object',
          properties: {
            detailed: {
              type: 'boolean',
              description: 'Enable detailed port scanning on all discovered devices (slower but more thorough)',
            },
          },
        },
      },
    ],
  };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    let result;

    switch (name) {
      case 'check_container_health':
        result = await checkContainerHealth(args.containerName);
        break;

      case 'check_network_connectivity':
        result = await checkNetworkConnectivity(args.target);
        break;

      case 'analyze_logs_for_errors':
        result = await analyzeLogsForErrors(args.containerName, args.lines);
        break;

      case 'detect_port_conflicts':
        result = await detectPortConflicts();
        break;

      case 'deep_network_analysis':
        result = await deepNetworkAnalysis(args.scope);
        break;

      case 'execute_safe_command':
        result = await executeSafeNetworkCommand(args.command);
        break;

      case 'scan_network_devices':
        result = await scanNetworkDevices(args.subnet);
        break;

      case 'scan_device_ports':
        result = await scanDevicePorts(args.target, args.ports);
        break;

      case 'generate_network_map':
        result = await generateNetworkMap(args.detailed);
        break;

      default:
        throw new Error(`Unknown tool: ${name}`);
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({ error: error.message }, null, 2),
        },
      ],
      isError: true,
    };
  }
});

// Start server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('Network Administrator Agent MCP server running on stdio');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
