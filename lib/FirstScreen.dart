import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopapp/MyAppStorage.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Welcome " + MyAppStorage.of(context)!.user.name)));
  }
}
