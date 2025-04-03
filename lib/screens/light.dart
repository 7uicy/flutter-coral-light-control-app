import 'package:flutter/material.dart';
import 'package:my_coral_light/models/light_modes.dart';
import 'package:provider/provider.dart';
import 'package:my_coral_light/models/ble_provider.dart';
import 'package:my_coral_light/slider/circular_slider.dart';
import 'package:my_coral_light/slider/vertical_slider/vertical_slider_painter.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LightScreenState createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen>
    with AutomaticKeepAliveClientMixin {
  double globalBrightness = 100.0;
  int defaultIconState = 0;
  int fullSpecIconState = 0;
  int fluoresceneIconState = 0;
  int sunsetSunriseIconState = 0;
  int customIconState = 0;
  String modeName = ' ';

  List<double> originalBrightnessValues = [
    100.0, // Cool White
    100.0, // UV
    100.0, // Violet
    100.0, // Royal Blue
    100.0, // Blue
    100.0, // Green
    100.0, // Yellow
    100.0 // Photo Red
  ];

  List<double> sendBrightnessValues = [
    100.0, // Cool White
    100.0, // UV
    100.0, // Violet
    100.0, // Royal Blue
    100.0, // Blue
    100.0, // Green
    100.0, // Yellow
    100.0 // Photo Red
  ];

  void updateGlobalBrightness(double percent) {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);
    globalBrightness = percent;

    if (bleProvider.device != null) {
      for (int i = 0; i < sendBrightnessValues.length; i++) {
        sendBrightnessValues[i] =
            (originalBrightnessValues[i] * percent / 100).clamp(0, 100);
        bleProvider.sendBrightness(i, sendBrightnessValues[i]);
      }
    }
  }

  void updateSigleBrightness(int ledIdex, double percent) {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);

    setState(() {
      defaultIconState = 0;
      fullSpecIconState = 0;
      fluoresceneIconState = 0;
      sunsetSunriseIconState = 0;
      customIconState = 1;
      modeName = 'Custom';
    });
    originalBrightnessValues[ledIdex] = percent;
    sendBrightnessValues[ledIdex] =
        (originalBrightnessValues[ledIdex] * globalBrightness / 100)
            .clamp(0, 100);
    bleProvider.sendBrightness(ledIdex, sendBrightnessValues[ledIdex]);
  }

  void setDefault() {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);
    List<double> baseBrightness = [
      0.0, // Cool White
      100.0, // UV
      100.0, // Violet
      100.0, // Royal Blue
      100.0, // Blue
      0.0, // Green
      0.0, // Yellow
      0.0 // Photo Red
    ];

    setState(() {
      defaultIconState = 1;
      fullSpecIconState = 0;
      fluoresceneIconState = 0;
      sunsetSunriseIconState = 0;
      customIconState = 0;
      modeName = 'Default';
    });
    // Adjust LEDs relative to the current global brightness
    for (int i = 0; i < sendBrightnessValues.length; i++) {
      originalBrightnessValues[i] = baseBrightness[i];
      sendBrightnessValues[i] = baseBrightness[i] * (globalBrightness / 100);
      bleProvider.sendBrightness(
          i, sendBrightnessValues[i]); // Send updated brightness
    }
  }

  void setFullSpectrum() {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);
    List<double> baseBrightness = [
      20.0, // Cool White
      80.0, // UV
      80.0, // Violet
      80.0, // Royal Blue
      80.0, // Blue
      5.0, // Green
      5.0, // Yellow
      5.0 // Photo Red
    ];

    setState(() {
      defaultIconState = 0;
      fullSpecIconState = 1;
      fluoresceneIconState = 0;
      sunsetSunriseIconState = 0;
      customIconState = 0;
      modeName = 'Full Spectrum';
    });
    // Adjust LEDs relative to the current global brightness
    for (int i = 0; i < sendBrightnessValues.length; i++) {
      originalBrightnessValues[i] = baseBrightness[i];
      sendBrightnessValues[i] = baseBrightness[i] * (globalBrightness / 100);
      bleProvider.sendBrightness(
          i, sendBrightnessValues[i]); // Send updated brightness
    }
  }

  void setFluorescene() {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);
    List<double> baseBrightness = [
      5.0, // Cool White
      100.0, // UV
      100.0, // Violet
      100.0, // Royal Blue
      100.0, // Blue
      5.0, // Green
      5.0, // Yellow
      5.0 // Photo Red
    ];

    setState(() {
      defaultIconState = 0;
      fullSpecIconState = 0;
      fluoresceneIconState = 1;
      sunsetSunriseIconState = 0;
      customIconState = 0;
      modeName = 'Fluorescene';
    });
    // Adjust LEDs relative to the current global brightness
    for (int i = 0; i < sendBrightnessValues.length; i++) {
      originalBrightnessValues[i] = baseBrightness[i];
      sendBrightnessValues[i] = baseBrightness[i] * (globalBrightness / 100);
      bleProvider.sendBrightness(
          i, sendBrightnessValues[i]); // Send updated brightness
    }
  }

  void setSunsetSunrise() {
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);
    List<double> baseBrightness = [
      20.0, // Cool White
      60.0, // UV
      60.0, // Violet
      60.0, // Royal Blue
      60.0, // Blue
      10.0, // Green
      10.0, // Yellow
      10.0 // Photo Red
    ];

    setState(() {
      defaultIconState = 0;
      fullSpecIconState = 0;
      fluoresceneIconState = 0;
      sunsetSunriseIconState = 1;
      customIconState = 0;
      modeName = 'Sunset/Sunrise';
    });
    // Adjust LEDs relative to the current global brightness
    for (int i = 0; i < sendBrightnessValues.length; i++) {
      originalBrightnessValues[i] = baseBrightness[i];
      sendBrightnessValues[i] = baseBrightness[i] * (globalBrightness / 100);
      bleProvider.sendBrightness(
          i, sendBrightnessValues[i]); // Send updated brightness
    }
  }

  @override
  void initState() {
    super.initState();
    final bleProvider = Provider.of<BLEProvider>(context, listen: false);

    // Listen for changes in connection status
    bleProvider.addListener(() {
      if (bleProvider.status) {
        setDefault(); // Call when connected
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 0,
            ),
            Container(
              width: 400,
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  color: Color.fromARGB(255, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Light Mode',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Choose: $modeName',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LightModeButton(
                            icon: Icons.water,
                            label: "Default",
                            onTap: setDefault,
                            isSelected: defaultIconState == 0),
                        LightModeButton(
                            icon: Icons.light,
                            label: "Full Spectrum",
                            onTap: setFullSpectrum,
                            isSelected: fullSpecIconState == 0),
                        LightModeButton(
                            icon: Icons.fluorescent_outlined,
                            label: "Fulorescene",
                            onTap: setFluorescene,
                            isSelected: fluoresceneIconState == 0),
                        LightModeButton(
                            icon: Icons.sunny_snowing,
                            label: "Sunset/Sunrise",
                            onTap: setSunsetSunrise,
                            isSelected: sunsetSunriseIconState == 0)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: 350,
                height: 480,
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  children: [
                    buildCircularSlider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildVerticalSlider(
                            0,
                            'White',
                            const Color.fromARGB(255, 255, 255, 255),
                            const Color.fromARGB(221, 205, 203, 203)),
                        buildVerticalSlider(
                            1,
                            'UV',
                            const Color.fromARGB(255, 234, 133, 237),
                            const Color.fromARGB(255, 155, 39, 176)),
                        buildVerticalSlider(
                            2,
                            'Violet',
                            const Color.fromARGB(255, 240, 160, 219),
                            const Color.fromARGB(255, 228, 6, 172)),
                        buildVerticalSlider(
                            3,
                            'Royal',
                            const Color.fromARGB(255, 63, 81, 181),
                            const Color.fromARGB(255, 7, 13, 124)),
                        buildVerticalSlider(
                            4,
                            'Blue',
                            const Color.fromARGB(255, 110, 203, 240),
                            const Color.fromARGB(199, 39, 96, 195)),
                        buildVerticalSlider(
                            5,
                            'Green',
                            const Color.fromARGB(198, 46, 226, 52),
                            const Color.fromARGB(255, 4, 101, 23)),
                        buildVerticalSlider(
                            6,
                            'Yellow',
                            const Color.fromARGB(255, 241, 228, 82),
                            const Color.fromARGB(255, 238, 165, 20)),
                        buildVerticalSlider(
                            7,
                            'Red',
                            const Color.fromARGB(255, 225, 131, 131),
                            const Color.fromARGB(255, 214, 23, 23))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        backgroundColor: Color.fromARGB(255, 242, 238, 238),
      ),
    );
  }

  Widget buildVerticalSlider(
      int ledIndex, String label, Color firstColor, Color secondColor) {
    final double sliderWidth = 25;
    final double sliderHeight = 140;
    return StatefulBuilder(builder: (context, setState) {
      return Column(
        children: [
          RotatedBox(
            quarterTurns: -1,
            child: SizedBox(
              width: sliderHeight,
              height: sliderWidth,
              child: VerticalSliderPainter(
                trackHeight: sliderWidth,
                label: label,
                value: originalBrightnessValues[ledIndex],
                onChanged: (value) {
                  setState(() {
                    originalBrightnessValues[ledIndex] = value;
                  });
                },
                onChangedEnd: (value) {
                  setState(() {
                    sendBrightnessValues[ledIndex] = value;
                  });
                  updateSigleBrightness(ledIndex, value);
                },
                gradientColors: [firstColor, secondColor],
              ),
            ),
          ),
          Text(
            '${originalBrightnessValues[ledIndex].toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 10),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10),
          ),
        ],
      );
    });
  }

  Widget buildCircularSlider() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Expanded(
          child: CircularSlider(
              value: globalBrightness,
              onChanged: (percentage) {
                setState(() {
                  globalBrightness = percentage;
                });
                updateGlobalBrightness(globalBrightness);
              }),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
