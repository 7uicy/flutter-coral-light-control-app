import 'package:flutter/material.dart';
import 'package:my_coral_light/models/ble_provider.dart';
import 'package:my_coral_light/screens/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestBluetoothPermissions();
  runApp(
    ChangeNotifierProvider(
      create: (context) => BLEProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyApp",
      //theme: ThemeData(primaryColor: Colors.transparent),
      home: HomeScreen(),
    );
  }
}

Future<void> requestBluetoothPermissions() async {
  if (await Permission.bluetoothScan.request().isDenied ||
      await Permission.bluetoothConnect.request().isDenied ||
      await Permission.locationWhenInUse.request().isDenied) {
    print("Bluetooth permissions denied!");
  }
}
