import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_notes/screens/welcome_screen.dart';

class AccountDeletion extends StatefulWidget {
  const AccountDeletion({super.key});

  @override
  State<AccountDeletion> createState() => _AccountDeletionState();
  static Route<dynamic> route() {
    return CupertinoPageRoute(
      builder: (BuildContext context) {
        return AccountDeletion();
      },
    );
  }
}

class _AccountDeletionState extends State<AccountDeletion> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.red,
                        size: 80,
                      ),
                      Text(
                        'Danger Zone',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Are you sure?\nAll your data will be permanently deleted',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()));
                            },
                            child: SizedBox(
                              width: width,
                              child: Text(
                                'Proceed?',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                                textAlign: TextAlign.right,
                              ),
                            )),
                        visible: isVisible,
                        replacement: GestureDetector(
                            onTap: () {
                              setState(() {
                                isVisible = true;
                              });
                            },
                            child: SizedBox(
                              width: width,
                              child: Text(
                                'Yes, I\'m sure',
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                                textAlign: TextAlign.right,
                              ),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
