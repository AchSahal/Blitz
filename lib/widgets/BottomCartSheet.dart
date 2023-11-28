import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/utils.dart';

class BottomCartSheet extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  Stream<List<DocumentSnapshot>> getCartDataStream() {
    return FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('items')
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
                child: Column(
                  children: [
                    Expanded(
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          Spacer(),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 5,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    var cartDocumentRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('cart')
                                                            .doc(user!.uid)
                                                            .collection('items')
                                                            .doc(documentId);

                                                    FirebaseFirestore.instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                      DocumentSnapshot
                                                          snapshot =
                                                          await transaction.get(
                                                              cartDocumentRef);

                                                      if (snapshot.exists) {
                                                        int quantity = snapshot
                                                            .get('quantity');
                                                        int price = snapshot
                                                            .get('price');

                                                        if (quantity > 1) {
                                                          transaction.update(
                                                              cartDocumentRef, {
                                                            'quantity':
                                                                quantity - 1,
                                                            'total':
                                                                (quantity - 1) *
                                                                    price
                                                          });
                                                        } else {
                                                          transaction.delete(
                                                              cartDocumentRef);
                                                        }
                                                      }
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                data['quantity'].toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 5,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    var cartDocumentRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('cart')
                                                            .doc(user!.uid)
                                                            .collection('items')
                                                            .doc(documentId);

                                                    FirebaseFirestore.instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                      DocumentSnapshot
                                                          snapshot =
                                                          await transaction.get(
                                                              cartDocumentRef);

                                                      if (snapshot.exists) {
                                                        int quantity = snapshot
                                                            .get('quantity');
                                                        int price = snapshot
                                                            .get('price');

                                                        transaction.update(
                                                            cartDocumentRef, {
                                                          'quantity':
                                                              quantity + 1,
                                                          'total':
                                                              (quantity + 1) *
                                                                  price
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Text(
                                            Utils.formatPrice(data['total']),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        child: InkWell(
                                            onTap: () {
                                              var cartDocumentRef =
                                                  FirebaseFirestore.instance
                                                      .collection('cart')
                                                      .doc(user!.uid)
                                                      .collection('items')
                                                      .doc(documentId);

                                              FirebaseFirestore.instance
                                                  .runTransaction(
                                                      (transaction) async {
                                                await transaction
                                                    .delete(cartDocumentRef);
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
                        );
                      },
                    )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.amber),
                        onPressed: () {
                          // Handle the button press, e.g., navigate to the payment page
                          Navigator.pushNamed(context, "checkoutPage");
                        },
                        child: Text(
                          'Checkout',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}
