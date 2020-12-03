import 'package:firebase_auth/firebase_auth.dart';
import 'package:traceme/service/query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final que = Hquery();

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Future<void> signOut() async {
    var pref = await SharedPreferences.getInstance();

    await pref.remove("userType");
    await pref.remove("user");
    await _firebaseAuth.signOut();
  }


  Future<String> signIn({String email, String password}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var u = await que.getDataByData("users", "email", email);
      await pref.setString("userType", u['userType']);
      await pref.setString("user", email);
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}  