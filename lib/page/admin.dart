import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/model/sensitive_data.dart';
import 'package:traceme/service/authentication.dart';
import 'package:traceme/service/query.dart';
import 'package:traceme/service/str.dart';



var str = Hstring();


class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var _scaffold = GlobalKey<ScaffoldState>();
  var que = Hquery();

  List<String> tabs = ["Person", "Company", "Statuses"];

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      _scaffold.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 4),
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
                    PopupMenuItem(value: 2, child: Text("Download csv")),
                    PopupMenuItem(value: 3, child: Text("Logout")),
                  ],
              onSelected: (p) async {
                if (p == 1) {
                  Navigator.pushNamed(context, "/profile");
                }
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
                        return Card(
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
                            leading: Text("${companies[idx].employees}",
                                style: TextStyle(
                                    color: Colors.cyan[700],
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
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
          ])

          // TabBarView(controller: TabController(length: null, vsync: null), children: [SizedBox()])

          // SingleChildScrollView(
          //   child: Container(
          //     child: Column(),
          //   ),
          // ),
          ),
    ));
  }
}

class DataSearch extends SearchDelegate<String> {
  var que = Hquery();

  final users = [];

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
        return Text(query);
      }
    
      @override
      Widget buildSuggestions(BuildContext context) {
        // Show if someone searches for something
        // throw UnimplementedError();

        // final suggestionList = query.isEmpty
        //     ? recent
        //     : users.where((element) => element.startsWith(query)).toList();


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
                showResults(context);
              }),
          itemCount: suggestionList.length,
        );
      }
    
      Future<void> setupData() async{
        var ids = await que.getIDs("users");

        for (var i in ids) {
          var u = await que.getDataByID("users", i);
          users.add(str.capitalizeS(u['name']));
        }
      }
}
