import 'dart:io';

import 'package:flutter/material.dart';
import 'package:skintone_remake/screens/home_page.dart';
import 'package:skintone_remake/screens/products_page.dart';

class ResultsScreen extends StatelessWidget {
  final String? skinTone;
  final double? accuracy;
  final List<dynamic>? dominantColors;
  final String? seasonCategory;
  final Map<String, String>? colorPalette;
  final File pickedImage;
  ResultsScreen({
    super.key,
    required this.skinTone,
    required this.accuracy,
    required this.dominantColors,
    required this.seasonCategory,
    required this.colorPalette,
    required this.pickedImage
  });

  Color secondaryColor = const Color(0xFFFFE4CC);
  Color mainColor = Colors.amber.shade50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        toolbarHeight: 100,
        flexibleSpace: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 36),
                Text(
                  'Here are the results!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'See which color suits you best',
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
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: mainColor,
            ),
            child: Column(
              children: [
                const SizedBox(height: 15,),
                Container(
                  height: 200,
                  width: 200,// Set a height for the image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      image: FileImage(pickedImage), // Use the FileImage directly
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                if (seasonCategory != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Season Category: $seasonCategory',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                // const SizedBox(height: 10),
                if (skinTone != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detected Skin Tone:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black38,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(int.parse(
                                skinTone!.substring(1), radix: 16) +
                                0xFF000000),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        if (accuracy != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Accuracy: ${(accuracy!).toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black38,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        if (dominantColors != null) ...[
                          Text(
                            'Dominant Colors:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black38,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: dominantColors!.map((colorData) {
                              return Expanded(
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        colorData['color'].substring(1),
                                        radix: 16) +
                                        0xFF000000),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (colorPalette != null) ...[
                            Text(
                              'Recommended Colors:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black38,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 10),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(), // Disable scrolling
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: colorPalette!.length,
                              itemBuilder: (context, index) {
                                final entry = colorPalette!.entries.elementAt(index);
                                final color = Color(int.parse(
                                    entry.value.substring(1),
                                    radix: 16) +
                                    0xFF000000);
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              entry.key,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontFamily: 'Poppins',
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.black.withOpacity(0.8),
                                                    offset: Offset(1.0, 1.0),
                                                  ),
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                );
                              },
                            ),
                          ],
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const HomePage()));
                                },
                                child: Text(
                                  'Reselect Image',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                            ),
                            TextButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductsPage(season: seasonCategory!)));
                                },
                                child: Text(
                                  'See products',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600
                                  ),
                                )
                            ),
                          ],
                        ),

                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
