import 'package:flutter/material.dart';
import 'package:traceme/component/appbar.dart';

// Update status
class UpdateStatus extends StatefulWidget {
  @override
  _UpdateStatusState createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {

  Map<String, bool> questions  = {
    "Travel history?":false,
    "Are you having fever?":false,
    "Having caught?":false,
  };
  List<String> questionKeys = [
    "Travel history?",
    "Are you having fever?",
    "Having caught?"
  ];


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    
    return SafeArea(
      child: Scaffold(
        appBar: mainAppBar(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text("Profile")
            ),
            PopupMenuItem(
              value: 2,
              child: Text("Logout")
            ),
          ],
          onSelected: (p){}
        ),
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
                        Text("Last updated 10/16/2020", style: TextStyle(fontSize: 18, color: Colors.orange)),
                        Spacer(),
                        Text("10:32 AM", style: TextStyle(fontSize: 18, color: Colors.orange)),
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
                              onChanged: (value){
                                setState(() {
                                  questions[questionKeys[i]] = value;
                                });
                              }
                            ),
                            title: Text(questionKeys[i]),
                          ),
                        );
                     },
                    ),
                  ),
                ]),
              )
            ),
            Container(
              height: 64,
              width: double.infinity,
              child: RaisedButton(
                color: Color.fromRGBO(255, 204, 51, 1),
                child: Text("Update data", style: TextStyle(fontSize: 24, color: Colors.white)),
                onPressed: (){},
              ),
            )
          ]),
        ),
      ),
    );
  }
}