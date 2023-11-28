import 'package:blitz/widgets/BottomCartSheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemBottomNavbar extends StatelessWidget {
  final String id;
  final String name;
  final int quantity;
  final int price;
  final String size;
  final String sku;
  final String image;

  ItemBottomNavbar(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.price,
      required this.size,
      required this.sku,
      required this.image});

  final user = FirebaseAuth.instance.currentUser;

  void addToCart(BuildContext context) {
    if (size == '') {
      Fluttertoast.showToast(
          msg: 'Please select you size first.',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.amber,
          textColor: Colors.black,
          fontSize: 16.0);
      return;
    }
    var firestore = FirebaseFirestore.instance;

    var data = {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'total': quantity * price,
      'size': size,
      'sku': sku,
      'image': image
    };

    firestore
        .collection('cart')
        .doc(user!.uid)
        .collection('items')
        .doc(id)
        .set(data)
        .then((value) {
      Fluttertoast.showToast(
          msg: 'Item has been add to your bag',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF232323),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                decoration: BoxDecoration(
                  color: Color(0xFFFFCD05),
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
                    addToCart(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        CupertinoIcons.cart_badge_plus,
                        color: Colors.black,
                        size: 32,
                      )
                    ],
                  ),
                )),
          ),
          SizedBox(width: 20),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
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
                // showSlidingBottomSheet(context, builder: (context) {
                //   return SlidingSheetDialog(
                //       elevation: 8,
                //       cornerRadius: 16,
                //       builder: (context, state) {
                //         return BottomCartSheet();
                //       });
                // });
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        child: BottomCartSheet(),
                      );
                    });
              },
              child: Icon(
                Icons.shopping_bag,
                color: Colors.black,
                size: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
