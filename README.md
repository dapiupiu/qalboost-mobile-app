<p align="center">
  <img src="assets/images/app_logo.png" alt="QalBoost Logo" width="200"/>
</p>

<h1 align="center">QalBoost</h1>

<p align="center">
  <strong>Aplikasi Pendukung Kesehatan Mental dan Pelacakan Emosi Mandiri.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen?style=for-the-badge" alt="PRs Welcome"/>
</p>

<p align="center">
  <a href="https://github.com/dapiupiu/qalboost-mobile-app"><strong>GitHub Repository</strong></a> · 
  <a href="https://www.figma.com/design/uyP9D5qelQrwXeeSEtjCn6/QALBOOST_APP?node-id=0-1&p=f&t=nuGvSz2tkmbvXxct-0"><strong>Figma Design Workspace</strong></a>
</p>

---

## Deskripsi Proyek & Filosofi

**QalBoost** adalah sebuah platform kesehatan mental inovatif yang dirancang khususnya bagi Gen Z. Berfokus pada kemandirian dalam mengelola emosi, aplikasi ini menyediakan ekosistem digital yang aman bagi pengguna untuk melacak dinamika perasaan sehari-hari, mencatat jurnal reflektif, serta mendapatkan asupan motivasi dan literasi kesehatan mental yang terkurasi. Kami percaya bahwa kesehatan mental yang terjaga adalah fondasi utama bagi keberhasilan akademik dan kesejahteraan personal seseorang.

Filosofi desain QalBoost berpusat pada **Frictionless User Experience**. Kami mengeliminasi hambatan konvensional seperti *landing page* yang statis, menggantikannya dengan interaksi video *Splash Screen* yang dinamis serta sistem *conditional auth routing* instan. Hal ini memastikan pengguna dapat langsung mengakses fitur utama Dashboard atau dipandu menuju proses autentikasi secara cerdas berdasarkan status sesi mereka, memberikan kesan aplikasi yang responsif dan "hidup".

---

## Fitur Utama

*   **Mood Tracking & Analytics**
    Pencatatan emosi harian dengan visualisasi metrik yang intuitif. Memanfaatkan *real-time broadcasting* untuk memperbarui status emosional di seluruh aplikasi secara instan melalui mutasi state yang reaktif.
*   **Personal Diary Journaling**
    Wadah curahan hati digital yang didorong oleh *reactive bottom sheet overlay*. Memungkinkan pengguna menulis jurnal reflektif tanpa kehilangan konteks visual dari layar sebelumnya.
*   **Mental Health Educational Tips**
    Pusat literasi kesehatan mental dengan aset edukatif yang dikategorikan secara dinamis menggunakan *tab bar navigation*, memudahkan akses ke berbagai topik kesehatan mental.
*   **Motivational Quotes Canvas**
    Penyajian kutipan inspiratif dalam bentuk kanvas visual yang menawan, dirancang untuk memberikan dorongan moral instan bagi pengguna setiap hari.

---

## Tech Stack & Arsitektur

### Teknologi yang Digunakan

| Kategori | Teknologi |
| :--- | :--- |
| **Language** | Dart SDK ^3.11.1 |
| **UI Framework** | Flutter Framework |
| **State Management** | ChangeNotifierProvider (Global State Layer) |
| **Data Pipeline** | JSON Serialization/Deserialization via Factory Methods |
| **AI Integration** | Groq AI (Llama-3.1-8b-instant) |
| **Local Storage** | Shared Preferences & Path Provider |

### Arsitektur & Optimasi

Aplikasi ini mengimplementasikan pola arsitektur reaktif menggunakan **ChangeNotifierProvider**. Seluruh data dikelola melalui model kelas modular (seperti `user_model.dart` dan `mood_model.dart`) yang memastikan enkapsulasi data yang ketat. 

**Optimasi Utama:**
- **Secure Environment:** Ekstraksi variabel sensitif (API Key) menggunakan pipeline `String.fromEnvironment` saat runtime, menjaga integritas kredensial dari *hard-coding*.
- **Memory Efficiency:** Penggunaan properti konstanta statis pada `theme_service.dart` untuk meminimalkan beban memori saat render gaya UI.

---

## Architectural System Flow

