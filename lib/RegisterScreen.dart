import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopapp/Cache.dart';
import 'package:shopapp/DataObjects/User.dart';
import 'package:shopapp/utilities/SMSCodeDialog.dart';

class RegisterScreen extends StatefulWidget {
  final Function(User) onRegister;

  RegisterScreen({required this.onRegister});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = new TextEditingController();

  final TextEditingController nameController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Auth.FirebaseAuth auth = Auth.FirebaseAuth.instance;
  String _countryCode = "+961";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
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
                flex: 3,
                child: Row(
                  children: [
                    Spacer(flex: 1),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: "",
                              labelStyle: TextStyle(fontSize: 8, color: Colors.transparent)),
                          value: _countryCode,
                          onChanged: (String? newValue) {
                            _countryCode = newValue ?? "+961";
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: "+961",
                              child: Text("+961"),
                            ),
                            DropdownMenuItem<String>(
                              value: "+20",
                              child: Text("+20"),
                            ),
                            DropdownMenuItem<String>(
                              value: "+1",
                              child: Text("+1"),
                            ),
                          ]),
                    ),
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: "Phone Number"),
                        validator: (value) {
                          String pattern = r'(^(?:[+0]9)?[0-9]{8,12}$)';
                          RegExp regExp = new RegExp(pattern);

                          if (value!.isEmpty) {
                            return "Please enter your phone number";
                          }
                          if (!regExp.hasMatch(value)) {
                            return "Please enter a valid phone number";
                          }

                          return null;
                        },
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
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Name"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                          if (value.length < 3) {
                            return "Name is too Short";
                          }
                          return null;
                        },
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
      ),
    );
  }

  void onPressed(BuildContext context) {
    String phone = phoneController.text;
    String name = nameController.text;

    if (_formKey.currentState!.validate()) {
      Auth.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _countryCode + phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (Auth.PhoneAuthCredential credential) {
          print("it's valid");
        },
        verificationFailed: (Auth.FirebaseAuthException e) {
          print("failed");

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        },
        codeSent: (String verificationId, int? resendToken) async {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return SMSCodeDialog(
                    phoneNumber: _countryCode + phone,
                    resendToken: resendToken,
                    onSMSCodeEntered: (smsCode, dialogContext) async {
                      try {
                        Auth.PhoneAuthCredential credential = Auth.PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);
                        Auth.UserCredential userCre = await auth.signInWithCredential(credential);

                        Auth.User firebaseUser = userCre.user!;

                        User user =
                            User(name, firebaseUser.phoneNumber!, firebaseToken: firebaseUser.uid);
                        Cache.saveUser(user);
                        widget.onRegister(user);
                        Navigator.of(dialogContext).pop();
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Wrong sms "
                                "code")));
                      }
                    });
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("timeout");
        },
      );
    }
  }
}
