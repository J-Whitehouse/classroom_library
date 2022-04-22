import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/reusable_widgets.dart';
import 'home_screen.dart';

class TeacherSignUpScreen extends StatefulWidget {
  const TeacherSignUpScreen({Key? key}) : super(key: key);

  @override
  _TeacherSignUpScreenState createState() => _TeacherSignUpScreenState();
}

class _TeacherSignUpScreenState extends State<TeacherSignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _firstNameTextController = TextEditingController();
  TextEditingController _lastNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Teacher Sign Up",
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
                reusableTextField(
                    "Email", Icons.person_outline, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 10,
                ),
                firebaseUIButton(context, "Sign Up", () async {
                  UserCredential result = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .catchError((error, stackTrace) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Email already in use."),
                          content: Text("Error ${error.toString()}"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  });
                  User user = result.user!;
                  FirebaseFirestore.instance
                      .collection('teachers')
                      .doc(user.uid)
                      .set({
                    'firstName': _firstNameTextController.text,
                    'lastName': _lastNameTextController.text,
                    'email': _emailTextController.text,
                    'teacher': true,
                  });
                  FirebaseFirestore.instance
                      .collection('teachers')
                      .doc(user.uid)
                      .collection('students')
                      .add({
                    'studentID': "_studentID",
                    'studentFirstName': "_studentFirstName",
                    'studentLastName': "_studentLastName",
                  });
                  FirebaseFirestore.instance
                      .collection('teachers')
                      .doc(user.uid)
                      .collection('books')
                      .add({
                    'bookID': "",
                    'studentFirstName': "_studentFirstName",
                    'studentLastName': "_studentLastName",
                  }).then((value) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()))
                              .onError((error, stackTrace) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Wrong Email or Password"),
                                  content: Text("Error ${error.toString()}"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }));
                }),
              ],
            ),
          ))),
    );
  }
}
