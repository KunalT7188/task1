import 'package:flutter/material.dart';

import 'package:zappkode/Login1.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zappkode',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(),
     
      home: Login1(),
    );
  }
}
