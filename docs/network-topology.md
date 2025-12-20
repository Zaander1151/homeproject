# Network Topology & Configuration

**Scanned on:** 2025-12-03
**Primary Network:** 192.168.40.0/24

> **📋 Reference Document:** This file should be consulted for all network troubleshooting, device setup, and automation tasks. It contains the complete network topology and agent access patterns.

## Network Overview

### Physical Network

**Interface:** enp4s0 (Ethernet)
**Host IP:** 192.168.40.201/24
**Gateway:** 192.168.40.1 (84:4d:4c:17:0f:d1)
**DNS Servers:** 8.8.8.8 (Google), 4.4.4.4
**ISP Domain:** cgocable.net

### Internet Connection
- **Provider:** Cogeco Cable
- **Type:** Cable Internet
- **IPv6:** Enabled (2001:1970:3c5a:4200::/64)

---

## Network Devices

### Infrastructure

| Device | IP Address | MAC Address | Role | Notes |
|--------|-----------|-------------|------|-------|
| **Router/Gateway** | 192.168.40.1 | 84:4d:4c:17:0f:d1 | Network gateway | ISP router |
| **Office Network Switch** | 192.168.40.20 | 30:68:93:24:d4:e5 | Network switch | North wall of office |
| **NAS/File Server** | 192.168.40.200 | 74:d4:35:9b:01:8f | Storage | CIFS/SMB share at /mnt/fileserver |
| **Docker Host** | 192.168.40.201 | 10:ff:e0:cb:7a:c2 | Main server | This machine (all Docker containers) |
| **Creality Slicer Server** | 192.168.40.202 | 00:0c:d6:17:8a:08 | 3D printing server | STL gateway for Creality Ender-3 V3, electronics testing |

### Computers & Workstations

| Device | IP Address | MAC Address | Specs/Type | Notes |
|--------|-----------|-------------|-----------|-------|
| **Main Computer** | 192.168.40.13 | 10:ff:e0:ca:b2:8c | Ryzen R7, 32GB RAM, 2TB M.2, NVIDIA 5060 | Primary workstation |
| **Dell PC** | 192.168.40.226 | e4:b9:7a:f6:c3:05 | Dell (Windows) | File sharing enabled |

### Smart Home Devices

| Device | IP Address | MAC Address | Type | Location/Notes |
|--------|-----------|-------------|------|---------------|
| **Living Room Voice** | 192.168.40.120 | f4:65:0b:01:cf:84 | ESP32 (M5Stack Atom) | Voice assistant - ONLINE |
| **Office Voice** | 192.168.40.121 | 00:4b:12:a1:1a:74 | ESP32 (M5Stack Atom) | Voice assistant - ONLINE |
| **Ecobee Thermostat** | 192.168.40.104 | 44:61:32:8a:99:74 | Smart thermostat | Climate control |
| **TP-Link Smart Plug #1** | 192.168.40.110 | 3c:52:a1:ed:2b:e7 | Tapo WiFi smart plug | Bedroom fan control |
| **TP-Link Smart Plug #2** | 192.168.40.111 | 98:ba:5f:c8:2e:0b | Tapo WiFi smart plug | Coffee machine |
| **TP-Link Smart Plug #3** | 192.168.40.112 | TBD | Tapo WiFi smart plug | Glue gun |
| **TP-Link Smart Plug #4** | 192.168.40.113 | TBD | Tapo WiFi smart plug | Creality Ender3 V3 |
| **Google Nest Hub** | 192.168.40.100 | 38:86:f7:11:0f:17 | Smart display | Kitchen display |
| **Google Nest Audio** | 192.168.40.102 | 38:86:f7:9c:bf:4a | Smart speaker | Bedroom speaker |
| **Samsung Smart Range** | 192.168.40.105 | 28:6b:b4:12:0d:16 | Smart kitchen appliance | Kitchen - SmartThings compatible |
| **Samsung Smart Refrigerator** | 192.168.40.106 | 28:6b:b4:1a:df:ac | Smart kitchen appliance | Kitchen - SmartThings compatible |

### Entertainment & Media Devices

| Device | IP Address | MAC Address | Type | Notes |
|--------|-----------|-------------|------|-------|
| **Living Room Roku TV** | 192.168.40.99 | 34:93:42:73:ed:46 | Smart TV (Wired) | Main TV |
| **Living Room Chromecast** | 192.168.40.101 | dc:e5:5b:9b:96:68 | Streaming device | Connected to Roku TV HDMI1 |

### Mobile Devices

| Device | IP Address | MAC Address | Type | Notes |
|--------|-----------|-------------|------|-------|
| **Google Pixel 10 Pro** | 192.168.40.250 | b6:84:b9:70:46:33 | Android phone | Main phone |

