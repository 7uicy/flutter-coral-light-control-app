import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEProvider extends ChangeNotifier {
  BluetoothDevice? device;
  BluetoothCharacteristic? brightnessCharacteristic;
  bool status = false;

  void setDevice(BluetoothDevice newDevice) {
    device = newDevice;
    notifyListeners();
  }

  void setBrightnessCharacteristic(BluetoothCharacteristic characteristic) {
    brightnessCharacteristic = characteristic;
    notifyListeners();
  }

  void setConnectionStatus(bool connectionStatus) {
    status = connectionStatus;
    notifyListeners();
  }

  Future<void> sendBrightness(int ledIndex, double percent) async {
    try {
      if (brightnessCharacteristic != null) {
        int brightnessValue = ((percent / 100) * 255)
            .toInt(); // Convert brightness to a single byte
        List<int> data = [ledIndex, brightnessValue];
        await brightnessCharacteristic!.write(data);
        print("Sent $ledIndex: $brightnessValue (from ${percent.toInt()}%)");
        print(data);
      } else {
        print("Characteristic not found!");
      }
    } catch (e) {
      print(device);
      print("Characteristic error");
    }
  }
}
