# ESPHome Development with VS Code

This guide shows you how to set up Visual Studio Code for ESPHome development, giving you a professional IDE experience with syntax highlighting, autocomplete, validation, and integrated flashing tools.

**Why VS Code instead of just the web dashboard?**
- ✅ **YAML syntax highlighting** - Catch errors before compiling
- ✅ **Autocomplete** - ESPHome component suggestions as you type
- ✅ **Validation** - Real-time error detection
- ✅ **Git integration** - Version control for your configs
- ✅ **Multi-file editing** - Work on multiple device configs simultaneously
- ✅ **Remote SSH** - Edit files on your server from any computer
- ✅ **Snippets** - Reusable code templates for common patterns

---

## Two Approaches

### Approach 1: VS Code + Remote SSH (Recommended)
Edit ESPHome files directly on your server from your workstation. **Best for your setup** since you're running ESPHome in Docker.

### Approach 2: Local VS Code + ESPHome CLI
Run ESPHome locally on your workstation. Useful for offline development.

**This guide focuses on Approach 1 (Remote SSH) since you already have ESPHome running in Docker.**

---

## Part 1: VS Code Setup (Your Workstation)

### Step 1: Install VS Code

**Download VS Code:**
- **Windows/Mac/Linux:** https://code.visualstudio.com/

**Install:**
- Windows: Run `.exe` installer
- Mac: Drag to Applications folder
- Linux: `sudo apt install code` or download `.deb`

### Step 2: Install Required Extensions

Open VS Code and install these extensions:

**Essential Extensions:**
1. **Remote - SSH** (`ms-vscode-remote.remote-ssh`)
   - Connect to your server via SSH
   - Edit files directly on the server

2. **ESPHome** (`esphome.esphome-vscode`)
   - YAML syntax highlighting for ESPHome
   - Autocomplete for ESPHome components
   - Schema validation

3. **YAML** (`redhat.vscode-yaml`)
   - General YAML syntax support
   - Indentation helpers
   - Format on save

**Highly Recommended Extensions:**
4. **GitLens** (`eamodio.gitlens`)
   - Git integration and history

5. **Error Lens** (`usernamehw.errorlens`)
   - Inline error highlighting

6. **Prettier - Code formatter** (`esbenp.prettier-vscode`)
   - Auto-format YAML files

**How to Install Extensions:**
1. Open VS Code
2. Click **Extensions** icon (sidebar, or `Ctrl+Shift+X`)
3. Search for extension name
4. Click **Install**

---

## Part 2: Remote SSH Configuration

### Step 1: Set Up SSH Key (If You Haven't Already)

**On your workstation (Windows/Mac/Linux):**

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Press Enter to accept default location (~/.ssh/id_ed25519)
# Set a passphrase (optional but recommended)

# Copy public key to server
ssh-copy-id hazzard@192.168.40.201

# Or manually:
cat ~/.ssh/id_ed25519.pub
# Copy the output, then on server:
# echo "paste-public-key-here" >> ~/.ssh/authorized_keys
```

**Test SSH connection:**
```bash
ssh hazzard@192.168.40.201
# Should connect without password prompt
```

### Step 2: Configure Remote SSH in VS Code

1. **Open Command Palette:** `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
2. Type: `Remote-SSH: Connect to Host...`
3. Click **+ Add New SSH Host**
4. Enter: `ssh hazzard@192.168.40.201`
5. Select SSH config file: `~/.ssh/config` (default)
6. Click **Connect**

**VS Code will:**
- Connect to your server
- Install VS Code Server on the remote machine
- Open a new VS Code window connected to the server

### Step 3: Open ESPHome Directory

1. In the remote VS Code window: **File → Open Folder**
2. Navigate to: `/home/hazzard/home-assistant/esphome/`
3. Click **OK**
4. You now see all your ESPHome YAML files in the sidebar!

---

## Part 3: ESPHome Extension Configuration

### Step 1: Configure ESPHome Extension Settings

**In VS Code (connected to server):**

1. Open Settings: `Ctrl+,` (Windows/Linux) or `Cmd+,` (Mac)
2. Search for: `ESPHome`
3. Configure these settings:

**ESPHome: Dashboard URI**
- Value: `http://localhost:6052`
- *Note:* Use `localhost` because VS Code is connected via SSH tunnel

