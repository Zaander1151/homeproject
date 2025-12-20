# IP Address Migration Plan

**Created:** 2025-12-03
**Status:** Pending Implementation
**Reference:** [network-topology.md](network-topology.md)

> **📋 Purpose:** This document provides a step-by-step plan to migrate devices from their current IP addresses to the organized block allocation scheme.

---

## Migration Overview

**Total Devices to Move:** 8 devices
**Estimated Time:** 2-3 hours (with testing)
**Risk Level:** Low (if done carefully with static DHCP reservations)

### Why Migrate?

- ✅ **Organization:** Group devices by type for easier management
- ✅ **Scalability:** Free up contiguous blocks for future expansion
- ✅ **Troubleshooting:** IP address indicates device type at a glance
- ✅ **Documentation:** Matches documented IP allocation scheme

---

## Pre-Migration Checklist

- [ ] **Backup router configuration** (export settings)
- [ ] **Document current working state** (all services operational)
- [ ] **Schedule maintenance window** (minimal service disruption)
- [ ] **Have physical access** to ESP32 devices (may need manual reboot)
- [ ] **Prepare rollback plan** (can revert to old IPs if issues)

---

## Migration Plan by Priority

### Priority 1: ESP32 Devices (Critical)

**Why First:** ESP32 devices require ESPHome config updates and are critical for voice assistant functionality.

| Device | Current IP | New IP | Block | ESPHome Config File |
|--------|-----------|--------|-------|---------------------|
| **Living Room Voice** | 192.168.40.107 | **192.168.40.120** | ESP32 & Custom IoT | `living-room-voice.yaml` |
| **Office Voice** | 192.168.40.108 | **192.168.40.121** | ESP32 & Custom IoT | `office-voice.yaml` |

**Steps:**

1. **Update ESPHome Configuration Files:**
   ```bash
   cd /home/hazzard/home-assistant/esphome

   # Edit living-room-voice.yaml
   # Change: static_ip: 192.168.40.107
   # To:     static_ip: 192.168.40.120

   # Edit office-voice.yaml
   # Change: static_ip: 192.168.40.108
   # To:     static_ip: 192.168.40.121
   ```

2. **Update Router DHCP Reservations:**
   - Remove old reservations: .107, .108
   - Add new reservations: .120 (MAC: f4:65:0b:01:cf:84), .121 (MAC: 00:4b:12:a1:1a:74)

3. **Compile and Upload New Firmware:**
   ```bash
   # Via ESPHome Dashboard (http://192.168.40.201:6052)
   # Or via command line:
   docker exec esphome esphome compile living-room-voice.yaml
   docker exec esphome esphome upload living-room-voice.yaml
   docker exec esphome esphome compile office-voice.yaml
   docker exec esphome esphome upload office-voice.yaml
   ```

4. **Verify:**
   - Devices reconnect automatically
   - Test voice assistant functionality
   - Check Home Assistant integration still works

**Rollback Plan:**
- Revert ESPHome config files to .107/.108
- Recompile and upload
- Restore old DHCP reservations

---

### Priority 2: Workstations (Low Impact)

**Why Second:** Workstations can be easily updated and tested.

| Device | Current IP | New IP | Block | Notes |
|--------|-----------|--------|-------|-------|
| **Main Computer** | 192.168.40.13 | **192.168.40.31** | Workstations & PCs | Ryzen R7, NVIDIA 5060 |
| **Dell PC** | 192.168.40.226 | **192.168.40.32** | Workstations & PCs | Windows, file sharing |

**Steps:**

1. **Update Router DHCP Reservations:**
   - Main Computer: MAC 10:ff:e0:ca:b2:8c → .31
   - Dell PC: MAC e4:b9:7a:f6:c3:05 → .32
   - Remove old reservations: .13, .226

2. **Reboot Workstations:**
   - Option A: Reboot both computers to get new IPs
   - Option B: Release/renew DHCP lease manually

3. **Update Static IP (if configured locally):**
   - If Main Computer has static IP in network settings, update to .31
   - If Dell PC has static IP in network settings, update to .32

4. **Verify:**
   - Check network connectivity
   - Test file sharing (Dell PC)
   - Verify SSH access if applicable

**Rollback Plan:**
- Restore old DHCP reservations
- Reboot to get old IPs back

---

### Priority 3: Climate Devices (Low Impact)

**Why Third:** Single device, low integration complexity.

| Device | Current IP | New IP | Block | Notes |
|--------|-----------|--------|-------|-------|
| **Ecobee Thermostat** | 192.168.40.104 | **192.168.40.160** | Climate & Environmental | Home Assistant integrated |

**Steps:**

1. **Update Router DHCP Reservation:**
   - Ecobee: MAC 44:61:32:8a:99:74 → .160
   - Remove old reservation: .104

2. **Check Home Assistant Integration:**
   - Ecobee integration uses cloud API (not local IP)
   - IP change should not affect functionality

