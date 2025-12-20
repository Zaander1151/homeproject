# Network Administrator Agent - MCP Server

Autonomous network troubleshooting and healing for Docker-based home automation infrastructure.

## Overview

This MCP (Model Context Protocol) server provides network diagnostics and remediation capabilities using a tiered AI approach:

- **Tier 1 (Ollama/Qwen3)**: Routine diagnostics and fixes (local, free, fast)
- **Tier 2 (Gemini)**: Complex architectural analysis (uses Gemini API tokens)
- **Tier 3 (Claude)**: Human-in-the-loop for critical decisions

## Capabilities

### Autonomous Actions (No Approval Required)
- **Network device discovery and mapping** (nmap, ARP)
- **Port scanning with service identification**
- Container connectivity diagnostics (ping, DNS, network inspect)
- Service health monitoring
- Log analysis for network-related errors
- Port conflict detection
- MQTT broker health checks
- Cloudflare Tunnel connectivity monitoring
- Complete network topology generation

### Actions Requiring Approval
- Container restart
- Service restart
- Network topology changes
- Firewall rule modifications
- Container deletion

## Tools

### 1. `check_container_health`
**Tier:** 1 (Ollama)
**Purpose:** Check health of Docker containers

**Parameters:**
- `containerName` (optional): Specific container to check, or all if omitted

**Returns:**
- Health assessment (healthy/degraded/failing/critical)
- Issues identified
- Root cause analysis
- Recommended actions

**Example:**
```javascript
{
  "containerName": "homeassistant"
}
```

### 2. `check_network_connectivity`
**Tier:** 1 (Ollama)
**Purpose:** Diagnose network connectivity for containers or hosts

**Parameters:**
- `target` (required): Container name or hostname

**Returns:**
- Connectivity status
- DNS, ping, routing diagnostics
- Root cause analysis
- Step-by-step remediation

**Example:**
```javascript
{
  "target": "mosquitto"
}
```

### 3. `analyze_logs_for_errors`
**Tier:** 1 (Ollama)
**Purpose:** Analyze logs for network and service errors

**Parameters:**
- `containerName` (optional): Container to analyze, or system logs if omitted
- `lines` (optional): Number of lines to analyze (default: 100)

**Returns:**
- Error patterns with counts
- Severity categorization
- Root causes
- Recommended fixes

**Example:**
```javascript
{
  "containerName": "homeassistant",
  "lines": 200
}
```

### 4. `detect_port_conflicts`
**Tier:** 1 (Ollama)
**Purpose:** Detect port conflicts across system and Docker

**Parameters:** None

**Returns:**
- Port conflicts identified
- Services affected
- Resolution steps

### 5. `deep_network_analysis`
**Tier:** 2 (Gemini)
**Purpose:** Comprehensive network architecture analysis

**Parameters:**
- `scope` (optional): "all", "docker", or "system" (default: "all")

**Returns:**
- Overall network health assessment
- Architectural issues
- Security vulnerabilities
- Performance optimization opportunities
- Priority-ordered action plan

**Example:**
```javascript
{
  "scope": "all"
}
```

### 6. `scan_network_devices`
**Tier:** 1 (Ollama)
**Purpose:** Discover all devices on the network using ARP and nmap

**Parameters:**
- `subnet` (optional): Subnet in CIDR notation (default: "192.168.40.0/24")

**Returns:**
- Complete list of discovered devices
- Device categorization (container, IoT, infrastructure, unknown)
- Known device identification
- Network topology summary

**Example:**
```javascript
{
  "subnet": "192.168.40.0/24"
}
```

### 7. `scan_device_ports`
**Tier:** 1 (Ollama)
**Purpose:** Scan open ports on a specific device

**Parameters:**
- `target` (required): IP address or hostname
- `ports` (optional): "common", "all", or custom like "22,80,443" (default: "common")

**Returns:**
- Open ports and services
- Expected vs unexpected ports
- Security concerns
- Service recommendations

**Example:**
```javascript
{
  "target": "192.168.40.107",
  "ports": "common"
}
```

### 8. `generate_network_map`
**Tier:** 2 (Gemini)
**Purpose:** Generate comprehensive network topology map

**Parameters:**
- `detailed` (optional): Enable detailed port scanning (slower, default: false)

**Returns:**
- Complete network topology diagram
- All devices with full details
- Network segments and purposes
- Inter-container communication paths
- Security posture assessment

**Example:**
```javascript
{
  "detailed": false
}
```

### 9. `execute_safe_command`
**Purpose:** Execute whitelisted network diagnostic commands

**Parameters:**
- `command` (required): Shell command to execute

**Safe Commands:**
- `docker ps`, `docker inspect`, `docker logs`, `docker stats`
- `docker network inspect`, `docker network ls`
- `ping`, `dig`, `nslookup`
- `ss -tulpn`, `ip addr`, `ip route`, `ip neighbor`
- `arp -a`
- `nmap -sn`, `sudo nmap -p`

**Example:**
```javascript
{
  "command": "sudo nmap -sn 192.168.40.0/24"
}
```

## Setup

### 1. Install Dependencies
```bash
cd /home/hazzard/homeproject/mcp-network-admin
npm install
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env and add your GEMINI_API_KEY
```

### 3. Test the Server
```bash
./test.sh
```

