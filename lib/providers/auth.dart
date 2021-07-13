import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get auth{
    return token!=null;
  }

  String get token{
    if(_token!=null&&_expiryDate!=null&&_expiryDate.isAfter(DateTime.now())){
      print(_token.toString());
      return _token;
    }
    print(_token.toString());
    print('>>>>>>>>>>');
    return null;
  }
  Future<void> _authenticate(String email, String password,
      String segment) async {
    final url =
    Uri.parse(
        "https://www.googleapis.com/identitytoolkit/v3/relyingparty/$segment?key=AIzaSyCMBWWXF8gQnHfVHfmnv_jRUHK6uhBQL88");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final extractData = json.decode(response.body);
      if(response.statusCode!=200){
      print(extractData.toString());
      throw extractData['error']['message'];
      }
      _token=extractData['idToken'];
      _userId=extractData['localId'];
      _expiryDate= DateTime.now().add(Duration(seconds: int.tryParse(extractData['expiresIn'])));
        print(json.decode(response.body));
    }catch(error){
   //  print("###################$error");
     throw error;
    }
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
   return  _authenticate(email, password, 'verifyPassword');
  }

  Future<void> signUp(String email, String password) async {
     return _authenticate(email, password, 'signupNewUser');
  }
}