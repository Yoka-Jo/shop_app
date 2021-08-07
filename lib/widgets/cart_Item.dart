import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/cart_data.dart';

class CartList extends StatefulWidget {
  final CartItem cartList;

  const CartList({Key key, this.cartList}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  var _expand = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _expand
          ? min(widget.cartList.products.length * 20.0 + 110.0, 200.0)
          : 95,
      duration: Duration(milliseconds: 300),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text('Total: '),
                  Text(
                    '${widget.cartList.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '\$',
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm')
                  .format(widget.cartList.dateTime)),
              trailing: IconButton(
                icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
              ),
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: _expand
                    ? min(widget.cartList.products.length * 20.0 + 15.0, 58.0)
                    : 0,
                child: ListView(
                    children: widget.cartList.products
                        .map((item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${item.quantity}',
                                        style: TextStyle(
                                            color: Colors.deepPurpleAccent,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                    Row(
                                      children: [
                                        Text('x',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('${item.price}',
                                            style: TextStyle(
                                                color: Colors.deepPurpleAccent,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                        Text('\$',
                                            style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ))
                        .toList())),
          ],
        ),
      ),
    );
  }
}