3. **Power Cycle Thermostat:**
   - Option A: Wait for DHCP lease renewal
   - Option B: Power off/on at breaker for immediate change

4. **Verify:**
   - Thermostat online and responsive
   - Home Assistant can still control it
   - Temperature readings updating

**Rollback Plan:**
- Restore old DHCP reservation to .104
- Power cycle thermostat

---

### Priority 4: Smart Appliances (Low Impact)

**Why Last:** Samsung appliances may use cloud integration, IP change less critical.

| Device | Current IP | New IP | Block | Notes |
|--------|-----------|--------|-------|-------|
| **Samsung Smart Range** | 192.168.40.105 | **192.168.40.140** | Smart Appliances | SmartThings compatible |
| **Samsung Smart Refrigerator** | 192.168.40.106 | **192.168.40.141** | Smart Appliances | SmartThings compatible |

**Steps:**

1. **Update Router DHCP Reservations:**
   - Range: MAC 28:6b:b4:12:0d:16 → .140
   - Refrigerator: MAC 28:6b:b4:1a:df:ac → .141
   - Remove old reservations: .105, .106

2. **Check SmartThings Integration:**
   - Samsung appliances typically use Samsung cloud
   - IP change should not affect cloud connectivity

3. **Power Cycle Appliances:**
   - Option A: Wait for DHCP lease renewal (may take hours/days)
   - Option B: Unplug and replug (if accessible)
   - Option C: Circuit breaker off/on (if dedicated circuits)

4. **Verify:**
   - Appliances reconnect to WiFi
   - SmartThings app shows devices online
   - Test remote control functions

**Rollback Plan:**
- Restore old DHCP reservations to .105/.106
- Power cycle appliances

---

## Devices That Should NOT Move

These devices are already in the correct IP blocks:

| Device | IP | Block | Status |
|--------|-----|-------|--------|
| **Gateway/Router** | .1 | Infrastructure | ✓ Correct |
| **Office Network Switch** | .20 | Infrastructure | ✓ Correct |
| **NAS/File Server** | .200 | Critical Infrastructure | ✓ Correct |
| **Docker Host** | .201 | Critical Infrastructure | ✓ Correct |
| **Creality Slicer Server** | .202 | Critical Infrastructure | ✓ Correct |
| **Living Room Roku TV** | .99 | Media Devices | ✓ Correct |
| **Living Room Chromecast** | .101 | Media Devices | ✓ Correct |
| **Google Nest Hub** | .100 | Smart Home Hubs | ✓ Correct |
| **Google Nest Audio** | .102 | Smart Home Hubs | ✓ Correct |
| **TP-Link Smart Plug #1** | .110 | Smart Plugs | ✓ Correct |
| **TP-Link Smart Plug #2** | .111 | Smart Plugs | ✓ Correct |

---

## Migration Execution Checklist

### Before Starting

- [ ] Backup router configuration
- [ ] All services currently operational
- [ ] ESPHome config files backed up
- [ ] Physical access to ESP32 devices available
- [ ] Maintenance window scheduled

### Priority 1: ESP32 Devices

- [ ] Update `living-room-voice.yaml` (.107 → .120)
- [ ] Update `office-voice.yaml` (.108 → .121)
- [ ] Update router DHCP reservations for .120, .121
- [ ] Remove old DHCP reservations for .107, .108
- [ ] Compile ESPHome firmware
- [ ] Upload to Living Room Voice
- [ ] Upload to Office Voice
- [ ] Verify Living Room Voice reconnects
- [ ] Verify Office Voice reconnects
- [ ] Test voice assistant functionality
- [ ] Check Home Assistant integration

### Priority 2: Workstations

- [ ] Update router DHCP reservation: Main Computer → .31
- [ ] Update router DHCP reservation: Dell PC → .32
- [ ] Remove old DHCP reservations for .13, .226
- [ ] Update static IP on Main Computer (if configured)
- [ ] Update static IP on Dell PC (if configured)
- [ ] Reboot Main Computer
- [ ] Reboot Dell PC
- [ ] Verify Main Computer network connectivity
- [ ] Verify Dell PC network connectivity
- [ ] Test file sharing on Dell PC

### Priority 3: Climate

- [ ] Update router DHCP reservation: Ecobee → .160
- [ ] Remove old DHCP reservation for .104
- [ ] Power cycle Ecobee thermostat
- [ ] Verify thermostat online
- [ ] Test Home Assistant control

### Priority 4: Appliances

- [ ] Update router DHCP reservation: Range → .140
- [ ] Update router DHCP reservation: Refrigerator → .141
- [ ] Remove old DHCP reservations for .105, .106
- [ ] Power cycle Samsung Range
- [ ] Power cycle Samsung Refrigerator
- [ ] Verify Range reconnects
- [ ] Verify Refrigerator reconnects
- [ ] Test SmartThings app control

### Post-Migration

