import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Category {
  Category({this.name, this.color, this.id});
  final String id;
  final String name;
  final Color color;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'color': color.hashCode};
  }
}

class DataManager {
  static Database database;

  static String blocksTable = 'blocks';
  static String categoriesBox = 'categories';
  static String activeCategoryBox = 'activeCategory';

  static void setup() async {
    await Hive.initFlutter();
    await Hive.openBox(categoriesBox);
    await Hive.openBox(activeCategoryBox);

    final dbPath = join(await getDatabasesPath(), 'time.db');
    database = await openDatabase(dbPath, onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE $blocksTable (category_id TEXT PRIMARY KEY)",
      );
    });
  }

  static Future<List<Category>> fetchCategories() {}

  static void addOrUpdateCategory(Category category) async {
    await database.insert(
      categoriesTable,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static void deleteCategory(String categoryId) async {
    await database.delete(
      categoriesTable,
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  static void writeBlock({String categoryId}) async {}

  static Future<Map<int, Category>> fetchBlocks(int offset) async {
    final maps = await database.query(blocksTable, limit: 100, offset: offset);
    print(maps);
  }
}
