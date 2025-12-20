# GEMINI.md

## ACTIVE PROJECT: XIAO C6 Climate Sensor
**CRITICAL:** Before starting any work on environmental sensors, READ the following file for the proven hardware configuration, pin mappings, and current status:
*   `docs-web/projects/xiao-c6-bme280-build.md`

---

This file provides guidance to the Gemini AI assistant when working within this repository.

## Directory Overview

This directory, `/home/hazzard/homeproject`, serves as a central hub for planning, documentation, and development of a comprehensive home automation and IoT ecosystem. It is not a traditional software project with a buildable artifact, but rather a well-organized collection of documentation, configuration examples, and project plans for ESP32-based devices and the surrounding infrastructure.

The primary focus is on ESP32 development using ESPHome, integrated with a Home Assistant-centric smart home setup. The project is meticulously documented, with detailed guides for setting up a workbench, project ideas, and in-depth architecture documentation of the entire production system.

## Key Files

*   **`README.md`**: The main entry point for understanding the project. It provides a high-level overview of the directory structure, quick start guides for ESP32 development, project ideas, and links to key documentation files.

*   **`CLAUDE.md`**: The most critical document in this repository. It contains a detailed, in-depth description of the entire home automation infrastructure, including:
    *   System architecture, with a breakdown of all services (Home Assistant, ESPHome, Ollama, n8n, etc.).
    *   Docker container configurations and network setups.
    *   Common commands for managing the various services.
    *   ESP32 development patterns and templates.
    *   Security considerations and data persistence strategies.

*   **`docs/`**: A directory containing all project-related documentation.
    *   `electronics-workbench-build.md`: A complete guide to setting up an electronics workbench.
    *   `esp32-starter-projects.md`: A list of project ideas for ESP32 development, from beginner to advanced.

*   **`esp32/`**: A directory dedicated to ESP32 development.
    *   `examples/`: Example ESPHome configurations for various sensors and devices.
    *   `esphome-dev/`: A directory for developing and testing new ESPHome configurations.
    *   `components-inventory/inventory.md`: A markdown file for tracking electronic components.

## Usage

This directory is intended to be used as a reference and workspace for all home automation and IoT projects.

*   **For ESP32 Development:**
    1.  Consult `CLAUDE.md` and `esp32/README.md` to understand the existing ESP32 setup and development patterns.
    2.  Use the `esp32/examples/` as templates for new devices.
    3.  Develop and test new configurations in the `esp32/esphome-dev/` directory.
    4.  Refer to `docs/esp32-starter-projects.md` for new project ideas.

*   **For System Administration:**
    1.  `CLAUDE.md` is the primary source of truth for the entire system architecture.
    2.  Use the "Common Commands" section in `CLAUDE.md` to manage the Docker containers and services.

*   **For Project Planning:**
    1.  Use the `docs/` directory to store new documentation and project plans.
    2.  Update `esp32/components-inventory/inventory.md` when new components are acquired.

## System Architecture Overview

The home automation system is built around a collection of Docker containers, orchestrated with `docker-compose`. The core components are:

*   **Home Assistant:** The central hub for automation and device control.
*   **ESPHome:** For building and managing firmware for ESP32 devices.
*   **Ollama:** A local AI inference engine for running large language models.
*   **n8n:** A workflow automation tool.
*   **Monitoring Stack:** Prometheus, Grafana, and InfluxDB for system and sensor data monitoring.
*   **Media Stack:** Plex, Sonarr, Radarr, and qBittorrent for media management.

All services are interconnected through Docker networks and are securely exposed to the internet via a Cloudflare Tunnel.

## Common Commands

The following are some of the most common commands used to manage the system, as documented in `CLAUDE.md`:

*   **View all running containers:** `docker ps -a`
*   **View container logs:** `docker logs -f <container_name>`
*   **Restart a service:** `docker restart <container_name>`
*   **Start Home Assistant services:** `cd /home/hazzard/home-assistant && docker-compose up -d`
*   **Compile an ESPHome configuration:** `docker exec -it esphome esphome compile <config_file.yaml>`
*   **List Ollama models:** `docker exec -it ollama ollama list`

