import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/model/history.dart';
import 'package:traceme/model/sensitive_data.dart';
import 'package:traceme/service/authentication.dart';
import 'package:traceme/service/query.dart';
import 'package:traceme/service/str.dart';
import 'package:traceme/service/time.dart';

var str = Hstring();
var que = Hquery();
var ti = Htime();

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var _scaffold = GlobalKey<ScaffoldState>();

  List<String> tabs = ["Person", "Company", "Traced"];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _scaffold.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
            "Warning: Only authorized user are allowed to view this page.",
            style: TextStyle(color: Colors.red[200])),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
          key: _scaffold,
          appBar: searchAppBar(
              context: context,
              goto: "none",
              bottom: TabBar(
                isScrollable: true,
                tabs: [
                  for (final tab in tabs)
                    Container(
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "$tab",
                            style: TextStyle(color: Colors.cyan[700]),
                          )),
                    )
                ],
              ),
              onSearch: () {
                showSearch(context: context, delegate: DataSearch());
              },
              itemBuilder: (context) => [
                    // PopupMenuItem(value: 2, child: Text("Download csv")),
                    PopupMenuItem(value: 3, child: Text("Logout")),
                  ],
              onSelected: (p) async {
                // if (p == 2) {
                  // print("Downloading..");
                  // Navigator.pushNamed(context, "/profile");
                // }
                if (p == 3) {
                  auth.signOut();
                }
              }),
          body: TabBarView(children: [
            StreamBuilder(
                stream: que.getSnap("users"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var users = [];
                    var d = snapshot.data.documents;

                    for (var i in d) {
                      users.add(
                        Person(
                            userID: i.documentID,
                            name: i['name'],
                            userType: i['userType'],
                            company:
                                i['userType'] == "employee" ? i['company'] : "",
                            position: i['userType'] == "employee"
                                ? i['position']
                                : ""),
                      );
                    }

                    return ListView.builder(
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (_) => ShowPersonDetails(
                                    userID: users[idx].userID,
                                    userType: users[idx].userType));
                            Navigator.of(context).push(route);
                          },
                          child: Card(
                            shape: Border(
                                right: BorderSide(
                                    width: 5.0, color: Colors.cyan[700])),
                            child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text("${users[idx].name}"),
                                subtitle: users[idx].userType == "employee"
                                    ? Row(
                                        children: [
                                          Text("${users[idx].position}"),
                                          Spacer(),
                                          Text("${users[idx].company}"),
                                        ],
                                      )
                                    : Text("${users[idx].userType}")),
                          ),
                        );
                      },
                      itemCount: users.length,
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            StreamBuilder(
                stream: que.getSnap("users"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var companies = [];
                    var _companies = {};
                    var d = snapshot.data.documents;

                    for (var i in d) {
                      if (i['userType'] == "employee") {
                        if (_companies[i['company']] == null) {
                          _companies[i['company']] = 1;
                        } else {
                          _companies[i['company']] += 1;
                        }
                      }
                    }

                    for (var c in _companies.keys) {
                      var address = "";

                      for (var i in d) {
                        if (i['userType'] == "employee" && address == "") {
                          if (c == i['company']) {
                            address = i['address'];
                          }
                        }
                      }

                      companies.add(Company(
                          company: c,
                          employees: _companies[c],
                          address: address));
                    }

                    return ListView.builder(
                      itemBuilder: (context, idx) {
                        return Card(
                          shape: Border(
                              right: BorderSide(
                                  width: 5.0, color: Colors.cyan[700])),
                          child: ListTile(
                            leading: Icon(Icons.business),
                            title: Text("${companies[idx].company}"),
                            subtitle: Text("${companies[idx].address}"),
                          ),
                        );
                      },
                      itemCount: companies.length,
                    );
                  } else {
                    return SizedBox();
                  }
                }),
            StreamBuilder(
                stream: que.getSnap("traced"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var traced = [];
                    var d = snapshot.data.documents;

                    for (var i in d) {
                      traced.add(Traced(
                          traceID: i.documentID,
                          name: i['name'],
                          company: i['company'],
                          timestamp: i['timestamp']));
                    }

                    return ListView.builder(
                      itemBuilder: (context, idx) {
                        return Card(
                          shape: Border(
                              right: BorderSide(
                                  width: 5.0, color: Colors.cyan[700])),
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text("${traced[idx].name}"),
                            subtitle: Row(
                              children: [
                                Text("${traced[idx].company}"),
                                Spacer(),
                                Text("${traced[idx].timestamp}")
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: traced.length,
                    );
                  } else {
                    return SizedBox();
                  }
                })
          ])),
    ));
  }
}

class DataSearch extends SearchDelegate<String> {
  final users = [];
  final usersData = [];
  var selectedKey;
  var selectedID;

  // final recent = ["Doe", "Jessica"];

