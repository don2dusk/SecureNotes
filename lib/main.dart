import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Secure Notes');
    setWindowMaxSize(const Size(700, 800));
    setWindowMinSize(const Size(700, 800));
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    color: Colors.black,
    home: WelcomeScreen(),
  ));
}
