import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traceme/page/admin.dart';
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
            final usr = context.watch<UserData>();

            if (firebaseUser != null && usr.type != "admin") {
              return Home();
            }else if(usr.type == "admin"){
              return Admin();
            }

            return Login();
          },
          "/status": (context) => UpdateStatus(),
          "/history": (context) => HistoryStatus(),
          "/home": (context) => Home(),
          "/profile": (context) => Profile(),
          "/admin": (context) => Admin(),
        },
        theme: ThemeData(primaryColor: Hcolor().yellow),
      ),
    ),
  );
}
