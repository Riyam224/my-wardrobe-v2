// // ignore_for_file: depend_on_referenced_packages

// import 'package:my_wordrobe_v2/features/data/item_model.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DBHelper {
//   static Database? _db;

//   static Future<Database> get database async {
//     if (_db != null) return _db!;
//     final path = join(await getDatabasesPath(), 'wardrobe.db');
//     _db = await openDatabase(path, version: 1, onCreate: _createDB);
//     return _db!;
//   }

//   static void _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE items (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         name TEXT,
//         color TEXT,
//         type TEXT,
//         imagePath TEXT,
//         isPicked INTEGER
//       )
//     ''');
//   }

//   static Future<int> insertItem(ItemModel item) async {
//     final db = await DBHelper.database;
//     return await db.insert(
//       'items',
//       item.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   static Future<List<ItemModel>> getAllItems() async {
//     final db = await database;
//     final result = await db.query('items');
//     return result.map((e) => ItemModel.fromMap(e)).toList();
//   }

//   static Future<List<ItemModel>> getPickedItems() async {
//     final db = await database;
//     final result = await db.query(
//       'items',
//       where: 'isPicked = ?',
//       whereArgs: [1],
//     );
//     return result.map((e) => ItemModel.fromMap(e)).toList();
//   }

//   static Future<List<ItemModel>> searchItems(String query) async {
//     final db = await database;
//     final result = await db.query(
//       'items',
//       where: 'name LIKE ? OR color LIKE ?',
//       whereArgs: ['%$query%', '%$query%'],
//     );
//     return result.map((e) => ItemModel.fromMap(e)).toList();
//   }

//   static Future<void> updateItem(ItemModel item) async {
//     final db = await database;
//     await db.update(
//       'items',
//       item.toMap(),
//       where: 'id = ?',
//       whereArgs: [item.id],
//     );
//   }

//   static Future<void> deleteItem(int id) async {
//     final db = await database;
//     await db.delete('items', where: 'id = ?', whereArgs: [id]);
//   }
// }

import 'package:my_wordrobe_v2/features/data/item_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'wardrobe.db');
    _db = await openDatabase(path, version: 1, onCreate: _createDB);
    return _db!;
  }

  static void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        color TEXT,
        type TEXT,
        imagePath TEXT,
        isPicked INTEGER
      )
    ''');
  }

  // ✅ Insert new item
  static Future<int> insertItem(ItemModel item) async {
    final db = await DBHelper.database;
    return await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Get all items
  static Future<List<ItemModel>> getAllItems() async {
    final db = await database;
    final result = await db.query('items');
    return result.map((e) => ItemModel.fromMap(e)).toList();
  }

  // ✅ Get only picked items
  static Future<List<ItemModel>> getPickedItems() async {
    final db = await database;
    final result = await db.query(
      'items',
      where: 'isPicked = ?',
      whereArgs: [1],
    );
    return result.map((e) => ItemModel.fromMap(e)).toList();
  }

  // ✅ Search by name or color
  static Future<List<ItemModel>> searchItems(String query) async {
    final db = await database;
    final result = await db.query(
      'items',
      where: 'name LIKE ? OR color LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return result.map((e) => ItemModel.fromMap(e)).toList();
  }

  // ✅ Get one item by ID (for showing details or editing)
  static Future<ItemModel?> getItemById(int id) async {
    final db = await database;
    final result = await db.query('items', where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return ItemModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  // ✅ Update item
  static Future<void> updateItem(ItemModel item) async {
    final db = await database;
    await db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  // ✅ Delete item
  static Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> removeFromCart(int id) async {
    final db = await database;
    await db.update('items', {'isPicked': 0}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> addToCart(int id) async {
    final db = await database;
    await db.update('items', {'isPicked': 1}, where: 'id = ?', whereArgs: [id]);
  }
}
