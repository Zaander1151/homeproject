# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a comprehensive home automation and smart home infrastructure project built on Docker containers. The system integrates IoT devices (primarily ESP32-based), monitoring, AI/automation, media services, and voice assistant capabilities.

**Network:** 192.168.40.0/24
**Timezone:** Canada/Eastern (America/Toronto)
**Main Host:** All services run in Docker containers on a single host machine with NVIDIA GPU support

---

## 🔴 PENDING TASKS FOR NEXT SESSION

### Voice Satellite LED Ring - TROUBLESHOOTING IN PROGRESS

**Status:** Hardware assembled, firmware flashed ✅ | LED test ⚠️ POWER ISSUE - Needs diagnosis

**Current Setup:**
- **Device:** ESP32-S3 DevKit at 192.168.40.180
- **Configuration:** `/home/hazzard/home-assistant/esphome/led-ring-test.yaml` (flashed successfully)
- **LED Ring:** 12x WS2812B NeoPixels on GPIO8
- **Power:** Currently using 5V wall adapter
- **Capacitance:** 1000µF total (multiple capacitors in parallel)

**Problem:**
- ✅ All 12 LEDs light up
- ❌ LEDs are unstable/flickering
- ❌ Blue channel very dim
- ❌ White displays as red/yellow (blue not working properly)
- ❌ Voltage at LED ring measures only **2.2V** (should be 4.8-5.2V)
- ❌ Same 2.2V reading on both USB power AND 5V wall adapter (suggests circuit problem, not just power supply)

**RGB Order Test Results:**
- `GRB` (original): Colors OK, blue dim, white = red
- `RGB`: Red/Green swapped, blue OK, white = red
- `RBG`: Green = green, red = green, blue = red, white = red
- **Conclusion:** Original `GRB` was correct

**What Needs to be Done Next Session:**

1. **Diagnose Why Voltage is Only 2.2V:**

   **Test A: Check for Short Circuit**
   - Power OFF everything
   - Multimeter to Ω (Ohms) mode, 200Ω range
   - Use jumper wires inserted into breadboard rails to test:
     - Red probe → 5V rail (via jumper wire)
     - Black probe → GND rail (via jumper wire)
   - **Expected:** "OL" or very high resistance (no short)
   - **Problem if:** 0-100Ω (short circuit - find and fix)

   **Test B: Measure Wall Adapter Output Directly**
   - Disconnect adapter from circuit
   - Probe USB connector pins or use USB breakout
   - **Expected:** 5.0-5.2V
   - **Problem if:** Less than 4.8V (bad adapter)

   **Test C: Check Capacitor Polarity**
   - Verify all capacitors have:
     - **+ (positive, longer leg)** → Connected to 5V
     - **- (negative, shorter leg, marked stripe)** → Connected to GND
   - If backwards, this could cause the voltage drop

   **Test D: Inspect for Wiring Errors**
   - Verify ESP32-S3 connections:
     - GPIO8 → 470Ω resistor → LED DIN
     - 5V rail → LED ring 5V
     - GND rail → LED ring GND
   - Check for loose breadboard connections
   - Look for accidental bridges between 5V and GND

2. **If Short Circuit Found:**
   - Disconnect components one by one to isolate the problem
   - Check LED ring separately (power it without ESP32)
   - Check capacitors separately

3. **If No Short Found:**
   - LED ring may be internally damaged
   - Try a different NeoPixel strip/ring if available
   - Consider adding a 74AHCT125 level shifter for data line (3.3V → 5V)

4. **Once Fixed:**
   - Re-test colors (should be correct with GRB order)
   - Test Rainbow effect
   - Verify all 12 LEDs work properly
   - Move to Step 3: Test Audio (microphone + speaker)

**Tools Needed:**
- GDT-3190 Multimeter
- Jumper wires for testing breadboard rails
- Possibly replacement LED ring if current one is damaged

**Reference Guide:** `/home/hazzard/homeproject/docs-web/projects/voice-satellite-led-ring.md` (Step 2: Test LED Ring, Troubleshooting section)

