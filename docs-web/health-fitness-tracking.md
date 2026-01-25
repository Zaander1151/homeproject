# Health & Fitness Tracking System

**Voice-Activated Food & Workout Tracking for Zepbound + Stronglifts 5X5**

---

## Quick Start

### Setup Status

**Components:**
- ✅ Home Assistant configuration files created
- ✅ n8n workflows created
- ✅ Stronglifts 5X5 12-week plan generated
- ⏳ **Needs setup** - Follow setup guide below

### Voice Commands

**Log Food:**
```
"Hey Nabu, I ate chicken breast"
"Hey Nabu, I had a protein shake"
```

**Log Workout:**
```
"Hey Nabu, I completed squat at 135 pounds"
"Hey Nabu, I did bench press at 115 pounds"
```

**Check Status:**
```
"Hey Nabu, what's my protein today?"
"Hey Nabu, what workout is next?"
```

---

## System Overview

This system provides **voice-activated tracking** using your existing M5Stack Atom Echo voice assistants. No new hardware needed!

**Architecture:**
```
M5Stack Atom Echo (Voice Input)
    ↓
Home Assistant (Intent Recognition)
    ↓
n8n Workflows (Processing)
    ↓
├─ Ollama (AI Protein Estimation)
├─ InfluxDB (Historical Data)
├─ Telegram (Notifications)
└─ Home Assistant (Update Trackers)
```

**Features:**
- 🎤 Natural voice commands
- 🤖 AI-powered protein estimation (Ollama qwen2.5:7b)
- 📊 Automatic Stronglifts 5X5 progression tracking
- 📈 Historical data visualization (Grafana)
- 📱 Real-time Telegram notifications
- 🏋️ Complete 12-week workout plan

---

## Documentation

**Setup Guide:**
- `/mnt/storage/automation/n8n/HEALTH-FITNESS-TRACKING-SETUP.md` - Complete setup instructions

**Workout Plan:**
- `/mnt/storage/automation/n8n/STRONGLIFTS-5X5-WORKOUT-PLAN.md` - 12-week detailed plan

**Configuration Files:**
- `/home/hazzard/home-assistant/config/packages/health_fitness_tracking.yaml`
- `/home/hazzard/home-assistant/config/custom_sentences/en/health_fitness.yaml`
- `/home/hazzard/home-assistant/config/configuration_health_intents.yaml`

**n8n Workflows:**
- `/mnt/storage/automation/n8n/food-logging-workflow.json`
- `/mnt/storage/automation/n8n/workout-logging-workflow.json`

---

## Stronglifts 5X5 Summary

**Program:** 3 workouts per week (Mon/Wed/Fri)

### Workout A
- Squat: 5x5
- Bench Press: 5x5
- Barbell Row: 5x5

### Workout B
- Squat: 5x5
- Overhead Press: 5x5
- Deadlift: 1x5

**Progression:**
- Add 5 lbs per workout to: Squat, Bench, Row, Press
- Add 10 lbs per workout to: Deadlift

**Starting Weights (Beginners):**
- Squat/Bench/Press: 45 lbs (empty bar)
- Barbell Row: 65 lbs
- Deadlift: 95 lbs

**12-Week Expected Progress:**
- Squat: 45 lbs → 215 lbs
- Bench Press: 45 lbs → 130 lbs
- Deadlift: 95 lbs → 255 lbs

---

## Setup Instructions (Quick)

### 1. Configure Home Assistant

```bash
# Files already created, just need to activate

# Add to /home/hazzard/home-assistant/config/configuration.yaml:
homeassistant:
  packages: !include_dir_named packages

intent_script: !include configuration_health_intents.yaml

conversation:

# Restart Home Assistant
docker restart homeassistant
```

### 2. Get Home Assistant Token

1. Visit: http://192.168.40.201:8123
2. Profile → "Create Token"
3. Name: `n8n Health Tracking`
4. Copy token

### 3. Import n8n Workflows

1. Visit: http://192.168.40.201:5678
2. Import: `/mnt/storage/automation/n8n/food-logging-workflow.json`
3. Import: `/mnt/storage/automation/n8n/workout-logging-workflow.json`
4. Update tokens in both workflows:
   - Home Assistant token (from step 2)
   - InfluxDB token
   - Telegram credentials
5. Activate both workflows

### 4. Test

Say to your voice assistant:
```
"Hey Nabu, I ate a protein shake"
```

You should receive a Telegram notification with protein estimate!

---

## Daily Workflow

### Morning (Workout Days - Mon/Wed/Fri)

**7:00 AM Automatic:**
- 📱 Telegram: Workout reminder with today's exercises
- 🔊 Voice: "Good morning! Today is workout day."

### At the Gym

Log each exercise as you complete it:

```
"I completed squat at 135 pounds"
"I completed bench press at 115 pounds"
"I completed barbell row at 120 pounds"
```

Each log:
- ✅ Confirms via voice
- 📱 Sends Telegram notification
- 📊 Logs to InfluxDB
- 🔄 Auto-calculates next workout weight

When finished:
```
"I finished my workout"
```

