import 'package:classroom_library/screens/signin_screen.dart' as signIn;
import 'package:classroom_library/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:classroom_library/classes/book_model.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutterfire_ui/database.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:scan/scan.dart';
import 'book_screen.dart';
import '../utils/colors.dart';
import '../widgets/reusable_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirebaseFirestore.instance;
  ScanController controller = ScanController();
  var _scanResult = '';
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => signIn.SignInScreen()));
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final books = snapshot.data?.docs;
          return ListView.builder(
            itemCount: books?.length,
            itemBuilder: (context, index) {
              final book = books![index];

              return ListTile(
                leading: ImageIcon(
                  AssetImage('assets/images/bookshelf.png'),
                  color: Colors.black,
                ),
                title: Text(book['title']),
                subtitle: Text(book['author']),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookScreen(
                                book: book[index],
                              )));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        openCloseDial: isDialOpen,
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 15,
        closeManually: true,
        children: [
          SpeedDialChild(
              child: Icon(Icons.book),
              label: 'Add Book',
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
              onTap: () {
                isDialOpen.value = false;
                _showBarcodeScanner();
              }),
          SpeedDialChild(
              child: Icon(Icons.person),
              label: 'Add Student',
              backgroundColor: Colors.purpleAccent,
              foregroundColor: Colors.white,
              onTap: () {
                print('Add Student Tapped');
              }),
        ],
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

  //BARCODE SCANNER

  _showBarcodeScanner() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Scaffold(
                appBar: _buildBarcodeScannerAppBar(),
                body: _buildBarcodeScannerBody(),
              ));
        });
      },
    );
  }

  AppBar _buildBarcodeScannerAppBar() {
    return AppBar(
      bottom: PreferredSize(
        child: Container(color: Colors.white, height: 4.0),
        preferredSize: const Size.fromHeight(4.0),
      ),
      title: const Text('Scan Your Barcode'),
      elevation: 0.0,
      backgroundColor: Colors.purpleAccent,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Center(
            child: Icon(
          Icons.cancel,
          color: Colors.white,
        )),
      ),
      actions: [
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () => controller.toggleTorchMode(),
                child: const Icon(Icons.flashlight_on))),
      ],
    );
  }

  Widget _buildBarcodeScannerBody() {
    return SizedBox(
      height: 400,
      child: ScanView(
        controller: controller,
        scanAreaScale: .7,
        scanLineColor: Colors.white,
        onCapture: (data) {
          setState(() {
            _scanResult = data;
            Navigator.of(context).pop();
          });
        },
      ),
    );
  }
}



//////////////////////////////////////////////////////////////////////////////
///FLOAING ACTION BUTTON
//////////////////////////////////////////////////////////////////////////////



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

