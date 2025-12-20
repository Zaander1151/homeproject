# Future Voice Assistant Projects

## Custom ESP32 → n8n Voice System (Option D)

**Status:** Planned for future exploration
**Date Added:** 2025-11-29

### Concept
Build a completely independent voice assistant system that bypasses Home Assistant and ESPHome entirely, using custom firmware on the Atom Echo devices that communicate directly with n8n workflows.

### Architecture Vision

```
Atom Echo (Custom Firmware)
  ↓ (button press to record)
Audio Recording via I2S microphone
  ↓ (HTTP POST)
n8n Webhook Endpoint
  ↓
n8n Workflow:
  - Transcribe audio (Whisper API or local Faster Whisper)
  - Process intent/query
  - Send to Ollama for AI response
  - Generate TTS audio (Piper or other TTS service)
  - Return audio file URL
  ↓
Atom Echo downloads and plays audio via I2S speaker
```

### Hardware
- 3 x M5Stack Atom Echo devices (already owned)
- Custom ESP-IDF or Arduino firmware
- I2S microphone and speaker (already configured in ESPHome - can reuse pins)

### Technical Challenges to Solve

1. **Wake Word Detection**
   - On-device wake word (current ESPHome uses micro_wake_word)
   - May need to implement button-press activation instead
   - Alternative: Always-listening with VAD (Voice Activity Detection)

2. **Audio Handling**
   - Capture I2S audio stream from microphone
   - Encode to WAV/MP3 format
   - HTTP POST multipart/form-data to n8n
   - Download and play TTS audio response

3. **Firmware Development**
   - ESP-IDF framework (currently using this in ESPHome)
   - HTTP client for webhook communication
   - Audio codec libraries
   - LED status indicators (reuse current patterns)

4. **n8n Workflow Design**
   - Webhook trigger for audio upload
   - Speech-to-text node (multiple options)
   - Ollama conversation node
   - TTS generation node
   - Response with audio file or URL

5. **Network Reliability**
   - WiFi reconnection handling
   - Request timeout handling
   - Fallback responses if n8n is down

### Advantages Over Current Setup

- **Full Control:** Complete customization of voice pipeline logic
- **n8n Power:** Access to 400+ n8n integrations in voice workflows
- **Independent:** Not tied to Home Assistant updates/breaking changes
- **Experimentation:** Easy to test different STT/TTS/LLM services
- **Multi-Modal:** Could add visual responses to n8n dashboard

### Disadvantages vs Current Setup

- **Development Time:** Significant effort to replicate ESPHome's polish
- **Maintenance:** More code to maintain vs YAML config
- **Wake Word:** Harder to implement on-device wake word
- **Latency:** Likely slower than optimized Wyoming protocol
- **Lose ESPHome Features:** OTA updates, easy reconfiguration, Home Assistant integration

### Skills Required

- ESP32 programming (C/C++ with ESP-IDF or Arduino)
- I2S audio protocol understanding
- HTTP/REST API integration
- n8n workflow development
- Audio codec knowledge (WAV, MP3, encoding/decoding)

### Estimated Effort

- **Research Phase:** 4-8 hours (find libraries, proof of concept)
- **Basic Implementation:** 20-40 hours (working button-press voice assistant)
- **Wake Word Integration:** 10-20 hours (if pursuing on-device wake word)
- **Polish & Reliability:** 10-15 hours (error handling, LED feedback, etc.)

**Total:** 44-83 hours for a production-quality system

### Why This Is Worth Exploring

1. **Learning Opportunity:** Deep dive into ESP32 audio and n8n capabilities
2. **Flexibility:** Could enable voice interfaces that HA can't easily do
3. **Portability:** Could deploy voice assistants in locations without HA
4. **Integration Power:** n8n can connect to services HA doesn't support
5. **Fun Factor:** Building custom embedded systems is rewarding!

### Next Steps (When Ready)

1. Research existing ESP32 voice projects:
   - ESP32 Whisper examples
   - ESP32 HTTP audio streaming projects
   - M5Stack Atom Echo community projects

2. Prototype simple version:
   - Button press → record 5 seconds → POST to n8n
   - n8n echoes back with TTS
   - ESP32 plays response

3. Build out full workflow:
   - Add Ollama integration
   - Implement conversation context
   - Add LED status indicators
   - Create fallback responses

4. Consider wake word options:
   - Port micro_wake_word to custom firmware
   - Use edge-impulse for custom wake word
   - Accept button-press only for simplicity

### Related Projects to Reference

- [ESP32 Audio I2S Examples](https://github.com/espressif/esp-idf/tree/master/examples/peripherals/i2s)
- [M5Stack Atom Echo Arduino Library](https://github.com/m5stack/M5Atom)
- [ESP32 HTTP Client Examples](https://github.com/espressif/esp-idf/tree/master/examples/protocols/esp_http_client)

### Resources Needed

- Time to dedicate to learning/building
- Test environment (can use spare Atom Echo)
- n8n workflow space (already have n8n running)
- Patience for debugging audio issues!

---

## Notes

This is a **future exploration project**, not urgent. The current Home Assistant + ESPHome setup works well once properly configured. This would be pursued for:
- Learning and experimentation
- Situations where HA integration isn't needed
- Maximum flexibility and control

Consider this after the main home automation system is stable and working well.