### Integration Notes

**Google Home Ecosystem:**
- 3 Google devices (Nest Hub, Nest Audio, Chromecast) can be integrated with Home Assistant
- Consider adding Google Assistant integration to HA for unified control

**Smart Home Hubs:**
- Ecobee thermostat integrates directly with Home Assistant
- TP-Link smart plug can be controlled via TP-Link Kasa integration
- ESP32 voice assistants already integrated via ESPHome

**Future ESP32 Projects:**
- IPs .122-.139 available for new ESP32 devices (18 available)
- Current ESP32 devices: .120 (living room), .121 (office)

---

## Docker Network Architecture

### Network Bridges

| Network Name | Bridge | Subnet | Gateway | Purpose |
|-------------|--------|--------|---------|---------|
| **homeassistant-network** | br-6c2ba96c8bfc | 172.19.0.0/16 | 172.19.0.1 | Home automation stack |
| **cloudflare-tunnel-network** | br-fb2cd4e8c189 | 192.168.64.0/20 | 192.168.64.1 | External access via Cloudflare |
| **media-network** | br-e4c9f047b8d1 | 172.18.0.0/16 | 172.18.0.1 | Media server stack (expanded) |
| **n8n_n8n_internal_network** | br-edc195903e7a | 172.23.0.0/16 | 172.23.0.1 | n8n + PostgreSQL |
| **ollama_default** | br-65372da799dc | 172.20.0.0/16 | 172.20.0.1 | Ollama + Open WebUI |
| **triposr_default** | br-40c950fd4b9a | 172.21.0.0/16 | 172.21.0.1 | 3D model generation |
| **dockpeek_default** | br-c65da9c026e0 | 172.28.0.0/16 | 172.28.0.1 | DockPeek monitoring |
| **i2p_default** | br-48cc2e4b9a53 | 172.24.0.0/16 | 172.24.0.1 | I2P router |
| **component-inventory_component-net** | br-ad1302c4db3c | 172.22.0.0/16 | 172.22.0.1 | Component inventory |
| **homeproject-docs-network** | br-19024b76ead3 | 172.25.0.0/16 | 172.25.0.1 | Documentation site |
| **default (docker0)** | docker0 | 172.17.0.0/16 | 172.17.0.1 | Default bridge |
| **host** | host | N/A | N/A | Direct host network (Plex, ATM10) |

### Container Network Assignments

#### homeassistant-network (172.19.0.0/16)

| Container | IP | Ports | Notes |
|-----------|-----|-------|-------|
| wyoming_whisper | 172.19.0.2 | 10300 | Speech-to-text |
| node_exporter | 172.19.0.3 | 9100 | System metrics |
| mosquitto | 172.19.0.4 | 1883, 9001 | MQTT broker |
| prometheus | 172.19.0.5 | 9090 | Metrics collection |
| wyoming_piper | 172.19.0.6 | 10200 | Text-to-speech |
| influxdb | 172.19.0.7 | 8086 | Time-series database |
| esphome | 172.19.0.8 | 6052 | ESP32 firmware builder |
| cadvisor | 172.19.0.9 | 8081 | Container metrics |
| wyoming_openwakeword | 172.19.0.10 | 10400 | Wake word detection |
| grafana | 172.19.0.11 | 3001 | Visualization |
| homeassistant | 172.19.0.12 | 8123 | Central hub |

#### cloudflare-tunnel-network (192.168.64.0/20)

| Container | IP | External Access | Notes |
|-----------|-----|-----------------|-------|
| homeassistant | 192.168.64.2 | ✓ | Via Cloudflare Tunnel |
| n8n_ai_agent | 192.168.64.3 | ✓ | Workflow automation |
| ollama | 192.168.64.4 | ✓ | AI inference |

**Note:** Containers on this network are accessible externally via Cloudflare Tunnel without exposing ports directly.

---

## Agent Access Patterns

This section documents how MCP agents, automation systems, and services can access and interact with network devices. **Reference this when troubleshooting connectivity or setting up automations.**

### Docker Container to Physical Device Access

**Path:** Docker Container → Docker Host (192.168.40.201) → Physical Network (192.168.40.0/24)

**Key Point:** Docker containers can reach physical network devices by using the host's IP range (192.168.40.x).

**Examples:**

```yaml
# ESPHome accessing ESP32 devices
esphome:
  - Can reach 192.168.40.120 (Living Room Voice) directly
  - Can reach 192.168.40.121 (Office Voice) directly
  - No special routing needed

# Home Assistant accessing MQTT devices
homeassistant:
  - Connects to mosquitto container via homeassistant-network (172.19.0.4)
  - ESP32 devices connect to mosquitto via 192.168.40.201:1883
  - Two-way communication works seamlessly
```