**ESPHome: Configuration Path**
- Value: `/home/hazzard/home-assistant/esphome/`

**ESPHome: Compile on Save** (optional)
- Value: `false` (recommended - don't auto-compile on every save)

### Step 2: Configure YAML Extension

**Settings to enable:**

**YAML: Format: Enable**
- Value: `true`

**YAML: Custom Tags**
- Add ESPHome secret tag: `!secret`
- Add ESPHome lambda tag: `!lambda`

**Settings JSON** (easier method):
1. Open Command Palette: `Ctrl+Shift+P`
2. Type: `Preferences: Open Settings (JSON)`
3. Add these lines:

```json
{
  "esphome.dashboardUri": "http://localhost:6052",
  "esphome.configPath": "/home/hazzard/home-assistant/esphome/",

  "yaml.customTags": [
    "!secret scalar",
    "!lambda scalar",
    "!extend",
    "!include"
  ],

  "yaml.format.enable": true,
  "yaml.validate": true,
  "yaml.completion": true,

  "files.associations": {
    "*.yaml": "esphome"
  },

  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true
}
```

---

## Part 4: Development Workflow

### Creating a New ESPHome Device

**Method 1: VS Code File Creation**

1. **Create new file:**
   - Right-click in Explorer → **New File**
   - Name: `my-new-device.yaml`

2. **Start with template:**
   ```yaml
   esphome:
     name: my-new-device
     friendly_name: "My New Device"
     platform: ESP32
     board: esp32dev

   wifi:
     ssid: !secret wifi_ssid
     password: !secret wifi_password
     manual_ip:
       static_ip: 192.168.40.XXX
       gateway: 192.168.40.1
       subnet: 255.255.255.0
       dns1: 8.8.8.8

   logger:

   api:
     encryption:
       key: !secret api_key_my_new_device

   ota:
     - platform: esphome
       password: !secret ota_password

   # Your components here...
   ```

3. **Save file:** `Ctrl+S`

**Method 2: ESPHome Dashboard (Then Edit in VS Code)**

1. Open ESPHome dashboard: http://192.168.40.201:6052
2. Click **+ NEW DEVICE**
3. Use wizard to create device
4. In VS Code, refresh Explorer (`F5`)
5. Open the newly created `.yaml` file
6. Edit in VS Code with autocomplete!

### Editing Existing Devices

1. **Open file** from VS Code Explorer
2. **Edit YAML** - autocomplete will suggest ESPHome components!
3. **Save:** `Ctrl+S`
4. **Compile and upload** (see next section)

### Using Autocomplete

**Example: Adding a DHT22 sensor**

1. Start typing `sen` → VS Code suggests `sensor:`
2. Press `Tab` to accept
3. Add new line, indent, type `- plat` → suggests `platform:`
4. Type `dht` → suggests `dht`
5. Press `Tab`, autocomplete fills in template:
   ```yaml
   sensor:
     - platform: dht
       pin: GPIO4
       model: DHT22
       temperature:
         name: "Temperature"
       humidity:
         name: "Humidity"
       update_interval: 60s
   ```

**This saves SO much time compared to typing manually!**

---

## Part 5: Compiling and Flashing

You have **three options** for compiling and flashing from VS Code:

### Option 1: ESPHome Dashboard (Easiest)

1. Save your YAML file in VS Code
2. Open ESPHome dashboard: http://192.168.40.201:6052
3. Click **INSTALL** on your device
4. Choose **Wirelessly** (if device already configured) or **Plug into this computer** (first flash)

**Pros:** Simple, familiar, web-based
**Cons:** Need to switch between VS Code and browser

### Option 2: Integrated Terminal (Recommended)

Use VS Code's integrated terminal to run ESPHome CLI commands directly in the Docker container.

**In VS Code:**
1. Open Terminal: `Ctrl+` ` (backtick) or **View → Terminal**
2. You're now in a bash shell on your server!

**Compile only:**
```bash
docker exec -it esphome esphome compile /config/my-device.yaml
```

**Compile and upload (OTA):**
```bash
docker exec -it esphome esphome upload /config/my-device.yaml
```

**View logs:**
```bash
docker exec -it esphome esphome logs /config/my-device.yaml
```

**Clean build (if errors):**
```bash
docker exec -it esphome esphome clean /config/my-device.yaml
```

**Pros:** All in one window, fast, scriptable
**Cons:** Need to remember commands

### Option 3: VS Code Tasks (Most Professional)

Create VS Code tasks for one-click compile/upload.

**Setup Tasks:**
1. Create `.vscode/tasks.json` in ESPHome directory:
   ```bash
   mkdir -p /home/hazzard/home-assistant/esphome/.vscode
   ```

2. **In VS Code:** Create `tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "ESPHome: Compile",
      "type": "shell",
      "command": "docker",
      "args": [
        "exec",
        "-it",
        "esphome",
        "esphome",
        "compile",
        "/config/${fileBasename}"
      ],
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": []
    },
    {
      "label": "ESPHome: Upload (OTA)",
      "type": "shell",
      "command": "docker",
      "args": [
        "exec",
        "-it",
        "esphome",
        "esphome",
        "upload",
        "/config/${fileBasename}"
      ],
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "ESPHome: Logs",
      "type": "shell",
      "command": "docker",
      "args": [
        "exec",
        "-it",
        "esphome",
        "esphome",
        "logs",
        "/config/${fileBasename}"
      ],
      "group": "none",
      "problemMatcher": []
    },
    {
      "label": "ESPHome: Clean",
      "type": "shell",
      "command": "docker",
      "args": [
        "exec",
        "-it",
        "esphome",
        "esphome",
        "clean",
        "/config/${fileBasename}"
      ],
      "group": "none",
      "problemMatcher": []
    }
  ]
}
```

**Using Tasks:**
1. Open a `.yaml` file (e.g., `living-room-voice.yaml`)
2. Open Command Palette: `Ctrl+Shift+P`
3. Type: `Tasks: Run Task`
4. Choose:
   - **ESPHome: Compile** - Build firmware
   - **ESPHome: Upload (OTA)** - Flash device over WiFi
   - **ESPHome: Logs** - View real-time logs
   - **ESPHome: Clean** - Clean build cache

**Keyboard Shortcut for Build:**
- `Ctrl+Shift+B` → Runs default task (Compile)

**Pros:** Professional workflow, one-click builds, organized
**Cons:** Initial setup required

---

## Part 6: Useful VS Code Features

### Multi-Cursor Editing

Edit multiple lines at once:
- `Ctrl+D` - Select next occurrence of current word
- `Alt+Click` - Add cursor at click position
- `Ctrl+Alt+Up/Down` - Add cursor above/below

**Example:**
```yaml
sensor:
  - platform: dht
    temperature:
      name: "Temperature"  # Select "name", press Ctrl+D twice
    humidity:
      name: "Humidity"     # All three "name" selected
