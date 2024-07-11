// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:kazoku/utils/json.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const _databaseName = "Kazoku.db";
  static const _databaseVersion = 1;

  // Table names
  static const charactersTable = "characters";
  static const accessoriesTable = "accessories";
  static const characterTexturesTable = "characterTextures";
  static const characterTexturesAttributesTable = "characterTexturesAttributes";

  // Column names
  static const characterIdCol = "id";
  static const characterNameCol = "name";
  static const characterGenderCol = "gender";
  static const characterAgeCol = "age";
  static const characterBodyTextureCol = "bodyTexture";
  static const characterEyesTextureCol = "eyesTexture";
  static const characterHairstyleTextureCol = "hairstyleTexture";
  static const characterOutfitTextureCol = "outfitTexture";

  static const accessoryIdCol = "id";
  static const accessoryTypeCol = "type";
  static const accessoryCharacterIdCol = "characterId";
  static const a_CharacterTextureIdCol = "characterTextureId";

  static const ct_IdCol = "id";
  static const ct_NameCol = "name";
  static const ct_TypeCol = "type";
  static const ct_TexturePath = "path";

  static const cta_IdCol = "id";
  static const cta_KeyCol = "key";
  static const cta_ValueCol = "value";
  static const cta_CharacterTextureId = "characterTextureId";

  // Singleton class this bitch
  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  // only one system wide refrence in game
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazy init
    _database = await _initDb();
    return _database!;
  }

  // create or open the database
  Future<Database> _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS $charactersTable (
        $characterIdCol TEXT PRIMARY KEY,
        $characterNameCol TEXT,
        $characterGenderCol INTEGER,
        $characterAgeCol INTEGER,
        $characterBodyTextureCol TEXT,
        $characterEyesTextureCol TEXT,
        $characterHairstyleTextureCol TEXT,
        $characterOutfitTextureCol TEXT
      )
      """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $accessoriesTable (
        $accessoryIdCol INTEGER PRIMARY KEY,
        $accessoryTypeCol TEXT,
        $accessoryCharacterIdCol TEXT,
        $a_CharacterTextureIdCol INTEGER
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $characterTexturesTable (
        $ct_IdCol INTEGER PRIMARY KEY,
        $ct_NameCol TEXT,
        $ct_TypeCol TEXT,
        $ct_TexturePath TEXT
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $characterTexturesAttributesTable (
        $cta_IdCol INTEGER PRIMARY KEY,
        $cta_KeyCol TEXT,
        $cta_ValueCol TEXT,
        $cta_CharacterTextureId INTEGER
      ) 
    """);

    await _addTexturesToDatabase();
  }

  Future<void> _addTexturesToDatabase() async {
    Database db = await instance.database;

    await db.execute("""
      INSERT INTO $characterTexturesTable ($ct_IdCol, $ct_NameCol, $ct_TypeCol, $ct_TexturePath)
      VALUES 
      (1, "Brown Body", "body", "sprites/character/body/brown_body.png"),
      (2, "Brown Eyes", "eyes", "sprites/character/eyes/brown_eyes.png"),
      (3, "Brown Hair", "hairstyle", "sprites/character/hairstyle/brown_hair.png"),
      (4, "Sherif Outfit", "outfit", "sprites/character/outfit/sherif_outfit.png")
    """);

    await db.execute("""
      INSERT INTO $characterTexturesAttributesTable ($cta_IdCol, $cta_KeyCol, $cta_ValueCol, $cta_CharacterTextureId)
      VALUES
      (1, "color", "brown", 1),
      (2, "color", "brown", 2),
      (3, "color", "brown", 3),
      (4, "color", "blue", 4),
      (5, "outfitType", "uniform", 4),
    """);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("old = $oldVersion");
    print("new = $newVersion");

    // await db.execute("DROP TABLE $charactersTable");
    await db.execute("DROP TABLE $characterTexturesTable");
    await db.execute("DROP TABLE $characterTexturesAttributesTable");
    await db.execute("DROP TABLE $accessoriesTable");

    _onCreate(db, newVersion);
  }

  /// Query a Character
  Future<JSON?> queryCharacter(String id) async {
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
