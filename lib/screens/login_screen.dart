import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_notes/screens/account_deletion.dart';
import 'package:secure_notes/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext context) {
    final userName = ModalRoute.of(context)!.settings.arguments as String;
    final passwordField = TextFormField(
        style: TextStyle(
          fontFamily: "SF Display",
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        autofocus: true,
        obscureText: true,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(5, 15, 20, 10),
            hintText: "Keep this between us? 🥺",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: "SF Display",
            ),
            border: UnderlineInputBorder()));
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Welcome Back, $userName!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontFamily: "SF Pro Display",
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("Enter your password:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: "SF Pro Display",
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: passwordField),
                    CupertinoButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                                settings: RouteSettings(arguments: userName)));
                      },
                      child: Icon(Icons.arrow_forward_rounded,
                          color: Colors.blue, size: 30),
                    )
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(AccountDeletion.route());
                        },
                        child: Text(
                          'Forgot password or not $userName?',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.right,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