  DataSearch() {
    setupData();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for appbar
    // throw UnimplementedError();
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left bar icon
    // throw UnimplementedError();
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result base on the selection
    // throw UnimplementedError();
    var id;
    var type;

    for (var i in usersData) {
      if (id == null && i.name == query) {
        id = i.userID;
        type = i.userType;
      }
    }

    var route = MaterialPageRoute(
        builder: (_) => ShowPersonDetails(userID: id, userType: type));
    Navigator.of(context).push(route);

    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show if someone searches for something
    // throw UnimplementedError();

    final suggestionList = query.isEmpty
        ? users
        : users.where((element) => element.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.person),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.grey))
                ]),
          ),
          onTap: () {
            query = suggestionList[index];

            var id;
            var type;

            for (var i in usersData) {
              if (id == null && str.capitalizeS(i.name) == query) {
                id = i.userID;
                type = i.userType;
              }
            }

            var route = MaterialPageRoute(
                builder: (_) => ShowPersonDetails(userID: id, userType: type));
            Navigator.of(context).push(route);

            // showResults(context);
          }),
      itemCount: suggestionList.length,
    );
  }

  Future<void> setupData() async {
    var ids = await que.getIDs("users");

    for (var i in ids) {
      var u = await que.getDataByID("users", i);
      users.add(str.capitalizeS(u['name']));
      usersData.add(
        Person(
            userID: i,
            name: u['name'],
            userType: u['userType'],
            company: u['userType'] == "employee" ? u['company'] : "",
            position: u['userType'] == "employee" ? u['position'] : ""),
      );
    }
  }
}

class ShowPersonDetails extends StatefulWidget {
  final userID;
  final userType;

  ShowPersonDetails({this.userID, this.userType});

  @override
  _ShowPersonDetailsState createState() => _ShowPersonDetailsState();
}

class _ShowPersonDetailsState extends State<ShowPersonDetails> {
  var userData = {};
  var traced = [];
  var name = "";
  var email = "";
  var phone = "";
  var birthday = "";
  var address = "";
  var company = "";
  var position = "";

  @override
  void initState() {
    setupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: normalAppBar(context: context),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(children: [
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  SizedBox(width: 8),
                  widget.userType == "customer"
                      ? QrImage(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          data: widget.userID,
                          version: QrVersions.auto,
                          size: 100.0,
                        )
                      : Container(
                          child: Icon(
                            Icons.business,
                            size: 100,
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.userType == "employee")
                            Text(
                              "$company",
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          RichText(
                            text: TextSpan(
                                text: "ID: ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: widget.userID,
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Name: ",
                                style: TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: "$name",
                                      style: TextStyle(color: Colors.grey))
                                ]),
                          ),
                          if (widget.userType == "customer")
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: "Phone: ",
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text: "$phone",
                                              style:
                                                  TextStyle(color: Colors.grey))
                                        ]),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: "Email: ",
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text: "$email",
                                              style:
                                                  TextStyle(color: Colors.grey))
                                        ]),
                                  ),
                                ])
                        ]),
                  )
                ]),
                Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(
                        text: "Address: ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "$address",
                              style: TextStyle(color: Colors.grey))
                        ]),
                  ),
                ),
                Divider(
                  thickness: 4,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.userType == "customer"
                      ? Container(
                          height: size.height - 300,
                          child: StreamBuilder(
                              stream: que.getSnapSortedR("traced", "timestamp"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var snap = snapshot.data.documents;
                                  var histories = [];

                                  for (var i in snap) {
                                    if (widget.userID == i['userID']) {
                                      var time = ti
                                          .stringTimestampToMap(i['timestamp']);

                                      histories.add(HistoryKey(
                                          statusKey: i['statusKey'],
                                          company: i['company'],
                                          date: time['date'],
                                          time: time['time']));
                                    }
                                  }

                                  if (histories.length != 0) {
                                    return ListView.builder(
                                      itemCount: histories.length,
                                      itemBuilder: (_, int i) {
                                        return GestureDetector(
                                          onTap: () {
                                            showAlertDialog(context,
                                                histories[i].statusKey);
                                            print(histories[i].statusKey);
                                          },
                                          child: Card(
                                            shape: Border(
                                                left: BorderSide(
                                                    width: 5,
                                                    color: Colors.cyan[700])),
                                            child: ListTile(
                                              title: Text(histories[i].company),
                                              subtitle: Row(children: [
                                                Text(histories[i].date),
                                                Spacer(),
                                                Text(histories[i].time)
                                              ]),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: Text("Nothing to show"));
                                  }
                                } else {
                                  return SizedBox();
                                }
                              }),
                        )
                      : Container(
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: "Position: ",
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: "$position",
                                            style:
                                                TextStyle(color: Colors.grey))
                                      ]),
                                ),
                                SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                      text: "Company phone: ",
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: "$phone",
                                            style:
                                                TextStyle(color: Colors.grey))
                                      ]),
                                ),
                                SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                      text: "Company email: ",
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: "$email",
                                            style:
                                                TextStyle(color: Colors.grey))
                                      ]),
                                ),
                                SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                      text: "Company address: ",
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: "$address",
                                            style:
                                                TextStyle(color: Colors.grey))
                                      ]),
                                ),
                              ]),
                        ),
                )
              ]),
            )),
      ),
    );
  }

  Future<void> setupData() async {
    var d = await que.getDataByID("users", widget.userID);

    setState(() {
      name = d['name'];
      email = d['email'];
      phone = d['phone'];
      address = d['address'];
      birthday = d['birthday'];

      if (widget.userType == "employee") {
        company = d['company'];
        position = d['position'];
      }
    });
  }

  showAlertDialog(context, data) async {
    var status = await que.getDataByID("status", data);

    Widget continueButton = FlatButton(
      child: Text("Ok"),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Trace me"),
      content: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    text: "Temperature: ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                          text: "${status['temperature']}C",
                          style: TextStyle(color: Colors.red))
                    ]),
              ),
            ),
          ),
          for (var i in status.keys)
            if (i != "temperature" && i != "userID" && i != "timestamp")
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        text: "$i ",
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                              text: "${status[i]}",
                              style: TextStyle(color: Colors.black))
                        ]),
                  ),
                ),
              ),
        ],
      )),
      actions: [
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
