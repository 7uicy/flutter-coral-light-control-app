import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_coral_light/models/ble_provider.dart';
import 'package:my_coral_light/screens/light.dart';
import 'package:my_coral_light/screens/bluetooth_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final bleProvider = Provider.of<BLEProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            bleProvider.status
                ? (bleProvider.device != null
                    ? bleProvider.device!.platformName
                    : " ")
                : " ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color.fromARGB(85, 239, 234, 234),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BluetoothHome()));
                  },
                  icon: Icon(
                    bleProvider.status
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth_disabled,
                    size: 22,
                    color: bleProvider.status
                        ? const Color.fromARGB(205, 44, 24, 158)
                        : const Color.fromARGB(255, 93, 93, 93),
                  )),
            ),
            SizedBox(
              width: 10,
            )
          ],
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          iconTheme:
              IconThemeData(color: const Color.fromARGB(255, 228, 36, 42)),
        ),
        body: LightScreen(),
        backgroundColor: const Color.fromARGB(255, 242, 238, 238));
  }
}
