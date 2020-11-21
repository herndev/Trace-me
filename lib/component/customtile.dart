import 'package:flutter/material.dart';

Widget cardIconedTile({@required text, @required icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: [
        Icon(icon),
        SizedBox(width: 10),
        Text("$text")
      ]),
    )),
  );
}

Widget cardTile({@required text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("$text")
    )),
  );
}
