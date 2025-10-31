# ESP32 Development Projects

This directory contains all ESP32 development projects, examples, and resources.

## Directory Structure

### `esphome-dev/`
Development and testing ESPHome configurations before deploying to production.

- Test new sensors and components here first
- Production configs live in `/home/hazzard/home-assistant/esphome/`
- Copy tested configs to production when ready

**Quick Start:**
```bash
# Create new device config
cp examples/basic-sensor.yaml esphome-dev/test-device.yaml

# Compile and test via ESPHome container
docker exec -it esphome esphome compile /config/../../../homeproject/esp32/esphome-dev/test-device.yaml
```

### `arduino-projects/`
Traditional Arduino IDE projects (.ino files).

Good for:
- Learning C++ basics
- Quick prototypes
- Using Arduino-specific libraries

### `platformio-projects/`
PlatformIO projects for more advanced development.

Advantages over Arduino:
- Better library management
- Multiple board support
- Built-in unit testing
- VS Code integration

### `libraries/`
Custom libraries and components you develop.

- Reusable code across projects
- Custom sensor drivers
- Helper functions

### `examples/`
Starter projects and code examples.

- Copy these as templates for new projects
- Organized by complexity (beginner, intermediate, advanced)

### `schematics/`
Wiring diagrams and circuit schematics.

- Fritzing files (.fzz)
- KiCad projects
- Hand-drawn diagrams (photos/scans)
- Connection reference sheets

### `docs/`
Learning resources and project documentation.

- ESP32 pinout diagrams
- Component datasheets
- Project notes and lessons learned

### `components-inventory/`
Track your components and parts.

- Inventory list (CSV or markdown)
- Component specifications
- Purchase links and sources
