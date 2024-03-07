import 'dart:math';

import 'package:flutter/material.dart';

class RadialProgressPainter extends CustomPainter {
  final Color progressColor;
  final startAngle = 4/5*pi;
  final maxSweepAngle = 7/5*pi;
  final double progress; // 0.0 -> 1.0

  RadialProgressPainter({required this.progressColor, required this.progress});

  Paint _createBasePaint() {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
  }

  double _calculateProgressSweepAngle() {
    final angle = maxSweepAngle*progress;
    if (angle > maxSweepAngle) {
      return maxSweepAngle;
    }
    return angle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final boundingRect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    final backgroundPaint = _createBasePaint()
      ..color = Colors.black12;

    final progressPaint = _createBasePaint()
      ..color = progressColor;

    canvas.drawArc(boundingRect, startAngle,  maxSweepAngle, false, backgroundPaint);
    canvas.drawArc(boundingRect, startAngle, _calculateProgressSweepAngle(), false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}


class MainBudgetChart extends StatelessWidget {
  final double maxBudget;
  final double currentExpenses;
  const MainBudgetChart({super.key, required this.maxBudget, required this.currentExpenses});
  // TODO: add support for percentages


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CustomPaint(
            painter: RadialProgressPainter(
              progressColor: theme.primaryColor,
              progress: currentExpenses / maxBudget,
            ),
            size: Size(constraints.maxWidth * 2/3, constraints.maxWidth * 2/3),
          ),
        );
      },
    );
  }
}
