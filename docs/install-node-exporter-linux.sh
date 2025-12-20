#!/bin/bash
# Node Exporter Installation Script for Linux
# Run this script on each Linux system you want to monitor
# Usage: sudo bash install-node-exporter-linux.sh

set -e

VERSION="1.8.2"
ARCH="amd64"

echo "==============================================="
echo "Node Exporter Installation Script"
echo "Version: ${VERSION}"
echo "==============================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: Please run as root (use sudo)"
  exit 1
fi

# Download Node Exporter
echo "[1/7] Downloading Node Exporter v${VERSION}..."
cd /tmp
wget -q --show-progress "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-${ARCH}.tar.gz"

# Extract
echo "[2/7] Extracting archive..."
tar xzf "node_exporter-${VERSION}.linux-${ARCH}.tar.gz"

# Install binary
echo "[3/7] Installing binary to /usr/local/bin..."
cp "node_exporter-${VERSION}.linux-${ARCH}/node_exporter" /usr/local/bin/
chmod +x /usr/local/bin/node_exporter

# Create user
echo "[4/7] Creating node_exporter user..."
if ! id -u node_exporter > /dev/null 2>&1; then
    useradd -rs /bin/false node_exporter
    echo "User created"
else
    echo "User already exists"
fi

# Create systemd service
echo "[5/7] Creating systemd service..."
cat > /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter
Documentation=https://github.com/prometheus/node_exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
echo "[6/7] Enabling and starting service..."
systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# Configure firewall
echo "[7/7] Configuring firewall..."
if command -v ufw &> /dev/null; then
    echo "UFW detected, adding firewall rule..."
    ufw allow from 192.168.40.0/24 to any port 9100 comment 'Prometheus Node Exporter'
    echo "Firewall rule added"
elif command -v firewall-cmd &> /dev/null; then
    echo "firewalld detected, adding firewall rule..."
    firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.40.0/24" port port="9100" protocol="tcp" accept'
    firewall-cmd --reload
    echo "Firewall rule added"
else
    echo "No firewall detected, skipping firewall configuration"
    echo "WARNING: You may need to manually configure your firewall to allow port 9100 from 192.168.40.0/24"
fi

# Cleanup
echo ""
echo "Cleaning up temporary files..."
rm -rf "/tmp/node_exporter-${VERSION}.linux-${ARCH}"*

# Verify installation
echo ""
echo "==============================================="
echo "Installation Complete!"
echo "==============================================="
echo ""
echo "Service status:"
systemctl status node_exporter --no-pager | head -5
echo ""
echo "Listening on port:"
ss -tlnp | grep 9100
echo ""
echo "Test metrics endpoint:"
echo "  curl http://localhost:9100/metrics | grep node_filesystem"
echo ""
echo "From monitoring server:"
echo "  curl http://$(hostname -I | awk '{print $1}'):9100/metrics"
echo ""
echo "Next steps:"
echo "1. Test the metrics endpoint from the monitoring server"
echo "2. Add this host to Prometheus configuration:"
echo "   - Edit /home/hazzard/home-assistant/prometheus/prometheus.yml"
echo "   - Add '$(hostname -I | awk '{print $1}'):9100' to linux_servers targets"
echo "   - Restart Prometheus: docker-compose restart prometheus"
echo ""