### ESP32 Device → Docker Service Communication

**Path:** ESP32 Device → Host IP (192.168.40.201) → Docker Container

ESP32 devices reach Docker services using the host's public IP (192.168.40.201) and mapped ports:

| Service | Container Network | Physical Access Point | Use Case |
|---------|------------------|----------------------|----------|
| **Home Assistant API** | 172.19.0.12 | 192.168.40.201:8123 | ESP32 device registration |
| **ESPHome Dashboard** | 172.19.0.8 | 192.168.40.201:6052 | OTA firmware updates |
| **MQTT Broker** | 172.19.0.4 | 192.168.40.201:1883 | IoT message bus |
| **Wyoming Whisper** | 172.19.0.2 | 172.19.0.2:10300 | Speech-to-text (HA network only) |
| **Wyoming Piper** | 172.19.0.6 | 172.19.0.6:10200 | Text-to-speech (HA network only) |
| **Wyoming OpenWakeWord** | 172.19.0.10 | 172.19.0.10:10400 | Wake word detection (HA network only) |

**Example ESPHome Config:**
```yaml
api:
  # ESP32 connects to Home Assistant via host IP
  encryption:
    key: "..."
  # Connection: 192.168.40.120 → 192.168.40.201:8123 → homeassistant container

mqtt:
  broker: 192.168.40.201  # Host IP, not container IP
  port: 1883
```

### MCP Agent Network Access

**Network Administrator Agent** can access:
- ✅ **Docker containers** - Via docker commands and network inspection
- ✅ **Physical network devices** - Via nmap, ping, SSH from host
- ✅ **Container-to-container** - Via docker exec and network troubleshooting
- ✅ **Host system** - Full access to host network stack

**Access Methods:**

```bash
# Scan physical network devices
sudo nmap -sn 192.168.40.0/24

# Check container health
docker ps -a
docker inspect homeassistant

# Test connectivity from container
docker exec homeassistant ping 192.168.40.107

# Check container logs
docker logs -f esphome
```

### Home Assistant → Device Integration Paths

**Home Assistant Integration Types:**

1. **Native API** (ESP32 devices):
   - ESPHome devices auto-discover via mDNS
   - Direct communication: HA ↔ ESP32 via API port

2. **MQTT** (IoT devices):
   - Device → MQTT Broker (192.168.40.201:1883)
   - HA subscribes to MQTT topics
   - Bi-directional messaging

3. **HTTP/REST** (Smart plugs, cameras):
   - HA → Device IP (e.g., 192.168.40.110 for Tapo plug)
   - Local API calls, no cloud dependency

4. **Cloud Integration** (Google Home, Ecobee):
   - HA ↔ Cloud API ↔ Device
   - Requires internet connection

### n8n Workflow Access Patterns

**n8n** (192.168.64.3 on cloudflare-tunnel-network) can access:

| Target | Access Method | Example |
|--------|--------------|---------|
| **Home Assistant** | Direct container-to-container | `http://homeassistant:8123` |
| **Ollama** | Via cloudflare-tunnel-network | `http://ollama:11434` |
| **Physical devices** | Via host IP | `http://192.168.40.107` |
| **External APIs** | Via internet | Gemini, external services |
| **MQTT** | Via mosquitto container | `mqtt://192.168.40.201:1883` |

**Example n8n Workflow:**
```javascript
// Trigger: MQTT message from ESP32
mqtt.subscribe('sensor/living-room/temperature');

// Process: Call Ollama for analysis
ollama.generate('qwen3:8b', prompt);

// Action: Update Home Assistant entity
homeassistant.callService('climate.set_temperature', {...});
```

### Cloudflare Tunnel Access

**External → Cloudflare → Container:**

```
User Device (Internet)
    ↓
Cloudflare Edge Server (encrypted)
    ↓
cloudflared container (192.168.40.201)
    ↓
cloudflare-tunnel-network (192.168.64.0/20)
    ↓
Target container (homeassistant, n8n, ollama)
```

**Accessible Services:**
- Home Assistant: Via Cloudflare subdomain
- n8n: Via Cloudflare subdomain
- Ollama: Via Cloudflare subdomain

**Security:** All traffic encrypted end-to-end, no inbound firewall rules needed.

### Inter-Container Communication Summary

**Same Network:**
- Use container name as hostname
- Example: `http://homeassistant:8123` from grafana

**Different Networks:**
- Attach container to both networks, OR
- Use host IP with port mapping

