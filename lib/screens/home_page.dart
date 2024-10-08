import 'package:flutter/material.dart';
import 'package:skintone_remake/screens/image_process.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color secondaryColor = const Color(0xFFFFE4CC);
  Color mainColor = Colors.amber.shade50;
  final picker = ImagePicker();
  XFile? _image;
  final List<XFile> imageList = [];

  Future<XFile?> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        imageList.add(XFile(pickedFile.path));
      });
      return _image;
    }
    return null;
  }

  Future<XFile?> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        imageList.add(XFile(pickedFile.path));
      });
      return _image;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        toolbarHeight: 90,
        flexibleSpace: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),
              const Text(
                'Upload Selfie to StyleHue',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'Get your personalized results',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w800, //sdsad
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: screenWidth * 0.25,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(imageList[index].path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: screenWidth * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: mainColor,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/assets/icons/notification.png',
                            height: 20,
                            width: 30,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Reminder for Best Results',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '1. Good Lighting - Use Natural light to avoid shadows.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Text(
                            '2. Neutral Background - Choose a plain backdrop.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Text(
                            '3. Face Forward - Position yourself directly in front of the camera.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Text(
                            '4. No Filters - Upload the image without edits.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Text(
                            '5. Clear Image - Ensure the photo is in focus.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Text(
                            '6. Remove Accessories - Take off hats and sunglasses.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Text(
                            '7. Minimal Makeup - Keep it natural for accurate color analysis.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          Text(
                            '8. Full Face Visibility - Center your face in the frame.',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: const Text(
                    'Recommended Shots',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildImageRow(screenWidth),
              const SizedBox(height: 15),
              Center(
                child: const Text(
                  'Unrecommended Shots',
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                ),
              ),
              const SizedBox(height: 15),
              _buildImageRow(screenWidth),
              const SizedBox(height: 20),
              _buildActionButton(
                context: context,
                label: 'Capture an Image',
                onTap: () async {
                  final pickedImage = await _pickImageFromCamera();
                  if (pickedImage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ImageProcess(
                          image: pickedImage,
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                context: context,
                label: 'Upload an Image',
                onTap: () async {
                  final pickedImage = await _pickImageFromGallery();
                  if (pickedImage != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ImageProcess(
                          image: pickedImage,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageRow(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImageBox(screenWidth),
        const SizedBox(width: 15),
        _buildImageBox(screenWidth),
        const SizedBox(width: 15),
        _buildImageBox(screenWidth),
      ],
    );
  }

  Widget _buildImageBox(double screenWidth) {
    return Container(
      height: screenWidth * 0.3,
      width: screenWidth * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: secondaryColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'lib/assets/images/reco.jpg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required BuildContext context,
      required String label,
      required void Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, color: Colors.grey),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
