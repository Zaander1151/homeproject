# Playing Specific Movies by Voice with Plex Assistant

## The Goal

Instead of manually browsing Plex with the remote, you want to say:
- *"Ok Nabu, play The Matrix"*
- *"Ok Nabu, play Breaking Bad season 2"*
- *"Ok Nabu, play Die Hard on the living room TV"*

And have the movie/show start playing automatically.

---

## The Solution: Plex Assistant

**Plex Assistant** is a Home Assistant custom integration that lets you play specific Plex content by voice.

**What it does:**
- Searches your Plex library by voice
- Starts playback on specified devices (Roku, Chromecast, etc.)
- Supports movies, TV shows, music
- Works with Home Assistant's voice assistant (your Atom Echo devices)

**Sources:**
- [Plex Assistant GitHub](https://github.com/maykar/plex_assistant)
- [Home Assistant Community Blueprint](https://community.home-assistant.io/t/play-plex-media-on-your-media-player-using-assist-voice-command/598912)
- [Setup Tutorial](https://smarthomepursuits.com/how-to-setup-plex-assistant-in-home-assistant)

---

## Installation Steps

### Step 1: Install Plex Assistant via HACS

1. **Open Home Assistant:** http://192.168.40.201:8123

2. **Go to HACS:**
   - Sidebar → HACS
   - Click **Integrations**

3. **Add Plex Assistant:**
   - Click **+ Explore & Download Repositories** (bottom right)
   - Search: "Plex Assistant"
   - Click on **Plex Assistant**
   - Click **Download**
   - Click **Download** again to confirm

4. **Restart Home Assistant:**
   ```bash
   docker restart homeassistant
   ```

---

### Step 2: Configure Plex Assistant

After restart:

1. **Settings → Devices & Services**
2. **Click + Add Integration**
3. **Search: "Plex Assistant"**
4. **Configure:**
   - Select your Plex server (should auto-detect)
   - Follow prompts

**Note:** You already have the Plex integration set up, so this should be straightforward.

---

### Step 3: Create Voice Commands

Add to `/config/configuration.yaml`:

```yaml
# Plex voice commands
conversation:
  intents:
    PlayMovie:
      - "play {movie}"
      - "play the movie {movie}"
      - "watch {movie}"
      - "watch the movie {movie}"
      - "start {movie}"
      - "play {movie} on plex"

    PlayShow:
      - "play {show}"
      - "play the show {show}"
      - "watch {show}"
      - "watch the show {show}"
      - "play {show} season {season}"
      - "play {show} season {season} episode {episode}"

intent_script:
  PlayMovie:
    speech:
      text: "Playing {{ movie }} on Plex"
    action:
      - service: plex_assistant.command
        data:
          command: "play {{ movie }}"
          media_player: media_player.43_tcl_roku_tv

  PlayShow:
    speech:
      text: "Playing {{ show }} on Plex"
    action:
      - service: plex_assistant.command
        data:
          command: "play {{ show }}"
          media_player: media_player.43_tcl_roku_tv
```

---

## Alternative: Home Assistant Blueprint

If Plex Assistant doesn't work well, there's a simpler blueprint approach:

### Install the Blueprint:

1. **Go to:** Settings → Automations & Scenes → Blueprints
2. **Click:** Import Blueprint
3. **URL:**
   ```
   https://community.home-assistant.io/t/play-plex-media-on-your-media-player-using-assist-voice-command/598912
   ```
4. **Import**

### Configure:

1. Create automation from blueprint
2. Set trigger: Voice command "play {title}"
3. Set action: Play on Plex
4. Select target: Your Roku TV

**Voice command format:**
- *"Ok Nabu, play The Matrix"*

---

## Expected Voice Commands After Setup

### Movies:
- *"Ok Nabu, play The Matrix"*
- *"Ok Nabu, play Die Hard"*
- *"Ok Nabu, watch Inception"*
- *"Ok Nabu, play Dune on Plex"*

### TV Shows:
- *"Ok Nabu, play Breaking Bad"*
- *"Ok Nabu, play The Office season 2"*
- *"Ok Nabu, play Game of Thrones season 1 episode 3"*

### Music (if you have music in Plex):
- *"Ok Nabu, play Pink Floyd"*
- *"Ok Nabu, play Dark Side of the Moon"*

---

## How It Works

1. You say: *"Ok Nabu, play The Matrix"*
2. Wake word detected → Speech-to-text processes command
3. Home Assistant intent matches "play {movie}"
4. Plex Assistant searches your library for "The Matrix"
5. Finds the movie
6. Starts playback on your Roku TV
7. Malory confirms: "Playing The Matrix on Plex"

---

## Troubleshooting

### Movie not found:
- **Check exact title:** Plex uses the exact title from your library
- **Try variations:** "The Matrix" vs "Matrix"
- **Check library:** Make sure movie is in Plex

### Doesn't start playing:
- **Verify Plex integration:** Settings → Devices & Services → Plex
- **Check Roku entity:** `media_player.43_tcl_roku_tv` is correct
- **Test manually:** Developer Tools → Services → `plex_assistant.command`

### Speech-to-text issues:
- Speak clearly and slowly
- Use simple, common movie titles
- Avoid special characters or complex names

### Wrong device:
- Update `media_player` in intent scripts
- Can specify device in command: "play The Matrix on living room TV"

---

## Advanced: Custom Plex Commands

Plex Assistant supports more than just "play":

### Playback Control:
- *"pause"*
- *"resume"*
- *"stop"*
- *"next episode"*
- *"previous episode"*

### Navigation:
- *"jump forward 5 minutes"*
- *"jump back 30 seconds"*
- *"restart"*

### Filters:
- *"play a comedy movie"*
- *"play a recent movie"*
- *"play unwatched The Office"*

---

## Configuration Options

### Multiple Devices:

If you want to play on different devices:

```yaml
intent_script:
  PlayMovieLivingRoom:
    speech:
      text: "Playing {{ movie }} in the living room"
    action:
      - service: plex_assistant.command
        data:
          command: "play {{ movie }}"
          media_player: media_player.43_tcl_roku_tv

  PlayMovieBedroom:
    speech:
      text: "Playing {{ movie }} in the bedroom"
    action:
      - service: plex_assistant.command
        data:
          command: "play {{ movie }}"
          media_player: media_player.bedroom_chromecast
```

Voice commands:
- *"Ok Nabu, play The Matrix in the living room"*
- *"Ok Nabu, play Dune in the bedroom"*

---

## Best Practices

### Clear Pronunciation:
- Movies with simple titles work best
- "Die Hard" is easier than "Eternal Sunshine of the Spotless Mind"
- Use common abbreviations: "LOTR" for "Lord of the Rings"

### Naming in Plex:
- Keep titles simple and standard
- Use exact movie titles (as they appear in Plex)
- Avoid special characters

### Test First:
Before relying on voice:
1. Test with simple titles: "The Matrix", "Avatar", "Inception"
2. Check what speech-to-text hears in logs
3. Add misheard variations to intents if needed

---

## Integration with Existing Commands

You can combine this with your existing Roku commands:

**Current workflow:**
1. *"Ok Nabu, watchplex"* - Opens Plex app
2. Use remote to browse
3. Select movie
4. Watch

**New workflow:**
1. *"Ok Nabu, play The Matrix"* - Done!

Or keep both:
- Simple browse: *"watchplex"*
- Direct play: *"play Die Hard"*

---

## Limitations

### What Works:
✅ Movies in your Plex library
✅ TV shows and episodes
✅ Music albums and artists
✅ Starting playback
✅ Basic controls (pause, resume, stop)

### What Doesn't Work:
❌ Movies NOT in your library (can't download on-demand)
❌ Complex multi-word titles with poor speech recognition
❌ Browsing recommendations by voice
❌ Detailed playback control (subtitles, audio tracks)

### Workarounds:
- Use movie request system for new movies: *"request movie Dune 2"*
- Use remote for complex navigation
- Keep "watchplex" command for browsing

---

## Next Steps

1. **Install Plex Assistant via HACS** (see Step 1 above)
2. **Configure voice intents** (see Step 3 above)
3. **Test with simple movies:** *"Ok Nabu, play The Matrix"*
4. **Check logs** if it doesn't work
5. **Add variations** for misheard titles

**Want me to help you install and configure Plex Assistant now?**

I can:
1. Guide you through HACS installation
2. Add the voice command configuration
3. Test it with your library
4. Troubleshoot any issues

---

## Sources

- [Plex Assistant GitHub](https://github.com/maykar/plex_assistant)
- [Play Plex media using Assist voice command - Blueprint](https://community.home-assistant.io/t/play-plex-media-on-your-media-player-using-assist-voice-command/598912)
- [Play media on Plex using voice control - HA Community](https://community.home-assistant.io/t/play-media-on-plex-using-voice-control/636868)
- [How to Setup Plex Assistant in Home Assistant](https://smarthomepursuits.com/how-to-setup-plex-assistant-in-home-assistant)
- [Plex Assistant Custom Integration - HA Community](https://community.home-assistant.io/t/plex-assistant/173937)

This will get you from using remotes to pure voice control for your entire Plex library!
