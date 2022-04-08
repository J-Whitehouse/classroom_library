import 'package:classroom_library/screens/signin_screen.dart' as signIn;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:classroom_library/classes/book.dart';
import 'package:classroom_library/classes/bookList.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutterfire_ui/i10n.dart';


import '../utils/colors.dart';
import 'book_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Library'),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => signIn.SignInScreen()));
              });
            },
          ),
        ],
      ),
      body: FirestoreQueryBuilder<Book>(
        query: bookCollection.orderBy('title'),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }

          return ListView.builder(
              itemCount: snapshot.docs.length,
              itemBuilder: (context, index) {
                final book = snapshot.docs[index];
                return ListTile(
                  title: Text(book['title']),
                  subtitle: Text(book['author']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookScreen(book: book),
                      ),
                    );
                  },
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Open Menu',
        child: const Icon(Icons.menu),
        foregroundColor: Colors.black,
        backgroundColor: Colors.greenAccent,
      ),
    );
  }


  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  //FUNCTIONS
  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////







/*
pull up manual entry page
have barcode scan button
or allow user to enter data manually
when submit button is pressed,
  check if book is in database
  if not, add book to database

  void addBook(Book book) async {
    final user = await auth.currentUser();
    final bookRef = bookCollection.doc(book.id);
    await bookRef.set(book.toMap());
    final userRef = userCollection.doc(user.uid);
    await userRef.set({
      'books': FieldValue.arrayUnion([bookRef]),
    });
  }

 */


  void SignOut() async {
    await FirebaseAuth.instance.signOut();
    print("Signed Out");
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => signIn.SignInScreen()));
  }

}








/*
LOGOUT BUTTON
body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
        ),
      ),
 */

