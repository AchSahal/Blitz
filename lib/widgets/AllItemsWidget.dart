import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../helper/utils.dart';

class AllItemsWidget extends StatelessWidget {
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('product').snapshots();

  @override
  Widget build(BuildContext context) {
    // return GridView.count(
    //   crossAxisCount: 2,
    //   childAspectRatio: 0.68,
    //   physics: NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   children: [
    //     for (int i = 1; i < 7; i++)
    //       Container(
    //         padding: EdgeInsets.only(left: 15, right: 15, top: 10),
    //         margin: EdgeInsets.all(8),
    //         decoration: BoxDecoration(
    //           color: Color(0xFF232323),
    //           borderRadius: BorderRadius.circular(10),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Color(0xFF121212).withOpacity(0.3),
    //               blurRadius: 2,
    //               spreadRadius: 1,
    //             ),
    //           ],
    //         ),
    //         child: Column(
    //           children: [
    //             InkWell(
    //               onTap: () {
    //                 Navigator.pushNamed(context, "itemPage");
    //               },
    //               child: Padding(
    //                 padding: EdgeInsets.all(10),
    //                 child: Image.asset(
    //                   "lib/images/$i.png",
    //                   height: 130,
    //                   width: 130,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.only(bottom: 8),
    //               child: Container(
    //                 alignment: Alignment.centerLeft,
    //                 child: Text(
    //                   "Nike Shoe",
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 20,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               alignment: Alignment.centerLeft,
    //               child: Text(
    //                 "New Nike Shoe for Men",
    //                 style: TextStyle(
    //                   color: Color(0xFF969696).withOpacity(0.8),
    //                   fontSize: 15,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.symmetric(vertical: 10),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     "\$55",
    //                     style: TextStyle(
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.w500,
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                   InkWell(
    //                     onTap: () {},
    //                     child: Container(
    //                       padding: EdgeInsets.all(5),
    //                       decoration: BoxDecoration(
    //                         color: Color(0xFF656565),
    //                         borderRadius: BorderRadius.circular(10),
    //                       ),
    //                       child: Icon(
    //                         CupertinoIcons.cart_fill_badge_plus,
    //                         color: Colors.white,
    //                         size: 28,
    //                       ),
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //   ],
    // );
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return SizedBox(
              height: MediaQuery.of(context).size.height * .45,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust the number of columns as needed
                  // crossAxisSpacing: 10.0,
                  // mainAxisSpacing: 10.0,
                ),
                itemCount: documents.length,
                itemBuilder: (BuildContext context, int index) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  final documentId = documents[index].id;
                  return Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF232323),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF121212).withOpacity(0.3),
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "itemPage",
                                arguments: {
                                  "id": documentId,
                                });
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: Column(
                              children: [
                                Image.network(
                                  data['image'],
                                  height: 90,
                                  width: 90,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    data['name'],
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  Utils.formatPrice(data['price']),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
        }

        return Text('No data available');
      },
    );
  }
}
