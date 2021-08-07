import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cart_cubit.dart';
import '../widgets/cart_Item.dart';
class CartScreen extends StatefulWidget {
  static const routeName = '/OrdersScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = false;
  bool isBuilt = true;

  @override
  void didChangeDependencies() {
    final auth = ModalRoute.of(context).settings.arguments as Map<String , String>;
    if(isBuilt){
      setState((){
        isLoading = true;
      });
      BlocProvider.of<CartCubit>(context).fetchAndSetCart(auth['authToken'] , auth['userId']).then((value) =>
          setState((){
        isLoading = false;
      }));
    }
    isBuilt = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
      )) : BlocBuilder<CartCubit , CartProvider>(
    builder: (context , state) {
      final cartList = state.cartItems;
      return ListView.builder(
          itemCount: cartList.length,
          itemBuilder: (context, i) {
            return CartList(cartList: cartList[i]);
          });
    }
      ),
    );
  }
}
