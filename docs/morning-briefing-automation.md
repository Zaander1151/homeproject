# Morning Briefing Automation

## Overview
Automated morning briefing system that delivers a personalized summary via Telegram and Google Nest Audio when you unplug your Pixel 10 Pro between 5:00-9:00 AM.

## What's Included

### Weather
- Current temperature
- High/low for the day
- Conditions (sunny, cloudy, etc.)
- Precipitation chance

### Calendar
- Today's scheduled events from Google Calendar
- Meeting times and titles

### News
- **Sports:** NFL, CFL, CPL, NHL headlines
- **Tech:** Latest technology news

### Smart Home Status
- Bronco fuel level
- Bronco lock status
- Bedroom fan status
- Phone battery level

## How It Works

```
1. You unplug your Pixel 10 Pro (5-9 AM)
     ↓
2. Home Assistant detects the unplug event
     ↓
3. Checks if briefing already delivered today
     ↓
4. Calls n8n webhook
     ↓
5. n8n collects all data from Home Assistant & news sources
     ↓
6. Ollama AI generates conversational 30-second summary
     ↓
7. Sends formatted message to Telegram
     ↓
8. Announces briefing on Google Nest Audio
     ↓
9. Sets flag to prevent duplicate briefings until midnight
```

## Components Created

### Home Assistant

**Input Boolean:**
- `input_boolean.morning_briefing_delivered` - Tracks if briefing sent today

**Automations:**
1. **Morning Briefing - Phone Unplugged**
   - Trigger: `binary_sensor.pixel_10_pro_is_charging` changes from `on` to `off`
   - Conditions: Time between 5:00-9:00 AM AND briefing not yet delivered
   - Action: Calls n8n webhook and sets briefing flag

2. **Morning Briefing - Reset at Midnight**
   - Trigger: Time at 00:00:00
   - Action: Resets briefing flag for new day

**Scripts:**
- `announce_morning_briefing` - Announces message on Google Nest Audio at 70% volume

**REST Commands:**
- `trigger_morning_briefing` - Calls n8n webhook at `http://n8n:5678/webhook/morning-briefing`

**Entity Customization:**
- `media_player.living_room_speaker` now displays as "Bedroom Speaker"

### n8n Workflow (To Be Built)

**Status:** Setup guide and workflow JSON available at `/mnt/storage/automation/n8n/`

**Files:**
- 📖 **Setup Guide:** `/mnt/storage/automation/n8n/morning-briefing-setup-guide.md`
- 🔧 **Workflow Template:** `/mnt/storage/automation/n8n/morning-briefing-workflow.json`

**Required Steps:**
1. Create Home Assistant Long-Lived Access Token
2. Build workflow in n8n following the setup guide (or import the JSON template)
3. Configure news sources (RSS or Gemini API)
4. Test the webhook
5. Activate the workflow

## Testing

### Manual Test (After n8n workflow is built)

```bash
# Test the complete flow
curl -X POST http://192.168.40.201:5678/webhook/morning-briefing \
  -H "Content-Type: application/json" \
  -d '{"timestamp": "2025-12-05T09:00:00", "triggered_by": "manual_test"}'
```

### What to Expect:
1. Telegram message arrives with formatted briefing
2. Google Nest Audio announces briefing (with ~5-10 second delay for TTS generation)
3. Flag is set so it won't trigger again until after midnight

### Test Individual Components:

**Test TTS Script:**
```bash
# Via Home Assistant Developer Tools > Services
Service: script.announce_morning_briefing
Data:
  message: "This is a test of the morning briefing system."
```

**Test Automation Trigger:**
```bash
# Via Home Assistant Developer Tools > Services
Service: automation.trigger
Target:
  entity_id: automation.morning_briefing_phone_unplugged
```

## Configuration Files

**Modified:**
- `/home/hazzard/home-assistant/config/configuration.yaml` - Added input_boolean, REST command, entity customization
- `/home/hazzard/home-assistant/config/automations.yaml` - Added morning briefing automations
- `/home/hazzard/home-assistant/config/scripts.yaml` - Added TTS announcement script

**Created:**
- `/mnt/storage/automation/n8n/morning-briefing-setup-guide.md` - n8n workflow setup instructions
- `/mnt/storage/automation/n8n/morning-briefing-workflow.json` - n8n workflow template (importable)
- `/home/hazzard/homeproject/docs/morning-briefing-automation.md` - This documentation

## Next Steps

1. **Retrieve the files from your workstation:**
   - Access `/mnt/storage/automation/n8n/` from your network share
   - Files available:
     - `morning-briefing-setup-guide.md` - Step-by-step instructions
     - `morning-briefing-workflow.json` - Workflow template to import

2. **Go to n8n:** http://192.168.40.201:5678

3. **Follow the setup guide** to build the workflow

4. **Test the workflow** with the curl command above

5. **Enjoy your automated morning briefings!**

## Customization Options

### Change Time Window
Edit `automation.morning_briefing_trigger` conditions:
```yaml
condition:
  - condition: time
    after: '05:00:00'  # Change start time
    before: '09:00:00' # Change end time
```

### Change Voice Volume
Edit `script.announce_morning_briefing`:
```yaml
data:
  volume_level: 0.7  # 0.0 to 1.0
```

### Change Briefing Length
Edit the Ollama prompt in n8n to request longer/shorter output:
```
Keep it conversational and brief (maximum 30 seconds when spoken - about 75 words)
```

### Add More Smart Home Data
Add new HTTP Request nodes in n8n to fetch additional Home Assistant entity states.

## Troubleshooting

### Briefing Not Triggering
- Check `input_boolean.morning_briefing_delivered` state (should be `off`)
- Check time is between 5:00-9:00 AM
- Check automation is enabled in Home Assistant
- Check Home Assistant logs for errors

### No Telegram Message
- Verify Telegram bot credentials in n8n
- Check chat ID is correct (6299872789)
- Check n8n workflow is active
- Check n8n execution logs

### No Voice Announcement
- Verify Google Nest Audio (media_player.living_room_speaker) is online
- Test with `script.test_bedroom_tts`
- Check Home Assistant logs for TTS errors
- Ensure volume is adequate (70% default)

### Ollama Timeout
- Check Ollama is running: `docker ps | grep ollama`
- Check model is downloaded: `docker exec ollama ollama list`
- Verify n8n can reach Ollama at `http://ollama:11434`

## Future Enhancements

- Add weather alerts (storm warnings, etc.)
- Include commute time/traffic conditions
- Add news sentiment analysis (positive vs negative)
- Include yesterday's accomplishments from task manager
- Add Bitcoin/stock market updates
- Include package delivery notifications
- Add local events happening today
- Include meal suggestions based on time and weather

---

**Created:** December 5, 2025
**Status:** Home Assistant components ✅ Complete | n8n workflow ⏳ Pending build
