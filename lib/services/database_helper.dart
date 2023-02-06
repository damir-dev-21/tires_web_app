import 'dart:convert';
// import 'dart:ffi';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tires_app_web/models/Message.dart';
import 'package:tires_app_web/models/Order.dart';
import 'package:tires_app_web/models/Orders/Orders.dart';
import 'package:tires_app_web/models/Product.dart';
import 'package:tires_app_web/providers/products_provider.dart';

class HiveHelper {
  Map<String, dynamic> selectOrder(Orders orders, int uuid_order) {
    final query =
        orders.orders.firstWhere((element) => element['userId'] == uuid_order);
    print('is_not_confirm');
    print(query['is_not_confirm']);
    return query;
  }

  void changeOrderIsNotConfirmed(Orders orders, int uuid_order, bool status) {
    // final query_idx =
    //     orders.orders.indexWhere((element) => element['uuid_sale'] == uuid);
    var list = orders.orders;
    final query = list.firstWhere((element) => element['userId'] == uuid_order);
    query['is_not_confirm'] = status;
    ProductProvider().getOrdersFromDb().delete('orders');
    ProductProvider().getOrdersFromDb().put('orders', Orders(list));
  }

  void changeOrderStatus(
    Orders orders,
    int uuid,
    String status,
    String uuid_order,
  ) async {
    var list = orders.orders;
    final query = list.firstWhere((element) => element['userId'] == uuid);
    query['status'] = status;
    query['uuid_sale'] = uuid_order;
    ProductProvider().getOrdersFromDb().delete('orders');
    ProductProvider().getOrdersFromDb().put('orders', Orders(list));
  }
}

// class DatabaseHelper {
//   Future<Database> database() async {
//     return openDatabase(join(await getDatabasesPath(), 'messages.db'),
//         onCreate: _onCreateTables, version: 1);
//   }

//   void _onCreateTables(Database db, int version) {
//     db.execute('''
//       CREATE TABLE IF NOT EXISTS message(
//         id INTEGER PRIMARY KEY, 
//         text TEXT
//       )
//     ''');

//     db.execute('''
//       CREATE TABLE IF NOT EXISTS imei(
//         id INTEGER PRIMARY KEY, 
//         imei TEXT
//       )
//     ''');

//     db.execute('''
//       CREATE TABLE IF NOT EXISTS orders(
//         id INTEGER PRIMARY KEY, 
//         userId INTEGER,
//         number INTEGER,
//         products TEXT,
//         addition_order TEXT,
//         total FLOAT,
//         date TEXT,
//         status TEXT,
//         uuid_sale TEXT,
//         is_not_confirm BOOLEAN
//       )
//     ''');

//     print('Tables was created!');
//   }

//   Future<void> insertMessage(Map<String, dynamic> text) async {
//     Database _db = await database();
//     await _db.insert('message', text,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<void> insertImei(Map<String, dynamic> text) async {
//     Database _db = await database();
//     await _db.insert('imei', text,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<void> insertOrder(Map<String, dynamic> text) async {
//     Database _db = await database();
//     await _db.insert('orders', text,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<void> changeOrderIsNotConfirmed(int uuid, bool status) async {
//     Database _db = await database();
//     await _db.rawUpdate('UPDATE orders SET is_not_confirm = ? WHERE userId = ?',
//         [status, uuid]);
//   }

//   Future<Map<String, dynamic>> selectOrder(int uuid) async {
//     Database _db = await database();
//     List<Map<String, dynamic>> query =
//         await _db.query('orders', where: "userId = ?", whereArgs: [uuid]);
//     // var a = await _db.rawQuery('SELECT * FROM orders WHERE userid = ?', [uuid]);
//     return query[0];
//   }

//   Future<void> changeOrderStatus(
//     int uuid,
//     String status,
//     String uuid_sale,
//   ) async {
//     Database _db = await database();
//     await _db.rawUpdate(
//         'UPDATE orders SET status = ?, uuid_sale = ? WHERE userId = ?',
//         [status, uuid_sale, uuid]);
//   }

//   Future<void> deleteImei() async {
//     Database _db = await database();
//     await _db.delete('imei');
//   }

//   Future<void> deleteMessages() async {
//     Database _db = await database();
//     await _db.delete('message');
//   }

//   Future<void> deleteOrders() async {
//     Database _db = await database();
//     await _db.delete('orders');
//   }

//   Future<List<Message>> getMessages(List<Product> products) async {
//     Database _db = await database();
//     List<Map<String, dynamic>> messageMap = await _db.query('message');
//     return List.generate(messageMap.length, (index) {
//       Message message_convert =
//           Message.setMessageFromMap(messageMap[index], products);
//       return message_convert;
//     });
//   }

//   Future<List<Order>> getOrders() async {
//     Database _db = await database();
//     List<Map<String, dynamic>> ordersMap = await _db.query('orders');
//     return List.generate(ordersMap.length, (index) {
//       Order orderDb = Order.fromJson(ordersMap[index]);
//       return orderDb;
//     });
//   }

//   Future<List<String>> getImei() async {
//     Database _db = await database();
//     List<Map<String, dynamic>> imeiMap = await _db.query('imei');
//     return List.generate(imeiMap.length, (index) {
//       return imeiMap[index]['imei'];
//     });
//   }
// }
