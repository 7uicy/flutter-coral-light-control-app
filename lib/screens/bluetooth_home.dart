import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:my_coral_light/models/ble_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothHome extends StatefulWidget {
  const BluetoothHome({super.key});

  @override
  State<BluetoothHome> createState() => _BluetoothHomeState();
}

class _BluetoothHomeState extends State<BluetoothHome>
    with AutomaticKeepAliveClientMixin {
  BluetoothDevice? selectedDevice;
  BluetoothCharacteristic? characteristic;
  bool connectionStatus = false;
  StreamSubscription<BluetoothConnectionState>? streamSubscription;

  Future<void> connectToDevice(BluetoothDevice device) async {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);
    try {
      await device.connect();
      print("Connected to ${device.platformName}");

      // Store device in provider
      bleProvider.setDevice(device);

      // Listen to connection state changes
      streamSubscription = device.connectionState.listen((event) async {
        setState(() {
          connectionStatus = event == BluetoothConnectionState.connected;
          bleProvider.setConnectionStatus(connectionStatus);
        });

        if (event == BluetoothConnectionState.connected) {
          print("Device Connected");
          Navigator.pop(context);
        }

        if (event == BluetoothConnectionState.disconnected) {
          print("Device Disconnected");
          await streamSubscription?.cancel();
        }
      });

      // Discover services
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        for (var char in service.characteristics) {
          if (char.uuid.toString() == "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
            // Store characteristic in provider
            bleProvider.setBrightnessCharacteristic(char);
            print("Found LED brightness characteristic!");
          }
        }
      }
    } catch (e) {
      print("Connection failed: $e");
    }
  }

  Future<void> toggleConnection(BluetoothDevice device) async {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);
    try {
      await device.disconnect();

      // Store device in provider
      bleProvider.setDevice(device);

      // Listen to connection state changes
      streamSubscription = device.connectionState.listen((event) async {
        setState(() {
          connectionStatus = event == BluetoothConnectionState.connected;
          bleProvider.setConnectionStatus(connectionStatus);
        });

        if (event == BluetoothConnectionState.disconnected) {
          print("Device Disconnected");
          await streamSubscription?.cancel();
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bleProvider = Provider.of<BLEProvider>(context);
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        backgroundColor: const Color.fromARGB(255, 242, 238, 238),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Find Device',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Container(
              width: 350,
              height: 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 0),
                        StreamBuilder<List<BluetoothDevice>>(
                          stream: Stream.periodic(const Duration(seconds: 2))
                              .asyncMap((_) async =>
                                  FlutterBluePlus.systemDevices([])),
                          initialData: const [],
                          builder: (context, snapshot) {
                            return Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: snapshot.data!.map((d) {
                                  return Card(
                                    color: Colors.white,
                                    elevation: 1,
                                    child: ListTile(
                                      title: Text(d.platformName),
                                      leading: Icon(Icons.devices),
                                      trailing: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.white),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                                    Colors.black)),
                                        onPressed: () => toggleConnection(d),
                                        child: Text(bleProvider.device != null
                                            ? 'Connected'
                                            : 'Connect'),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                        StreamBuilder<List<ScanResult>>(
                            stream: FlutterBluePlus.scanResults,
                            initialData: const [],
                            builder: (context, snapshot) {
                              List<ScanResult> scanresults = snapshot.data!;
                              List<ScanResult> templist = scanresults
                                  .where((element) =>
                                      element.device.platformName != "")
                                  .toList();
                              return Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                      itemCount: templist.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Card(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              elevation: 1,
                                              child: ListTile(
                                                title: Text(templist[index]
                                                    .device
                                                    .platformName),
                                                leading: Icon(Icons.devices),
                                                trailing: ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.white),
                                                      foregroundColor:
                                                          WidgetStatePropertyAll(
                                                              Colors.black),
                                                    ),
                                                    onPressed: () {
                                                      connectToDevice(
                                                          templist[index]
                                                              .device);
                                                    },
                                                    child: Text('Connect')),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        );
                                      }),
                                ),
                              );
                            }),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBluePlus.isScanning,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 228, 36, 42),
                onPressed: () => FlutterBluePlus.stopScan(),
                child: const Icon(
                  Icons.stop,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              );
            } else {
              return FloatingActionButton(
                backgroundColor: Color.fromARGB(255, 228, 36, 42),
                onPressed: () => FlutterBluePlus.startScan(
                    timeout: const Duration(seconds: 5)),
                child: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              );
            }
          }),
      backgroundColor: const Color.fromARGB(255, 242, 238, 238),
    );
  }

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