**Container → Physical Network:**
- Always use host IP (192.168.40.201) or device IP (192.168.40.x)
- Ensure port is mapped: `0.0.0.0:PORT->PORT`

### Troubleshooting Access Issues

**Problem: ESP32 can't reach Home Assistant**
```bash
# From ESP32 perspective, it should connect to:
192.168.40.201:8123

# Verify port is open on host:
ss -tlnp | grep 8123

# Test from another physical device:
curl http://192.168.40.201:8123

# Check ESP32 device connectivity:
ping 192.168.40.120  # Living Room Voice
ping 192.168.40.121  # Office Voice
```

**Problem: Container can't reach MQTT**
```bash
# Check if mosquitto is on the same network
docker network inspect homeassistant-network

# Test from container
docker exec homeassistant ping mosquitto
docker exec homeassistant nc -zv mosquitto 1883
```

**Problem: n8n can't reach Ollama**
```bash
# Verify both are on cloudflare-tunnel-network
docker inspect n8n_ai_agent | grep Networks
docker inspect ollama | grep Networks

# Test connection
docker exec n8n_ai_agent curl http://ollama:11434/api/version
```

**Problem: MCP agent can't scan network**
```bash
# Verify nmap is installed
which nmap

# Test scan manually
sudo nmap -sn 192.168.40.0/24

# Check MCP agent has sudo access for nmap
```

---

#### media-network (172.18.0.0/16)

| Container | IP | Ports | Notes |
|-----------|-----|-------|-------|
| radarr | 172.18.0.2 | 7878 | Movie management |
| jackett | 172.18.0.3 | 9117 | Indexer proxy |
| qbittorrent | 172.18.0.4 | 8080, 6881 | Download client |
| sonarr | 172.18.0.5 | 8989 | TV management |

**Note:** Plex uses `network_mode: host` and is not on this bridge.

---

## Port Mapping Summary

### Externally Accessible Services (0.0.0.0)

| Port | Service | Container | Protocol | Access |
|------|---------|-----------|----------|--------|
| **1883** | MQTT | mosquitto | TCP | Local network |
| **3000** | Open WebUI | open-webui | HTTP | Local network |
| **3001** | Grafana | grafana | HTTP | Local network |
| **5678** | n8n | n8n_ai_agent | HTTP | Local network + Cloudflare |
| **6052** | ESPHome | esphome | HTTP | Local network |
| **6881** | BitTorrent | qbittorrent | TCP/UDP | Internet |
| **7878** | Radarr | radarr | HTTP | Local network |
| **8080** | qBittorrent | qbittorrent | HTTP | Local network |
| **8081** | cAdvisor | cadvisor | HTTP | Local network |
| **8086** | InfluxDB | influxdb | HTTP | Local network |
| **8123** | Home Assistant | homeassistant | HTTP | Local network + Cloudflare |
| **8888** | MkDocs Documentation | homeproject-docs | HTTP | Local network |
| **8989** | Sonarr | sonarr | HTTP | Local network |
| **9000** | Portainer | portainer | HTTP | Local network |
| **9001** | MQTT WebSocket | mosquitto | WebSocket | Local network |
| **9090** | Prometheus | prometheus | HTTP | Local network |
| **9100** | Node Exporter | node_exporter | HTTP | Local network |
| **9117** | Jackett | jackett | HTTP | Local network |
| **9443** | Portainer SSL | portainer | HTTPS | Local network |
| **10200** | Wyoming Piper | wyoming_piper | TCP | Local network |
| **10300** | Wyoming Whisper | wyoming_whisper | TCP | Local network |
| **10400** | Wyoming OpenWakeWord | wyoming_openwakeword | TCP | Local network |
| **11434** | Ollama | ollama | HTTP | Local network + Cloudflare |
| **123** | NTP | chrony-ntp | UDP | Local network |

### Host Network Mode Services

| Service | Container | Ports | Notes |
|---------|-----------|-------|-------|
| **Plex** | plex | 32400, others | Direct host network access |

---

## DNS Configuration

**Primary DNS:** 8.8.8.8 (Google Public DNS)
**Backup DNS:** 4.4.4.4 (Level 3)
**IPv6 DNS:** 2001:18c0:ffe0:28::1, 2001:1970:c06e:c0::93
**Search Domain:** cgocable.net

**Resolver:** systemd-resolved (stub mode)
**Local Stub:** 127.0.0.53

### Container DNS
Most containers use Docker's embedded DNS server (127.0.0.11) which forwards to host DNS.

---

## File Shares & Storage

### Network Storage

**NAS Share:**
- **Host:** 192.168.40.200
- **Share:** //192.168.40.200/media-share
- **Mount Point:** /mnt/fileserver
- **Protocol:** CIFS (SMB v3.0)
- **Username:** hazzard
- **Mount Type:** autofs (auto-mount on access)

