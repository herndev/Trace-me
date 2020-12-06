import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  
  final controller;
  final validator;

  PasswordField({@required this.controller, @required this.validator});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  
  var pwd = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !pwd,
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: GestureDetector(
          child: Icon(pwd ? Icons.visibility_off : Icons.visibility),
          onTap: (){
            setState(() {
              pwd = !pwd;
            });
          },
        ),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}


Widget emailField({@required controller, @required validator}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: TextInputType.emailAddress,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(Icons.email),
      hintText: "Email",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}


Widget inputField({@required controller, @required validator, @required icon, @required hint, type: TextInputType.text}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: type,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: icon,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}


Widget disabledField({@required controller, @required validator, @required icon, @required hint, type: TextInputType.text}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: type,
    enabled: false,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: icon,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}


Widget textAreaField({@required controller, @required hint, @required max, @required validator}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    maxLines: max,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
