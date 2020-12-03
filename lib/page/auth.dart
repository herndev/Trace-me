// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:traceme/component/colors.dart';
import 'package:traceme/component/input.dart';
import 'package:traceme/model/user.dart';
import 'package:traceme/service/authentication.dart';
import 'package:traceme/service/query.dart';

// LOGIN
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();
  var password = TextEditingController();
  var _login = GlobalKey<FormState>();
  var _scaffold = GlobalKey<ScaffoldState>();
  var auth = AuthenticationService(FirebaseAuth.instance);
  final que = Hquery();
  var signing = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<UserData>(context, listen: false);

    return SafeArea(
        child: Scaffold(
          key: _scaffold,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 26,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/location_icon.png"),
                  Image.asset("assets/logo.png")
                ],
              ),
            ),
            SizedBox(height: 50),
            Form(
              key: _login,
              child: Column(
                children: [
                  emailField(
                      controller: email,
                      validator: (val) {
                        if (val.length == 0 || !val.contains("@"))
                          return "Please provide valid email.";
                        return null;
                      }),
                  SizedBox(height: 8),
                  PasswordField(
                      controller: password,
                      validator: (val) {
                        if (val.length == 0) return "Please provide password.";
                        return null;
                      }),
                ],
              ),
            ),
            SizedBox(height: 15),
            FlatButton(
                height: 45,
                color: Color.fromRGBO(255, 204, 51, 1),
                minWidth: double.infinity,
                child: 
                signing ?
                Text("Signing-in...",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
                :Text("Sign in",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                onPressed: () async{
                  if (_login.currentState.validate() && !signing) {
                    _login.currentState.save();

                    setState(() {
                      signing = true;
                    });

                    // Begin Authenticate
                    var result = await auth.signIn(email: email.text, password: password.text);
                    // End Authenticate

                    
                    print(result);

                    if(result != "Signed in"){
                      
                      _scaffold.currentState.showSnackBar(
                        SnackBar(
                          content: Text(result),
                        )
                      );

                      setState(() {
                        signing = false;
                      });
                    }else{
                      var u = await que.getDataByData("users", "email", email.text);
                      await user.setType(u['userType']);
                    }
                  }
                }),
            SizedBox(height: 50),
            Container(
              height: 80,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topLeft, children: [
                GestureDetector(
                  child: Container(
                    child: Text("Create account",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                  onTap: () {
                    var route = MaterialPageRoute(
                      builder: (copntext) => NewUser()
                    );
                    Navigator.of(context).push(route);
                  },
                ),
                Positioned(
                  top: 30,
                  child: GestureDetector(
                    child: Container(
                      child: Text("Sign up for a management account.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 204, 51, 1))),
                    ),
                    onTap: () {
                      var route = MaterialPageRoute(
                      builder: (copntext) => NewUser(userType: "employee")
                    );
                    Navigator.of(context).push(route);
                    },
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    ));
  }
}




// REGISTER
class NewUser extends StatefulWidget {

  final userType;
  NewUser({this.userType: "customer"});

  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  var auth = AuthenticationService(FirebaseAuth.instance);
  var _scaffold = GlobalKey<ScaffoldState>();
  var phone = TextEditingController();
  var address = TextEditingController();
  var password = TextEditingController();
  var email = TextEditingController();
  var fname = TextEditingController();
  var birth = TextEditingController();
  var company = TextEditingController();
  var position = TextEditingController();
  var _newuser = GlobalKey<FormState>();
  var que = Hquery();
  var signing = false;

  @override
  void dispose() {
    phone.dispose();
    address.dispose();
    password.dispose();
    email.dispose();
    fname.dispose();
    birth.dispose();

    if (widget.userType != "customer") {
      position.dispose();
      company.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffold,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Row(children: [
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    size: 45,
                    color: Color.fromRGBO(255, 204, 51, 1),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(right: 35),
                      child: Container(
                        height: 40,
                        child: Image.asset("assets/logo.png"),
                      )),
                ),
              ]),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: _newuser,
                  child: Column(children: [
                    inputField(
                        controller: fname,
                        validator: (v) {
                          if (v.length == 0) return "Please provide full name";
                          return null;
                        },
                        icon: Icon(Icons.person),
                        hint: "Full name"),
                    SizedBox(height: 8),
                    inputField(
                        controller: email,
                        hint: widget.userType == "customer"
                            ? "Email"
                            : "Company email",
                        icon: Icon(Icons.email),
                        type: TextInputType.emailAddress,
                        validator: (v) {
                          if (v.length == 0 || !v.contains("@"))
                            return "Please provide email";
                          return null;
                        }),
                    SizedBox(height: 8),
                    inputField(
                        controller: phone,
                        hint: widget.userType == "customer"
                            ? "Phone"
                            : "Company contact number",
                        icon: Icon(Icons.phone),
                        type: TextInputType.phone,
                        validator: (v) {
                          if (v.length == 0 || v.replaceAll("0", "") == "")
                            return "Please provide phone number";
                          return null;
                        }),
                    SizedBox(height: 8),
                    PasswordField(
                        controller: password,
                        validator: (v) {
                          if (v.length == 0) return "Please provide password";
                          return null;
                        }),
                    SizedBox(height: 8),
                    GestureDetector(
                      child: disabledField(
                          controller: birth,
                          validator: (v) {
                            if (v.length == 0)
                              return "Please provide birth date";
                            return null;
                          },
                          icon: Icon(Icons.cake),
                          hint: "Birth date"),
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: birth.text == ""
                                    ? DateTime.now()
                                    : DateTime.parse(
                                        birth.text + " " + "00:00:00"),
                                firstDate: DateTime(1920),
                                lastDate: DateTime.now())
                            .then((value) {
                          if (value != null) {
                            birth.text = DateFormat('yyyy-MM-dd').format(value);
                          }
                        });
                      },
                    ),
                    if (widget.userType != "customer")
                      Column(children: [
                        SizedBox(height: 8),
                        inputField(
                            controller: company,
                            hint: "Company",
                            icon: Icon(Icons.business),
                            validator: (v) {
                              if (v.length == 0)
                                return "Please provide company";
                              return null;
                            }),
                        SizedBox(height: 8),
                        inputField(
                            controller: position,
                            hint: "Position",
                            icon: Icon(Icons.person_outline),
                            validator: (v) {
                              if (v.length == 0)
                                return "Please provide position";
                              return null;
                            }),
                      ]),
                    SizedBox(height: 8),
                    Container(
                      child: textAreaField(
                          controller: address,
                          hint: "Address",
                          max: 8,
                          validator: (v) {
                            if (v.length == 0) return "Please provide address";
                            return null;
                          }),
                    )
                  ]),
                ),
              ),
            ]),
          ),
        ),
        bottomNavigationBar: FlatButton(
            height: 45,
            color: Hcolor().yellow,
            minWidth: double.infinity,
            child: 
            signing ?
            Text("Signing-up...",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
            : Text("Sign up",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            onPressed: () async{
              if (_newuser.currentState.validate() && birth.text != "" && !signing) {
                _newuser.currentState.save();

                
                // await que.getKeyByData("users", "email", email.text) == null
                if(true){

                  setState(() {
                    signing = true;
                  });

                  var  result = await auth.signUp(email: email.text, password: password.text);

                  if(result == "Signed up"){
                    if(widget.userType == "customer"){
                      await que.push("users", {
                      "name": fname.text,
                      "email": email.text,
                      "phone": phone.text,
                      "birthDate": birth.text,
                      "address": address.text,
                      "userType": widget.userType,
                    });
                    }else{
                      await que.push("users", {
                        "name": fname.text,
                        "email": email.text,
                        "phone": phone.text,
                        "birthDate": birth.text,
                        "address": address.text,
                        "company": company.text,
                        "position": position.text,
                        "userType": widget.userType,
                      });
                    }
                      
                    
                    Navigator.pop(context);
                  }else{
                    _scaffold.currentState.showSnackBar(
                      SnackBar(
                        content: Text(result),
                      )
                    );

                    setState(() {
                      signing = false;
                    });
                  }
                }
              }
            }),
      ),
    );
  }
}
