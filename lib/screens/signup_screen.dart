import 'package:flutter/cupertino.dart';

import 'name.dart' as name;
import 'package:flutter/material.dart';

import 'login_screen.dart';

class User {
  final String name;
  final String password;

  const User({required this.name, required this.password});
}

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool isVisible = false;

  Widget build(BuildContext context) {
    final nameField = TextFormField(
      style: TextStyle(
          fontFamily: "SF Display", fontSize: 18, fontWeight: FontWeight.w600),
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.text,
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5, 15, 20, 10),
          hintText: "Type in a cool name 😎",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            fontFamily: "SF Display",
          ),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue, style: BorderStyle.solid),
          )),
    );

    final passwordField = TextFormField(
      style: TextStyle(
          fontFamily: "SF Display", fontSize: 24, fontWeight: FontWeight.w600),
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(5, 15, 20, 10),
          hintText: "Enter those secret characters...",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: "SF Display",
          ),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue, style: BorderStyle.solid),
          )),
    );
    double width = MediaQuery.of(context).size.width;
    name.name = nameController.text;
    return Scaffold(
        //body : Center(
        //child: SingleChildScrollView(
        body: GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 0.5) {
          Navigator.pop(context);
        }
      },
      child: Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("We'll need a password too",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "SF Pro Rounded",
                                      fontSize: 30,
                                      color: Colors.black),
                                  textAlign: TextAlign.center),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width: width * 0.65, child: passwordField),
                                CupertinoButton(
                                  onPressed: () {
                                    Navigator.of(context).push(_createRoute());
                                  },
                                  child: Icon(Icons.arrow_forward_rounded,
                                      color: Colors.blue, size: 30),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      visible: isVisible,
                      replacement: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "What should we call you?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "SF Pro Rounded",
                                  fontSize: 30,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(width: width * 0.65, child: nameField),
                                CupertinoButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisible = true;
                                    });
                                  },
                                  child: Icon(Icons.arrow_forward_rounded,
                                      color: Colors.blue, size: 30),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            )),
      ),
    ));
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
    settings: RouteSettings(arguments: name.name),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