## Hardware Interaction Guidelines

**CRITICAL:** When the user asks to identify devices, scan ports, or find MAC addresses for USB-connected hardware:

1.  **Context Awareness:** Recognize that this project involves ESP32 development. The user likely has an ESP32 connected via USB.
2.  **Do Not Refuse Immediately:** Do not assume you "cannot access hardware" or "cannot see MAC addresses on USB".
3.  **Active Scanning:**
    *   **Check USB Devices:** Run `lsusb` to see connected bridges (e.g., CP210x, CH340).
    *   **Check Serial Ports:** Run `ls /dev/ttyUSB*` or `ls /dev/ttyACM*`.
    *   **Query ESP32:** If a serial port is found (e.g., `/dev/ttyUSB0`), **use `esptool` to query the chip info.**
        ```bash
        esptool --port /dev/ttyUSB0 read_mac
        ```
    *   **Check Kernel Logs:** Run `dmesg | tail` or grep for `tty` to see attachment events.
4.  **Assumption:** If a generic "USB to UART" bridge is seen, assume it is an ESP32 target unless proven otherwise.

## File Permissions and Write Access

**Issue:** Docker containers (Home Assistant, Ollama, n8n, etc.) run as root and create files owned by `root:root`. This can cause permission errors when trying to edit configuration files.

**Solution Applied:** All files in `/home/hazzard/` have been changed to ownership `hazzard:hazzard`:

```bash
sudo chown -R hazzard:hazzard /home/hazzard/
```

**Why This Works:**
*   Docker containers running as root can still read and write to files owned by any user
*   The Gemini AI assistant runs as the `hazzard` user and can now write to all files
*   Home Assistant, ESPHome, and other services continue to function normally

**Important Files:**
*   `/home/hazzard/home-assistant/config/automations.yaml` - Home Assistant automations
*   `/home/hazzard/home-assistant/config/configuration.yaml` - Home Assistant main config
*   `/home/hazzard/homeproject/` - Documentation and planning directory
*   All other directories under `/home/hazzard/` are now writable

**Note:** If you encounter permission errors writing to any file in the home directory, the ownership has likely been reset by a Docker container. Simply re-run the chown command above.

## Home Assistant Automation Guidelines

### CRITICAL: YAML Formatting Rules

**ALWAYS use proper YAML syntax when editing `/home/hazzard/home-assistant/config/automations.yaml`.** Incorrect YAML formatting will break Home Assistant and put it into recovery mode.

**Common Mistakes to AVOID:**

1. **NEVER use JSON-style braces `{` or `}` in YAML files**
   ```yaml
   # ❌ WRONG - This will break Home Assistant
   target:{
     entity_id: climate.my_ecobee

   # ✅ CORRECT - Use proper YAML indentation
   target:
     entity_id: climate.my_ecobee
   ```

2. **ALWAYS use consistent indentation (2 spaces per level)**
   ```yaml
   # ✅ CORRECT
   action:
     - service: climate.set_temperature
       target:
         entity_id: climate.my_ecobee
       data:
         temperature: 20
         hvac_mode: "auto"
   ```

3. **NEVER mix tabs and spaces** - Use only spaces for indentation

4. **ALWAYS validate YAML before saving** - If you're unsure, use a YAML validator

### Automation Structure

When creating Home Assistant automations, ensure each automation has a unique ID. Generate a 32-character string using the automation's alias as a seed for consistency.

**Standard Automation Template:**
```yaml
- id: 'unique_32_char_id_here'
  alias: Descriptive Automation Name
  description: Brief description of what this automation does
  trigger:
    - platform: state
      entity_id: sensor.example
  condition: []
  action:
    - service: notify.notify
      data:
        message: "Automation triggered"
  mode: single
```

### Testing Changes

After editing automations.yaml:
1. Verify YAML syntax inside the Home Assistant container:
   ```bash
   docker exec homeassistant python -c "import yaml; yaml.safe_load(open('/config/automations.yaml'))"
   ```
2. If valid, reload automations via Home Assistant UI or restart the container
3. Check logs for errors: `docker logs homeassistant --tail 50`