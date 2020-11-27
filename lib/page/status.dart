import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/model/history.dart';
import 'package:traceme/model/user.dart';

// Update status
class UpdateStatus extends StatefulWidget {
  @override
  _UpdateStatusState createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  Map<String, bool> questions = {
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

  @override
  void initState() {
    setState(() {
      questionKeys = questions.keys.toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: mainAppBar(
            context: context,
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
                Navigator.pushNamed(context, "/login");
              }
              if (p == 4) {
                Navigator.pushNamed(context, "/history");
              }
            }),
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
                  height: size.height - 230,
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
                onPressed: () {},
              ),
            )
          ]),
        ),
      ),
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

  @override
  void initState() {
    setState(() {
      histories.add(History(company: "Mang kanor", date: "10/11/2020", time: "10:00 AM"));
      histories.add(History(company: "Jollibee", date: "10/11/2020", time: "10:00 AM"));
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userType = Provider.of<User>(context);
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: mainAppBar(
            context: context,
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
                Navigator.pushNamed(context, "/login");
              }
              if (p == 4) {
                Navigator.pushNamed(context, "/history");
              }
            }),
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
