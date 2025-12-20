# Roku TV Voice Commands - Quick Reference

## Setup Complete ✅

Your Roku TV (192.168.40.103) is now configured with voice control through Home Assistant and your M5Stack Atom Echo devices (Living Room Voice & Office Voice).

---

## Available Voice Commands

### Watch TSN (Sports)
- *"Hey Malory, watch TSN"*
- *"Hey Malory, open TSN"*
- *"Hey Malory, turn on TSN"*
- *"Hey Malory, play TSN"*
- *"Hey Malory, watch sports"*

**What happens:** TV turns on (if off), waits 3 seconds, launches TSN app

---

### Watch Plex (Your Media Server)
- *"Hey Malory, watch Plex"*
- *"Hey Malory, open Plex"*
- *"Hey Malory, launch Plex"*
- *"Hey Malory, start Plex"*

**What happens:** TV turns on, waits 3 seconds, launches Plex app

---

### Watch Disney Plus
- *"Hey Malory, watch Disney"*
- *"Hey Malory, open Disney"*
- *"Hey Malory, watch Disney Plus"*
- *"Hey Malory, open Disney Plus"*
- *"Hey Malory, launch Disney"*

**What happens:** TV turns on, waits 3 seconds, launches Disney Plus app

---

### Watch CTV
- *"Hey Malory, watch CTV"*
- *"Hey Malory, open CTV"*
- *"Hey Malory, launch CTV"*

**What happens:** TV turns on, waits 3 seconds, launches CTV app

---

### Watch YouTube
- *"Hey Malory, watch YouTube"*
- *"Hey Malory, open YouTube"*
- *"Hey Malory, launch YouTube"*
- *"Hey Malory, play YouTube"*

**What happens:** TV turns on, waits 3 seconds, launches YouTube app

---

### TV Power Control
**Turn On:**
- *"Hey Malory, turn on the TV"*
- *"Hey Malory, TV on"*
- *"Hey Malory, power on the TV"*

**Turn Off:**
- *"Hey Malory, turn off the TV"*
- *"Hey Malory, TV off"*
- *"Hey Malory, power off the TV"*

---

## For Sportsnet (Manual Process)

Since Roku doesn't have the Sportsnet app:

1. Say: *"Hey Malory, turn on the TV"*
2. Manually switch TV input to Chromecast (using remote)
3. Open Sportsnet app on Chromecast
4. Enjoy the game

---

## Testing Your Setup

### Via Home Assistant UI (if needed):

1. **Go to:** http://192.168.40.201:8123
2. **Navigate to:** Developer Tools → Services
3. **Test a script:**
   - Service: `script.roku_launch_tsn`
   - Click "Call Service"
   - TSN should launch on your Roku TV

### Via Voice (Recommended):

1. Stand near your Atom Echo (Living Room or Office)
2. Say: *"Hey Malory, watch TSN"*
3. Wait for Malory to respond: "Opening TSN on your TV"
4. TV should turn on and TSN should launch

---

## Troubleshooting

### "Sorry, I couldn't understand that"
- **Cause:** Voice command not recognized
- **Fix:** Speak clearly, use exact phrases from list above
- **Try:** Simpler phrases like "watch TSN" instead of complex sentences

### TV doesn't turn on
- **Cause:** Roku entity may not be loaded
- **Fix:** Check Home Assistant → Settings → Devices & Services → Look for Roku
- **Verify:** Entity ID is `media_player.roku`

### App doesn't launch
- **Cause:** App name mismatch
- **Fix:** Check exact app name on Roku
- **To verify:** Home Assistant → Developer Tools → States → Look for `media_player.roku` → Check `source_list` attribute

### Different app name on Roku?
If the app names don't match exactly, edit `/config/scripts.yaml`:

**Example:** If Disney Plus shows as "Disney+" instead:
```yaml
roku_launch_disney:
  alias: "Launch Disney Plus on Roku"
  sequence:
    - service: media_player.turn_on
      target:
        entity_id: media_player.roku
    - delay:
        seconds: 3
    - service: media_player.select_source
      target:
        entity_id: media_player.roku
      data:
        source: "Disney+"  # Change this to match Roku's exact name
```

Then restart Home Assistant: `docker restart homeassistant`

---

## Advanced: Adding More Voice Commands

Want to add more apps? Follow this pattern:

### 1. Add Script to `/config/scripts.yaml`

```yaml
roku_launch_newapp:
  alias: "Launch New App on Roku"
  sequence:
    - service: media_player.turn_on
      target:
        entity_id: media_player.roku
    - delay:
        seconds: 3
    - service: media_player.select_source
      target:
        entity_id: media_player.roku
      data:
        source: "Exact App Name From Roku"
```

### 2. Add Intent to `/config/configuration.yaml`

Under `conversation: intents:` add:
```yaml
    WatchNewApp:
      - "watch new app"
      - "open new app"
      - "launch new app"
```

Under `intent_script:` add:
```yaml
  WatchNewApp:
    speech:
      text: "Opening New App"
    action:
      - service: script.roku_launch_newapp
```

### 3. Restart Home Assistant

```bash
docker restart homeassistant
```

### 4. Test

*"Hey Malory, watch new app"*

---

## File Locations

**Configuration files:**
- Main config: `/home/hazzard/home-assistant/config/configuration.yaml`
- Scripts: `/home/hazzard/home-assistant/config/scripts.yaml`
- This guide: `/home/hazzard/homeproject/docs/roku-voice-commands.md`

**Roku IP:** 192.168.40.103

**Voice Assistants:**
- Living Room Voice (M5Stack Atom Echo)
- Office Voice (M5Stack Atom Echo)

**Wake word:** "Ok Nabu" (triggers as "Malory")

---

## Next Steps

### Try These Commands Now:

1. *"Hey Malory, watch TSN"* - Launch TSN
2. *"Hey Malory, watch Plex"* - Launch Plex
3. *"Hey Malory, turn off the TV"* - Power off

### Future Enhancements:

**Macro Commands** - Combine multiple actions:
```yaml
game_time:
  alias: "Game Time Mode"
  sequence:
    - service: script.roku_launch_tsn
    - service: light.turn_off
      target:
        area_id: living_room  # If you have smart lights
    - service: notify.mobile_app
      data:
        message: "Enjoy the game!"
```

Voice: *"Hey Malory, it's game time!"*

**Scheduled Automations** - Auto-launch for scheduled games:
```yaml
- id: leafs_game_auto
  alias: "Auto-launch TSN for Leafs Games"
  trigger:
    - platform: time
      at: "19:00:00"  # 7 PM
  condition:
    - condition: time
      weekday:
        - wed
        - sat
  action:
    - service: script.roku_launch_tsn
    - service: tts.speak
      target:
        entity_id: media_player.living_room_voice
      data:
        message: "The game is starting. I've opened TSN for you."
```

---

## Feedback

If any commands aren't working, check:
1. Home Assistant logs: `docker logs -f homeassistant`
2. Roku is powered on and connected to network
3. Entity ID is correct: `media_player.roku`
4. App names match exactly

**Need help?** Check the logs and adjust app names in scripts.yaml as needed.

---

## Summary

✅ **Roku TV integrated** with Home Assistant
✅ **Voice commands configured** for 5 apps (TSN, Plex, Disney+, CTV, YouTube)
✅ **TV power control** via voice
✅ **No new hardware required** - using existing Roku TV
✅ **Sportsnet workaround** documented (manual Chromecast input switch)

**You can now control your TV entirely by voice - no remotes needed!**

Enjoy your hands-free streaming experience!
