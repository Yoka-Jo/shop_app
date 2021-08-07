import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import '../Helper/HttpException.dart';
import '../data/product_data.dart';
part 'manage_products_state.dart';

class ManageProductsCubit extends Cubit<LoadList> {
  List<Product> _items = [];
  List<String> nameList = [];

  ManageProductsCubit() : super(LoadList([]));


List<Product> get items{
  return [..._items];
}

  // List<String> itemsName() {
  //   String name = '';
  //   for (int i = 0; i < _items.length; i++) {
  //     name = _items[i].title;
  //     nameList.add(name);
  //   }
  //   return nameList;
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product , String authToken , String userId) async {
    final url =
        'https://shop-jumia-app-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'kind': product.kind,
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId,
      }),
    );
    final newProduct = Product(
        kind: product.kind,
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl);
    _items.add(newProduct);
    emit(LoadList(_items));
  }

  Future<void> fetchAndSetProducts([String authToken , String userId]) async {
    var url = 'https://shop-jumia-app-default-rtdb.firebaseio.com/products.json?auth=$authToken&';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url = 'https://shop-jumia-app-default-rtdb.firebaseio.com/favorite/$userId.json?auth=$authToken';
      final favouriteResponse = await http.get(Uri.parse(url));
      final favouriteData = json.decode(favouriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          kind: prodData['kind'],
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavourite:
              favouriteData == null ? false : favouriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      // itemsName();
      emit(LoadList(_items));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> deleteProduct(String id , String authToken) async {
    final url =
        'https://shop-jumia-app-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    emit(LoadList(_items));
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      emit(LoadList(_items));
      throw HttpException('Couldn\'t delete this product');
    }
    existingProduct = null;
  }

  Future<void> updateProduct(String id, Product newProduct , String authToken) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url =
        'https://shop-jumia-app-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'kind': newProduct.kind,
          'imageUrl': newProduct.imageUrl
        }));
    _items[prodIndex] = newProduct;
    emit(LoadList(_items));
  }
}
