# Project 11: Energy Monitoring System

**Difficulty:** Advanced
**Estimated Time:** 5-8 hours
**Cost:** $40-70

## Learning Objectives

By completing this project, you will learn:
- AC current sensing (non-invasive and safe)
- Power calculations (watts, kWh, power factor)
- PZEM-004T communication (Modbus RTU protocol)
- Electrical safety with AC mains
- Long-term energy tracking with InfluxDB
- Cost calculations and budgeting
- Peak usage detection and alerts

---

## Parts List

| Part | Quantity | Approximate Cost (CAD) | Notes |
|------|----------|------------------------|-------|
| ESP32 Development Board | 1 | $8-12 | Reuse from previous projects |
| PZEM-004T V3.0 Module | 1 | $25-35 | AC power meter with CT clamp |
| SCT-013 Current Clamp (100A) | 1 | Included | Split-core CT (comes with PZEM) |
| Breadboard | 1 | Reuse | 400-point or larger |
| Jumper Wires | 6-10 | Reuse | Male-to-male |
| OLED Display (optional) | 1 | $8-12 | Real-time power display |

**Total Cost:** ~$40-70

**⚠️ SAFETY WARNING:**
- **AC mains electricity is DANGEROUS and can be LETHAL**
- **NEVER open electrical panels without proper training**
- **Use isolated modules (PZEM-004T is electrically isolated)**
- **Non-invasive installation only (CT clamp around wire, no cutting)**
- **If unsure, hire a licensed electrician**

**PZEM-004T Features:**
- **Voltage Range:** 80-260V AC
- **Current Range:** 0-100A (with included CT clamp)
- **Power Range:** 0-22 kW
- **Frequency:** 45-65 Hz
- **Accuracy:** ±0.5% (voltage), ±1% (current)
- **Isolation:** Optocoupler isolated (safe for ESP32)
- **Protocol:** Modbus RTU over UART

---

## Understanding the Parts

### PZEM-004T Power Meter

**How it works:**
- **Voltage sensing:** Internal transformer samples AC voltage
- **Current sensing:** External CT (current transformer) clamp measures magnetic field
- **Power calculation:** Real power (W) = Voltage × Current × Power Factor
- **Energy accumulation:** Tracks total kWh over time
- **Communication:** UART (TX/RX) sends data to ESP32 every second

**What it measures:**
- **Voltage (V):** Line voltage (e.g., 120V in North America)
- **Current (A):** Load current (e.g., 5A for 600W device)
- **Power (W):** Active power (watts consumed)
- **Energy (kWh):** Cumulative energy (1 kWh = 1000W for 1 hour)
- **Frequency (Hz):** AC frequency (60 Hz in North America, 50 Hz in Europe)
- **Power Factor (PF):** Ratio of real power to apparent power (0.0-1.0)

**Pinout:**
| Pin | Function | ESP32 Connection |
|-----|----------|------------------|
| 5V | Power input | 5V |
| GND | Ground | GND |
| RX | Receive (from ESP32) | GPIO17 (TX2) |
| TX | Transmit (to ESP32) | GPIO16 (RX2) |

**CT Clamp Installation:**
- **Split-core:** Opens like clothespin (no wire cutting needed)
- **Clamp around ONE wire only** (hot or neutral, not both!)
- **Arrow direction:** Points toward load (away from breaker panel)
- **Secure closure:** Ensure halves snap together fully

### Current Transformer (CT) Theory

**How CT clamps work:**
- **Magnetic induction:** Current flowing through wire creates magnetic field
- **Transformer action:** Magnetic field induces proportional current in CT coil
- **Turns ratio:** 100A primary → ~50mA secondary (2000:1 ratio typical)
- **Non-invasive:** No electrical connection to measured wire

**Installation Rules:**
1. **One wire only:** Clamp around hot OR neutral (never both!)
   - If both hot and neutral are in clamp, currents cancel = 0A reading
2. **Correct orientation:** Arrow points toward load
3. **Tight closure:** Gap in core reduces accuracy
4. **Wire centering:** Wire should pass through center of opening

