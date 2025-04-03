import 'package:flutter/material.dart';

class GradientSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  final List<Color> gradientColors;
  final Color inactiveColor;

  GradientSliderTrackShape(
      {required this.gradientColors, required this.inactiveColor});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 4.0;
    final double trackRadius = trackHeight / 2;
    final double trackWidth = parentBox.size.width;

    final double activeWidth = thumbCenter.dx - offset.dx;

    // Full track rectangle (inactive track)
    final Rect inactiveTrackRect = Rect.fromPoints(
      Offset(offset.dx, thumbCenter.dy - trackHeight / 2),
      Offset(trackWidth + offset.dx, thumbCenter.dy + trackHeight / 2),
    );

    // Active track rectangle (gradient track)
    final Rect activeTrackRect = Rect.fromPoints(
      Offset(offset.dx, thumbCenter.dy - trackHeight / 2),
      Offset(activeWidth + offset.dx, thumbCenter.dy + trackHeight / 2),
    );

    final Paint inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    final Paint activePaint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(activeTrackRect)
      ..style = PaintingStyle.fill;

    // Draw inactive track
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(inactiveTrackRect, Radius.circular(trackRadius)),
      inactivePaint,
    );

    // Draw active gradient track
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(activeTrackRect, Radius.circular(trackRadius)),
      activePaint,
    );
  }
}
