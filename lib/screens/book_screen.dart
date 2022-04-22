import 'package:classroom_library/classes/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutterfire_ui/firestore.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key, required QueryDocumentSnapshot<BookModel> book})
      : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
    );
  }
}