**Common Mistakes:**
- ❌ Clamping around entire cable (hot + neutral + ground)
- ❌ Clamping around metal conduit instead of wire
- ❌ Arrow pointing wrong direction (reads negative power)
- ✅ Clamp around single insulated wire (hot or neutral)

### Power Factor

**What is power factor?**
- **Ratio:** Real Power (W) / Apparent Power (VA)
- **Range:** 0.0 (worst) to 1.0 (best)
- **Meaning:** How efficiently device uses electricity

**Examples:**
- **PF = 1.0:** Resistive loads (heaters, incandescent bulbs) - ideal
- **PF = 0.9:** Most appliances (fridges, TVs) - good
- **PF = 0.6:** Motors without correction, fluorescent lights - poor
- **PF < 0.5:** Old equipment, some LED drivers - very poor

**Why it matters:**
- Utility companies charge for apparent power (VA), not just real power (W)
- Low PF = higher current = wasted energy in wiring
- Power factor correction can reduce electricity bills

**Real vs Apparent Power:**
```
Apparent Power (VA) = Voltage × Current
Real Power (W) = Voltage × Current × Power Factor
Reactive Power (VAR) = √(VA² - W²)
```

### Energy Cost Calculation

**Formula:**
```
Cost = Energy (kWh) × Rate ($/kWh)
```

**Example (Ontario, Canada - approximate rates):**
- **Off-Peak:** $0.087/kWh (weekends, 7pm-7am weekdays)
- **Mid-Peak:** $0.132/kWh (weekday 11am-5pm)
- **On-Peak:** $0.18/kWh (weekday 7am-11am, 5pm-7pm)

**Daily cost for 1000W device running 24h:**
- Constant rate ($0.13/kWh): 24 kWh × $0.13 = **$3.12/day**
- Monthly: **~$94**
- Yearly: **~$1,140**

---

## Wiring Diagram

### PZEM-004T + ESP32 Connection

```
ESP32 Board            PZEM-004T Module         AC Load

5V -----------------> 5V (power)
GND ----------------> GND

GPIO17 (TX2) -------> RX (data in)
GPIO16 (RX2) <-------- TX (data out)

                      AC IN (Line, Neutral)
                         |
                         v
                    [CT Clamp around HOT wire only]
                         |
                         v
                      AC OUT (to load)


Optional: OLED Display (I2C)
GPIO21 (SDA) -------> SDA
GPIO22 (SCL) -------> SCL
3.3V ---------------> VCC
GND ----------------> GND
```

### Safe AC Installation

```
Electrical Panel            Device Under Test
    [Breaker]
        |
        | HOT (black/red) ← [CT Clamp HERE - arrow toward device]
        |
        +-------------------> Device HOT
        |
        | NEUTRAL (white)
        |
        +-------------------> Device NEUTRAL
        |
        | GROUND (green)
        |
        +-------------------> Device GROUND


PZEM-004T Wiring:
AC IN:  Connect to breaker output (before CT clamp)
AC OUT: Connect to device input (after CT clamp)

⚠️ CRITICAL: PZEM-004T AC terminals are NOT isolated from 5V/GND!
   Use ONLY the isolated UART interface (TX/RX) with ESP32.
   NEVER connect ESP32 to AC side!
```

**Installation Safety:**
1. **Turn off breaker** before any wiring
2. **Verify power is off** with multimeter or voltage tester
3. **Install PZEM-004T in electrical box or enclosure** (never exposed)
4. **Use wire nuts and proper gauge wire** (14 AWG for 15A, 12 AWG for 20A)
5. **Label everything** ("Energy Monitor - Do Not Disturb")
6. **Test with multimeter** before turning breaker on

---

## ESPHome Configuration

Create a new file: `/home/hazzard/home-assistant/esphome/energy-monitor.yaml`

### Complete Configuration

