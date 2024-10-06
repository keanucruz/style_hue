import 'package:flutter/material.dart';
import 'package:skintone_remake/screens/image_process.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color secondaryColor = const Color(0xFFFFE4CC);
  Color mainColor =  Colors.amber.shade50;
  final picker = ImagePicker();
  XFile? _image;

  Future <XFile?> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      setState(() {
        _image = pickedFile;
        imageList.add(XFile(pickedFile.path));
      });
      return _image;
    }
    return null;
  }

  Future<XFile?> _pickImageFromGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _image = pickedFile;
        imageList.add(XFile(pickedFile.path));
      });
      return _image;
    }
    return null;
  }

  final List<XFile> imageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        toolbarHeight: 90,
        flexibleSpace: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 36),
                Text(
                  'Upload Selfie to StyleHue',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Get your personalized results',
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
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(File(imageList[index].path),
                          fit: BoxFit.cover,),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15,),
              Container(
                height: 256,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: mainColor,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                                'lib/assets/icons/notification.png',
                              height: 20,
                              width: 30,
                            ),
                            const SizedBox(width: 3,),
                            Text(
                                'Reminder for Best Results',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '1. Good Lighting - Use Natural light to avoid shadows.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '2. Neutral Background - Choose a plain backdrop.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '3. Face Forward - Position yourself directly in front of the camera.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '4. No Filters - Upload the image without edits.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '5. Clear Image - Ensure the photo is in focus.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '6. Remove Accessories - Take off hats and sunglasses.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '7. Minimal Makeup - Keep it natural for accurate color analysis.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '8. Full Face Visibility - Center your face in the frame.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Center(
                child: Text(
                    'Recommended Shots',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18
                  )
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: secondaryColor
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('lib/assets/images/reco.jpg', fit: BoxFit.fill,),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: secondaryColor
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('lib/assets/images/reco.jpg', fit: BoxFit.fill,),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: secondaryColor
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('lib/assets/images/reco.jpg', fit: BoxFit.fill,),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              Center(
                child: Text(
                    'Unrecommended Shots',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18
                    )
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: secondaryColor
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('lib/assets/images/reco.jpg', fit: BoxFit.fill,),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: secondaryColor
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('lib/assets/images/reco.jpg', fit: BoxFit.fill,),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Container(
                    height: 130,
                    width: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: secondaryColor
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('lib/assets/images/reco.jpg', fit: BoxFit.fill,),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final pickedImage = await _pickImageFromCamera();
                    if(pickedImage != null){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) =>  ImageProcess(image: pickedImage))
                      );
                    }
                  },
                  child: Container(
                    width: 360,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.camera_alt,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          'Capture an Image',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final pickedImage = await _pickImageFromGallery();
                    if(pickedImage != null){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) =>  ImageProcess(image: pickedImage))
                      );
                    }
                  },
                  child: Container(
                    width: 360,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(25)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          'Upload an Image',
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
