// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:kazoku/utils/json.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  static const _databaseName = "Kazoku.db";
  static const _databaseVersion = 1;

  // Table names
  static const charactersTable = "characters";
  static const characterTexturesTable = "characterTextures";

  // Column names
  static const characterIdCol = "id";
  static const characterNameCol = "name";
  static const characterGenderCol = "gender";
  static const characterAgeCol = "age";
  static const characterBodyTextureCol = "bodyTexture";
  static const characterEyesTextureCol = "eyesTexture";
  static const characterHairstyleTextureCol = "hairstyleTexture";
  static const characterOutfitTextureCol = "outfitTexture";

  static const ct_IdCol = "id";
  static const ct_NameCol = "name";
  static const ct_TypeCol = "type";
  static const ct_TexturePath = "path";
  static const ct_attributes = "attributes";

  // Singleton class this bitch
  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  // only one system wide refrence in game
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazy init
    _database = await _initDb();
    return database;
  }

  // create or open the database
  Future<Database> _initDb() async {
    // windows is special
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // non windows
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onUpgrade,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print("On create called");
    await db.execute("""
      CREATE TABLE IF NOT EXISTS $charactersTable (
        $characterIdCol INTEGER PRIMARY KEY,
        $characterNameCol TEXT,
        $characterGenderCol INTEGER,
        $characterAgeCol INTEGER,
        $characterBodyTextureCol INTEGER,
        $characterEyesTextureCol INTEGER,
        $characterHairstyleTextureCol INTEGER,
        $characterOutfitTextureCol INTEGER
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $characterTexturesTable (
        $ct_IdCol INTEGER PRIMARY KEY,
        $ct_NameCol TEXT,
        $ct_TypeCol TEXT,
        $ct_TexturePath TEXT,
        $ct_attributes TEXT
      )
    """);

    // ADD A DEMO PLAYER
    // TODO: remove this line
    await db.insert(charactersTable, {
      characterIdCol: 1,
      characterNameCol: "Jordan",
      characterAgeCol: 22,
      characterGenderCol: 1,
      characterBodyTextureCol: 1,
      characterEyesTextureCol: 2,
      characterHairstyleTextureCol: 3,
      characterOutfitTextureCol: 4,
    });
    print("Added character");


    await _addTexturesToDatabase(); 
    print("on_create finish");
  }

  Future<void> _addTexturesToDatabase() async {
    Database db = await instance.database;

    await db.execute("""
      INSERT INTO $characterTexturesTable ($ct_IdCol, $ct_NameCol, $ct_TypeCol, $ct_TexturePath, $ct_attributes)
      VALUES 
      (1, "Brown Body", "body", "sprites/character/body/Body_Green.png", ""),
      (2, "Brown Eyes", "eyes", "sprites/character/eyes/Eyes_32x32_02.png", ""),
      (3, "Brown Hair", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_07.png", ""),
      (4, "Sherif Outfit", "outfit", "sprites/character/outfit/Outfit_04_32x32_02.png", "")
    """);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("On upgrade called");
    print("old = $oldVersion");
    print("new = $newVersion");

    // await db.execute("DROP TABLE $charactersTable");
    await db.execute("DROP TABLE IF EXISTS $characterTexturesTable");
    await db.execute("DROP TABLE IF EXISTS $charactersTable");

    _onCreate(db, newVersion);
  }

  /// Query a Character
  Future<JSON?> queryCharacter(int id) async {
    print(await instance.database);
    Database db = await instance.database;
    var query = await db.query(
      charactersTable,
      where: "$characterIdCol = $id",
    );

    if (query.isNotEmpty) {
      return query.first;
    }

    return null;
  }

  /// Query a Texture
  Future<JSON?> queryTexture(int textureId) async {
    Database db = await instance.database;
    var query = await db.query(
      characterTexturesTable,
      where: "$ct_IdCol = $textureId",
    );

    return query.isEmpty ? null : query.first;
  }

  /// Insert into a table
  Future<int> insertIntoTable(String tableName, JSON data) async {
    Database db = await instance.database;
    return await db.insert(tableName, data);
  }

  /// Delete from a table
  Future<int> deleteFromTable(
    String tableName,
    String colName,
    dynamic value,
  ) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: "$colName = $value");
  }

  /// Update a value in a table
  ///
  /// **IMPORTANT** the `data` must have an `id` key.
  Future<int> updateTableValue(String tableName, JSON data) async {
    Database db = await instance.database;
    return db.update(tableName, data, where: "id = ${data['id']}");
  }
}
