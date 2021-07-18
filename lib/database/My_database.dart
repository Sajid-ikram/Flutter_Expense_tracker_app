import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../widgets/Data_Structure.dart';

class MyDatabase {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
          join(await getDatabasesPath(), "transaction.db"),
          version: 1, onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE Expense(id INTEGER PRIMARY KEY autoincrement, title TEXT, description TEXT, datetime TEXT, price REAL)",
        );
        await db.execute(
          "CREATE TABLE Income(id INTEGER PRIMARY KEY autoincrement, title TEXT, description TEXT, datetime TEXT, price REAL)",
        );
      }).catchError((error) {
        throw error;
      });
    }
  }

  Future<int> insertData(DataSample data, String tableN) async {
    try {
      await openDb();
      return await _database.insert(tableN, data.toMap());
    } catch (e) {
      throw e;
    }
  }

  Future<List<DataSample>> getDataList(String tableN) async {
    try {
      await openDb();
      final List<Map<String, dynamic>> maps = await _database.query(tableN);
      return List.generate(maps.length, (i) {
        return DataSample(
            id: maps[i]['id'],
            title: maps[i]['title'],
            description: maps[i]['description'],
            datetime: DateTime.parse(maps[i]['datetime']),
            price: maps[i]['price']);
      });
    } catch (e) {
      throw e;
    }
  }

  Future<int> updateTransaction(DataSample tr, String table) async {
    try {
      await openDb();
      return await _database
          .update(table, tr.toMap(), where: "id = ?", whereArgs: [tr.id]);
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteTransaction(int id, String table) async {
    try {
      await openDb();
      await _database.delete(table, where: "id = ?", whereArgs: [id]);
    } catch (error) {
      throw error;
    }
  }
}
