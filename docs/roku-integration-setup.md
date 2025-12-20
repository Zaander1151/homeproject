# Roku Integration Setup - UI Configuration

## The Problem

The Roku integration no longer supports YAML configuration. It must be set up via the Home Assistant UI.

**Error you saw:**
```
The 'roku' integration does not support YAML setup, please remove it from your configuration
```

This has been fixed - the YAML config was removed and Home Assistant has been restarted.

---

## Setup Steps (Do This Now)

### Step 1: Add Roku Integration via UI

1. **Open Home Assistant:** http://192.168.40.201:8123

2. **Navigate to Settings:**
   - Click **Settings** (gear icon in sidebar)
   - Click **Devices & Services**

3. **Add Integration:**
   - Click **+ Add Integration** (bottom right)
   - Search for "Roku"
   - Click on **Roku**

4. **Enter Roku IP:**
   - Host: `192.168.40.103`
   - Click **Submit**

5. **Verify:**
   - You should see "Roku" appear in your integrations list
   - It should show your TV model name

---

### Step 2: Find the Roku Entity ID

After adding the integration:

1. **Go to Settings → Devices & Services**
2. **Click on "Roku"** integration
3. **Look for the media player entity**
   - It will be named something like:
     - `media_player.roku_yp00xxxxxxxx` (random ID)
     - OR `media_player.living_room_roku`
     - OR `media_player.tcl_roku_tv`

4. **Note the exact entity_id**
   - We need this for the scripts

---

### Step 3: Update Scripts with Correct Entity ID

Once you know the entity ID, I need to update the scripts.

**Tell me what the entity ID is, and I'll update the configuration.**

For example, if it's `media_player.roku_yp001234567`:
- I'll update all scripts to use that instead of `media_player.roku`

---

## Quick Test After Setup

Once the integration is added and scripts are updated:

**Via Home Assistant UI:**
1. Settings → Devices & Services → Roku
2. Click on the media player entity
3. Try "Select Source" → "TSN"
4. TV should launch TSN

**Via Voice (after scripts updated):**
- *"Hey Nabu, watch TSN"*
- Should work!

---

## Alternative: Auto-Discovery

If you don't want to manually add it:

1. **Settings → Devices & Services**
2. Look for "Discovered" section
3. Your Roku might show up automatically
4. Click **Configure** if you see it

This is easier if it appears, but manual add always works.

---

## Troubleshooting

### Roku not discovered:
- Make sure Roku TV is ON
- Make sure it's on the same network (192.168.40.0/24)
- Try pinging it: `ping 192.168.40.103`
- Try manual add with IP

### Can't connect:
- Verify Roku IP hasn't changed (check router)
- Restart Roku TV
- Make sure no firewall blocking port 8060

### Entity not appearing:
- Wait 30 seconds after adding integration
- Refresh the page
- Check Settings → Devices & Services → Roku
- Look for media_player entities

---

## Next Steps

1. ✅ Add Roku integration via UI (do this now)
2. ⏳ Find the entity ID
3. ⏳ Tell me the entity ID
4. ⏳ I'll update the scripts
5. ⏳ Test voice commands

**Let me know when you've added the integration and what the entity ID is!**