**Mounted Directories:**
- `/mnt/fileserver/movies` - Plex movie library
- `/mnt/fileserver/tv` - Plex TV library
- `/mnt/fileserver/downloads` - qBittorrent destination

### Local Storage

**Docker Volumes:**
- `ollama_ollama` - Ollama models
- `ollama_open-webui` - Open WebUI data
- `n8n_data` - n8n workflows
- `n8n_postgres_data` - PostgreSQL database
- `home-assistant_prometheus-data` - Prometheus metrics (30-day retention)

**Bind Mounts:**
- `/home/hazzard/home-assistant/config` → Home Assistant config
- `/home/hazzard/home-assistant/esphome` → ESPHome device configs
- `/home/hazzard/home-assistant/mosquitto` → MQTT data
- `/home/hazzard/home-assistant/grafana-data` → Grafana dashboards
- `/home/hazzard/home-assistant/influxdb-data` → InfluxDB time-series
- `/home/hazzard/n8n/local-files` → n8n file access

---

## Cloudflare Tunnel Configuration

**Container:** cloudflared
**Network Mode:** bridge (default)
**Token:** (Stored in docker-compose.yml)

**Extra Hosts:**
- `homeassistant:192.168.40.201` - Allows Cloudflare to reach Home Assistant by hostname

**Services Exposed via Tunnel:**
- Home Assistant (via cloudflare-tunnel-network)
- n8n (via cloudflare-tunnel-network)
- Ollama (via cloudflare-tunnel-network)

**Security:** All traffic encrypted via Cloudflare Tunnel, no inbound ports exposed on WAN.

---

## Security Considerations

### Current Security Posture

✅ **Strengths:**
- Cloudflare Tunnel for external access (no port forwarding)
- Services isolated in separate Docker networks
- MQTT requires configuration review (credentials)
- NAS access requires authentication
- Most services only accessible on local network

