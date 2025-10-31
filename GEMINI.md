# GEMINI.md

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
