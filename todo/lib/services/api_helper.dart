import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/services/api_result.dart';
import 'package:todo/utils/global.dart' as global;

class APIHelper {
  static Database? _database;

  static final APIHelper instance = APIHelper._init();

  APIHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todoDatabase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        minute INTEGER,
        second INTEGER,
        title TEXT,
        description TEXT,
        status TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  Future<APIResult<int>> insertTodo(TodoModel todo) async {
    try {
      final db = await instance.database;
      final id = await db.insert('todo', todo.toJson());
      return APIResult<int>(
        status: "success",
        isDisplayMessage: false,
        message: "",
        recordList: id,
        totalRecords: null,
        value: null,
        error: null,
      );
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper.dart",
        functionNameWithoutBraces: "insertTodo",
        e: e,
      );
      return APIResult<int>(
        status: "error",
        isDisplayMessage: true,
        message: e.toString(),
        recordList: null,
        totalRecords: null,
        value: null,
        error: Error(
          apiName: "insertTodo",
          apiType: "local",
          fileName: "api_helper.dart",
          functionName: "insertTodo",
          lineNumber: null,
          typeName: e.runtimeType.toString(),
          stack: e.toString(),
        ),
      );
    }
  }

  
  Future<APIResult<List<TodoModel>>> getAllTodos() async {
    try {
      final db = await instance.database;
      final result = await db.query('todo', orderBy: 'createdAt DESC');

      final list = result.map((json) => TodoModel.fromJson(json)).toList();
      return APIResult<List<TodoModel>>(
        status: "success",
        isDisplayMessage: false,
        message: "",
        recordList: list,
        totalRecords: list.length,
        value: null,
        error: null,
      );
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper.dart",
        functionNameWithoutBraces: "getAllTodos",
        e: e,
      );
      return APIResult<List<TodoModel>>(
        status: "error",
        isDisplayMessage: true,
        message: e.toString(),
        recordList: [],
        totalRecords: 0,
        value: null,
        error: Error(
          apiName: "getAllTodos",
          apiType: "local",
          fileName: "api_helper.dart",
          functionName: "getAllTodos",
          lineNumber: null,
          typeName: e.runtimeType.toString(),
          stack: e.toString(),
        ),
      );
    }
  }

  Future<APIResult<int>> updateTodo(TodoModel todo) async {
    try {
      final db = await instance.database;
      final count = await db.update(
        'todo',
        todo.toJson(),
        where: 'id = ?',
        whereArgs: [todo.id],
      );
      return APIResult<int>(
        status: "success",
        isDisplayMessage: false,
        message: "",
        recordList: count,
        totalRecords: null,
        value: null,
        error: null,
      );
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper.dart",
        functionNameWithoutBraces: "updateTodo",
        e: e,
      );
      return APIResult<int>(
        status: "error",
        isDisplayMessage: true,
        message: e.toString(),
        recordList: null,
        totalRecords: null,
        value: null,
        error: Error(
          apiName: "updateTodo",
          apiType: "local",
          fileName: "api_helper.dart",
          functionName: "updateTodo",
          lineNumber: null,
          typeName: e.runtimeType.toString(),
          stack: e.toString(),
        ),
      );
    }
  }

  /// Delete a todo by its [id].
  Future<APIResult<int>> deleteTodo(int id) async {
    try {
      final db = await instance.database;
      final count = await db.delete('todo', where: 'id = ?', whereArgs: [id]);
      return APIResult<int>(
        status: "success",
        isDisplayMessage: false,
        message: "",
        recordList: count,
        totalRecords: null,
        value: null,
        error: null,
      );
    } catch (e) {
      global.exceptionMessage(
        classNameWithoutExt: "api_helper.dart",
        functionNameWithoutBraces: "deleteTodo",
        e: e,
      );
      return APIResult<int>(
        status: "error",
        isDisplayMessage: true,
        message: e.toString(),
        recordList: null,
        totalRecords: null,
        value: null,
        error: Error(
          apiName: "deleteTodo",
          apiType: "local",
          fileName: "api_helper.dart",
          functionName: "deleteTodo",
          lineNumber: null,
          typeName: e.runtimeType.toString(),
          stack: e.toString(),
        ),
      );
    }
  }
}
