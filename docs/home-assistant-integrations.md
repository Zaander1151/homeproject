# Home Assistant Integrations

**Last Scanned:** 2025-10-30
**Home Assistant Version:** 2025.10.x
**Total Integrations:** 29+

---

## ✅ Integrated Devices & Services

### Smart Home Devices (7 integrations)

#### ESP32/ESPHome Devices (2)
1. **Living Room Voice** (192.168.40.107)
   - Device: M5Stack Atom Echo 01cf84
   - MAC: f4:65:0b:01:cf:84
   - Integration: ESPHome
   - Features: Voice assistant, wake word detection

2. **Office Voice** (192.168.40.108)
   - Device: Office Voice a11a74
   - MAC: 00:4b:12:a1:1a:74
   - Integration: ESPHome
   - Features: Voice assistant, wake word detection

#### Climate Control (1)
3. **Ecobee Thermostat** (192.168.40.104)
   - Device: My ecobee
   - MAC: 6c:74:de:4d:c9:10
   - Integration: HomeKit Controller
   - Features: Temperature control, sensors, scheduling

#### Smart Plugs (1)
4. **TP-Link Smart Plug HS103** (192.168.40.110)
   - Device: Bedroom Fan HS103
   - MAC: 3c:52:a1:ed:2b:e7
   - Integration: TP-Link Kasa
   - Control: Bedroom fan

#### Google Cast Devices (3)
5. **Google Nest Hub** (192.168.40.100)
   - Integration: Google Cast
   - Features: Smart display, casting, announcements

6. **Living Room Chromecast** (192.168.40.101)
   - Device: Living Room TV (Android TV Remote)
   - MAC: DC:E5:5B:B4:EC:8F
   - Integration: Google Cast + Android TV Remote
   - Connected: Roku TV HDMI1

7. **Google Nest Audio** (192.168.40.102)
   - Integration: Google Cast
   - Features: Smart speaker, casting, announcements

---

### Entertainment & Media (2 integrations)

8. **Roku TV** (192.168.40.99)
   - Device: 43" TCL Roku TV
   - Model: YN004G797344
   - Integration: Roku
   - Features: Media control, power, volume, input switching

9. **Plex Media Server** (192.168.40.201)
   - Server: Plex Server
   - URL: https://192-168-40-201.d1103884d1024a6db8ffafa8e970b5d9.plex.direct:32400
   - Integration: Plex
   - Features: Media library, playback control

---

### Mobile & Notifications (2 integrations)

10. **Google Pixel 10 Pro** (192.168.40.250)
    - App: Home Assistant Companion (Android)
    - Version: 2025.8.7-full
    - Features: Push notifications, location tracking, sensors
    - Entities: Battery, steps, location, and more

11. **Telegram Bot** - HAT
    - Bot: 8039402084:AAEEN05...
    - User: Alex (6299872789)
    - Integration: Telegram
    - Features: Notifications, commands

---

### Voice Assistant & AI (6 integrations)

#### Wyoming Protocol Pipeline (3)
12. **Wyoming Whisper** (wyoming_whisper:10300)
    - Service: faster-whisper
    - Purpose: Speech-to-text (STT)
    - Model: tiny-int8

13. **Wyoming Piper** (wyoming_piper:10200)
    - Service: piper
    - Purpose: Text-to-speech (TTS)
    - Voice: en_US-amy-medium

14. **Wyoming OpenWakeWord** (wyoming_openwakeword:10400)
    - Service: openwakeword
    - Purpose: Wake word detection
    - Models: ok_nabu, hey_mycroft, hey_jarvis

#### AI Services (3)
15. **Google Generative AI**
    - API: Google AI (Gemini)
    - Sub-services:
      - Conversation agent
      - TTS (text-to-speech)
      - STT (speech-to-text)
      - AI task automation

