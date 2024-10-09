import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultsScreen extends StatefulWidget {
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
    required this.colorPalette,
  });

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<dynamic> products = [];

  // Fetch products from the backend
  Future<void> fetchProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3009/get_products'));
      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Convert hex color to RGB
  Color hexToColor(String hexColor) {
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.replaceFirst('#', '0xff');
    }
    return Color(int.parse(hexColor));
  }

  // Check if the product color matches the recommended color palette
  bool isColorWithinRecommendedPalette(String productColorHex) {
    if (widget.colorPalette == null) return false;

    Color productColor = hexToColor(productColorHex);

    for (String paletteColorHex in widget.colorPalette!.values) {
      Color paletteColor = hexToColor(paletteColorHex);

      // Use a simple distance calculation (could be more advanced like Delta-E)
      double distance = colorDistance(productColor, paletteColor);
      if (distance < 50.0) {
        // Adjust the threshold for similarity
        return true;
      }
    }
    return false;
  }

  // Calculate color distance using RGB (simple method)
  double colorDistance(Color c1, Color c2) {
    return ((c1.red - c2.red).abs() +
            (c1.green - c2.green).abs() +
            (c1.blue - c2.blue).abs()) /
        3.0;
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber.shade50,
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
          children: [
            Center(
              child: Container(
                height: 600,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.amber.shade50,
                ),
                child: Column(
                  children: [
                    if (widget.skinTone != null)
                      Text('Detected Skin Tone: ${widget.skinTone}',
                          style: TextStyle(fontSize: 18)),
                    if (widget.accuracy != null)
                      Text(
                          'Accuracy: ${(widget.accuracy!).toStringAsFixed(2)}%',
                          style: TextStyle(fontSize: 18)),
                    if (widget.seasonCategory != null)
                      Text('Season Category: ${widget.seasonCategory}',
                          style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),

                    if (widget.dominantColors != null)
                      Text('Dominant Colors:', style: TextStyle(fontSize: 18)),

                    // Display dominant colors
                    if (widget.dominantColors != null)
                      Row(
                        children: widget.dominantColors!.map((colorData) {
                          if (colorData is Map<String, dynamic> &&
                              colorData.containsKey('color')) {
                            String hexColor = colorData['color'].toString();
                            return Container(
                              margin: EdgeInsets.all(4.0),
                              width: 50,
                              height: 50,
                              color: hexToColor(hexColor),
                            );
                          } else {
                            return SizedBox();
                          }
                        }).toList(),
                      ),

                    if (widget.colorPalette != null)
                      ...widget.colorPalette!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),

                    // Show matching products
                    SizedBox(height: 20),
                    Text('Matching Products:', style: TextStyle(fontSize: 18)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          String productColor = product['color'] ?? '';

                          // Check if product color matches the recommended palette
                          if (isColorWithinRecommendedPalette(productColor)) {
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: Image.network(
                                  'http://localhost:3009/${product['image_path']}',
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(product['name']),
                                subtitle: Text(
                                  'Manufacturer: ${product['manufacturer']}\nColor: $productColor',
                                ),
                                trailing: Container(
                                  width: 24,
                                  height: 24,
                                  color: hexToColor(productColor),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox(); // Skip non-matching products
                          }
                        },
                      ),
                    ),
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
