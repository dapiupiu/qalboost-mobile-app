import 'package:flutter/material.dart';
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

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();

    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau Password salah!'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: themeService.loginBackgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/mix.png',
                      width: 130,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 35),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: isKeyboardVisible ? 100 : 180,
                    child: Image.asset(
                      'assets/images/regis.png',
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Icon(
                        Icons.wb_cloudy,
                        size: 100,
                        color: themeService.loginButtonColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    'Selamat Datang Kembali!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeService.loginTitleColor,
                    ),
                  ),

                  const SizedBox(height: 45),

                  _buildTextField(
                    themeService,
                    'Masukan Email',
                    _emailController,
                    Icons.email_outlined,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    themeService,
                    'Masukan Password',
                    _passwordController,
                    Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeService.loginButtonColor,
                        elevation: themeService.isDarkMode ? 0 : 5,
                        shadowColor:
                            themeService.loginButtonColor.withOpacity(0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: themeService.loginButtonTextColor,
                            )
                          : Text(
                              'Login',
                              style: TextStyle(
                                color: themeService.loginButtonTextColor,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum Mempunyai Akun? ',
                        style: TextStyle(
                          color: themeService.loginBottomTextColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/register',
                        ),
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            color: themeService.loginButtonColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: themeService.loginButtonColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    ThemeService themeService,
    String hint,
    TextEditingController controller,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: themeService.loginInputColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeService.loginInputBorderColor,
        ),
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
        style: TextStyle(
          color: themeService.loginTitleColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: themeService.loginHintColor,
            fontSize: 14,
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