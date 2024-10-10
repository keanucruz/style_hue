import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductList {
  final int id;
  final String name;
  final String type;
  final String color;
  final String brand;

  const ProductList({
    required this.id,
    required this.name,
    required this.type,
    required this.color,
    required this.brand,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) {
    return ProductList(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      color: json['color'],
      brand: json['brand'],
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.season});
  final String season;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<ProductList>> futureProducts;
  Color secondaryColor = const Color(0xFFFFE4CC);
  Color mainColor = Colors.amber.shade50;

  Future<List<ProductList>> fetchProducts() async {
    final season = widget.season.toLowerCase();
    final response =
    await http.get(Uri.parse('http://192.168.18.211:3009/api/products/$season'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = jsonDecode(response.body);

      List<dynamic> jsonList = jsonMap[season];

      if (jsonList != null) {
        return jsonList.map((item) => ProductList.fromJson(item)).toList();
      } else {
        throw Exception('No products found for the season: $season');
      }
    } else {
      throw Exception('Failed to load products: ${response.reasonPhrase}');
    }
  }

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  List<ProductList> filterProductsByType(List<ProductList> products, String type) {
    return products.where((product) => product.type == type).toList();
  }

  Widget buildProductGrid(String title, List<ProductList> products) {
    if (products.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  product.type == 'clothes'
                      ? Image.asset('lib/assets/images/clothes_icon.png',
                      width: 50, height: 50)
                      : product.type == 'bottoms'
                      ? Image.asset('lib/assets/images/bottoms_icon.png',
                      width: 50, height: 50)
                      : Image.asset('lib/assets/images/cosmetics_icon.png',
                      width: 50, height: 50),
                  const SizedBox(height: 8),
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Color: ${product.color}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Brand: ${product.brand}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainColor,
        toolbarHeight: 90,
        flexibleSpace: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),
                Text(
                  'Products for ${widget.season} Season',
                  style: const TextStyle(
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
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ProductList>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            final clothes = filterProductsByType(snapshot.data!, 'clothes');
            final bottoms = filterProductsByType(snapshot.data!, 'bottoms');
            final cosmetic = filterProductsByType(snapshot.data!, 'cosmetic');

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProductGrid('Clothes', clothes),
                  buildProductGrid('Bottoms', bottoms),
                  buildProductGrid('Cosmetics', cosmetic),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
