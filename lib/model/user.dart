import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier{
  
  String type;
  
  setType(String _type){
    this.type = _type;
    notifyListeners();
  }
}