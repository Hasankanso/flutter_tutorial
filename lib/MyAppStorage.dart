import 'package:flutter/material.dart';
import 'package:shopapp/DataObjects/User.dart';

class MyAppStorage extends InheritedWidget {
  final User user;

  const MyAppStorage({
    Key? key,
    required Widget child,
    required this.user,
  }) : super(key: key, child: child);

  static MyAppStorage? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppStorage>();
  }

  @override
  bool updateShouldNotify(MyAppStorage old) {
    return user.name == old.user.name && user.phoneNumber == old.user.phoneNumber;
  }
}
