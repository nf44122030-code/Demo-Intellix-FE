import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController1;
  late AnimationController _rotationController2;
  late AnimationController _rotationController3;
  late AnimationController _glowController;
  late AnimationController _shimmerController;
  late AnimationController _fadeController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Scale animation for the main circle
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Rotation animations for the gradient layers
    _rotationController1 = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _rotationController2 = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _rotationController3 = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    // Glow pulsing animation
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Shimmer animation
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Fade out controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create animations
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeIn),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.5).animate(_glowController);

    // Start animations
    _scaleController.forward();

    // Navigate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        _fadeController.forward().then((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController1.dispose();
    _rotationController2.dispose();
    _rotationController3.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A1929), Color(0xFF0A1929)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                ),
        ),
        child: Stack(
          children: [
            // Main Content
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: 320,
                    height: 320,
                    child: Stack(
                      children: [
                        // Outer glow
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? const Color(0xFF0EA5E9).withOpacity(_glowAnimation.value)
                                        : const Color(0xFF0284C7).withOpacity(_glowAnimation.value),
                                    blurRadius: 120,
                                    spreadRadius: 20,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // Layer 1: Rotating radial gradient
                        AnimatedBuilder(
                          animation: _rotationController1,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationController1.value * 2 * math.pi,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.4, -0.4),
                                    colors: isDarkMode
                                        ? [
                                            const Color(0xFF38BDF8).withOpacity(0.9),
                                            const Color(0xFF0EA5E9).withOpacity(0.8),
                                            const Color(0xFF0284C7).withOpacity(0.7),
                                            const Color(0xFF06B6D4).withOpacity(0.8),
                                            const Color(0xFF38BDF8).withOpacity(0.6),
                                          ]
                                        : [
                                            const Color(0xFFBAE6FD).withOpacity(0.9),
                                            const Color(0xFF0EA5E9).withOpacity(0.8),
                                            const Color(0xFF0284C7).withOpacity(0.7),
                                            const Color(0xFF06B6D4).withOpacity(0.8),
                                            const Color(0xFF38BDF8).withOpacity(0.6),
                                          ],
                                    stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Layer 2: Counter-rotating conic gradient
                        AnimatedBuilder(
                          animation: _rotationController2,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: -_rotationController2.value * 2 * math.pi,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    colors: isDarkMode
                                        ? [
                                            const Color(0xFF06B6D4).withOpacity(0.8),
                                            const Color(0xFF0EA5E9).withOpacity(0.7),
                                            const Color(0xFF0284C7).withOpacity(0.8),
                                            const Color(0xFF38BDF8).withOpacity(0.7),
                                            const Color(0xFF06B6D4).withOpacity(0.8),
                                          ]
                                        : [
                                            const Color(0xFF06B6D4).withOpacity(0.8),
                                            const Color(0xFF0EA5E9).withOpacity(0.7),
                                            const Color(0xFF0284C7).withOpacity(0.8),
                                            const Color(0xFF38BDF8).withOpacity(0.7),
                                            const Color(0xFF06B6D4).withOpacity(0.8),
                                          ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Layer 3: Shimmer/highlight effect
                        AnimatedBuilder(
                          animation: _rotationController3,
                          builder: (context, child) {
                            return AnimatedBuilder(
                              animation: _shimmerController,
                              builder: (context, child) {
                                final scale = 1.0 + (_shimmerController.value * 0.1);
                                return Transform.scale(
                                  scale: scale,
                                  child: Transform.rotate(
                                    angle: _rotationController3.value * 2 * math.pi,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          center: const Alignment(0.7, 0.7),
                                          colors: [
                                            Colors.white.withOpacity(0.5),
                                            const Color(0xFFBAE6FD).withOpacity(0.6),
                                            const Color(0xFF0EA5E9).withOpacity(0.4),
                                            Colors.transparent,
                                          ],
                                          stops: const [0.0, 0.2, 0.4, 0.7],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // Glossy highlight
                        Positioned(
                          top: 48,
                          left: 64,
                          child: AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, child) {
                              final offset = _shimmerController.value * 20;
                              final opacity = 0.5 + (_shimmerController.value * 0.2);
                              return Transform.translate(
                                offset: Offset(offset, -offset / 2),
                                child: Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withOpacity(opacity),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Center text
                        Center(
                          child: FadeTransition(
                            opacity: _textFadeAnimation,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'INTELLIX',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 20,
                                  shadows: [
                                    Shadow(
                                      color: isDarkMode
                                          ? const Color(0xFF0284C7).withOpacity(0.4)
                                          : const Color(0xFF0284C7).withOpacity(0.4),
                                      blurRadius: 20,
                                    ),
                                    Shadow(
                                      color: isDarkMode
                                          ? const Color(0xFF06B6D4).withOpacity(0.3)
                                          : const Color(0xFF06B6D4).withOpacity(0.3),
                                      blurRadius: 40,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Fade out overlay
            AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return IgnorePointer(
                  child: Container(
                    color: isDarkMode
                        ? const Color(0xFF0A1929).withOpacity(_fadeController.value)
                        : const Color(0xFFF0F9FF).withOpacity(_fadeController.value),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
