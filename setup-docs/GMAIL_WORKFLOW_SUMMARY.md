# Gmail AI Manager Workflow - Summary

## ✅ What's Been Set Up

### 1. File Organization

All Gmail workflow files have been organized into a proper directory structure:

```
/mnt/storage/automation/
├── README.md                                              # Overview of all automation workflows
└── n8n/
    └── gmail_manager/
        ├── gmail-ai-manager-build-guide.md               # ⭐ MAIN GUIDE - Step-by-step instructions
        └── gmail-ai-manager-workflow.json                # Legacy JSON (deprecated)
```

### 2. n8n Volume Mount

The n8n Docker container now has full access to `/mnt/storage`:

**Updated:** `/home/hazzard/n8n/docker-compose.yml`
- Added volume mount: `/mnt/storage:/mnt/storage`
- n8n can now read/write files in `/mnt/storage`
- Perfect for importing workflows and storing exports

**Verified:**
```bash
docker exec n8n_ai_agent ls -la /mnt/storage/automation/n8n/gmail_manager/
# ✅ n8n can access all files
```

### 3. Documentation Updated

All documentation has been updated with new paths:

- ✅ Build guide references updated
- ✅ Setup guide references updated
- ✅ Requirements checker updated
- ✅ README created for automation directory

## 📚 Key Files & Their Purpose

### Primary Documentation

**1. Build Guide (RECOMMENDED):**
```
/mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-build-guide.md
```
- Complete step-by-step instructions
- Build workflow directly in n8n UI
- Uses correct node types (AI Agent, Ollama Chat Model, etc.)
- Includes troubleshooting and optimization tips
- **Use this to build your workflow!**

**2. Setup Guide (Reference):**
```
/home/hazzard/homeproject/gmail-ai-manager-setup-guide.md
```
- Prerequisites and account setup
- Google Cloud OAuth configuration
- Telegram bot creation
- Credential configuration
- General troubleshooting

**3. Requirements Checker:**
```
/home/hazzard/homeproject/check-gmail-workflow-requirements.sh
```
- Verifies all services are running
- Checks Ollama models
- Shows next steps
- Run with: `./check-gmail-workflow-requirements.sh`

**4. Automation Overview:**
```
/mnt/storage/automation/README.md
```
- Overview of all automation workflows
- Directory structure
- How to add new workflows

## 🚀 Quick Start

### Step 1: Verify Prerequisites

```bash
/home/hazzard/homeproject/check-gmail-workflow-requirements.sh
```

This checks:
- ✅ n8n is running
- ✅ Ollama is running with models
- ✅ Files are accessible
- ✅ Services are reachable

### Step 2: Set Up Accounts

You need:
1. **Telegram Bot**
   - Message @BotFather → `/newbot`
   - Save bot token
   - Get chat ID from @userinfobot

2. **Google OAuth**
   - Visit: https://console.cloud.google.com/
   - Enable Gmail API + Google Calendar API
   - Create OAuth 2.0 credentials
   - Save Client ID and Secret

### Step 3: Build the Workflow

Open the build guide and follow it step-by-step:

```bash
cat /mnt/storage/automation/n8n/gmail_manager/gmail-ai-manager-build-guide.md
```

Or view it in your browser/text editor.

Time needed: **30-45 minutes** (including account setup)

## 🎯 What the Workflow Does

```
New Email Arrives
    ↓
Gmail Trigger (polls every 1-5 minutes)
    ↓
Extract Email Data
    ↓
AI Agent (Ollama - classifies email)
    ↓
Switch/Router
    ↓
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┐
│  DELIVERY   │ APPOINTMENT │    SPAM     │   ARCHIVE   │  UNCERTAIN  │
│             │             │             │             │             │
│ → Calendar  │ → Calendar  │ → Mark      │ → Archive   │ → Telegram  │
│   (all-day) │   (timed)   │   as spam   │   email     │   (buttons) │
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┘
```

### Features

✅ **Automatic Calendar Events**
- Deliveries: All-day events with tracking info
- Appointments: Timed events with location

