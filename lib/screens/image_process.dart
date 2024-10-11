import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:scanning_effect/scanning_effect.dart';
import 'package:skintone_remake/screens/results_screen.dart';
import 'package:http/http.dart' as http;
import 'package:scanning_effect/scanner_animation.dart';

class ImageProcess extends StatefulWidget {
  final XFile image;

  const ImageProcess({super.key, required this.image});

  @override
  State<ImageProcess> createState() => _ImageProcessState();
}

class _ImageProcessState extends State<ImageProcess> {
  Color secondaryColor = const Color(0xFFFFE4CC);
  Color mainColor = Colors.amber.shade50;
  String? _skinTone;
  List<dynamic>? _dominantColors;
  double? _accuracy;
  String? _seasonCategory;
  Map<String, String>? _colorPalette;
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
        print("Failed to upload/process image");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        toolbarHeight: screenHeight * 0.1,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.04),
              Text(
                'You look amazing!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Confirm your color analysis shot',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: screenWidth * 0.04,
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
            Center(
              child: Container(
                height: screenHeight * 0.5,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: mainColor,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: screenHeight * 0.5,
                        width: screenWidth * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: mainColor,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.file(
                            File(widget.image.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    if (_isScanning)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ScanningEffect(
                          scanningColor: secondaryColor,
                          borderLineColor: Colors.white,
                          delay: const Duration(seconds: 1),
                          duration: const Duration(seconds: 2),
                          child: Image.file(
                            File(widget.image.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _isScanning = true;
                });
                await Future.delayed(const Duration(seconds: 3));
                await _uploadImage();
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
                        pickedImage: File(widget.image.path),
                      ),
                    ),
                  );
                }
              },
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.06,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
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
              child: Text(
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