### 4. Add to Claude Code MCP Configuration

Add to `.claude/mcp.json`:
```json
{
  "mcpServers": {
    "network-admin": {
      "command": "node",
      "args": ["/home/hazzard/homeproject/mcp-network-admin/server.js"],
      "env": {
        "OLLAMA_BASE_URL": "http://localhost:11434",
        "OLLAMA_MODEL": "qwen3:8b",
        "GEMINI_API_KEY": "your_gemini_api_key_here"
      }
    }
  }
}
```

## Usage Examples

### Network Device Discovery
```
"Scan the network and show all devices"
→ Uses scan_network_devices tool
→ Discovers devices via nmap and ARP
→ Categorizes devices (container, IoT, infrastructure)
→ Identifies known devices
```

### Port Scanning
```
"Scan ports on 192.168.40.107"
→ Uses scan_device_ports tool
→ Scans common ports by default
→ Identifies services
→ Flags security concerns
```

### Complete Network Mapping
```
"Generate a complete network map"
→ Uses generate_network_map tool
→ Analyzes with Gemini (Tier 2)
→ Creates topology diagram
→ Maps all connections and services
```

### Check Container Health
```
"Check the health of the Home Assistant container"
→ Uses check_container_health tool
→ Analyzes with Qwen3 (Tier 1)
→ Provides diagnosis and fixes
```

### Diagnose Network Issues
```
"Why can't the mosquitto container connect to the internet?"
→ Uses check_network_connectivity tool
→ Tests ping, DNS, routing
→ Identifies root cause
→ Suggests remediation steps
```

### Analyze Logs for Errors
```
"Analyze the last 200 lines of homeassistant logs for network errors"
→ Uses analyze_logs_for_errors tool
→ Extracts error patterns
→ Categorizes by severity
→ Recommends fixes
```

### Deep Network Analysis
```
"Perform a comprehensive network security and architecture review"
→ Uses deep_network_analysis tool
→ Analyzes with Gemini (Tier 2)
→ Provides detailed architectural assessment
→ Identifies security vulnerabilities
```

## Token Savings

**Estimated savings:** 60-90% of Claude tokens for routine network troubleshooting

- Network device scan: ~8,000 tokens saved (uses Qwen3)
- Port scanning: ~6,000 tokens saved (uses Qwen3)
- Container health check: ~5,000 tokens saved (uses Qwen3)
- Network diagnostics: ~8,000 tokens saved (uses Qwen3)
- Log analysis: ~12,000 tokens saved (uses Qwen3)
- Complete network map: ~15,000 Claude tokens saved (uses Gemini instead)
- Deep analysis: ~25,000 Claude tokens saved (uses Gemini instead)

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      Claude Code                         │
│              (Orchestration & Critical Decisions)        │
└───────────────────────┬─────────────────────────────────┘
                        │
                        │ MCP Protocol
                        │
┌───────────────────────▼─────────────────────────────────┐
│            Network Administrator Agent                   │
│                                                          │
│  ┌────────────┐  ┌────────────┐  ┌───────────────┐    │
│  │   Tier 1   │  │   Tier 2   │  │  Safe Command │    │
│  │  (Qwen3)   │  │  (Gemini)  │  │   Execution   │    │
│  │  Ollama    │  │   API      │  │  (Whitelist)  │    │
│  └────────────┘  └────────────┘  └───────────────┘    │
└───────────────────────┬─────────────────────────────────┘
                        │
                        │ Docker API / Shell Commands
                        │
┌───────────────────────▼─────────────────────────────────┐
│              Docker Infrastructure                       │
│  (Home Assistant, MQTT, Services, Networks)             │
└─────────────────────────────────────────────────────────┘
```

## Security

### Safe Command Whitelist
Only read-only diagnostic commands are executed autonomously:
- Container inspection and logs
- Network diagnostics (ping, DNS)
- Port and route inspection
- Network device discovery (nmap ping scan, ARP)
- Port scanning with nmap

### Approval Required
Destructive or state-changing commands require human approval:
- Container restart/stop/start
- Service modifications
- Network changes
- Firewall rules

## Troubleshooting

### "Ollama connection failed"
```bash
# Check Ollama is running
docker ps | grep ollama

# Verify model is installed
docker exec ollama ollama list | grep qwen3
```

### "Gemini API error"
```bash
# Verify API key is set
echo $GEMINI_API_KEY

# Check API key is valid at:
# https://aistudio.google.com/app/apikey
```

### "Command not in safe whitelist"
Modify the `SAFE_COMMANDS` array in `server.js` to add additional safe commands.

## Future Enhancements

- [ ] Build knowledge base of past issues and solutions using nomic-embed-text
- [ ] Integrate with Prometheus alerts for proactive monitoring
- [ ] Add Home Assistant automation triggers
- [ ] Implement learning mode for command approval
- [ ] Add Grafana dashboard for agent activity

## Integration Points

- **Prometheus**: Trigger diagnostics on alerts
- **Home Assistant**: Binary sensors for service health
- **n8n**: Complex multi-step remediation workflows
- **Grafana**: Visualize agent actions and health metrics

---

**Version:** 1.0.0
**Last Updated:** 2025-12-03
**Part of:** Home Automation Infrastructure Project
