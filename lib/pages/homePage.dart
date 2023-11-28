import 'package:blitz/widgets/AllItemsWidget.dart';
import 'package:blitz/widgets/HomeBottomNavbar.dart';
import 'package:blitz/widgets/RowItemsWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex =
      0; // tambahkan properti currentIndex dengan nilai default 0

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> productStream =
      FirebaseFirestore.instance.collection('product').limit(20).snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'lib/images/Blitz Black resize.png',
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "aboutUs");
                      },
                      child: const Icon(
                        Icons.info,
                        size: 30,
                        color: Color(0xFF656565),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF121212).withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 300,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                          ),
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.search,
                        size: 27,
                        color: Color(0xFF656565),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'New Products',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                RowItemsWidget(),
                SizedBox(height: 20),
                AllItemsWidget(),
              ],
            ),
          ),
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
