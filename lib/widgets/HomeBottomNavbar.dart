import 'dart:ui';

import 'package:blitz/widgets/BottomCartSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:sliding_sheet/sliding_sheet.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap; // tambahkan ValueChanged untuk onTap
  const HomeBottomNavBar({Key? key, this.currentIndex = 0, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF232323).withOpacity(0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Item 1
          InkWell(
            onTap: () {
              onTap(0); // ubah nilai currentIndex
            },
            child: Icon(
              Icons.home,
              color: currentIndex == 0 ? Color(0xFFFFCD05) : Color(0xFF656565),
              size: 32,
            ),
          ),
          // Item 2
          InkWell(
            onTap: () {
              onTap(1); // ubah nilai currentIndex
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
              CupertinoIcons.cart_fill,
              color: currentIndex == 1 ? Color(0xFFFFCD05) : Color(0xFF656565),
              size: 32,
            ),
          ),
          // Item 3
          InkWell(
            onTap: () {
              onTap(2); // ubah nilai currentIndex
              Navigator.pushNamed(context, "favoritePage");
            },
            child: Icon(
              Icons.favorite,
              color: currentIndex == 2 ? Color(0xFFFFCD05) : Color(0xFF656565),
              size: 32,
            ),
          ),
          // Item 4
          InkWell(
            onTap: () {
              onTap(3); // ubah nilai currentIndex
              Navigator.pushNamed(context, "profilePage");
            },
            child: Icon(
              Icons.person,
              color: currentIndex == 3 ? Color(0xFFFFCD05) : Color(0xFF656565),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
