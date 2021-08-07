import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/orders_cubit.dart';
import '../data/order_data.dart';
class OrderList extends StatelessWidget {
  final OrderCubit cart;
  final List <OrderItem> cartList;
  final List <String> cartKey;

   OrderList(this.cart, this.cartList , this.cartKey);
  @override
  Widget build(BuildContext context) {
    print(cart.totalAmount);
    return Expanded(
        child: ListView.builder(
            itemCount:cart.itemCount,
            itemBuilder: (context , i){
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: ValueKey(cartList[i].id),
                confirmDismiss: (direction){
                  return showDialog(
                    context: context,
                    builder: (ctx)=> AlertDialog(
                      title: Text('Are You Sure!'),
                      content: Text('You\'re about to delete this one'),
                      actions: [
                        TextButton(
                          child: Text('No' , style: TextStyle(color:Colors.amber),),
                          onPressed: ()=>Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text('Yes' , style: TextStyle(color: Colors.red),),
                          onPressed: ()=>Navigator.of(context).pop(true),
                        )
                      ],
                    )
                  );
                },
                onDismissed: (direction){
                  BlocProvider.of<OrderCubit>(context).removeItem(cartKey[i]);
                },
                background: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Icon(Icons.delete , size: 60, color: Colors.white,),
                    ),
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black26 ,
                      offset: Offset(0, 4),
                      blurRadius: 5,
                        spreadRadius: 5
                      ),
                    ],
                    color: Colors.white70,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage(cartList[i].imageUrl),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      SizedBox(width: 60,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cartList[i].title),
                          Row(
                            children: [
                              Text('\$${cartList[i].price..toString()}', style: TextStyle(color: Colors.deepOrangeAccent),),
                              SizedBox(width: 10,),
                              Text('${cartList[i].quantity.toString()}x'),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
        ),
    );
  }
}