```yaml
esphome:
  name: energy-monitor
  friendly_name: "Home Energy Monitor"
  platform: ESP32
  board: esp32dev

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  manual_ip:
    static_ip: 192.168.40.170
    gateway: 192.168.40.1
    subnet: 255.255.255.0
    dns1: 8.8.8.8

  ap:
    ssid: "Energy-Monitor-FB"
    password: "12345678"

logger:
  baud_rate: 0  # Disable UART logging (UART2 used for PZEM)

api:
  encryption:
    key: !secret api_key_energy_monitor

ota:
  - platform: esphome
    password: !secret ota_password

# UART for PZEM-004T (Modbus RTU)
uart:
  id: pzem_uart
  tx_pin: GPIO17
  rx_pin: GPIO16
  baud_rate: 9600
  stop_bits: 1

# Modbus Controller
modbus:
  id: modbus_pzem

modbus_controller:
  - id: pzem_controller
    address: 0x01  # PZEM default Modbus address
    modbus_id: modbus_pzem
    update_interval: 10s
    setup_priority: -10

# PZEM-004T Sensors
sensor:
  # Voltage
  - platform: modbus_controller
    modbus_controller_id: pzem_controller
    name: "Voltage"
    id: pzem_voltage
    register_type: input
    address: 0x0000
    unit_of_measurement: "V"
    device_class: voltage
    state_class: measurement
    accuracy_decimals: 1
    filters:
      - multiply: 0.1  # PZEM returns value × 10

  # Current
  - platform: modbus_controller
    modbus_controller_id: pzem_controller
    name: "Current"
    id: pzem_current
    register_type: input
    address: 0x0001
    unit_of_measurement: "A"
    device_class: current
    state_class: measurement
    accuracy_decimals: 3
    filters:
      - multiply: 0.001  # PZEM returns mA

  # Power
  - platform: modbus_controller
    modbus_controller_id: pzem_controller
    name: "Power"
    id: pzem_power
    register_type: input
    address: 0x0003
    unit_of_measurement: "W"
    device_class: power
    state_class: measurement
    accuracy_decimals: 0
    filters:
      - multiply: 0.1

  # Energy (Total kWh)
  - platform: modbus_controller
    modbus_controller_id: pzem_controller
    name: "Energy"
    id: pzem_energy
    register_type: input
    address: 0x0005
    unit_of_measurement: "kWh"
    device_class: energy
    state_class: total_increasing
    accuracy_decimals: 2
    filters:
      - multiply: 0.001  # PZEM returns Wh, convert to kWh

  # Frequency
  - platform: modbus_controller
    modbus_controller_id: pzem_controller
    name: "Frequency"
    id: pzem_frequency
    register_type: input
    address: 0x0007
    unit_of_measurement: "Hz"
    state_class: measurement
    accuracy_decimals: 1
    filters:
      - multiply: 0.1

  # Power Factor
  - platform: modbus_controller
    modbus_controller_id: pzem_controller
    name: "Power Factor"
    id: pzem_pf
    register_type: input
    address: 0x0008
    unit_of_measurement: ""
    state_class: measurement
    accuracy_decimals: 2
    filters:
      - multiply: 0.01  # PZEM returns value × 100

  # Calculated: Daily Energy Cost (CAD)
  - platform: template
    name: "Daily Energy Cost"
    id: daily_cost
    unit_of_measurement: "$"
    icon: "mdi:currency-usd"
    accuracy_decimals: 2
    lambda: |-
      // Ontario Time-of-Use rates (approximate)
      // Off-peak: $0.087/kWh, Mid-peak: $0.132/kWh, On-peak: $0.18/kWh
      float rate = 0.13;  // Average blended rate

      // Get current energy (kWh)
      static float previous_energy = 0;
      float current_energy = id(pzem_energy).state;

      // Calculate daily consumption
      float daily_kwh = current_energy - previous_energy;

      // Reset at midnight
      auto time = id(homeassistant_time).now();
      if (time.hour == 0 && time.minute == 0) {
        previous_energy = current_energy;
      }

      return daily_kwh * rate;
    update_interval: 60s

  # Calculated: Projected Monthly Cost
  - platform: template
    name: "Projected Monthly Cost"
    id: monthly_cost
    unit_of_measurement: "$"
    icon: "mdi:currency-usd"
    accuracy_decimals: 2
    lambda: |-
      float daily_cost = id(daily_cost).state;
      return daily_cost * 30.4;  // Average days per month
    update_interval: 60s

  # WiFi Signal
  - platform: wifi_signal
    name: "WiFi Signal"
    update_interval: 60s

  # Uptime
  - platform: uptime
    name: "Uptime"
    update_interval: 300s

# Time (for daily cost reset)
time:
  - platform: homeassistant
    id: homeassistant_time

# Optional: I2C for OLED Display
i2c:
  sda: GPIO21
  scl: GPIO22
  scan: true

# Optional: OLED Display
font:
  - file: "gfonts://Roboto"
    id: font_small
    size: 12
  - file: "gfonts://Roboto@700"
    id: font_large
    size: 20

display:
  - platform: ssd1306_i2c
    model: "SSD1306 128x64"
    address: 0x3C
    update_interval: 1s
    lambda: |-
      // Header
      it.print(64, 0, id(font_small), TextAlign::TOP_CENTER, "Energy Monitor");

      // Power (large)
      it.printf(64, 16, id(font_large), TextAlign::TOP_CENTER, "%.0f W", id(pzem_power).state);

      // Voltage and Current
      it.printf(0, 48, id(font_small), TextAlign::BASELINE_LEFT, "%.1fV", id(pzem_voltage).state);
      it.printf(128, 48, id(font_small), TextAlign::BASELINE_RIGHT, "%.2fA", id(pzem_current).state);

      // Daily cost
      it.printf(64, 64, id(font_small), TextAlign::BASELINE_CENTER, "$%.2f/day", id(daily_cost).state);

# Text Sensors
text_sensor:
  - platform: wifi_info
    ip_address:
      name: "IP Address"

# Buttons
button:
  - platform: restart
    name: "Restart Device"

  # Reset energy counter (use with caution!)
  - platform: template
    name: "Reset Energy Counter"
    on_press:
      - logger.log: "Resetting PZEM energy counter..."
      # Note: This requires sending Modbus command 0x42 to PZEM
      # Implementation depends on ESPHome version

# Binary Sensors
binary_sensor:
  # High power usage alert (>2000W)
  - platform: template
    name: "High Power Alert"
    id: high_power_alert
    device_class: problem
    lambda: |-
      return id(pzem_power).state > 2000;
```

