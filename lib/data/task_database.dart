import 'package:gestionnaire_taches/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskDatabase {
  TaskDatabase._();
  static final TaskDatabase instance = TaskDatabase._();

  Database? _db;

  Future<Database> get _database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            done INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await _database;
    final rows = await db.query('tasks', orderBy: 'id DESC');
    return rows.map(Task.fromMap).toList();
  }

  Future<Task> insert(Task task) async {
    final db = await _database;
    final id = await db.insert('tasks', {
      'title': task.title,
      'done': task.done ? 1 : 0,
    });
    return task.copyWith(id: id);
  }

  Future<void> update(Task task) async {
    final db = await _database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> delete(Task task) async {
    final db = await _database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }
}