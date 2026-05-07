
# mobile_sensor_msgs

This package provides custom ROS 2 interfaces designed to stream hardware sensor data from Android/iOS devices (like smartphones and tablets) to a robotic system. It acts as the "nervous system" bridging mobile-specific hardware—such as capacitive multi-touch screens, NFC readers, and biometric scanners—that are not covered by standard ROS 2 `sensor_msgs`.


## 📦 Provided Messages

This package currently defines the following custom interfaces:

### 1. Touch Interface (`TouchPoint.msg` & `TouchArray.msg`)
Standard ROS 2 lacks a native multi-touch interface. These messages capture the spatial intent of a touch screen using normalized coordinates (0.0 to 1.0), making them resolution-independent across different devices.

**`TouchPoint.msg`**
Represents a single active touch (finger) on the screen.
```text
uint32 id            # Unique ID for the finger (tracked by OS)
float32 x            # Normalized 0.0 to 1.0 (Left to Right)
float32 y            # Normalized 0.0 to 1.0 (Top to Bottom)
float32 pressure     # Normalized 0.0 to 1.0 (Force applied)
float32 major_axis   # Size of the touch ellipse (useful for "palm" vs "finger" detection)
```

**`TouchArray.msg`**
Published to stream all currently active touches.
```text
std_msgs/Header header   # Includes timestamp of the touch event
TouchPoint[] touches     # List of active touches
```

### 2. NFC / RFID Data (`NFCData.msg`)
Used for reading passive NFC tags (e.g., for robot docking stations, inventory tracking, or location tagging).
```text
std_msgs/Header header
string tag_id          # Unique Serial Number (UID)
string technology      # e.g., "NFC-A", "MifareClassic"
uint8[] ndef_payload   # The raw data stored on the tag
```

### 3. Biometric Authentication (`BiometricAuth.msg`)
Used for "Safe Mode" or "Owner Unlock" operations using the phone's fingerprint scanner or facial recognition.
```text
std_msgs/Header header
bool success         # True if the biometric authentication passed
uint8 user_id        # (Optional) Map biometric data to specific user profiles
```

## 🛠️ Best Practices & Usage

* **Event-Driven Publishing:** Do not publish these messages at a fixed frequency (e.g., 60Hz). To save network bandwidth and battery, publishers should only send `TouchArray` messages on hardware interrupts (e.g., `ACTION_DOWN`, `ACTION_MOVE`, `ACTION_UP`).
* **Translation Nodes:** Do not put robot-specific logic (like virtual joysticks) directly into the phone app. The mobile app should publish these raw generic messages, and a separate node on the robot should subscribe to `TouchArray` and translate the coordinates into standard `sensor_msgs/Joy` or `geometry_msgs/Twist` commands.
* **Standard Sensors:** For standard mobile sensors like Accelerometers, Gyroscopes, and GPS, continue to use standard ROS 2 interfaces (`sensor_msgs/Imu`, `sensor_msgs/NavSatFix`) instead of this package.

## 🏗️ Building

Clone this repository into your ROS 2 workspace's `src` directory and build using `colcon`:

```bash
cd ~/ros2_ws
colcon build --packages-select mobile_sensor_msgs
source install/setup.bash
```

Verify the messages are available in your environment:
```bash
ros2 interface show mobile_sensor_msgs/msg/TouchArray
```