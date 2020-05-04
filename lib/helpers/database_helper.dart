import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';

class DatabaseHelper{
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  String productsTable = 'product_table';
  String colId = 'id';
  String colName = 'name';
  String colQuantity = 'quantity';
  String colPriority  = 'priority';
  String colStatus = 'status';
  String colToBuy = 'toBuy';

  Future<Database> get db async {
    if(_db == null){
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'tobuy_list.db';
    final tobuyListDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return tobuyListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $productsTable('
            '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colName TEXT, '
            '$colQuantity TEXT, '
            '$colPriority TEXT, '
            '$colStatus INTEGER, '
            '$colToBuy INTEGER)'
    );
  }
////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getProductMapList() async{
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(productsTable);
    return result;
  }

  Future<List<Product>> getProductList() async {
    final List<Map<String, dynamic>> productMapList = await getProductMapList();
    final List<Product> productList = [];
    productMapList.forEach((productMap){
      productList.add(Product.fromMap(productMap));
    });

    return productList;
  }
/////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getProductToBuyMapList() async{
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(
        productsTable,
        where: '$colToBuy = 1'
    );
    return result;
  }

  Future<List<Product>> getProductToBuyList() async {
    final List<Map<String, dynamic>> productMapList = await getProductToBuyMapList();
    final List<Product> productList = [];
    productMapList.forEach((productMap){
      productList.add(Product.fromMap(productMap));
    });

    return productList;
  }
//////////////////////////////////////////////////////
  Future<int> insertProduct(Product product) async {
    Database db = await this.db;
    final int result = await db.insert(productsTable, product.toMap());
    return result;
  }

  Future<int> updateProduct(Product product) async {
    Database db = await this.db;
    final int result = await db.update(
      productsTable,
      product.toMap(),
      where: '$colId = ?',
      whereArgs: [product.id],
    );
    return result;
  }

  Future<int> deleteProduct(int id) async{
    Database db = await this.db;
    final int result = await db.delete(
        productsTable,
        where: '$colId = ?',
        whereArgs: [id]
    );
    return result;
  }
}