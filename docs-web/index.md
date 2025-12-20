# Home Automation & IoT Project Hub

Central planning and development workspace for home automation, IoT devices, and ESP32 projects.

## 📁 Directory Structure

```
homeproject/
├── CLAUDE.md                      # AI assistant guidance for this codebase
├── README.md                      # This file
├── esp32/                         # ESP32 development projects
│   ├── esphome-dev/              # Development ESPHome configs
│   ├── arduino-projects/         # Arduino IDE projects
│   ├── platformio-projects/      # PlatformIO projects
│   ├── libraries/                # Custom libraries
│   ├── examples/                 # Example code (basic-sensor, relay, multi-sensor)
│   ├── schematics/               # Wiring diagrams
│   ├── docs/                     # ESP32 reference materials
│   └── components-inventory/     # Parts tracking
└── docs/                         # Project documentation
    ├── esp32-starter-projects.md       # 18 project ideas with progression
    ├── electronics-workbench-build.md  # Complete workbench setup guide
    ├── guides/                         # How-to guides
    └── datasheets/                     # Component datasheets
```

## 🚀 Quick Start

### For ESP32 Development

1. **Read the docs:**
   - [`esp32/README.md`](esp32/README.md) - Project structure overview
   - [`esp32/docs/esp32-quick-reference.md`](esp32/docs/esp32-quick-reference.md) - Pin layouts, common patterns

2. **Copy an example:**
   ```bash
   cd /home/hazzard/homeproject/esp32/esphome-dev
   cp ../examples/basic-sensor.yaml my-first-device.yaml
   # Edit secrets.yaml with your WiFi credentials
   ```

3. **Compile via ESPHome:**
   - Web UI: http://localhost:6052
   - Or CLI: `docker exec -it esphome esphome compile /config/my-first-device.yaml`

### For Project Ideas

Check out [`docs/esp32-starter-projects.md`](docs/esp32-starter-projects.md):
- **Beginner:** LED blink, temperature monitor, relay control
- **Intermediate:** Multi-sensor nodes, plant monitor, door sensors
- **Advanced:** Voice assistant, energy monitoring, weather station

### For Workbench Setup

See [`docs/electronics-workbench-build.md`](docs/electronics-workbench-build.md):
- Complete tool list with costs
- Component inventory recommendations
- Storage and organization tips
- Budget breakdowns ($300 starter to $1500+ advanced)

## 🏠 Production Infrastructure

Your existing home automation setup is documented in [`CLAUDE.md`](CLAUDE.md).

**Key Services:**
- **Home Assistant** (port 8123) - `/home/hazzard/home-assistant/`
- **ESPHome** (port 6052) - Production configs in `/home/hazzard/home-assistant/esphome/`
- **Ollama AI** (port 11434) - `/home/hazzard/ollama/`
- **n8n Automation** (port 5678) - `/home/hazzard/n8n/`
- **Grafana** (port 3001) - Metrics visualization
- **MQTT Broker** (port 1883) - IoT device communication

**Network:** 192.168.40.0/24
**Current ESP32 Devices:**
- Living Room Voice (192.168.40.107)
- Office Voice

## 📚 Documentation Index

| Document | Purpose |
|----------|---------|
| [`CLAUDE.md`](CLAUDE.md) | Complete system architecture, common commands, production service details |
| [`esp32/README.md`](esp32/README.md) | ESP32 project structure and workflow |
| [`esp32/docs/esp32-quick-reference.md`](esp32/docs/esp32-quick-reference.md) | GPIO pins, ESPHome platforms, troubleshooting |
| [`docs/esp32-starter-projects.md`](docs/esp32-starter-projects.md) | 18 progressive project ideas from beginner to advanced |
| [`docs/electronics-workbench-build.md`](docs/electronics-workbench-build.md) | Complete workbench requirements, tools, budget |
| [`docs/home-assistant-integrations.md`](docs/home-assistant-integrations.md) | List of installed Home Assistant integrations |

## 🎯 Learning Path

### Phase 1: Get Started (1-2 weeks)
1. Build electronics workbench (order tools/components)
2. Set up workspace with proper lighting and power
3. Flash first ESP32 with basic LED blink example
4. **First Project:** Temperature monitor (DHT22 sensor)

### Phase 2: Build Skills (1-2 months)
5. **Project 2:** Smart lamp with relay control
6. **Project 3:** Motion sensor for automation
7. Learn I2C communication with BME280
8. Create first multi-sensor node

### Phase 3: Advanced Projects (Ongoing)
9. RGB lighting with effects
10. Plant monitoring system
11. Door/window sensor network
12. Energy monitoring
13. Custom voice assistant endpoints

## 🔗 Useful Links

### Your Services
- Home Assistant: http://localhost:8123
- ESPHome Dashboard: http://localhost:6052
- Grafana: http://localhost:3001
- Ollama/Open-WebUI: http://localhost:3000
- n8n: http://localhost:5678
- Portainer: http://localhost:9000

### External Resources
- [ESPHome Documentation](https://esphome.io/)
- [Home Assistant Docs](https://www.home-assistant.io/)
- [ESP32 Datasheet](https://www.espressif.com/en/products/socs/esp32)
- [r/homeassistant](https://reddit.com/r/homeassistant)
- [r/esp32](https://reddit.com/r/esp32)

## 📝 Project Tracking

Keep track of your projects:

1. **Current Active Projects:** (list here)
2. **Completed Projects:** (list here)
3. **Planned Projects:** (reference docs/esp32-starter-projects.md)

Update [`esp32/components-inventory/inventory.md`](esp32/components-inventory/inventory.md) as you acquire parts.

## 💡 Tips

- **Start simple:** Don't jump to complex projects immediately
- **Document everything:** Take photos, notes, lessons learned
- **Reuse code:** Copy working configs, build a personal library
- **Test in dev first:** Use `esp32/esphome-dev/` before deploying to production
- **Ask for help:** ESPHome and Home Assistant communities are very helpful
- **Safety first:** Review workbench safety guidelines before starting

## 🛠️ Contributing to This Project

This is your personal project hub! Keep it organized:

- Add new projects to appropriate directories
- Update CLAUDE.md when infrastructure changes
- Document lessons learned in `docs/`
- Keep component inventory up to date
- Take photos of builds and save in `esp32/schematics/`

---

**Timezone:** Canada/Eastern
**Last Updated:** 2025-10-29

Happy building! 🚀
