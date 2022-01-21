import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgressWidget extends StatelessWidget {
  const CircleProgressWidget({
    Key? key,
    required this.child,
    required this.percent,
    required this.lineColor,
    this.padding = 0,
    this.lineWidth = 2,
  }) : super(key: key);

  final Widget child;
  final double percent;
  final Color lineColor;
  final double padding;
  final double lineWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      // fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: CustomPaint(
            painter: CirclePainter(
              percent: percent,
              padding: padding,
              lineColor: lineColor,
              lineWidth: lineWidth,
            ),
            child: Padding(padding: EdgeInsets.all(padding), child: Center(child: child)),
          ),
        ),
      ],
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.percent,
    required this.lineColor,
    required this.padding,
    required this.lineWidth,
  });

  final double percent;
  final Color lineColor;
  final double padding;
  final double lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final arcRect = calculateArcRect(size);
    drawBackgroundLine(canvas, arcRect);
    drawLine(canvas, arcRect);
  }

  Rect calculateArcRect(Size size) {
    final offset = lineWidth / 2 + padding;
    final arcOffset = Offset(offset, offset);
    final arcSize = Size(size.width - offset * 2, size.height - offset * 2);
    final arcRect = arcOffset & arcSize;
    return arcRect;
  }

  void drawLine(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = lineColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineWidth;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      pi / 2,
      2 * pi * percent,
      false,
      paint,
    );
  }

  void drawBackgroundLine(Canvas canvas, Rect arcRect) {
    final paint = Paint();
    paint.color = lineColor.withOpacity(0.1);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = lineWidth;
    paint.isAntiAlias = true;
    paint.strokeCap = StrokeCap.round;

    canvas.drawArc(
      arcRect,
      pi / 2,
      2 * pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
