import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traceme/page/auth.dart';
import 'package:traceme/page/profile.dart';
import 'package:traceme/page/status.dart';
import 'package:traceme/page/home.dart';
import 'package:traceme/service/authentication.dart';

import 'component/colors.dart';
import 'model/user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var pref = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ListenableProvider<UserData>(create: (_) => UserData()),
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/login",
        routes: {
          "/login": (context) {
            final firebaseUser = context.watch<User>();
            final udata = context.watch<UserData>();
            final userType = pref.getString("userType");

            if (firebaseUser != null) {
              if(userType != null){
                udata.setType(userType);
              }
              
              return Home();
            }
            return Login();
          },
          "/status": (context) => UpdateStatus(),
          "/history": (context) => HistoryStatus(),
          "/home": (context) => Home(),
          "/profile": (context) => Profile(),
        },
        theme: ThemeData(primaryColor: Hcolor().yellow),
      ),
    ),
  );
}
