import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUp(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
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
                  padding: const EdgeInsets.fromLTRB(40, 24, 40, 24),
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
                          'Join Us',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sign Up Form
                      Column(
                        children: [
                          // Full Name Input
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Full Name',
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 10),

                          // Email Input
                          _buildTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 10),

                          // Username Input
                          _buildTextField(
                            controller: _usernameController,
                            hintText: 'Username',
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 10),

                          // Password Input
                          _buildTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            isPassword: true,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 10),

                          // Confirm Password Input
                          _buildTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            isPassword: true,
                            isDarkMode: isDarkMode,
                          ),
                          const SizedBox(height: 16),

                          // Create Account Button with Gradient
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: isDarkMode
                                  ? const LinearGradient(
                                      colors: [Color(0xFF0369A1), Color(0xFF0EA5E9)],
                                    )
                                  : const LinearGradient(
                                      colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                                    ),
                              borderRadius: BorderRadius.circular(24),
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
                              onPressed: _isLoading ? null : _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
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
                                      'Create Account',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 12),

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
                          const SizedBox(height: 12),

                          // Social Sign Up Buttons
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
                                  size: 20,
                                ),
                                isDarkMode: isDarkMode,
                              ),
                              const SizedBox(width: 16),
                              _buildSocialButton(
                                child: Icon(
                                  Icons.apple,
                                  color: isDarkMode ? Colors.white : const Color(0xFF111827),
                                  size: 20,
                                ),
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Bottom Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: isDarkMode
                                      ? const Color(0xFFD1D5DB)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: isDarkMode
                                        ? [const Color(0xFF0EA5E9), const Color(0xFF06B6D4)]
                                        : [const Color(0xFF0369A1), const Color(0xFF0EA5E9)],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'Login',
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
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: isDarkMode ? const Color(0xFF1E4976) : const Color(0xFFBAE6FD),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
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
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
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
      width: 20,
      height: 20,
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

    // Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.94, size.height * 0.51)
        ..lineTo(size.width * 0.5, size.height * 0.51)
        ..lineTo(size.width * 0.5, size.height * 0.69)
        ..lineTo(size.width * 0.74, size.height * 0.69)
        ..close(),
      paint,
    );

    // Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.25,
      paint,
    );

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.5), radius: size.width * 0.25),
      3.14 * 0.5,
      3.14 * 0.5,
      true,
      paint,
    );

    // Green
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.5, size.height * 0.5), radius: size.width * 0.25),
      3.14,
      3.14 * 0.5,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
