import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/features/home/data/models/task_model.dart';

class SqfLiteHelper {
  SqfLiteHelper();
  static Database? _database;

  /// دالة لتهيئة وإنشاء قاعدة البيانات
  Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    final String path = join(await getDatabasesPath(), 'my_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
      CREATE TABLE Tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT ,
        title TEXT,
        note TEXT,
        date TEXT,
        startTime TEXT,
        endTime TEXT,
        color INTEGER,
        isCompleted INTEGER )
      ''').then(
          (value) => print('DB created successfully'),
        );
      },
    );
    return _database!;
  }

  /// دالة لإضافة مستخدم جديد
  Future<int> insertToDB(TaskModel model) async {
    final db = await getDatabase();
    return await db.rawInsert('''
      INSERT INTO Tasks( 
      title ,note ,date ,startTime ,endTime ,color ,isCompleted )
         VALUES
         ('${model.title}','${model.note}','${model.date}','${model.startTime}',
       '${model.endTime}','${model.color}','${model.isCompleted}')''');
  }

  /// دالة لجلب جميع المستخدمين
  Future<List<Map<String, dynamic>>> getFromDB() async {
    final db = await getDatabase();
    return await db.query('Tasks');
  }

  /// دالة لتحديث بيانات مستخدم معين
  Future<int> updatedDB(int id) async {
    final db = await getDatabase();
    return await db.rawUpdate('''
    UPDATE Tasks
    SET isCompleted = ?
    WHERE id = ?
   ''', [1, id]);
  }

  /// دالة لحذف مستخدم معين
  Future<int> deleteFromDB(int id) async {
    final db = await getDatabase();
    return await db.rawDelete(
      '''DELETE FROM Tasks WHERE id = ?''',
      [id],
    );
  }

  /// دالة لحذف قاعدة البيانات بالكامل (اختياري)
  Future<void> deleteDatabaseFile() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');
    await deleteDatabase(path);
    _database = null; // إعادة تعيين الكائن
  }
}
