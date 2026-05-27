import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../data/auth_local_data.dart';
import '../model/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final AuthLocalData _localData = AuthLocalData();

  // Proses Registrasi
  Future<bool> register(String name, String email, String password) async {
    final user = UserModel(fullName: name, email: email, password: password);
    return await _repository.registerUser(user);
  }

  // Proses Login
  Future<bool> login(String email, String password) async {
    // === TAMBAHKAN LOGIKA AKUN ADMIN DI SINI ===
    if (email == 'admin@gmail.com' && password == 'admin123') {
      // Langsung simpan session ke local storage seperti login biasa
      await _localData.saveSession(email); 
      return true;
    }
    // ===========================================

    // Jika bukan akun admin, jalankan proses login normal (cek database/API)
    final user = await _repository.login(email, password);
    if (user != null) {
      // Simpan session dan data password ke local storage untuk keperluan Edit Profile
      await _localData.saveSession(email); 
      return true;
    }
    return false;
  }
}