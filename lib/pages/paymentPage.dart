import 'package:blitz/helper/utils.dart';
import 'package:blitz/pages/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class PaymentPage extends StatelessWidget {
  final String name;

  final String image;
  PaymentPage({super.key, required this.name, required this.image});
  final user = FirebaseAuth.instance.currentUser;

  late int totPrice = 0;

  String generateUniqueId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  Future<int> getCartTotalPrice() async {
    int totalPrice = 0;

    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('items')
        .get();

    for (QueryDocumentSnapshot<Object?> document in cartSnapshot.docs) {
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      if (data != null) {
        int price =
            data['total'] ?? 0; // Assuming price is a numeric field of type int
        totalPrice += price;
      }
    }
    totPrice = totalPrice;
    return totalPrice;
  }

  void createTransaction(BuildContext context) async {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('items')
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    String transactionId = Uuid().v4();
// Get the current date
    String paymentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Iterate over the cart documents and add them to the 'transaction' collection
    for (QueryDocumentSnapshot cartDocument in cartSnapshot.docs) {
      Map<String, dynamic>? cartData =
          cartDocument.data() as Map<String, dynamic>?;

      if (cartData != null) {
        // Create a reference for the new transaction document
        DocumentReference transactionDocRef = FirebaseFirestore.instance
            .collection('transaction')
            .doc(user!.uid)
            .collection('id')
            .doc(transactionId)
            .collection('item')
            .doc(cartDocument.id);

        // Add the cart data to the transaction document
        // Add the payment name to the 'id' collection
        DocumentReference idDocRef = FirebaseFirestore.instance
            .collection('transaction')
            .doc(user!.uid)
            .collection('id')
            .doc(transactionId);
        batch.set(idDocRef, {
          'paymentId': transactionId,
          'paymentDate': paymentDate,
          'paymentName': name,
          'total': totPrice
        });

        // Add the cart data to the transaction document
        batch.set(transactionDocRef, cartData);

        // Delete the cart document
        batch.delete(cartDocument.reference);
      }
    }

    // Commit the batch operation
    await batch.commit();

    Fluttertoast.showToast(
        msg: 'Payment Success',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      image,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Pay using $name',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: getCartTotalPrice(),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int totalPrice = snapshot.data ?? 0;

                          return Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                Utils.formatPrice(totalPrice),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ));
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                foregroundColor: Colors.black),
                            onPressed: () {
                              createTransaction(context);
                            },
                            child: Text("Pay")),
                      ),
                    ),
                    // Text(Utils.formatPrice(total)),
                  ],
                ))));
  }
}
