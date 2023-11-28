import 'package:blitz/pages/paymentPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/utils.dart';

class BottomPaymentSheet extends StatelessWidget {
  Stream<List<DocumentSnapshot>> getCartDataStream() {
    return FirebaseFirestore.instance
        .collection('payment')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<List<DocumentSnapshot>>(
        stream: getCartDataStream(),
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
                      return Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 80,
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
                                child: InkWell(
                                  onTap: () {
                                    print(data['name']);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentPage(
                                            name: data['name'],
                                            image: data['image']),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Image.network(
                                        data['image'],
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        data['name'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      );
                    },
                  )),
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
      ),
    );
  }
}
