import 'package:flutter/material.dart';

Widget mainAppBar({@required itemBuilder, @required onSelected}) {
  return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromRGBO(255, 204, 51, 1),
      title: Row(children: [
        Text("Trace me", style: TextStyle(fontSize: 24, color: Colors.white)),
        Spacer(),
        PopupMenuButton(
          child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.white,
            child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.grey[900])),
          ),
          itemBuilder: itemBuilder,
          onSelected: onSelected,
        )
      ]));
}

Widget normalAppBar() {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
    backgroundColor: Color.fromRGBO(255, 204, 51, 1),
    title:
        Text("Trace me", style: TextStyle(fontSize: 24, color: Colors.white)),
  );
}
