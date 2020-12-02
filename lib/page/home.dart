import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/model/user.dart';
import 'package:traceme/service/authentication.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:traceme/service/query.dart';

class Home extends StatefulWidget {
  // final userType;
  // Home({this.userType: "customer"});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var que = Hquery();
  var _userType;
  var _user;

  @override
  void initState() {
    super.initState();
    updateUserType();
    getUID();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<UserData>(context);

    if (_userType != null) {
      userType.setType(_userType);
    }

    return SafeArea(
      child: Scaffold(
        appBar: mainAppBar(
            context: context,
            goto: "none",
            itemBuilder: (context) => [
                  if (userType.type == "customer")
                    PopupMenuItem(value: 1, child: Text("Profile")),
                  if (userType.type == "customer")
                    PopupMenuItem(value: 4, child: Text("History")),
                  if (userType.type != "customer")
                    PopupMenuItem(value: 2, child: Text("Download csv")),
                  PopupMenuItem(value: 3, child: Text("Logout")),
                ],
            onSelected: (p) {
              if (p == 1) {
                Navigator.pushNamed(context, "/profile");
              }
              if (p == 3) {
                auth.signOut();
              }
              if (p == 4) {
                Navigator.pushNamed(context, "/history");
              }
            }),
        body: Container(
          child: Column(children: [
            // Camera
            Expanded(
              child: Center(
                  child: userType.type == "customer"
                      ? QrImage(data: _user != null ? _user : "")
                      : TextButton(
                          child: RichText(
                            text: TextSpan(
                                text: "[ ",
                                children: [
                                  TextSpan(
                                      text: "QR Scan",
                                      style: TextStyle(
                                          fontSize: 24, color: Colors.black)),
                                  TextSpan(
                                      text: " ]",
                                      style: TextStyle(fontSize: 32))
                                ],
                                style:
                                    TextStyle(fontSize: 32, color: Colors.red)),
                          ),
                          onPressed: () {},
                        )),
            ),
            if (userType.type == "customer")
              Container(
                height: 64,
                width: double.infinity,
                child: RaisedButton(
                  color: Color.fromRGBO(255, 204, 51, 1),
                  child: Text("Update data",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  onPressed: () {
                    Navigator.pushNamed(context, "/status");
                  },
                ),
              )
          ]),
        ),
      ),
    );
  }

  Future<void> updateUserType() async {
    var pref = await SharedPreferences.getInstance();
    // var udata = context.watch<UserData>();
    setState(() {
      _userType = pref.getString("userType");
    });

    // if (userType != null) {
    // udata.setType(userType);
    // }
  }

  Future<void> getUID() async {
    var pref = await SharedPreferences.getInstance();

    setState(() {
      _user = que.getKeyByData("users", "email", pref.getString("user"));
    });
  }
}
