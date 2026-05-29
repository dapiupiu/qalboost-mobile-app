import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_service.dart';
import '../provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Gagal! Email atau Password salah.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeService.loginBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Positioned(
                      top: 200,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeService.isDarkMode
                              ? const Color(0xFF1E1E1E)
                              : const Color(0xFFD7EAF8),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 100),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Image.asset(
                                'assets/images/mix.png',
                                width: 130,
                                cacheWidth: 390,
                                fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Center(
                              child: Image.asset(
                                'assets/images/regis.png',
                                height: 180,
                                cacheHeight: 540,
                                fit: BoxFit.contain,
                                errorBuilder: (c, e, s) => Icon(
                                  Icons.wb_cloudy,
                                  size: 100,
                                  color: themeService.loginButtonColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              'Selamat Datang',
                              style: AppTextStyles.titleLarge(context).copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Silakan login untuk melanjutkan',
                              style: AppTextStyles.bodyMedium(context).copyWith(
                                color: themeService.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 30),
                            _buildLabel('Email'),
                            _buildTextField(
                              controller: _emailController,
                              hint: 'Masukkan email kamu',
                              icon: Icons.email_outlined,
                              themeService: themeService,
                            ),
                            const SizedBox(height: 20),
                            _buildLabel('Password'),
                            _buildTextField(
                              controller: _passwordController,
                              hint: 'Masukkan password kamu',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              themeService: themeService,
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeService.loginButtonColor,
                                  foregroundColor: themeService.loginButtonTextColor,
                                  elevation: themeService.isDarkMode ? 0 : 4,
                                  shadowColor: themeService.loginButtonColor
                                      .withValues(alpha: 0.35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Masuk Sekarang',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Belum punya akun?',
                                    style: AppTextStyles.bodySmall(context),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: Text(
                                      'Daftar di sini',
                                      style: AppTextStyles.bodySmall(context).copyWith(
                                        color: themeService.loginButtonColor,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium(context).copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required ThemeService themeService,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: themeService.loginInputShadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: AppTextStyles.bodyMedium(context),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium(context).copyWith(
            color: themeService.loginHintColor,
          ),
          prefixIcon: Icon(
            icon,
            color: themeService.loginIconColor,
            size: 20,
          ),
          filled: true,
          fillColor: themeService.loginInputColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}