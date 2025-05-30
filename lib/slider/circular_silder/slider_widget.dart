import 'package:flutter/material.dart';
import 'package:my_coral_light/slider/circular_silder/utils.dart';
import 'package:my_coral_light/slider/circular_silder/custom_arc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SliderWidget extends StatefulWidget {
  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double progressVal = 0.5;
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
                Color.fromARGB(255, 229, 51, 11),
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
                      color: Color.fromARGB(255, 229, 51, 11).withAlpha(
                          normalize(progressVal * 20000, 100, 255).toInt()),
                      offset: Offset(1, 3))
                ]),
            child: SleekCircularSlider(
              min: kMinDegree,
              max: kMaxDegree,
              initialValue: 50,
              appearance: CircularSliderAppearance(
                startAngle: 180,
                angleRange: 180,
                size: kDiameter - 30,
                customWidths: CustomSliderWidths(
                  trackWidth: 01,
                  shadowWidth: 0,
                  progressBarWidth: 01,
                  handlerSize: 10,
                ),
                customColors: CustomSliderColors(
                  hideShadow: true,
                  progressBarColor: Colors.transparent,
                  trackColor: Colors.transparent,
                  dotColor: const Color.fromARGB(255, 229, 51, 11),
                ),
              ),
              onChange: (value) {
                setState(() {
                  progressVal = normalize(value, kMinDegree, kMaxDegree);
                });
              },
              innerWidget: (percentage) {
                return Center(
                  child: Text(
                    '${percentage.toInt()}',
                    style: TextStyle(
                      fontSize: 35,
                    ),
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
