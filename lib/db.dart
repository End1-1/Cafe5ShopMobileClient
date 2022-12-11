import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


List<String> dbCreate = [
  "create table currency (id integer primary key, name text)",
  "create table currency_crossrate (id integer primary key, curr1 int, curr2 int, rate real)",
  "create table goods (id integer primary key, groupid integer, name text, barcode text)",
  "create table goods_pricelist (goods integer, currencyid integer, price1 real, price2 real)"
];

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
          List<String> oldTable = ["currency", "currency_crossrate", "goods", "goods_pricelist"];
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
        }, version: 38)
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
