import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/model/user.dart';
import 'package:traceme/service/authentication.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:traceme/service/query.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var _scaffold = GlobalKey<ScaffoldState>();
  // var cameraScanResult = "";
  var que = Hquery();
  var _user = "";

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<UserData>(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffold,
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
        body: _user == ""
            ? Center(
                child: SpinKitFadingCube(
                  color: Colors.cyan[700],
                ),
              )
            : Container(
                child: Column(children: [
                  Expanded(
                    child: Center(
                        child: userType.type == "customer"
                            ? QrImage(
                                data: _user,
                                version: QrVersions.auto,
                                size: 200.0,
                              )
                            : TextButton(
                                child: RichText(
                                  text: TextSpan(
                                      text: "[ ",
                                      children: [
                                        TextSpan(
                                            text: "QR Scan",
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.black)),
                                        TextSpan(
                                            text: " ]",
                                            style: TextStyle(fontSize: 32))
                                      ],
                                      style: TextStyle(
                                          fontSize: 32, color: Colors.red)),
                                ),
                                onPressed: () async {
                                  var sc = await scanner.scan();
                                  var data = {
                                    "userID": sc
                                  };

                                  showAlertDialog(context, data);
                                  // setState(() {
                                  //   cameraScanResult = sc;
                                  // });
                                },
                              )),
                  ),
                  // if (userType.type != "customer")
                  // Text(cameraScanResult == null ? "No data" : cameraScanResult),
                  if (userType.type == "customer")
                    Container(
                      height: 64,
                      width: double.infinity,
                      child: RaisedButton(
                        color: Color.fromRGBO(255, 204, 51, 1),
                        child: Text("Update data",
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)),
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

  Future<void> getUser() async {
    var pref = await SharedPreferences.getInstance();

    if (pref.getString("user") != null) {
      var _tempUser =
          await que.getKeyByData("users", "email", pref.getString("user"));

      setState(() {
        _user = _tempUser;
      });
    }
  }


  showAlertDialog(context, data) {
    // set up the buttons
    // Widget cancelButton = FlatButton(
    //   child: Text("Cancel"),
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    // );
    Widget continueButton = FlatButton(
      child: Text("Verify"),
      onPressed: () async {
        Navigator.pop(context);
        _scaffold.currentState
            .showSnackBar(SnackBar(content: Text("Pushing data..")));
        // await que.push("status", data);
        // Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Trace me"),
      content: Text("Do you want to update status now?"),
      actions: [
        // cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
