import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Book {

  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String bookUrl;
  final String isbn;
  final String publisher;
  final String publishedDate;
  final String pageCount;

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.bookUrl,
    required this.isbn,
    required this.publisher,
    required this.publishedDate,
    required this.pageCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'imageUrl': imageUrl,
      'bookUrl': bookUrl,
      'isbn': isbn,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'pageCount': pageCount,
    };
  }
}

final bookCollection = FirebaseFirestore.instance.collection('books').withConverter<Book>(
    fromFirestore: (snapshot, _) => Book(
      title: snapshot.data()!['title'],
      author: snapshot.data()!['author'],
      description: snapshot.data()!['description'],
      imageUrl: snapshot.data()!['imageUrl'],
      bookUrl: snapshot.data()!['bookUrl'],
      isbn: snapshot.data()!['isbn'],
      publisher: snapshot.data()!['publisher'],
      publishedDate: snapshot.data()!['publishedDate'],
      pageCount: snapshot.data()!['pageCount'],
    ),
    toFirestore: (book, _) => book.toMap()
);
