import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/order_data.dart';

part 'orders_state.dart';

class OrderCubit extends Cubit<OrderProvider> {
  OrderCubit() : super(OrderProvider({}));


  int get itemCount {
    return state.orderItems.length;
  }

  double get totalAmount {
    var total = 0.0;
    state.orderItems.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title , String imageUrl) {
//    var url = 'https://gymapp-1a04c-default-rtdb.firebaseio.com/carts.json';

    if (state.orderItems.containsKey(productId)) {
      print('if');
      state.orderItems.update(
          productId,
              (existingCartItem) {
                return OrderItem(
                    imageUrl: existingCartItem.imageUrl,
                    id: existingCartItem.id,
                    title: existingCartItem.title,
                    quantity: existingCartItem.quantity + 1,
                    price: existingCartItem.price

                );
              });
      emit(OrderProvider(state.orderItems));
//      http.patch(url , body:
//      json.encode({
//        'imageUrl': existingCartItem.imageUrl,
//        'id': existingCartItem.id,
//        'title': existingCartItem.title,
//        'quantity': existingCartItem.quantity + 1,
//        'price': existingCartItem.price,
//      })
//      );
    }
    else {
      print('else');
      state.orderItems.putIfAbsent(
        productId,
            () => OrderItem(
            id: DateTime.now().toString(),
                imageUrl: imageUrl,
                title: title,
            quantity: 1,
            price: price),
      );
      emit(OrderProvider(state.orderItems));
    }
  }

  void removeItem(String productId) {
    state.orderItems.remove(productId);
    emit(OrderProvider(state.orderItems));
  }

  void removeSingleItem(String productId) {
    if (!state.orderItems.containsKey(productId)) {
      return;
    }
    if (state.orderItems[productId].quantity > 1) {
      state.orderItems.update(
          productId,
              (existingCardItem) => OrderItem(
                  imageUrl: existingCardItem.imageUrl,
                  id: existingCardItem.id,
              title: existingCardItem.title,
              quantity: existingCardItem.quantity - 1,
              price: existingCardItem.price));
    }
    else{
      state.orderItems.remove(productId);
    }
    emit(OrderProvider(state.orderItems));
  }

   void clear() {
    emit(OrderProvider({}));
  }


}
