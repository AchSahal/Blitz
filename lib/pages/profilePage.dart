import 'package:blitz/helper/utils.dart';
import 'package:blitz/pages/signinPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blitz/widgets/HomeBottomNavbar.dart';
import 'package:blitz/widgets/BottomCartSheet.dart';
import 'package:intl/intl.dart';
// import 'package:sliding_sheet/sliding_sheet.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Future<List<QueryDocumentSnapshot>> getTransactionHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('transaction')
        .doc(user!.uid)
        .collection('id')
        .orderBy('paymentDate', descending: true)
        .get();

    // Return the list of transaction documents
    return querySnapshot.docs;
  }

  Future<DocumentSnapshot<Object?>> getProfile() async {
    DocumentReference docRef = firestore.collection("users").doc(user!.uid);

    return docRef.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CircleAvatar(
            //   radius: 50.0,
            //   backgroundImage: AssetImage('lib/images/zidanpp.png'),
            // ),
            // SizedBox(height: 16.0),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8.0),
            //     color: Color(0xFF232323),
            //   ),
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     'Full Name',
            //     style: TextStyle(
            //       fontSize: 24.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8.0),
            //     color: Color(0xFF232323),
            //   ),
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     'email@example.com',
            //     style: TextStyle(
            //       fontSize: 16.0,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 16.0),
            // Text(
            //   'Shipping Address',
            //   style: TextStyle(
            //     fontSize: 20.0,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(8.0),
            //     color: Color(0xFF232323),
            //   ),
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     '123 Street, City, Country',
            //     style: TextStyle(
            //       fontSize: 16.0,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            FutureBuilder<DocumentSnapshot>(
                future: getProfile(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  var documentId = snapshot.data!.id;
                  var name = data['name'];
                  var address = data['address'];
                  var email = data['email'];

                  return Column(children: [
                    Row(
                      children: [
                        Image.network(
                          data['image'],
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              address,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ]);
                }),
            SizedBox(height: 26.0),
            Text(
              'Order History',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: FutureBuilder<List<QueryDocumentSnapshot>>(
                future: getTransactionHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> transactionDocuments =
                        snapshot.data!;

                    // Render the transaction history list
                    return ListView.builder(
                      itemCount: transactionDocuments.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot transaction =
                            transactionDocuments[index];

                        // Customize how you want to display each transaction item
                        return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          DateFormat('dd MMMM yyyy').format(
                                              DateTime.parse(
                                                  transaction['paymentDate'])),
                                          style:
                                              TextStyle(color: Colors.white)),
                                      // Text(transaction['paymentId']),
                                      Text(
                                        transaction['paymentName'],
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Utils.formatPrice(transaction['total']),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ));
                      },
                    );
                  }

                  // No transaction history
                  return Center(
                      child: Text('No transaction history available.',
                          style: TextStyle(color: Colors.white)));
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  await auth.signOut().then((value) =>
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return SigninPage();
                      })));
                },
                child: Text("Sign out"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex:
            _currentIndex, // set nilai currentIndex dengan nilai _currentIndex
        onTap: (index) {
          setState(() {
            _currentIndex =
                index; // ubah nilai _currentIndex ketika item di tap
          });
        },
      ),
    );
  }
}