```
Type to replace all at once!

### Folding (Collapse Sections)

Click the arrow next to line numbers to fold/unfold sections:
```yaml
sensor:   # Click arrow here to collapse entire sensor block
  - platform: dht
    ...
```

### Go to Symbol

Quickly jump to sections:
- `Ctrl+Shift+O` - Show all symbols (sections) in current file
- Type to filter (e.g., "sensor", "switch")
- Click to jump

### Search Across All Files

Find all devices using a specific GPIO pin:
- `Ctrl+Shift+F` - Search across all files
- Search: `GPIO4`
- See all matches in sidebar

### Git Integration (Version Control)

**Initialize Git repo:**
```bash
cd /home/hazzard/home-assistant/esphome
git init
git add .
git commit -m "Initial ESPHome configurations"
```

**In VS Code:**
- See file changes in **Source Control** sidebar (`Ctrl+Shift+G`)
- Commit changes with message
- View file history with GitLens

**Benefits:**
- Undo changes if something breaks
- See what changed between versions
- Backup your configs

---

## Part 7: Snippets (Code Templates)

Create reusable code snippets for common patterns.

**Setup User Snippets:**
1. Command Palette: `Ctrl+Shift+P`
2. Type: `Preferences: Configure User Snippets`
3. Choose: `esphome.json` (or create new)

**Example Snippets:**

```json
{
  "DHT22 Sensor": {
    "prefix": "dht22",
    "body": [
      "sensor:",
      "  - platform: dht",
      "    pin: GPIO${1:4}",
      "    model: DHT22",
      "    temperature:",
      "      name: \"${2:Temperature}\"",
      "      id: ${3:temp}",
      "    humidity:",
      "      name: \"${4:Humidity}\"",
      "      id: ${5:humidity}",
      "    update_interval: ${6:60s}"
    ],
    "description": "DHT22 temperature and humidity sensor"
  },

  "Binary Sensor (GPIO)": {
    "prefix": "bingpio",
    "body": [
      "binary_sensor:",
      "  - platform: gpio",
      "    pin:",
      "      number: GPIO${1:4}",
      "      mode:",
      "        input: true",
      "        pullup: ${2:true}",
      "    name: \"${3:Sensor Name}\"",
      "    device_class: ${4|motion,door,window,occupancy,safety|}"
    ],
    "description": "Binary sensor on GPIO pin"
  },

  "Relay Switch": {
    "prefix": "relay",
    "body": [
      "switch:",
      "  - platform: gpio",
      "    pin: GPIO${1:4}",
      "    name: \"${2:Switch Name}\"",
      "    id: ${3:switch_id}",
      "    restore_mode: ${4|RESTORE_DEFAULT_OFF,RESTORE_DEFAULT_ON,ALWAYS_OFF,ALWAYS_ON|}"
    ],
    "description": "Relay or GPIO switch"
  },

  "Complete Device Template": {
    "prefix": "esp32device",
    "body": [
      "esphome:",
      "  name: ${1:device-name}",
      "  friendly_name: \"${2:Device Name}\"",
      "  platform: ESP32",
      "  board: esp32dev",
      "",
      "wifi:",
      "  ssid: !secret wifi_ssid",
      "  password: !secret wifi_password",
      "  manual_ip:",
      "    static_ip: 192.168.40.${3:150}",
      "    gateway: 192.168.40.1",
      "    subnet: 255.255.255.0",
      "    dns1: 8.8.8.8",
      "",
      "logger:",
      "",
      "api:",
      "  encryption:",
      "    key: !secret api_key_${1:device-name}",
      "",
      "ota:",
      "  - platform: esphome",
      "    password: !secret ota_password",
      "",
      "# Components below",
      "$0"
    ],
    "description": "Complete ESP32 device template"
  }
}
```

**Using Snippets:**
1. Open a `.yaml` file
2. Type snippet prefix (e.g., `dht22`)
3. Press `Tab`
4. Snippet expands with placeholders
5. Press `Tab` to jump between placeholders
6. Fill in values

**Example:**
```
Type: esp32device [Tab]
→ Expands to full device template
→ Cursor on "device-name" (highlighted)
→ Type: temperature-sensor [Tab]
→ Cursor jumps to "Device Name"
→ Type: Temperature Sensor [Tab]
→ Cursor jumps to IP last octet
→ Type: 155 [Tab]
→ Done!
```

---

## Part 8: Validation and Error Detection

### Real-Time Validation

VS Code with ESPHome extension validates YAML as you type:

**Example Errors:**
```yaml
sensor:
  - platform: dht
    pin: GPIO4
    model: DHT99  # ❌ Red squiggle - invalid model
