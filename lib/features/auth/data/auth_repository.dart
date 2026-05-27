import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../model/user_model.dart';

class AuthRepository {
  // Pastikan nama file JSON konsisten dengan yang dipakai saat register/login
  final String _fileName = 'users.json';

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // --- Fungsi yang sudah ada sebelumnya ---
  
  Future<List<UserModel>> getAllUsers() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      
      final String contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<UserModel?> login(String email, String password) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> registerUser(UserModel user) async {
    final users = await getAllUsers();
    if (users.any((u) => u.email == user.email)) return false;
    
    users.add(user);
    final String jsonString = jsonEncode(users.map((u) => u.toJson()).toList());
    final file = await _localFile;
    await file.writeAsString(jsonString);
    return true;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final users = await getAllUsers();
    try {
      return users.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  // --- FUNGSI UPDATE (YANG TADI ERROR) ---
  
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      final List<UserModel> users = await getAllUsers();
      
      // Cari index berdasarkan email
      int index = users.indexWhere((u) => u.email == updatedUser.email);
      
      if (index != -1) {
        // Ganti data lama dengan data baru (termasuk password baru)
        users[index] = updatedUser;
        
        // Simpan kembali ke file
        final String jsonString = jsonEncode(users.map((u) => u.toJson()).toList());
        final file = await _localFile;
        await file.writeAsString(jsonString);
        
        debugPrint("Berhasil update data user di JSON: ${updatedUser.email}");
      }
    } catch (e) {
      debugPrint("Gagal update user: $e");
    }
  }
}