---

## Understanding the Code

### Modbus RTU Communication

```yaml
uart:
  tx_pin: GPIO17
  rx_pin: GPIO16
  baud_rate: 9600  # PZEM-004T uses 9600 baud
  stop_bits: 1
```

**What is Modbus RTU?**
- Industrial communication protocol (since 1979)
- Master-slave architecture (ESP32 = master, PZEM = slave)
- Request-response model (ESP32 asks, PZEM answers)
- CRC error checking (data integrity)

**Modbus Frame Structure:**
```
[Slave Address][Function Code][Register Address][Data][CRC]
     0x01           0x04            0x0000        ...   ...
```

### Register Mapping (PZEM-004T)

```yaml
address: 0x0000  # Voltage register
```

**PZEM-004T Register Map:**
| Address | Parameter | Unit | Scale |
|---------|-----------|------|-------|
| 0x0000 | Voltage | V | × 0.1 |
| 0x0001 | Current (low) | A | × 0.001 |
| 0x0002 | Current (high) | - | - |
| 0x0003 | Power (low) | W | × 0.1 |
| 0x0004 | Power (high) | - | - |
| 0x0005 | Energy (low) | Wh | × 1 |
| 0x0006 | Energy (high) | - | - |
| 0x0007 | Frequency | Hz | × 0.1 |
| 0x0008 | Power Factor | - | × 0.01 |
| 0x0009 | Alarm Status | - | - |

**Example Reading:**
- **Voltage = 1203** (register 0x0000) → 1203 × 0.1 = **120.3V**
- **Current = 5432** (register 0x0001) → 5432 × 0.001 = **5.432A**
- **Power = 6540** (register 0x0003) → 6540 × 0.1 = **654W**

### Cost Calculation Templates

```yaml
lambda: |-
  float rate = 0.13;  // $/kWh
  float daily_kwh = current_energy - previous_energy;
  return daily_kwh * rate;
```

