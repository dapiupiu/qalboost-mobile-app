import 'package:flutter/material.dart';
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

    final authProvider = AuthProvider(); 
    bool success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email atau Password salah!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Deteksi keyboard untuk stabilitas layout
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 60),
              
              // 1. LOGO TEXT (MIX.PNG diperbesar manual)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/mix.png', 
                    width: 130, // Ukuran diperbesar manual
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 2. MASKOT UTAMA (REGIS.PNG menggantikan matahari)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: isKeyboardVisible ? 100 : 180, // Mengecil saat ngetik
                child: Image.asset(
                  'assets/images/regis.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.wb_cloudy, size: 100, color: Colors.blue),
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Selamat Datang Kembali!', 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 40),

              // 3. FORM INPUT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    _buildTextField('Masukan Email', _emailController, Icons.email_outlined),
                    const SizedBox(height: 15),
                    _buildTextField('Masukan Password', _passwordController, Icons.lock_outline, isPassword: true),
                    
                    const SizedBox(height: 35),

                    // TOMBOL LOGIN
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E679F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Login', 
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // NAVIGASI KE REGISTER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum Mempunyai Akun? '),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            'Daftar', 
                            style: TextStyle(
                              color: Color(0xFF1E679F), 
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}