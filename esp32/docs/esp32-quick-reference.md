# ESP32 Quick Reference

## Common GPIO Pins (ESP32 DevKit)

### Safe to Use (No restrictions)
- GPIO 4, 5, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23, 25, 26, 27, 32, 33

### Special Purpose / Notes
- **GPIO 0** - Boot mode (pull LOW for flash mode), has pullup
- **GPIO 1, 3** - UART TX/RX (used for serial debug), avoid unless needed
- **GPIO 2** - Often connected to onboard LED, has pulldown, strapping pin
- **GPIO 6-11** - Connected to flash memory, DO NOT USE
- **GPIO 34, 35, 36, 39** - Input only (no pullup/pulldown)

### Common I2C
- **SDA: GPIO 21**
- **SCL: GPIO 22**

### Common SPI
- **MISO: GPIO 19**
- **MOSI: GPIO 23**
- **CLK: GPIO 18**
- **CS: GPIO 5** (can be any pin)

## Voltage Levels
- **Logic Level:** 3.3V (NOT 5V tolerant on most pins!)
- **ADC Input:** 0-3.3V (some boards have voltage dividers for 0-5V)
- **Operating Voltage:** 3.3V (board regulators accept 5V via USB)

## Power Specifications
- **Deep Sleep:** ~10μA
- **Light Sleep:** ~0.8mA
- **WiFi Active:** ~160-260mA
- **Bluetooth Active:** ~100-130mA
- **Recommended Supply:** 500mA+ for WiFi stability

## ESPHome Common Platforms

### Sensors
```yaml
# Temperature/Humidity
- platform: dht       # DHT11, DHT22
- platform: bme280    # I2C temp/humidity/pressure
- platform: dallas    # DS18B20 one-wire

# Distance
- platform: ultrasonic  # HC-SR04

# Light
- platform: adc         # Analog input (0-3.3V)
```

### Binary Sensors
```yaml
- platform: gpio      # Buttons, switches, PIR
```

### Switches/Outputs
```yaml
- platform: gpio      # Relays, LEDs
```

### Lights
```yaml
- platform: esp32_rmt_led_strip  # WS2812B, SK6812
- platform: rgb                  # RGB LED (3 GPIO)
```

## Flashing Methods

### Via ESPHome Web UI (Preferred)
1. Access: http://localhost:6052
2. Create/edit device config
3. Click "Install" → "Wirelessly" (if already flashed) or "Plug into this computer"

### Via ESPHome CLI
```bash
# Compile only
docker exec -it esphome esphome compile device.yaml

# Compile and upload (USB)
docker exec -it esphome esphome upload device.yaml

# View logs
docker exec -it esphome esphome logs device.yaml
```

### First-Time Flash (USB Required)
- Install esptool: `pip install esptool`
- Hold BOOT button while connecting USB (some boards auto-detect)
- Use ESPHome web installer or Arduino IDE

## Troubleshooting

### Won't Flash
- Hold BOOT button (GPIO0) while connecting
- Check USB cable (must be data cable, not charge-only)
- Try different USB port
- Verify correct board selection

### WiFi Connection Issues
- Check signal strength (move closer to router)
- Verify credentials in secrets.yaml
- Use 2.4GHz WiFi (ESP32 doesn't support 5GHz)
- Check for special characters in SSID/password

### Random Crashes/Reboots
- Insufficient power supply (use 2A+ adapter)
- Check for loose connections
- Add bulk capacitor (100-470μF) near power input
- Avoid long wires on high-frequency signals

### Device Not Showing in Home Assistant
- Check API encryption key matches
- Verify device is on same network
- Check Home Assistant logs: Settings → System → Logs
- Manually add via: Settings → Devices & Services → Add Integration → ESPHome

## Learning Resources

- **Official ESPHome Docs:** https://esphome.io/
- **ESP32 Datasheet:** https://www.espressif.com/en/products/socs/esp32
- **Home Assistant ESPHome Integration:** https://www.home-assistant.io/integrations/esphome/
- **Your Production Devices:** `/home/hazzard/home-assistant/esphome/`
