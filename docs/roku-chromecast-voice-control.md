# Roku TV & Chromecast Voice Control Setup

## Overview

This guide will help you set up voice control for your Roku TV (with TSN app) and Chromecast (with TSN + Sportsnet apps) so you can completely replace your remotes with voice commands through Home Assistant.

## Current Setup

- **Roku TV**: Has TSN app built-in
- **Chromecast**: Connected to Roku TV, has TSN + Sportsnet apps
- **Goal**: Control everything with voice commands to your M5Stack Atom Echo devices

## Integration Setup

### 1. Roku TV Integration

Home Assistant has built-in Roku support through automatic discovery.

#### Enable Roku Discovery:

1. **Go to Home Assistant UI**: http://192.168.40.201:8123
2. Navigate to **Settings** → **Devices & Services**
3. Click **+ Add Integration**
4. Search for "Roku"
5. Home Assistant should auto-discover your Roku TV on the network
6. Click **Configure** and follow the prompts

**Manual Configuration (if auto-discovery doesn't work):**

Add to `/config/configuration.yaml`:

```yaml
# Roku TV Integration
roku:
  - host: 192.168.40.103  # Your Roku TV IP
```

**Your Roku TV IP Address: 192.168.40.103**

### 2. Chromecast Integration

Chromecast is automatically discovered by Home Assistant through the `default_config:` in your configuration.yaml.

#### Verify Chromecast Discovery:

1. **Go to Home Assistant UI**: http://192.168.40.201:8123
2. Navigate to **Settings** → **Devices & Services**
3. Look for "Google Cast" integration
4. Your Chromecast should appear automatically
5. If not, click **+ Add Integration** → Search "Google Cast"

### 3. Entity IDs

After setup, your devices will have entity IDs like:

- **Roku TV**: `media_player.roku_tv` (or similar)
- **Chromecast**: `media_player.living_room_chromecast` (or similar)

**To find exact entity IDs:**
1. Settings → Devices & Services
2. Click on Roku or Google Cast integration
3. Note the `entity_id` for each device

## Voice Control Setup

### Step 1: Install Roku App Helper Script

Create a script to help launch Roku apps by name.

Add to `/config/scripts.yaml`:

```yaml
launch_roku_app:
  alias: "Launch Roku App"
  fields:
    app_name:
      description: "Name of the app to launch"
      example: "TSN"
  sequence:
    - service: media_player.select_source
      target:
        entity_id: media_player.roku_tv  # Replace with your Roku entity_id
      data:
        source: "{{ app_name }}"

turn_on_roku_tv:
  alias: "Turn On Roku TV"
  sequence:
    - service: media_player.turn_on
      target:
        entity_id: media_player.roku_tv  # Replace with your Roku entity_id

turn_off_roku_tv:
  alias: "Turn Off Roku TV"
  sequence:
    - service: media_player.turn_off
      target:
        entity_id: media_player.roku_tv  # Replace with your Roku entity_id
```

### Step 2: Create TSN/Sportsnet Voice Commands

Add to `/config/configuration.yaml`:

```yaml
# Custom sentences for voice control
conversation:
  intents:
    WatchTSN:
      - "watch TSN"
      - "open TSN"
      - "turn on TSN"
      - "play TSN"
      - "watch sports"

    WatchSportsnet:
      - "watch Sportsnet"
      - "open Sportsnet"
      - "turn on Sportsnet"
      - "play Sportsnet"

    TurnOnTV:
      - "turn on the TV"
      - "TV on"
      - "turn on TV"

    TurnOffTV:
      - "turn off the TV"
      - "TV off"
      - "turn off TV"
```

### Step 3: Create Intent Scripts

Add to `/config/configuration.yaml`:

```yaml
# Intent scripts for voice commands
intent_script:
  WatchTSN:
    speech:
      text: "Opening TSN on the TV"
    action:
      - service: media_player.turn_on
        target:
          entity_id: media_player.roku_tv
      - delay:
          seconds: 3
      - service: media_player.select_source
        target:
          entity_id: media_player.roku_tv
        data:
          source: "TSN"

  WatchSportsnet:
    speech:
      text: "Opening Sportsnet on Chromecast"
    action:
      - service: media_player.turn_on
        target:
          entity_id: media_player.living_room_chromecast  # Replace with your Chromecast entity_id
      - delay:
          seconds: 2
      # Note: Chromecast app launching requires casting a stream
      # You may need to use a helper automation or script

  TurnOnTV:
    speech:
      text: "Turning on the TV"
    action:
      - service: media_player.turn_on
        target:
          entity_id: media_player.roku_tv

  TurnOffTV:
    speech:
      text: "Turning off the TV"
    action:
      - service: media_player.turn_off
        target:
          entity_id: media_player.roku_tv
```

### Step 4: Chromecast App Launching (Advanced)

Unfortunately, Chromecast doesn't support direct app launching like Roku. However, you can:

**Option A: Use Roku for TSN, Manual Switch to Chromecast for Sportsnet**

Since your Roku already has TSN, use voice to launch TSN on Roku:
- *"Hey Malory, watch TSN"* → Opens TSN on Roku TV

For Sportsnet (Chromecast only):
- *"Hey Malory, switch to Chromecast"* → Switches TV input to Chromecast
- Then manually open Sportsnet app

**Option B: Home Assistant + Android TV/Google TV**

If your Chromecast is a Chromecast with Google TV, you can use the Android TV integration:

```yaml
# Add to configuration.yaml
androidtv:
  - name: Chromecast
    host: <CHROMECAST_IP>
    device_class: androidtv
```

Then you can launch apps directly:

```yaml
# Script to launch Sportsnet
launch_sportsnet:
  sequence:
    - service: androidtv.adb_command
      target:
        entity_id: media_player.chromecast
      data:
        command: "am start -n com.sportsnet.mobile/.ui.activity.SplashActivity"
```

**Option C: Create Input Automation**

Create an automation to switch TV input to Chromecast:

```yaml
# Add to automations.yaml
- id: switch_to_chromecast
  alias: "Switch TV to Chromecast Input"
  trigger:
    - platform: event
      event_type: custom_intent
      event_data:
        intent: "SwitchToChromecast"
  action:
    - service: media_player.select_source
      target:
        entity_id: media_player.roku_tv
      data:
        source: "HDMI 1"  # Or whichever HDMI port your Chromecast is on
```

## Example Voice Commands

### Basic TV Control:
- *"Hey Malory, turn on the TV"*
- *"Hey Malory, turn off the TV"*

### TSN (via Roku):
- *"Hey Malory, watch TSN"*
- *"Hey Malory, open TSN"*
- *"Hey Malory, turn on TSN"*

### Sportsnet (via Chromecast - requires input switch):
- *"Hey Malory, switch to Chromecast"*
- (Then manually open Sportsnet app)

### Advanced (if using Android TV integration):
- *"Hey Malory, launch Sportsnet"*

## Roku Remote Control via Voice

You can also control Roku navigation with voice:

```yaml
# Add to scripts.yaml
roku_home:
  sequence:
    - service: remote.send_command
      target:
        entity_id: remote.roku_tv  # Your Roku remote entity
      data:
        command: "home"

roku_select:
  sequence:
    - service: remote.send_command
      target:
        entity_id: remote.roku_tv
      data:
        command: "select"

roku_back:
  sequence:
    - service: remote.send_command
      target:
        entity_id: remote.roku_tv
      data:
        command: "back"
```

Then create voice commands:
- *"Hey Malory, Roku home"*
- *"Hey Malory, Roku select"*
- *"Hey Malory, Roku back"*

## Finding TSN Channels on Roku

After launching the TSN app via voice, you can navigate to specific channels:

### Method 1: Deep Linking (Advanced)

Some Roku channels support deep linking to specific content. Check TSN's Roku channel for deep link support:

```yaml
launch_tsn_channel:
  sequence:
    - service: roku.launch
      target:
        entity_id: media_player.roku_tv
      data:
        app_id: "12345"  # TSN app ID (find this in Roku documentation)
        content_id: "tsn1"  # Channel identifier (if supported)
```

### Method 2: Directional Navigation

Create scripts to navigate within the TSN app:

```yaml
tsn_select_channel_1:
  sequence:
    - service: script.launch_roku_app
      data:
        app_name: "TSN"
    - delay:
        seconds: 5  # Wait for app to load
    - service: remote.send_command
      target:
        entity_id: remote.roku_tv
      data:
        command: "right"
    - delay:
        milliseconds: 500
    - service: remote.send_command
      target:
        entity_id: remote.roku_tv
      data:
        command: "select"
```

## Free Legal Sports Streaming Options

### CBC Gem (100% Free for Canadians)
- **Hockey Night in Canada** - Saturday NHL games
- Olympic coverage
- No subscription required

**Voice Control:**
```yaml
watch_cbc_gem:
  sequence:
    - service: media_player.select_source
      target:
        entity_id: media_player.roku_tv
      data:
        source: "CBC Gem"  # Install from Roku Channel Store
```

Voice command: *"Hey Malory, watch CBC Gem"*

### Pluto TV (Free, Ad-Supported)
- Sports channels and content
- NFL Channel (highlights, not live games)
- Available on Roku and Chromecast

**Voice Control:**
```yaml
watch_pluto_sports:
  sequence:
    - service: media_player.select_source
      target:
        entity_id: media_player.roku_tv
      data:
        source: "Pluto TV"
```

Voice command: *"Hey Malory, watch Pluto TV"*

## Testing Your Setup

### Step-by-Step Testing:

1. **Test Roku Discovery:**
   ```bash
   # From your host machine:
   curl -s http://<ROKU_TV_IP>:8060/query/apps | grep -o '<app id="[^"]*">[^<]*' | head -10
   ```

2. **Test TSN App Launch:**
   - Go to Home Assistant → Developer Tools → Services
   - Service: `media_player.select_source`
   - Entity: `media_player.roku_tv`
   - Source: `TSN`
   - Click "Call Service"

3. **Test Voice Command:**
   - Say: *"Hey Malory, watch TSN"*
   - Check if TV turns on and TSN launches

## Troubleshooting

### Roku Not Discovered:
- Ensure Roku is on the same network (192.168.40.0/24)
- Restart Home Assistant: `docker restart homeassistant`
- Add manual configuration with Roku IP

### TSN App Not Launching:
- Check exact app name on Roku: Settings → System → About
- App names are case-sensitive
- Use Developer Tools to test service calls

### Chromecast Not Casting:
- Ensure Chromecast is powered on
- Verify network connectivity
- Check firewall rules (allow mDNS/multicast)

### Voice Commands Not Working:
- Check Home Assistant logs: `docker logs -f homeassistant`
- Verify conversation integration is loaded
- Test intent scripts manually in Developer Tools

## Next Steps

1. **Set up Roku integration** in Home Assistant
2. **Verify Chromecast** auto-discovery
3. **Add scripts** to `/config/scripts.yaml`
4. **Test voice commands** with your M5Stack Atom Echo
5. **Fine-tune navigation** for TSN channels
6. **Consider upgrading Chromecast** to Chromecast with Google TV for better app control

## Additional Resources

- **Roku Integration Docs**: https://www.home-assistant.io/integrations/roku/
- **Google Cast Integration**: https://www.home-assistant.io/integrations/cast/
- **Voice Assistant Pipeline**: https://www.home-assistant.io/voice_control/
- **Android TV Integration**: https://www.home-assistant.io/integrations/androidtv/

## Pro Tips

### Macro Commands:
Create a single command that does multiple things:

```yaml
game_time:
  alias: "Game Time Mode"
  sequence:
    - service: media_player.turn_on
      target:
        entity_id: media_player.roku_tv
    - delay:
        seconds: 3
    - service: media_player.select_source
      target:
        entity_id: media_player.roku_tv
      data:
        source: "TSN"
    - service: light.turn_off
      target:
        entity_id: light.living_room_lights  # If you have smart lights
```

Voice command: *"Hey Malory, it's game time"*

### Schedule-Based Automation:
Automatically turn on TSN for scheduled games:

```yaml
- id: leafs_game_reminder
  alias: "Leafs Game Starting"
  trigger:
    - platform: time
      at: "19:00:00"  # 7 PM ET
    - platform: calendar
      event: start
      entity_id: calendar.maple_leafs_schedule  # If you add a calendar
  condition:
    # Add day-of-week or calendar conditions
  action:
    - service: tts.speak
      target:
        entity_id: media_player.living_room_voice
      data:
        message: "The Leafs game is starting soon. Would you like me to turn on TSN?"
```

### Voice Confirmation:
Add TTS feedback for better UX:

```yaml
watch_tsn_with_feedback:
  sequence:
    - service: tts.speak
      target:
        entity_id: media_player.living_room_voice
      data:
        message: "Opening TSN on your TV"
    - service: media_player.turn_on
      target:
        entity_id: media_player.roku_tv
    - delay:
        seconds: 3
    - service: media_player.select_source
      target:
        entity_id: media_player.roku_tv
      data:
        source: "TSN"
```
