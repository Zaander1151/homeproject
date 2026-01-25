# Barbell Lift Tracker

**Status:** Idea / Future Project

## Concept

ESP32-based device to automatically track barbell lifts (bench press, squat, deadlift, overhead press, bent over rows) using an IMU sensor and TinyML for exercise classification.

## Goals

- Auto-detect exercise type from movement signature
- Auto-count reps
- Auto-detect set boundaries (rest periods)
- Sync data to Home Assistant or phone

## Hardware (Tentative)

- ESP32-C3 or S3
- MPU6050 or LSM6DS3 (accelerometer + gyroscope)
- Small LiPo battery
- 3D printed barbell clamp enclosure

## Notes

- Weight tracking is the hard problem - may require voice input or manual confirmation
- Would use Edge Impulse for TinyML model training
- Each lift has a distinct motion pattern that should be classifiable