---

### Morning Briefing Automation - IN PROGRESS

**Status:** Home Assistant components ✅ COMPLETE | n8n workflow ⚠️ PARTIAL - Needs field mapping fixes

**What's Done:**
- ✅ Home Assistant automations configured (phone unplug trigger 5-9 AM, midnight reset)
- ✅ Input boolean tracking system (`input_boolean.morning_briefing_delivered`)
- ✅ TTS script for Google Nest Audio announcements (`script.announce_morning_briefing`)
- ✅ REST command configured to call n8n webhook
- ✅ Google Nest Audio renamed to "Bedroom Speaker" (entity: `media_player.living_room_speaker`)
- ✅ All workflow files stored in `/mnt/storage/automation/n8n/`

**What Needs to be Done:**
1. **Create Home Assistant Long-Lived Access Token**
   - Navigate to Home Assistant profile (remotely via 192.168.40.201:8123)
   - Generate token for n8n integration

2. **Build n8n Workflow**
   - Location: http://192.168.40.201:5678
   - Import template from `/mnt/storage/automation/n8n/morning-briefing-workflow.json` OR
   - Build manually following `/mnt/storage/automation/n8n/morning-briefing-setup-guide.md`

3. **Configure Workflow Components:**
   - Add Home Assistant authentication (Bearer token)
   - Configure Telegram bot credentials (already exists, just connect)
   - Set up news sources:
     - Sports: NFL, CFL, CPL, NHL (via Gemini Search or RSS)
     - Tech news (via Gemini Search or RSS)
   - Configure Ollama node (model: `llama3.1:8b` or `qwen2.5:7b`)

4. **Test the Complete Flow:**
   ```bash
   curl -X POST http://192.168.40.201:5678/webhook/morning-briefing \
     -H "Content-Type: application/json" \
     -d '{"timestamp": "2025-12-05T09:00:00", "triggered_by": "manual_test"}'
   ```
   - Verify Telegram message received (chat ID: 6299872789)
   - Verify Google Nest Audio announcement plays

5. **Activate the Workflow** in n8n

**Expected Behavior:**
- Trigger: Pixel 10 Pro unplugged between 5:00-9:00 AM (first time only each day)
- Output: 30-second briefing with weather, calendar, sports/tech news, smart home status
- Delivery: Telegram (formatted with emojis) + Google Nest Audio (natural voice)

**Documentation:**
- Quick start: `/mnt/storage/automation/n8n/MORNING-BRIEFING-SUMMARY.md`
- Full guide: `/mnt/storage/automation/n8n/morning-briefing-setup-guide.md`
- System docs: `/home/hazzard/homeproject/docs/morning-briefing-automation.md`

---

