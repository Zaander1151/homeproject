# Network Topology & Configuration

**Scanned on:** 2025-10-30
**Primary Network:** 192.168.40.0/24

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
| **Docker Host** | 192.168.40.201 | 10:ff:e0:cb:7a:c2 | Main server | This machine |
| **NAS/File Server** | 192.168.40.200 | 74:d4:35:9b:01:8f | Storage | CIFS/SMB share at /mnt/fileserver |

### Computers & Workstations

| Device | IP Address | MAC Address | Specs/Type | Notes |
|--------|-----------|-------------|-----------|-------|
| **Main Computer** | 192.168.40.13 | 10:ff:e0:ca:b2:8c | Ryzen R7, 32GB RAM, 2TB M.2, NVIDIA 5060 | Primary workstation |
| **Dell PC** | 192.168.40.226 | e4:b9:7a:f6:c3:05 | Dell (Windows) | File sharing enabled |

### Smart Home Devices

| Device | IP Address | MAC Address | Type | Location/Notes |
|--------|-----------|-------------|------|---------------|
| **Living Room Voice** | 192.168.40.107 | f4:65:0b:01:cf:84 | ESP32 (M5Stack Atom) | Voice assistant |
| **Office Voice** | 192.168.40.108 | - | ESP32 (M5Stack Atom) | Voice assistant (offline?) |
| **Ecobee Thermostat** | 192.168.40.104 | 44:61:32:8a:99:74 | Smart thermostat | Climate control |
| **TP-Link Smart Plug** | 192.168.40.110 | 3c:52:a1:ed:2b:e7 | WiFi smart plug | Bedroom fan control |
| **Google Nest Hub** | 192.168.40.100 | 38:86:f7:11:0f:17 | Smart display | Kitchen display |
| **Google Nest Audio** | 192.168.40.102 | 38:86:f7:9c:bf:4a | Smart speaker | Bedroom speaker |

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
- Consider IPs 111-150 for new ESP32 devices
- Current ESP32 devices: .107 (living room), .108 (office - offline)

---

## Docker Network Architecture

### Network Bridges

| Network Name | Bridge | Subnet | Gateway | Purpose |
|-------------|--------|--------|---------|---------|
| **homeassistant-network** | br-6c2ba96c8bfc | 172.19.0.0/16 | 172.19.0.1 | Home automation stack |
| **cloudflare-tunnel-network** | br-fb2cd4e8c189 | 192.168.64.0/20 | 192.168.64.1 | External access via Cloudflare |
| **media-network** | br-c6474695d223 | 172.18.0.0/16 | 172.18.0.1 | Media server stack |
| **n8n_internal_network** | br-7c6b643c5d79 | 172.23.0.0/16 | 172.23.0.1 | n8n + PostgreSQL |
| **ollama_default** | br-65372da799dc | 172.20.0.0/16 | 172.20.0.1 | Ollama services |
| **dockpeek_default** | br-c65da9c026e0 | 172.28.0.0/16 | 172.28.0.1 | DockPeek monitoring |
| **default (docker0)** | docker0 | 172.17.0.0/16 | 172.17.0.1 | Default bridge |

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
    │    ├─ Living Room Voice (192.168.40.107) - ESP32
    │    ├─ Office Voice (192.168.40.108) - ESP32
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

### Reserved Ranges (Proposed)

| Range | Purpose | Notes |
|-------|---------|-------|
| 192.168.40.1-10 | Network infrastructure | Router, switches, APs |
| 192.168.40.11-50 | Servers & NAS | Static assignments |
| 192.168.40.51-99 | Computers & workstations | DHCP or static |
| 192.168.40.100-150 | IoT devices (ESP32, sensors) | Static recommended for reliability |
| 192.168.40.151-200 | Smart home devices | Thermostats, hubs, cameras |
| 192.168.40.201-220 | Docker hosts | Current host is .201 |
| 192.168.40.221-254 | DHCP pool | Guest devices, phones, tablets |

### Current Assignments

| IP | Assignment | Static? | Category | Notes |
|----|-----------|---------|----------|-------|
| .1 | Gateway | ✓ | Infrastructure | ISP router |
| .13 | Main Computer | ✓ | Workstation | Ryzen R7, NVIDIA 5060 |
| .99 | Living Room Roku TV | ✓ | Media | Wired connection |
| .100 | Google Nest Hub | ✓ | Smart Home | Kitchen display |
| .101 | Living Room Chromecast | ? | Media | Connected to Roku HDMI1 |
| .102 | Google Nest Audio | ? | Smart Home | Bedroom speaker |
| .104 | Ecobee Thermostat | ✓ | Smart Home | Climate control |
| .107 | Living Room Voice | ✓ | ESP32 | Voice assistant (M5Stack) |
| .108 | Office Voice | ✓ | ESP32 | Voice assistant (offline) |
| .110 | TP-Link Smart Plug | ? | Smart Home | Bedroom fan |
| .200 | NAS/File Server | ✓ | Infrastructure | CIFS share |
| .201 | Docker Host | ✓ | Infrastructure | This machine |
| .226 | Dell PC | ? | Workstation | Windows, file sharing |
| .250 | Google Pixel 10 Pro | DHCP | Mobile | Main phone |

**Recommendations:**
1. ✅ All devices identified!
2. Set static DHCP reservations for:
   - Smart home devices (.100, .102, .104, .110)
   - Chromecast (.101)
   - Dell PC (.226) if always-on
3. Reserve IPs 111-130 for future ESP32 projects
4. Keep .250+ as DHCP pool for mobile devices

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
ping 192.168.40.107               # Check if reachable
docker logs -f esphome             # Check ESPHome logs
docker exec -it esphome esphome logs living-room-voice.yaml
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

**Document Version:** 1.0
**Last Updated:** 2025-10-30
**Maintained By:** User (via Claude Code)

**Quick Reference Card:**

**Infrastructure:**
- Gateway/Router: 192.168.40.1
- Docker Host: 192.168.40.201
- File Server (NAS): 192.168.40.200 → \\192.168.40.200\media-share
- Main Computer: 192.168.40.13

**Key Services:**
- Home Assistant: http://192.168.40.201:8123
- ESPHome: http://192.168.40.201:6052
- Grafana: http://192.168.40.201:3001
- Ollama/Open-WebUI: http://192.168.40.201:3000
- n8n: http://192.168.40.201:5678

**Smart Home Devices:**
- Living Room Voice (ESP32): 192.168.40.107
- Office Voice (ESP32): 192.168.40.108
- Ecobee Thermostat: 192.168.40.104
- TP-Link Smart Plug: 192.168.40.110
- Google Nest Hub: 192.168.40.100
- Google Nest Audio: 192.168.40.102

**Media Devices:**
- Living Room Roku TV: 192.168.40.99
- Living Room Chromecast: 192.168.40.101

**Available for ESP32 Projects:** 192.168.40.111-130
