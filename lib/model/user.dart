import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData extends ChangeNotifier{
  
  String type;

  UserData() {
    setupSavedData();
  }

  setupSavedData() async{
    var pref = await SharedPreferences.getInstance();
    if(pref.getString("userType") != null){
      this.type = pref.getString("userType");
    }
  }
  
  setType(String _type){
    this.type = _type;
    notifyListeners();
  }
}