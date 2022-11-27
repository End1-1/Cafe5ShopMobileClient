import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Db {
  static Database? db;

  static init(List<String> createList) {
    if (db == null) {
      getDatabasesPath().then((value) {
        openDatabase(join(value, 'tasks.db'), onCreate: (db, version) {
          for (String s in createList) {
            db.execute(s);
          }
        }, onUpgrade: (db, oldVersion, newVersion) {
          List<String> oldTable = ["halls", "tables", "dish_part1", "dish_part2", "dish", "car_model", "dish_menu", "dish_comment"];
          for (String t in oldTable) {
            try {
              db.execute("drop table $t");
            } catch (e) {
              print(e);
            }
          }
          for (String s in createList) {
            db.execute(s);
          }
        }, version: 33)
            .then((value) => db = value);
      });
    }
  }

  static void delete(String sql, [List<Object?>? args]) async {
    await db!.rawDelete(sql, args);
  }

  static Future<int> insert(String sql, [List<Object?>? args]) async {
    int result = await db!.rawInsert(sql, args);
    return result;
  }

  static Future<List<Map<String, dynamic?>>> query(String table, {String? orderBy,}) async {
    return await db!.query(table, orderBy: orderBy);
  }

  static Future<int> update(String table, Map<String, Object?> values,  {String? where,  List<Object?>? whereArgs,}) async {
    return await db!.update(table, values, where: where, whereArgs: whereArgs);
  }

  static Future<List<Map<String, dynamic?>>> rawQuery(String sql) async {
    return await db!.rawQuery(sql);
  }
}
