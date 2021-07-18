import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SymbolProvider with ChangeNotifier {

  setSymbol(String symbol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Symbol', symbol);
    notifyListeners();
  }

  Future<String> getSymbol() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String a = prefs.getString('Symbol');
    if(a == null){
      return "\$";
    }
    else{
      return a;
    }
  }
}