**Time-of-Use Rate Logic:**
```cpp
lambda: |-
  auto time = id(homeassistant_time).now();
  float rate;

  // Weekend (all day off-peak)
  if (time.day_of_week == 1 || time.day_of_week == 7) {
    rate = 0.087;
  }
  // Weekday time-of-use
  else {
    int hour = time.hour;
    // On-peak: 7-11am, 5-7pm
    if ((hour >= 7 && hour < 11) || (hour >= 17 && hour < 19)) {
      rate = 0.18;
    }
    // Mid-peak: 11am-5pm
    else if (hour >= 11 && hour < 17) {
      rate = 0.132;
    }
    // Off-peak: 7pm-7am
    else {
      rate = 0.087;
    }
  }

  return id(pzem_power).state * (rate / 1000);  // Cost per hour
```

---

## Step-by-Step Build Guide

### Step 1: Hardware Assembly (Low-Voltage Testing)

**Before installing in electrical panel, test with USB power:**

1. **Wire ESP32 to PZEM-004T:**
   - PZEM **5V** → ESP32 **5V**
   - PZEM **GND** → ESP32 **GND**
   - PZEM **RX** → ESP32 **GPIO17** (TX2)
   - PZEM **TX** → ESP32 **GPIO16** (RX2)

2. **Flash configuration** via USB

3. **Test communication** (check logs):
   ```
   [I][modbus_controller:163]: Modbus command sent successfully
   [D][sensor:094]: 'Voltage': Got value 0.0V
   [D][sensor:094]: 'Current': Got value 0.0A
   ```

**If no communication:**
- Swap TX/RX pins (RX→TX, TX→RX)
- Check baud rate (must be 9600)
- Verify PZEM is powered (LED should light up)

### Step 2: AC Installation (Hire Electrician if Unsure!)

**⚠️ DANGER: This step involves AC mains electricity!**

**Option A: Monitor Individual Appliance (Easier)**
1. **Turn off power** to outlet
2. **Install PZEM-004T in junction box** between outlet and appliance
3. **Wire AC connections:**
   - Breaker HOT → PZEM AC IN (live)
   - PZEM AC OUT (load) → Appliance HOT
   - Neutral and Ground pass through (not monitored)
4. **Install CT clamp around HOT wire** (between breaker and PZEM)
5. **Close junction box** and secure
6. **Restore power** and test

**Option B: Monitor Whole House (Advanced)**
1. **⚠️ HIRE LICENSED ELECTRICIAN** (working in main panel is dangerous!)
2. **Install PZEM-004T in dedicated sub-panel** (safer than main panel)
3. **CT clamp around main service wire** (before branch breakers)
4. **Measure total house consumption**

**Recommended: Start with Option A (single appliance)**
- Safer (work in accessible junction box, not main panel)
- Easier troubleshooting
- Can monitor high-usage appliances (dryer, AC, water heater)

### Step 3: Verify Measurements

**Check readings in Home Assistant:**

1. **Voltage:** Should match your region
   - North America: ~120V (single-phase) or ~240V (split-phase)
   - Europe/Asia: ~230V
   - Tolerance: ±5% typical

2. **Current:** Depends on load
   - No load: 0.0-0.1A (idle current)
   - Small appliance: 0.5-2A (laptop, TV)
   - Large appliance: 5-15A (dryer, AC)

3. **Power:** Should equal Voltage × Current × Power Factor
   - **Example:** 120V × 5A × 0.95 PF = 570W

4. **Power Factor:** Varies by device
   - Resistive loads (heater): 0.95-1.0 (excellent)
   - Electronics (TV, PC): 0.7-0.9 (good)
   - Motors (fridge, AC): 0.6-0.8 (fair)

**Validation Test:**
1. Turn on known load (e.g., 1500W space heater)
2. Check power reading: should show ~1500W
3. Check current: 1500W ÷ 120V ÷ PF ≈ 12.5A (for PF=1.0)

### Step 4: Add to InfluxDB and Grafana

**Configure InfluxDB Integration:**

