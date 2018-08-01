import 'package:flutter/material.dart';
import 'package:ICISI/ui/home.dart';


void main() {
  runApp(new MaterialApp(
    title: 'Prototype_3',
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prototype',
      home: new Home(),
    );
  }
}