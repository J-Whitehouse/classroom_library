import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  FirebaseFirestore _firesStoreDataBase = FirebaseFirestore.instance;

  Stream<List<BookModel>> getBookList() {
    return _firesStoreDataBase
        .collection('teachers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('books')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BookModel.fromSnapShot(doc)).toList());
  }

  addBook() {
    var addBookData = Map<String, dynamic>();
    addBookData['title'] = 'Dracula';
    addBookData['author'] = 'Bram Stoker';
    addBookData['description'] =
        'Dracula is a fictional character created by the German author Bram Stoker. He is a vampire hunter, a monster-slayer, and a blood-sucking monster.';
    addBookData['imageUrl'] =
        'https://images-na.ssl-images-amazon.com/images/I/51ZU%2BKrYr6L._SX331_BO1,204,203,200_.jpg';
    addBookData['bookUrl'] =
        'https://www.amazon.com/Dracula-Bram-Stoker/dp/067102907X';
    addBookData['isbn'] = '067102907X';
    addBookData['publisher'] = 'Vintage';
    addBookData['publishedDate'] = '1931-01-01';
    addBookData['pageCount'] = '400';

    return _firesStoreDataBase
        .collection('teachers')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('books')
        .add({
      'title': '',
      'author': '',
      'description': '',
      'imageUrl': '',
      'bookUrl': '',
      'isbn': '',
      'publisher': '',
      'publishedDate': '',
      'pageCount': '',
    });
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
