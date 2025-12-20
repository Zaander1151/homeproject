# Ethical Streaming Device Options (Non-Google/Amazon/Apple)

## The Moral Dilemma

**Eliminated Options:**
- ❌ **Google** - Gemini rollout disaster, frustrated you, kills products constantly
- ❌ **Amazon** - Fuck Jeff Bezos, he is the devil
- ❌ **Apple** - Super expensive for absolutely no reason

**What You Need:**
- ✅ TSN app support
- ✅ Sportsnet app support
- ✅ Voice control via Home Assistant
- ✅ No evil megacorp involvement

---

## The Unfortunate Reality

Here's the bad news: **Sportsnet removed their app from Roku in 2024.** According to Roku community forums, Sportsnet is no longer available on Roku devices in Canada as of April 2024. Only TSN remains.

So your current Roku TV gets you TSN but NOT Sportsnet.

---

## Option 1: NVIDIA Shield TV Pro (Least Evil Corporate Option)

**Price:** ~$250-300 CAD
**Manufacturer:** NVIDIA (GPU company, not a streaming/retail giant)

### Why NVIDIA Shield?

**The Good:**
- ✅ **Both TSN and Sportsnet apps** work perfectly (Android TV platform)
- ✅ **Excellent Home Assistant integration** - best in class
- ✅ **Most powerful streaming device** - Tegra X1+ chip, 3GB RAM
- ✅ **Not made by Google/Amazon/Apple** - Made by NVIDIA
- ✅ **Long-term support** - Shield devices from 2015 still get updates
- ✅ **No ads in UI** - Unlike Fire TV
- ✅ **Runs Android TV** - But NVIDIA's own hardware
- ✅ **Can also be a Plex server** - Bonus functionality
- ✅ **4K HDR, Dolby Vision, Dolby Atmos**

**The Bad:**
- ❌ **Expensive** - $250-300 CAD (most expensive option)
- ⚠️ **Runs Android TV** - Which is Google's OS, but hardware is NVIDIA

**The Compromise:**
- You're buying NVIDIA hardware, not Google hardware
- Android TV is the OS (Google), but you're not directly funding Google's hardware division
- NVIDIA is primarily a GPU/AI company, not an evil retail/ad giant

**Available at:**
- Best Buy Canada: ~$270
- Amazon.ca: ~$250 (but you said fuck Bezos)
- Canada Computers, Newegg.ca, Memory Express

**Home Assistant Integration:**
```yaml
androidtv:
  - name: Living Room Shield
    host: 192.168.40.XXX
    device_class: androidtv
```

**Voice Commands Work Perfectly:**
- *"Hey Malory, watch TSN"* ✅
- *"Hey Malory, watch Sportsnet"* ✅
- *"Hey Malory, it's game time"* ✅

---

## Option 2: Generic Android TV Box (Questionable Quality)

**Price:** ~$50-150 CAD
**Manufacturers:** Various Chinese OEMs (Xiaomi Mi Box, Mecool, etc.)

### Why Generic Android TV?

**The Good:**
- ✅ **Cheap** - $50-150 depending on model
- ✅ **Both TSN and Sportsnet** (if it has Google Play Store)
- ✅ **Home Assistant integration** works
- ✅ **Not from big evil corps** - Usually Chinese manufacturers

**The Bad:**
- ❌ **Quality control is sketchy** - Hit or miss
- ❌ **Updates are rare** - Many get abandoned quickly
- ❌ **Still runs Android TV** - Google's OS
- ❌ **May come with bloatware/malware** - Varies by manufacturer
- ❌ **Performance varies wildly** - Some are laggy junk

**The Risk:**
- You're gambling on quality
- May not work reliably long-term
- Could brick itself with bad firmware

**Reputable Brands:**
- **Xiaomi Mi Box S** (~$80-100) - Better quality, but harder to find in Canada
- **Mecool KM6** (~$100-150) - Decent reviews
- **Homatics Box R** (~$150) - Google-certified Android TV

**Available at:**
- Amazon.ca (but fuck Bezos)
- AliExpress (cheap, slow shipping)
- Local electronics shops in major cities

---

## Option 3: Roku + Workaround (Compromise Solution)

**Price:** $0 (you already have it)
**The Workaround:** Use your phone to cast Sportsnet to Roku TV

### How This Works:

**For TSN:**
- *"Hey Malory, watch TSN"* → Launches TSN on Roku TV ✅

**For Sportsnet:**
1. Open Sportsnet app on your phone
2. Cast to Roku TV via AirPlay (if iPhone) or screen mirroring (Android)
3. Not ideal, but works

**OR - Create a Home Assistant Automation:**

```yaml
# Automation: Watch Sportsnet (via phone casting)
watch_sportsnet_workaround:
  sequence:
    - service: notify.mobile_app_your_phone
      data:
        message: "Opening Sportsnet app for casting"
        data:
          url: "sportsnet://open"  # Deep link to app
    - service: tts.speak
      target:
        entity_id: media_player.living_room_voice
      data:
        message: "I've opened Sportsnet on your phone. Please cast it to the TV."
```

**Voice command:** *"Hey Malory, prepare Sportsnet"*
- Opens Sportsnet on your phone
- You manually cast to Roku TV
- Not perfect, but avoids buying new hardware

---

## Option 4: Wait for Sportsnet to Return to Roku

**Price:** $0
**Timeline:** Unknown

