import 'package:classroom_library/screens/home_screen.dart';
import 'package:classroom_library/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

  var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return MaterialApp(
        title: 'Classroom Library',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomeScreen(),
      );

    }
    return MaterialApp(
      title: 'Classroom Library',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SignInScreen(),
    );
  }
}