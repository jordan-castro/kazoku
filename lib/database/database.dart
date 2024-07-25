// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:kazoku/database/insert_character_textures.dart';
import 'package:kazoku/database/insert_floor_tiles.dart';
import 'package:kazoku/database/insert_floors.dart';
import 'package:kazoku/utils/json.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  static const _databaseName = "Kazoku.db";
  static const _databaseVersion = 1;

  // Table names
  /// The table which holds all characters including our player.
  static const charactersTable = "characters";

  /// The table that holds the character textures.
  static const characterTexturesTable = "characterTextures";

  /// The table which holds the map for every KazuFloor.
  static const kazuFloorsMapTable = "kazuFloorsMap";

  /// floor tiles.
  static const floorTilesTable = "floor_tiles";

  /// Animated objects
  static const animatedObjectsTable = "animated_objects";

  /// Static objects
  static const staticObjectsTable = "static_objects";

  /// Object headers (animated and static)
  static const objectHeadersTable = "object_headers";

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
  static const ct_isForKid = "is_for_kid";

  static const kfm_IdCol = "id";
  static const kfm_Name = "name";
  static const kfm_FloorNumber = "floor_number";
  static const kfm_Map = "map";

  static const ft_IdCol = "id";
  static const ft_Source = "source";
  static const ft_Coords = "coords";

  static const ao_IdCol = "id";
  static const ao_Name = "name";
  static const ao_Source = "source";
  static const ao_HeaderId = "header_id";

  static const so_IdCol = "id";
  static const so_Name = "name";
  static const so_Source = "source";
  static const so_HeaderId = "header_id";

  static const oh_IdCol = "id";
  static const oh_title = "title";

  // Singleton class this jaunt
  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  bool initialized = false;

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
    // windows is special
    if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // non windows
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    var db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onDowngrade: _onUpgrade,
    );

    initialized = true;
    return db;
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    print("On create called");
    await db.execute("""
      CREATE TABLE IF NOT EXISTS $charactersTable (
        $characterIdCol INTEGER PRIMARY KEY,
        $characterNameCol TEXT NOT NULL,
        $characterGenderCol INTEGER NOT NULL,
        $characterAgeCol INTEGER NOT NULL,
        $characterBodyTextureCol INTEGER NOT NULL,
        $characterEyesTextureCol INTEGER NOT NULL,
        $characterHairstyleTextureCol INTEGER,
        $characterOutfitTextureCol INTEGER NOT NULL
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $characterTexturesTable (
        $ct_IdCol INTEGER PRIMARY KEY,
        $ct_NameCol TEXT NOT NULL,
        $ct_TypeCol TEXT NOT NULL,
        $ct_TexturePath TEXT NOT NULL,
        $ct_attributes TEXT NOT NULL,
        $ct_isForKid INTEGER NOT NULL
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $kazuFloorsMapTable (
        $kfm_IdCol INTEGER PRIMARY KEY,
        $kfm_Name TEXT NOT NULL,
        $kfm_FloorNumber TEXT NOT NULL,
        $kfm_Map TEXT NOT NULL
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $floorTilesTable (
        $ft_IdCol INTEGER PRIMARY KEY,
        $ft_Source TEXT NOT NULL,
        $ft_Coords TEXT NOT NULL
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $animatedObjectsTable (
        $ao_IdCol INTEGER PRIMARY KEY,
        $ao_Name TEXT NOT NULL,
        $ao_Source TEXT NOT NULL,
        $ao_HeaderId INTEGER
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $staticObjectsTable (
        $so_IdCol INTEGER PRIMARY KEY,
        $so_Name TEXT NOT NULL,
        $so_Source TEXT NOT NULL
        $ao_HeaderId INTEGER
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $objectHeadersTable (
        $oh_IdCol INTEGER PRIMARY KEY,
        $oh_title TEXT NOT NULL
      )
    """);

    // Add a player character. This should be removed
    // TODO: REMOVE THIS LINE
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

    await addInitialCharacterTextures(db);
    await insertFloors(db);
    await insertFloorTiles(db);

    // await _addNames();
    print("on_create finish");
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("On upgrade called");
    print("old = $oldVersion");
    print("new = $newVersion");

    // await db.execute("DROP TABLE $charactersTable");
    await db.execute("DROP TABLE IF EXISTS $characterTexturesTable");
    await db.execute("DROP TABLE IF EXISTS $charactersTable");
    await db.execute("DROP TABLE IF EXISTS $kazuFloorsMapTable");
    await db.execute("DROP TABLE IF EXISTS $floorTilesTable");
    await db.execute("DROP TABLE IF EXISTS $animatedObjectsTable");
    await db.execute("DROP TABLE IF EXISTS $staticObjectsTable");

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

  /// Return a floor tile JSON.
  Future<JSON?> queryFloorTile(int tileId) async {
    Database db = await instance.database;
    final row = await db.query(
      floorTilesTable,
      where: "$ft_IdCol = $tileId",
    );
    if (row.isEmpty) {
      return null;
    }
    return row.first;
  }

  /// Return data from a KazuFloor
  Future<JSON?> queryFloor(int floorId) async {
    Database db = await instance.database;
    final row = await db.query(
      kazuFloorsMapTable,
      where: "$kfm_IdCol = $floorId",
    );
    if (row.isEmpty) {
      return null;
    }

    return row.first;
  }
}
