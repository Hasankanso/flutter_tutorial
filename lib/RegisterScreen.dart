import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopapp/Cache.dart';
import 'package:shopapp/DataObjects/User.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();

  final Function(User) onRegister;

  RegisterScreen({required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Spacer(flex: 2),
            Expanded(
              flex: 4,
              child: Icon(
                Icons.shopping_cart,
                color: Colors.amber.shade800,
                size: 120,
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Spacer(flex: 1),
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: "Phone Number"),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Spacer(flex: 1),
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
            Spacer(flex: 2),
            Expanded(
                child:
                    ElevatedButton(onPressed: () => onPressed(context), child: Text("Register"))),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  void onPressed(BuildContext context) {
    String phone = phoneController.text;
    String name = nameController.text;

    if (phone.isNotEmpty && name.isNotEmpty) {
      User user = User(name, phone);
      Cache.saveUser(user);
      onRegister(user);
      Navigator.of(context).pop();
    }
  }
}
