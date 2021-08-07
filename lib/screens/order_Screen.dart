import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/orders_cubit.dart';
import '../widgets/order_list.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/CartScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isOrder = false;
  @override
  Widget build(BuildContext context) {
    final auth = ModalRoute.of(context).settings.arguments as Map<String , Object>; 
    final totalAmount =  BlocProvider.of<OrderCubit>(context).totalAmount;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<OrderCubit, OrderProvider>(builder: (context, state) {
        return Column(
          children: [
            OrderList(BlocProvider.of<OrderCubit>(context),
                state.orderItems.values.toList() , state.orderItems.keys.toList()),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 6),
                              height: 25,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  BlocProvider.of<OrderCubit>(context)
                                      .totalAmount
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              )),
                        ],
                      ),
                      TextButton(
                        onPressed: (totalAmount<=0 || isOrder) ? null : () async{
                          setState((){
                            isOrder = true;
                          });
                          await BlocProvider.of<CartCubit>(context)
                              .addToTheCart(state.orderItems.values.toList() ,totalAmount , auth['authToken'] , auth['userId']);
                          setState((){
                            isOrder = false;
                          });

                          BlocProvider.of<OrderCubit>(context)
                          .clear();
                        },
                        child: Center(
                            child: isOrder ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                            ):Text(
                          'Order Now',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20 , color: Colors.amber.shade800),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
