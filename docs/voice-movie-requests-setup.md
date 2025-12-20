# Voice Movie Requests with Telegram Confirmation

Complete setup guide for requesting movies via voice commands ("Ok Nabu, request The Dark Knight") with Telegram confirmation.

## Architecture

```
Voice Assistant → Home Assistant → n8n Webhook → Overseerr API
                                         ↓
                                  Telegram Confirmation
                                         ↓
                                  Download via Radarr
```

## Setup Steps

### 1. Import n8n Workflow

1. Open n8n: http://192.168.40.201:5678
2. Click **Add workflow** (+ icon)
3. Click **three dots menu** → **Import from File**
4. Upload: `/home/hazzard/homeproject/n8n-movie-request-workflow.json`
5. Configure Telegram credential:
   - Click on any Telegram node (e.g., "Send Telegram Confirmation")
   - Click "+ Add new credential"
   - Name: `hsnotifications`
   - Access Token: (Your Telegram bot token)
   - Save
6. **IMPORTANT:** Get the Production Webhook URL:
   - Click the "Webhook - Movie Request" node
   - Copy the **Production URL** (e.g., `http://n8n:5678/webhook/movie-request`)
   - Save this URL for step 3
7. Click **Activate** (toggle in top right corner)

### 2. Get Your Telegram Chat ID

You need your Telegram chat ID for the automation. Two methods:

**Method A: Via your existing bot**
1. Send any message to your `hsnotifications` bot
2. In Home Assistant, go to Developer Tools → States
3. Look for `sensor.telegram_*` or check the Telegram integration
4. Your chat ID will be visible in the attributes

**Method B: Via @userinfobot**
1. Message @userinfobot on Telegram
2. It will reply with your chat ID

Save this chat ID - you'll need it in step 4.

### 3. Add REST Command to Home Assistant

Add this to `/home/hazzard/home-assistant/config/configuration.yaml`:

```yaml
rest_command:
  n8n_movie_request:
    url: "http://n8n:5678/webhook/movie-request"  # Use the URL from step 1
    method: POST
    headers:
      Content-Type: "application/json"
    payload: >
      {
        "movie_name": "{{ movie_name }}",
        "chat_id": "{{ chat_id }}"
      }
```

**Note:** Replace the URL with the actual webhook URL from step 1, step 6.

### 4. Add Automation to Home Assistant

Option A: Via YAML (add to `/home/hazzard/home-assistant/config/automations.yaml`):

```yaml
- alias: "Voice Movie Request"
  description: "Request movies via voice command with Telegram confirmation"
  trigger:
    - platform: conversation
      command:
        - "RequestMovie"
  action:
    - service: rest_command.n8n_movie_request
      data:
        movie_name: "{{ trigger.slots.movie_name.value }}"
        chat_id: "YOUR_TELEGRAM_CHAT_ID"  # Replace with your actual chat ID from step 2
    - service: tts.speak
      target:
        entity_id: tts.piper
      data:
        media_player_entity_id: "{{ trigger.device_id }}"
        message: "Searching for {{ trigger.slots.movie_name.value }}. Check Telegram for confirmation."
```

**IMPORTANT:** Replace `YOUR_TELEGRAM_CHAT_ID` with your actual chat ID from step 2.

Option B: Via UI:
1. Settings → Automations → Create Automation
2. Trigger: Conversation, Command: RequestMovie
3. Action: Call service → rest_command.n8n_movie_request
4. Add voice response with TTS

### 5. Restart Home Assistant

After adding the configuration and automation:

```bash
cd /home/hazzard/home-assistant
docker-compose restart homeassistant
```

Wait 1-2 minutes for Home Assistant to fully restart.

### 6. Verify Custom Sentences Loaded

The custom sentence file is already created at:
`/home/hazzard/home-assistant/config/custom_sentences/en/media_requests.yaml`

Home Assistant will automatically load this on restart.

## Usage

### Voice Commands

Say "Ok Nabu" followed by:
- "request The Dark Knight"
- "request the movie Inception"
- "I want to watch Interstellar"
- "download Avatar"
- "get The Matrix"
- "add Blade Runner"

### What Happens

1. Voice assistant captures your command
2. Extracts the movie name
3. Home Assistant sends request to n8n
4. n8n searches Overseerr for the movie
5. **You receive a Telegram message** with:
   - Movie title and year
   - Description
   - Poster image
   - Current status (Available/Pending/Not Requested)
   - **Confirm/Cancel buttons**
6. **Press "Confirm"** in Telegram
7. n8n requests the movie via Overseerr
8. Overseerr sends to Radarr
9. Radarr downloads the movie
10. You get a success message on Telegram

## Troubleshooting

### Voice command not recognized
- Check Home Assistant logs: `docker logs homeassistant | grep conversation`
- Verify custom_sentences loaded: Developer Tools → Services → `conversation.reload`
- Try restarting Home Assistant

### Webhook not triggering
- Check n8n workflow is **activated** (toggle in top right)
- Verify webhook URL in Home Assistant configuration
- Check Home Assistant logs for REST command errors
- Test webhook manually: `curl -X POST http://localhost:5678/webhook/movie-request -H "Content-Type: application/json" -d '{"movie_name":"The Matrix","chat_id":"YOUR_CHAT_ID"}'`

### Telegram message not received
- Verify Telegram credential in n8n is correct
- Check n8n execution logs (click workflow name → Executions)
- Make sure chat_id is correct (number, not username)
- Test by clicking "Execute Workflow" in n8n manually

### Movie not found
- Try more specific names (include year: "The Matrix 1999")
- Check Overseerr is properly configured with TMDB
- Verify API key is correct in n8n nodes

### Movie request fails
- Check Overseerr → Settings → Radarr is configured
- Verify Radarr quality profile and root folder are set
- Check Overseerr logs: `docker logs overseerr`

## Configuration Files

- **n8n Workflow:** `/home/hazzard/homeproject/n8n-movie-request-workflow.json`
- **Custom Sentences:** `/home/hazzard/home-assistant/config/custom_sentences/en/media_requests.yaml`
- **Automation Template:** `/home/hazzard/homeproject/movie_request_automation.yaml`
- **REST Command Template:** `/home/hazzard/homeproject/movie_request_rest_command.yaml`

## API Credentials Used

- **Overseerr API Key:** `MTc2NDQ1NjgzNjIzNzdhODg0Nzg2LTg1NDEtNGUzZi05ZWIyLTlkOWYxOTYzNGI4OQ==`
- **Telegram Bot:** `hsnotifications`
- **n8n Webhook:** Production URL from workflow

## Next Steps / Enhancements

1. **Add TV Show support:** Create similar workflow for TV series
2. **Add quality selection:** Let user choose quality profile via Telegram buttons
3. **Add search refinement:** If multiple matches, show list in Telegram
4. **Add status checking:** "Ok Nabu, what's the status of The Matrix?"
5. **Add download progress:** Periodic updates on download progress

## Testing Checklist

- [ ] n8n workflow imported and activated
- [ ] Telegram credential configured in n8n
- [ ] Webhook URL copied and added to Home Assistant
- [ ] Telegram chat ID obtained
- [ ] REST command added to configuration.yaml
- [ ] Automation added with correct chat ID
- [ ] Home Assistant restarted
- [ ] Voice command test: "Ok Nabu, request The Matrix"
- [ ] Telegram message received with movie details
- [ ] Clicked "Confirm" button
- [ ] Movie successfully requested in Overseerr
- [ ] Movie appears in Radarr
