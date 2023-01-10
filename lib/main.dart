import 'package:flutter/material.dart';
import 'package:spe/homepage.dart';

void main() {

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Photo Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage()
  ));
}