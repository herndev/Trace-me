import 'package:flutter/material.dart';
import 'package:traceme/page/auth.dart';

import 'component/colors.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/auth",
      routes: {
        "/auth": (context) => Login(),
        "/newuser": (context) => NewUser()
      },
      theme: ThemeData(
        primaryColor: Hcolor().yellow
      ),
    ),
  );
}
