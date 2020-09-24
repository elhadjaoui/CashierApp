

import 'package:clock_app/models/expenses.dart';
import 'package:clock_app/models/user_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String tableUser = 'users';
final String columnId = 'id';
final String columnTitle = 'name';
final String columnDateTime = 'creationDate';

final String tableExpenses = 'Expenses';
final String columnExpensesId = 'id';
final String columnExpensesTitle = 'name';
final String columnExpensesProduct = 'product';
final String columnExpensesPrice = 'price';
final String columnExpensesDateTime = 'creationDate';

final String usersTable = 'usersdetails';
final String columnUserId = 'id';
final String columnUserName = 'name';
final String columnUserTotal = 'total';
final String columnUserDateTime = 'creationDate';
final String columnUserProduct = 'product';
final String columnUserBool = 'condition';
final String columnUserPrice = 'price';




class UserHelper {
  static Database _database;
  static UserHelper _userHelper;
  final userName;
  UserHelper({this.userName});

  //UserHelper._createInstance(this.tablename);
//  factory UserHelper() {
//    if (_userHelper == null) {
//      _userHelper = UserHelper._createInstance(tablename);
//    }
//    return _userHelper;
//  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "user.db";
   // await deleteDatabase(path);
    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $tableUser (
        $columnId integer primary key autoincrement, 
        $columnTitle text not null, 
        $columnDateTime text not null )
        ''');
        await db.execute('''
          CREATE TABLE $usersTable (
          $columnUserId integer primary key autoincrement,
          $columnUserName text not null,
          $columnUserProduct text not null,
          $columnUserBool text not null,
          $columnUserPrice real,
          $columnUserTotal integer,
          $columnDateTime text not null )
        ''');
        await db.execute('''
        CREATE TABLE $tableExpenses (
        $columnId integer primary key autoincrement, 
        $columnExpensesTitle text not null, 
        $columnExpensesPrice real,
        $columnDateTime text not null )
        ''');
      },
    );
    return database;
  }
  ///********************User*******************************************************************************|
    insertUser(UserInfo userInfo) async {
    var db = await this.database;
    var result = await db.insert(tableUser, userInfo.toMap());
    print('result : $result');
    return result;
  }
  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }
  Future<int> update(UserInfo userInfo) async {
    var db = await this.database;
    return await db.update(tableUser,userInfo.toMap(), where: '$columnId = ?', whereArgs: [userInfo.id]);
  }
  Future<List<UserInfo>> getUsersByName(String name) async {
    List<UserInfo> _users = [];

    var db = await database;
    var result = await db.query(tableUser,where: 'name = ?',whereArgs: [name]);
    result.forEach((element) {
      var userInfo = UserInfo.fromMap(element);
      _users.add(userInfo);
    });
    return _users;
  }
  Future<List<UserInfo>> getUsers() async {
    List<UserInfo> _users = [];

    var db = await database;
    var result = await db.query(tableUser,orderBy: 'id DESC');
    result.forEach((element) {
      var userInfo = UserInfo.fromMap(element);
      _users.add(userInfo);
    });
    return _users;
  }
///***************UserDetails********************************************************************************|
  insertDetailUser(UserDetailsInfo userDetailsInfo) async {
    var db = await this.database;
    var result = await db.insert(usersTable, userDetailsInfo.toMap());
    print('result : $result');
    return result;
  }
  Future<List<UserDetailsInfo>> getUserDetails(String name) async {
    List<UserDetailsInfo> _users = [];

    var db = await database;
    var result = await db.query(usersTable,where: 'name = ?',whereArgs: [name],orderBy: 'id DESC');
    result.forEach((element) {
      var userInfo = UserDetailsInfo.fromMap(element);
      _users.add(userInfo);
    });

    return _users;
  }

  Future<int> deleteUserDetails(String name ,{int id}) async {
    var db = await this.database;
    return await db.delete(usersTable, where: ' $columnUserName = ?', whereArgs: [name]);
  }
  Future<int> deleteUserDetailsById(int id) async {
    var db = await this.database;
    return await db.delete(usersTable, where: ' $columnUserId = ?', whereArgs: [id]);
  }
  Future<int> updateUserDetails(UserDetailsInfo userDetailsInfo) async {
    var db = await this.database;
    return await db.update(usersTable,userDetailsInfo.toMap(), where: ' $columnUserId = ?', whereArgs: [userDetailsInfo.id]);
  }
  Future<int> updateUserDetailsByName(String newName,String oldName) async {
    var db = await this.database;
    return await db.rawUpdate('UPDATE $usersTable SET name = ? WHERE name = ?', [newName, oldName]);
  }

  ///***********************Expenses*************************************************************************************************|
  insertExpenses(Expenses expenses) async {
    var db = await this.database;
    var result = await db.insert(tableExpenses, expenses.toMap());
    print('result : $result');
    return result;
  }
  Future<List<Expenses>> getExpenses() async {
    List<Expenses> _expenses = [];
    var db = await database;
    var result = await db.query(tableExpenses,orderBy: 'id DESC');
    result.forEach((element) {
      var expenses = Expenses.fromMap(element);
      _expenses.add(expenses);
    });
    return _expenses;
  }
  Future<int> deleteExpenses(int id) async {
    var db = await this.database;
    return await db.delete(tableExpenses, where: '$columnExpensesId = ?', whereArgs: [id]);
  }
  Future<int> updateExpenses(Expenses expenses) async {
    var db = await this.database;
    return await db.update(tableExpenses,expenses.toMap(), where: '$columnExpensesId = ?', whereArgs: [expenses.id]);
  }
}
