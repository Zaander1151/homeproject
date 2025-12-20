# Fix Atom Echo Voice Assistant - Step by Step Guide

**Date:** 2025-11-29
**Current Issue:** Voice assistant responds to "OK Nabu" but gives minimal responses and doesn't understand most commands
**Root Cause:** Using basic Home Assistant conversation agent instead of Ollama-powered "Malory" agent

---

## Current Configuration Analysis

### What's Working ✅
- Wake word detection ("OK Nabu") - using on-device micro_wake_word
- Speech-to-text - Wyoming Whisper (Faster Whisper)
- Text-to-speech - Wyoming Piper (en_US-hfc_female-medium voice)
- ESP32 devices are online and connected
- Ollama is running with multiple models available

### What's Not Working ❌
- Natural language understanding (too literal, pattern matching only)
- Conversational responses (robotic, minimal)
- Understanding varied command phrasings

### Why It's Not Working
The Atom Echo devices are using the "Home Assistant" pipeline which uses the basic `conversation.home_assistant` agent. This agent only recognizes exact phrases defined in your automations.

You have a "Malory" pipeline configured that uses Ollama (AI-powered), but it's NOT set as the preferred/default pipeline.

---

## Solution: Switch to Malory (Ollama) Pipeline

### Step 1: Access Voice Assistant Settings

1. Open Home Assistant web UI: http://192.168.40.5:8123
2. Click on **Settings** (gear icon in sidebar)
3. Click on **Voice assistants**
4. You should see two pipelines:
   - **Home Assistant** (currently preferred ⭐)
   - **Malory** (Ollama-powered)

### Step 2: Check Malory Configuration

Click on **Malory** pipeline to verify its settings:

**Expected Configuration:**
- **Conversation agent:** conversation.malory (Ollama Conversation)
- **Speech-to-text:** stt.faster_whisper
- **Text-to-speech:** tts.piper
- **Voice:** en_US-hfc_female-medium
- **Language:** en (English)

If any of these are missing or incorrect, update them.

### Step 3: Option A - Set Malory as Default (Recommended)

**Make Malory the preferred pipeline for ALL voice assistants:**

1. In the Voice assistants settings page
2. Click the **⭐ star icon** next to "Malory" to make it preferred
3. The star should move from "Home Assistant" to "Malory"

This will make all your Atom Echo devices use Malory by default.

**Test it:**
- Say: "OK Nabu, what's the weather like?"
- Say: "OK Nabu, tell me a joke"
- Say: "OK Nabu, what time is it?"

You should get conversational responses instead of robotic ones.

### Step 4: Option B - Assign Malory to Specific Devices

**If you want to keep Home Assistant as default but use Malory for specific devices:**

1. Go to **Settings** → **Devices & Services**
2. Search for "living room voice" or "office voice"
3. Click on the device
4. Find the **Voice assistant** setting
5. Change from "Preferred pipeline" to **"Malory"**
6. Repeat for each Atom Echo device

---

## Step 5: Configure Ollama Conversation Agent

The "Malory" conversation agent needs to be properly configured to use Ollama.

### Check Ollama Integration

1. Go to **Settings** → **Devices & Services**
2. Click on **+ ADD INTEGRATION** (if not already added)
3. Search for **"Ollama"**
4. If not installed, add it with these settings:
   - **Host:** http://ollama:11434 (if in same Docker network)
   - **OR:** http://192.168.40.5:11434 (if using host network)
5. Click **Submit**

### Configure Malory Conversation Agent

1. Go to **Settings** → **Devices & Services**
2. Find **Ollama** integration
3. Click **CONFIGURE**
4. Set the following:
   - **Model:** `llama3.1:8b-instruct-q4_K_M` (recommended for voice)
     - Alternatives: `llama3:8b`, `mistral:latest`, `dolphin-mistral:7b`
   - **Prompt Template:** (see below)
   - **Temperature:** 0.7 (balanced creativity)
   - **Max Tokens:** 150 (keep responses concise for voice)
   - **Top P:** 0.9

**Recommended Prompt Template for Voice Assistant:**
```
You are Malory, a helpful home automation voice assistant.

Current date and time: {{ now().strftime('%A, %B %d, %Y at %I:%M %p') }}

User's home information:
- Temperature: {{ states('sensor.my_ecobee_current_temperature') }}°F
- Weather: {{ states('sensor.hamilton_weather_temperature') }}°F outside
- Bronco status: {{ states('lock.fordpass_doorlock') }}

Keep responses SHORT and CONVERSATIONAL for voice output (1-3 sentences max).
Be friendly and helpful. If you don't know something, say so honestly.

User: {{ prompt }}
Malory:
```

---

## Step 6: Test Voice Commands

Try these test phrases to verify Malory is working:

### General Conversation
- "OK Nabu, what's the weather?"
- "OK Nabu, what time is it?"
- "OK Nabu, tell me about the temperature"
- "OK Nabu, is my Bronco locked?"

### Home Assistant Queries
- "OK Nabu, what's the temperature inside?"
- "OK Nabu, what's the weather outside?"

