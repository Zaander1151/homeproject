# Storage Monitoring - Quick Start Guide

## What's Been Set Up

Your storage monitoring system is ready to go! Here's what's configured:

### On Main Host (Monitoring Server)
- ✅ **Prometheus** - Updated with alert rules and ready to monitor remote systems
- ✅ **Grafana** - Ready to import dashboards
- ✅ **Alert Rules** - 12 storage alert rules configured for disk space, I/O, and inode monitoring
- ✅ **Configuration Files** - All templates ready for adding remote systems

### Alert Rules Active
1. **DiskSpaceWarning** - Triggers when disk usage > 80%
2. **DiskSpaceCritical** - Triggers when disk usage > 90%
3. **DiskWillFillSoon** - Predicts disk will fill in 4 hours
4. **DiskWillFillIn24Hours** - Predicts disk will fill in 24 hours
5. **InodeUsageHigh** - Triggers when inode usage > 80%
6. **InodeUsageCritical** - Triggers when inode usage > 90%
7. **FilesystemReadOnly** - Detects read-only filesystems
8. **HighDiskIOUtilization** - Monitors disk I/O saturation
9. **WindowsDiskSpaceWarning** - Windows disk > 80%
10. **WindowsDiskSpaceCritical** - Windows disk > 90%
11. **WindowsDiskWillFillSoon** - Predicts Windows disk will fill in 4 hours
12. **UnusualDiskActivity** - Detects 10x normal read/write activity

---

## Next Steps: Set Up Remote Monitoring

### For Linux Computers

**1. Copy the installation script to each Linux computer:**
```bash
# From your main host
scp /home/hazzard/homeproject/docs/install-node-exporter-linux.sh user@remote-host:/tmp/
```

**2. SSH into the remote Linux computer and run:**
```bash
ssh user@remote-host
sudo bash /tmp/install-node-exporter-linux.sh
```

**3. Test from monitoring server:**
```bash
curl http://<remote-host-ip>:9100/metrics | grep node_filesystem
```

**4. Add to Prometheus configuration:**
Edit `/home/hazzard/home-assistant/prometheus/prometheus.yml` and add the IP to `linux_servers`:
```yaml
- job_name: 'linux_servers'
  static_configs:
    - targets:
        - '192.168.40.50:9100'  # Replace with actual IP
```

**5. Restart Prometheus:**
```bash
cd /home/hazzard/home-assistant
docker-compose restart prometheus
```

---

### For Windows Computers

**1. Copy the installation script to each Windows computer:**
Transfer `/home/hazzard/homeproject/docs/install-windows-exporter.ps1` to the Windows machine

**2. Run PowerShell as Administrator and execute:**
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-windows-exporter.ps1
```

**3. Test from monitoring server:**
```bash
curl http://<windows-host-ip>:9182/metrics | grep windows_logical_disk
```

**4. Add to Prometheus configuration:**
Edit `/home/hazzard/home-assistant/prometheus/prometheus.yml` and add the IP to `windows_servers`:
```yaml
- job_name: 'windows_servers'
  static_configs:
    - targets:
        - '192.168.40.60:9182'  # Replace with actual IP
```

**5. Restart Prometheus:**
```bash
cd /home/hazzard/home-assistant
docker-compose restart prometheus
```

---

## Set Up Grafana Dashboards

### Option 1: Import Pre-built Dashboards

**Access Grafana:** http://localhost:3001 (admin/admin)

**Add Prometheus Data Source (if not already done):**
1. Configuration → Data Sources → Add data source
2. Select "Prometheus"
3. URL: `http://prometheus:9090`
4. Click "Save & Test"

**Import Node Exporter Dashboard:**
1. Dashboards → Import
2. Dashboard ID: **1860**
3. Select Prometheus data source
4. Click Import

**Import Windows Exporter Dashboard:**
1. Dashboards → Import
2. Dashboard ID: **14694**
3. Select Prometheus data source
4. Click Import

### Option 2: Import Custom Storage Dashboard

