// // import 'package:flutter/material.dart';
// // import 'package:my_wordrobe_v2/features/cart/cart_view.dart';
// // import 'package:my_wordrobe_v2/features/home/add_item_view.dart';
// // import 'package:my_wordrobe_v2/features/home/favorite_item_view.dart';
// // import 'package:my_wordrobe_v2/features/home/home_view.dart';
// // import 'package:my_wordrobe_v2/features/profile/profile_view.dart';

// // class RootPage extends StatefulWidget {
// //   const RootPage({super.key});

// //   @override
// //   State<RootPage> createState() => _RootPageState();
// // }

// // class _RootPageState extends State<RootPage> {
// //   int _selectedIndex = 0;

// //   // Map tab indices to views (5 items for 5 tabs)
// //   final List<Widget> _tabViews = [
// //     const HomeView(), // index 0
// //     const FavoriteItemView(), // index 1
// //     const AddItemView(), // index 2
// //     const CartView(), // index 3
// //     const ProfileView(), // index 4
// //   ];

// //   void _onTabTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _tabViews[_selectedIndex],
// //       bottomNavigationBar: BottomAppBar(
// //         color: Colors.white,
// //         elevation: 10,
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: List.generate(5, (index) {
// //               final icons = [
// //                 Icons.home_outlined,
// //                 Icons.favorite_border,
// //                 Icons.article_outlined,
// //                 Icons.shopping_bag_outlined,
// //                 Icons.person_2_outlined,
// //               ];

// //               return IconButton(
// //                 onPressed: () => _onTabTapped(index),
// //                 icon: Icon(
// //                   icons[index],
// //                   size: 28,
// //                   color: index == 4 ? Colors.black : Colors.blue,
// //                 ),
// //               );
// //             }),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:my_wordrobe_v2/features/view/cart/cart_view.dart';
// import 'package:my_wordrobe_v2/features/view/home/add_item_view.dart';
// import 'package:my_wordrobe_v2/features/view/home/favorite_item_view.dart';
// import 'package:my_wordrobe_v2/features/view/home/home_view.dart';
// import 'package:my_wordrobe_v2/features/view/profile/profile_view.dart';

// class RootPage extends StatefulWidget {
//   const RootPage({super.key});

//   @override
//   State<RootPage> createState() => _RootPageState();
// }

// class _RootPageState extends State<RootPage> {
//   int _selectedIndex = 0;

//   final List<Widget> _tabViews = [
//     const HomeView(), // 0
//     const FavoriteItemView(), // 1
//     const AddItemView(), // 2
//     const CartView(), // 3
//     const ProfileView(), // 4
//   ];

//   final List<IconData> _icons = [
//     Icons.home_outlined,
//     Icons.favorite_border,
//     Icons.add_circle_outline,
//     Icons.shopping_bag_outlined,
//     Icons.person_2_outlined,
//   ];

//   final List<String> _labels = ["Home", "Favorites", "Add", "Cart", "Profile"];

//   void _onTabTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _tabViews[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onTabTapped,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: List.generate(5, (index) {
//           return BottomNavigationBarItem(
//             icon: Icon(_icons[index]),
//             label: _labels[index],
//           );
//         }),
//       ),
//     );
//   }
// }

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:my_wordrobe_v2/core/utils/app_colors.dart';
import 'package:my_wordrobe_v2/features/view/cart/cart_view.dart';
import 'package:my_wordrobe_v2/features/view/home/add_item_view.dart';
import 'package:my_wordrobe_v2/features/view/home/edit_item_view.dart';
import 'package:my_wordrobe_v2/features/view/home/favorite_item_view.dart';
import 'package:my_wordrobe_v2/features/view/home/home_view.dart';
import 'package:my_wordrobe_v2/features/view/profile/profile_view.dart';

class RootPage extends StatefulWidget {
  final int initialIndex;
  final int? editItemId;

  const RootPage({super.key, this.initialIndex = 0, this.editItemId});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _tabViews = [
      const HomeView(), // 0
      const FavoriteItemView(), // 1
      widget.editItemId != null
          ? EditItemView(itemId: widget.editItemId!)
          : const AddItemView(), // 2
      const CartView(), // 3
      const ProfileView(), // 4
    ];

    final List<IconData> _icons = [
      Icons.home_outlined,
      Icons.favorite_border,
      Icons.add_circle_outline,
      Icons.shopping_bag_outlined,
      Icons.person_2_outlined,
    ];

    final List<String> _labels = [
      "Home",
      "Favorites",
      "Add",
      "Cart",
      "Profile",
    ];

    return Scaffold(
      body: _tabViews[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: Icon(_icons[index]),
            label: _labels[index],
          );
        }),
      ),
    );
  }
}
