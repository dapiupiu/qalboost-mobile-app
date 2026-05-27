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
    final user = await _repository.login(email, password);
    if (user != null) {
      // Simpan session dan data password ke local storage untuk keperluan Edit Profile
      await _localData.saveSession(email); 
      return true;
    }
    return false;
  }
}