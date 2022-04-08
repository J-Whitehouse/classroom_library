import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/reusable_widgets.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _firstNameTextController = TextEditingController();
  TextEditingController _lastNameTextController = TextEditingController();

bool teacherUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),

      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                // hexStringToColor("d7d7d7"),
                Colors.deepPurpleAccent,
                Colors.greenAccent,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("First Name", Icons.person_outline, false,
                        _firstNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Last Name", Icons.person_outline, false,
                        _lastNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Email", Icons.person_outline, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Password", Icons.lock_outlined, true,
                        _passwordTextController),
                    const SizedBox(
                      height: 10,
                    ),
                    teacherUserMarker(),
                    firebaseUIButton(context, "Sign Up", () async {
                      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text);
                          if (teacherUser == true) {
                            User user = result.user!;
                            FirebaseFirestore.instance.collection('teachers')
                                .doc(user.uid).set({
                              'firstName': _firstNameTextController.text,
                              'lastName': _lastNameTextController.text,
                              'email': _emailTextController.text,
                              'teacher': true,
                            });
                            FirebaseFirestore.instance.collection('teachers')
                                .doc(user.uid).collection('students').add({
                              'studentID': "_studentID",
                              'studentFirstName': "_studentFirstName",
                              'studentLastName': "_studentLastName",
                            }).then((value) =>
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomeScreen()))
                                    .onError((error, stackTrace) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context)
                                        { return AlertDialog(
                                          title:  Text("Wrong Email or Password"),
                                          content:  Text("Error ${error.toString()}"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child:  Text("Close"),
                                              onPressed: () { Navigator.of(context).pop(); },
                                            ),],
                                        );},
                                      );
                                    }));

                          } else {
                            User user = result.user!;
                            FirebaseFirestore.instance.collection('students')
                                .doc(user.uid).set({
                              'firstName': _firstNameTextController.text,
                              'lastName': _lastNameTextController.text,
                              'email': _emailTextController.text,
                              'teacher': false,
                            }).then((value) =>
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomeScreen()))
                                    .onError((error, stackTrace) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context)
                                        { return AlertDialog(
                                          title:  Text("Wrong Email or Password"),
                                          content:  Text("Error ${error.toString()}"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child:  Text("Close"),
                                              onPressed: () { Navigator.of(context).pop(); },
                                            ),],
                                        );},
                                      );
                                    })
                            );

                          }
                    }),
                  ],
                ),
              )
          )
      ),
    );
  }
}

class teacherUserMarker extends StatefulWidget {
  const teacherUserMarker({Key? key}) : super(key: key);

  @override
  _teacherUserMarkerState createState() => _teacherUserMarkerState();
}

class _teacherUserMarkerState extends State<teacherUserMarker> {
  bool _toggled = true;

  @override
  Widget build(BuildContext context) {

    return SwitchListTile(
      selected: true,
      title: Text("Register as a Teacher?"),
      secondary: const Icon(Icons.person),
      activeColor: Colors.white,
      value: _toggled,
      onChanged: (teacherUser) => setState(() => _toggled = teacherUser),
    );
  }
}

