import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_jumia_app/Helper/HttpException.dart';

class Authentication with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

   bool get isAuth{
     return token != null;
   }

  String get  userId{
     return _userId;
   }

   String get token{
     if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
       return _token;
     }
     else{
     return null;
     }
   }

    Future<void> authenticate(String chain , String email , String password) async{
     final url = "https://identitytoolkit.googleapis.com/v1/accounts:$chain?key=AIzaSyBul7JdPL46CZoMuMIrm0Z7rJOhYDORvEI";

    final response = await http.post(Uri.parse(url) , body: json.encode({'email': email, 'password': password, 'returnSecureToken': true}),);
       final responseData = json.decode(response.body);
         if(responseData['error'] != null){
           throw HttpException(responseData['error']['message']);
         }
       _token = responseData['idToken'];
       _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']))) ;
       _userId = responseData['localId'];
       _autoLogout();
       notifyListeners();
       final prefs = await SharedPreferences.getInstance();
       final userData = json.encode({'token': _token , 'userId': _userId , 'expiryDate': _expiryDate.toIso8601String() });
       prefs.setString('userData', userData);

    }

  Future<void> signUp({String email , String password}) {
    return authenticate('signUp' , email , password);
  }

  Future<void> signIn({String email , String password}) {
    return authenticate('signInWithPassword' , email , password);
  }

  Future<bool> tryAutoLogin () async {
  final prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('userData')){
    return false;
  }
  final extractedUserData = json.decode(prefs.getString('userData')) as Map<String , Object>;
  final expiryData = DateTime.parse(extractedUserData['expiryDate']);
  
  if(expiryData.isBefore(DateTime.now())){
      return false;
  }
  _token = extractedUserData['token'];
  _expiryDate = DateTime.parse(extractedUserData['expiryDate']);
  _userId = extractedUserData['userId'];
   notifyListeners();
   _autoLogout();
   return true;
  }

  Future<void> logOut() async{
    _token = null;
    _userId =null;
    _expiryDate = null;
     if(_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout (){
    if(_authTimer != null){
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry) , logOut);
  }
}