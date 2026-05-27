import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/model/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? "";
    
    // Ambil data terbaru langsung dari database JSON
    final user = await _authRepository.getUserByEmail(email);
    
    if (user != null) {
      setState(() {
        _nameController.text = user.fullName ?? "";
        _emailController.text = user.email;
        _passwordController.text = user.password;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final prefs = await SharedPreferences.getInstance();
      final String email = _emailController.text;
      final String newPassword = _passwordController.text;

      // 1. Eksekusi update ke file JSON
      final user = await _authRepository.getUserByEmail(email);
      if (user != null) {
        final updatedUser = UserModel(
          fullName: user.fullName,
          email: user.email,
          password: newPassword,
        );
        await _authRepository.updateUser(updatedUser);
      }

      // 2. Update SharedPreferences agar session tetap sinkron
      await prefs.setString('user_password', newPassword);
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF6E9E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profil', 
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87, 
            fontWeight: FontWeight.bold
          )
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: isDarkMode ? const Color(0xFF1F1F1F) : Colors.white,
                child: const Icon(Icons.person, size: 70, color: Color(0xFF58A6F0)),
              ),
              const SizedBox(height: 35),

              _buildTextField(
                label: 'Nama Lengkap',
                controller: _nameController,
                icon: Icons.person_outline,
                enabled: false,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email_outlined,
                enabled: false,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),

              _buildTextField(
                label: 'Password Baru',
                controller: _passwordController,
                icon: Icons.lock_outline,
                enabled: true,
                isDarkMode: isDarkMode,
                isPassword: true,
                obscureText: !_isPasswordVisible,
                onSuffixIconPressed: () {
                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                },
              ),
              
              const SizedBox(height: 45),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58A6F0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20, width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_clock_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Demi keamanan, Nama dan Email bersifat permanen.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    required bool isDarkMode,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          style: TextStyle(
            color: enabled 
                ? (isDarkMode ? Colors.white : Colors.black87) 
                : Colors.grey,
            fontSize: 15
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: enabled ? const Color(0xFF58A6F0) : Colors.grey),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: onSuffixIconPressed,
                )
              : null,
            filled: true,
            fillColor: isDarkMode 
              ? (enabled ? const Color(0xFF1F1F1F) : const Color(0xFF151515))
              : (enabled ? Colors.white : Colors.grey[200]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            hintText: 'Masukkan $label',
          ),
          validator: (value) {
            if (enabled && (value == null || value.isEmpty)) return 'Password tidak boleh kosong';
            if (enabled && value!.length < 6) return 'Minimal 6 karakter';
            return null;
          },
        ),
      ],
    );
  }
}