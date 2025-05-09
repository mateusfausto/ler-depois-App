import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ler_depois/models/item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'ler_depois_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        link TEXT NOT NULL,
        category TEXT NOT NULL,
        iconName TEXT,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Helper para converter IconData para String e vice-versa
  String _iconDataToString(IconData icon) {
    if (icon == Icons.newspaper) return 'newspaper';
    if (icon == Icons.shopping_cart) return 'shopping_cart';
    if (icon == Icons.edit) return 'edit';
    if (icon == Icons.delete) return 'delete';
    // Adicione outros ícones conforme necessário e um fallback
    return 'default_icon'; // ou lançar um erro se o ícone não for mapeado
  }

  IconData _stringToIconData(String iconName) {
    switch (iconName) {
      case 'newspaper':
        return Icons.newspaper;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'edit':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.error; // Ícone padrão para casos não mapeados
    }
  }

  Future<int> insertItem(ItemModel item) async {
    final db = await database;
    return await db.insert('items', {
      'title': item.title,
      'link': item.link,
      'category': item.category,
      'iconName': _iconDataToString(item.icon), // Salva o nome do ícone
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<ItemModel>> getAllItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items', orderBy: 'createdAt DESC');
    return List.generate(maps.length, (i) {
      return ItemModel(
        id: maps[i]['id'] as int?,
        title: maps[i]['title'] as String,
        link: maps[i]['link'] as String,
        category: maps[i]['category'] as String,
        icon: _stringToIconData(maps[i]['iconName'] as String),
        // Os ícones de edição e exclusão são fixos no modelo, não precisam vir do DB
        // Se fossem dinâmicos por item, precisariam ser armazenados e recuperados.
        editIcon: Icons.edit, 
        deleteIcon: Icons.delete,
        createdAt: DateTime.parse(maps[i]['createdAt'] as String),
      );
    });
  }

  Future<int> updateItem(ItemModel item) async {
    final db = await database;
    return await db.update(
      'items',
      {
        'title': item.title,
        'link': item.link,
        'category': item.category,
        'iconName': _iconDataToString(item.icon),
      },
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


