# Windows Exporter Installation Script
# Run this script in PowerShell as Administrator on each Windows computer
# Usage: Right-click PowerShell and "Run as Administrator", then:
#        Set-ExecutionPolicy Bypass -Scope Process -Force
#        .\install-windows-exporter.ps1

# Requires elevation
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator!"
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'"
    Exit
}

$VERSION = "0.27.2"
$ARCH = "amd64"
$DOWNLOAD_URL = "https://github.com/prometheus-community/windows_exporter/releases/download/v$VERSION/windows_exporter-$VERSION-$ARCH.msi"
$INSTALLER_PATH = "$env:TEMP\windows_exporter-$VERSION-$ARCH.msi"

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Windows Exporter Installation Script" -ForegroundColor Cyan
Write-Host "Version: $VERSION" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Download installer
Write-Host "[1/5] Downloading Windows Exporter v$VERSION..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $INSTALLER_PATH -UseBasicParsing
    Write-Host "Download complete" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to download installer" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Exit 1
}

# Install with specific collectors
Write-Host "[2/5] Installing Windows Exporter..." -ForegroundColor Yellow
Write-Host "Enabled collectors: cpu, cs, logical_disk, net, os, system, process" -ForegroundColor Gray

$ENABLED_COLLECTORS = "cpu,cs,logical_disk,net,os,system,process"
$MSI_ARGS = @(
    "/i"
    "`"$INSTALLER_PATH`""
    "ENABLED_COLLECTORS=$ENABLED_COLLECTORS"
    "/qn"
    "/L*v"
    "$env:TEMP\windows_exporter_install.log"
)

try {
    $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $MSI_ARGS -Wait -PassThru -NoNewWindow
    if ($process.ExitCode -eq 0) {
        Write-Host "Installation successful" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Installation failed with exit code $($process.ExitCode)" -ForegroundColor Red
        Write-Host "Check log file: $env:TEMP\windows_exporter_install.log" -ForegroundColor Yellow
        Exit 1
    }
} catch {
    Write-Host "ERROR: Failed to install" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Exit 1
}

# Wait for service to start
Write-Host "[3/5] Starting service..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Verify service
Write-Host "[4/5] Verifying service..." -ForegroundColor Yellow
$service = Get-Service -Name "windows_exporter" -ErrorAction SilentlyContinue
if ($service) {
    Write-Host "Service status: $($service.Status)" -ForegroundColor Green
    if ($service.Status -ne "Running") {
        Write-Host "Starting service..." -ForegroundColor Yellow
        Start-Service -Name "windows_exporter"
        Start-Sleep -Seconds 2
        $service = Get-Service -Name "windows_exporter"
        Write-Host "Service status: $($service.Status)" -ForegroundColor Green
    }
} else {
    Write-Host "ERROR: Service not found" -ForegroundColor Red
    Exit 1
}

# Configure firewall
Write-Host "[5/5] Configuring firewall..." -ForegroundColor Yellow
try {
    $existingRule = Get-NetFirewallRule -DisplayName "Prometheus Windows Exporter" -ErrorAction SilentlyContinue
    if ($existingRule) {
        Write-Host "Firewall rule already exists, removing old rule..." -ForegroundColor Gray
        Remove-NetFirewallRule -DisplayName "Prometheus Windows Exporter"
    }

    New-NetFirewallRule -DisplayName "Prometheus Windows Exporter" `
        -Direction Inbound `
        -Protocol TCP `
        -LocalPort 9182 `
        -Action Allow `
        -RemoteAddress 192.168.40.0/24 `
        -Description "Allow Prometheus server to scrape Windows metrics" | Out-Null

    Write-Host "Firewall rule created successfully" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Failed to create firewall rule" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host "You may need to manually allow port 9182 from 192.168.40.0/24" -ForegroundColor Yellow
}

# Cleanup
Write-Host ""
Write-Host "Cleaning up temporary files..." -ForegroundColor Gray
Remove-Item -Path $INSTALLER_PATH -Force -ErrorAction SilentlyContinue

# Test metrics endpoint
Write-Host ""
Write-Host "Testing metrics endpoint..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9182/metrics" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "Metrics endpoint is responding" -ForegroundColor Green
        $metricsCount = ($response.Content -split "`n" | Where-Object { $_ -match "^windows_" }).Count
        Write-Host "Found $metricsCount Windows metrics" -ForegroundColor Green
    }
} catch {
    Write-Host "WARNING: Could not connect to metrics endpoint" -ForegroundColor Yellow
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}

# Get IP address
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet*" | Select-Object -First 1).IPAddress
if (-not $ipAddress) {
    $ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -notlike "127.*" } | Select-Object -First 1).IPAddress
}

# Final summary
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Service Information:" -ForegroundColor White
Write-Host "  Name: windows_exporter" -ForegroundColor Gray
Write-Host "  Status: $($service.Status)" -ForegroundColor Gray
Write-Host "  Port: 9182" -ForegroundColor Gray
Write-Host "  Local endpoint: http://localhost:9182/metrics" -ForegroundColor Gray
Write-Host "  Network endpoint: http://${ipAddress}:9182/metrics" -ForegroundColor Gray
Write-Host ""
Write-Host "Enabled Collectors:" -ForegroundColor White
Write-Host "  - cpu (CPU usage)" -ForegroundColor Gray
Write-Host "  - cs (Computer system info)" -ForegroundColor Gray
Write-Host "  - logical_disk (Disk space and I/O)" -ForegroundColor Gray
Write-Host "  - net (Network interface stats)" -ForegroundColor Gray
Write-Host "  - os (Operating system info)" -ForegroundColor Gray
Write-Host "  - system (System metrics)" -ForegroundColor Gray
Write-Host "  - process (Process information)" -ForegroundColor Gray
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor White
Write-Host "  1. Test from monitoring server:" -ForegroundColor Yellow
Write-Host "     curl http://${ipAddress}:9182/metrics | grep windows_logical_disk" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Add to Prometheus configuration:" -ForegroundColor Yellow
Write-Host "     - Edit /home/hazzard/home-assistant/prometheus/prometheus.yml" -ForegroundColor Gray
Write-Host "     - Add '${ipAddress}:9182' to windows_servers targets" -ForegroundColor Gray
Write-Host "     - Restart Prometheus: docker-compose restart prometheus" -ForegroundColor Gray
Write-Host ""
Write-Host "  3. View metrics in Grafana:" -ForegroundColor Yellow
Write-Host "     - Import dashboard ID 14694 (Windows Exporter Dashboard)" -ForegroundColor Gray
Write-Host "     - Or use custom storage dashboard" -ForegroundColor Gray
Write-Host ""
