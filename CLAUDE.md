# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a comprehensive home automation and smart home infrastructure project built on Docker containers. The system integrates IoT devices (primarily ESP32-based), monitoring, AI/automation, media services, and voice assistant capabilities.

**Network:** 192.168.40.0/24
**Timezone:** Canada/Eastern (America/Toronto)
**Main Host:** All services run in Docker containers on a single host machine with NVIDIA GPU support

## Project Organization

The infrastructure is organized across multiple directories in `/home/hazzard/`:

- **`/home/hazzard/home-assistant/`** - Core home automation stack (Home Assistant, ESPHome, MQTT, monitoring, voice)
- **`/home/hazzard/media-stack/`** - Media server components (Plex, Sonarr, Radarr, qBittorrent)
- **`/home/hazzard/ollama/`** - AI inference with Ollama (NVIDIA GPU) and Open WebUI
- **`/home/hazzard/n8n/`** - Workflow automation and AI agent platform
- **`/home/hazzard/cloudflared/`** - Cloudflare Tunnel for secure remote access
- **`/home/hazzard/minecraft-atm10/`** - Minecraft server (ATM10 modpack)
- **`/home/hazzard/dockpeek/`** - Docker monitoring utility
- **`/home/hazzard/homeproject/`** - This directory - for planning, documentation, and ESP32 projects

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

### ESP32 Devices

**Current Devices:**
- **Living Room Voice** (192.168.40.107) - M5Stack Atom voice assistant
- **Office Voice** - M5Stack Atom voice assistant

**Hardware Platform:** M5Stack Atom
**Board Configuration:** ESP32 @ 240MHz, ESP-IDF framework
**Audio:** I2S microphone (PDM) and speaker with echo cancellation
**Features:** On-device wake word detection, voice assistant integration, LED status indicators

**ESPHome Location:** `/home/hazzard/home-assistant/esphome/`
**Device Configs:** `living-room-voice.yaml`, `office-voice.yaml`
**Secrets:** `secrets.yaml` (WiFi credentials)

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

```bash
# Inspect network
docker network inspect homeassistant-network
docker network inspect cloudflare-tunnel-network

# Check DNS resolution between containers
docker exec <container> ping <other_container>
docker exec <container> nslookup <service_name>
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
