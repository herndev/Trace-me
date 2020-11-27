import 'package:flutter/material.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/component/customtile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: normalAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(children: [
              CircleAvatar(
                radius: 43,
                backgroundColor: Colors.amber[300],
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.amber[100],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[400],
                    size: 70,
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    "27 C",
                    style:
                        TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ))
            ]),
            SizedBox(height: 20),
            cardIconedTile(
              text: "Hernie Jabien", 
              icon: Icons.person
            ),
            cardIconedTile(
              text: "hernie@gmail.com", 
              icon: Icons.email
            ),
            cardIconedTile(
              text: "09123456789", 
              icon: Icons.phone
            ),
            cardTile(
              text: "Magna occaecat anim proident do mollit id et mollit esse ut non. Proident mollit aute ex nisi nostrud ullamco laborum occaecat cupidatat. Veniam deserunt irure id cillum eiusmod excepteur deserunt aute ea ad cillum. Non incididunt tempor mollit ut amet qui cillum enim et enim consequat est. Laborum ea ut labore adipisicing nisi elit eu id ad. Id minim cupidatat sunt excepteur minim do anim dolor magna incididunt eu pariatur amet."
            )
          ]),
        ),
      ),
    ));
  }
}
