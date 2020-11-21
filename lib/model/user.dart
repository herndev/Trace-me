import 'package:flutter/foundation.dart';

class User extends ChangeNotifier{
  
  String type;
  
  setType(String _type){
    this.type = _type;
    notifyListeners();
  }
}