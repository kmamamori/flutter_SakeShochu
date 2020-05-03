import 'package:flutter/material.dart';
import 'auth_ui/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Login Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Login()
    );
  }
}