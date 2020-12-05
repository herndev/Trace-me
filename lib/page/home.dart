import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/model/sensitive_data.dart';
import 'package:traceme/model/user.dart';
import 'package:traceme/service/authentication.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:traceme/service/csv.dart';
import 'package:traceme/service/query.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:traceme/service/time.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var _scaffold = GlobalKey<ScaffoldState>();
  var que = Hquery();
  var ti = Htime();
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
            onSelected: (p) async {
              if (p == 1) {
                Navigator.pushNamed(context, "/profile");
              }
              if (p == 2) {
                _scaffold.currentState.showSnackBar(
                    SnackBar(content: Text("Downloading csv data..")));
                var ids = await que.getIDs("traced");
                var data = [];

                for (var i in ids) {
                  var t = await que.getDataByID("traced", i);
                  if (t['employee'] == _user) {
                    data.add(Customer(
                        userID: t['userID'],
                        timestamp: t['timestamp'],
                        temperature: t['temperature']));
                  }
                }

                // var data = await que.getDataByData("traced", "employee", _user);
                var r = await getCsv(data);
                if( r == "No access to directories"){
                  _scaffold.currentState.showSnackBar(
                    SnackBar(content: Text("No access to directories"), duration: Duration(milliseconds: 200),));
                }else{
                  _scaffold.currentState.showSnackBar(
                    SnackBar(content: Text("Saved @ $r"), duration: Duration(seconds: 5),));
                }
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
                                  var valCode = await que.checkID("users", sc);

                                  if (valCode) {
                                    var _data =
                                        await que.getDataByID("users", sc);
                                    var valStatus = await que.getKeyByData(
                                        "status", "userID", sc);

                                    var latest = {
                                      "key": "",
                                      "timestamp": "0000-00-00 00:00:00"
                                    };
                                    var ids = await que.getIDs("status");

                                    for (var i in ids) {
                                      var s =
                                          await que.getDataByID("status", i);
                                      if (latest['timestamp']
                                              .compareTo(s['timestamp']) <
                                          0) {
                                        latest['timestamp'] = s['timestamp'];
                                        latest['key'] = i;
                                      }
                                    }

                                    if (valStatus != null &&
                                        valStatus != {} &&
                                        latest['timestamp'] !=
                                            "0000-00-00 00:00:00") {
                                      var data = {
                                        "userID": sc,
                                        "name": _data['name'],
                                        "statusKey": latest['key'],
                                        "employee": _user,
                                        "timestamp": ti.getTimeStamp()
                                      };

                                      showAlertDialog(context, data);
                                    }
                                  }
                                },
                              )),
                  ),
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
        var d = await que.getDataByID("users", _user);
        var company = d['company'];
        var _data = data;
        _data['company'] = company;

        _scaffold.currentState
            .showSnackBar(SnackBar(content: Text("Pushing data..")));

        await que.push("traced", data);

        _scaffold.currentState.showSnackBar(SnackBar(
            duration: Duration(milliseconds: 250),
            content: Text("Data pushed")));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Trace me"),
      content: Container(
          child: Text("USER ID: ${data['userID']} \n\nVerify this user?")),
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
