# Voice Media Request - Quick Start Guide

## Current Status: READY TO IMPORT

The AI-powered media request workflow is complete and ready for import into n8n.

## What This Does

Say **"Ok Nabu, request The Dark Knight"** and the system will:

1. Home Assistant captures your voice command
2. Sends the full text to n8n webhook
3. n8n uses Ollama AI (llama3.2) to parse:
   - Media type (movie or TV show)
   - Title
4. Searches Overseerr for matches
5. Sends you a Telegram message with:
   - Movie/show details
   - Poster image
   - Current availability status
   - Confirm/Cancel buttons
6. On confirmation, requests via Overseerr → Radarr/Sonarr

## Import and Setup (5 minutes)

### Step 1: Import Workflow

1. Open n8n: http://192.168.40.201:5678
2. Click **Workflows** → **Add workflow** → **Import from File**
3. Select: `/mnt/storage/n8n-smart-media-request-workflow.json`
4. Click **Import**

### Step 2: Configure Telegram Credentials

The workflow has 5 Telegram nodes that need the `hsnotifications` credential:

1. **Send Telegram Confirmation** (line 158)
2. **Send Not Found** (line 178)
3. **Telegram - Button Press** (trigger, line 196)
4. **Send Success** (line 293)
5. **Send Cancelled** (line 312)

**For each node:**
- Click the node
- In the right panel, find **Credential for Telegram API**
- Select: **hsnotifications** (should already exist)
- If it doesn't exist, create it with your Telegram bot token

### Step 3: Activate Workflow

1. Click the **Inactive** toggle in the top-right
2. Should show **Active** in green
3. Verify webhook URL shows: `/webhook/media-request`

### Step 4: Test

Say to your Atom Echo: **"Ok Nabu, request The Matrix"**

**Expected flow:**
1. Voice assistant confirms: "I'm searching for that. Check Telegram for confirmation."
2. Within 5-10 seconds, Telegram message appears with:
   - Movie title, year, overview
   - Poster image
   - Current status (Available/Pending/Not Requested)
   - Two buttons: ✅ Confirm Request | ❌ Cancel
3. Tap **✅ Confirm Request**
4. Message updates to: "✅ Request Successful! Your media has been added to the queue."
5. Check Overseerr → Radarr to see the download start

## Troubleshooting

### "I'm searching for that" but no Telegram message

**Check n8n execution:**
1. Open n8n → Executions tab
2. Look for recent execution of "Smart Media Request with AI Parsing"
3. Click to view details and see where it failed

**Common issues:**
- Ollama not responding → check `docker logs ollama`
- Overseerr API error → verify API key in workflow
- Telegram credential missing → configure credentials per Step 2

### "Unknown intent request"

**Check Home Assistant automation:**
```bash
docker exec homeassistant cat /config/automations.yaml | grep -A 15 voice_media_request
```

Should show:
```yaml
- id: voice_media_request
  alias: "Voice Media Request - Send to n8n"
  trigger:
    - platform: conversation
      command:
        - request
```

### Red flash on Atom Echo (no response)

**Check Home Assistant logs:**
```bash
docker logs homeassistant 2>&1 | tail -50 | grep -i "conversation\|intent\|request"
```

### Telegram message shows wrong media

**Ollama parsing issue:**
1. Check n8n execution details
2. Look at "Parse Request with Ollama" node output
3. Verify the prompt is correctly extracting title
4. Try different phrasing: "request movie The Matrix" or "request the dark knight"

## File Locations

**Workflow:**
- `/mnt/storage/n8n-smart-media-request-workflow.json` (ready to import)
- `/home/hazzard/homeproject/n8n-smart-media-request-workflow.json` (original)

**Home Assistant Config:**
- `/home/hazzard/home-assistant/config/configuration.yaml` (REST command configured)
- `/home/hazzard/home-assistant/config/automations.yaml` (voice automation configured)

**Documentation:**
- This file: `/home/hazzard/homeproject/VOICE_MEDIA_REQUEST_QUICKSTART.md`
- Detailed guide: `/home/hazzard/homeproject/docs/voice-movie-requests-setup.md`
- Web docs: http://192.168.40.201:8888

## Key Details

**Telegram Chat ID:** 6299872789
**Overseerr API Key:** MTc2NDQ1NjgzNjIzNzdhODg0Nzg2LTg1NDEtNGUzZi05ZWIyLTlkOWYxOTYzNGI4OQ==
**Ollama Model:** llama3.2:latest
**n8n Webhook:** https://malory.hssupport.ca/webhook/media-request

## What Works Now

- ✅ Home Assistant voice automation configured
- ✅ REST command to n8n webhook configured
- ✅ n8n workflow created with AI parsing
- ✅ JSON validated and ready to import
- ✅ Overseerr API integration configured
- ✅ Telegram bot integration configured
- ✅ Supports both movies AND TV shows

## Next Steps After Testing

1. **Add more voice commands:**
   - "search for [media]" instead of just "request"
   - "find [media]"

2. **Enhance AI parsing:**
   - Add year detection: "request The Matrix from 1999"
   - Add season/episode for TV: "request Breaking Bad season 2"

3. **Add Telegram bot commands:**
   - Direct messaging: "request The Dark Knight" to Telegram bot
   - Bypass voice assistant entirely

4. **Track request history:**
   - Log all requests to InfluxDB
   - Create Grafana dashboard for media requests
