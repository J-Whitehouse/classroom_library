import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String title;
  String author;
  String description;
  String imageUrl;
  String bookUrl;
  String isbn;
  String publisher;
  String publishedDate;
  String pageCount;

  BookModel({
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

final bookCollection =
    FirebaseFirestore.instance.collection('books').withConverter<BookModel>(
        fromFirestore: (snapshot, _) => BookModel(
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
        toFirestore: (book, _) => book.toMap());