According to Roku community forums, it's up to Sportsnet to develop a Roku app. They had one, they removed it. They might bring it back.

**In the meantime:**
- Use Roku for TSN ✅
- Use your current Chromecast for Sportsnet (with input switching)
- Hope Sportsnet comes back to Roku

---

## Option 5: Build Your Own Streaming PC (Nuclear Option)

**Price:** ~$300-500
**Complexity:** High
**Overkill Factor:** Maximum

### Why This Is Insane But Awesome:

**Build a Mini PC with:**
- Intel N100 Mini PC (~$200-300)
- Install Linux + Kodi
- Full control, no corporate overlords
- Can run anything

**The Good:**
- ✅ **Total freedom** - No corporate control
- ✅ **Can run TSN/Sportsnet via web browser**
- ✅ **Home Assistant integration** via browser automation
- ✅ **No proprietary hardware**
- ✅ **You own everything**

**The Bad:**
- ❌ **Way more complex** than a streaming stick
- ❌ **No official apps** - Browser-based only
- ❌ **Overkill for your use case**
- ❌ **More power consumption**

**Only consider this if:**
- You're a tinkerer
- You want maximum control
- You have time to set it up

---

## The Harsh Truth: Pick Your Poison

**Reality Check:**
- **TSN and Sportsnet are corporate apps** that only run on corporate platforms
- Android TV is Google's OS (unavoidable for these apps)
- Fire TV is Amazon's platform (Bezos)
- Apple TV is Apple's platform (overpriced)
- Roku doesn't have Sportsnet anymore

**Your Options, Ranked by "Least Evil":**

1. **NVIDIA Shield TV Pro** ($250-300)
   - Not funding Google/Amazon/Apple hardware directly
   - NVIDIA makes GPUs, not an ad/retail empire
   - Most expensive, but best quality and least compromise

2. **Generic Android TV Box** ($50-150)
   - Questionable quality, still Google OS
   - Cheaper, but risky

3. **Keep Roku + Phone Casting Workaround** ($0)
   - No new hardware purchase
   - Slightly annoying workflow

4. **Give up on voice control for Sportsnet** ($0)
   - Keep using manual Chromecast input switching
   - Roku voice for TSN only

5. **Wait and hope Sportsnet returns to Roku** ($0)
   - Might never happen

---

## My Honest Recommendation

Given your constraints (no Google, no Amazon, no Apple, want voice control):

### **Option A: NVIDIA Shield TV Pro**

**Pros:**
- Best overall experience
- Most reliable long-term
- You're funding NVIDIA (GPU company) not Google directly
- Both apps work perfectly
- Full voice control

**Cons:**
- Expensive ($250-300)
- Still runs Android TV (Google OS)

**Moral Compromise:**
- You're buying NVIDIA hardware that happens to run Google's OS
- Not directly funding Google's hardware division
- NVIDIA is less evil than Google/Amazon/Apple (they make chips, not surveillance/retail empires)

---

### **Option B: Keep Current Setup + Workarounds**

**Pros:**
- $0 cost
- No new corporate involvement
- Roku works great for TSN

**Cons:**
- No voice control for Sportsnet
- Manual input switching for Chromecast
- Slightly annoying workflow

**Moral Compromise:**
- None - you already own the hardware

---

## What I Would Do (Honest Opinion)

If I were in your shoes with the same moral constraints:

1. **Short term:** Use Roku for TSN voice control, manual Chromecast for Sportsnet
2. **Long term:** Save up for NVIDIA Shield TV Pro and buy from Best Buy or Memory Express (not Amazon)
3. **Rationalize it:** You're buying NVIDIA hardware, they're a GPU company, not an evil empire

**The Shield is the only non-Google/Amazon/Apple option that actually works well.**

---

## Alternative: Just Use CBC Gem

**For free Saturday night hockey:**
- CBC Gem has Hockey Night in Canada
- 100% free, no subscription
- Available on Roku
- Voice command: *"Hey Malory, watch hockey night"*

**Doesn't solve NFL/other sports, but it's something.**

---

## Sources

- [Roku Community: Sportsnet app not available in Canada](https://community.roku.com/discussions/apps-and-viewing/sportsnet-app-not-available-from-canada/1077559)
- [Roku Community: Where do I find SportsNet+ app](https://community.roku.com/discussions/apps-and-viewing/where-do-i-find-the-sportsnet-app-canada/963252)
- [Best Buy Canada: NVIDIA Shield TV Pro](https://www.bestbuy.ca/en-ca/product/nvidia-shield-android-tv-pro-16gb-4k-hdr-media-streamer-english/14276267)
- [How to stream sports on any device - Best Buy Blog](https://blog.bestbuy.ca/smartphones-accessories/how-to-stream-your-favourite-sports-on-any-device)
- [Best Android TV Boxes for 2024](https://androidpcreview.com/best-android-tv-box/)
- [Home Assistant Android TV Remote Integration](https://www.home-assistant.io/integrations/androidtv_remote/)

---

## Final Answer

**You have 3 realistic choices:**

1. **Pay $250-300 for NVIDIA Shield** - Best experience, least evil corp
2. **Keep current setup with workarounds** - $0, slightly annoying
3. **Give up on Sportsnet voice control** - Roku for TSN only

**There is no perfect ethical solution here.** TSN and Sportsnet force you into corporate ecosystems. The Shield is the least-worst option that actually works.

**What do you want to do?**