**Import the custom storage monitoring dashboard:**
1. Dashboards → Import
2. Upload JSON file: `/home/hazzard/homeproject/docs/storage-monitoring-dashboard.json`
3. Select Prometheus data source
4. Click Import

This dashboard includes:
- Linux filesystem usage gauges
- Windows disk usage gauges
- Usage over time graphs
- Disk I/O charts for both Linux and Windows
- Detailed tables with all filesystem information

---

## Verify Everything is Working

### Check Prometheus Targets

**Web UI:** http://localhost:9090/targets

All targets should show status "UP" in green.

**Command line:**
```bash
curl -s http://localhost:9090/api/v1/targets | \
  python3 -m json.tool | \
  grep -E '"(job|instance|health)"'
```

### Check Alert Rules

**Web UI:** http://localhost:9090/alerts

**Command line:**
```bash
curl -s http://localhost:9090/api/v1/rules | \
  python3 -m json.tool | \
  grep -E '"name"' | head -20
```

### Test Storage Metrics

**Linux filesystem metrics:**
```bash
curl -s 'http://localhost:9090/api/v1/query?query=node_filesystem_avail_bytes' | \
  python3 -m json.tool
```

**Windows disk metrics:**
```bash
curl -s 'http://localhost:9090/api/v1/query?query=windows_logical_disk_free_bytes' | \
  python3 -m json.tool
```

---

## Useful Prometheus Queries

