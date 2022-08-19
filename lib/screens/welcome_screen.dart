import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:secure_notes/screens/signup_screen.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Container(
              color: Colors.black,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.delta.dy < 0.5) {
                    Navigator.of(context).push(_createRoute());
                  }
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Opacity(
                      opacity: 0.5,
                      child: Image.asset('assets/imgs/unsplash.jpg',
                          fit: BoxFit.cover),
                    )),
                    Positioned.fill(
                        child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [.2, .72],
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(220, 0, 0, 0)
                        ],
                      )),
                    )),
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          "Welcome to",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 45),
                        ),
                        SizedBox(
                          height: 60.0,
                          width: 300,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 45.0,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                FadeAnimatedText('Simple Notes',
                                    textAlign: TextAlign.center),
                                FadeAnimatedText('Fast Notes',
                                    textAlign: TextAlign.center),
                                FadeAnimatedText('Secure Notes',
                                    textAlign: TextAlign.center),
                              ],
                              onTap: () {
                                print("Tap Event");
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        SizedBox(
                            height: 20,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(206, 255, 255, 255)),
                              child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    FadeAnimatedText('Slide up to begin',
                                        duration: Duration(milliseconds: 5000))
                                  ]),
                            )),
                        SizedBox(height: 20)
                        /*SizedBox(height: 25),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()),
                              );
                            },
                            child: Icon(Icons.arrow_forward_rounded,
                                color: Colors.blue, size: 50)),
                                SizedBox(height: 20), */
                      ],
                    ))
                  ],
                ),
              ))),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SignupScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
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