### Throughout the Day (Meals)

Log food after eating:

```
"I ate grilled chicken"
"I had greek yogurt"
"I ate eggs"
```

Each log:
- 🤖 AI estimates protein content
- 📊 Adds to daily total
- 📱 Sends Telegram confirmation

### Evening (8:00 PM)

**Low Protein Alert (if < 50% goal):**
```
⚠️ Low Protein Alert

Current: 75g
Goal: 150g
Remaining: 75g

Consider a protein shake before bed! 🥤
```

### Midnight

**Automatic:**
- Reset daily protein counter
- Send daily summary via Telegram

---

## Nutrition Guidelines (Zepbound)

**Daily Protein Goal:** 0.8-1.0g per pound of ideal body weight

**High-Protein Foods:**

| Food | Protein |
|------|---------|
| Chicken breast (4 oz) | 30g |
| Greek yogurt (1 cup) | 20g |
| Eggs (2 large) | 12g |
| Protein shake | 25-30g |
| Salmon (4 oz) | 25g |
| Cottage cheese (1 cup) | 25g |
| Ground turkey (4 oz) | 28g |
| Tofu (1/2 cup) | 10g |
| Lentils (1 cup) | 18g |

**Meal Structure:**
- Breakfast: 30-40g protein
- Lunch: 40-50g protein
- Dinner: 40-50g protein
- Snacks: 20-30g protein

**Example Day (150g goal):**
- Breakfast: 4 eggs + Greek yogurt = 44g
- Lunch: 6 oz chicken breast = 45g
- Dinner: 8 oz salmon = 50g
- Snack: Protein shake = 30g
- **Total: 169g** ✅

---

## Viewing Progress

### Home Assistant Dashboard

**Visit:** http://192.168.40.201:8123

**Create a card:**
```yaml
type: entities
title: Health & Fitness Tracking
entities:
  - entity: input_number.daily_protein_grams
    name: "Protein Today"
  - entity: sensor.protein_percentage
    name: "Goal Progress"
  - entity: input_select.current_workout
    name: "Next Workout"
  - entity: input_number.squat_weight
  - entity: input_number.bench_press_weight
  - entity: input_number.deadlift_weight
```

### Grafana Dashboards

**Visit:** http://192.168.40.201:3001

**Create graphs for:**
- Daily protein intake trend
- Workout weight progression (all 5 exercises)
- Total workout volume per session
- Workout frequency (days per week)

**Sample InfluxDB queries:**

```sql
-- Protein intake over last 30 days
SELECT sum("protein_grams")
FROM "food_intake"
WHERE time > now() - 30d
GROUP BY time(1d)

-- Squat progression
SELECT mean("weight")
FROM "workout"
WHERE "exercise" = 'Squat'
GROUP BY time(1d)
```

---

## Troubleshooting

### Voice Commands Not Working

**Check Home Assistant logs:**
```bash
docker logs -f homeassistant | grep -i intent
```

**Verify files loaded:**
```bash
docker exec homeassistant ls -la /config/packages/
docker exec homeassistant ls -la /config/custom_sentences/en/
```

**Try rephrasing:**
- ❌ "Log chicken" → ✅ "I ate chicken breast"
- ❌ "Squat 135" → ✅ "I completed squat at 135 pounds"

### Protein Estimate Wrong

**Issue:** AI estimates seem off

**Solutions:**
1. Be more specific: "I ate a 30 gram protein shake"
2. Check Ollama model: `docker exec ollama ollama list`
3. Pull latest model: `docker exec ollama ollama pull qwen2.5:7b`

### Telegram Not Sending

**Check n8n executions:**
- http://192.168.40.201:5678 → Executions
- Look for failed executions
- Check error messages

**Verify Telegram credentials:**
- n8n → Credentials → Telegram Account
- Test the credential

### Weights Not Auto-Updating

**Check n8n workflow:**
- Verify Home Assistant token is correct
- Test webhook manually:
  ```bash
  curl -X POST http://192.168.40.201:5678/webhook/log-workout \
    -H "Content-Type: application/json" \
    -d '{"exercise": "squat", "weight": 135, "sets": 5, "reps": 5}'
  ```

