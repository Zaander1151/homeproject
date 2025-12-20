# Gmail AI Manager - Setup Guide

This workflow uses AI (Ollama) to automatically manage your Gmail inbox, add calendar events for deliveries and appointments, and send Telegram notifications when uncertain.

## Features

✅ **Automatic Email Classification:**
- Delivery tracking (AliExpress, Amazon, etc.)
- Doctor appointments & calendar events
- Spam detection
- Low-priority auto-archive
- Important emails requiring attention

✅ **Smart Actions:**
- 📦 Deliveries → Auto-add to Google Calendar
- 📅 Appointments → Auto-add to Google Calendar with reminders
- 🗑️ Spam → Mark as spam
- 📥 Low priority → Auto-archive
- 🤔 Uncertain → Send to Telegram with quick-reply buttons

✅ **Telegram Integration:**
- Real-time notifications for uncertain emails
- One-touch action buttons
- Email preview in notification

## Prerequisites

Before setting up this workflow, you need:

1. **n8n** (already running at http://localhost:5678)
2. **Ollama** (already running with AI models)
3. **Gmail account** with API access
4. **Google Calendar** access
5. **Telegram Bot** token and chat ID

## Step 1: Set Up Telegram Bot

### Create a Telegram Bot

1. Open Telegram and search for [@BotFather](https://t.me/botfather)
2. Send `/newbot` command
3. Follow prompts to name your bot (e.g., "Gmail AI Manager")
4. **Save the Bot Token** you receive (looks like: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### Get Your Chat ID

1. Search for [@userinfobot](https://t.me/userinfobot) on Telegram
2. Start a chat with it
3. **Save your Chat ID** (looks like: `123456789`)

OR use this command:
```bash
# Replace YOUR_BOT_TOKEN with your actual bot token
curl https://api.telegram.org/botYOUR_BOT_TOKEN/getUpdates
```

## Step 2: Set Up Gmail API Access

### Enable Gmail API in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use existing)
3. Enable **Gmail API**:
   - Navigate to "APIs & Services" > "Library"
   - Search for "Gmail API"
   - Click "Enable"
4. Enable **Google Calendar API** (same process)
5. Create OAuth 2.0 credentials:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "OAuth client ID"
   - Application type: "Web application"
   - Add authorized redirect URI: `http://localhost:5678/rest/oauth2-credential/callback`
   - **Save Client ID and Client Secret**

## Step 3: Set Up Ollama Model

Make sure you have a good model installed for email classification:

```bash
# Pull the recommended model (if not already installed)
docker exec ollama ollama pull llama3.2:latest

# Or use a larger model for better accuracy:
docker exec ollama ollama pull llama3.1:8b
```

## Step 4: Import Workflow into n8n

1. Open n8n: http://localhost:5678
2. Click **"Import from File"** (top right menu)
3. Select: `/mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-workflow.json`
4. The workflow will be imported

**Note:** The workflow JSON is deprecated. It's recommended to use the build guide instead:
- `/mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-build-guide.md`

## Step 5: Configure Credentials in n8n

### 5.1 Gmail OAuth2 Credentials

1. In n8n, go to **Settings** > **Credentials** > **Add Credential**
2. Select **"Gmail OAuth2 API"**
3. Enter:
   - **Client ID**: From Google Cloud Console
   - **Client Secret**: From Google Cloud Console
4. Click **"Connect my account"**
5. Authorize access to your Gmail account
6. Save credential as **"Gmail account"**

### 5.2 Google Calendar OAuth2 Credentials

1. Add new credential: **"Google Calendar OAuth2 API"**
2. Enter same Client ID and Secret from Gmail setup
3. Click **"Connect my account"**
4. Authorize calendar access
5. Save as **"Google Calendar account"**

### 5.3 Telegram Bot Credentials

1. Add new credential: **"Telegram API"**
2. Enter your **Bot Token** from @BotFather
3. Save as **"Telegram account"**

### 5.4 Ollama API Credentials

1. Add new credential: **"Ollama API"**
2. Enter base URL: `http://ollama:11434`
   - If n8n can't reach it, use: `http://host.docker.internal:11434`
   - Or the host IP: `http://192.168.40.X:11434`
3. Save as **"Ollama API"**

## Step 6: Update Workflow Configuration

Open the imported workflow and update these settings:

### 6.1 Update Telegram Chat ID

1. Open the **"Send Telegram Notification"** node
2. Replace `YOUR_TELEGRAM_CHAT_ID` with your actual Chat ID (from Step 1)
3. Save the node

### 6.2 Verify AI Model

1. Open the **"AI Email Classifier"** node
2. Verify model is set to: `llama3.2:latest` (or your preferred model)
3. Adjust temperature if needed (0.3 = more consistent, 0.7 = more creative)

### 6.3 Configure Gmail Trigger Polling

1. Open the **"Gmail Trigger"** node
2. Set polling interval (default: every minute)
   - For testing: every minute
   - For production: every 5-10 minutes to avoid API limits
3. Optional: Add filter for specific labels or senders

## Step 7: Test the Workflow

### Test with Manual Execution

1. Click **"Execute Workflow"** button in n8n
2. Send yourself a test email to your Gmail
3. Wait for the polling interval
4. Check the execution log in n8n
5. Verify:
   - Email was classified correctly
   - Appropriate action was taken
   - Calendar events created (if applicable)
   - Telegram notification received (if uncertain)

### Test Telegram Quick Replies

1. Wait for an "uncertain" email notification in Telegram
2. Click one of the action buttons
3. Verify the action is executed in Gmail
4. Check for confirmation message in Telegram

## Step 8: Activate Workflow

Once testing is successful:

1. Click the **"Active"** toggle at the top of the workflow
2. The workflow will now run automatically on new emails

## Workflow Logic Overview

```
New Email Arrives
    ↓
AI Classifier (Ollama)
    ↓
Category Router
    ↓
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│  DELIVERY   │ APPOINTMENT │    SPAM     │   ARCHIVE   │  IMPORTANT  │
│             │             │             │             │             │
│ Add to      │ Add to      │ Mark as     │ Archive &   │ Send to     │
│ Calendar    │ Calendar    │ Spam        │ Mark Read   │ Telegram    │
│ (All-day)   │ (Timed)     │             │             │ (w/buttons) │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

## Advanced Configuration

### Customize AI Classification

Edit the **AI Email Classifier** prompt to:
- Add more categories
- Change classification criteria
- Extract additional data fields
- Support more email types

### Add More Actions

You can extend the workflow to:
- Send email replies automatically
- Forward important emails
- Create tasks in project management tools
- Send notifications to other platforms (Slack, Discord)
- Update spreadsheets with tracking info

### Filter Emails by Sender

In the **Gmail Trigger** node, add filters:
```
From: aliexpress.com
Subject: Tracking
Label: Important
```

### Adjust AI Confidence Threshold

Add a filter node after AI classification:
```javascript
// Only send to Telegram if confidence < 70%
{{ $json.confidence < 0.7 }}
```

## Troubleshooting

### Ollama Connection Issues

If AI classification fails:
1. Verify Ollama is running: `docker ps | grep ollama`
2. Test Ollama endpoint: `curl http://localhost:11434/api/tags`
3. Update Ollama URL in credentials:
   - Try: `http://ollama:11434`
   - Or: `http://host.docker.internal:11434`
   - Or: `http://192.168.40.X:11434` (your host IP)

### Gmail API Rate Limits

Gmail API has quotas:
- **250 quota units per user per second**
- **1 billion quota units per day**

If you hit limits:
- Reduce polling frequency
- Add filters to reduce emails processed
- Use batch processing

### Telegram Not Receiving Messages

1. Verify bot token is correct
2. Make sure you've **started a chat** with your bot first
3. Check chat ID is correct (must match your Telegram account)
4. Test with Telegram API:
```bash
curl -X POST "https://api.telegram.org/botYOUR_BOT_TOKEN/sendMessage" \
  -d "chat_id=YOUR_CHAT_ID" \
  -d "text=Test message"
```

### Calendar Events Not Creating

1. Verify Google Calendar API is enabled
2. Check calendar permissions in OAuth consent
3. Ensure date/time extraction is working correctly
4. Check for timezone issues (dates must be ISO format)

## Security Best Practices

1. **Never share your credentials** (bot tokens, OAuth secrets)
2. **Use environment variables** for sensitive data in n8n
3. **Enable 2FA** on your Gmail account
4. **Regularly review** bot permissions in Google Account settings
5. **Monitor workflow executions** for suspicious activity
6. **Set up error notifications** to catch issues early

## Optimization Tips

1. **Reduce API Calls:**
   - Increase polling interval during low-traffic hours
   - Use Gmail filters to pre-filter emails
   - Batch process multiple emails

2. **Improve AI Accuracy:**
   - Use larger Ollama models (llama3.1:8b or llama3.1:70b)
   - Fine-tune prompts based on your email patterns
   - Add example emails to the prompt

3. **Minimize False Positives:**
   - Adjust confidence threshold
   - Add sender whitelist/blacklist
   - Use multiple AI passes for uncertain emails

## Monitoring & Maintenance

### Check Workflow Health

1. Review execution logs daily
2. Monitor error rate
3. Check calendar for correct entries
4. Review spam classifications weekly

### Update AI Model

```bash
# Pull latest model updates
docker exec ollama ollama pull llama3.2:latest

# Or switch to a better model
docker exec ollama ollama pull llama3.1:8b
```

### Backup Workflow

Regularly export your workflow:
1. Open workflow in n8n
2. Click menu > "Export Workflow"
3. Save JSON file to safe location

## Support & Documentation

- **n8n Docs:** https://docs.n8n.io/
- **Ollama Docs:** https://ollama.com/docs
- **Gmail API Docs:** https://developers.google.com/gmail/api
- **Telegram Bot API:** https://core.telegram.org/bots/api

## Quick Reference

### Important Files
- Build Guide: `/mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-build-guide.md`
- Workflow JSON (legacy): `/mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-workflow.json`
- This guide: `/home/hazzard/homeproject/gmail-ai-manager-setup-guide.md`
- Automation README: `/mnt/storage/automation/README.md`

### Service URLs
- n8n: http://localhost:5678
- Ollama: http://localhost:11434
- Open WebUI: http://localhost:3000

### Useful Commands
```bash
# View n8n logs
docker logs -f n8n_ai_agent

# View Ollama logs
docker logs -f ollama

# Test Ollama
curl http://localhost:11434/api/tags

# Restart n8n
cd /home/hazzard/n8n && docker-compose restart

# Restart Ollama
cd /home/hazzard/ollama && docker-compose restart
```

---

**Workflow Created:** 2025-11-16
**Version:** 1.0
**Status:** Ready for import and configuration
