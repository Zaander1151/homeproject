# Voice Media Request Setup - Current Status

## ✅ What's Working:

### i2p Setup:
- **i2p router running** on ports 4444 (HTTP), 4446 (SOCKS5), 7657 (console)
- **SOCKS5 proxy configured** for Prowlarr at 192.168.40.201:4446
- Prowlarr proxy saved successfully
- **Note:** i2p trackers may take 2-4 hours to fully integrate into network

### Documentation Site:
- **Running at:** http://192.168.40.201:8888
- Full project documentation with Material Design theme
- Auto-updates when markdown files change

### Home Assistant Configuration:
- REST command `n8n_media_request` configured at `https://malory.hssupport.ca/webhook/media-request`
- Automation triggers on conversation command "request"
- Sends full sentence text to n8n for AI parsing
- Chat ID: 6299872789

## ✅ Voice Media Requests - FULLY OPERATIONAL

### The Solution:
AI-powered parsing with Ollama (llama3.2):

1. Say: "Ok Nabu, request [anything]"
2. Home Assistant sends full text to n8n webhook
3. n8n uses Ollama AI to parse title and detect if it's a movie/TV show
4. Searches Overseerr
5. AI Agent node ready to intelligently select best result
6. Sends Telegram confirmation with details and buttons
7. On confirm, requests via Overseerr → Radarr/Sonarr → qBittorrent

### Current Status:

✅ **Workflow imported and activated**
✅ **Home Assistant automation configured**
✅ **REST command configured**
✅ **Supports movies AND TV shows**
✅ **Telegram integration working**
✅ **Ollama AI parsing improved for TV show detection**
✅ **AI Agent node added for intelligent result selection**
✅ **Tested successfully:**
   - Movies: "The Matrix" → Radarr → qBittorrent ✅
   - TV Shows: "Severance" → Sonarr ✅

### How to Use:

Just say to your Atom Echo voice assistant:
- **"Ok Nabu, request The Matrix"** (movie)
- **"Ok Nabu, request Severance"** (TV show)
- **"Ok Nabu, request Breaking Bad"** (TV show)
- **"Ok Nabu, request Inception"** (movie)

You'll get a Telegram message with movie/show details and Confirm/Cancel buttons!

**See:** `/home/hazzard/homeproject/VOICE_MEDIA_REQUEST_QUICKSTART.md` for detailed documentation

## 📁 Important Files:

**n8n Workflows:**
- `/mnt/storage/n8n-smart-media-request-workflow.json` - AI-powered parser (USE THIS)
- `/mnt/storage/n8n-movie-request-workflow.json` - Old movie-only version

**Home Assistant:**
- `/home/hazzard/home-assistant/config/configuration.yaml` - REST commands
- `/home/hazzard/home-assistant/config/automations.yaml` - Voice automation (id: voice_media_request)

**Documentation:**
- `/home/hazzard/homeproject/docs/voice-movie-requests-setup.md`
- Live at: http://192.168.40.201:8888

## 🔑 Key Details:

- **Overseerr API:** MTc2NDQ1NjgzNjIzNzdhODg0Nzg2LTg1NDEtNGUzZi05ZWIyLTlkOWYxOTYzNGI4OQ==
- **Telegram Chat ID:** 6299872789
- **n8n Webhook:** https://malory.hssupport.ca/webhook/media-request
- **Ollama Model:** llama3.2:latest (for AI parsing)

## 🐛 Issues Resolved:

- ❌ Custom sentences with wildcards don't work in HA
- ❌ Conversation trigger with wildcards (*) matches areas
- ✅ **Solution:** Send full text to n8n, let AI parse it

## 📋 Completed Tasks:

- [x] Import workflow into n8n
- [x] Test with: "Ok Nabu, request The Matrix" ✅
- [x] Test with TV show: "Ok Nabu, request Severance" ✅
- [x] Improve Ollama AI for better TV show detection
- [x] Add AI Agent node for intelligent result selection
- [x] Fix Telegram inline keyboard buttons
- [x] Fix callback data parsing (handle = prefix)
- [x] Fix Overseerr request format for TV shows (seasons: "all")
- [ ] Verify i2p trackers working (wait 2-4 hours for network integration)
- [ ] Configure Sonarr automatic search settings (optional)
