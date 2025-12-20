# Morning Briefing n8n Workflow Setup Guide

## Overview
This workflow collects morning briefing data and delivers it via Telegram and Google Nest Audio TTS.

## Prerequisites

1. **Home Assistant Long-Lived Access Token**
   - Go to Home Assistant: http://192.168.40.201:8123/profile
   - Scroll to "Long-Lived Access Tokens"
   - Click "Create Token"
   - Name: "n8n Morning Briefing"
   - Copy the token and save it

2. **Telegram Bot Credentials**
   - Already configured in n8n
   - Bot token: Connected to your bot
   - Chat ID: 6299872789

3. **Ollama Model**
   - Ensure `llama3.1:8b` or `qwen2.5:7b` is installed on Ollama
   - Check: `docker exec ollama ollama list`

## Workflow Components

### 1. Webhook Trigger
- **Path:** `/webhook/morning-briefing`
- **Method:** POST
- **URL:** `http://n8n:5678/webhook/morning-briefing`

### 2. Data Collection Nodes

#### Get Weather Data
```
URL: http://homeassistant:8123/api/states/weather.hamilton_weather_forecast
Method: GET
Authentication: Header Auth
  Header Name: Authorization
  Header Value: Bearer YOUR_TOKEN_HERE
```

#### Get Calendar Events
```
URL: http://homeassistant:8123/api/calendars/calendar.hazzard25_gmail_com?start={{ $today }}&end={{ $tomorrow }}
Method: GET
Authentication: Header Auth
  Header Name: Authorization
  Header Value: Bearer YOUR_TOKEN_HERE
```

#### Get Bronco Fuel
```
URL: http://homeassistant:8123/api/states/sensor.fordpass_fuel
Method: GET
Authentication: Header Auth
```

#### Get Bronco Lock Status
```
URL: http://homeassistant:8123/api/states/lock.fordpass_doorlock
Method: GET
Authentication: Header Auth
```

#### Get Bedroom Fan
```
URL: http://homeassistant:8123/api/states/switch.bedroom_fan
Method: GET
Authentication: Header Auth
```

#### Get Phone Battery
```
URL: http://homeassistant:8123/api/states/sensor.pixel_10_pro_battery_level
Method: GET
Authentication: Header Auth
```

### 3. News Collection (Manual Setup Required)

Since n8n doesn't have direct Gemini API integration, you'll need to:

**Option A: Use RSS Feeds (Simpler)**
- Add RSS Read nodes for:
  - Sports: ESPN, TSN, The Athletic
  - Tech: TechCrunch, Ars Technica, The Verge

**Option B: Use HTTP Request to Gemini API**
```
URL: https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=YOUR_API_KEY
Method: POST
Body: {
  "contents": [{
    "parts": [{
      "text": "Provide the top 2 sports news headlines today for NFL, CFL, CPL, and NHL. Be brief."
    }]
  }]
}
```

### 4. Data Processing

**Code Node - Parse and Structure Data:**
```javascript
// Extract weather
const weather = $input.item.json[0].attributes;
const weatherData = {
  temp: Math.round(weather.temperature),
  condition: weather.condition,
  high: Math.round(weather.forecast[0].temperature),
  low: Math.round(weather.forecast[0].templow),
  precip: weather.forecast[0].precipitation_probability || 0
};

// Extract calendar
const calendar = $input.item.json[1];
const calendarEvents = calendar.length > 0
  ? calendar.map(e => `${e.start.dateTime} - ${e.summary}`).join(', ')
  : 'No meetings today';

// Extract smart home
const broncoFuel = $input.item.json[2].state;
const broncoLocked = $input.item.json[3].state === 'locked';
const bedroomFan = $input.item.json[4].state;
const phoneBattery = $input.item.json[5].state;

// Extract news (adapt based on your news source)
const sportsNews = "NFL: Bills defeat Chiefs 30-21, NHL: Leafs win 4-3";
const techNews = "Apple announces new MacBook Pro";

return {
  json: {
    weather: weatherData,
    calendar: calendarEvents,
    sports_news: sportsNews,
    tech_news: techNews,
    bronco_fuel: broncoFuel,
    bronco_locked: broncoLocked,
    bedroom_fan: bedroomFan,
    phone_battery: phoneBattery
  }
};
```

### 5. AI Generation (Ollama Node)

**Ollama Chat Model Node:**
- **Model:** `llama3.1:8b`
- **Prompt:**
```
You are creating a concise morning briefing. Keep it conversational and brief (maximum 30 seconds when spoken - about 75 words).

Weather: {{ $json.weather.temp }}°C now, high {{ $json.weather.high }}°C, {{ $json.weather.condition }}. {{ $json.weather.precip }}% chance of precipitation.

Calendar: {{ $json.calendar }}

Sports News: {{ $json.sports_news }}

Tech News: {{ $json.tech_news }}

Smart Home: Bronco at {{ $json.bronco_fuel }}% fuel, {{ $json.bronco_locked ? 'locked' : 'unlocked' }}. Phone at {{ $json.phone_battery }}% battery.

Create a natural, friendly morning briefing. Format for voice - be conversational, use contractions, no lists or bullets. Just a natural paragraph.
```

### 6. Format for Telegram

**Set Node - Create Telegram Message:**
```
telegram_message:
🌅 **Good Morning!**

🌡️ **Weather:** {{ $json.weather.temp }}°C now, high of {{ $json.weather.high }}°C. {{ $json.weather.condition }} with {{ $json.weather.precip }}% chance of precipitation.

📅 **Calendar:** {{ $json.calendar }}

🏈 **Sports:**
{{ $json.sports_news }}

💻 **Tech:**
{{ $json.tech_news }}

🏠 **Smart Home:** Bronco at {{ $json.bronco_fuel }}% fuel, {{ $json.bronco_locked ? 'locked' : 'unlocked' }}. Phone at {{ $json.phone_battery }}% battery.

Have a great day! ☕
```

### 7. Send Telegram

**Telegram Node:**
- **Chat ID:** 6299872789
- **Text:** `{{ $json.telegram_message }}`
- **Parse Mode:** Markdown

### 8. Trigger Voice Announcement

**HTTP Request Node:**
```
URL: http://homeassistant:8123/api/services/script/announce_morning_briefing
Method: POST
Authentication: Header Auth
  Header Name: Authorization
  Header Value: Bearer YOUR_TOKEN_HERE
Content-Type: application/json
Body:
{
  "message": "{{ $('Ollama Chat Model').item.json.response }}"
}
```

### 9. Respond to Webhook

**Respond to Webhook Node:**
- **Respond With:** All Incoming Items

## Testing the Workflow

1. **Import the workflow** (or build manually following this guide)
2. **Activate the workflow**
3. **Test the webhook:**
```bash
curl -X POST http://192.168.40.201:5678/webhook/morning-briefing \
  -H "Content-Type: application/json" \
  -d '{"timestamp": "2025-12-05T09:00:00", "triggered_by": "manual_test"}'
```

4. **Check:**
   - Telegram message received
   - Google Nest Audio announcement played
   - n8n execution log shows success

## Troubleshooting

- **No Telegram message:** Check bot token and chat ID
- **No voice announcement:** Check HA token and script exists
- **Missing data:** Verify entity IDs in Home Assistant
- **Ollama timeout:** Check Ollama is running and model is downloaded

## Next Steps

Once tested, the automation will trigger automatically when you unplug your Pixel 10 Pro between 5-9 AM!
