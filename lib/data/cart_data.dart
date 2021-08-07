import 'order_data.dart';
class CartItem{
  final String id;
  final double amount;
  final List<OrderItem> products;
  final DateTime dateTime;

  CartItem({this.id, this.amount, this.products, this.dateTime});



}
