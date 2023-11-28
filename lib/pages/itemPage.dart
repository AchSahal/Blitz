import 'package:blitz/widgets/itemBottomNavbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import '../helper/utils.dart';

class ItemPage extends StatefulWidget {
  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final user = FirebaseAuth.instance.currentUser;
  String? selectedSize;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Map<String, String>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final String? uid = arguments?['id'];

    void addFavorit(
        String id, String name, int price, String sku, String image) async {
      var firestore = FirebaseFirestore.instance;

      var data = {
        'id': id,
        'name': name,
        'price': price,
        'sku': sku,
        'image': image,
        'total': price
      };

      firestore
          .collection('fav')
          .doc(user!.uid)
          .collection('items')
          .doc(id)
          .set(data)
          .then((value) {
        Fluttertoast.showToast(
            msg: 'Item has been add to your whistlist',
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 16.0);
        Navigator.pop(context);
      }).catchError((error) {
        Fluttertoast.showToast(
            msg: error,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.black,
            fontSize: 16.0);
      });
    }

    Future<DocumentSnapshot<Object?>> getData() async {
      String docID = uid!;

      DocumentReference docRef = firestore.collection("product").doc(docID);

      return docRef.get();
    }

    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<DocumentSnapshot>(
              future: getData(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data!.data() as Map<String, dynamic>;
                var documentId = snapshot.data!.id;
                var rating = data['rating'];
                var roundedRating = rating.floor();
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // Goes back
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Color(0xFF656565),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              addFavorit(documentId, data['name'],
                                  data['price'], data['sku'], data['image']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 2,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite,
                                size: 30,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.43,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 260,
                              width: 350,
                              margin: EdgeInsets.only(bottom: 20, right: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Image.network(
                              data['image'],
                              height: 360,
                              width: 360,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.34,
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF232323),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35),
                            topLeft: Radius.circular(35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .94,
                                child: Text(
                                  data['name'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                Utils.formatPrice(data['price']),
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: RatingBar.builder(
                                  allowHalfRating: true,
                                  initialRating: data['rating'],
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemSize: 20,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  onRatingUpdate: (index) {},
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                data['description'],
                                style: TextStyle(
                                  color: Color(0xFF969696).withOpacity(0.8),
                                  fontSize: 17,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Text(
                                    "Size: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Row(
                                    children: [
                                      for (var size in data['size'])
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedSize = size.toString();
                                            });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              color: selectedSize == size
                                                  ? Color(0xFFFFCD05)
                                                  : Colors.white,
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
                                            child: Text(
                                              size.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                    ItemBottomNavbar(
                        id: documentId,
                        name: data['name'],
                        quantity: 1,
                        price: data['price'],
                        size: selectedSize.toString(),
                        sku: data['sku'] != null ? data['sku'] : '',
                        image: data['image']),
                  ],
                );
              })),
    );
  }
}
