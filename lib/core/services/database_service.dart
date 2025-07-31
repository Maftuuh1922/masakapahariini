import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recipe_app.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    // Recipes table
    await db.execute('''
      CREATE TABLE recipes (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        cookingTime INTEGER,
        difficulty TEXT,
        servings INTEGER,
        rating REAL,
        reviewCount INTEGER,
        category TEXT,
        createdAt TEXT,
        isFavorite INTEGER DEFAULT 0
      )
    ''');

    // Ingredients table
    await db.execute('''
      CREATE TABLE ingredients (
        id TEXT PRIMARY KEY,
        recipeId TEXT,
        name TEXT NOT NULL,
        amount TEXT,
        unit TEXT,
        category TEXT,
        isOptional INTEGER DEFAULT 0,
        FOREIGN KEY (recipeId) REFERENCES recipes (id)
      )
    ''');

    // Cooking steps table
    await db.execute('''
      CREATE TABLE cooking_steps (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId TEXT,
        stepNumber INTEGER,
        instruction TEXT,
        FOREIGN KEY (recipeId) REFERENCES recipes (id)
      )
    ''');

    // User preferences
    await db.execute('''
      CREATE TABLE user_preferences (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }
}
