import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traceme/component/appbar.dart';

class Home extends StatefulWidget {
  final userType;
  Home({this.userType: "customer"});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: mainAppBar(
            itemBuilder: (context) => [
                  PopupMenuItem(value: 1, child: Text("Profile")),
                  if (widget.userType != "customer")
                    PopupMenuItem(value: 2, child: Text("Download csv")),
                  PopupMenuItem(value: 3, child: Text("Logout")),
                ],
            onSelected: (p) {
              if (p == 1) {
                Navigator.pushNamed(context, "/profile");
              }
            }),
        body: Container(
          child: Column(children: [
            Text(user.User().name),
            // Camera
            Expanded(
              child: Center(
                  child: TextButton(
                child: RichText(
                  text: TextSpan(
                      text: "[ ",
                      children: [
                        TextSpan(
                            text: widget.userType == "customer"
                                ? "QR Code"
                                : "QR Scan",
                            style:
                                TextStyle(fontSize: 24, color: Colors.black)),
                        TextSpan(text: " ]", style: TextStyle(fontSize: 32))
                      ],
                      style: TextStyle(fontSize: 32, color: Colors.red)),
                ),
                onPressed: () {},
              )),
            ),
            if (widget.userType == "customer")
              Container(
                height: 64,
                width: double.infinity,
                child: RaisedButton(
                  color: Color.fromRGBO(255, 204, 51, 1),
                  child: Text("Update data",
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
