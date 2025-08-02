# Firebase Setup Guide

## Langkah-langkah Setup Firebase

### 1. Buat Firebase Project
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik "Add project" atau "Create a project"
3. Nama project: `masak-apa-hari-ini`
4. Enable/disable Google Analytics sesuai kebutuhan
5. Klik "Create project"

### 2. Setup Android App
1. Di Firebase Console, klik "Add app" → pilih Android (ikon robot)
2. **Android package name**: `com.example.masakapahariini`
3. App nickname (opsional): `Masak Apa Hari Ini`
4. Debug signing certificate SHA-1 (opsional untuk development)
5. Klik "Register app"

### 3. Download Configuration Files
1. Download `google-services.json`
2. Pindahkan file ke: `android/app/google-services.json`
3. **PENTING**: Jangan commit file ini ke repository public!

### 4. Setup Web App (Opsional)
1. Klik "Add app" → pilih Web
2. App nickname: `Masak Apa Hari Ini Web`
3. Copy konfigurasi yang diberikan
4. Update `lib/firebase_options.dart` dengan data dari Firebase Console:
   - Ganti `YOUR_WEB_API_KEY` dengan apiKey
   - Ganti `YOUR_WEB_APP_ID` dengan appId
   - Ganti `YOUR_MESSAGING_SENDER_ID` dengan messagingSenderId
   - Pastikan projectId sudah benar: `masak-apa-hari-ini`

### 5. Update Firebase Options
Edit file `lib/firebase_options.dart` dan ganti semua placeholder:

**Android:**
- `YOUR_ANDROID_API_KEY` → dari google-services.json
- `YOUR_ANDROID_APP_ID` → dari google-services.json
- `YOUR_MESSAGING_SENDER_ID` → dari project settings

**Web:**
- `YOUR_WEB_API_KEY` → dari web app config
- `YOUR_WEB_APP_ID` → dari web app config

### 6. Enable Firebase Services
Di Firebase Console, enable services yang dibutuhkan:

1. **Firestore Database**:
   - Klik "Firestore Database" → "Create database"
   - Pilih "Start in test mode" untuk development
   - Pilih lokasi server (asia-southeast1 untuk Asia Tenggara)

2. **Firebase ML** (untuk AI features):
   - Klik "ML Kit" atau "Machine Learning"
   - Enable fitur yang dibutuhkan

3. **Authentication** (jika diperlukan):
   - Klik "Authentication" → "Get started"
   - Enable provider yang diinginkan (Email/Password, Google, dll)

### 7. Test Connection
Setelah setup:
```bash
flutter clean
flutter pub get
flutter run
```

### 8. Firestore Rules (Development)
Untuk development, gunakan rules berikut di Firestore:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**PERINGATAN**: Rules di atas hanya untuk development. Untuk production, gunakan rules yang lebih ketat!

### 9. Environment Variables (Opsional)
Untuk keamanan yang lebih baik, Anda bisa menggunakan environment variables:

1. Buat file `.env` di root project
2. Tambahkan konfigurasi Firebase
3. Install package `flutter_dotenv`
4. Load dari .env file

### Troubleshooting

**Error: google-services.json not found**
- Pastikan file `google-services.json` ada di `android/app/`
- Pastikan nama file exactly `google-services.json`

**Error: Firebase not initialized**
- Pastikan `Firebase.initializeApp()` dipanggil di `main()`
- Pastikan import `firebase_options.dart` benar

**Build error Android**
- Pastikan Google Services plugin sudah ditambahkan di `build.gradle`
- Clean dan rebuild project

**API Key issues**
- Pastikan semua placeholder di `firebase_options.dart` sudah diganti
- Periksa kembali konfigurasi di Firebase Console

### File yang Perlu Diupdate
1. ✅ `android/build.gradle.kts` - Google Services plugin
2. ✅ `android/app/build.gradle.kts` - Plugin dan namespace
3. ✅ `lib/firebase_options.dart` - Firebase configuration
4. ❌ `android/app/google-services.json` - **Download dari Firebase Console**

### Security Notes
- **JANGAN** commit `google-services.json` ke public repository
- Tambahkan ke `.gitignore`:
  ```
  android/app/google-services.json
  ios/Runner/GoogleService-Info.plist
  ```
