import 'package:flutter/material.dart';
import 'package:dog_breeds/screens/dog_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Breeds App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DogScreen(),
    );
  }
}