Copy these into Prometheus Graph UI (http://localhost:9090/graph):

### Disk Usage Percentage (Linux)
```promql
100 - ((node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100)
```

### Disk Usage Percentage (Windows)
```promql
100 - ((windows_logical_disk_free_bytes / windows_logical_disk_size_bytes) * 100)
```

### Available Space in GB (Linux)
```promql
node_filesystem_avail_bytes / 1024 / 1024 / 1024
```

### Available Space in GB (Windows)
```promql
windows_logical_disk_free_bytes / 1024 / 1024 / 1024
```

### Disk Read Rate (Bytes/sec)
```promql
rate(node_disk_read_bytes_total[5m])
```

### Disk Write Rate (Bytes/sec)
```promql
rate(node_disk_written_bytes_total[5m])
```

### Top 5 Fullest Filesystems
```promql
topk(5, 100 - ((node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100))
```

---

## File Locations

**Main Documentation:**
- `/home/hazzard/homeproject/docs/storage-monitoring-setup.md` - Complete setup guide

**Installation Scripts:**
- `/home/hazzard/homeproject/docs/install-node-exporter-linux.sh` - Linux installer
- `/home/hazzard/homeproject/docs/install-windows-exporter.ps1` - Windows installer

**Grafana Dashboard:**
- `/home/hazzard/homeproject/docs/storage-monitoring-dashboard.json` - Custom dashboard

**Prometheus Configuration:**
- `/home/hazzard/home-assistant/prometheus/prometheus.yml` - Main config
- `/home/hazzard/home-assistant/prometheus/alerts/storage_alerts.yml` - Alert rules

---

## Monitoring URLs

- **Prometheus:** http://localhost:9090
- **Prometheus Targets:** http://localhost:9090/targets
- **Prometheus Alerts:** http://localhost:9090/alerts
- **Prometheus Rules:** http://localhost:9090/rules
- **Grafana:** http://localhost:3001
- **Node Exporter (main host):** http://localhost:9100/metrics

---

## Quick Commands

**Restart Prometheus:**
```bash
cd /home/hazzard/home-assistant && docker-compose restart prometheus
```

**View Prometheus logs:**
```bash
docker logs -f prometheus
```

**Check Prometheus config is valid:**
```bash
docker exec prometheus promtool check config /etc/prometheus/prometheus.yml
```

**Check alert rules are valid:**
```bash
docker exec prometheus promtool check rules /etc/prometheus/alerts/storage_alerts.yml
```

**Reload Prometheus config without restart:**
```bash
curl -X POST http://localhost:9090/-/reload
```

**Test if a remote host is reachable:**
```bash
# Linux
curl http://192.168.40.XXX:9100/metrics | head

# Windows
curl http://192.168.40.XXX:9182/metrics | head
```

---

## Troubleshooting

### Prometheus not scraping a target

1. Check if the exporter is running on the remote host:
   ```bash
   # Linux
   ssh user@host "systemctl status node_exporter"

   # Windows (PowerShell)
   Get-Service windows_exporter
   ```

2. Check if the port is accessible:
   ```bash
   # From monitoring server
   nc -zv 192.168.40.XXX 9100  # Linux
   nc -zv 192.168.40.XXX 9182  # Windows
   ```

3. Check firewall rules:
   ```bash
   # Linux
   ssh user@host "sudo ufw status | grep 9100"

   # Windows (PowerShell)
   Get-NetFirewallRule -DisplayName "*Prometheus*"
   ```

### Grafana shows "No Data"

1. Verify Prometheus data source is configured correctly
2. Check that metrics exist in Prometheus
3. Adjust the time range in Grafana
4. Verify the correct job labels are used in queries

### Alert rules not firing

1. Check rules are loaded:
   ```bash
   curl http://localhost:9090/api/v1/rules
   ```

2. Manually test the alert query in Prometheus Graph UI

3. Check the alert evaluation time and "for" duration

---

## Example: Adding Your First Remote Linux Server

Let's say you have a Linux server at `192.168.40.55`:

**1. Install Node Exporter on 192.168.40.55:**
```bash
# From main host
scp /home/hazzard/homeproject/docs/install-node-exporter-linux.sh user@192.168.40.55:/tmp/

# SSH to remote host
ssh user@192.168.40.55
sudo bash /tmp/install-node-exporter-linux.sh
```

**2. Verify it's working:**
```bash
# From main host
curl http://192.168.40.55:9100/metrics | grep node_filesystem_size
```

**3. Add to Prometheus:**
```bash
# Edit config
nano /home/hazzard/home-assistant/prometheus/prometheus.yml

# Add under linux_servers targets:
- job_name: 'linux_servers'
  static_configs:
    - targets:
        - '192.168.40.55:9100'

# Restart Prometheus
cd /home/hazzard/home-assistant
docker-compose restart prometheus
```

**4. Verify in Prometheus:**
- Go to http://localhost:9090/targets
- Look for your new target with IP `192.168.40.55:9100`
- Status should be "UP" in green

**5. View in Grafana:**
- Go to http://localhost:3001
- Open the Node Exporter Full dashboard (ID 1860)
- Select your new host from the dropdown

Done! Your remote Linux server is now being monitored.

---

## Current System Status

Run these commands to check what's currently being monitored:

```bash
# Check all Prometheus targets
curl -s http://localhost:9090/api/v1/targets | \
  python3 -c "import sys, json; \
  targets = json.load(sys.stdin)['data']['activeTargets']; \
  print('\n'.join([f\"{t['labels']['job']:20} {t['labels'].get('instance', 'N/A'):30} {t['health']}\" for t in targets]))"

# Check main host storage
df -h | grep -E '(Filesystem|^/dev/)'

# Count alert rules
curl -s http://localhost:9090/api/v1/rules | \
  python3 -c "import sys, json; \
  rules = json.load(sys.stdin)['data']['groups'][0]['rules']; \
  print(f'Loaded {len(rules)} storage alert rules')"
```

---

## Maintenance

### Weekly Tasks
- Check Grafana dashboards for any systems approaching storage limits
- Review alert notifications (if configured)
- Verify all targets are healthy in Prometheus

### Monthly Tasks
- Update exporters to latest versions
- Review and adjust alert thresholds if needed
- Clean up old Prometheus data (automatic with 30-day retention)

### As Needed
- Add new systems to monitoring
- Create custom dashboards for specific use cases
- Set up alert notifications (email, Slack, etc.) via Grafana

---

## Need Help?

**Full documentation:** `/home/hazzard/homeproject/docs/storage-monitoring-setup.md`

**Prometheus documentation:** https://prometheus.io/docs/
**Grafana documentation:** https://grafana.com/docs/
**Node Exporter:** https://github.com/prometheus/node_exporter
**Windows Exporter:** https://github.com/prometheus-community/windows_exporter
