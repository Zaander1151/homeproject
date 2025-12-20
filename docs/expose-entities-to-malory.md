# Expose Entities to Malory (Ollama Conversation Agent)

**Issue:** Malory says "Sorry, No Weather is exposed" when asked about weather.

**Root Cause:** The Ollama conversation integration needs entities explicitly exposed to it.

---

## Solution 1: Expose Entities via Ollama Integration Settings

### Step 1: Access Ollama Integration

1. Go to **Settings** → **Devices & Services**
2. Find **"Ollama Conversation"** integration (or just "Ollama")
3. Click **CONFIGURE**

### Step 2: Enable Entity Exposure

Look for an option like:
- "Expose Home Assistant entities"
- "Allow entity access"
- "Conversation entities"

If you see a list of entities, enable these:

**Weather Entities:**
- `sensor.hamilton_weather_temperature`
- `sensor.hamilton_weather_high_temperature`
- `sensor.hamilton_weather_low_temperature`
- `sensor.hamilton_weather_humidity`
- `sensor.hamilton_weather_humidex`

**Home Status:**
- `climate.my_ecobee`
- `sensor.my_ecobee_current_temperature`
- `sensor.my_ecobee_current_humidity`

**Vehicle:**
- `lock.fordpass_doorlock`
- `sensor.temperature_outdoors` (Bronco outside temp)
- `switch.rc_start` (Remote start)

**Phone:**
- `binary_sensor.phone_at_home`
- `sensor.pixel_10_pro_battery_level`

---

## Solution 2: Configure via Prompt Template (Easier)

If the Ollama integration doesn't have entity exposure settings, we can give Malory the data via the prompt template.

### Step 1: Edit Ollama Conversation Settings

1. **Settings** → **Devices & Services** → **Ollama**
2. Click **CONFIGURE**
3. Find **"Prompt Template"** field

### Step 2: Use This Enhanced Prompt Template

```
You are Malory, a helpful and friendly home automation voice assistant.

Current date and time: {{ now().strftime('%A, %B %d, %Y at %I:%M %p') }}

CURRENT HOME STATUS:
- Outside Temperature: {{ states('sensor.hamilton_weather_temperature') }}°C
- Today's High: {{ states('sensor.hamilton_weather_high_temperature') }}°C
- Today's Low: {{ states('sensor.hamilton_weather_low_temperature') }}°C
- Outside Humidity: {{ states('sensor.hamilton_weather_humidity') }}%
- Indoor Temperature: {{ states('sensor.my_ecobee_current_temperature') }}°F
- Indoor Humidity: {{ states('sensor.my_ecobee_current_humidity') }}%
- Thermostat Mode: {{ states('climate.my_ecobee') }}
- Bronco Door Locks: {{ states('lock.fordpass_doorlock') }}
- Bronco Outside Temp: {{ states('sensor.temperature_outdoors') }}°F
- Phone at Home: {{ states('binary_sensor.phone_at_home') }}

INSTRUCTIONS:
- Keep responses SHORT and CONVERSATIONAL for voice output (1-3 sentences max)
- Be friendly, helpful, and natural
- If asked about weather, use the data above
- If asked about temperature, specify if it's inside or outside
- If you don't know something not listed above, say so honestly
- Always speak in Fahrenheit for indoor temps, Celsius for outdoor (Canadian weather)

User: {{ prompt }}
Malory:
```

### Step 3: Save and Test

Click **SUBMIT** or **SAVE**

Now try: "OK Nabu, what's the weather like?"

Expected response: "It's currently X degrees Celsius outside, with a high of Y expected today."

---

## Solution 3: Check Entity IDs

The entity IDs might be slightly different. Let's verify:

### Get Actual Entity IDs

1. Go to **Developer Tools** → **States**
2. Search for "hamilton weather"
3. Note the exact entity IDs
4. Update the prompt template with the correct IDs

Common variations:
- `sensor.hamilton_weather_temperature` ✓
- `weather.hamilton_weather_hourly`
- `weather.hamilton_weather_daily`

---

## Test Commands After Configuration

Try these to verify it's working:

1. **"OK Nabu, what's the weather?"**
   - Should tell you current temperature and forecast

2. **"OK Nabu, what's the temperature outside?"**
   - Should give current outdoor temp

3. **"OK Nabu, what's the temperature inside?"**
   - Should give Ecobee current temp

4. **"OK Nabu, should I wear a jacket?"**
   - Should use outdoor temp to make a recommendation

5. **"OK Nabu, is it warmer inside or outside?"**
   - Should compare both temperatures

---

## Troubleshooting

### Still says "No Weather is exposed"

**Option A:** The entity doesn't exist
- Go to **Developer Tools** → **States**
- Search for "hamilton_weather_temperature"
- If not found, the weather integration might not be working

**Option B:** The prompt template isn't being used
- Verify you saved the configuration
- Restart the Ollama container:
  ```bash
  docker restart ollama
  ```
- Wait 30 seconds, then test again

**Option C:** Wrong entity ID format
- Try using `state_attr()` instead:
  ```
  {{ state_attr('weather.hamilton_weather', 'temperature') }}
  ```

### Weather integration errors

If you saw errors connecting to Environment Canada:
```
Error requesting environment_canada weather data
```

This might be temporary. Check:
1. **Settings** → **Devices & Services** → **Environment Canada**
2. Click **RELOAD**
3. If still failing, the government weather service might be down

Alternative: Use a different weather integration like **OpenWeatherMap** or **Met.no**

---

## Quick Verification

After configuring, test in **Developer Tools** → **Template**:

```jinja2
{{ states('sensor.hamilton_weather_temperature') }}°C
High: {{ states('sensor.hamilton_weather_high_temperature') }}°C
Low: {{ states('sensor.hamilton_weather_low_temperature') }}°C
```

This should show actual values. If it shows "unknown" or "unavailable", the weather integration needs fixing first.

---

## Recommended: Full Context Prompt Template

For best results, use this comprehensive template:

```jinja2
You are Malory, a helpful home automation voice assistant.

Time: {{ now().strftime('%I:%M %p on %A, %B %d, %Y') }}

WEATHER:
- Current: {{ states('sensor.hamilton_weather_temperature') }}°C
- High today: {{ states('sensor.hamilton_weather_high_temperature') }}°C
- Low today: {{ states('sensor.hamilton_weather_low_temperature') }}°C
- Humidity: {{ states('sensor.hamilton_weather_humidity') }}%

HOME:
- Indoor temp: {{ states('sensor.my_ecobee_current_temperature') }}°F
- Indoor humidity: {{ states('sensor.my_ecobee_current_humidity') }}%
- Bedroom fan: {{ states('switch.bedroom_fan') }}

VEHICLE (Bronco):
- Doors: {{ states('lock.fordpass_doorlock') }}
- Outside temp (vehicle): {{ states('sensor.temperature_outdoors') }}°F

PRESENCE:
- Phone at home: {{ states('binary_sensor.phone_at_home') }}

Keep responses SHORT (1-3 sentences) and conversational for voice. Be friendly and natural.

User: {{ prompt }}
Malory:
```

This gives Malory full context to answer most common questions!
