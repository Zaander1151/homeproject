#include <Arduino.h>
#include <Wire.h>

#define AHT10_ADDR 0x38

void setup() {
  Serial.begin(115200);
  delay(2000);

  Serial.println("\n\n=== AHT10 Raw Test ===");

  Wire.begin(21, 22);
  delay(100);

  // Initialize AHT10
  Serial.println("Initializing AHT10...");
  Wire.beginTransmission(AHT10_ADDR);
  Wire.write(0xE1); // Init command
  Wire.write(0x08);
  Wire.write(0x00);
  Wire.endTransmission();
  delay(500);

  Serial.println("AHT10 initialized!\n");
}

void loop() {
  // Trigger measurement
  Wire.beginTransmission(AHT10_ADDR);
  Wire.write(0xAC); // Trigger command
  Wire.write(0x33);
  Wire.write(0x00);
  Wire.endTransmission();

  delay(100); // Wait for measurement

  // Read 6 bytes
  Wire.requestFrom(AHT10_ADDR, 6);
  if (Wire.available() >= 6) {
    uint8_t data[6];
    for (int i = 0; i < 6; i++) {
      data[i] = Wire.read();
    }

    // Calculate humidity
    uint32_t humidity_raw = ((uint32_t)data[1] << 12) | ((uint32_t)data[2] << 4) | ((data[3] & 0xF0) >> 4);
    float humidity = ((float)humidity_raw / 1048576.0) * 100.0;

    // Calculate temperature
    uint32_t temp_raw = (((uint32_t)data[3] & 0x0F) << 16) | ((uint32_t)data[4] << 8) | data[5];
    float temperature = (((float)temp_raw / 1048576.0) * 200.0) - 50.0;

    Serial.print("Temperature: ");
    Serial.print(temperature, 2);
    Serial.print(" °C | Humidity: ");
    Serial.print(humidity, 2);
    Serial.println(" %");
  } else {
    Serial.println("ERROR: Failed to read from AHT10");
  }

  delay(2000);
}
