# Voice Movie Request Setup - COMPLETE ✅

## Configuration Summary

Your voice-controlled movie request system is now fully configured!

### What Was Configured:

1. **n8n Workflow:**
   - Webhook URL: `https://malory.hssupport.ca/webhook/movie-request`
   - Workflow imported and activated
   - Connected to Overseerr API
   - Telegram bot configured (hsnotifications)

2. **Home Assistant REST Command:**
   - Added to `/home/hazzard/home-assistant/config/configuration.yaml`
   - Calls n8n webhook with movie name and chat ID

3. **Home Assistant Automation:**
   - Added to `/home/hazzard/home-assistant/config/automations.yaml`
   - Listens for "RequestMovie" conversation command
   - Your Telegram Chat ID: `6299872789`

4. **Custom Voice Sentences:**
   - Already exists at `/home/hazzard/home-assistant/config/custom_sentences/en/media_requests.yaml`

### How to Use:

Say "**Ok Nabu**" followed by any of these:
- "request The Dark Knight"
- "request the movie Inception"
- "I want to watch Interstellar"
- "download Avatar"
- "get The Matrix"
- "add Blade Runner"

### The Flow:

1. **You say:** "Ok Nabu, request The Dark Knight"
2. **Home Assistant** extracts "The Dark Knight" and sends to n8n
3. **n8n** searches Overseerr for the movie
4. **You receive** a Telegram message with:
   - Movie title, year, and description
   - Poster image
   - Current status (Available/Pending/Not Requested)
   - ✅ Confirm / ❌ Cancel buttons
5. **You tap "Confirm"** in Telegram
6. **n8n** requests the movie via Overseerr
7. **Overseerr** sends to Radarr for download
8. **Success message** sent to Telegram

### Testing:

Try it now:
1. Say "Ok Nabu, request The Matrix"
2. Check your Telegram for the confirmation message
3. Tap the ✅ Confirm button
4. Movie should appear in Radarr's queue

### Troubleshooting:

**Voice command not working:**
- Check Home Assistant logs: `docker logs homeassistant | grep -i conversation`
- Verify custom sentences loaded: Developer Tools → Services → `conversation.reload`

**No Telegram message received:**
- Check n8n execution logs (click workflow → Executions tab)
- Verify webhook URL is accessible
- Check that Telegram credential is configured in all Telegram nodes

**Movie not requested:**
- Check Overseerr logs: `docker logs overseerr`
- Verify Radarr is connected in Overseerr settings
- Check quality profile and root folder are set in Overseerr

### Configuration Files Modified:

- `/home/hazzard/home-assistant/config/configuration.yaml` - Added rest_command
- `/home/hazzard/home-assistant/config/automations.yaml` - Added voice automation
- `/home/hazzard/home-assistant/config/custom_sentences/en/media_requests.yaml` - Voice patterns (already existed)

### Next Steps / Enhancements:

- [ ] Add TV show request support
- [ ] Add quality profile selection via Telegram
- [ ] Add search refinement for multiple matches
- [ ] Add status checking: "Ok Nabu, what's the status of The Matrix?"
- [ ] Add download progress notifications

## Documentation

Full setup guide available at:
- Local docs: http://192.168.40.201:8888
- File: `/home/hazzard/homeproject/docs/voice-movie-requests-setup.md`

---

**Setup completed:** 2025-11-30
**n8n Workflow:** Voice Movie Request with Telegram Confirmation
**Telegram Bot:** hsnotifications
**Chat ID:** 6299872789
