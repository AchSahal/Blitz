import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blitz/widgets/HomeBottomNavbar.dart';
import 'package:blitz/widgets/BottomCartSheet.dart';

import '../helper/utils.dart';
// import 'package:sliding_sheet/sliding_sheet.dart';

class FavoritePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  Stream<List<DocumentSnapshot>> getFavItems() {
    return FirebaseFirestore.instance
        .collection('fav')
        .doc(user!.uid)
        .collection('items')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorite Items'),
          backgroundColor: Color(0xFF121212),
        ),
        body: StreamBuilder<List<DocumentSnapshot>>(
          stream: getFavItems(),
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data!;

              return Material(
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  color: Color(0xFF121212),
                  child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      final documentId = documents[index].id;

                      // Customize how you want to display each item in the horizontal list
                      return data.length > 0
                          ? Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF232323),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "itemPage");
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, right: 60),
                                                height: 90,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              Image.network(
                                                data['image'],
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.contain,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  data['name'],
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                Utils.formatPrice(
                                                    data['price']),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context, "itemPage",
                                                        arguments: {
                                                          "id": documentId,
                                                        });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                        color: Colors.amber),
                                                    child: Text('Add to cart'),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Container(
                                            child: InkWell(
                                                onTap: () {
                                                  var favDocumentRef =
                                                      FirebaseFirestore.instance
                                                          .collection('fav')
                                                          .doc(user!.uid)
                                                          .collection('items')
                                                          .doc(documentId);

                                                  FirebaseFirestore.instance
                                                      .runTransaction(
                                                          (transaction) async {
                                                    await transaction
                                                        .delete(favDocumentRef);
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: 30,
                                                ))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                "Fav items still empty",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                    },
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'Cart empty',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ));
  }
}
