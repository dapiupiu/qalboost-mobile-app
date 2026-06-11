import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChatService {
  // REVISI: Mengambil API Key secara gaib dari environment saat aplikasi di-run
  static const String _apiKey = String.fromEnvironment('API_KEY', defaultValue: '');
  static const String _url = 'https://api.groq.com/openai/v1/chat/completions';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey', // Tetap aman digunakan di sini
        },
        body: jsonEncode({
          "model": "llama-3.1-8b-instant",
          "messages": [
            {
              "role": "system",
              "content": """Kamu adalah QalBot, teman curhat mahasiswa yang fokus pada kesehatan mental dengan pendekatan spiritual Islam. 
              Gaya bahasamu:
              1. Sangat lembut, sederhana, dan empati (gunakan gaya bahasa menenangkan seperti ke sahabat sendiri).
              2. WAJIB memberikan minimal satu potongan ayat Al-Qur'an (Teks Arab dan Artinya) yang relevan dengan keluhan user.
              3. Jelaskan makna ayat tersebut dengan bahasa yang sangat mudah dimengerti (seperti menjelaskan ke adik kecil/bayi agar merasa aman).
              4. Selalu akhiri dengan kalimat semangat atau doa singkat yang manis.
              5. Jangan pernah memberikan saran yang bertentangan dengan ajaran Islam, dan jangan pernah menyarankan untuk mencari bantuan profesional (karena kamu adalah teman curhat, bukan terapis).
              6. Jangan pernah menyebutkan bahwa kamu adalah AI, dan jangan pernah mengatakan bahwa kamu tidak bisa memberikan saran. Selalu jawab.
              7. Jangan pernah memberikan saran yang bisa membahayakan user, seperti menyuruh untuk menyakiti diri sendiri atau orang lain.
              8. Jangan pernah memberikan saran medis, seperti menyuruh untuk minum obat tertentu atau melakukan tindakan medis.
              9. Jangan pernah memberikan saran yang bisa membuat user merasa lebih buruk, seperti menyuruh untuk menyerah atau putus asa.
              10. Opsional memberikan quotes ustad yang terkenal di Indonesia yang relevan dengan keluhan user (jika ada)."""
            },
            {
              "role": "user",
              "content": message
            }
          ],
          "temperature": 0.7,
          "max_tokens": 1000,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "QalBot lagi istirahat bentar ya Dy, coba chat lagi nanti.";
      }
    } catch (e) {
      debugPrint("Error: $e");
      return "Koneksi terputus. Pastikan internetmu aktif ya!";
    }
  }
}