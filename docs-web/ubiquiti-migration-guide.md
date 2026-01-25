# Ubiquiti Network Migration Guide

**Network Migration:** Single flat network (192.168.40.0/24) → VLAN-segmented Ubiquiti infrastructure

**Equipment:**
- Cloud Gateway Ultra (UCG-Ultra)
- Switch Lite 8 PoE (USW-Lite-8-PoE)
- U6+ Access Point

**Estimated Migration Time:** 2-4 hours (weekend project)

---

## Table of Contents

1. [Network Design Overview](#network-design-overview)
2. [VLAN Configuration](#vlan-configuration)
3. [Firewall Rules](#firewall-rules)
4. [Physical Topology](#physical-topology)
5. [Static IP Assignments](#static-ip-assignments)
6. [Pre-Migration Checklist](#pre-migration-checklist)
7. [Migration Steps](#migration-steps)
8. [Testing Checklist](#testing-checklist)
9. [Rollback Plan](#rollback-plan)
10. [Troubleshooting](#troubleshooting)

---

## Network Design Overview

### VLANs

| VLAN ID | Name | Subnet | Purpose | Security Level |
|---------|------|---------|---------|----------------|
| **1** | Management | 192.168.1.0/24 | UniFi devices (gateway, switch, AP) | High - admin only |
| **10** | Servers | 192.168.10.0/24 | Docker host, NAS, Creality server | High - infrastructure |
| **20** | Trusted | 192.168.20.0/24 | Workstations, phones, tablets | Medium - full LAN access |
| **30** | IoT | 192.168.30.0/24 | ESP32s, smart plugs, thermostats | Low - isolated, limited access |
| **40** | Media | 192.168.40.0/24 | TV, Chromecast, streaming | Low - media services only |
| **50** | Guest | 192.168.50.0/24 | Guest WiFi (internet only) | Very Low - fully isolated |

### WiFi SSIDs

| SSID | VLAN | Security | Purpose |
|------|------|----------|---------|
| **"[Your Main SSID]"** | VLAN 20 (Trusted) | WPA3/WPA2 | Primary WiFi for phones, laptops |
| **"IoT"** | VLAN 30 (IoT) | WPA2 | Smart home devices, ESP32s |
| **"Guest"** | VLAN 50 (Guest) | WPA2 | Guest access, isolated |

### Key Benefits

✅ **Security:** IoT devices isolated from workstations and servers
✅ **Performance:** Reduced broadcast traffic, better QoS
✅ **Manageability:** Granular firewall rules, per-VLAN monitoring
✅ **Scalability:** Easy to add new device categories

---

## VLAN Configuration

### UniFi Network Settings → Networks

**Network 1 - Management (Default):**
```
Name: Management
VLAN ID: 1
Gateway/Subnet: 192.168.1.1/24
DHCP Range: 192.168.1.100-192.168.1.254
DHCP Enabled: Yes
Auto-Scale Network: Off
```

**Network 2 - Servers:**
```
Name: Servers
VLAN ID: 10
Gateway/Subnet: 192.168.10.1/24
DHCP Range: 192.168.10.100-192.168.10.199
DHCP Enabled: Yes
```

**Network 3 - Trusted:**
```
Name: Trusted
VLAN ID: 20
Gateway/Subnet: 192.168.20.1/24
DHCP Range: 192.168.20.100-192.168.20.254
DHCP Enabled: Yes
```

**Network 4 - IoT:**
```
Name: IoT
VLAN ID: 30
Gateway/Subnet: 192.168.30.1/24
DHCP Range: 192.168.30.200-192.168.30.254
DHCP Enabled: Yes
```

**Network 5 - Media:**
```
Name: Media
VLAN ID: 40
Gateway/Subnet: 192.168.40.1/24
DHCP Range: 192.168.40.100-192.168.40.254
DHCP Enabled: Yes
```

**Network 6 - Guest:**
```
Name: Guest
VLAN ID: 50
Gateway/Subnet: 192.168.50.1/24
DHCP Range: 192.168.50.100-192.168.50.254
DHCP Enabled: Yes
Guest Network: ENABLED (blocks local LAN access)
```

---

## Firewall Rules

### UniFi Settings → Security → Firewall → Create Rule

**Configure in this order (priority matters):**

| Priority | Name | Action | Source | Destination | Ports/Protocol | Purpose |
|----------|------|--------|--------|-------------|----------------|---------|
| **1** | Allow Established/Related | ACCEPT | Any | Any | Any | Return traffic |
| **2** | Allow Trusted → All | ACCEPT | VLAN 20 | Any VLAN | Any | Workstation full access |
| **3** | Allow IoT → Home Assistant | ACCEPT | VLAN 30 | 192.168.10.201 | TCP 8123 | Home Assistant API |
| **4** | Allow IoT → MQTT | ACCEPT | VLAN 30 | 192.168.10.201 | TCP 1883 | MQTT broker |
| **5** | Allow IoT → ESPHome | ACCEPT | VLAN 30 | 192.168.10.201 | TCP 6052 | ESPHome OTA/logs |
| **6** | Allow Servers → IoT | ACCEPT | VLAN 10 | VLAN 30 | Any | HA polling devices |
| **7** | Allow Media → Plex | ACCEPT | VLAN 40 | 192.168.10.201 | TCP 32400 | Plex streaming |
| **8** | Allow Media → HA | ACCEPT | VLAN 40 | 192.168.10.201 | TCP 8123 | HA media control |
| **9** | Allow All → Internet | ACCEPT | Any | !RFC1918 | Any | Internet access |
| **10** | Block Guest → LAN | DROP | VLAN 50 | RFC1918 | Any | Isolate guests |
| **11** | Block Inter-VLAN | DROP | Any VLAN | Any VLAN | Any | Default deny |

**RFC1918 Definition:**
- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16

### Additional Settings

**Enable mDNS (Chromecast discovery):**
```
Settings → Services → mDNS
  Enable: ON
```

---

## Physical Topology

### SME Closet (Front Hall) - Central Hub

```
ISP Modem
  ↓ (Ethernet)
Cloud Gateway Ultra (WAN port)
  ↓ (LAN port → Lite-8 Port 8)
Lite-8 PoE Switch:
  Port 1: U6+ Access Point (PoE, Trunk - All VLANs)
  Port 2: Main Server / Docker Host (VLAN 10)
  Port 3: Wall Port 1 → Living Room TV (VLAN 40)
  Port 4: Wall Port 2 → Office → Main Workstation (VLAN 20)
  Port 5: Wall Port 3 → Main Bedroom (VLAN 20)
  Port 6: Wall Port 4 → Secondary Living Room (VLAN 20)
  Port 7: Future NAS (VLAN 10)
  Port 8: Uplink to UCG-Ultra (Trunk)
```

### Switch Port Configuration

**UniFi Devices → Lite-8 PoE → Port Manager:**

| Port | Device | Profile | VLAN Mode | VLANs |
|------|--------|---------|-----------|-------|
| **1** | U6+ AP | All | Trunk (Tagged) | 1, 10, 20, 30, 40, 50 |
| **2** | Main Server | Servers | Access (Untagged) | 10 |
| **3** | Wall → TV | Media | Access (Untagged) | 40 |
| **4** | Wall → Office | Trusted | Access (Untagged) | 20 |
| **5** | Wall → Bedroom | Trusted | Access (Untagged) | 20 |
| **6** | Wall → Living Room | Trusted | Access (Untagged) | 20 |
| **7** | Future NAS | Servers | Access (Untagged) | 10 |
| **8** | UCG-Ultra | All | Trunk | All |

---

## Static IP Assignments

### DHCP Reservations (UniFi)

**VLAN 10 (Servers) - Static IPs:**
- Main Server / Docker Host: **192.168.10.201**
- NAS (future): **192.168.10.200**
- Creality Slicer Server: **192.168.10.202**

**VLAN 20 (Trusted) - Static IPs:**
- Main Workstation: **192.168.20.31** (MAC: 10:ff:e0:ca:b2:8c)
- Dell PC: **192.168.20.32** (MAC: e4:b9:7a:f6:c3:05)
- Pixel 10 Pro: DHCP (MAC: b6:84:b9:70:46:33)

**VLAN 30 (IoT) - DHCP Reservations:**
```
Settings → Networks → IoT → DHCP → Static Leases

Device                        MAC Address         IP Address
-----------------------------------------------------------------
Living Room Voice (ESP32)     f4:65:0b:01:cf:84   192.168.30.120
Office Voice (ESP32)          00:4b:12:a1:1a:74   192.168.30.121
TP-Link Smart Plug #1         3c:52:a1:ed:2b:e7   192.168.30.110
TP-Link Smart Plug #2         98:ba:5f:c8:2e:0b   192.168.30.111
TP-Link Smart Plug #3         TBD                 192.168.30.112
TP-Link Smart Plug #4         TBD                 192.168.30.113
Ecobee Thermostat             44:61:32:8a:99:74   192.168.30.160
Samsung Smart Range           28:6b:b4:12:0d:16   192.168.30.140
Samsung Refrigerator          28:6b:b4:1a:df:ac   192.168.30.141
Google Nest Hub               38:86:f7:11:0f:17   192.168.30.100
Google Nest Audio             38:86:f7:9c:bf:4a   192.168.30.102
```

**VLAN 40 (Media) - DHCP Reservations:**
```
Device                        MAC Address         IP Address
-----------------------------------------------------------------
Living Room Roku TV           34:93:42:73:ed:46   192.168.40.99
Living Room Chromecast        dc:e5:5b:9b:96:68   192.168.40.101
```

---

## Pre-Migration Checklist

### 1 Week Before Migration

- [ ] Create Ubiquiti account at unifi.ui.com
- [ ] Download UniFi Network mobile app (iOS/Android)
- [ ] Verify UCG-Ultra, Lite-8, U6+ are unboxed and ready
- [ ] Gather Cat6 patch cables (need ~8 cables for SME closet)
- [ ] Verify mounts for UCG-Ultra and Lite-8 are ready
- [ ] Print this migration guide
- [ ] Schedule migration window (weekend, 2-4 hours)

### 1 Day Before Migration

**Backup Configurations:**
```bash
# SSH to Docker host (192.168.40.201)

# Backup Home Assistant
cd /home/hazzard/home-assistant
tar -czf ~/ha-backup-$(date +%Y%m%d).tar.gz config/ esphome/ mosquitto/

# Backup all Docker configs
cd /home/hazzard
tar -czf ~/docker-backup-$(date +%Y%m%d).tar.gz \
  home-assistant/ n8n/ ollama/ media-stack/

# Document current network config
ip addr show enp4s0 > ~/network-config-old.txt
ip route show >> ~/network-config-old.txt
cat /etc/netplan/*.yaml >> ~/network-config-old.txt
```

**Document Current State:**
- [ ] Photo of ISP router connections
- [ ] Write down ISP router admin credentials
- [ ] Test current network: ping 8.8.8.8, access HA, test voice assistants
- [ ] Verify all Docker containers are running: `docker ps`

---

## Migration Steps

### Phase 1: Initial Setup (No Downtime Yet)

**Step 1: Install Physical Equipment**

```
1. Mount UCG-Ultra in SME closet
2. Mount Lite-8 PoE in SME closet
3. Run Cat6 from SME closet to hallway for U6+ AP
4. Mount U6+ AP on hallway wall

5. Power connections:
   - UCG-Ultra → Power
   - Lite-8 → Power
   - DO NOT connect UCG-Ultra WAN yet (no internet disruption)

6. Network connections:
   - Lite-8 Port 8 → UCG-Ultra LAN port (temporary)
   - Lite-8 Port 1 → U6+ AP (PoE)

7. Wait for devices to boot (blue/white LEDs)
```

**Step 2: Initial UniFi Setup**

```
1. Open UniFi Network app on phone
2. App should discover UCG-Ultra
3. Follow setup wizard:
   - Create admin account (save credentials!)
   - Set device name: "Home-Gateway"
   - Skip internet setup (we'll connect later)

4. Adopt Lite-8 Switch:
   - Should appear in "Devices" tab
   - Tap → Adopt
   - Set name: "Main-Switch"

5. Adopt U6+ AP:
   - Should appear in "Devices" tab
   - Tap → Adopt
   - Set name: "Main-AP"
```

---

### Phase 2: Configure UniFi (Still No Downtime)

**Step 3: Create VLANs**

```
UniFi app → Settings → Networks → Create New Network

Create each network from the "VLAN Configuration" section above:
  1. Management (VLAN 1)
  2. Servers (VLAN 10)
  3. Trusted (VLAN 20)
  4. IoT (VLAN 30)
  5. Media (VLAN 40)
  6. Guest (VLAN 50)

IMPORTANT:
  - Enable "Guest Network" toggle ONLY for VLAN 50
  - Verify gateway IPs are correct (.1 for each subnet)
  - Verify DHCP ranges don't overlap with static IPs
```

**Step 4: Create WiFi SSIDs**

```
Settings → WiFi → Create New WiFi Network

SSID 1:
  Name: "[YourHomeNetwork]"
  Password: [Strong password]
  Network: Trusted (VLAN 20)
  Security: WPA2/WPA3

SSID 2:
  Name: "IoT"
  Password: [Different password]
  Network: IoT (VLAN 30)
  Security: WPA2

SSID 3:
  Name: "Guest"
  Password: [Simple password]
  Network: Guest (VLAN 50)
  Security: WPA2
```

**Step 5: Configure Switch Ports**

```
UniFi Devices → Lite-8 PoE → Port Manager

Configure each port from the "Physical Topology" section above

Port 1 (U6+ AP): Profile = All, Trunk mode
Port 2 (Main Server): Profile = Servers, VLAN 10
Port 3-6 (Wall Ports): Assign based on your layout
Port 7 (Future NAS): Profile = Servers, VLAN 10
Port 8 (Uplink): Keep as Trunk (All VLANs)
```

**Step 6: Configure Firewall**

```
Settings → Security → Firewall → Create Rule

Create each rule from "Firewall Rules" section above
CRITICAL: Create in exact order (priority matters!)

Rules 1-11:
  1. Allow Established/Related
  2. Allow Trusted → All
  3. Allow IoT → Home Assistant
  4. Allow IoT → MQTT
  5. Allow IoT → ESPHome
  6. Allow Servers → IoT
  7. Allow Media → Plex
  8. Allow Media → HA
  9. Allow All → Internet
  10. Block Guest → LAN
  11. Block Inter-VLAN
```

**Step 7: Enable mDNS**

```
Settings → Services → mDNS
  Enable: ON
```

**Step 8: Configure DHCP Reservations**

```
For VLAN 30 (IoT):
  Settings → Networks → IoT → DHCP → Static Leases
  Add each device from "Static IP Assignments" section

For VLAN 40 (Media):
  Settings → Networks → Media → DHCP → Static Leases
  Add Roku TV and Chromecast

For VLAN 20 (Trusted):
  Settings → Networks → Trusted → DHCP → Static Leases
  Add Main Workstation and Dell PC (optional)
```

---

### Phase 3: Cutover (DOWNTIME BEGINS)

**Step 9: Disconnect Old Network**

```
1. Announce to household: "Network going down for ~30 minutes"

2. Gracefully shutdown Docker services:
   docker-compose -f /home/hazzard/home-assistant/docker-compose.yml down
   docker-compose -f /home/hazzard/n8n/docker-compose.yml down
   docker-compose -f /home/hazzard/ollama/docker-compose.yml down
   docker-compose -f /home/hazzard/media-stack/docker-compose.yml down

3. Shutdown Docker host:
   sudo shutdown -h now

4. Wait for server to fully power off (1-2 minutes)

5. Disconnect ISP router:
   - Unplug power from ISP router
   - Wait 30 seconds
   - Disconnect cable from ISP router LAN → old network
```

**Step 10: Connect UCG-Ultra to Internet**

```
1. Connect: ISP Modem WAN port → UCG-Ultra WAN port
2. Power on ISP modem
3. Wait for modem to sync (2-3 minutes, watch LEDs)
4. UCG-Ultra should show "Connected" in UniFi app
5. Test internet from phone:
   - Connect to new WiFi "[YourHomeNetwork]"
   - Open browser, load google.com
   - Ping 8.8.8.8 from Network Tools app
```

**Step 11: Reconfigure Docker Host**

```
1. Physically move server to SME closet (if planned)
2. Connect server → Lite-8 Port 2
3. Power on server
4. Wait for boot (2-3 minutes)

5. Server will get DHCP IP on VLAN 10 (192.168.10.x)

6. Find server IP:
   - Check UniFi app → Clients → Find "hazzard-server"
   - Note DHCP IP (example: 192.168.10.150)

7. SSH to server (from workstation on Trusted WiFi):
   ssh hazzard@192.168.10.150

8. Set static IP:
   sudo nano /etc/netplan/01-netcfg.yaml

   # Update to:
   network:
     version: 2
     ethernets:
       enp4s0:
         addresses:
           - 192.168.10.201/24
         routes:
           - to: default
             via: 192.168.10.1
         nameservers:
           addresses:
             - 8.8.8.8
             - 1.1.1.1

   # Apply:
   sudo netplan apply

9. Verify new IP:
   ip addr show enp4s0
   # Should show: 192.168.10.201/24

   ping 192.168.10.1  # Gateway
   ping 8.8.8.8       # Internet

10. Start Docker services:
    cd /home/hazzard/home-assistant && docker-compose up -d
    cd /home/hazzard/n8n && docker-compose up -d
    cd /home/hazzard/ollama && docker-compose up -d
    cd /home/hazzard/media-stack && docker-compose up -d

11. Verify containers started:
    docker ps
    # All containers should show "Up X seconds/minutes"
```

---

### Phase 4: Device Migration

**Step 12: Connect Wired Devices**

```
Living Room TV (Roku):
  - Should already be connected to Wall Port 1 → VLAN 40
  - Power cycle TV
  - Should get 192.168.40.99 via DHCP reservation
  - Open Plex app to test

Main Workstation:
  - Disconnect from old network
  - Connect Ethernet to Wall Port 2 (Office) → VLAN 20
  - Will get DHCP first, verify internet works
  - Optional: Set static IP 192.168.20.31
```

**Step 13: Migrate ESP32 Devices**

```
For each ESP32 (Living Room Voice, Office Voice):

1. Connect laptop to "IoT" WiFi SSID

2. Access ESPHome: http://192.168.10.201:6052

3. Edit device YAML:
   - Click device → Edit
   - Update WiFi section:

   wifi:
     ssid: "IoT"  # Your IoT SSID name
     password: !secret iot_wifi_password
     manual_ip:
       static_ip: 192.168.30.120  # .120 for living room, .121 for office
       gateway: 192.168.30.1
       subnet: 255.255.255.0

4. Update secrets.yaml with new IoT WiFi password

5. Click "Install" → "Wirelessly"
   - Enter current IP (still on old network if in range)
   - OR use USB cable if out of range

6. Device will reboot and join IoT network

7. Verify in Home Assistant:
   - Settings → Devices → ESPHome
   - Device should show online at 192.168.30.120
   - If offline, delete and re-add with new IP

8. Test voice assistant:
   - Say "Hey Nabu, what time is it?"
   - Should respond
```

**Step 14: Migrate Smart Plugs**

```
For each TP-Link Tapo plug:

1. Connect phone to "IoT" WiFi

2. Open Tapo app

3. Device will show offline

4. Tap device → Settings → Wi-Fi Settings

5. "Forget Network" or "Change Network"

6. Connect to "IoT" SSID with new password

7. Device will reconnect and get reserved IP automatically

8. Verify in Home Assistant:
   - TP-Link integration may need re-authentication
   - Settings → Integrations → TP-Link Kasa Smart
   - Reconfigure with new network if needed
```

**Step 15: Migrate Google Home Devices**

```
Google Nest Hub, Nest Audio:

1. Google Home app on phone (connect to Trusted WiFi)

2. Each device → Settings → Wi-Fi

3. Tap "Forget Network"

4. Reconnect to "[YourHomeNetwork]" (Trusted VLAN 20)

5. Devices will get reserved IPs (192.168.30.100, .102)

6. Test by saying "Hey Google, what's the weather?"

Chromecast:

1. Google Home app → Chromecast → Settings → Wi-Fi

2. Forget old network

3. Reconnect to "Trusted" WiFi (VLAN 20) OR "Media" (VLAN 40)

4. Will get 192.168.40.101 if on Media VLAN

5. Test by casting from phone
```

**Step 16: Migrate Samsung Appliances**

```
Ecobee Thermostat:
1. On thermostat → Menu → Settings → Wi-Fi → Network
2. Forget current network
3. Connect to "IoT" SSID
4. Will get 192.168.30.160
5. Verify in Home Assistant (Ecobee integration)

Samsung Range/Fridge:
1. SmartThings app → Device → Settings → Wi-Fi
2. Change network to "IoT"
3. Will get 192.168.30.140 and .141
4. Verify in Home Assistant (SmartThings integration)
```

**Step 17: Migrate Workstations & Phones**

```
Main Workstation:
  - Already connected via Ethernet (Step 12)
  - OR connect to "Trusted" WiFi

Dell PC:
  - Connect to "Trusted" WiFi
  - OR plug into Wall Port 5/6

Pixel 10 Pro (phone):
  - Connect to "[YourHomeNetwork]" (Trusted WiFi)
  - Will get DHCP in 192.168.20.x range

Work Laptop:
  - Connect to "Trusted" WiFi (or use "Guest" for isolation)
```

---

### Phase 5: Testing & Verification

**Step 18: Test All Services**

```
✅ Internet Connectivity:
   From each VLAN, verify:
   - Ping 8.8.8.8
   - Browse to google.com

✅ Home Assistant:
   - URL: http://192.168.10.201:8123
   - From workstation (VLAN 20): Should work
   - From phone on Trusted WiFi: Should work
   - Verify all devices online:
     - ESP32 devices (Living Room, Office)
     - Smart Plugs (4 devices)
     - Ecobee Thermostat
     - Samsung Range/Fridge
     - Google Home devices

✅ Voice Assistants:
   - Living Room: "Hey Nabu, turn on bedroom fan"
   - Office: "Hey Nabu, what's the temperature?"
   - Should respond and execute commands

✅ MQTT:
   docker exec -it mosquitto mosquitto_sub -h localhost -t '#' -v
   - Should see messages from ESP32 devices
   - Verify sensor updates coming through

✅ Plex:
   - Open Plex on Roku TV
   - Should connect to server (192.168.10.201:32400)
   - Play a movie/show to test streaming
   - Verify transcoding works if needed

✅ n8n Workflows:
   - URL: http://192.168.10.201:5678
   - From workstation, access n8n
   - Test webhook (morning briefing):
     curl -X POST http://192.168.10.201:5678/webhook/morning-briefing \
       -H "Content-Type: application/json" \
       -d '{"timestamp": "2025-01-01T09:00:00", "triggered_by": "test"}'

✅ Ollama / Open WebUI:
   - URL: http://192.168.10.201:3000
   - From workstation, access Open WebUI
   - Test chat with qwen3:8b model

✅ Cross-VLAN Access:
   From workstation (VLAN 20):
   - Ping 192.168.30.120 (ESP32) → Should work (Trusted → IoT allowed)
   - Ping 192.168.10.201 (Server) → Should work (Trusted → Servers allowed)
   - SSH to ESP32: ssh esphome@192.168.30.120 → Should work

   From IoT device perspective:
   - ESP32 → HA (8123): Should work (firewall rule)
   - ESP32 → random port on server: Should FAIL (blocked)

✅ Isolation Testing:
   Connect phone to "Guest" WiFi:
   - Ping 8.8.8.8 → Should work (internet)
   - Ping 192.168.10.201 → Should FAIL (blocked by firewall)
   - Access http://192.168.10.201:8123 → Should FAIL

✅ mDNS / Chromecast:
   From phone on Trusted WiFi:
   - Open Netflix/YouTube
   - Tap cast button
   - Should see Chromecast (Living Room)
   - Cast should work
```

**Step 19: Monitor for Issues**

```
1. UniFi Dashboard:
   - Check for offline devices
   - Review traffic stats per VLAN
   - Check for firewall blocks (unexpected)

2. Docker Logs:
   docker logs -f homeassistant | grep -i error
   docker logs -f mosquitto
   docker logs -f esphome

3. Home Assistant Logs:
   - Check for "Unavailable" entities
   - Settings → System → Logs
   - Look for connection errors

4. Run network diagnostics:
   # From Docker host
   docker exec homeassistant ping 192.168.30.120  # Should work
   docker exec homeassistant curl http://192.168.30.120  # ESP32 web UI
```

---

## Rollback Plan

**If migration fails and you need to revert:**

### Emergency Rollback Steps

```
1. STOP: Document what failed before rolling back
   - Screenshot UniFi errors
   - Save Docker logs
   - Note which devices failed to connect

2. Disconnect UCG-Ultra from WAN:
   - Unplug Ethernet from UCG-Ultra WAN port

3. Reconnect ISP Router:
   - Power on ISP router
   - Wait for boot (2-3 minutes)
   - Reconnect ISP router LAN → your old network

4. Reconfigure Docker Host to old IP:
   SSH to server (if you can reach it on new network):
   ssh hazzard@192.168.10.201

   sudo nano /etc/netplan/01-netcfg.yaml

   # Change back to old config:
   network:
     version: 2
     ethernets:
       enp4s0:
         addresses:
           - 192.168.40.201/24
         routes:
           - to: default
             via: 192.168.40.1
         nameservers:
           addresses:
             - 8.8.8.8
             - 1.1.1.1

   sudo netplan apply

   # If you can't SSH, connect monitor/keyboard to server

5. Move Docker Host back to original location (if moved)

6. Restart Docker services:
   cd /home/hazzard/home-assistant && docker-compose up -d
   cd /home/hazzard/n8n && docker-compose up -d
   cd /home/hazzard/ollama && docker-compose up -d

7. Reconnect all devices to old WiFi:
   - ESP32s: Flash old config with old WiFi SSID
   - Smart Plugs: Reconnect to old network via Tapo app
   - Phones/laptops: Reconnect to old WiFi

8. Verify everything works on old network:
   - Home Assistant: http://192.168.40.201:8123
   - All devices online
   - Voice assistants working

9. Troubleshoot Ubiquiti offline:
   - Review what failed
   - Check UniFi forums/documentation
   - Plan retry for another weekend
```

### Partial Rollback (Keep some devices on new network)

If only some devices fail:
- Keep UCG-Ultra connected to WAN
- Keep working devices on new network
- Troubleshoot failing devices individually
- Gradually migrate remaining devices

---

## Troubleshooting

### Common Issues & Solutions

#### ESP32 Won't Connect to New Network

**Symptoms:**
- Device shows offline in ESPHome
- "Unavailable" in Home Assistant
- Can't ping 192.168.30.120

**Solutions:**

1. **Check WiFi credentials:**
   ```yaml
   # In ESPHome YAML, verify:
   wifi:
     ssid: "IoT"  # Must match exactly
     password: !secret iot_wifi_password

   # In secrets.yaml:
   iot_wifi_password: "YourIoTPassword"
   ```

2. **Flash via USB instead of OTA:**
   ```
   - Connect ESP32 to laptop via USB
   - ESPHome → Install → USB
   - Select correct COM port
   - Wait for flash to complete
   ```

3. **Check DHCP reservation:**
   ```
   UniFi → Settings → Networks → IoT → DHCP → Static Leases
   - Verify MAC address matches device
   - Verify IP is 192.168.30.120
   ```

4. **Check signal strength:**
   ```
   UniFi → U6+ AP → WiFi tab
   - Look for device in client list
   - Check RSSI (should be > -70 dBm)
   - If weak, move AP or add another AP
   ```

5. **Factory reset ESP32:**
   ```
   - Hold BOOT button on ESP32 for 10 seconds
   - Re-flash firmware via USB
   - Device will reconnect to WiFi
   ```

---

#### Home Assistant Shows Devices as "Unavailable"

**Symptoms:**
- Entities show "Unavailable" in HA
- Devices show offline in HA integrations

**Solutions:**

1. **Check firewall allows IoT → Server:**
   ```
   UniFi → Security → Firewall
   - Verify "Allow IoT → Home Assistant" rule exists
   - Source: VLAN 30
   - Destination: 192.168.10.201
   - Port: 8123
   - Action: ACCEPT
   ```

2. **Check device IP changed:**
   ```
   # Old: 192.168.40.120 → New: 192.168.30.120

   # In HA, update integration:
   Settings → Devices & Services → ESPHome
   - Delete device
   - Add device with new IP: 192.168.30.120
   ```

3. **Restart Home Assistant:**
   ```
   Settings → System → Restart
   OR:
   docker restart homeassistant
   ```

4. **Check MQTT connection:**
   ```
   docker exec -it mosquitto mosquitto_sub -h localhost -t '#' -v

   # Should see messages like:
   sensor/living_room/temperature 22.5
   ```

5. **Re-discover devices:**
   ```
   Settings → Devices & Services → Configure → ESPHome
   - Re-scan network
   - Devices should auto-discover if on same network
   ```

---

#### Plex Won't Stream to Roku

**Symptoms:**
- Roku Plex app shows "No servers found"
- Can't connect to Plex server

**Solutions:**

1. **Check firewall allows Media → Plex:**
   ```
   UniFi → Security → Firewall
   - Verify "Allow Media → Plex" rule exists
   - Source: VLAN 40
   - Destination: 192.168.10.201
   - Port: 32400
   - Action: ACCEPT
   ```

2. **Manually add Plex server:**
   ```
   Plex app on Roku:
   - Settings → Server → Add Server Manually
   - Enter: 192.168.10.201:32400
   ```

3. **Enable network discovery:**
   ```
   Plex Web UI (from workstation):
   http://192.168.10.201:32400/web

   Settings → Network
   - Enable "Enable server support for Insecure connections on LAN"
   - List of IP addresses: 192.168.40.0/24,192.168.20.0/24,192.168.10.0/24
   ```

4. **Check mDNS enabled:**
   ```
   UniFi → Settings → Services → mDNS
   - Enable: ON
   ```

5. **Verify Plex container networking:**
   ```
   docker inspect plex | grep -i network
   # Should show: "network_mode": "host"

   # If not, update docker-compose.yml:
   services:
     plex:
       network_mode: host

   docker-compose up -d plex
   ```

---

#### Chromecast Not Discoverable

**Symptoms:**
- Can't see Chromecast in cast menu
- "No devices found"

**Solutions:**

1. **Enable mDNS:**
   ```
   UniFi → Settings → Services → mDNS
   - Enable: ON
   ```

2. **Move Chromecast to Trusted VLAN:**
   ```
   Option 1: Same VLAN as phone (easier)
   - Reconnect Chromecast to "Trusted" WiFi (VLAN 20)
   - Phone also on Trusted WiFi
   - Discovery should work

   Option 2: Keep on Media VLAN (needs mDNS)
   - Chromecast on VLAN 40
   - Phone on VLAN 20
   - mDNS MUST be enabled
   - Firewall MUST allow mDNS packets
   ```

3. **Reboot Chromecast:**
   ```
   - Unplug Chromecast from power
   - Wait 30 seconds
   - Plug back in
   - Wait for boot (1-2 minutes)
   ```

4. **Check firewall doesn't block mDNS:**
   ```
   mDNS uses UDP port 5353

   If you have explicit firewall rules, add:
   - Source: Any
   - Destination: 224.0.0.251 (multicast)
   - Port: UDP 5353
   - Action: ACCEPT
   ```

---

#### Guest WiFi Can Access Local Devices

**Symptoms:**
- Guest devices can ping 192.168.10.201
- Guest can access Home Assistant, Plex, etc.

**Solutions:**

1. **Enable Guest Network toggle:**
   ```
   UniFi → Settings → Networks → Guest (VLAN 50)

   Guest Network: ENABLED ✓

   (This auto-creates isolation firewall rules)
   ```

2. **Check firewall rule order:**
   ```
   UniFi → Security → Firewall

   "Block Guest → LAN" rule MUST be BEFORE "Allow All → Internet"

   Correct order:
   Priority 10: Block Guest → LAN (DROP)
   Priority 9: Allow All → Internet (ACCEPT)
   ```

3. **Verify RFC1918 definition:**
   ```
   RFC1918 includes:
   - 10.0.0.0/8
   - 172.16.0.0/12
   - 192.168.0.0/16

   Firewall rule:
   Source: VLAN 50
   Destination: RFC1918
   Action: DROP
   ```

---

#### Poor WiFi Performance

**Symptoms:**
- Slow speeds on WiFi
- Frequent disconnects
- High latency

**Solutions:**

1. **Check AP placement:**
   ```
   - U6+ should be ceiling-mounted (not wall/desk)
   - Central location for best coverage
   - Avoid metal objects, microwaves, thick walls
   ```

2. **Optimize WiFi channels:**
   ```
   UniFi → U6+ AP → Settings → Radios

   2.4 GHz:
   - Channel Width: 20 MHz (HT20)
   - Channel: Auto OR manually select 1, 6, or 11

   5 GHz:
   - Channel Width: 40 MHz (VHT40) or 80 MHz (VHT80)
   - Channel: Auto OR manually select DFS channels
   ```

3. **Enable WiFi 6 features:**
   ```
   UniFi → U6+ AP → Settings

   - WiFi 6: Enabled
   - BSS Transition: Enabled (for roaming)
   - Fast Roaming: Enabled
   - UAPSD: Enabled (power save)
   ```

4. **Check client device limits:**
   ```
   U6+ can handle ~300 clients, but performance degrades after ~50

   UniFi → U6+ AP → Insights
   - Check client count per SSID
   - If >30 clients, consider adding another AP
   ```

5. **Monitor interference:**
   ```
   UniFi → U6+ AP → RF Scan
   - Run scan to see neighboring APs
   - If many APs on same channel, manually select different channel
   ```

---

#### Port Exhaustion on Lite-8

**Symptoms:**
- Need to connect more than 8 devices
- All ports in use

**Solutions:**

1. **Use PoE injectors for AP:**
   ```
   If you don't need PoE for other devices:
   - Remove U6+ from Lite-8
   - Use PoE injector for U6+
   - Frees up 1 port on Lite-8
   ```

2. **Add second switch downstream:**
   ```
   Purchase: USW-Lite-8-PoE (another) OR USW-16-PoE

   Topology:
   Lite-8 Port X → Second Switch Uplink

   Configure second switch port as Trunk (All VLANs)
   ```

3. **Upgrade to larger switch:**
   ```
   Replace Lite-8 with:
   - USW-16-PoE (16 ports, $299) OR
   - USW-24-PoE (24 ports, $499)

   Sell/repurpose Lite-8 for remote location
   ```

4. **Use WiFi for some devices:**
   ```
   Move wired devices to WiFi where possible:
   - Dell PC → WiFi
   - Chromecast → WiFi
   - Frees up wired ports for critical devices
   ```

---

#### Docker Containers Can't Reach Internet

**Symptoms:**
- `docker exec homeassistant ping 8.8.8.8` fails
- Containers show DNS resolution errors

**Solutions:**

1. **Check Docker host internet:**
   ```
   ping 8.8.8.8  # From Docker host
   ping google.com

   If this fails, host network config is wrong
   ```

2. **Verify DNS in containers:**
   ```
   docker exec homeassistant cat /etc/resolv.conf

   Should show:
   nameserver 127.0.0.11  (Docker DNS)

   Test resolution:
   docker exec homeassistant nslookup google.com
   ```

3. **Check Docker daemon DNS:**
   ```
   sudo nano /etc/docker/daemon.json

   {
     "dns": ["8.8.8.8", "1.1.1.1"]
   }

   sudo systemctl restart docker
   ```

4. **Verify masquerading/NAT:**
   ```
   # Docker creates iptables rules for NAT
   sudo iptables -t nat -L -n -v

   # Should see MASQUERADE rules for Docker networks
   ```

---

#### High CPU on UCG-Ultra

**Symptoms:**
- Slow response in UniFi interface
- Dropped packets
- High latency

**Solutions:**

1. **Disable IDS/IPS temporarily:**
   ```
   UniFi → Security → Threat Management
   - IDS/IPS: OFF (if not critical for your use)

   Note: IDS/IPS reduces throughput to ~500 Mbps on UCG-Ultra
   If you have >500 Mbps internet, consider disabling
   ```

2. **Reduce DPI (Deep Packet Inspection):**
   ```
   UniFi → Settings → Internet
   - DPI: OFF or Minimal

   DPI causes CPU overhead for traffic analysis
   ```

3. **Limit logging verbosity:**
   ```
   UniFi → Settings → System → Advanced
   - Logging Level: Warnings & Errors (not Debug/Info)
   ```

4. **Check for firmware bugs:**
   ```
   UniFi → UCG-Ultra → Settings → Firmware
   - Update to latest stable firmware
   - Check UniFi forums for known issues
   ```

---

## Post-Migration Tasks

### Documentation Updates

```bash
# Update network-topology.md with new VLANs
nano /home/hazzard/homeproject/docs/network-topology.md

# Update CLAUDE.md with new architecture
nano /home/hazzard/homeproject/CLAUDE.md

# Document UniFi credentials (use password manager):
- UniFi account email
- UniFi password
- UCG-Ultra local admin password
```

### Monitoring Setup

**1. UniFi Insights:**
```
Enable traffic analysis:
- Settings → Traffic → Enable
- Monitor bandwidth per VLAN
- Set up alerts for offline devices
```

**2. Grafana Dashboard:**
```
Create UniFi dashboard in Grafana:
- Monitor UCG-Ultra CPU/memory
- Track per-VLAN bandwidth
- Alert on high latency/packet loss
```

**3. Home Assistant Automations:**
```
Create notifications for:
- Device goes offline (ESP32, smart plugs)
- High network latency
- Internet connection drop
```

### Security Hardening

**1. Change Default Passwords:**
```
- UniFi account password (if using default)
- UCG-Ultra local admin password
- WiFi SSID passwords (if using temporary ones)
```

**2. Enable 2FA:**
```
UniFi account (unifi.ui.com):
- Profile → Security → Enable 2FA
- Use authenticator app (Google Authenticator, Authy)
```

**3. Review Firewall Logs:**
```
UniFi → Security → Firewall → Logs
- Check for unexpected blocked traffic
- Verify rules are working as intended
- Look for brute-force attempts on Guest VLAN
```

**4. Enable Automatic Firmware Updates (optional):**
```
UniFi → Settings → System → Automatic Updates
- Auto-update: Enabled (or Manual for control)
- Email notifications: Enabled
```

### Future Expansion

**Available IP Ranges:**
```
VLAN 10 (Servers):
  - 192.168.10.100-199 available for DHCP
  - 192.168.10.200-202 reserved for static (NAS, servers)

VLAN 20 (Trusted):
  - 192.168.20.31-50 reserved for workstations
  - 192.168.20.100-254 available

VLAN 30 (IoT):
  - 192.168.30.122-139 reserved for future ESP32s
  - 192.168.30.114-119 reserved for smart plugs
  - 192.168.30.200-254 DHCP pool

VLAN 40 (Media):
  - 192.168.40.100-254 available

VLAN 50 (Guest):
  - 192.168.50.100-254 DHCP only
```

**Adding NAS to VLAN 10:**
```
1. Connect NAS → Lite-8 Port 7
2. Configure NAS with static IP: 192.168.10.200
3. Create DHCP reservation in UniFi (optional)
4. Test access from Trusted VLAN (workstation)
5. Update Plex/Sonarr/Radarr to use new NAS IP
```

**Adding More APs:**
```
If WiFi coverage insufficient:

1. Purchase: U6+ or U6-LR (long range)
2. Run Cat6 to new location
3. Connect to any available switch port (configured as Trunk)
4. UniFi will auto-discover and adopt
5. Configure same SSIDs on new AP
6. Devices will roam between APs automatically
```

**Adding IP Cameras (Future):**
```
Create new VLAN 60 (Cameras):
  - Subnet: 192.168.60.0/24
  - Gateway: 192.168.60.1
  - Isolated from all VLANs except Servers

Firewall rules:
  - Allow Cameras → NVR (VLAN 10)
  - Allow Trusted → Cameras (for viewing)
  - Block everything else

Connect cameras to PoE ports or add PoE+ switch
```

---

## Quick Reference

### Key IP Addresses

| Device | New IP | Old IP | VLAN |
|--------|--------|--------|------|
| **UCG-Ultra** | 192.168.1.1 | N/A | 1 |
| **Lite-8 Switch** | 192.168.1.2 | N/A | 1 |
| **U6+ AP** | 192.168.1.3 | N/A | 1 |
| **Main Server** | 192.168.10.201 | 192.168.40.201 | 10 |
| **NAS (future)** | 192.168.10.200 | 192.168.40.200 | 10 |
| **Creality Server** | 192.168.10.202 | 192.168.40.202 | 10 |
| **Main Workstation** | 192.168.20.31 | 192.168.40.13 | 20 |
| **Dell PC** | 192.168.20.32 | 192.168.40.226 | 20 |
| **Living Room Voice** | 192.168.30.120 | 192.168.40.120 | 30 |
| **Office Voice** | 192.168.30.121 | 192.168.40.121 | 30 |
| **TP-Link Plug #1** | 192.168.30.110 | 192.168.40.110 | 30 |
| **TP-Link Plug #2** | 192.168.30.111 | 192.168.40.111 | 30 |
| **Ecobee** | 192.168.30.160 | 192.168.40.104 | 30 |
| **Samsung Range** | 192.168.30.140 | 192.168.40.105 | 30 |
| **Samsung Fridge** | 192.168.30.141 | 192.168.40.106 | 30 |
| **Google Nest Hub** | 192.168.30.100 | 192.168.40.100 | 30 |
| **Google Nest Audio** | 192.168.30.102 | 192.168.40.102 | 30 |
| **Roku TV** | 192.168.40.99 | 192.168.40.99 | 40 |
| **Chromecast** | 192.168.40.101 | 192.168.40.101 | 40 |

### Service URLs (After Migration)

| Service | New URL | Notes |
|---------|---------|-------|
| **Home Assistant** | http://192.168.10.201:8123 | Accessible from Trusted VLAN |
| **ESPHome** | http://192.168.10.201:6052 | Admin only |
| **Plex** | http://192.168.10.201:32400/web | All VLANs (firewall rules) |
| **n8n** | http://192.168.10.201:5678 | Trusted VLAN only |
| **Open WebUI** | http://192.168.10.201:3000 | Trusted VLAN only |
| **Grafana** | http://192.168.10.201:3001 | Trusted VLAN only |
| **Portainer** | http://192.168.10.201:9000 | Trusted VLAN only |
| **UniFi Network** | https://unifi.ui.com | Remote access |
| **UniFi Network (local)** | https://192.168.1.1 | UCG-Ultra IP |

### Emergency Contacts

- **UniFi Support:** https://help.ui.com
- **UniFi Community:** https://community.ui.com
- **Your ISP Support:** [Your ISP phone/website]

### Backup Locations

```
Pre-migration backups:
  /home/hazzard/ha-backup-YYYYMMDD.tar.gz
  /home/hazzard/docker-backup-YYYYMMDD.tar.gz
  /home/hazzard/network-config-old.txt

UniFi configuration backups:
  UniFi app → Settings → System → Backup
  Auto-saved to cloud (if enabled)
  Manual: Download from Settings → System → Backup → Download
```

---

**Document Version:** 1.0
**Created:** 2025-01-01
**Last Updated:** 2025-01-01
**Migration Status:** Pre-migration planning

---

**Good luck with your migration! 🚀**

Remember:
- Take your time, no need to rush
- Test each phase before moving to next
- Keep ISP router nearby for quick rollback
- Document any issues for troubleshooting
- Weekend project = plenty of time to troubleshoot

If you run into issues, refer to the Troubleshooting section or roll back and try again another day.