16. **Ollama** (http://192.168.40.201:11434/)
    - Models: llama3.2:latest, llama2-uncensored:7b
    - Custom Agent: **Malory** (friendly AI chatbot)
    - Features: Conversation, AI tasks, local LLM inference
    - Prompt: Custom personality for home automation assistance

17. **Google Translate TTS**
    - Language: English
    - TLD: .com
    - Purpose: Fallback text-to-speech

---

### Infrastructure & Monitoring (4 integrations)

18. **MQTT Broker** (mosquitto:1883)
    - Broker: mosquitto container
    - Purpose: IoT device communication
    - Integration: MQTT

19. **Portainer** (http://192.168.40.201:9000/)
    - Integration: Portainer
    - Features: Docker container management and monitoring

20. **InfluxDB** (influxdb:8086)
    - Version: 2.x
    - Organization: homeassistant
    - Bucket: homeassistant
    - Purpose: Time-series data storage
    - Note: Configured in configuration.yaml

21. **Prometheus** (prometheus:9090)
    - Purpose: Metrics collection
    - Note: Running in homeassistant-network
    - Retention: 30 days

---

### Calendar & Productivity (2 integrations)

22. **Google Calendar** (hazzard25@gmail.com)
    - Integration: Google
    - Access: Read/Write
    - Features: Calendar events, automation triggers

23. **Local To-Do List** - Home Setup Items
    - Integration: Local To-Do
    - Purpose: Task tracking

24. **Shopping List**
    - Integration: Shopping List (built-in)
    - Purpose: Grocery/shopping tracking

---

### Weather & Location (2 integrations)

25. **Environment Canada** - Burlington
    - Station: ON/s0000368
    - Language: English
    - Coordinates: 43.233, -79.786
    - Features: Canadian weather forecasts

26. **Met.no Weather** - Home
    - Integration: Met.no (Norwegian Meteorological Institute)
    - Track home: Yes
    - Features: Weather forecasting

---

### Other Integrations (6)

27. **Sun** (solar calculations)
    - Integration: Sun
    - Features: Sunrise/sunset automation triggers

28. **Thread** (Matter/Thread devices)
    - Discovered: Google Nest Hub (Kitchen) as border router
    - Purpose: Matter/Thread device support

29. **Browser Mod**
    - Integration: Browser Mod (HACS)
    - Features: Browser-based automations and controls

30. **Media Extractor**
    - Integration: Media Extractor
    - Purpose: Extract media URLs from various sources

31. **Bluetooth** (hci0)
    - Adapter: 58:10:31:EA:CA:18 (Hon Hai Precision)
    - Status: Configured
    - Purpose: Bluetooth device discovery

32. **FordPass** - Vehicle
    - VIN: 3FMCR9C68PRD61702
    - Username: hazzard25@gmail.com
    - Units: km, kPa (Canadian)
    - Features: Vehicle status, remote start, location

---

## Integration Summary by Category

### Smart Home Control (10 devices)
- ✅ 2 ESP32 voice assistants (ESPHome)
- ✅ 1 Ecobee thermostat (HomeKit)
- ✅ 1 TP-Link smart plug (Kasa)
- ✅ 3 Google Cast devices (Nest Hub, Nest Audio, Chromecast)
- ✅ 1 Roku TV
- ✅ 1 Plex server
- ✅ 1 Ford vehicle (FordPass)

### Voice & AI (6 services)
- ✅ Wyoming Whisper (STT)
- ✅ Wyoming Piper (TTS)
- ✅ Wyoming OpenWakeWord
- ✅ Google Generative AI (Gemini)
- ✅ Ollama with custom "Malory" agent
- ✅ Google Translate TTS

### Infrastructure (4 services)
- ✅ MQTT
- ✅ InfluxDB
- ✅ Prometheus
- ✅ Portainer

### Mobile & Notifications (2)
- ✅ Google Pixel 10 Pro (HA Companion app)
- ✅ Telegram Bot

### Productivity (3)
- ✅ Google Calendar
- ✅ Shopping List
- ✅ Local To-Do

### Weather (2)
- ✅ Environment Canada
- ✅ Met.no

---

## Custom AI Agent: "Malory"

**Platform:** Ollama (llama2-uncensored:7b)
**Purpose:** Friendly AI chatbot for home automation

**Personality Traits:**
- Friendly and genuinely funny
- Witty assistant
- No conversational boundaries
- Remembers context from conversations
- Interests: Sports, electronics DIY, networking, AI

**Capabilities:**
- Direct answers for simple queries
- Follow-up questions for complex topics
- Step-by-step guidance
- Brainstorming partner
- Optimized for voice output via Assist Pipeline

---

## Voice Assistant Pipeline Flow

```
User speaks → ESP32 M5Stack (Living Room/Office)
             ↓
         Wake word detected (Wyoming OpenWakeWord: "ok nabu")
             ↓
         Audio captured → Home Assistant
             ↓
         Wyoming Whisper (STT) → Text
             ↓
         Ollama "Malory" OR Google Gemini (Intent processing)
             ↓
         Response generated → Wyoming Piper (TTS) → Audio
             ↓
         Audio played on ESP32 speaker
```

---

## Disabled Integrations

1. **MJPEG Camera** - G5 Webcam (192.168.40.65:8081)
   - Status: Disabled by user
   - Integration: MJPEG

---

## Integration Statistics

**Total Active Integrations:** 32
**Smart Devices:** 10
**AI/Voice Services:** 6
**Infrastructure Services:** 4
**Mobile/Notifications:** 2
**Calendar/Productivity:** 3
**Weather Services:** 2
**Media/Entertainment:** 2
**Other:** 3

---

## HACS (Home Assistant Community Store)

**Status:** ✅ Installed
**Token:** GitHub personal access token configured
**Experimental Features:** Enabled

**Custom Components:**
- Browser Mod
- (Other HACS integrations may be installed)

---

## Network Configuration

**Trusted Networks:**
- 192.168.64.0/20 (Cloudflare Tunnel network)
- 192.168.40.0/24 (Local network)
- 127.0.0.1 (Localhost)

**Trusted Device (Bypass Login):**
- 192.168.40.100 (Google Nest Hub in Kitchen)

---

## Data Storage

**Time-Series Database:**
- InfluxDB 2.x (homeassistant bucket)
- Excludes: automation, script domains
- Tags: friendly_name, source

**Home Assistant Database:**
- SQLite: home-assistant_v2.db (28MB)
- Location: /config/

**Media Directories:**
- `/media` → NAS media share (//192.168.40.200/media-share)
- `/recordings` → Local M.2 recordings

---

## Automation Capabilities

With these integrations, you can create automations for:

✅ **Voice Control:**
- Control devices via ESP32 voice assistants
- Custom commands via Ollama "Malory"
- Wake word: "ok nabu"

✅ **Climate Automation:**
- Ecobee thermostat scheduling
- Temperature-based triggers

✅ **Entertainment:**
- Roku TV control
- Plex playback automation
- Cast announcements to Google devices

✅ **Notifications:**
- Push to Pixel 10 Pro
- Telegram messages
- TTS announcements

✅ **Presence & Tracking:**
- Phone location tracking
- Daily steps monitoring
- Battery health tracking

✅ **Smart Scheduling:**
- Google Calendar triggers
- Sun-based automations (sunrise/sunset)
- Weather-based conditions

✅ **Media Management:**
- Plex integration
- Media extraction

✅ **Vehicle Integration:**
- Ford vehicle status
- Remote start
- Location tracking

---

## Recommendations

### Already Excellent Coverage! 🎉

Your Home Assistant setup is **very comprehensive**. You have:
- ✅ Full voice assistant pipeline with custom AI
- ✅ All identified Google devices integrated
- ✅ Ecobee and TP-Link devices connected
- ✅ Roku TV control
- ✅ Comprehensive monitoring (InfluxDB, Prometheus, Portainer)
- ✅ Mobile app with rich sensors

### Potential Additions

1. **Additional ESP32 Projects**
   - You have the infrastructure ready for more voice assistants
   - ESPHome makes it easy to add sensors

2. **Automation Expansion**
   - Voice-activated scenes
   - Multi-room audio coordination
   - Climate schedules based on presence

3. **Integration Opportunities**
   - Dell PC (.226) - Wake-on-LAN integration
   - Main Computer (.13) - Wake-on-LAN integration
   - Additional sensors/devices as needed

---

## Quick Reference

**Voice Assistants:** 2 ESP32 M5Stack devices
**AI Agents:** Ollama "Malory" + Google Gemini
**Smart Devices:** 10 integrated
**Mobile App:** Pixel 10 Pro with sensors
**Weather:** 2 sources (Environment Canada + Met.no)
**Calendar:** Google Calendar
**Notifications:** Telegram + Push

**Voice Pipeline:** OpenWakeWord → Whisper → Malory/Gemini → Piper

---

**For detailed device information, see:**
- Network topology: `/home/hazzard/homeproject/docs/network-topology.md`
- Device map: `/home/hazzard/homeproject/docs/network-device-map.md`
