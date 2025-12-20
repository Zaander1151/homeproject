# Wake Word Options for Your Voice Assistant

## Current Setup

**Current Wake Word:** "Ok Nabu"
**Desired Wake Word:** "Hey Malory"

**Bad News:** There is no pre-trained "Hey Malory" wake word model available for Wyoming OpenWakeWord.

---

## Available Pre-Trained Wake Words

These are the wake words you can use **right now** without any training:

1. **alexa** - "Alexa"
2. **hey_mycroft** - "Hey Mycroft"
3. **hey_jarvis** - "Hey Jarvis" ⭐ (Similar vibe to "Hey Malory")
4. **hey_rhasspy** - "Hey Rhasspy"
5. **ok_nabu** - "Ok Nabu" (your current wake word)

**Source:** [Wyoming OpenWakeWord GitHub](https://github.com/rhasspy/wyoming-openwakeword)

---

## Option 1: Use "Hey Jarvis" (Closest Alternative)

"Hey Jarvis" is the closest pre-trained option to "Hey Malory" - it's got that AI assistant vibe from Iron Man.

### To Switch to "Hey Jarvis":

**1. Edit docker-compose.yml:**

```bash
cd /home/hazzard/home-assistant
nano docker-compose.yml
```

**2. Find the openwakeword section and change:**

```yaml
FROM:
    command: --preload-model 'ok_nabu'

TO:
    command: --preload-model 'hey_jarvis'
```

**3. Restart the container:**

```bash
docker-compose restart openwakeword
```

**4. Test it:**

Say: *"Hey Jarvis, turn on the TV"*

---

## Option 2: Train Custom "Hey Malory" Wake Word

You can train your own "Hey Malory" wake word, but it requires time and effort.

### Requirements:

- **Time:** 1-3 hours for training
- **Tools:** Google Colab (free) or local Python environment
- **Audio samples:** 100-3000 voice clips saying "Hey Malory"
- **Technical skill:** Moderate (following a tutorial)

### Training Process:

**Method A: Synthetic Training (Easier, recommended)**

1. Use text-to-speech (TTS) to generate thousands of "Hey Malory" clips
2. Vary speakers, accents, speeds, room acoustics
3. Add background noise (music, conversation, etc.)
4. Train the model using [OpenWakeWord Google Colab notebook](https://colab.research.google.com/drive/1q1oe2zOyZp7UsB3jJiQ1IFn8z5YfjwEb?usp=sharing)
5. Export the `.tflite` model file
6. Add to Wyoming OpenWakeWord

**Method B: Personal Voice Training (More accurate for you)**

1. Record yourself saying "Hey Malory" 100+ times
2. Vary tone, volume, distance from mic
3. Combine with 2900 synthetic samples
4. Train using the same Colab notebook
5. This will be more accurate for YOUR voice

**Sources:**
- [OpenWakeWord Training Guide](https://github.com/dscripka/openWakeWord/blob/main/docs/custom_verifier_models.md)
- [Training Custom Wake Words - Home Assistant](https://www.home-assistant.io/voice_control/create_wake_word/)
- [Community Experience Training Custom Wake Words](https://github.com/dscripka/openWakeWord/discussions/45)

### Adding Custom Model to Wyoming:

Once you have your `hey_malory.tflite` file:

**1. Create custom models directory:**

```bash
mkdir -p /home/hazzard/home-assistant/openwakeword-custom
```

**2. Copy your model:**

```bash
cp hey_malory.tflite /home/hazzard/home-assistant/openwakeword-custom/
```

**3. Edit docker-compose.yml:**

```yaml
openwakeword:
  container_name: wyoming_openwakeword
  image: rhasspy/wyoming-openwakeword:latest
  restart: unless-stopped
  hostname: wyoming_openwakeword
  command: --custom-model-dir /custom-models --preload-model 'hey_malory'
  ports:
    - "10400:10400"
  volumes:
    - ./openwakeword-custom:/custom-models  # Add this line
  networks:
    - default
```

**4. Restart:**

```bash
docker-compose restart openwakeword
```

**5. Test:**

*"Hey Malory, turn on the TV"*

---

## Option 3: Community Wake Words

Check the [Home Assistant Wake Words Collection](https://github.com/fwartner/home-assistant-wakewords-collection) for community-trained models.

**Popular community wake words:**
- Custom names
- Character references (e.g., "Hey JARVIS", "Computer", "Friday")
- Custom phrases

**To use:**
1. Download the `.tflite` file from the community repo
2. Follow the same steps as Option 2 for adding custom models

---

## Option 4: Just Mentally Call It "Malory"

**Simplest option:**
- Keep "Ok Nabu" or switch to "Hey Jarvis"
- Mentally think of it as talking to "Malory"
- No configuration changes needed

**Rationale:**
- The wake word is just a trigger
- Once triggered, you're still talking to your "Malory" assistant
- The voice assistant's personality is defined by how it responds, not the wake word

---

## My Recommendation

### **Short-term: Switch to "Hey Jarvis"**

**Why:**
- 5-minute change (edit one line, restart container)
- More natural than "Ok Nabu"
- Similar AI assistant vibe to "Malory"
- Pre-trained and reliable

**How:**
```bash
cd /home/hazzard/home-assistant
nano docker-compose.yml
# Change: --preload-model 'ok_nabu'
# To:     --preload-model 'hey_jarvis'
docker-compose restart openwakeword
```

---

### **Long-term: Train "Hey Malory" (if motivated)**

**Why:**
- Perfect match for your assistant name
- Customized to your voice
- Unique to your setup

**When:**
- You have 1-3 hours to dedicate
- You're comfortable following a tutorial
- You want the "perfect" experience

**How:**
1. Use the [Google Colab training notebook](https://colab.research.google.com/drive/1q1oe2zOyZp7UsB3jJiQ1IFn8z5YfjwEb?usp=sharing)
2. Generate 3000 synthetic "Hey Malory" samples using Piper TTS
3. Record 100 personal samples
4. Train the model (takes ~1 hour in Colab)
5. Download and add to Wyoming OpenWakeWord

**Tutorial:** [Train Custom Wake Word - Home Assistant](https://www.home-assistant.io/voice_control/create_wake_word/)

---

## Comparison Table

| Option | Ease | Time | Natural? | Cost |
|--------|------|------|----------|------|
| **Keep "Ok Nabu"** | Easiest | 0 min | ⚠️ Robotic | $0 |
| **Switch to "Hey Jarvis"** | Very Easy | 5 min | ✅ Natural | $0 |
| **Train "Hey Malory"** | Moderate | 1-3 hours | ✅✅ Perfect | $0 (Colab free) |
| **Community Model** | Easy | 10-30 min | ✅ Varies | $0 |

---

## Quick Switch Guide: "Ok Nabu" → "Hey Jarvis"

**1. Edit config:**
```bash
cd /home/hazzard/home-assistant
nano docker-compose.yml
```

**2. Find this line (~line 67):**
```yaml
command: --preload-model 'ok_nabu'
```

**3. Change to:**
```yaml
command: --preload-model 'hey_jarvis'
```

**4. Save and exit** (Ctrl+X, Y, Enter)

**5. Restart:**
```bash
docker-compose restart openwakeword
```

**6. Wait 30 seconds, then test:**

*"Hey Jarvis, watch TSN"*

**Done!** ✅

---

## Training "Hey Malory" - Detailed Steps

If you want to train your own "Hey Malory" wake word:

### Step 1: Prepare Audio Data

**Option A: Synthetic Only (Easier)**

Use Piper TTS to generate clips:
```bash
# Install Piper locally or use the docker container
docker run -it --rm -v /tmp:/tmp rhasspy/wyoming-piper:latest \
  --voice en_US-amy-medium \
  --output-file /tmp/malory_sample.wav \
  "Hey Malory"
```

Repeat with variations:
- Different voices
- Different speeds
- Different emphasis
- Generate 3000+ samples

**Option B: Personal + Synthetic (Better accuracy)**

1. Record yourself saying "Hey Malory" 100 times:
   - Use your phone voice recorder
   - Vary distance, tone, volume
   - Save as WAV files
   - Name: `malory_001.wav`, `malory_002.wav`, etc.

2. Generate 2900 synthetic samples (as above)

3. Combine for training

### Step 2: Train the Model

**Use Google Colab (Free, No Setup):**

1. Open: [OpenWakeWord Training Notebook](https://colab.research.google.com/drive/1q1oe2zOyZp7UsB3jJiQ1IFn8z5YfjwEb?usp=sharing)
2. Upload your audio samples to Colab
3. Follow the notebook instructions:
   - Set wake word phrase: "Hey Malory"
   - Point to your audio samples
   - Run training cells
   - Wait ~30-60 minutes
4. Download the resulting `hey_malory.tflite` file

### Step 3: Deploy to Wyoming

**1. Create directory:**
```bash
mkdir -p /home/hazzard/home-assistant/openwakeword-custom
```

**2. Copy model:**
```bash
# Transfer hey_malory.tflite from your computer to:
/home/hazzard/home-assistant/openwakeword-custom/hey_malory.tflite
```

**3. Update docker-compose.yml:**
```yaml
openwakeword:
  container_name: wyoming_openwakeword
  image: rhasspy/wyoming-openwakeword:latest
  restart: unless-stopped
  hostname: wyoming_openwakeword
  command: --custom-model-dir /custom-models --preload-model 'hey_malory'
  ports:
    - "10400:10400"
  volumes:
    - ./openwakeword-custom:/custom-models
  networks:
    - default
```

**4. Restart:**
```bash
cd /home/hazzard/home-assistant
docker-compose restart openwakeword
```

**5. Test:**

*"Hey Malory, turn on the TV"*

---

## Troubleshooting

### Wake word not detected:
- **Check sensitivity:** Models have different thresholds
- **Background noise:** Train with realistic noise levels
- **Distance:** Train at your typical speaking distance
- **Accent:** Include your accent in training data

### False triggers:
- **Increase threshold** in model settings
- **Add negative samples** during training (similar-sounding phrases)
- **Retrain** with more diverse data

### Model not loading:
- **Check file name** matches exactly (case-sensitive)
- **Verify path** in docker-compose.yml
- **Check logs:** `docker logs wyoming_openwakeword`

---

## Sources

- [Wyoming OpenWakeWord GitHub](https://github.com/rhasspy/wyoming-openwakeword)
- [OpenWakeWord Training Documentation](https://github.com/dscripka/openWakeWord/blob/main/docs/custom_verifier_models.md)
- [Home Assistant Wake Word Guide](https://www.home-assistant.io/voice_control/create_wake_word/)
- [Community Wake Words Collection](https://github.com/fwartner/home-assistant-wakewords-collection)
- [OpenWakeWord Training Notebook (Google Colab)](https://colab.research.google.com/drive/1q1oe2zOyZp7UsB3jJiQ1IFn8z5YfjwEb?usp=sharing)
- [Training Experience Discussion](https://github.com/dscripka/openWakeWord/discussions/45)

---

## My Honest Recommendation

**Switch to "Hey Jarvis" today** (takes 5 minutes), then:

- **If you love it:** Keep it! "Hey Jarvis" is great.
- **If you want "Malory":** Dedicate a weekend afternoon to training your custom model.

Training a custom wake word is a fun project if you're into tinkering, but "Hey Jarvis" is a solid, reliable option that sounds way better than "Ok Nabu" and has that AI assistant personality you're looking for.

**Want me to help you switch to "Hey Jarvis" right now?**
