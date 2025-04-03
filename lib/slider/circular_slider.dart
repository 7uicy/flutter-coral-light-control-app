import 'package:flutter/material.dart';
import 'package:my_coral_light/slider/circular_silder/utils.dart';
import 'package:my_coral_light/slider/circular_silder/custom_arc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircularSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CircularSlider(
      {super.key, required this.value, required this.onChanged});

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  double progressVal = 1.0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return SweepGradient(
              startAngle: degToRad(0),
              endAngle: degToRad(184),
              colors: [
                Color.fromARGB(255, 228, 36, 42),
                Colors.grey.withAlpha(50)
              ],
              stops: [progressVal, progressVal],
              transform: GradientRotation(
                degToRad(178),
              ),
            ).createShader(rect);
          },
          child: Center(child: CustomArc()),
        ),
        Center(
          child: Container(
            width: kDiameter - 30,
            height: kDiameter - 30,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 20,
                  style: BorderStyle.solid,
                ),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 30,
                      spreadRadius: 10,
                      color: Color.fromARGB(255, 228, 36, 42).withAlpha(
                          normalize(progressVal * 20000, 100, 255).toInt()),
                      offset: Offset(1, 3))
                ]),
            child: SleekCircularSlider(
              min: kMinDegree,
              max: kMaxDegree,
              initialValue: widget.value,
              appearance: CircularSliderAppearance(
                startAngle: 180,
                angleRange: 180,
                size: kDiameter - 30,
                customWidths: CustomSliderWidths(
                  trackWidth: 10,
                  shadowWidth: 0,
                  progressBarWidth: 2,
                  handlerSize: 11,
                ),
                customColors: CustomSliderColors(
                  hideShadow: true,
                  progressBarColor: const Color.fromARGB(0, 0, 0, 0),
                  trackColor: const Color.fromARGB(0, 0, 0, 0),
                  dotColor: const Color.fromARGB(255, 228, 36, 42),
                ),
              ),
              onChange: (percentage) {
                setState(() {
                  progressVal = normalize(percentage, kMinDegree, kMaxDegree);
                });
              },
              onChangeEnd: widget.onChanged,
              innerWidget: (percentage) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${percentage.toInt()}%',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'All',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