> **⚠️ CRITICAL: This is a HEADLESS Linux server with NO GUI or web browser access. NEVER suggest accessing web UIs via localhost URLs (http://localhost:*). The user accesses all web services remotely from other devices on the network using the server's IP address (192.168.40.201). All configuration must be done via CLI, APIs, or configuration files.**

> **💾 CRITICAL FILE STORAGE: Any files that need to be retrieved/downloaded by the user (n8n workflows, exports, backups, etc.) MUST be stored in `/mnt/storage/` directory. This is accessible from the user's other devices. For n8n workflow JSON files specifically, use `/mnt/storage/automation/n8n/`. NEVER store user-retrievable files only in `/home/hazzard/homeproject/` as the user cannot easily access them from their workstation.**

> **📋 Network Reference:** For all network-related tasks, troubleshooting, or device setup, consult [`docs/network-topology.md`](/home/hazzard/homeproject/docs/network-topology.md). This document contains the complete network map, device inventory, agent access patterns, and troubleshooting guides.

> **📋 Home Assistant Entities Reference:** For questions about Home Assistant devices, entities, or available integrations, consult [`docs/home-assistant-entities.md`](/home/hazzard/homeproject/docs/home-assistant-entities.md). This document contains a complete list of all entities available in the Home Assistant instance.

## Project Organization

The infrastructure is organized across multiple directories in `/home/hazzard/`:

- **`/home/hazzard/home-assistant/`** - Core home automation stack (Home Assistant, ESPHome, MQTT, monitoring, voice)
- **`/home/hazzard/media-stack/`** - Media server components (Plex, Sonarr, Radarr, qBittorrent)
- **`/home/hazzard/ollama/`** - AI inference with Ollama (NVIDIA GPU) and Open WebUI
- **`/home/hazzard/n8n/`** - Workflow automation and AI agent platform
- **`/home/hazzard/triposr/`** - 3D model generation from 2D images (TripoSR)
- **`/home/hazzard/cloudflared/`** - Cloudflare Tunnel for secure remote access
- **`/home/hazzard/minecraft-atm10/`** - Minecraft server (ATM10 modpack)
- **`/home/hazzard/dockpeek/`** - Docker monitoring utility
- **`/home/hazzard/homeproject/`** - This directory - for planning, documentation, and ESP32 projects

### Documentation Storage

**Web Documentation (MkDocs):**
- **Primary Location:** `/home/hazzard/homeproject/docs-web/`
- **Served By:** MkDocs Material container (`homeproject-docs`)
- **Access:** http://192.168.40.201:8888
- **Config:** `/home/hazzard/homeproject/mkdocs.yml`

**IMPORTANT: All user-facing documentation should be stored in `docs-web/`**

The `docs-web/` directory is:
- Volume-mapped to the MkDocs container
- Automatically served as web documentation
- The single source of truth for project documentation
- Accessible from any device on the network

**File Organization:**
```
/home/hazzard/homeproject/
├── docs-web/               ← PRIMARY: All documentation here
│   ├── archive/           ← Archived/obsolete docs
│   ├── index.md           ← Homepage
│   ├── CLAUDE.md          ← This file (also in docs-web)
│   ├── esp32-starter-projects.md
│   ├── electronics-workbench-complete-guide.md
│   └── ...
├── docs/                  ← DEPRECATED: Legacy location, avoid using
├── mkdocs.yml             ← Navigation menu configuration
└── ...
```

**Adding New Documentation:**
1. Create `.md` file in `/home/hazzard/homeproject/docs-web/`
2. Add entry to `mkdocs.yml` navigation section
3. Restart container: `docker restart homeproject-docs`
4. View at http://192.168.40.201:8888

**Archiving Documentation:**
- Move obsolete files to `/home/hazzard/homeproject/docs-web/archive/`
- Remove from `mkdocs.yml` navigation
- Files remain accessible but hidden from menu

---

## System Architecture

### Core Services Stack

**Home Automation Hub:**
- **Home Assistant** (port 8123) - Central automation platform
- **ESPHome** (port 6052) - ESP32/ESP8266 firmware builder and OTA updater
- **Mosquitto MQTT** (ports 1883, 9001) - Message broker for IoT devices

**Voice Assistant Pipeline (Wyoming Protocol):**
- **Wyoming Whisper** (port 10300) - Speech-to-text (tiny-int8 model, English)
- **Wyoming Piper** (port 10200) - Text-to-speech (en_US-amy-medium voice)
- **Wyoming OpenWakeWord** (port 10400) - Wake word detection (ok_nabu model)

**Monitoring & Observability:**
- **Prometheus** (port 9090) - Metrics collection and storage (30-day retention)
- **Grafana** (port 3001) - Visualization and dashboards
- **InfluxDB** (port 8086) - Time-series database for sensor data
- **cAdvisor** (port 8081) - Container resource monitoring
- **Node Exporter** (port 9100) - System-level metrics

**AI & Automation:**
- **Ollama** (port 11434) - Local LLM inference with NVIDIA GPU acceleration
- **Open WebUI** (port 3000) - Chat interface for Ollama models
- **n8n** (port 5678) - Workflow automation and AI agent orchestration with PostgreSQL backend
- **TripoSR** (port 8731) - 3D model generation from single 2D images with NVIDIA GPU acceleration
- **MCP Gemini Search** - Model Context Protocol server that provides web search via Gemini API for Claude Code

**Media Services:**
- **Plex** - Media server (network_mode: host)
- **Sonarr** (port 8989) - TV show management
- **Radarr** (port 7878) - Movie management
- **Jackett** (port 9117) - Indexer proxy
- **qBittorrent** (ports 8080, 6881) - Download client

**Infrastructure:**
- **Portainer** (ports 9000, 9443) - Docker management UI
- **Cloudflare Tunnel** - Secure external access without port forwarding
- **Chrony NTP** (port 123 UDP) - Network time synchronization
- **DockPeek** (port 3420) - Container monitoring

### Docker Networks

- **homeassistant-network** - Home automation services
- **media-network** - Media stack isolation
- **n8n_n8n_internal_network** - n8n and PostgreSQL
- **cloudflare-tunnel-network** - Services exposed via Cloudflare (external)
- **ollama_default** - AI services

**Note on Wireless Protocols:** Zigbee is not used in this project. All wireless devices will primarily use Wi-Fi or ESP-NOW.

### ESP32 Devices

**Deployed Devices:**
- **Living Room Voice** (192.168.40.107) - M5Stack Atom Echo voice assistant
- **Office Voice** - M5Stack Atom Echo voice assistant

**Available Hardware:**
- 1 x M5Stack Atom Echo (for additional voice assistant)
- 3 x M5Stack PIR Motion Units (motion detection)
- 1 x M5Stack ENVIV Unit (temperature, humidity, pressure, air quality)
- 5 x ESP32 Development Boards (general purpose)

**Planned Projects:**
- **Motorized Blinds (x3):** Three ESP32-based motorized blind controllers using NEMA 17 stepper motors and TMC2208 drivers for existing beaded chain blinds
- **Motion Sensor Nodes:** PIR-based presence detection using M5Stack PIR units
- **Environmental Monitoring:** Room monitoring with ENVIV sensor (temp, humidity, air quality)

**Hardware Platform:** M5Stack Atom Echo
**Board Configuration:** ESP32 @ 240MHz, ESP-IDF framework
**Audio:** I2S microphone (PDM) and speaker with echo cancellation
**Features:** On-device wake word detection, voice assistant integration, LED status indicators

**ESPHome Location:** `/home/hazzard/home-assistant/esphome/`
**Device Configs:** `living-room-voice.yaml`, `office-voice.yaml`
**Secrets:** `secrets.yaml` (WiFi credentials)

## Hardware Inventory

### 3D Printing Equipment

- **Creality Ender-3 V3** - 3D printer for custom enclosures and mounting brackets
- **Hyper-PAL Filament** (Grey) - General purpose printing
- **Hyper-PETG Filament** - Higher strength applications

### Electronics Tools & Supplies

- **Weller WLSK3012A Soldering Station** - Professional soldering station
- **Electrisol 60/40 Solder** (0.81mm, 113g) - Electronics solder
- **2 x Breadboards** - Prototyping and testing
- **Digital Caliper** (15cm, 0.001" accuracy) - Precision measurements

### M5Stack Hardware

**Voice Assistants:**
- 2 x M5Stack Atom Echo (deployed: Living Room, Office)
- 1 x M5Stack Atom Echo (available for deployment)

**Sensors & Modules:**
- **1 x M5Stack ENVIV Unit** - Environmental sensor (temperature, humidity, pressure, air quality/eCO2/TVOC)
- **3 x M5Stack PIR Motion Unit** - Motion detection sensors

### Smart Plugs

- **4 x TP-Link Tapo Smart Plugs** - Wi-Fi enabled smart outlets
  - Integrated with Home Assistant
  - Coffee machine automation (1 already deployed)
  - 3 available for additional automations

### ESP32 Development Boards

- **5 x ESP32 Development Boards** - General purpose ESP32 boards for custom projects
  - Available for motorized blinds, sensors, and custom automation projects

## Common Commands

### Docker Operations

```bash
# View all running containers
docker ps -a

# View container logs
docker logs -f <container_name>

# Restart a service
docker restart <container_name>

# View resource usage
docker stats

# Access Portainer for GUI management
open http://localhost:9000
```

### Service-Specific Commands

**Home Assistant:**
```bash
cd /home/hazzard/home-assistant
docker-compose up -d                    # Start all services
docker-compose restart homeassistant    # Restart Home Assistant
docker-compose logs -f homeassistant    # View logs
docker exec -it homeassistant bash      # Access container shell
```

**ESPHome:**
```bash
cd /home/hazzard/home-assistant/esphome
# ESPHome CLI commands run via docker:
docker exec -it esphome esphome compile living-room-voice.yaml
docker exec -it esphome esphome upload living-room-voice.yaml
docker exec -it esphome esphome logs living-room-voice.yaml

# Web interface (preferred method):
open http://localhost:6052
```

**Ollama:**
```bash
cd /home/hazzard/ollama
docker exec -it ollama ollama list              # List installed models
docker exec -it ollama ollama pull <model>      # Download model
docker exec -it ollama ollama run <model>       # Run model interactively
```

**n8n:**
```bash
cd /home/hazzard/n8n
docker-compose up -d
docker-compose logs -f n8n
# Access web UI: http://localhost:5678
```

**Media Stack:**
```bash
cd /home/hazzard/media-stack
docker-compose up -d
docker-compose restart <service>
```

**Prometheus/Grafana:**
```bash
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3001 (admin/admin)

# Reload Prometheus config without restart:
docker exec prometheus kill -HUP 1
```

### Monitoring Commands

```bash
# View system metrics
curl http://localhost:9100/metrics      # Node Exporter
curl http://localhost:8081/metrics      # cAdvisor

# Check MQTT broker
docker exec -it mosquitto mosquitto_sub -h localhost -t '#' -v

# Monitor InfluxDB
docker exec -it influxdb influx
```

### Network Troubleshooting

> **📋 See [`docs/network-topology.md`](/home/hazzard/homeproject/docs/network-topology.md) for comprehensive network reference, device access patterns, and troubleshooting guides.**

```bash
# Scan network for all devices
sudo nmap -sn 192.168.40.0/24

# Inspect network
docker network inspect homeassistant-network
docker network inspect cloudflare-tunnel-network

# Check DNS resolution between containers
docker exec <container> ping <other_container>
docker exec <container> nslookup <service_name>

# Test ESP32 connectivity
ping 192.168.40.107  # Living Room Voice
ping 192.168.40.108  # Office Voice
```

## Architecture Notes

### MQTT Integration

All IoT devices communicate via MQTT broker (Mosquitto). ESPHome devices automatically integrate with Home Assistant via the native API, but can also publish to MQTT topics for advanced automation.

### Voice Assistant Flow

1. ESP32 device detects wake word (on-device or via Wyoming OpenWakeWord)
2. Audio captured and sent to Home Assistant
3. HA forwards to Wyoming Whisper for speech-to-text
4. HA processes intent/command
5. Response sent to Wyoming Piper for text-to-speech
6. Audio played on ESP32 speaker

### AI Infrastructure

- **Ollama** provides local LLM inference using NVIDIA GPU
- **Open WebUI** offers ChatGPT-like interface for Ollama models
- **n8n** connects to Ollama for workflow automation and AI agents
- All three services share the `cloudflare-tunnel-network` for inter-communication

### MCP (Model Context Protocol) Agents

Claude Code uses multiple MCP agents to enhance capabilities and optimize token usage. All agents are automatically loaded via `.claude/mcp.json` configuration.

**Architecture Strategy:**
- **Tier 1 (Ollama):** Simple tasks using local models (free, private, fast)
- **Tier 2 (Gemini):** Complex tasks using Gemini API (uses Gemini tokens instead of Claude)
- **Token Savings:** 500k-800k Claude tokens/month for typical usage

**CRITICAL USAGE RULE:**
- **Network/Port Questions:** ALWAYS consult [`docs/network-topology.md`](/home/hazzard/homeproject/docs/network-topology.md) which contains the complete Port Mapping Summary. Read the file directly instead of guessing port numbers or making assumptions.
- **Network Troubleshooting:** The network-admin MCP agent can autonomously handle device discovery, port scanning, and connectivity diagnostics.
- **When in doubt:** Check network-topology.md first, use MCP agents second, never assume defaults.

---

#### 1. Gemini Search Agent

Web search using Google's Gemini API with Google Search grounding.

**Location:** `/home/hazzard/homeproject/mcp-gemini-search/`

**Tools:**
- `gemini_web_search` - Web search with source citations

**Use Cases:**
- Real-time information lookup
- Documentation searches
- Technology research

**Testing:**
```bash
cd /home/hazzard/homeproject/mcp-gemini-search
./test.sh
```

---

#### 2. Code Analyzer Agent

Code review and analysis with tiered complexity handling.

**Location:** `/home/hazzard/homeproject/mcp-task-delegation/code-analyzer/`

**Tools:**
- `analyze_code_simple` - Quick checks (Ollama `qwen3:8b`)
- `analyze_code_deep` - Security/architecture analysis (Gemini)
- `review_diff` - Git diff review (Ollama `qwen3:8b`)

**Use Cases:**
- PR reviews: Saves ~12,000 Claude tokens per review
- Security audits: Deep analysis without burning Claude tokens
- Code quality checks

---

#### 3. File Summarizer Agent

File and log processing for information extraction.

**Location:** `/home/hazzard/homeproject/mcp-task-delegation/file-summarizer/`

**Tools:**
- `summarize_file` - Extract key info (Ollama `qwen3:8b`)
- `analyze_logs` - Error patterns and debugging (Ollama `qwen3:8b`)
- `extract_structure` - Config/schema analysis (Ollama `qwen3:8b`)

**Use Cases:**
- Log analysis: Saves ~55,000 Claude tokens for large log files
- Configuration file inspection
- Error pattern detection

---

#### 4. Documentation Generator Agent

Documentation creation using Gemini for high-quality output.

**Location:** `/home/hazzard/homeproject/mcp-task-delegation/doc-generator/`

**Tools:**
- `generate_readme` - Project README (Gemini)
- `generate_docstring` - Function documentation (Gemini)
- `explain_code` - Code explanations (Gemini)

**Use Cases:**
- Documentation: Saves ~32,000 Claude tokens (uses Gemini instead)
- API documentation
- Code explanations

---

#### 5. Network Administrator Agent

Network troubleshooting, monitoring, and security analysis.

**Location:** `/home/hazzard/homeproject/mcp-network-admin/`

**Tools:**
- `check_container_health` - Docker container diagnostics (Ollama)
- `check_network_connectivity` - Ping/DNS/routing tests (Ollama)
- `analyze_logs_for_errors` - Network error pattern detection (Ollama)
- `detect_port_conflicts` - Port conflict analysis (Ollama)
- `scan_network_devices` - Device discovery via nmap/ARP (Ollama)
- `scan_device_ports` - Port scanning with service identification (Ollama)
- `deep_network_analysis` - Comprehensive architecture analysis (Gemini)
- `generate_network_map` - Complete topology mapping (Gemini)
- `execute_safe_command` - Whitelisted network diagnostics

**Use Cases:**
- Network device discovery and mapping
- Container connectivity troubleshooting
- Port conflict detection
- Security vulnerability scanning
- Autonomous network health monitoring
- Service uptime checks

**Example Usage:**
```
"Scan the network and show all devices"
"Check if Home Assistant container is healthy"
"Generate a complete network map"
"Scan ports on 192.168.40.107"
```

---

### MCP Agent Configuration

**Models Used:**
- **Ollama (Local):** `qwen3:8b` - Simple tasks (free, 5.2GB VRAM)
- **Gemini (API):** `gemini-2.0-flash-exp` - Complex tasks

**Setup All Agents:**
```bash
cd /home/hazzard/homeproject/mcp-task-delegation
./setup.sh
# Restart Claude Code to load all MCP servers
```

**Testing:**
```bash
# Task delegation agents
./test-code-analyzer.sh
./test-file-summarizer.sh
./test-doc-generator.sh

# Search agent
cd ../mcp-gemini-search && ./test.sh
```

**Natural Usage:**
Claude automatically chooses the right agent:
- "Review this code for bugs" → code-analyzer
- "Analyze these Docker logs" → file-summarizer
- "Generate a README" → doc-generator
- "Search for X documentation" → gemini-search
- "Scan the network" → network-admin

**Documentation:**
- Task Delegation: `/home/hazzard/homeproject/mcp-task-delegation/USAGE_GUIDE.md`
- Network Admin: `/home/hazzard/homeproject/mcp-network-admin/server.js` (inline docs)

### Smart Plug Automations

**Coffee Machine Automation:**
- **Drip Coffee Machine:** A "dumb" drip coffee machine with a mechanical toggle switch
- **Smart Plug:** Plugged into a TP-Link Tapo smart plug, integrated with Home Assistant
- **Automation:** Scheduled turn-on at wake-up time or voice-activated triggers

**Additional Smart Plugs:**
- **3 x TP-Link Tapo Smart Plugs** available for additional automations
  - Fans, heaters, lights, or other dumb appliances
  - Power monitoring and scheduling capabilities
  - Voice control via Home Assistant integration

### Cloudflare Tunnel Architecture

Services attached to `cloudflare-tunnel-network`:
- Home Assistant
- Ollama
- n8n

These services are accessible externally via Cloudflare Tunnel without exposing ports directly to the internet.

### Data Persistence

**Volumes:**
- Home automation config: `./home-assistant/config`
- ESPHome devices: `./home-assistant/esphome`
- MQTT data: `./home-assistant/mosquitto/data`
- Metrics: `prometheus-data` volume (30-day retention)
- Grafana dashboards: `./home-assistant/grafana-data`
- InfluxDB: `./home-assistant/influxdb-data`
- Ollama models: `ollama` volume
- n8n workflows: `n8n_data` and `postgres_data` volumes
- Media storage: `/mnt/fileserver` (network share)

### GPU Acceleration

The Ollama container uses NVIDIA GPU via Docker runtime:
```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: all
          capabilities: [gpu]
```

## ESP32 Development

### Setting Up New ESP32 Devices

1. Create YAML config in `/home/hazzard/home-assistant/esphome/`
2. Use existing device configs as templates
3. Define static IP in the 192.168.40.0/24 range
4. Configure WiFi credentials using `!secret` references
5. Compile and flash via ESPHome web UI (http://localhost:6052)

### M5Stack Atom Voice Assistant Template

Reference: `living-room-voice.yaml` and `office-voice.yaml`

Key components:
- **I2S Audio** (pins: LRCLK=GPIO33, BCLK=GPIO19, DIN=GPIO23, DOUT=GPIO22)
- **LED Strip** (GPIO27, SK6812, 1 LED)
- **Button** (GPIO39, inverted, with multi-click support)
- **Voice Assistant** with micro wake word support
- **OTA Updates** with password protection
- **API Encryption** for Home Assistant integration

### Common ESP32 Patterns

**Static IP Configuration:**
```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.XXX
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8
```

**OTA and API Security:**
```yaml
api:
  encryption:
    key: "<auto-generated>"

ota:
  - platform: esphome
    password: "<set-password>"
```

## File Share Access

Media and recordings are stored on network share mounted at `/mnt/fileserver`:
- `/mnt/fileserver/movies` - Movie library
- `/mnt/fileserver/tv` - TV show library
- `/mnt/fileserver/downloads` - Download destination

Home Assistant recordings: `./home-assistant/recordings/`

## Security Considerations

- All services run in isolated Docker networks
- External access only via Cloudflare Tunnel (no direct port exposure)
- ESP32 devices use encrypted API communication
- MQTT broker requires configuration review before production use
- Secrets stored in `.env` files and ESPHome `secrets.yaml`
- Grafana default credentials should be changed (current: admin/admin)
