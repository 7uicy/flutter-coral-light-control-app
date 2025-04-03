import 'package:flutter/material.dart';
import 'package:my_coral_light/slider/vertical_slider/gradient_slider_track_shape.dart';

class VerticalSliderPainter extends StatefulWidget {
  final double trackHeight;
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangedEnd;
  final List<Color> gradientColors;

  const VerticalSliderPainter({
    super.key,
    this.trackHeight = 60,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onChangedEnd,
    required this.gradientColors,
  });

  @override
  State<VerticalSliderPainter> createState() => _VerticalSliderPainterState();
}

class _VerticalSliderPainterState extends State<VerticalSliderPainter> {
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: widget.trackHeight,
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: SliderComponentShape.noThumb,
        trackShape: GradientSliderTrackShape(
            gradientColors: widget.gradientColors,
            inactiveColor: const Color.fromARGB(70, 223, 215, 215)),
      ),
      child: Slider(
        min: 0,
        max: 100,
        value: widget.value,
        onChanged: widget.onChanged,
        onChangeEnd: widget.onChangedEnd,
        thumbColor: Colors.white,
      ),
    );
  }
}
