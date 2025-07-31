class CameraService {
  // Simulasi pengenalan bahan dari gambar
  Future<List<String>> recognizeIngredients(String imagePath) async {
    // Di sini bisa integrasi dengan ML/AI atau API
    await Future.delayed(const Duration(seconds: 1));
    // Dummy hasil
    return ['Tomat', 'Telur', 'Bawang'];
  }
}
