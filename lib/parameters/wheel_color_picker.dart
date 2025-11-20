import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class WheelColorPicker extends StatefulWidget {
  final String? initialColorString;
  final ValueChanged<String> onColorSelected;
  final double size;

  const WheelColorPicker({
    super.key,
    this.initialColorString,
    required this.onColorSelected,
    this.size = 260,
  });

  @override
  State<WheelColorPicker> createState() => _WheelColorPickerState();
}

class _WheelColorPickerState extends State<WheelColorPicker> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();

    if (widget.initialColorString != null) {
      selectedColor = Color(int.parse(widget.initialColorString!, radix: 16));
    } else {
      selectedColor = Colors.red;
    }
  }

  void _handleTouch(Offset localPos) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;

    final distance = sqrt(dx * dx + dy * dy);
    final radius = widget.size / 2;

    if (distance > radius) return; // outside circle

    // angle → hue
    double hue = (atan2(dy, dx) * 180 / pi) % 360;
    if (hue < 0) hue += 360;

    // distance → saturation
    double saturation = (distance / radius).clamp(0, 1);

    // value always max for full color wheel
    double value = 1.0;

    final color = HSVColor.fromAHSV(1, hue, saturation, value).toColor();

    setState(() => selectedColor = color);

    widget.onColorSelected(
      color.value.toRadixString(16).toUpperCase(), // return string
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (d) => _handleTouch(d.localPosition),
      onPanUpdate: (d) => _handleTouch(d.localPosition),
      child: CustomPaint(
        painter: _ColorWheelPainter(selectedColor),
        size: Size(widget.size, widget.size),
      ),
    );
  }
}

class _ColorWheelPainter extends CustomPainter {
  final Color pointerColor;

  _ColorWheelPainter(this.pointerColor);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final rect = Rect.fromCircle(center: center, radius: radius);

    final sweepGradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      colors: [
        Colors.red,
        Colors.yellow,
        Colors.green,
        Colors.cyan,
        Colors.blue,
        Colors.red,
      ],
    );

    final radialGradient = RadialGradient(
      colors: [Colors.white, Colors.transparent],
    );

    // Draw hue circle
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = sweepGradient.createShader(rect),
    );

    // Blend saturation from center
    canvas.drawCircle(
      center,
      radius,
      Paint()..shader = radialGradient.createShader(rect),
    );

    // Draw selection point
    final hsv = HSVColor.fromColor(pointerColor);
    final angle = hsv.hue * pi / 180;
    final dist = hsv.saturation * radius;

    final pointerOffset = Offset(
      center.dx + cos(angle) * dist,
      center.dy + sin(angle) * dist,
    );

    canvas.drawCircle(
      pointerOffset,
      10,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
