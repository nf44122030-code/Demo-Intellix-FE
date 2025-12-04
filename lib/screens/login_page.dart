import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials')),
      );
    }
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
        child: Column(
          children: [
            // Top Gradient Header Section - Icy Blue Professional
            Container(
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                      )
                    : const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF0284C7), Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                      ),
              ),
              padding: const EdgeInsets.only(top: 40, bottom: 80, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'INTELLIX',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 14.4, // 0.3em equivalent
                    ),
                  ),
                ],
              ),
            ),

            // Curved Content Section
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF0A1929) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                transform: Matrix4.translationValues(0, -40, 0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(40, 48, 40, 32),
                  child: Column(
                    children: [
                      // Welcome Text with Gradient
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: isDarkMode
                              ? [const Color(0xFF0EA5E9), const Color(0xFF06B6D4)]
                              : [const Color(0xFF0369A1), const Color(0xFF0EA5E9)],
                        ).createShader(bounds),
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Login Form
                      Column(
                        children: [
                          // Username Input
                          _buildTextField(
                            controller: _usernameController,
                            hintText: 'Enter Username',
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 20),

                          // Password Input
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Enter Password',
                            isPassword: true,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 8),

                          // Login Button with Gradient
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: isDarkMode
                                  ? const LinearGradient(
                                      colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                                    ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? const Color(0xFF0EA5E9).withOpacity(0.3)
                                      : const Color(0xFF06B6D4).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Forgot Password
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Forget Password ?',
                              style: TextStyle(
                                color: isDarkMode
                                    ? const Color(0xFFD1D5DB)
                                    : const Color(0xFF0369A1),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // OR Divider
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: isDarkMode
                                      ? const Color(0xFF374151)
                                      : const Color(0xFFD1D5DB),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDarkMode
                                        ? const Color(0xFF9CA3AF)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: isDarkMode
                                      ? const Color(0xFF374151)
                                      : const Color(0xFFD1D5DB),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Social Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                child: _buildGoogleIcon(),
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 16),
                              _buildSocialButton(
                                child: Icon(
                                  Icons.facebook,
                                  color: const Color(0xFF1877F2),
                                  size: 24,
                                ),
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 16),
                              _buildSocialButton(
                                child: Icon(
                                  Icons.apple,
                                  color: isDarkMode ? Colors.white : const Color(0xFF111827),
                                  size: 24,
                                ),
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Bottom Registration Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not registered? ',
                            style: TextStyle(
                              color: isDarkMode
                                  ? const Color(0xFFD1D5DB)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: isDarkMode
                                    ? [const Color(0xFF0EA5E9), const Color(0xFF06B6D4)]
                                    : [const Color(0xFF0369A1), const Color(0xFF0EA5E9)],
                              ).createShader(bounds),
                              child: const Text(
                                'Create an account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDarkMode,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(
        color: isDarkMode ? Colors.white : const Color(0xFF374151),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDarkMode ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
        ),
        filled: true,
        fillColor: isDarkMode
            ? const Color(0xFF132F4C)
            : const Color(0xFFF0F9FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Color(0xFF0EA5E9),
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required Widget child,
    required bool isDarkMode,
  }) {
    return InkWell(
      onTap: () {
        // Handle social login
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF132F4C) : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFD1D5DB),
            width: 2,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: GoogleIconPainter(),
      ),
    );
  }
}

// Google Icon Painter
class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blue path
    paint.color = const Color(0xFF4285F4);
    final bluePath = Path();
    bluePath.moveTo(size.width * 0.94, size.height * 0.51);
    bluePath.lineTo(size.width * 0.94, size.height * 0.34);
    bluePath.cubicTo(
      size.width * 0.93, size.height * 0.28,
      size.width * 0.70, size.height * 0.20,
      size.width * 0.50, size.height * 0.20,
    );
    bluePath.lineTo(size.width * 0.50, size.height * 0.38);
    bluePath.lineTo(size.width * 0.74, size.height * 0.38);
    bluePath.cubicTo(
      size.width * 0.72, size.height * 0.44,
      size.width * 0.65, size.height * 0.49,
      size.width * 0.57, size.height * 0.52,
    );
    bluePath.close();
    canvas.drawPath(bluePath, paint);

    // Green path
    paint.color = const Color(0xFF34A853);
    final greenPath = Path();
    greenPath.moveTo(size.width * 0.50, size.height * 0.96);
    greenPath.cubicTo(
      size.width * 0.62, size.height * 0.96,
      size.width * 0.73, size.height * 0.92,
      size.width * 0.80, size.height * 0.85,
    );
    greenPath.lineTo(size.width * 0.65, size.height * 0.73);
    greenPath.cubicTo(
      size.width * 0.61, size.height * 0.76,
      size.width * 0.56, size.height * 0.77,
      size.width * 0.50, size.height * 0.77,
    );
    greenPath.cubicTo(
      size.width * 0.38, size.height * 0.77,
      size.width * 0.28, size.height * 0.69,
      size.width * 0.24, size.height * 0.58,
    );
    greenPath.lineTo(size.width * 0.09, size.height * 0.70);
    greenPath.cubicTo(
      size.width * 0.17, size.height * 0.86,
      size.width * 0.32, size.height * 0.96,
      size.width * 0.50, size.height * 0.96,
    );
    greenPath.close();
    canvas.drawPath(greenPath, paint);

    // Yellow path
    paint.color = const Color(0xFFFBBC05);
    final yellowPath = Path();
    yellowPath.moveTo(size.width * 0.24, size.height * 0.59);
    yellowPath.cubicTo(
      size.width * 0.23, size.height * 0.56,
      size.width * 0.23, size.height * 0.53,
      size.width * 0.23, size.height * 0.50,
    );
    yellowPath.cubicTo(
      size.width * 0.23, size.height * 0.47,
      size.width * 0.23, size.height * 0.44,
      size.width * 0.24, size.height * 0.41,
    );
    yellowPath.lineTo(size.width * 0.09, size.height * 0.29);
    yellowPath.cubicTo(
      size.width * 0.06, size.height * 0.36,
      size.width * 0.04, size.height * 0.43,
      size.width * 0.04, size.height * 0.50,
    );
    yellowPath.cubicTo(
      size.width * 0.04, size.height * 0.57,
      size.width * 0.06, size.height * 0.64,
      size.width * 0.09, size.height * 0.70,
    );
    yellowPath.close();
    canvas.drawPath(yellowPath, paint);

    // Red path
    paint.color = const Color(0xFFEA4335);
    final redPath = Path();
    redPath.moveTo(size.width * 0.50, size.height * 0.22);
    redPath.cubicTo(
      size.width * 0.57, size.height * 0.22,
      size.width * 0.63, size.height * 0.25,
      size.width * 0.67, size.height * 0.29,
    );
    redPath.lineTo(size.width * 0.80, size.height * 0.16);
    redPath.cubicTo(
      size.width * 0.73, size.height * 0.09,
      size.width * 0.62, size.height * 0.04,
      size.width * 0.50, size.height * 0.04,
    );
    redPath.cubicTo(
      size.width * 0.32, size.height * 0.04,
      size.width * 0.17, size.height * 0.14,
      size.width * 0.09, size.height * 0.29,
    );
    redPath.lineTo(size.width * 0.24, size.height * 0.41);
    redPath.cubicTo(
      size.width * 0.28, size.height * 0.30,
      size.width * 0.38, size.height * 0.22,
      size.width * 0.50, size.height * 0.22,
    );
    redPath.close();
    canvas.drawPath(redPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
