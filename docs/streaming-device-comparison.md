# Streaming Device Comparison for TSN & Sportsnet Voice Control

## The Problem with Your Current Setup

- **Roku TV**: Has TSN ✅ but NO Sportsnet ❌
- **Chromecast**: Has both TSN + Sportsnet ✅ but requires manual TV input switching ❌

**You need a single device that has BOTH apps AND supports direct app launching via Home Assistant.**

## Recommended Solutions

### 🏆 **BEST OPTION: Chromecast with Google TV (4K)**

**Price:** ~$50-70 CAD

**Why This Is Perfect:**
- ✅ **Both TSN and Sportsnet apps** available
- ✅ **Android TV platform** = excellent Home Assistant integration
- ✅ **Direct app launching** via voice commands
- ✅ **No input switching required** (replaces your current Chromecast)
- ✅ **Built-in Google Assistant** (optional, but you'll use Malory instead)
- ✅ **4K HDR support**
- ✅ **Remote included** (for initial setup or backup)

**Home Assistant Integration:**
```yaml
# Uses androidtv integration - supports full app control
androidtv:
  - name: Living Room Chromecast
    host: 192.168.40.XXX
    device_class: androidtv
```

**Voice Commands:**
- *"Hey Malory, watch TSN"* → Launches TSN app directly
- *"Hey Malory, watch Sportsnet"* → Launches Sportsnet app directly
- *"Hey Malory, open CBC Gem"* → Launches CBC for free hockey
- *"Hey Malory, turn off the TV"* → Powers down

**Apps Available:**
- TSN ✅
- Sportsnet NOW ✅
- CBC Gem ✅ (free Hockey Night in Canada)
- Pluto TV ✅
- Netflix, Prime, Disney+, etc.

---

### 🥈 **SECOND CHOICE: Amazon Fire TV Stick 4K**

**Price:** ~$50-80 CAD

**Why This Works:**
- ✅ **Both TSN and Sportsnet apps** available
- ✅ **Good Home Assistant integration** (via Android Debug Bridge)
- ✅ **Direct app launching** possible
- ✅ **4K HDR support**
- ✅ **Alexa built-in** (optional)
- ✅ **Frequent sales** (often $30-40 on Prime Day/Black Friday)

**Home Assistant Integration:**
```yaml
# Uses androidtv integration with ADB
androidtv:
  - name: Living Room Fire TV
    host: 192.168.40.XXX
    adb_server_ip: 192.168.40.201  # Your Home Assistant host
    device_class: firetv
```

**Voice Commands:**
- *"Hey Malory, watch TSN"* → Launches TSN
- *"Hey Malory, watch Sportsnet"* → Launches Sportsnet
- *"Hey Malory, pause"* → Playback control
- *"Hey Malory, turn off TV"* → Powers down

**Slight Downside:**
- Requires enabling ADB (Developer Mode) - one-time setup
- Amazon's UI can be more cluttered with ads

---

### 🥉 **THIRD CHOICE: Apple TV 4K**

**Price:** ~$150-200 CAD

**Why This Is Expensive But Premium:**
- ✅ **Both TSN and Sportsnet apps** available
- ✅ **Home Assistant integration** available
- ✅ **Best overall streaming experience**
- ✅ **Fastest performance**
- ✅ **No ads in UI**
- ✅ **4K HDR, Dolby Vision, Dolby Atmos**
- ❌ **Most expensive option**
- ⚠️ **App launching is more limited** in Home Assistant

**Home Assistant Integration:**
```yaml
# Uses apple_tv integration
# Auto-discovered, requires pairing
```

**Voice Commands:**
- Playback control works great
- App launching is possible but more complex
- Power control works

**Best If:**
- You're already in the Apple ecosystem
- You want the absolute best streaming quality
- Budget isn't a concern

---

## Detailed Comparison Table

| Feature | Chromecast w/ Google TV | Fire TV Stick 4K | Apple TV 4K |
|---------|-------------------------|------------------|-------------|
| **Price** | $50-70 | $50-80 | $150-200 |
| **TSN App** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Sportsnet App** | ✅ Yes | ✅ Yes | ✅ Yes |
| **CBC Gem** | ✅ Yes | ✅ Yes | ✅ Yes |
| **HA Integration Quality** | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐⭐ Very Good | ⭐⭐⭐ Good |
| **App Launch via Voice** | ✅ Easy | ✅ Easy | ⚠️ Complex |
| **Setup Difficulty** | Easy | Medium (ADB) | Easy |
| **Performance** | Great | Great | Excellent |
| **UI Ads** | Minimal | Moderate | None |
| **Remote Quality** | Good | Good | Excellent |
| **4K HDR** | ✅ Yes | ✅ Yes | ✅ Yes |

---

## ⚠️ WARNING: Google Hardware Concerns

**Important Consideration:** Google has had significant issues with:
- Gemini rollout causing hardware problems
- History of discontinuing products and services
- Potential class action lawsuits regarding hardware handling
- Frequent service shutdowns (Google Graveyard)

**If you're frustrated with current Google products, avoid Chromecast with Google TV.**

---

## 🏆 REVISED RECOMMENDATION: Amazon Fire TV Stick 4K Max

**Cost:** ~$70-80 CAD (often on sale for $40-50)
**Setup Time:** 20 minutes
**Result:** Full voice control of TSN, Sportsnet, and all other streaming apps

### Why Fire TV Instead of Google?

1. **Amazon is more committed to hardware** - Fire TV is a mature, stable platform
2. **Better long-term support** - Fire TV has been around for years, not going anywhere
3. **Same functionality as Chromecast** - Android TV base, excellent Home Assistant integration
4. **No Google frustrations** - Completely independent ecosystem
5. **Frequent sales** - Often $30-50 during Prime Day, Black Friday, Boxing Day
6. **Both apps available** - TSN and Sportsnet fully supported

### Fire TV Setup Process:

1. **Buy Fire TV Stick 4K Max** (~$70 CAD, watch for sales)
2. **Connect to your Roku TV** (HDMI port, preferably HDMI 1)
3. **Install TSN and Sportsnet apps** from Amazon Appstore
4. **Enable Developer Mode** and ADB on Fire TV (Settings → My Fire TV → About → click 7 times)
5. **Add to Home Assistant** via androidtv integration
6. **Configure voice commands** in Home Assistant
7. **Test:** *"Hey Malory, watch TSN"*
8. **Done!** No Google hardware needed

---

## Alternative: Keep Your Current Chromecast?

**If you have a Chromecast with Google TV already:**

Your current Chromecast might already support this! Let me check:

**Standard Chromecast (dongle, no remote):**
- ❌ **Cannot launch apps directly** via Home Assistant
- This is what you currently have - NOT recommended

**Chromecast with Google TV (has remote, runs Android TV):**
- ✅ **CAN launch apps directly** via Home Assistant
- If this is what you have, we can configure it now!

**To check what you have:**
- Does your Chromecast have a remote? → **Chromecast with Google TV** ✅
- Is it just a dongle with no remote? → **Regular Chromecast** ❌

---

## Free Legal Sports Streaming (Bonus)

With any of these devices, you also get:

### **CBC Gem - Hockey Night in Canada (100% FREE)**
- Saturday NHL games
- Playoffs
- No subscription required
- Just create a free CBC account

**Voice command:** *"Hey Malory, watch Hockey Night in Canada"*

### **Pluto TV - Free Sports Channels (100% FREE)**
- NFL Channel (highlights and shows)
- Sports documentaries
- Ad-supported but completely free

**Voice command:** *"Hey Malory, open Pluto TV"*

---

## Next Steps

### ✅ RECOMMENDED: Buy Fire TV Stick 4K Max
1. **Order from Amazon.ca** (~$70, watch for sales - often $40-50)
2. **Best Buy also carries them** if you prefer in-store
3. **Wait for a sale** - Amazon regularly discounts these heavily
4. Set it up on your TV
5. I'll help you configure Home Assistant integration
6. Configure voice commands
7. Enjoy remote-free sports streaming!

### Option 2: Go Premium with Apple TV 4K
1. Buy Apple TV 4K ($150-200)
2. Best streaming experience, premium price
3. No Google, no Amazon - pure Apple ecosystem
4. I'll help with Home Assistant setup

### Option 3: Keep Current Setup (Not Recommended)
1. Continue using Roku for TSN
2. Manual input switching for Sportsnet on Chromecast
3. No additional cost, but no voice convenience

**My advice: Wait for a Fire TV sale (often 40-50% off) and grab one then. You'll get the voice control you want without giving more money to Google.**

---

## Sources

- [TSN Streaming FAQ](https://www.tsn.ca/streaming-faq-1.1105604)
- [TSN App Support](https://www.tsn.ca/help/faq/)
- [Sportsnet on App Store](https://apps.apple.com/ca/app/sportsnet/id602321016)
- [Home Assistant Apple TV Integration](https://www.home-assistant.io/integrations/apple_tv/)
- [Home Assistant Android TV Integration](https://www.home-assistant.io/integrations/androidtv/)
- [HA-Firemote GitHub - Android TV Remote Control](https://github.com/PRProd/HA-Firemote)

---

## Configuration Examples

### Fire TV Stick 4K Max Setup (RECOMMENDED)

**1. Enable ADB on Fire TV:**
- Settings → My Fire TV → About
- Click on your Fire TV name 7 times (enables Developer Mode)
- Go back → Settings → My Fire TV → Developer Options
- Enable "ADB Debugging" and "Apps from Unknown Sources"
- Note your Fire TV IP address (Settings → My Fire TV → About → Network)

**2. Add to Home Assistant `/config/configuration.yaml`:**

```yaml
# Fire TV Stick
androidtv:
  - name: Living Room Fire TV
    host: 192.168.40.XXX  # Your Fire TV IP
    device_class: firetv
    adb_server_ip: 192.168.40.201  # Your Home Assistant host IP
```

**Note:** The first time you connect, you'll need to approve the ADB connection on your Fire TV screen.

---

### Alternative: Chromecast with Google TV Setup (NOT RECOMMENDED DUE TO GOOGLE ISSUES)

**1. Enable ADB on Chromecast:**
- Settings → System → About
- Click "Android TV OS build" 7 times (enables Developer Mode)
- Settings → System → Developer Options
- Enable "USB Debugging" and "Network Debugging"

**2. Add to Home Assistant `/config/configuration.yaml`:**

```yaml
# Android TV / Chromecast with Google TV
androidtv:
  - name: Living Room TV
    host: 192.168.40.XXX  # Your Chromecast IP
    device_class: androidtv
```

**3. Create Scripts `/config/scripts.yaml`:**

```yaml
watch_tsn:
  alias: "Watch TSN"
  sequence:
    - service: androidtv.adb_command
      target:
        entity_id: media_player.living_room_tv
      data:
        command: "am start -n ca.bellmedia.tsn/.ui.activity.SplashActivity"

watch_sportsnet:
  alias: "Watch Sportsnet"
  sequence:
    - service: androidtv.adb_command
      target:
        entity_id: media_player.living_room_tv
      data:
        command: "am start -n com.sportsnet.mobile/.ui.activity.SplashActivity"

watch_cbc_gem:
  alias: "Watch CBC Gem"
  sequence:
    - service: androidtv.adb_command
      target:
        entity_id: media_player.living_room_tv
      data:
        command: "am start -n ca.cbc.gem/.ui.activity.MainActivity"
```

**4. Add Voice Commands `/config/configuration.yaml`:**

```yaml
conversation:
  intents:
    WatchTSN:
      - "watch TSN"
      - "open TSN"
      - "turn on TSN"
      - "watch sports"

    WatchSportsnet:
      - "watch Sportsnet"
      - "open Sportsnet"
      - "turn on Sportsnet"

    WatchHockeyNight:
      - "watch hockey night"
      - "watch hockey night in Canada"
      - "watch the game"

intent_script:
  WatchTSN:
    speech:
      text: "Opening TSN"
    action:
      - service: script.watch_tsn

  WatchSportsnet:
    speech:
      text: "Opening Sportsnet"
    action:
      - service: script.watch_sportsnet

  WatchHockeyNight:
    speech:
      text: "Opening CBC Gem for Hockey Night in Canada"
    action:
      - service: script.watch_cbc_gem
```

**5. Test Voice Commands:**
- *"Hey Malory, watch TSN"*
- *"Hey Malory, watch Sportsnet"*
- *"Hey Malory, watch hockey night"*

**Done! No remotes needed!**

---

## Pro Tips

### Game Time Macro

Create a single command that does everything:

```yaml
game_time:
  alias: "Game Time Mode"
  sequence:
    - service: media_player.turn_on
      target:
        entity_id: media_player.living_room_tv
    - delay:
        seconds: 3
    - service: script.watch_tsn
    - service: light.turn_off
      target:
        area_id: living_room  # If you have smart lights
```

**Voice command:** *"Hey Malory, it's game time!"*

Result:
1. TV turns on
2. TSN launches
3. Lights dim/off
4. Enjoy the game!

### Schedule-Based Automation

Automatically remind you when games start:

```yaml
- id: leafs_game_reminder
  alias: "Leafs Game Starting"
  trigger:
    - platform: time
      at: "19:00:00"  # 7 PM
  condition:
    - condition: time
      weekday:
        - wed
        - sat
  action:
    - service: tts.speak
      target:
        entity_id: media_player.living_room_voice
      data:
        message: "The Leafs game is starting in 30 minutes. Say 'it's game time' when you're ready."
```

---

## Final Recommendation

**Buy: Fire TV Stick 4K Max for ~$70 (often $40-50 on sale)**

This gives you:
- ✅ Full voice control
- ✅ TSN + Sportsnet apps
- ✅ No input switching
- ✅ No remotes needed
- ✅ Excellent Home Assistant integration
- ✅ Free CBC Gem for Hockey Night
- ✅ No Google hardware frustrations
- ✅ Mature, stable platform
- ✅ Frequent sales

**Given your valid concerns about Google hardware, Fire TV is the better choice. Wait for a sale if possible - Amazon discounts these heavily during Prime Day, Black Friday, and Boxing Day.**

**Let me know when you get it and I'll help you set up the voice commands!**