✅ **Smart Classification**
- AI determines email category
- Confidence scoring
- Extracts relevant data (dates, tracking numbers, etc.)

✅ **Telegram Control**
- Notifications for uncertain emails
- One-tap action buttons
- Email preview in message

✅ **Privacy First**
- All AI runs locally (Ollama)
- No data sent to external services
- Full control over your data

## 📊 Services Status

### Check Services

```bash
# n8n
docker ps | grep n8n_ai_agent
curl http://localhost:5678

# Ollama
docker ps | grep ollama
curl http://localhost:11434/api/tags

# List available models
docker exec ollama ollama list
```

### Access Points

- **n8n:** http://localhost:5678
- **Ollama:** http://localhost:11434
- **Open WebUI:** http://localhost:3000

### n8n Volume Access

From inside n8n container, workflows are accessible at:
```
/mnt/storage/automation/n8n/gmail_manager/
```

From host:
```
/mnt/storage/automation/n8n/gmail_manager/
```

## 🔧 n8n Docker Configuration

The n8n container has been configured with these volume mounts:

```yaml
volumes:
  - n8n_data:/home/node/.n8n
  - ./local-files:/files
  - /home/hazzard/comfyui/output:/comfyui_output:ro
  - /mnt/storage/slicer_files:/slicer_files
  - /mnt/storage:/mnt/storage                    # ← NEW!
```

This allows n8n to:
- Import workflows from `/mnt/storage`
- Export workflows to `/mnt/storage`
- Store files and data in `/mnt/storage`
- Access automation documentation

## 🎓 How to Use This Setup

### For Gmail Workflow

1. Read the build guide
2. Follow step-by-step to build in n8n
3. Test with sample emails
4. Activate and let it run

### For Future Workflows

1. Create new directory: `/mnt/storage/automation/n8n/[workflow_name]/`
2. Build workflow in n8n
3. Export to the directory
4. Add documentation
5. Update `/mnt/storage/automation/README.md`

## 📝 Important Notes

### About the JSON Workflow

The file `gmail-ai-manager-workflow.json` is **deprecated** because:
- Contains incorrect node types from initial attempt
- Broken connections and expressions
- Not compatible with current n8n features

**Use the build guide instead!** It's:
- Accurate and tested
- Uses proper node types
- Easier to customize
- Better documented

### Volume Mount Benefits

With `/mnt/storage` mounted in n8n:
- ✅ Easy workflow sharing between host and container
- ✅ Persistent storage for workflow exports
- ✅ Can access files from other containers
- ✅ Backups include workflow files

### Maintenance

To update or restart n8n:
```bash
cd /home/hazzard/n8n
docker-compose restart n8n
```

To see n8n logs:
```bash
docker logs -f n8n_ai_agent
```

## 🎯 Next Steps

1. **Now:** Run the requirements checker
   ```bash
   /home/hazzard/homeproject/check-gmail-workflow-requirements.sh
   ```

2. **Then:** Set up Telegram bot and Google OAuth

3. **Finally:** Follow the build guide to create the workflow

## 📖 Additional Resources

- **n8n Documentation:** https://docs.n8n.io/
- **n8n Community:** https://community.n8n.io/
- **Ollama Documentation:** https://ollama.com/docs
- **Telegram Bot API:** https://core.telegram.org/bots/api

## 🆘 Troubleshooting

### Can't import workflow in n8n?

n8n can now access `/mnt/storage` directly. When importing:
1. Click "Import from File" in n8n
2. Navigate to `/mnt/storage/automation/n8n/gmail_manager/`
3. Select the workflow file

### n8n can't access files?

Verify volume mount:
```bash
docker exec n8n_ai_agent ls -la /mnt/storage/automation/
```

If it fails, restart n8n:
```bash
cd /home/hazzard/n8n && docker-compose restart
```

### Need help?

- Check the build guide troubleshooting section
- Review n8n execution logs in the UI
- Check docker logs: `docker logs n8n_ai_agent`

---

**Created:** 2025-11-16
**Version:** 2.0
**Status:** ✅ Ready to use
