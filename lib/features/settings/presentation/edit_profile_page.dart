import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_service.dart';
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

    final user = await _authRepository.getUserByEmail(email);

    if (user != null && mounted) {
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

      final user = await _authRepository.getUserByEmail(email);

      if (user != null) {
        final updatedUser = UserModel(
          fullName: user.fullName,
          email: user.email,
          password: newPassword,
        );

        await _authRepository.updateUser(updatedUser);
      }

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
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      backgroundColor: themeService.editProfileBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profil',
          style: TextStyle(
            color: themeService.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeService.iconColor,
          ),
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
                backgroundColor: themeService.editProfileAvatarBgColor,
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: themeService.editProfileIconColor,
                ),
              ),

              const SizedBox(height: 35),

              _buildTextField(
                themeService: themeService,
                label: 'Nama Lengkap',
                controller: _nameController,
                icon: Icons.person_outline,
                enabled: false,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                themeService: themeService,
                label: 'Email',
                controller: _emailController,
                icon: Icons.email_outlined,
                enabled: false,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                themeService: themeService,
                label: 'Password Baru',
                controller: _passwordController,
                icon: Icons.lock_outline,
                enabled: true,
                isPassword: true,
                obscureText: !_isPasswordVisible,
                onSuffixIconPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 45),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeService.editProfileButtonColor,
                    foregroundColor: themeService.editProfileButtonTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: themeService.isDarkMode ? 0 : 2,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: themeService.editProfileButtonTextColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeService.editProfileButtonTextColor,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_clock_outlined,
                    size: 14,
                    color: themeService.editProfileInfoTextColor,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Demi keamanan, Nama dan Email bersifat permanen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeService.editProfileInfoTextColor,
                        fontSize: 11,
                      ),
                    ),
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
    required ThemeService themeService,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixIconPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: themeService.textPrimaryColor,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          enabled: enabled,
          obscureText: obscureText,
          style: TextStyle(
            color: enabled
                ? themeService.editProfileInputTextColor
                : themeService.editProfileDisabledTextColor,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: enabled
                  ? themeService.editProfileIconColor
                  : themeService.editProfileDisabledTextColor,
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: themeService.editProfileDisabledTextColor,
                    ),
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            filled: true,
            fillColor: enabled
                ? themeService.editProfileInputEnabledColor
                : themeService.editProfileInputDisabledColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            hintText: 'Masukkan $label',
            hintStyle: TextStyle(
              color: themeService.hintTextColor,
            ),
          ),
          validator: (value) {
            if (enabled && (value == null || value.isEmpty)) {
              return 'Password tidak boleh kosong';
            }

            if (enabled && value!.length < 6) {
              return 'Minimal 6 karakter';
            }

            return null;
          },
        ),
      ],
    );
  }
}