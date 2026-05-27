import 'package:flutter/material.dart';
import '../provider/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok!')),
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
          const SnackBar(content: Text('Akun berhasil dibuat! Silakan Login.')),
        );
        Navigator.pop(context); 
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi gagal! Email mungkin sudah digunakan.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengecek apakah keyboard sedang aktif
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- 1. BACKGROUND CONTAINER PEACH (MENGISI PENUH KE BAWAH) ---
          Positioned(
            top: 200, // Mulai melengkung di sini
            left: 0,
            right: 0,
            bottom: 0, // Ini yang bikin dia penuh sampai bawah layar
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFE5D1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
            ),
          ),

          // --- 2. KONTEN UTAMA ---
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo MIX
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/mix.png', 
                      width: 140, 
                      fit: BoxFit.contain,
                    ),
                  ),

                  // GAMBAR REGIS (Bulan) yang menimpa garis pembatas
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: isKeyboardVisible ? 0 : 140,
                    alignment: Alignment.centerRight,
                    child: isKeyboardVisible 
                      ? const SizedBox() 
                      : Transform.translate(
                          offset: const Offset(0, 55),
                          child: Image.asset(
                            'assets/images/regis.png', 
                            height: 140,
                          ),
                        ),
                  ),

                  // FORM INPUT
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Buat Akun', 
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 10),
                        
                        _labelInput('Masukan Nama Lengkap'),
                        _buildField(_nameController),
                        
                        _labelInput('Masukan Email'),
                        _buildField(_emailController),
                        
                        _labelInput('Masukan Password'),
                        _buildField(_passwordController, isPassword: true),
                        
                        _labelInput('Ulangi Password'),
                        _buildField(_confirmPasswordController, isPassword: true),
                        
                        const SizedBox(height: 30),
                        
                        // TOMBOL DAFTAR
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E679F),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 5,
                            ),
                            child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Buat Akun', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sudah punya akun?", style: TextStyle(color: Colors.black54)),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFF1E679F),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Padding bawah dinamis agar scroll enak saat keyboard aktif
                        SizedBox(height: isKeyboardVisible ? 150 : 80), 
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

  Widget _labelInput(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 12),
    child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
  );

  Widget _buildField(TextEditingController controller, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}