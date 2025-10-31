# Network Device Map

**Quick reference for all devices on 192.168.40.0/24**
**Last Updated:** 2025-10-30

## Complete Device List

| IP | Device Name | Type | Location | Integration |
|----|-------------|------|----------|-------------|
| .1 | Gateway/Router | ISP Router | - | - |
| .13 | Main Computer | Ryzen R7 PC | - | Wake-on-LAN |
| .99 | Living Room Roku TV | Smart TV | Living Room | Roku HA Integration |
| .100 | Google Nest Hub | Smart Display | Kitchen | Google Assistant |
| .101 | Living Room Chromecast | Streaming Device | Living Room (Roku HDMI1) | Cast Integration |
| .102 | Google Nest Audio | Smart Speaker | Bedroom | Google Assistant |
| .104 | Ecobee Thermostat | Smart Thermostat | - | Ecobee HA Integration |
| .107 | Living Room Voice | ESP32 M5Stack | Living Room | ESPHome ✓ |
| .108 | Office Voice | ESP32 M5Stack | Office | ESPHome ✓ (offline) |
| .110 | TP-Link Smart Plug | Smart Plug | Bedroom (Fan) | Kasa HA Integration |
| .200 | NAS/File Server | Storage Server | - | CIFS/SMB Mount |
| .201 | Docker Host | Linux Server | - | Home Assistant Host |
| .226 | Dell PC | Windows PC | - | SMB File Sharing |
| .250 | Google Pixel 10 Pro | Android Phone | - | Mobile App |

## Devices by Room

### Living Room
- 192.168.40.99 - Roku TV (Wired)
- 192.168.40.101 - Chromecast (on Roku HDMI1)
- 192.168.40.107 - Voice Assistant (ESP32)

### Kitchen
- 192.168.40.100 - Google Nest Hub

### Bedroom
- 192.168.40.102 - Google Nest Audio
- 192.168.40.110 - TP-Link Smart Plug (Fan)

### Office
- 192.168.40.108 - Voice Assistant (ESP32, currently offline)

### Unassigned Location
- 192.168.40.13 - Main Computer
- 192.168.40.104 - Ecobee Thermostat
- 192.168.40.200 - NAS/File Server
- 192.168.40.201 - Docker Host (Home Assistant)
- 192.168.40.226 - Dell PC

## Devices by Category

### Infrastructure (4)
- .1 - Gateway/Router
- .13 - Main Computer (Ryzen R7)
- .200 - NAS/File Server
- .201 - Docker Host
- .226 - Dell PC

### Smart Home (6)
- .100 - Google Nest Hub (Kitchen)
- .102 - Google Nest Audio (Bedroom)
- .104 - Ecobee Thermostat
- .107 - ESP32 Voice (Living Room) ✓
- .108 - ESP32 Voice (Office) ✓
- .110 - TP-Link Smart Plug (Bedroom Fan)

### Entertainment (2)
- .99 - Roku TV (Living Room)
- .101 - Chromecast (Living Room)

### Mobile (1)
- .250 - Google Pixel 10 Pro

## Home Assistant Integration Status

### ✅ Fully Integrated (10 devices)
- **Living Room Voice** (.107) - ESPHome
- **Office Voice** (.108) - ESPHome
- **Ecobee Thermostat** (.104) - HomeKit Controller
- **TP-Link Smart Plug** (.110) - TP-Link Kasa (Bedroom Fan)
- **Roku TV** (.99) - Roku integration (43" TCL)
- **Google Nest Hub** (.100) - Google Cast
- **Google Nest Audio** (.102) - Google Cast
- **Chromecast** (.101) - Google Cast + Android TV Remote
- **Google Pixel 10 Pro** (.250) - Mobile App with sensors
- **Plex Server** (.201) - Plex integration

### 🔧 Optional Integration
- **Main Computer** (.13) - Wake-on-LAN
- **Dell PC** (.226) - Wake-on-LAN, SMB access

## Available IP Ranges

### Currently Used
- .1 - Gateway
- .13 - Main Computer
- .99-102 - Entertainment/Smart Home
- .104 - Thermostat
- .107-108 - ESP32 devices
- .110 - Smart Plug
- .200-201 - Infrastructure
- .226 - Dell PC
- .250 - Phone (DHCP)

### Available for Future ESP32 Projects
**Recommended Range:** 192.168.40.111-130 (20 addresses)
- .109 - Available
- .111-130 - Available (reserved for ESP32)

### Recommended DHCP Pool
- .131-254 - Guest devices, temporary connections

## Integration Priority

### High Priority (Immediate Value)
1. **Ecobee Thermostat** (.104)
   - Climate control automation
   - Temperature sensors
   - Smart scheduling

2. **TP-Link Smart Plug** (.110)
   - Automate bedroom fan
   - Energy monitoring
   - Schedules and scenes

3. **Roku TV** (.99)
   - Media control from HA
   - Automation triggers
   - Dashboard integration

### Medium Priority (Enhanced Features)
4. **Google Cast Devices** (.100, .101, .102)
   - TTS announcements
   - Media casting
   - Multi-room audio

### Low Priority (Nice to Have)
5. **Wake-on-LAN** for computers (.13, .226)
   - Remote power on
   - Shutdown automation

## Network Health

### Active Devices: 14
### ESP32 Devices: 2 (1 offline)
### Integration Opportunities: 6
### IP Utilization: 14/254 (5.5%)

## Quick Actions

### Add Ecobee to Home Assistant
```
Settings → Devices & Services → Add Integration → Ecobee
```

### Add TP-Link Kasa to Home Assistant
```
Settings → Devices & Services → Add Integration → TP-Link Kasa Smart
```

### Add Roku to Home Assistant
```
Settings → Devices & Services → Add Integration → Roku
```

### Set Static IP Reservations (via router app)
Recommended static reservations:
- Smart home devices: .100, .102, .104, .110
- Entertainment: .99, .101
- Computers: .13, .226 (if always-on)

## Notes

- **Google Ecosystem:** 3 devices (.100, .102, .101) - consider unified Google Assistant integration
- **ESP32 Projects:** Reserve .111-130 range for future builds
- **Living Room Setup:** TV + Chromecast + Voice Assistant all within .99-107
- **Dell PC** (.226) has file sharing enabled - verify security settings
- **Pixel 10 Pro** uses DHCP - IP may change

---

**For detailed information, see:**
- Full network topology: `/home/hazzard/homeproject/docs/network-topology.md`
- Device analysis: `/home/hazzard/homeproject/docs/device-identification-analysis.md`
