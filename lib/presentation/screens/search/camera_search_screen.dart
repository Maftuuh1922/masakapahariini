import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../core/services/camera_service.dart';
import '../../../routes/app_routes.dart'; // Import AppRoutes

class CameraSearchScreen extends StatefulWidget {
  const CameraSearchScreen({Key? key}) : super(key: key);

  @override
  State<CameraSearchScreen> createState() => _CameraSearchScreenState();
}

class _CameraSearchScreenState extends State<CameraSearchScreen> {
  CameraController? _controller;
  late CameraService _cameraService;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || _isProcessing) return;
    
    setState(() => _isProcessing = true);
    
    try {
      final image = await _controller!.takePicture();
      final ingredients = await _cameraService.recognizeIngredients(image.path);
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.searchResults,
          arguments: {'detectedIngredients': ingredients},
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Bahan Makanan'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Camera Preview
          CameraPreview(_controller!),
          
          // Overlay UI
          SafeArea(
            child: Column(
              children: [
                // Instructions
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Arahkan kamera ke bahan makanan yang ingin dimasak',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const Spacer(),
                
                // Capture Button
                Container(
                  margin: const EdgeInsets.all(32),
                  child: FloatingActionButton.large(
                    onPressed: _isProcessing ? null : _takePicture,
                    backgroundColor: Colors.white,
                    child: _isProcessing
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 32,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
