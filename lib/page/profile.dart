import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traceme/component/appbar.dart';
import 'package:traceme/component/customtile.dart';
import 'package:traceme/service/query.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var que = Hquery();
  var data = {};
  var temperature;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: normalAppBar(context: context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: data['name'] == null
            ? Center(
                child: SpinKitFadingCube(
                  color: Colors.cyan[700],
                ),
              )
            : Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            child: StreamBuilder(
                                stream:
                                    que.getSnapSortedR("status", "timestamp"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var snap = snapshot.data.documents;

                                    for (var i in snap) {
                                      if (data['userID'] == i['userID'] &&
                                          temperature == null) {
                                        temperature = i['temperature'];
                                      }
                                    }

                                    return Text(
                                      temperature == null
                                          ? "None"
                                          : temperature.toString() + " C",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }else{
                                    return SizedBox();
                                  }
                                }))
                      ]),
                      SizedBox(height: 20),
                      cardIconedTile(
                          text: data['name'].toString(), icon: Icons.person),
                      cardIconedTile(
                          text: data['email'].toString(), icon: Icons.email),
                      cardIconedTile(
                          text: data['phone'].toString(), icon: Icons.phone),
                      Container(
                        width: double.infinity,
                        child: cardTile(text: data['address'].toString()),
                      )
                    ]),
              ),
      ),
    ));
  }

  Future<void> getUserData() async {
    var pref = await SharedPreferences.getInstance();
    var user = pref.getString("user");
    var userKey;
    var userData;

    if (user != null) {
      userKey = await que.getKeyByData("users", "email", user);
      userData = await que.getDataByID("users", userKey);
      userData['userID'] = userKey;
    }

    if (userData != null || userData != {}) {
      setState(() {
        data = userData;
      });
    }
  }
}
