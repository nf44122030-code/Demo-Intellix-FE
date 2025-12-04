import 'package:flutter/material.dart';
import 'dart:math' as math;

class GlowingPill3D extends StatefulWidget {
  final bool isDarkMode;

  const GlowingPill3D({super.key, required this.isDarkMode});

  @override
  State<GlowingPill3D> createState() => _GlowingPill3DState();
}

class _GlowingPill3DState extends State<GlowingPill3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.85,
          child: SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: GlowingPillPainter(
                isDarkMode: widget.isDarkMode,
                animationValue: _controller.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class GlowingPillPainter extends CustomPainter {
  final bool isDarkMode;
  final double animationValue;

  GlowingPillPainter({required this.isDarkMode, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Bottom shadow/reflection
    _drawBottomShadow(canvas, size);

    // Outer circular glow
    _drawOuterGlow(canvas, size, center);

    // Main pill body
    _drawMainPill(canvas, size);
  }

  void _drawBottomShadow(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: isDarkMode
            ? [
                const Color(0xFF0369A1).withOpacity(0.25),
                const Color(0xFF0EA5E9).withOpacity(0.18),
                const Color(0xFF06B6D4).withOpacity(0.12),
                Colors.transparent,
              ]
            : [
                const Color(0xFF0284C7).withOpacity(0.25),
                const Color(0xFF0EA5E9).withOpacity(0.18),
                const Color(0xFF06B6D4).withOpacity(0.12),
                Colors.transparent,
              ],
        stops: const [0.0, 0.25, 0.5, 0.75],
      ).createShader(Rect.fromLTWH(
        size.width * 0.21,
        size.height * 0.86,
        size.width * 0.58,
        size.height * 0.22,
      ))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.21,
        size.height * 0.86,
        size.width * 0.58,
        size.height * 0.22,
      ),
      paint,
    );
  }

  void _drawOuterGlow(Canvas canvas, Size size, Offset center) {
    final glowRadius = size.width * 0.49;

    // Outer glow layers
    for (int i = 3; i >= 0; i--) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: isDarkMode
              ? [
                  const Color(0xFF06B6D4).withOpacity(0.6 - i * 0.1),
                  const Color(0xFF0EA5E9).withOpacity(0.5 - i * 0.1),
                  const Color(0xFF0369A1).withOpacity(0.4 - i * 0.1),
                  const Color(0xFF0284C7).withOpacity(0.3 - i * 0.1),
                  Colors.transparent,
                ]
              : [
                  const Color(0xFF06B6D4).withOpacity(0.7 - i * 0.1),
                  const Color(0xFF0EA5E9).withOpacity(0.6 - i * 0.1),
                  const Color(0xFF0284C7).withOpacity(0.5 - i * 0.1),
                  const Color(0xFF0369A1).withOpacity(0.4 - i * 0.1),
                  Colors.transparent,
                ],
        ).createShader(Rect.fromCircle(
          center: center,
          radius: glowRadius + i * 15,
        ))
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 18 + i * 5);

      canvas.drawCircle(center, glowRadius + i * 15, paint);
    }
  }

  void _drawMainPill(Canvas canvas, Size size) {
    final pillRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.265,
        size.height * 0.49,
        size.width * 0.47,
        size.height * 0.28,
      ),
      const Radius.circular(42.5),
    );

    // Main pill gradient
    final pillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDarkMode
            ? [
                const Color(0xFF0369A1),
                const Color(0xFF0284C7),
                const Color(0xFF0EA5E9),
                const Color(0xFF06B6D4),
                const Color(0xFF0891B2),
                const Color(0xFF0E7490),
                const Color(0xFF0369A1),
                const Color(0xFF075985),
              ]
            : [
                const Color(0xFF0EA5E9),
                const Color(0xFF06B6D4),
                const Color(0xFF0284C7),
                const Color(0xFF0369A1),
                const Color(0xFF075985),
                const Color(0xFF0891B2),
                const Color(0xFF06B6D4),
                const Color(0xFF0EA5E9),
              ],
      ).createShader(pillRect.outerRect);

    // Draw pill with multiple shadow layers
    final shadowPaint1 = Paint()
      ..color = isDarkMode
          ? const Color(0xFF0EA5E9).withOpacity(0.5)
          : const Color(0xFF06B6D4).withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);

    final shadowPaint2 = Paint()
      ..color = isDarkMode
          ? const Color(0xFF06B6D4).withOpacity(0.4)
          : const Color(0xFF0EA5E9).withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);

    canvas.drawRRect(pillRect.shift(const Offset(0, 15)), shadowPaint1);
    canvas.drawRRect(pillRect.shift(const Offset(0, 25)), shadowPaint2);
    canvas.drawRRect(pillRect, pillPaint);

    // Top highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDarkMode
            ? [
                const Color(0xFFE0F2FE).withOpacity(0.4),
                const Color(0xFFBAE6FD).withOpacity(0.25),
                const Color(0xFF7DD3FC).withOpacity(0.15),
                Colors.transparent,
              ]
            : [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.15),
                Colors.transparent,
              ],
        stops: const [0.0, 0.3, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(
        size.width * 0.31,
        size.height * 0.503,
        size.width * 0.37,
        size.height * 0.1,
      ))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.31,
          size.height * 0.503,
          size.width * 0.37,
          size.height * 0.1,
        ),
        const Radius.circular(30),
      ),
      highlightPaint,
    );

    // Draw eyes
    _drawEye(
      canvas,
      Offset(size.width * 0.32, size.height * 0.54),
      size.width * 0.074,
      size.height * 0.093,
    );

    _drawEye(
      canvas,
      Offset(size.width * 0.585, size.height * 0.54),
      size.width * 0.074,
      size.height * 0.093,
    );

    // Animated pulse effect
    _drawPulseEffect(canvas, size, pillRect);
  }

  void _drawEye(Canvas canvas, Offset center, double width, double height) {
    final eyeRect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    final eyePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.3),
        colors: isDarkMode
            ? [
                const Color(0xFFFFFFFF).withOpacity(0.9),
                const Color(0xFFE0F2FE).withOpacity(0.85),
                const Color(0xFFBAE6FD).withOpacity(0.8),
                const Color(0xFF7DD3FC).withOpacity(0.75),
              ]
            : [
                const Color(0xFFFFFFFF),
                const Color(0xFFFEFEFE).withOpacity(0.95),
                const Color(0xFFF0F9FF).withOpacity(0.9),
                const Color(0xFFE0F2FE).withOpacity(0.85),
              ],
      ).createShader(eyeRect);

    // Eye shadow
    final eyeShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawOval(eyeRect.shift(const Offset(0, 2)), eyeShadowPaint);
    canvas.drawOval(eyeRect, eyePaint);

    // Eye highlight
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.5),
        colors: [
          Colors.white.withOpacity(0.9),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCenter(
        center: center + const Offset(-width * 0.2, -height * 0.2),
        width: width * 0.6,
        height: height * 0.6,
      ));

    canvas.drawOval(
      Rect.fromCenter(
        center: center + const Offset(-width * 0.2, -height * 0.2),
        width: width * 0.4,
        height: height * 0.4,
      ),
      highlightPaint,
    );
  }

  void _drawPulseEffect(Canvas canvas, Size size, RRect pillRect) {
    final pulsePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          isDarkMode
              ? const Color(0xFF0EA5E9).withOpacity(0.3 * (1 - animationValue))
              : const Color(0xFF06B6D4).withOpacity(0.3 * (1 - animationValue)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height * 0.63),
        radius: 100 + (animationValue * 50),
      ))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.63),
      100 + (animationValue * 50),
      pulsePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GlowingPillPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