1.  **Splash Initialization:** Aplikasi memulai dengan video splash dinamis sambil memuat konfigurasi tema dan memeriksa status sesi pengguna di latar belakang.
2.  **Token Validation Session:** Sistem memeriksa keberadaan token autentikasi di penyimpanan lokal. Jika valid, pengguna akan diarahkan langsung ke Dashboard.
3.  **Conditional Auth Routing:** Jika sesi tidak ditemukan, aplikasi melakukan transisi mulus ke halaman Login/Register tanpa melalui layar antara yang tidak perlu.
4.  **Mood State Broadcaster:** Saat pengguna memasukkan data emosi, state diubah secara global. Broadcaster akan memberi tahu seluruh komponen UI (seperti Dashboard dan Tracker) untuk melakukan *re-render* dengan data terbaru.
5.  **Reactive Journaling Pipeline:** Proses pencatatan jurnal diaktifkan melalui overlay, memastikan data tersimpan secara lokal dan sinkron dengan *state provider* utama.

---

## Struktur Proyek

Berikut adalah struktur direktori utama yang digunakan dalam pengembangan QalBoost:

```text
lib/
├── core/
│   ├── chatbot/
│   │   ├── chat_screen.dart          <-- [5] Chat AI Screen
│   │   └── chat_service.dart
│   ├── components/                   <-- Shared UI Components
│   ├── notifications/
│   └── theme/
│       └── theme_service.dart        <-- Static Constant Styling
├── features/
│   ├── auth/
│   │   ├── model/
│   │   │   └── user_model.dart       <-- Data Encapsulation
│   │   ├── presentation/
│   │   │   ├── login_page.dart       <-- [2] Login View
│   │   │   └── register_page.dart    <-- [3] Register View
│   │   └── provider/
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── home_page.dart        <-- [4] Dashboard View
│   │   │   └── splash_screen.dart    <-- [1] Video Splash View
│   │   └── provider/
│   ├── main_features/
│   │   ├── model/
│   │   │   └── mood_model.dart
│   │   ├── presentation/
│   │   │   ├── checker.dart          <-- [6] Mood Checker
│   │   │   └── mood.dart             <-- [7] Mood Tracking View
│   │   └── provider/
│   │       └── mood_provider.dart    <-- Real-time Broadcaster
│   ├── settings/
│   │   ├── presentation/
│   │   │   ├── settings.dart         <-- [12] Settings View
│   │   │   └── edit_profile_page.dart <-- [13] Profile Edit View
│   └── sub_features/
│       └── presentation/
│           ├── consul.dart           <-- [9] Consultation View
│           ├── diary.dart            <-- [8] Journaling View
│           ├── quotes.dart           <-- [10] Quotes Canvas
│           └── tips.dart             <-- [11] Educational Tips
└── main.dart
```

---

## Memulai (Local Deployment)

Ikuti langkah-langkah berikut untuk menjalankan proyek QalBoost di lingkungan lokal Anda:

### Prasyarat
- Pastikan [Flutter SDK](https://docs.flutter.dev/get-started/install) sudah terinstal (v3.11.1 atau lebih baru).
- Device Android/iOS atau Emulator yang siap digunakan.

### Langkah-langkah

1.  **Clone Repositori**
    ```bash
    git clone https://github.com/dapiupiu/qalboost-mobile-app.git
    cd qalboost-mobile-app
    ```

2.  **Instalasi Dependensi**
    ```bash
    flutter pub get
    ```

3.  **Injeksi Environment & Jalankan Aplikasi**
    Pastikan Anda menyertakan API Key Groq saat menjalankan aplikasi untuk fitur Chatbot:
    ```bash
    flutter run --dart-define=API_KEY=YOUR_GROQ_API_KEY_HERE
    ```

---

## Roadmap Pengembangan Masa Depan

- **End-to-End Encryption:** Implementasi enkripsi tingkat lanjut untuk data jurnal pribadi pengguna.
- **AI Sentiment Analysis:** Analisis otomatis terhadap entri jurnal untuk memberikan *insight* mendalam tentang tren kesehatan mental pengguna.
- **Cross-platform Notification Syncing:** Sinkronisasi pengingat *mood tracking* di berbagai perangkat secara real-time.
- **Offline-first Architecture:** Optimalisasi dukungan *full offline* dengan sinkronisasi database saat koneksi tersedia.

---

## Kontributor Proyek

| Nama | Peran & Tanggung Jawab |
| :--- | :--- |
| **Kaka Davi Dharmawan** | Lead Front-end Developer & State Management Architect |
| **Dodyk Fahlome** | Lead Back-end Developer & Data Pipeline Integration |
| **Dea Alya** | UI/UX Designer & Creative Visionary |
| **Nazwa Aliya M. Hasibuan** | QA Engineer & Performance Optimization |

---

## Lisensi & Hak Cipta

Proyek ini merupakan proyek original dan seluruh konten dan aset dalam repositori ini adalah bagian dari ekosistem QalBoost. 

Copyright © 2026 **Tim QalBoost - Kelompok 1**. Seluruh hak cipta dilindungi undang-undang.