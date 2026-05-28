import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/theme_service.dart';
import '../provider/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (_passwordController.text !=
        _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak cocok!'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = AuthProvider();

    bool success = await authProvider.register(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Akun berhasil dibuat! Silakan Login.',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Registrasi gagal! Email mungkin sudah digunakan.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService =
        Provider.of<ThemeService>(context);

    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeService.isDarkMode
          ? const Color(0xFF121212)
          : Colors.white,
      body: Stack(
        children: [
          // BACKGROUND
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: themeService.isDarkMode
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFFFE5D1),
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () =>
                FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics:
                  const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // LOGO
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    child: Image.asset(
                      'assets/images/mix.png',
                      width: 140,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // MASKOT
                  AnimatedContainer(
                    duration: const Duration(
                        milliseconds: 200),
                    height:
                        isKeyboardVisible ? 0 : 140,
                    alignment: Alignment.centerRight,
                    child: isKeyboardVisible
                        ? const SizedBox()
                        : Transform.translate(
                            offset:
                                const Offset(0, 55),
                            child: Image.asset(
                              'assets/images/regis.png',
                              height: 140,
                            ),
                          ),
                  ),

                  // FORM
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                            horizontal: 30),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buat Akun',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight:
                                FontWeight.bold,
                            color: themeService
                                .textPrimaryColor,
                          ),
                        ),

                        const SizedBox(height: 10),

                        _labelInput(
                          'Masukan Nama Lengkap',
                          themeService,
                        ),

                        _buildField(
                          themeService,
                          _nameController,
                        ),

                        _labelInput(
                          'Masukan Email',
                          themeService,
                        ),

                        _buildField(
                          themeService,
                          _emailController,
                        ),

                        _labelInput(
                          'Masukan Password',
                          themeService,
                        ),

                        _buildField(
                          themeService,
                          _passwordController,
                          isPassword: true,
                        ),

                        _labelInput(
                          'Ulangi Password',
                          themeService,
                        ),

                        _buildField(
                          themeService,
                          _confirmPasswordController,
                          isPassword: true,
                        ),

                        const SizedBox(height: 30),

                        // BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _handleRegister,
                            style: ElevatedButton
                                .styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFF1E679F),
                              elevation: themeService
                                      .isDarkMode
                                  ? 0
                                  : 5,
                              shadowColor:
                                  const Color(
                                          0xFF1E679F)
                                      .withOpacity(
                                          0.35),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            16),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                  )
                                : const Text(
                                    'Buat Akun',
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Text(
                                "Sudah punya akun?",
                                style: TextStyle(
                                  color: themeService
                                      .textSecondaryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(
                                        0xFF1E679F),
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    decoration:
                                        TextDecoration
                                            .underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height:
                              isKeyboardVisible
                                  ? 150
                                  : 80,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelInput(
    String label,
    ThemeService themeService,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
        top: 12,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: themeService
              .textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildField(
    ThemeService themeService,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              themeService.isDarkMode
                  ? 0.18
                  : 0.05,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textInputAction: TextInputAction.next,
        style: TextStyle(
          color: themeService
              .textPrimaryColor,
        ),
        decoration: InputDecoration(
          fillColor: themeService.isDarkMode
              ? const Color(0xFF2A2A2A)
              : Colors.white,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
          hintStyle: TextStyle(
            color:
                themeService.hintTextColor,
          ),
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}