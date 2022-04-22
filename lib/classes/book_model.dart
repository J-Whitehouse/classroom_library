import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String bookUrl;
  final String isbn;
  final String publisher;
  final String pageCount;

  BookModel({
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.bookUrl,
    required this.isbn,
    required this.publisher,
    required this.pageCount,
  });

  BookModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot)
      : title = documentSnapshot.data()!['title'],
        author = documentSnapshot.data()!['author'],
        description = documentSnapshot.data()!['description'],
        imageUrl = documentSnapshot.data()!['imageUrl'],
        bookUrl = documentSnapshot.data()!['bookUrl'],
        isbn = documentSnapshot.data()!['isbn'],
        publisher = documentSnapshot.data()!['publisher'],
        pageCount = documentSnapshot.data()!['pageCount'];
}
