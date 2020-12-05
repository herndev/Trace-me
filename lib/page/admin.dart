import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/service/authentication.dart';
import 'package:traceme/service/query.dart';

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
                          child: Text("$tab", style:  TextStyle(color: Colors.cyan[700]),)),
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
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.red,
                    child: Column(
                      children: [],
                    ),
                  )),
            ),
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Column(
                      children: [],
                    ),
                  )),
            ),
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Column(
                      children: [],
                    ),
                  )),
            )
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
  final users = [
    "Heerniee",
    "Jabien",
    "Jhon",
    "Doe",
    "Jessica",
    "Jane",
  ];

  final recent = ["Doe", "Jessica"];

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
    final suggestionList = query.isEmpty
        ? recent
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
}
