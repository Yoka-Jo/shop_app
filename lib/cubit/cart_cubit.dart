import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import '../data/cart_data.dart';
import '../data/order_data.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartProvider> {
  CartCubit() : super(CartProvider([]));




    Future <void> addToTheCart(List<OrderItem> orderItems , double total , String authToken , String userId) async{
    final url = 'https://shop-jumia-app-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();

      final response = await http.post(Uri.parse(url), body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': orderItems.map((item) =>
        {
          'id': item.id,
          'title': item.title,
          'price': item.price,
          'quantity': item.quantity,
        }).toList(),
      }));


    state.cartItems.insert(0, CartItem(
        dateTime: timeStamp,
        id: json.decode(response.body)['name'],
        amount: total,
        products: orderItems
    ));
    emit(CartProvider(state.cartItems));
  }

  Future<void> fetchAndSetCart(String authToken , String userId) async{
    print('fetchAndSetCart => $authToken');
    final url = 'https://shop-jumia-app-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    try{
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map <String , dynamic>;
      final List<CartItem> loadedCart = [];
      if(extractedData == null ){
        return;
      }
      extractedData.forEach((cartId, cartData) {
        loadedCart.add(CartItem(
          id: cartId,
          amount: cartData['amount'],
          dateTime: DateTime.parse(cartData['dateTime']),
          products: (cartData['products'] as List<dynamic>).map((item) => OrderItem(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quantity'],
          )).toList()
        ));
      });
      emit(CartProvider(loadedCart));
    }catch(error){
      throw(error);
    }
  }
  void reset(){
    emit(CartProvider([]));
  }
}
