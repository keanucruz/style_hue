import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:skintone_remake/screens/results_screen.dart';
import 'home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart'; // Import Lottie package

class ImageProcess extends StatefulWidget {
  final XFile image;

  const ImageProcess({super.key, required this.image});

  @override
  State<ImageProcess> createState() => _ImageProcessState();
}

class _ImageProcessState extends State<ImageProcess> {
  double _imageX = 0; // Position X of image
  double _imageY = 0; // Position Y of image
  double _imageScale = 1.0; // Scale for zooming the image
  final GlobalKey _imageKey = GlobalKey(); // Key to capture image widget
  Color secondaryColor = const Color(0xFFFFE4CC);
  Color mainColor = Colors.amber.shade50;
  String? _skinTone;
  List<dynamic>? _dominantColors;
  double? _accuracy;
  String? _seasonCategory;
  Map<String, String>? _colorPalette;
  final picker = ImagePicker();
  bool _isScanning = false;

  Future<void> _uploadImage() async {
    try {
      final File imageFile = File(widget.image.path);
      final request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.18.211:3009/process_image'));
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseBody);
        setState(() {
          _dominantColors = responseData['dominant_colors'];
          _skinTone = responseData['skin_tone'];
          _accuracy = responseData['accuracy'];
          _seasonCategory = responseData['season_category'];
          _colorPalette =
              Map<String, String>.from(responseData['color_palette']);
        });
      } else {
        // Handle error
        print("Failed to upload/process image");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload/process image')),
        );
      }
    } catch (e) {
      // Handle exceptions
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber.shade50,
        toolbarHeight: 100,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 36),
              Text(
                'You look amazing!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Confirm your color analysis shot',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  // Move the image when dragged
                  _imageX += details.delta.dx;
                  _imageY += details.delta.dy;
                });
              },
              child: Center(
                child: ClipOval(
                  child: RepaintBoundary(
                    key: _imageKey,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.8, // Circle size
                          height: screenWidth * 0.8, // Circle size
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.amber.shade50,
                          ),
                          child: widget.image != null
                              ? Transform.translate(
                                  offset: Offset(_imageX, _imageY),
                                  child: Transform.scale(
                                    scale: _imageScale,
                                    child: Image.file(
                                      File(widget.image.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'No Image Selected',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                        if (_isScanning) // Show scanning animation if scanning
                          SizedBox(
                            width: screenWidth * 0.8, // Match circle size
                            height: screenWidth * 0.8, // Match circle size
                            child: Lottie.asset(
                              'lib/assets/animations/scanning.json', // Replace with your Lottie animation file path
                              repeat: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _imageScale,
              min: 1.0,
              max: 3.0,
              divisions: 20,
              label: _imageScale.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _imageScale = value;
                });
              },
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                if (widget.image == null) {
                  print("No image selected.");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No image selected.')),
                  );
                  return;
                }

                setState(() {
                  _isScanning = true;
                });

                await Future.delayed(
                    const Duration(seconds: 3)); // Simulate scanning time
                await _uploadImage(); // Upload the image

                setState(() {
                  _isScanning = false; // Reset scanning state
                });

                if (_skinTone != null &&
                    _accuracy != null &&
                    _dominantColors != null &&
                    _seasonCategory != null &&
                    _colorPalette != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ResultsScreen(
                        skinTone: _skinTone,
                        accuracy: _accuracy,
                        dominantColors: _dominantColors,
                        seasonCategory: _seasonCategory,
                        colorPalette: _colorPalette,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                width: screenWidth * 0.9,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Start my color analysis',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Reselect Image',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
