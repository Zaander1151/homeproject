# Storage Monitoring Setup Guide

## Overview

This guide covers comprehensive storage monitoring across multiple computers using Prometheus, Grafana, and exporters.

**Architecture:**
- **Prometheus** - Collects metrics from all systems (already running on main host)
- **Grafana** - Visualizes storage data with dashboards (already running on main host)
- **Node Exporter** - Linux system metrics including disk usage
- **Windows Exporter** - Windows system metrics including disk usage

**Network:** 192.168.40.0/24
**Main Monitoring Server:** Current host (Prometheus at http://localhost:9090)
**Grafana Dashboard:** http://localhost:3001

---

## Part 1: Linux Systems Storage Monitoring

### Installing Node Exporter on Remote Linux Systems

Node Exporter provides comprehensive system metrics including disk usage, filesystem stats, and I/O metrics.

**SSH into each Linux system and run:**

```bash
# Download Node Exporter (latest stable version)
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz

# Extract
tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/
sudo chmod +x /usr/local/bin/node_exporter

# Create node_exporter user
sudo useradd -rs /bin/false node_exporter

# Create systemd service
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Verify it's running
sudo systemctl status node_exporter

# Test metrics endpoint
curl http://localhost:9100/metrics | grep node_filesystem
```

**Firewall Configuration:**

```bash
# Allow Prometheus server to access Node Exporter
sudo ufw allow from 192.168.40.0/24 to any port 9100 comment 'Prometheus Node Exporter'
```

**Verify Installation:**

```bash
# Check if port is listening
sudo ss -tlnp | grep 9100

# Test from monitoring server
curl http://<linux-host-ip>:9100/metrics
```

---

## Part 2: Windows Systems Storage Monitoring

### Installing Windows Exporter

Windows Exporter (formerly windows_exporter/wmi_exporter) provides Windows system metrics.

**Download and Install:**

1. **Download the latest release:**
   - Go to: https://github.com/prometheus-community/windows_exporter/releases
   - Download: `windows_exporter-X.X.X-amd64.msi`

2. **Install with custom collectors:**

   ```powershell
   # Run PowerShell as Administrator
   # Install with specific collectors enabled
   msiexec /i windows_exporter-0.27.2-amd64.msi ENABLED_COLLECTORS="cpu,cs,logical_disk,net,os,system,process" /qn
   ```

   **Or use the GUI installer and enable these collectors:**
   - `cpu` - CPU usage
   - `cs` - Computer system info
   - `logical_disk` - Disk space and I/O
   - `net` - Network interface stats
   - `os` - Operating system info
   - `system` - System metrics
   - `process` - Process information

3. **Verify Service:**

   ```powershell
   # Check service status
   Get-Service windows_exporter

   # Test metrics endpoint
   Invoke-WebRequest -Uri http://localhost:9182/metrics
   ```

4. **Configure Firewall:**

   ```powershell
   # Allow Prometheus server to access Windows Exporter
   New-NetFirewallRule -DisplayName "Prometheus Windows Exporter" `
     -Direction Inbound `
     -Protocol TCP `
     -LocalPort 9182 `
     -Action Allow `
     -RemoteAddress 192.168.40.0/24
   ```

**Verify Installation from Monitoring Server:**

```bash
curl http://<windows-host-ip>:9182/metrics | grep windows_logical_disk
```

---

## Part 3: Update Prometheus Configuration

### Edit Prometheus Config

Edit `/home/hazzard/home-assistant/prometheus/prometheus.yml` to add your remote systems:

```yaml
scrape_configs:
  # Monitor cAdvisor (Docker containers)
  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']

  # Monitor Node Exporter (main host system metrics)
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['node_exporter:9100']
        labels:
          hostname: 'main-host'
          role: 'docker-host'

  # Monitor Prometheus itself
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Remote Linux Systems
  - job_name: 'linux_servers'
    static_configs:
      - targets:
          - '192.168.40.XXX:9100'  # Replace with actual IP
          - '192.168.40.YYY:9100'  # Add more as needed
        labels:
          role: 'linux-server'

  # Windows Systems
  - job_name: 'windows_servers'
    static_configs:
      - targets:
          - '192.168.40.ZZZ:9182'  # Replace with actual IP
          - '192.168.40.AAA:9182'  # Add more as needed
        labels:
          role: 'windows-server'
```

**Apply Configuration:**

```bash
cd /home/hazzard/home-assistant
docker-compose restart prometheus

# Verify targets are being scraped
# Go to: http://localhost:9090/targets
```

---

## Part 4: Grafana Dashboard Setup

### Import Pre-built Storage Dashboard

1. **Access Grafana:** http://localhost:3001 (default: admin/admin)

2. **Add Prometheus Data Source** (if not already configured):
   - Go to Configuration → Data Sources → Add data source
   - Select Prometheus
   - URL: `http://prometheus:9090`
   - Click "Save & Test"

3. **Import Node Exporter Dashboard:**
   - Go to Dashboards → Import
   - Enter Dashboard ID: **1860** (Node Exporter Full)
   - Select Prometheus data source
   - Click Import

4. **Import Windows Exporter Dashboard:**
   - Go to Dashboards → Import
   - Enter Dashboard ID: **14694** (Windows Exporter Dashboard)
   - Select Prometheus data source
   - Click Import

### Custom Storage-Focused Dashboard

I'll create a custom dashboard JSON that focuses specifically on storage monitoring across all systems.

**Dashboard Features:**
- Disk usage by filesystem across all hosts
- Filesystem fill rate predictions
- Disk I/O statistics
- Inode usage monitoring
- Storage alerts and thresholds
- Network storage mount monitoring

**Import Custom Dashboard:**
- Use the dashboard JSON file: `storage-monitoring-dashboard.json`
- Import via Grafana UI: Dashboards → Import → Upload JSON file

---

## Part 5: Alerting Rules

### Prometheus Alert Rules

Create alert rules for storage thresholds in Prometheus.

**Create alert rules file:**

Location: `/home/hazzard/home-assistant/prometheus/alerts/storage_alerts.yml`

```yaml
groups:
  - name: storage_alerts
    interval: 60s
    rules:
      # Disk usage over 80%
      - alert: DiskSpaceWarning
        expr: |
          (node_filesystem_avail_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"} /
           node_filesystem_size_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"}) * 100 < 20
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Disk space warning on {{ $labels.instance }}"
          description: "Filesystem {{ $labels.mountpoint }} on {{ $labels.instance }} has only {{ $value | humanize }}% available space"

      # Disk usage over 90%
      - alert: DiskSpaceCritical
        expr: |
          (node_filesystem_avail_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"} /
           node_filesystem_size_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"}) * 100 < 10
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "CRITICAL: Disk space on {{ $labels.instance }}"
          description: "Filesystem {{ $labels.mountpoint }} on {{ $labels.instance }} has only {{ $value | humanize }}% available space"

      # Disk will fill in 4 hours based on current rate
      - alert: DiskWillFillSoon
        expr: |
          predict_linear(node_filesystem_avail_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"}[1h], 4*3600) < 0
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Disk filling rapidly on {{ $labels.instance }}"
          description: "Filesystem {{ $labels.mountpoint }} on {{ $labels.instance }} is predicted to fill within 4 hours"

      # Inode usage over 80%
      - alert: InodeUsageHigh
        expr: |
          (node_filesystem_files_free / node_filesystem_files) * 100 < 20
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High inode usage on {{ $labels.instance }}"
          description: "Filesystem {{ $labels.mountpoint }} on {{ $labels.instance }} has only {{ $value | humanize }}% inodes available"

      # Windows disk space warning
      - alert: WindowsDiskSpaceWarning
        expr: |
          (windows_logical_disk_free_bytes / windows_logical_disk_size_bytes) * 100 < 20
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Windows disk space warning on {{ $labels.instance }}"
          description: "Drive {{ $labels.volume }} on {{ $labels.instance }} has only {{ $value | humanize }}% available space"
```

**Update Prometheus configuration to load alerts:**

Edit `/home/hazzard/home-assistant/prometheus/prometheus.yml`:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

# Load alert rules
rule_files:
  - '/etc/prometheus/alerts/*.yml'

# Add alertmanager endpoint if you set one up
# alerting:
#   alertmanagers:
#     - static_configs:
#         - targets: ['alertmanager:9093']

scrape_configs:
  # ... existing config ...
```

**Update docker-compose to mount alerts directory:**

Edit `/home/hazzard/home-assistant/docker-compose.yml` Prometheus section:

```yaml
prometheus:
  image: prom/prometheus:latest
  container_name: prometheus
  volumes:
    - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    - ./prometheus/alerts:/etc/prometheus/alerts  # Add this line
    - prometheus-data:/prometheus
  # ... rest of config ...
```

**Apply changes:**

```bash
cd /home/hazzard/home-assistant
mkdir -p prometheus/alerts
# Create the storage_alerts.yml file
docker-compose restart prometheus
```

**View alerts:** http://localhost:9090/alerts

---

## Part 6: Monitoring Network Shares

Your `/mnt/storage` share is already monitored by the main host's Node Exporter.

**To monitor other network mounts:**

1. **Mount on monitoring server:**
   ```bash
   sudo mkdir -p /mnt/remote-share
   sudo mount -t nfs 192.168.40.XXX:/share /mnt/remote-share
   ```

2. **Add to /etc/fstab for persistence:**
   ```bash
   192.168.40.XXX:/share  /mnt/remote-share  nfs  defaults  0  0
   ```

3. Node Exporter will automatically monitor all mounted filesystems

**For CIFS/SMB shares:**
```bash
sudo mount -t cifs //192.168.40.XXX/share /mnt/remote-share -o username=user,password=pass
```

---

## Quick Reference: Key Metrics

### Linux Storage Metrics (Node Exporter)

```promql
# Disk usage percentage
100 - ((node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100)

# Disk I/O read bytes per second
rate(node_disk_read_bytes_total[5m])

# Disk I/O write bytes per second
rate(node_disk_written_bytes_total[5m])

# Filesystem size in GB
node_filesystem_size_bytes / 1024 / 1024 / 1024

# Available space in GB
node_filesystem_avail_bytes / 1024 / 1024 / 1024
```

### Windows Storage Metrics (Windows Exporter)

```promql
# Disk usage percentage
100 - ((windows_logical_disk_free_bytes / windows_logical_disk_size_bytes) * 100)

# Disk read bytes per second
rate(windows_logical_disk_read_bytes_total[5m])

# Disk write bytes per second
rate(windows_logical_disk_write_bytes_total[5m])

# Free space in GB
windows_logical_disk_free_bytes / 1024 / 1024 / 1024
```

---

## Testing and Validation

### Verify Each Component

**1. Check Prometheus targets:**
```bash
curl http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job, instance, health}'
```

**2. Query storage metrics:**
```bash
# Linux filesystems
curl -G http://localhost:9090/api/v1/query --data-urlencode 'query=node_filesystem_avail_bytes'

# Windows disks
curl -G http://localhost:9090/api/v1/query --data-urlencode 'query=windows_logical_disk_free_bytes'
```

**3. Test alerts:**
```bash
curl http://localhost:9090/api/v1/alerts
```

**4. Access Grafana dashboards:**
- Node Exporter Full: http://localhost:3001/d/rYdddlPWk/node-exporter-full
- Windows Exporter: http://localhost:3001/d/windows-exporter
- Custom Storage Dashboard: http://localhost:3001/d/storage-monitoring

---

## Maintenance

### Updating Exporters

**Linux Node Exporter:**
```bash
# Check current version
/usr/local/bin/node_exporter --version

# Download latest, replace binary, restart service
sudo systemctl restart node_exporter
```

**Windows Exporter:**
- Download latest MSI from GitHub releases
- Run installer to upgrade
- Service automatically restarts

### Troubleshooting

**Prometheus not scraping targets:**
```bash
# Check Prometheus logs
docker logs prometheus

# Verify network connectivity
docker exec prometheus wget -O- http://192.168.40.XXX:9100/metrics

# Check firewall rules on remote systems
sudo ufw status
```

**Missing metrics:**
```bash
# Verify exporter is running
sudo systemctl status node_exporter  # Linux
Get-Service windows_exporter  # Windows

# Check exporter logs
sudo journalctl -u node_exporter -f  # Linux
Get-EventLog -LogName Application -Source windows_exporter  # Windows
```

**Dashboard showing "No Data":**
1. Verify Prometheus data source is configured
2. Check that metrics exist: http://localhost:9090/graph
3. Adjust time range in Grafana dashboard
4. Verify correct job labels in queries

---

## Next Steps

1. Install Node Exporter on all Linux systems
2. Install Windows Exporter on all Windows systems
3. Update Prometheus configuration with all target IPs
4. Import Grafana dashboards
5. Configure alert rules
6. Set up notification channels (email, Slack, etc.) in Grafana
7. Document each monitored system with hostname and IP

**Optional Enhancements:**
- Set up Alertmanager for advanced alert routing
- Add Loki for log aggregation
- Configure blackbox exporter for endpoint monitoring
- Implement SNMP exporter for network devices
- Add custom exporters for specific applications