⚠️ **Recommendations:**
1. **Change default Grafana credentials** (currently admin/admin)
2. **Review MQTT broker authentication** - Configure mosquitto ACLs
3. **Implement network segmentation** - Consider VLAN for IoT devices
4. **Enable HTTPS** for web interfaces (reverse proxy with Let's Encrypt)
5. **Regular updates** - Keep Docker images current
6. **Backup strategy** - Document backup procedures for volumes
7. **Monitor unusual traffic** - Review Prometheus/Grafana for anomalies

### Firewall Status
**Current:** Unable to check (requires root)
**Recommendation:** Verify firewall rules restrict access to management interfaces

---

## Network Diagrams

### Overall Architecture

```
Internet (Cogeco Cable)
    │
    ├─── Cloudflare Tunnel (encrypted) ──┐
    │                                     │
[ISP Router] 192.168.40.1                 │
    │                                     │
    ├─── Main Network (192.168.40.0/24)   │
    │    │                                │
    │    ├─ Docker Host (192.168.40.201) ─┘
    │    │  ├─ homeassistant-network (172.19.0.0/16)
    │    │  ├─ cloudflare-tunnel-network (192.168.64.0/20)
    │    │  ├─ media-network (172.18.0.0/16)
    │    │  ├─ n8n-network (172.23.0.0/16)
    │    │  └─ ollama-network (172.20.0.0/16)
    │    │
    │    ├─ NAS/File Server (192.168.40.200)
    │    ├─ Living Room Voice (192.168.40.120) - ESP32
    │    ├─ Office Voice (192.168.40.121) - ESP32
    │    └─ Other devices (192.168.40.x)
    │
    └─── WAN Interface
```

### Docker Network Interconnections

```
┌─────────────────────────────────────────────────────┐
│ cloudflare-tunnel-network (192.168.64.0/20)        │
│  ├─ homeassistant (also on 172.19.0.12)            │
│  ├─ n8n (also on 172.23.0.x)                        │
│  └─ ollama (also on 172.20.0.x)                     │
└─────────────────────────────────────────────────────┘
         │           │              │
         └───────────┴──────────────┘
                     │
              [Cloudflared Container]
                     │
                  Internet

┌─────────────────────────────────────────────────────┐
│ homeassistant-network (172.19.0.0/16)              │
│  ├─ homeassistant ──┬─ API ──> Wyoming services    │
│  ├─ mosquitto (MQTT)│           (Whisper, Piper,   │
│  ├─ esphome ────────┘            OpenWakeWord)      │
│  ├─ influxdb                                        │
│  ├─ grafana                                         │
│  ├─ prometheus                                      │
│  ├─ cadvisor                                        │
│  └─ node_exporter                                   │
└─────────────────────────────────────────────────────┘
         │
         └─> ESP32 devices on 192.168.40.0/24
```

---

## IP Address Allocation Plan

> **📋 Use this allocation scheme when assigning new devices to prevent conflicts and maintain organization.**

### Reserved IP Blocks (Active)

| Range | Purpose | Device Types | Static DHCP? |
|-------|---------|--------------|--------------|
| **192.168.40.1-10** | Network Infrastructure | Router, switches, access points, network management | ✓ Required |
| **192.168.40.11-30** | Servers & Infrastructure | NAS, file servers, backup servers | ✓ Required |
| **192.168.40.31-50** | Workstations & PCs | Desktop computers, development machines | ✓ Recommended |
| **192.168.40.51-79** | **RESERVED FOR FUTURE** | Expansion - additional workstations/servers | - |
| **192.168.40.80-99** | Media Devices | Roku, Chromecast, Apple TV, streaming boxes | ✓ Recommended |
| **192.168.40.100-109** | Smart Home Hubs & Displays | Google Home, Amazon Echo, smart displays | ✓ Required |
| **192.168.40.110-119** | Smart Plugs & Switches | TP-Link, Wyze, Shelly switches | ✓ Recommended |
| **192.168.40.120-139** | ESP32 & Custom IoT | M5Stack, ESP32 dev boards, custom sensors | ✓ Required |
| **192.168.40.140-159** | Smart Appliances | Refrigerators, ranges, washers, dryers | ✓ Recommended |
| **192.168.40.160-179** | Climate & Environmental | Thermostats, temperature sensors, air quality | ✓ Required |
| **192.168.40.180-199** | Security & Cameras | IP cameras, doorbells, motion sensors (future) | ✓ Required |
| **192.168.40.200-210** | Critical Infrastructure | NAS (.200), Docker Host (.201) | ✓ Required |
| **192.168.40.211-220** | **RESERVED FOR FUTURE** | Additional Docker hosts, Kubernetes nodes | - |
| **192.168.40.221-254** | DHCP Pool | Phones, tablets, laptops, guest devices | DHCP |

### Current Device Assignments

| IP | Device | Block | Status | Notes |
|----|--------|-------|--------|-------|
| **.1** | Gateway/Router | Infrastructure | ✓ Static | ISP router |
| **.13** | Main Computer | Workstations | ✓ Static | Ryzen R7, NVIDIA 5060 - **MOVE TO .31** |
| **.20** | Office Network Switch | Infrastructure | ✓ Static | North wall switch - **CORRECT BLOCK** |
| **.99** | Living Room Roku TV | Media | ✓ Static | Wired connection |
| **.100** | Google Nest Hub | Smart Home Hubs | ⚠️ Reserve | Kitchen display |
| **.101** | Living Room Chromecast | Media | ⚠️ Reserve | Connected to Roku HDMI1 |
| **.102** | Google Nest Audio | Smart Home Hubs | ⚠️ Reserve | Bedroom speaker |
| **.104** | Ecobee Thermostat | Climate | ⚠️ **MOVE TO .160** | Climate control |
| **.105** | Samsung Smart Range | Smart Appliances | ⚠️ **MOVE TO .140** | Kitchen - SmartThings |
| **.106** | Samsung Refrigerator | Smart Appliances | ⚠️ **MOVE TO .141** | Kitchen - SmartThings |
| **.120** | Living Room Voice | ESP32 | ✅ **MOVED** | M5Stack Atom - **RECOMMENDED BLOCK** |
| **.121** | Office Voice | ESP32 | ✅ **MOVED** | M5Stack Atom - **RECOMMENDED BLOCK** |
| **.110** | TP-Link Smart Plug #1 | Smart Plugs | ✓ Static | Bedroom fan - **CORRECT BLOCK** |
| **.111** | TP-Link Smart Plug #2 | Smart Plugs | ✓ Static | Coffee machine - **CORRECT BLOCK** |
| **.112** | TP-Link Smart Plug #3 | Smart Plugs | ✓ Static | Glue gun - **CORRECT BLOCK** |
| **.113** | TP-Link Smart Plug #4 | Smart Plugs | ✓ Static | Creality Ender3 V3 - **CORRECT BLOCK** |
| **.200** | NAS/File Server | Critical Infra | ✓ Static | CIFS/SMB share |
| **.201** | Docker Host | Critical Infra | ✓ Static | Main server (this machine) |
| **.202** | Creality Slicer Server | Critical Infra | ✓ Static | 3D printing & electronics testing |
| **.226** | Dell PC | Workstations | ⚠️ Reserve | Windows - **MOVE TO .32** |
| **.250** | Google Pixel 10 Pro | DHCP Pool | DHCP | Main phone |

### IP Reorganization Plan

> **📋 DETAILED MIGRATION GUIDE:** See [ip-migration-plan.md](ip-migration-plan.md) for complete step-by-step instructions, checklists, and troubleshooting.

**Action Required:** Several devices are in incorrect IP blocks and should be moved:

#### Priority 1 - ESP32 Devices (Move to .120-.139) ✅ COMPLETED
- ✅ **Previously:** .107, .108 (in Smart Home block)
- ✅ **Moved to:** .120, .121
- **Benefit:** Dedicated ESP32 block with room for 20 devices
- **Status:** Both devices migrated and operational

#### Priority 2 - Workstations (Move to .31-.50)
- ✅ **Currently:** .13, .226 (scattered)
- ✅ **Move to:** .31 (Main Computer), .32 (Dell PC)
- **Benefit:** Organized workstation block

#### Priority 3 - Climate Devices (Move to .160-.179)
- ✅ **Currently:** .104 (Ecobee in Smart Home block)
- ✅ **Move to:** .160
- **Benefit:** Dedicated climate/environmental block

#### Priority 4 - Smart Appliances (Move to .140-.159)
- ✅ **Currently:** .105 (Range), .106 (Refrigerator in Smart Home block)
- ✅ **Move to:** .140 (Range), .141 (Refrigerator)
- **Benefit:** Dedicated kitchen appliance block

### Future Device Assignments

**Available ranges for new devices:**

| Block | Available IPs | Use For |
|-------|--------------|---------|
| **ESP32 (.120-.139)** | .122-.139 (18 IPs) | New M5Stack devices, sensors, custom IoT |
| **Smart Plugs (.110-.119)** | .114-.119 (6 IPs) | Additional TP-Link/Shelly switches |
| **Smart Appliances (.140-.159)** | .142-.159 (18 IPs) | Smart washer/dryer, dishwasher, etc. |
| **Climate (.160-.179)** | .161-.179 (19 IPs) | Temperature sensors, air quality monitors |
| **Security (.180-.199)** | .180-.199 (20 IPs) | IP cameras, doorbells, motion sensors |

### Static DHCP Reservation Checklist

Configure these in your router to ensure devices always get the same IP:

**Critical (Must Have):**
- [x] Router (.1)
- [x] NAS (.200)
- [x] Docker Host (.201)

**ESP32 & IoT (Required for reliability):**
- [x] Living Room Voice → .120 ✅ CONFIGURED
- [x] Office Voice → .121 ✅ CONFIGURED
- [ ] Future ESP32 devices → .122-.139

**Smart Home (Recommended):**
- [ ] Google Nest Hub (.100)
- [ ] Google Nest Audio (.102)
- [ ] Living Room Chromecast (.101)
- [x] TP-Link Smart Plug #1 (.110) - Bedroom fan
- [x] TP-Link Smart Plug #2 (.111) - Coffee machine
- [x] TP-Link Smart Plug #3 (.112) - Glue gun
- [x] TP-Link Smart Plug #4 (.113) - Creality Ender3 V3

**Climate (Required):**
- [ ] Ecobee Thermostat → .160 (currently .104)

**Appliances (Recommended):**
- [ ] Samsung Range → .140 (currently .105)
- [ ] Samsung Refrigerator → .141 (currently .106)

**Workstations (Recommended):**
- [ ] Main Computer → .31 (currently .13)
- [ ] Dell PC → .32 (currently .226)

**Media (Recommended):**
- [ ] Living Room Roku TV (.99)

---

## Network Performance

### Metrics to Monitor

**Prometheus Targets:**
- Node Exporter (9100) - Host system metrics
- cAdvisor (8081) - Container resource usage
- Custom exporters for network bandwidth

**Grafana Dashboards:**
- System overview (CPU, RAM, disk, network)
- Container resource usage
- MQTT message rates
- Service response times

### Bandwidth Considerations

**High Bandwidth Services:**
- Plex streaming (variable, 2-20 Mbps per stream)
- qBittorrent downloads (saturates connection)
- IP cameras (if added, 2-8 Mbps each)

**Low Bandwidth Services:**
- MQTT (< 1 Mbps)
- Home Assistant (< 1 Mbps)
- Monitoring (< 5 Mbps)

---

## Troubleshooting

### Common Network Issues

**Device can't reach Internet:**
```bash
ping 8.8.8.8              # Test connectivity
ping google.com           # Test DNS resolution
traceroute 8.8.8.8        # Check routing path
```

**Container can't reach other containers:**
```bash
docker network inspect <network-name>
docker exec <container> ping <other-container>
docker exec <container> nslookup <service-name>
```

**ESP32 device offline:**
```bash
ping 192.168.40.120               # Living Room Voice
ping 192.168.40.121               # Office Voice
docker logs -f esphome             # Check ESPHome logs
docker exec esphome esphome logs living-room-voice.yaml --device 192.168.40.120
docker exec esphome esphome logs office-voice.yaml --device 192.168.40.121
```

**File server not accessible:**
```bash
mount | grep fileserver            # Check if mounted
ls -la /mnt/fileserver             # Test access
smbclient -L 192.168.40.200 -U hazzard  # Test SMB connection
```

### Network Scan Commands

```bash
# Scan for devices on network (requires sudo)
sudo nmap -sn 192.168.40.0/24

# Check neighbor cache
ip neighbor show

# Show routing table
ip route show

# Check open ports on this host
ss -tlnp

# Test connectivity to service
curl -v http://localhost:8123
```

---

## Future Network Enhancements

### Planned Additions

1. **VLAN Segmentation**
   - VLAN 10: Management (servers, docker host)
   - VLAN 20: IoT devices (ESP32, sensors)
   - VLAN 30: Guest network
   - VLAN 40: Media & entertainment

2. **Additional ESP32 Devices**
   - Reserve 192.168.40.110-130 for ESP32 projects
   - Configure static IPs via router DHCP reservations

3. **Network Monitoring**
   - Add SNMP monitoring for router/switches
   - Set up bandwidth monitoring
   - Network UPS monitoring

4. **Security Hardening**
   - Implement network segmentation
   - Add reverse proxy (Nginx/Traefik) with SSL
   - Enable 2FA for exposed services
   - Regular security audits

5. **Backup Infrastructure**
   - Automated backups to NAS
   - Off-site backup strategy
   - Regular restore testing

---

**Document Version:** 2.0
**Last Updated:** 2025-12-03
**Maintained By:** User (via Claude Code)

---

## Quick Reference Card

### Infrastructure Devices

| Device | IP | Access |
|--------|-----|--------|
| **Gateway/Router** | 192.168.40.1 | Router admin panel |
| **Office Network Switch** | 192.168.40.20 | North wall switch |
| **NAS/File Server** | 192.168.40.200 | \\192.168.40.200\media-share |
| **Docker Host** | 192.168.40.201 | SSH/All Docker services |
| **Creality Slicer Server** | 192.168.40.202 | 3D printing & electronics |

### Key Services (Docker Host)

| Service | URL | Purpose |
|---------|-----|---------|
| **Home Assistant** | http://192.168.40.201:8123 | Smart home hub |
| **ESPHome** | http://192.168.40.201:6052 | ESP32 management |
| **Grafana** | http://192.168.40.201:3001 | Monitoring dashboards |
| **Prometheus** | http://192.168.40.201:9090 | Metrics collection |
| **Open WebUI** | http://192.168.40.201:3000 | Ollama chat interface |
| **n8n** | http://192.168.40.201:5678 | Workflow automation |
| **Portainer** | http://192.168.40.201:9000 | Docker management |

### Smart Home Devices

| Device | IP Address | Status | Location |
|--------|-----------|--------|----------|
| **Living Room Voice** | .120 | ✅ Active | ESP32 voice assistant |
| **Office Voice** | .121 | ✅ Active | ESP32 voice assistant |
| **Ecobee Thermostat** | .104 | → .160 | Climate control |
| **TP-Link Smart Plug #1** | .110 | ✅ Active | Bedroom fan |
| **TP-Link Smart Plug #2** | .111 | ✅ Active | Coffee machine |
| **TP-Link Smart Plug #3** | .112 | ✅ Active | Glue gun |
| **TP-Link Smart Plug #4** | .113 | ✅ Active | Creality Ender3 V3 |
| **Google Nest Hub** | .100 | .100 ✓ | Kitchen |
| **Google Nest Audio** | .102 | .102 ✓ | Bedroom |
| **Samsung Smart Range** | .105 | → .140 | Kitchen |
| **Samsung Refrigerator** | .106 | → .141 | Kitchen |

### Media Devices

| Device | IP | Notes |
|--------|-----|-------|
| **Living Room Roku TV** | .99 | Wired connection |
| **Living Room Chromecast** | .101 | HDMI1 on Roku TV |

### Available IP Ranges for New Devices

- **ESP32 Projects:** .122-.139 (18 available)
- **Smart Plugs:** .112-.119 (8 available)
- **Smart Appliances:** .142-.159 (18 available)
- **Climate Sensors:** .161-.179 (19 available)
- **Security/Cameras:** .180-.199 (20 available)