**Check Home Assistant entity:**
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  http://192.168.40.201:8123/api/states/input_number.squat_weight
```

---

## Next Steps

### Week 1 Goals

- ✅ Complete first workout Wednesday
- ✅ Log all 3 workouts (Wed/Fri + next Mon)
- ✅ Hit protein goal 5 out of 7 days
- ✅ Set up Grafana dashboard

### Month 1 Goals

- 🎯 Complete 12/12 workouts
- 🎯 Hit protein goal 20+ days
- 🎯 Squat: 45 lbs → 105 lbs
- 🎯 Deadlift: 95 lbs → 155 lbs

### Long-Term

- Continue Stronglifts 5X5 for 6-12 months
- Consider adding body weight tracking
- Add sleep tracking correlation
- Create custom Grafana dashboards

---

## Resources

**Official Stronglifts:**
- Website: https://stronglifts.com/5x5/
- App: Stronglifts 5x5 (iOS/Android)

**Form Tutorials:**
- Squat: https://stronglifts.com/squat/
- Bench Press: https://stronglifts.com/bench-press/
- Deadlift: https://stronglifts.com/deadlift/
- Barbell Row: https://stronglifts.com/barbell-row/
- Overhead Press: https://stronglifts.com/overhead-press/

**Setup Guides:**
- Complete setup: `/mnt/storage/automation/n8n/HEALTH-FITNESS-TRACKING-SETUP.md`
- 12-week plan: `/mnt/storage/automation/n8n/STRONGLIFTS-5X5-WORKOUT-PLAN.md`

---

## Advanced Integrations

### Withings Scale Integration

**Official Home Assistant integration** for automatic weight tracking from your Withings smart scale.

**Features:**
- Automatic weight sync
- Body composition metrics (BMI, fat %, muscle mass)
- Historical tracking & graphs
- No manual logging needed

**Setup:** See `/mnt/storage/automation/n8n/WITHINGS-GOOGLE-FIT-SETUP.md`

**Prerequisites:**
- Withings developer account
- HTTPS access (Cloudflare Tunnel)
- Valid SSL certificate

### Health Connect / Google Fit Integration

**Android Health Connect integration** via Home Assistant Companion App for blood pressure, heart rate, and vitals.

**Features:**
- Blood pressure tracking (automatic from cuff)
- Heart rate & resting heart rate
- Sleep duration & quality
- Steps, distance, calories
- Oxygen saturation

**Setup:** See `/mnt/storage/automation/n8n/WITHINGS-GOOGLE-FIT-SETUP.md`

**Prerequisites:**
- Pixel 10 Pro with HA Companion App ✅ (you have this!)
- Health Connect app installed
- Blood pressure cuff that syncs to Google Fit/Health Connect

---

## Health Dashboard

**Comprehensive visual dashboard** with graphs and charts for all health metrics.

**Access:** http://192.168.40.201:8123/health-fitness

**Features:**
- 📊 Real-time protein tracking with progress bars
- 📈 30-day weight trend graph
- 💪 90-day workout progression (all 5 exercises)
- ❤️ Blood pressure trend with alerts
- 🏃 Daily steps & sleep charts
- 🎯 Goal tracking with visual indicators

**Configuration:**
- Dashboard YAML: `/home/hazzard/home-assistant/config/dashboards/health_fitness_dashboard.yaml`
- Requires: ApexCharts Card + Mushroom Cards (install via HACS)

**Installation:**
1. Install ApexCharts and Mushroom cards via HACS
2. Add dashboard view in Home Assistant
3. Paste YAML configuration
4. Customize goals and thresholds

**Screenshot Preview:**

The dashboard includes:
- **Row 1:** Quick status cards (protein today, goal progress, next workout)
- **Row 2:** Protein progress gauge + weight card
- **Row 3:** Detailed protein tracking table
- **Row 4:** Current workout weights (all 5 exercises)
- **Row 5:** Blood pressure & vitals
- **Row 6:** 30-day weight trend graph
- **Row 7:** 14-day protein intake bar chart
- **Row 8:** 90-day workout progression (all exercises on one chart)
- **Row 9:** 30-day blood pressure trend with threshold lines
- **Row 10:** Daily steps & sleep charts
- **Row 11:** Automation controls
- **Row 12:** Manual input options

---

## Complete Documentation

**All Guides:**

| Guide | Location | Purpose |
|-------|----------|---------|
| **Main Setup** | `/mnt/storage/automation/n8n/HEALTH-FITNESS-TRACKING-SETUP.md` | Voice tracking setup, n8n workflows, automations |
| **12-Week Workout Plan** | `/mnt/storage/automation/n8n/STRONGLIFTS-5X5-WORKOUT-PLAN.md` | Detailed Stronglifts 5X5 progression |
| **Quick Reference** | `/mnt/storage/automation/n8n/HEALTH-TRACKING-QUICK-REFERENCE.md` | Printable cheat sheet |
| **Withings/Health Connect** | `/mnt/storage/automation/n8n/WITHINGS-GOOGLE-FIT-SETUP.md` | Scale & blood pressure integration |

**Web Docs:** http://192.168.40.201:8888/health-fitness-tracking/

---

## Support

**Logs to check:**
```bash
# Home Assistant
docker logs -f homeassistant

# n8n
docker logs -f n8n

# Ollama
docker logs -f ollama

# InfluxDB
docker logs -f influxdb
```

**n8n Execution History:**
- http://192.168.40.201:5678 → Executions
- Shows all webhook calls and their status

**Home Assistant Developer Tools:**
- http://192.168.40.201:8123/developer-tools/state
- View all entity states in real-time

**Common Issues:**

| Issue | Solution |
|-------|----------|
| Withings not syncing | Wait 10 min, force sync in Withings app |
| Blood pressure data missing | Enable sensors in HA Companion App |
| Dashboard graphs blank | Install ApexCharts via HACS, wait 24hrs for data |
| Voice commands not working | Check HA logs, verify custom sentences loaded |

Good luck with your fitness journey! 💪