```

**Hover over error:**
- VS Code shows: "Value 'DHT99' is not valid. Valid values: DHT11, DHT22, AM2302"

**Indentation Errors:**
```yaml
sensor:
  - platform: dht
  pin: GPIO4  # ❌ Wrong indentation
```

**Missing Required Fields:**
```yaml
sensor:
  - platform: dht
    # ❌ Missing 'pin' field
```

### Pre-Compile Validation

Before compiling, VS Code highlights:
- Syntax errors (invalid YAML)
- Schema errors (wrong ESPHome component structure)
- Type errors (string where number expected)

**This catches 90% of errors before wasting time compiling!**

---

## Part 9: Advanced Tips

### Tip 1: Side-by-Side Editing

Compare two device configs:
1. Open first file: `living-room-voice.yaml`
2. Right-click second file in Explorer
3. Choose: **Open to the Side**
4. Now you can copy/paste between devices

### Tip 2: YAML Anchors (Reusable Blocks)

Define common config once, reuse multiple times:

```yaml
# Define anchor
common_sensor_config: &common_config
  update_interval: 60s
  filters:
    - filter_out: nan

sensor:
  # Use anchor
  - platform: dht
    <<: *common_config
    pin: GPIO4
    temperature:
      name: "Temp 1"

  - platform: dht
    <<: *common_config  # Reuse same settings
    pin: GPIO5
    temperature:
      name: "Temp 2"
