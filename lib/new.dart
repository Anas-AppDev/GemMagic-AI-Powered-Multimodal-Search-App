import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemini2/Typer.dart';

void main(){
  runApp(MaterialApp(
    home: New(),
  ));
}

class New extends StatefulWidget {
  const New({super.key});

  @override
  State<New> createState() => _NewState();
}

class _NewState extends State<New> {

  List<String> messages = [
    "anas",
    "aman",
    "rihan",
    "ishan",
    "rahul",
    "shruti",
    "nikhil",
    "abhishek",
    "shreyansh",
    "varun",
    "palki",
    "ujjawal",
    "abhinav",
    "subham",
    "ojas",
    "siddarth",
    "varun",
    "palki",
    "ujjawal",
    "abhinav",
    "subham",
    "ojas",
    "siddarth",
    "nikhil",
    "abhishek",
    "shreyansh",
    "varun",
    "palki",
    "ujjawal",
    "abhinav",
    "subham",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Typer(text: "fabdskjnasjdncaksdc a cdsdascjkn")
      ),
    );
  }
}