- [ ] All devices online and functional
- [ ] Update documentation with "Completed" status
- [ ] Run network scan to verify new IPs
- [ ] Update network-topology.md if needed
- [ ] Test all automations and integrations
- [ ] Monitor for 24-48 hours for issues

---

## Post-Migration Verification

### Network Scan

```bash
# Scan network to verify new IPs
sudo nmap -sn 192.168.40.0/24

# Expected results:
# 192.168.40.31  - Main Computer (was .13)
# 192.168.40.32  - Dell PC (was .226)
# 192.168.40.120 - Living Room Voice (was .107)
# 192.168.40.121 - Office Voice (was .108)
# 192.168.40.140 - Samsung Range (was .105)
# 192.168.40.141 - Samsung Refrigerator (was .106)
# 192.168.40.160 - Ecobee Thermostat (was .104)
```

### Service Checks

```bash
# Test ESP32 devices
ping 192.168.40.120  # Living Room Voice
ping 192.168.40.121  # Office Voice

# Check Home Assistant integration
curl http://192.168.40.201:8123/api/states | grep -i "living_room_voice\|office_voice"

# Verify ESPHome can see devices
docker exec esphome esphome logs living-room-voice.yaml --device 192.168.40.120
```

### Home Assistant Integration

1. Open Home Assistant: http://192.168.40.201:8123
2. Check **Settings → Devices & Services → ESPHome**
3. Verify both voice assistants are "Connected"
4. Test voice assistant: "OK Nabu, what time is it?"

---

## Troubleshooting

### ESP32 Device Won't Reconnect

**Problem:** ESP32 device offline after IP change

**Solution:**
1. Check router DHCP reservation is correct
2. Power cycle ESP32 device (unplug/replug)
3. Check ESPHome logs: `docker logs -f esphome`
4. If still offline, connect via USB and upload firmware manually
5. Check WiFi credentials in ESPHome config

### Home Assistant Can't Find ESP32

**Problem:** Home Assistant shows ESP32 as unavailable

**Solution:**
1. Restart Home Assistant: Settings → System → Restart
2. Check ESPHome integration: Settings → Devices & Services → ESPHome
3. Remove and re-add device if necessary
4. Check mDNS discovery: `docker exec homeassistant avahi-browse -a`

### Workstation Can't Get New IP

**Problem:** Computer still using old IP address

**Solution:**
1. Verify DHCP reservation is correct in router
2. Release and renew DHCP lease:
   - **Linux:** `sudo dhclient -r && sudo dhclient`
   - **Windows:** `ipconfig /release && ipconfig /renew`
3. Reboot computer
4. Check for static IP configuration locally (override DHCP)

### Device Lost After Migration

**Problem:** Can't find device on network after IP change

**Solution:**
1. Run network scan: `sudo nmap -sn 192.168.40.0/24`
2. Check router DHCP leases page
3. Look for device by MAC address
4. Power cycle device to force DHCP renewal
5. Restore old DHCP reservation if needed

---

## Rollback Procedures

### Emergency Rollback (All Devices)

If multiple issues occur, revert all changes:

1. **Restore router DHCP reservations to old IPs**
2. **Revert ESPHome configs:**
   ```bash
   cd /home/hazzard/home-assistant/esphome
   git checkout living-room-voice.yaml office-voice.yaml
   # Or manually change IPs back to .107, .108
   ```
3. **Recompile and upload ESP32 firmware**
4. **Reboot all affected devices**
5. **Verify all services operational**

### Partial Rollback (Single Device)

If one device has issues:

1. Restore old DHCP reservation for that device only
2. Revert config files if applicable (ESP32)
3. Power cycle device
4. Continue migration for other devices

---

## Future IP Assignments

After migration, use these blocks for new devices:

| Block | Available IPs | Use For |
|-------|--------------|---------|
| **ESP32 (.120-.139)** | .122-.139 (18 IPs) | Additional M5Stack, custom sensors |
| **Workstations (.31-.50)** | .33-.50 (18 IPs) | Laptops, development machines |
| **Smart Plugs (.110-.119)** | .112-.119 (8 IPs) | More TP-Link/Shelly devices |
| **Smart Appliances (.140-.159)** | .142-.159 (18 IPs) | Washer, dryer, dishwasher |
| **Climate (.160-.179)** | .161-.179 (19 IPs) | Temperature sensors, air quality |
| **Security (.180-.199)** | .180-.199 (20 IPs) | IP cameras, doorbells, motion sensors |

---

## Notes

- **DHCP Lease Time:** Check router settings for lease duration (typically 24 hours)
- **Service Disruption:** ESP32 migration will cause ~5 minutes voice assistant downtime
- **Best Time:** Perform migration during low-usage hours (early morning/late evening)
- **Testing:** Test each priority level before moving to the next
- **Documentation:** Update network-topology.md after successful migration

---

**Document Status:** Ready for Implementation
**Last Updated:** 2025-12-03
**Next Review:** After migration completion
