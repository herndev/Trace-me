import 'package:flutter/material.dart';

Widget mainAppBar({@required context, goto: "/home", @required itemBuilder, @required onSelected}) {
  return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color.fromRGBO(255, 204, 51, 1),
      title: Row(children: [
        GestureDetector(onTap: (){ if(goto != "none") Navigator.pushNamed(context, goto);}, child: Text("Trace me", style: TextStyle(fontSize: 24, color: Colors.white))),
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

Widget normalAppBar({@required context, goto: "/home", }) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
    backgroundColor: Color.fromRGBO(255, 204, 51, 1),
    title:
        GestureDetector(onTap: (){Navigator.pushNamed(context, goto);}, child: Text("Trace me", style: TextStyle(fontSize: 24, color: Colors.white))),
  );
}