1. **Home Assistant → Settings → Integrations → InfluxDB**
2. **Select entities to track:**
   - ✅ `sensor.voltage`
   - ✅ `sensor.current`
   - ✅ `sensor.power`
   - ✅ `sensor.energy`
   - ✅ `sensor.power_factor`

**Create Grafana Dashboard:**

1. Access Grafana: http://192.168.40.201:3001
2. **Create → Dashboard → Add Panel**

**Power Usage Panel (Line Graph):**
```sql
SELECT mean("value")
FROM "sensor.power"
WHERE $timeFilter
GROUP BY time(1m) fill(linear)
```
- **Title:** "Power Usage (24h)"
- **Unit:** Watts (W)
- **Y-axis:** 0 to max expected load

**Energy Consumption Panel (Area Graph):**
```sql
SELECT last("value") - first("value") as "consumption"
FROM "sensor.energy"
WHERE $timeFilter
GROUP BY time(1h)
```
- **Title:** "Energy Consumption (kWh per hour)"
- **Unit:** Kilowatt-hours (kWh)
- **Fill:** Area under curve

**Cost Panel (Stat):**
```sql
SELECT last("value")
FROM "sensor.daily_energy_cost"
```
- **Visualization:** Stat (large number)
- **Color thresholds:**
  - < $2: Green
  - $2-5: Yellow
  - > $5: Red

### Step 5: Create Alerts and Automations

**High Usage Alert:**
```yaml
# configuration.yaml
automation:
  - alias: "High Power Usage Alert"
    trigger:
      - platform: numeric_state
        entity_id: sensor.power
        above: 2000  # 2000W threshold
        for:
          minutes: 5
    action:
      - service: notify.mobile_app_pixel_10_pro
        data:
          title: "⚡ High Power Usage!"
          message: "Current power usage: {{ states('sensor.power') }}W"

  - alias: "Unusual Night Usage Alert"
    trigger:
      - platform: time
        at: "02:00:00"
    condition:
      - condition: numeric_state
        entity_id: sensor.power
        above: 500  # 500W at 2 AM is unusual
    action:
      - service: notify.mobile_app_pixel_10_pro
        data:
          message: "Unusual power usage at night: {{ states('sensor.power') }}W"
```

**Daily Energy Report:**
```yaml
automation:
  - alias: "Daily Energy Report"
    trigger:
      - platform: time
        at: "20:00:00"  # 8 PM daily report
    action:
      - service: notify.mobile_app_pixel_10_pro
        data:
          title: "📊 Daily Energy Report"
          message: >
            Today's usage: {{ states('sensor.energy') | float - state_attr('sensor.energy', 'last_reset') | float }} kWh
            Cost: ${{ states('sensor.daily_energy_cost') }}
            Peak power: {{ state_attr('sensor.power', 'max_value') }}W
```

---

## Troubleshooting

### No Communication with PZEM-004T

**Cause:** Wiring or configuration issue

**Fix:**
1. **Check UART wiring:** Swap TX/RX if needed
2. **Verify baud rate:** Must be 9600 for PZEM-004T
3. **Check Modbus address:** Default is 0x01 (can be changed with special command)
4. **Inspect logs:**
   ```
   [E][modbus_controller:256]: Modbus communication error
   ```
5. **Try different UART pins** (GPIO pins 16/17 may conflict with PSRAM on some boards)

### Voltage Reads Zero or Incorrect

**Cause:** AC power not connected or PZEM not powered

**Fix:**
1. **Verify AC input:** PZEM AC IN terminals must have mains voltage
2. **Check PZEM LED:** Should illuminate when AC present
3. **Measure with multimeter:** Verify AC voltage at PZEM terminals
4. **Ensure ESP32 powered separately:** Don't rely on PZEM 5V output (may be weak)

### Current Reads Zero with Load Running

**Cause:** CT clamp installation error

**Fix:**
1. **Check clamp closure:** Halves must snap together fully
2. **Single wire only:** Ensure clamp around ONE wire (not cable bundle)
3. **Correct wire:** Clamp around HOT (black/red), not neutral or ground
4. **Arrow direction:** Point toward load (away from breaker)
5. **Test with known load:** Turn on 1500W heater (should read ~12A at 120V)

