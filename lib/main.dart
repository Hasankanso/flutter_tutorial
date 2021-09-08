import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopapp/Cache.dart';
import 'package:shopapp/DataObjects/User.dart';
import 'package:shopapp/FirstScreen.dart';
import 'package:shopapp/MyAppStorage.dart';
import 'package:shopapp/RegisterScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Hive.registerAdapter(UserAdapter());

  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;

  void login(User user) {
    setState(() {
      this.user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(pages: [
      if (user == null)
        MaterialPage(
          child: FutureBuilder<User?>(
              future: Cache.getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  user = snapshot.data;
                  return MyAppStorage(user: snapshot.data!, child: FirstScreen());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return RegisterScreen(onRegister: login);
                } else {
                  return Scaffold(body: Center(child: CircularProgressIndicator()));
                }
              }),
        )
      else
        MaterialPage(child: MyAppStorage(user: user!, child: FirstScreen()))
    ], onPopPage: (route, result) => route.didPop(result));
  }
}