```

### Tip 3: !include for Shared Configs

Split large configs into multiple files:

**Main file: `living-room.yaml`**
```yaml
esphome:
  name: living-room
  ...

# Include shared configs
<<: !include common/wifi.yaml
<<: !include common/logger.yaml

sensor: !include sensors/living-room-sensors.yaml
switch: !include switches/living-room-switches.yaml
```

**`common/wifi.yaml`**
```yaml
wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8
```

### Tip 4: JSON Schema Validation

For even better autocomplete, create a schema file:

**`.vscode/settings.json`** (in ESPHome directory):
```json
{
  "yaml.schemas": {
    "https://esphome.io/schema.json": "*.yaml"
  }
}
```

This enables deep validation and autocomplete for all ESPHome components!

---

## Part 10: Troubleshooting

### VS Code Can't Connect via SSH

**Issue:** "Could not establish connection to server"

**Fix:**
1. Test SSH manually: `ssh hazzard@192.168.40.201`
2. Check SSH key: `ssh-add -l` (should list your key)
3. If not listed: `ssh-add ~/.ssh/id_ed25519`
4. Restart VS Code

### Autocomplete Not Working

**Issue:** No suggestions when typing

**Fix:**
1. Verify ESPHome extension installed (check Extensions sidebar)
2. Check file association: Bottom-right corner should say "ESPHome" (not "YAML")
3. If says "YAML": Right-click → **Change Language Mode** → **ESPHome**
4. Reload VS Code: `Ctrl+Shift+P` → `Developer: Reload Window`

### Tasks Don't Run

**Issue:** "Task 'ESPHome: Compile' not found"

**Fix:**
1. Ensure `tasks.json` is in `.vscode/` subfolder
2. Check JSON syntax (no trailing commas)
3. Reload VS Code

### Docker Exec Fails in Terminal

**Issue:** "Error: Cannot connect to Docker daemon"

**Fix:**
You're in a remote SSH session, but Docker needs proper socket access:

```bash
# Test Docker access
docker ps

# If fails, check Docker socket
ls -l /var/run/docker.sock

# Ensure your user is in docker group
groups
# Should show "docker"

# If not in docker group:
sudo usermod -aG docker hazzard
# Log out and back in
```

---

## Part 11: Complete Example Workflow

**Scenario:** Create a new temperature sensor for the bedroom

### Step 1: Open VS Code (Remote SSH)

```bash
# On your workstation
code --remote ssh-remote+192.168.40.201 /home/hazzard/home-assistant/esphome
```

Or click **Remote Explorer** in VS Code sidebar → Connect to saved host.

### Step 2: Create New Device File

**In VS Code:**
1. Explorer → Right-click → **New File**
2. Name: `bedroom-climate.yaml`
3. Type: `esp32device` → Press `Tab` (snippet expands)
4. Fill in placeholders:
   - Name: `bedroom-climate`
   - Friendly Name: `Bedroom Climate`
   - IP: `154`

### Step 3: Add DHT22 Sensor

**Below the OTA section:**
1. Type: `dht22` → Press `Tab`
2. Fill in:
   - Pin: `GPIO4`
   - Temperature name: `Bedroom Temperature`
   - Humidity name: `Bedroom Humidity`

**Your file now looks like:**
```yaml
esphome:
  name: bedroom-climate
  friendly_name: "Bedroom Climate"
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password
  manual_ip:
    static_ip: 192.168.40.154
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

logger:

api:
  encryption:
    key: !secret api_key_bedroom_climate

ota:
  - platform: esphome
    password: !secret ota_password

sensor:
  - platform: dht
    pin: GPIO4
    model: DHT22
    temperature:
      name: "Bedroom Temperature"
      id: temp
    humidity:
      name: "Bedroom Humidity"
      id: humidity
    update_interval: 60s
