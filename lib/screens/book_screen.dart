import 'package:classroom_library/classes/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class BookScreen extends StatefulWidget {
  const BookScreen({Key? key, required QueryDocumentSnapshot<Book> book}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
