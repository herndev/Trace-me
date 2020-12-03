import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/component/input.dart';
import 'package:traceme/model/history.dart';
// import 'package:traceme/model/user.dart';
import 'package:traceme/service/authentication.dart';
import 'package:traceme/service/query.dart';
import 'package:traceme/service/time.dart';

// Update status
class UpdateStatus extends StatefulWidget {
  @override
  _UpdateStatusState createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  Map<String, dynamic> questions = {
    "Travel history?": false,
    "Are you having headache?": false,
    "Having cough and colds?": false,
    "Sore Throat": false,
    "Fever for the past few days?": false,
    "have you worked together or stayed close with confirmed COVID 19 patient?":
        false,
    "Have you had any contact with anyone with fever, cough, colds and sore throat in the past 2 weeks?":
        false,
    "Are you an Overseas Filipino Worker that was just back here in your place?":
        false
  };

  List<String> questionKeys;
  var _scaffold = GlobalKey<ScaffoldState>();
  var temperature = TextEditingController();
  var que = Hquery();
  var ti = Htime();
  var updating = true;
  var userID;
  var timeStamp;

  @override
  void initState() {
    setState(() {
      questionKeys = questions.keys.toList();
    });

    getUserID();
    super.initState();
  }


  @override
  void dispose() {
    temperature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final userType = Provider.of<UserData>(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        key: _scaffold,
        appBar: normalAppBar(context: context),
        // mainAppBar(
        //     context: context,
        //     itemBuilder: (context) => [
        //           if (userType.type == "customer")
        //             PopupMenuItem(value: 1, child: Text("Profile")),
        //           if (userType.type == "customer")
        //             PopupMenuItem(value: 4, child: Text("History")),
        //           if (userType.type != "customer")
        //             PopupMenuItem(value: 2, child: Text("Download csv")),
        //           PopupMenuItem(value: 3, child: Text("Logout")),
        //         ],
        //     onSelected: (p) {
        //       if (p == 1) {
        //         Navigator.pushNamed(context, "/profile");
        //       }
        //       if (p == 3) {
        //         Navigator.pushNamed(context, "/login");
        //       }
        //       if (p == 4) {
        //         Navigator.pushNamed(context, "/history");
        //       }
        //     }),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: StreamBuilder(
                        stream: que.getSnapSortedR("status", "timestamp"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var snap = snapshot.data.documents;

                            for (var i in snap) {
                              if (userID == i['userID'] && timeStamp == null) {
                                timeStamp = i['timestamp'];
                              }
                            }

                            return Row(
                              // width: double.infinity,
                              children: [
                                Text("Last updated",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange)),
                                Spacer(),
                                Text("${timeStamp == null ? "" : timeStamp}",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.orange))
                              ],
                            );
                          } else {
                            return SizedBox();
                          }
                        }

                        // Row(children: [
                        //   Text("Last updated 10/16/2020",
                        //       style: TextStyle(fontSize: 18, color: Colors.orange)),
                        //   Spacer(),
                        //   Text("10:32 AM",
                        //       style: TextStyle(fontSize: 18, color: Colors.orange)),
                        // ]),
                        ),
                  ),
                ),
                Card(
                  child: inputField(
                      controller: temperature,
                      validator: null,
                      icon: Icon(Icons.device_thermostat),
                      hint: "Temperature"),
                ),
                SizedBox(height: 3),
                Container(
                  height: size.height - 290,
                  child: ListView.builder(
                    itemCount: questionKeys.length,
                    itemBuilder: (_, int i) {
                      return Card(
                        child: ListTile(
                          leading: Checkbox(
                              value: questions[questionKeys[i]],
                              onChanged: (value) {
                                setState(() {
                                  questions[questionKeys[i]] = value;
                                });
                              }),
                          title: Text(questionKeys[i]),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            )),
            Container(
              height: 64,
              width: double.infinity,
              child: RaisedButton(
                color: Color.fromRGBO(255, 204, 51, 1),
                child: Text("Update now",
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                onPressed: () async {
                  var valTemp = false;

                  try{
                    var t = int.parse(temperature.text);
                    if(t > 0){
                      valTemp = true;
                    }
                  }catch(e){
                    print(e);
                  }


                  if (!updating && valTemp) {

                    // // Process data
                    var data = questions;
                    data['userID'] = userID;
                    data['timestamp'] = ti.getTimeStamp();
                    data['temperature'] = int.parse(temperature.text);

                    showAlertDialog(context, data);
                  }
                },
              ),
            )
          ]),
        ),
      ),
    );
  }

  Future<void> getUserID() async {
    var pref = await SharedPreferences.getInstance();
    var _user =
        await que.getKeyByData("users", "email", pref.getString("user"));

    setState(() {
      userID = _user;
      updating = false;
    });
  }

  showAlertDialog(context, data) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Proceed"),
      onPressed: () async {
        Navigator.pop(context);
        _scaffold.currentState
            .showSnackBar(SnackBar(content: Text("Updating status")));
        await que.push("status", data);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Trace me"),
      content: Text("Do you want to update status now?"),
      actions: [
        cancelButton,
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

// History status
class HistoryStatus extends StatefulWidget {
  @override
  _HistoryStatusState createState() => _HistoryStatusState();
}

class _HistoryStatusState extends State<HistoryStatus> {
  List<History> histories = [];
  List<String> questionKeys;
  var auth = AuthenticationService(FirebaseAuth.instance);

  @override
  void initState() {
    setState(() {
      histories.add(
          History(company: "Mang kanor", date: "10/11/2020", time: "10:00 AM"));
      histories.add(
          History(company: "Jollibee", date: "10/11/2020", time: "10:00 AM"));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final userType = Provider.of<UserData>(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: normalAppBar(context: context),
        // mainAppBar(
        //     context: context,
        //     itemBuilder: (context) => [
        //           if (userType.type == "customer")
        //             PopupMenuItem(value: 1, child: Text("Profile")),
        //           if (userType.type == "customer")
        //             PopupMenuItem(value: 4, child: Text("History")),
        //           if (userType.type != "customer")
        //             PopupMenuItem(value: 2, child: Text("Download csv")),
        //           PopupMenuItem(value: 3, child: Text("Logout")),
        //         ],
        //     onSelected: (p) {
        //       if (p == 1) {
        //         Navigator.pushNamed(context, "/profile");
        //       }
        //       if (p == 3) {
        //         auth.signOut();
        //       }
        //       if (p == 4) {
        //         Navigator.pushNamed(context, "/history");
        //       }
        //     }),
        body: Container(
          child: Column(children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(children: [
                      Text("Last updated 10/16/2020",
                          style: TextStyle(fontSize: 18, color: Colors.orange)),
                      Spacer(),
                      Text("10:32 AM",
                          style: TextStyle(fontSize: 18, color: Colors.orange)),
                    ]),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: size.height - 170,
                  child: ListView.builder(
                    itemCount: histories.length,
                    itemBuilder: (_, int i) {
                      return Card(
                        shape: Border(
                            left:
                                BorderSide(width: 5, color: Colors.cyan[700])),
                        child: ListTile(
                          title: Text(histories[i].company),
                          subtitle: Row(children: [
                            Text(histories[i].date),
                            Spacer(),
                            Text(histories[i].time)
                          ]),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ))
          ]),
        ),
      ),
    );
  }
}
