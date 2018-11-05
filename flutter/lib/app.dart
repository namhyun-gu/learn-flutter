import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_chat/main.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.grey[200],
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey[200],
        systemNavigationBarIconBrightness: Brightness.dark));
    return MaterialApp(
      title: 'SimpleChat',
      theme: ThemeData(
          primaryColor: Colors.white, accentColor: Colors.blueAccent[400]),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}