### Power Factor Shows 0.0 or Incorrect

**Cause:** PZEM firmware issue or very low load

**Fix:**
1. **Increase load:** PF reading unreliable below ~10W
2. **Check PZEM firmware version:** V3.0 has better PF accuracy than older versions
3. **Compare with known load:** Test with resistive heater (PF should be ~1.0)
4. **Update ESPHome:** Newer versions have better Modbus handling

### Energy Counter Resets Unexpectedly

**Cause:** PZEM power loss or Modbus reset command

**Fix:**
1. **Ensure continuous power:** PZEM must have stable AC power (no breaker trips)
2. **Check for reset commands:** Remove any "Reset Energy Counter" automations
3. **Use Home Assistant energy dashboard:** Tracks resets and maintains cumulative total
4. **Backup readings:** Log energy values to InfluxDB for recovery

---

## Advanced Features

### Multiple Circuit Monitoring

**Monitor 4 separate circuits with one ESP32:**

```yaml
# Use 4 PZEM-004T modules on shared UART bus
modbus_controller:
  - id: pzem_1
    address: 0x01  # Main panel
    modbus_id: modbus_pzem

  - id: pzem_2
    address: 0x02  # HVAC circuit
    modbus_id: modbus_pzem

  - id: pzem_3
    address: 0x03  # Kitchen appliances
    modbus_id: modbus_pzem

  - id: pzem_4
    address: 0x04  # Bedroom outlets
    modbus_id: modbus_pzem

# Change PZEM address with Modbus command (one-time setup)
# Address change requires special Modbus function code (0x06)
```

**Note:** Each PZEM needs unique Modbus address (factory default is 0x01)

### Load Disaggregation (Device Identification)

**Identify devices by power signature:**

```yaml
automation:
  - alias: "Detect Dryer Running"
    trigger:
      - platform: numeric_state
        entity_id: sensor.power
        above: 4000  # Dryer draws ~4500W
        for:
          seconds: 30
    action:
      - service: input_boolean.turn_on
        target:
          entity_id: input_boolean.dryer_running

  - alias: "Detect Dryer Finished"
    trigger:
      - platform: numeric_state
        entity_id: sensor.power
        below: 500
        for:
          minutes: 2
    condition:
      - condition: state
        entity_id: input_boolean.dryer_running
        state: 'on'
    action:
      - service: notify.mobile_app_pixel_10_pro
        data:
          message: "🧺 Dryer cycle complete!"
      - service: input_boolean.turn_off
        target:
          entity_id: input_boolean.dryer_running
```

### Peak Demand Tracking

**Identify peak usage times:**

```yaml
sensor:
  - platform: template
    sensors:
      peak_power_today:
        friendly_name: "Peak Power Today"
        unit_of_measurement: "W"
        value_template: >
          {{ state_attr('sensor.power', 'max_value') | default(0) }}

      peak_power_time:
        friendly_name: "Peak Time Today"
        value_template: >
          {{ state_attr('sensor.power', 'max_time') | default('Unknown') }}
```

---

## What You've Learned

By completing this project, you now understand:

✅ **AC Power Measurement:**
- Non-invasive current sensing with CT clamps
- Voltage and frequency monitoring
- Power factor and its importance

✅ **Energy Calculations:**
- Real vs apparent power
- kWh accumulation and cost calculation
- Time-of-use rate optimization

✅ **Modbus RTU Protocol:**
- UART communication with industrial devices
- Register mapping and data scaling
- Master-slave architecture

✅ **Electrical Safety:**
- Working with AC mains safely
- Isolation requirements
- When to hire professionals

✅ **Data Analytics:**
- Long-term energy tracking
- Peak demand identification
- Load disaggregation techniques

✅ **Home Automation:**
- Usage alerts and notifications
- Cost tracking and budgeting
- Appliance state detection

**Ready for the next project?** Try [Project 12: Custom HVAC Controller](12-custom-hvac-controller.md) to optimize heating and cooling costs!
