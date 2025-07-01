// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_wordrobe_v2/core/utils/app_colors.dart';
import 'package:my_wordrobe_v2/features/data/db_helper.dart';
import 'package:my_wordrobe_v2/features/data/item_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<ItemModel> allItems = [];
  List<ItemModel> filteredItems = [];

  final TextEditingController searchController = TextEditingController();
  String selectedColor = 'All';

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload items when screen becomes visible again
    loadItems();
  }

  Future<void> loadItems() async {
    final items = await DBHelper.getAllItems();
    for (var i in items) {
      print("Loaded item: ${i.name} - path: ${i.imagePath}");
    }
    setState(() {
      allItems = items;
    });
    filterItems();
  }

  void filterItems() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredItems = allItems.where((item) {
        final matchesColor =
            selectedColor == 'All' ||
            item.color.toLowerCase() == selectedColor.toLowerCase();
        final matchesSearch =
            item.name.toLowerCase().contains(query) ||
            item.color.toLowerCase().contains(query);
        return matchesColor && matchesSearch;
      }).toList();
    });
  }

  Future<void> pickItem(ItemModel item) async {
    final updated = ItemModel(
      id: item.id,
      name: item.name,
      color: item.color,
      type: item.type,
      imagePath: item.imagePath,
      isPicked: true,
    );
    await DBHelper.updateItem(updated);
    loadItems(); // refresh UI
  }

  ImageProvider getItemImage(String path) {
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    } else {
      return const AssetImage('assets/images/placeholder.jpg');
    }
  }

  Future<void> deleteItem(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DBHelper.deleteItem(id);
      loadItems(); // refresh UI
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item deleted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 13, 7, 23),
        onPressed: () async {
          await GoRouter.of(context).push('/addItem');
          loadItems(); // reload after returning
        },
        child: const Icon(Icons.add, color: AppColors.primaryColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Search and Filters
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => filterItems(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: '#clothes #shoes ...',
                          hintText: 'Search',
                          suffixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedColor,
                      onChanged: (value) {
                        selectedColor = value!;
                        filterItems();
                      },
                      items: ['All', 'Red', 'Blue', 'Black', 'White', 'Green']
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => GoRouter.of(context).go('/cart'),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              const SliverToBoxAdapter(
                child: Text(
                  'Bienvenue, Riyam!',
                  style: TextStyle(
                    color: Color(0xFF202020),
                    fontSize: 28,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w700,
                    height: 1.29,
                    letterSpacing: -0.28,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // Grid of Items
              filteredItems.isEmpty
                  ? const SliverToBoxAdapter(
                      child: Center(child: Text("No items found")),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = filteredItems[index];
                        return Column(
                          children: [
                            Container(
                              width: 180,
                              height: 220,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: getItemImage(item.imagePath),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // TODO
                            Column(
                              children: [
                                // The "Pick" button container (full width)
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  // color: const Color.fromRGBO(244, 67, 54, 1),
                                  child: GestureDetector(
                                    onTap: () => pickItem(item),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 40,
                                      decoration: ShapeDecoration(
                                        color: AppColors.primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            11,
                                          ),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Pick',
                                          style: TextStyle(
                                            color: Color(0xFFF3F3F3),
                                            fontSize: 16,
                                            fontFamily: 'Nunito Sans',
                                            fontWeight: FontWeight.w300,
                                            height: 1.56,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Row with two floating action buttons: Edit and Delete
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FloatingActionButton(
                                      heroTag: 'edit_${item.id}',
                                      onPressed: () async {
                                        await GoRouter.of(
                                          context,
                                        ).push('/editItem', extra: item.id);
                                        loadItems();
                                      },
                                      backgroundColor: Colors.orange,
                                      mini: true,
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    FloatingActionButton(
                                      heroTag: 'delete_${item.id}',
                                      onPressed: () => deleteItem(item.id!),
                                      backgroundColor: Colors.red,
                                      mini: true,
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }, childCount: filteredItems.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.5,
                          ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:my_wordrobe_v2/core/utils/app_colors.dart';
// import 'package:my_wordrobe_v2/features/data/db_helper.dart';
// import 'package:my_wordrobe_v2/features/data/item_model.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   List<ItemModel> allItems = [];
//   List<ItemModel> filteredItems = [];

//   final TextEditingController searchController = TextEditingController();
//   String selectedColor = 'All';

//   @override
//   void initState() {
//     super.initState();
//     loadItems();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Reload items when screen becomes visible again
//     loadItems();
//   }

//   Future<void> loadItems() async {
//     final items = await DBHelper.getAllItems();
//     setState(() {
//       allItems = items;
//     });
//     filterItems();
//   }

//   void filterItems() {
//     final query = searchController.text.toLowerCase();

//     setState(() {
//       filteredItems = allItems.where((item) {
//         final matchesColor =
//             selectedColor == 'All' ||
//             item.color.toLowerCase() == selectedColor.toLowerCase();
//         final matchesSearch =
//             item.name.toLowerCase().contains(query) ||
//             item.color.toLowerCase().contains(query);
//         return matchesColor && matchesSearch;
//       }).toList();
//     });
//   }

//   Future<void> pickItem(ItemModel item) async {
//     final updated = ItemModel(
//       id: item.id,
//       name: item.name,
//       color: item.color,
//       type: item.type,
//       imagePath: item.imagePath,
//       isPicked: true,
//     );
//     await DBHelper.updateItem(updated);
//     loadItems(); // refresh UI
//   }

//   Future<void> deleteItem(int id) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete Item'),
//         content: const Text('Are you sure you want to delete this item?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(true),
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await DBHelper.deleteItem(id);
//       loadItems();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Item deleted')),
//       );
//     }
//   }

//   ImageProvider getItemImage(String path) {
//     final file = File(path);
//     if (file.existsSync()) {
//       return FileImage(file);
//     } else {
//       return const AssetImage('assets/images/placeholder.jpg');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.secondaryColor,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.secondaryColor,
//         onPressed: () async {
//           await GoRouter.of(context).push('/addItem');
//           loadItems(); // reload after returning
//         },
//         child: const Icon(Icons.add, color: AppColors.primaryColor),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: CustomScrollView(
//             slivers: [
//               const SliverToBoxAdapter(child: SizedBox(height: 20)),

//               // Search and Filters
//               SliverToBoxAdapter(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     SizedBox(
//                       width: 200,
//                       height: 40,
//                       child: TextField(
//                         controller: searchController,
//                         onChanged: (_) => filterItems(),
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           labelText: '#clothes #shoes ...',
//                           hintText: 'Search',
//                           suffixIcon: const Icon(Icons.search),
//                         ),
//                       ),
//                     ),
//                     DropdownButton<String>(
//                       value: selectedColor,
//                       onChanged: (value) {
//                         selectedColor = value!;
//                         filterItems();
//                       },
//                       items: ['All', 'Red', 'Blue', 'Black', 'White', 'Green']
//                           .map(
//                             (c) => DropdownMenuItem(value: c, child: Text(c)),
//                           )
//                           .toList(),
//                     ),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () => GoRouter.of(context).go('/cart'),
//                       child: const Icon(
//                         Icons.shopping_bag,
//                         color: AppColors.primaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SliverToBoxAdapter(child: SizedBox(height: 20)),

//               const SliverToBoxAdapter(
//                 child: Text(
//                   'Bienvenue, Riyam!',
//                   style: TextStyle(
//                     color: Color(0xFF202020),
//                     fontSize: 28,
//                     fontFamily: 'Raleway',
//                     fontWeight: FontWeight.w700,
//                     height: 1.29,
//                     letterSpacing: -0.28,
//                   ),
//                 ),
//               ),

//               const SliverToBoxAdapter(child: SizedBox(height: 20)),

//               // Grid of Items
//               filteredItems.isEmpty
//                   ? const SliverToBoxAdapter(
//                       child: Center(child: Text("No items found")),
//                     )
//                   : SliverGrid(
//                       delegate: SliverChildBuilderDelegate((context, index) {
//                         final item = filteredItems[index];
//                         return Column(
//                           children: [
//                             Container(
//                               width: 180,
//                               height: 220,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: getItemImage(item.imagePath),
//                                   fit: BoxFit.cover,
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Colors.grey[200],
//                               ),
//                             ),
//                             const SizedBox(height: 10),

//                             // Pick Button
//                             GestureDetector(
//                               onTap: () => pickItem(item),
//                               child: Container(
//                                 width: 120,
//                                 height: 40,
//                                 decoration: ShapeDecoration(
//                                   color: AppColors.primaryColor,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(11),
//                                   ),
//                                 ),
//                                 child: const Center(
//                                   child: Text(
//                                     'Pick',
//                                     style: TextStyle(
//                                       color: Color(0xFFF3F3F3),
//                                       fontSize: 16,
//                                       fontFamily: 'Nunito Sans',
//                                       fontWeight: FontWeight.w300,
//                                       height: 1.56,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(height: 6),

//                             // Edit and Delete Buttons Row
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 // Edit Button
//                                 ElevatedButton(
//                                   onPressed: () async {
//                                     await GoRouter.of(context)
//                                         .push('/editItem', extra: item.id);
//                                     loadItems();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.orange,
//                                     minimumSize: const Size(70, 36),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'Edit',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),

//                                 const SizedBox(width: 12),

//                                 // Delete Button
//                                 ElevatedButton(
//                                   onPressed: () => deleteItem(item.id!),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                     minimumSize: const Size(70, 36),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'Delete',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       }, childCount: filteredItems.length),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 6,
//                         mainAxisSpacing: 10,
//                         childAspectRatio: 0.6,
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
