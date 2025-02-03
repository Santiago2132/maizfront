import 'package:flutter/material.dart';

class HexagonBadge extends StatelessWidget {
  final String text;
  final bool isDarkMode;

  const HexagonBadge({
    required this.text,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HexagonPainter(isDarkMode: isDarkMode),
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final bool isDarkMode;

  HexagonPainter({required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? Colors.blueGrey : Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width, size.height * 0.25)
      ..lineTo(size.width, size.height * 0.75)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(0, size.height * 0.75)
      ..lineTo(0, size.height * 0.25)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
