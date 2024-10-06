import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final String? skinTone;
  final double? accuracy;
  final List<dynamic>? dominantColors;
  final String? seasonCategory;
  final Map<String, String>? colorPalette;


   ResultsScreen({
    super.key,
    required this.skinTone,
    required this.accuracy,
    required this.dominantColors,
    required this.seasonCategory,
    required this.colorPalette, });

  Color secondaryColor = const Color(0xFFFFE4CC);
  Color mainColor =  Colors.amber.shade50;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 600,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: mainColor
                ),
                child: Column(
                  children: [
                    if (skinTone != null)
                      Text('Detected Skin Tone: $skinTone', style: TextStyle(fontSize: 18)),
                    if (accuracy != null)
                      Text('Accuracy: ${(accuracy!).toStringAsFixed(2)}%', style: TextStyle(fontSize: 18)),
                    if (seasonCategory != null)
                      Text('Season Category: $seasonCategory', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),

                    if (dominantColors != null)
                      Text('Dominant Colors:', style: TextStyle(fontSize: 18)),

                    // Display dominant colors
                    if (dominantColors != null)
                      Row(
                        children: dominantColors!.map((colorData) {
                          // Check if the current element is a map with a color field
                          if (colorData is Map<String, dynamic> && colorData.containsKey('color')) {
                            String hexColor = colorData['color'].toString();
                            if (hexColor.startsWith('#')) {
                              hexColor = hexColor.replaceFirst('#', '0xff');
                            }
                            return Container(
                              margin: EdgeInsets.all(4.0),
                              width: 50,
                              height: 50,
                              color: Color(int.parse(hexColor)), // Convert the hex color to a Color object
                            );
                          } else {
                            return SizedBox(); // Return an empty widget if colorData is invalid
                          }
                        }).toList(),
                      ),

                    if (colorPalette != null)
                      ...colorPalette!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
