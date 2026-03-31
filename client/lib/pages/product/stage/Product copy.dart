import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_1riel/Environment.dart';
import 'package:app_1riel/navigators/Routes.dart';
import 'package:app_1riel/utilities/Debug.dart';
import 'package:app_1riel/themes/Theme_Data.dart';
import 'package:app_1riel/navigators/Main_Drawer.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: TITLE, theme: Theme_Data.get_theme(), home: const ProductPage(), routes: Routes.routes, debugShowCheckedModeBanner: false);
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final Dio dio;
  late final TextEditingController searchController;
  late final ScrollController listViewController;

  final List<Map<String, dynamic>> allProducts = [];
  Timer? debounceTimer;
  bool isSearching = false;
  bool hasMore = true;
  static const int limit = 100;

  @override
  void initState() {
    super.initState();
    dio = Dio(BaseOptions(baseUrl: API_HOST, connectTimeout: const Duration(seconds: 10), sendTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 10)));
    searchController = TextEditingController();
    listViewController = ScrollController();
    _loadProducts();
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    searchController.dispose();
    listViewController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts({String query = '', int offset = 0}) async {
    try {
      final response = await dio.post('/product/read', data: FormData.fromMap({'query': query, if (offset > 0) 'offset': offset}));

      if (response.data is List) {
        final products = List<Map<String, dynamic>>.from(response.data);
        setState(() {
          if (offset == 0) {
            allProducts.clear();
          }
          allProducts.addAll(products);
          hasMore = products.length >= limit;
        });
      }
    } catch (e) {
      debug('Error loading products: $e');
    }
  }

  void _onSearch(String query) {
    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 200), () {
      _loadProducts(query: query);
      listViewController.jumpTo(0);
    });
  }

  void _loadMore() {
    if (hasMore) {
      _loadProducts(query: searchController.text, offset: allProducts.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Search...', border: InputBorder.none),
                onChanged: _onSearch,
              )
            : const Text('Product'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  _loadProducts();
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: listViewController,
        itemCount: allProducts.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == allProducts.length) {
            _loadMore();
            return const Center(
              child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
            );
          }
          return _buildProductTile(allProducts[index], index);
        },
      ),
      drawer: Main_Drawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton(onPressed: () => debug('Add product'), child: const Icon(Icons.add)),
      ),
    );
  }

  Widget _buildProductTile(Map<String, dynamic> product, int index) {
    return ListTile(
      key: ValueKey(product['order']),
      title: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(product),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index. ${product['name'] ?? "N/A"}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    product['description'] ?? 'N/A',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  _buildProductFooter(product),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () => debug('view'),
    );
  }

  Widget _buildProductImage(Map<String, dynamic> product) {
    final imageUrl = product['images'] is List && (product['images'] as List).isNotEmpty ? '${product['images'][0]}' : null;

    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[300],
      child: imageUrl != null ? Image.network('$API_HOST/public/$imageUrl?w=100&h=100', fit: BoxFit.cover, errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 100)) : const Icon(Icons.image_not_supported, size: 100),
    );
  }

  Widget _buildProductFooter(Map<String, dynamic> product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(product['rating']?.toStringAsFixed(2) ?? 'N/A', style: const TextStyle(fontSize: 16, color: Colors.orange)),
            const Icon(Icons.star, color: Colors.orange, size: 18),
          ],
        ),
        Text(
          '${product['price'] ?? "N/A"} KHR',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ],
    );
  }
}