```

### Step 4: Validate

Look for red squiggles (errors) - there should be none!

### Step 5: Save

`Ctrl+S` - file saved on server!

### Step 6: Compile

**Option A: Terminal**
```bash
docker exec -it esphome esphome compile /config/bedroom-climate.yaml
```

**Option B: Task**
1. `Ctrl+Shift+B` (Run Build Task)
2. Watch compilation in terminal panel

### Step 7: Flash

**First flash (USB):**
1. Connect ESP32 to your workstation via USB
2. Open ESPHome dashboard: http://192.168.40.201:6052
3. Find `bedroom-climate` → **INSTALL** → **Plug into this computer**

**Subsequent updates (OTA):**
```bash
docker exec -it esphome esphome upload /config/bedroom-climate.yaml
```

Or use Task: `ESPHome: Upload (OTA)`

### Step 8: Monitor Logs

**In VS Code terminal:**
```bash
docker exec -it esphome esphome logs /config/bedroom-climate.yaml
```

Or use Task: `ESPHome: Logs`

**You'll see:**
```
[D][dht:048]: Got Temperature=22.3°C Humidity=45.2%
```

### Step 9: Verify in Home Assistant

1. Open Home Assistant: http://192.168.40.201:8123
2. **Settings → Integrations → ESPHome**
3. Your new device appears!

---

## Part 12: Quick Reference

### VS Code Keyboard Shortcuts

| Action | Windows/Linux | Mac |
|--------|---------------|-----|
| Command Palette | `Ctrl+Shift+P` | `Cmd+Shift+P` |
| Quick Open File | `Ctrl+P` | `Cmd+P` |
| Terminal | `Ctrl+` ` | `Cmd+` ` |
| Save | `Ctrl+S` | `Cmd+S` |
| Build (Default Task) | `Ctrl+Shift+B` | `Cmd+Shift+B` |
| Find | `Ctrl+F` | `Cmd+F` |
| Find in Files | `Ctrl+Shift+F` | `Cmd+Shift+F` |
| Go to Symbol | `Ctrl+Shift+O` | `Cmd+Shift+O` |
| Multi-cursor | `Alt+Click` | `Option+Click` |
| Select Next Occurrence | `Ctrl+D` | `Cmd+D` |

### ESPHome CLI Commands (via Docker)

```bash
# Compile only
docker exec -it esphome esphome compile /config/<device>.yaml

# Upload (OTA)
docker exec -it esphome esphome upload /config/<device>.yaml

# View logs
docker exec -it esphome esphome logs /config/<device>.yaml

# Clean build
docker exec -it esphome esphome clean /config/<device>.yaml

# Validate config
docker exec -it esphome esphome config /config/<device>.yaml

# Generate binary (no upload)
docker exec -it esphome esphome compile /config/<device>.yaml --only-generate
```

### Common YAML Patterns

**Static IP:**
```yaml
wifi:
  manual_ip:
    static_ip: 192.168.40.XXX
    gateway: 192.168.40.1
    subnet: 255.255.255.0
```

**Secrets:**
```yaml
# In device YAML
wifi:
  ssid: !secret wifi_ssid

# In secrets.yaml
wifi_ssid: "YourNetworkName"
```

**Filters:**
```yaml
filters:
  - filter_out: nan
  - sliding_window_moving_average:
      window_size: 3
  - offset: -0.5
```

---

## Summary

With VS Code + Remote SSH + ESPHome extension, you get:

✅ **Professional IDE experience**
- Syntax highlighting
- Autocomplete
- Real-time validation

✅ **Efficient workflow**
- Edit on server from any workstation
- One-click compile/upload
- Integrated terminal

✅ **Error prevention**
- Catch errors before compiling
- Schema validation
- Inline error messages

✅ **Better organization**
- Multi-file editing
- Version control with Git
- Code snippets for common patterns

✅ **Faster development**
- No switching between web dashboard and text editor
- Keyboard shortcuts
- Multi-cursor editing

**This is the workflow used by ESPHome power users!**

---

## Next Steps

Now that you have VS Code set up:

1. **Try editing an existing device** - Open `living-room-voice.yaml` and explore autocomplete
2. **Create a snippet** for your most common sensor types
3. **Enable Git version control** for config backup
4. **Experiment with tasks** for one-click builds
5. **Customize your workspace** with themes and keybindings

**Happy coding!** 🚀
