import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product  with ChangeNotifier{
  final String kind;
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({@required this.kind,@required this.id,@required this.title,@required this.description,@required this.price,
  @required this.imageUrl,this.isFavourite = false});

  void _setFavValue(bool newValue){
    isFavourite = !isFavourite;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String userId , String id , String authToken) async {
    final url = 'https://shop-jumia-app-default-rtdb.firebaseio.com/favorite/$userId/$id.json?auth=$authToken';
    final oldValue = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    
    try {

      final response = await http.put(Uri.parse(url) , body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        _setFavValue(oldValue);
      }
    } catch (error) {
      _setFavValue(oldValue);
    }
  }
}

















