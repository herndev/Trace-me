import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traceme/page/auth.dart';
import 'package:traceme/page/profile.dart';
import 'package:traceme/page/status.dart';
import 'package:traceme/page/home.dart';

import 'component/colors.dart';
import 'model/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => User(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/login",
        routes: {
          "/login": (context) => Login(),
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
