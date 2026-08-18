import 'package:flutter/material.dart';
import '../theme/pulse_colors.dart';

/// PLACEHOLDER brand mark.
///
/// Replace `assets/branding/pulse_logo.png` (+ _light/_dark variants) with
/// the official supplied PULSE logo, then swap this widget's body for an
/// Image.asset of that file. Keeping a code-drawn placeholder here means
/// the app builds and looks intentional even before the real asset lands.
class PulseLogo extends StatelessWidget {
  final double size;
  const PulseLogo({super.key, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: PulseColors.brandGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.5, size * 0.5),
          painter: _PulseWavePainter(),
        ),
      ),
    );
  }
}

class _PulseWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.height * 0.16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final h = size.height;
    final w = size.width;
    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.25, h * 0.5);
    path.lineTo(w * 0.4, 0);
    path.lineTo(w * 0.6, h);
    path.lineTo(w * 0.75, h * 0.5);
    path.lineTo(w, h * 0.5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