### Your Existing Automations (Should Still Work)
- "OK Nabu, pause" (Plex control)
- "OK Nabu, good night" (bedtime routine)
- "OK Nabu, make coffee in the morning"

---

## Troubleshooting

### Issue: Malory responds but answers are still generic

**Solution:** Malory can't access Home Assistant state unless you expose entities:

1. Go to **Settings** → **Voice assistants**
2. Click on **Malory** pipeline
3. Click **Expose entities**
4. Enable these entities:
   - `climate.my_ecobee`
   - `sensor.hamilton_weather_temperature`
   - `lock.fordpass_doorlock`
   - `sensor.pixel_10_pro_battery_level`
   - All `media_player.plex_*` entities

### Issue: Responses are too long and rambling

**Solution:** Adjust Ollama settings:
- Reduce **Max Tokens** to 100
- Lower **Temperature** to 0.5
- Update prompt template to emphasize brevity

### Issue: Responses are too slow

**Solution:** Try a smaller/faster model:
- Switch from `llama3.1:8b-instruct-q4_K_M`
- To: `mistral:latest` or `llama3.2:latest` (smaller, faster)

### Issue: Voice commands still don't work

**Check Wyoming services are running:**
```bash
docker ps | grep wyoming
```

Should show:
- wyoming-whisper (STT)
- wyoming-piper (TTS)
- wyoming-openwakeword (wake word)

**Check ESPHome device logs:**
```bash
docker exec -it esphome esphome logs living-room-voice.yaml
```

Look for errors related to voice assistant pipeline.

---

## Advanced: Create Custom Intents

If you want Malory to trigger specific Home Assistant automations:

### Example: "Turn on bedroom fan" Intent

1. Go to **Settings** → **Voice assistants** → **Malory**
2. Click **Custom sentences**
3. Add sentence pattern:
   ```
   Turn on [the] bedroom fan
   Turn bedroom fan on
   Start [the] bedroom fan
   ```
4. Link to action:
   - Service: `switch.turn_on`
   - Entity: `switch.bedroom_fan`

This combines natural language understanding (Malory) with specific device control.

---

## Alternative: Hybrid Approach

Keep both pipelines and use them for different purposes:

**Home Assistant Pipeline (Specific Commands):**
- Plex controls ("pause", "play", "volume up")
- Exact automation triggers ("good night", "make coffee")
- Fast, deterministic responses

**Malory Pipeline (Conversational):**
- Questions about home state
- Weather queries
- General information
- Conversational interactions

**How to switch between them:**
Set Home Assistant as preferred, but create a custom automation:

```yaml
- alias: "Voice - Switch to Conversation Mode"
  trigger:
    - platform: conversation
      command:
        - "let's talk"
        - "conversation mode"
        - "I want to chat"
  action:
    - service: notify.persistent_notification
      data:
        message: "Conversation mode enabled"
    # Manually switch pipeline for next query
```

---

## Recommended Next Steps

1. **Set Malory as preferred pipeline** (Option A above)
2. **Test with simple questions** to verify Ollama is responding
3. **Expose key entities** so Malory can answer home queries
4. **Tune the prompt template** to get desired response style
5. **Adjust max tokens** if responses are too long
6. **Keep existing automations** - they should still work via custom sentences

---

## Expected Results

After switching to Malory, you should experience:

✅ Natural language understanding (varied phrasings work)
✅ Conversational responses (friendly, context-aware)
✅ Ability to ask questions about your home
✅ Better handling of unclear/ambiguous commands
✅ All existing Plex voice controls still work
✅ All existing automations still trigger

The voice assistant should feel more like talking to a person than issuing commands to a robot.

---

## Notes

- Ollama responses take 1-3 seconds (GPU accelerated) - this is normal
- First query after idle may be slower (model loading)
- Malory uses local Ollama - no cloud/internet required
- You can switch back to basic "Home Assistant" pipeline anytime
- Both pipelines can coexist - choose per device or globally

---

## Which Model Should I Use?

**For Voice Assistant (Balance of Speed & Quality):**
- `llama3.1:8b-instruct-q4_K_M` ⭐ Recommended
- `mistral:latest` - Faster, still good
- `llama3:8b` - Good alternative

**For Faster Responses (Smaller Models):**
- `llama3.2:latest` (3.2B parameters - very fast)
- `granite4:micro` (3.4B parameters)

**For Better Conversation (Slower):**
- `dolphin-mistral:7b` - Uncensored, creative
- `llama2-uncensored:7b` - More flexible

**Current Best Choice:**
`llama3.1:8b-instruct-q4_K_M` - already downloaded, well-tuned for instructions, good speed on GPU

---

## Testing Checklist

After configuration, test these scenarios:

- [ ] Wake word detection: "OK Nabu" → LED lights up
- [ ] Simple question: "What time is it?"
- [ ] Home query: "What's the temperature?"
- [ ] Weather: "What's the weather outside?"
- [ ] Existing automation: "Pause" (Plex)
- [ ] Existing automation: "Good night"
- [ ] Complex question: "Should I wear a jacket today?"
- [ ] Unknown query: "What's the meaning of life?" (should handle gracefully)

All should work with natural, conversational responses.
