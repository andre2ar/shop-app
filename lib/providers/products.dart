import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/models/http_exception.dart';

import 'package:shopapp/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  final String authToken;

  Products(this.authToken, this._items);

  List<Product> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://flutterstore-42eae.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavourite: prodData['isFavourite'],
            imageUrl: prodData['imageUrl']));
      });

      _items = loadedProducts;
    } catch (e) {
      throw (e);
    }

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutterstore-42eae.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite,
          },
        ),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );

      _items.add(newProduct);

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutterstore-42eae.firebaseio.com/products/$id.json?auth=$authToken';

      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      _items[prodIndex] = newProduct;
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutterstore-42eae.firebaseio.com/products/$id.json?auth=$authToken';

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException('Could not delete product.');
    }

    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
