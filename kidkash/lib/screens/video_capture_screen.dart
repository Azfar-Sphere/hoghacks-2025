import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class VideoCaptureScreen extends StatefulWidget {
  const VideoCaptureScreen({super.key});

  @override
  State<VideoCaptureScreen> createState() => _VideoCaptureScreenState();
}

class _VideoCaptureScreenState extends State<VideoCaptureScreen> {
  CameraController? _controller;
  bool _isRecording = false;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[1], ResolutionPreset.medium);
    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> startRecording() async {
    if (_controller == null || _isRecording) return;
    await _controller!.startVideoRecording();
    setState(() => _isRecording = true);
  }

  Future<void> stopRecording() async {
    if (_controller == null || !_isRecording) return;

    final file = await _controller!.stopVideoRecording();
    setState(() => _isRecording = false);

    print('Video saved to: ${file.path}');

    // Replace with your local IP
    final uri = Uri.parse('http://172.20.10.6:8000/detect-nod');

    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('video', file.path));

    final response = await request.send();
    print('Request sent to: $uri');
    print('Request headers: ${request.headers}');
    print('Request files: ${request.files}');
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      print('API response: $result');
      // TODO: Update Firestore based on response
    } else {
      print('Upload failed: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller!.value.previewSize!.height,
                height: _controller!.value.previewSize!.width,
                child: CameraPreview(_controller!),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _isRecording ? stopRecording : startRecording,
                child: Text(
                  _isRecording ? 'Stop Recording' : 'Start Recording',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
