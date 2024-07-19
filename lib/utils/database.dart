// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:kazoku/utils/json.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  static const _databaseName = "Kazoku.db";
  static const _databaseVersion = 2;

  // Table names
  static const charactersTable = "characters";
  static const characterTexturesTable = "characterTextures";
  static const nameOptionsTable = "name_options";

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

  static const no_idCol = "id";
  static const no_nameCol = "name";
  static const no_genderCol = "gender";

  // Singleton class this jaunt
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
        $ct_attributes TEXT,
        $ct_isForKid INTEGER
      )
    """);

    await db.execute("""
      CREATE TABLE IF NOT EXISTS $nameOptionsTable (
        $no_idCol INTEGER PRIMARY KEY,
        $no_nameCol TEXT,
        $no_genderCol INTEGER
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

    await _addTexturesToDatabase(db);
    // await _addNames();
    print("on_create finish");
  }

  Future<void> _addTexturesToDatabase(Database db) async {
    await db.rawInsert("""
      INSERT INTO $characterTexturesTable ($ct_IdCol, $ct_NameCol, $ct_TypeCol, $ct_TexturePath, $ct_attributes, $ct_isForKid)
      VALUES 
      (1, "Body 1", "body", "sprites/character/body/Body_32x32_01.png", "{'color': '#bf8b78'}", 0),
      (2, "Body 2", "body", "sprites/character/body/Body_32x32_02.png", "{'color': '#ffcbb0'}", 0),
      (3, "Body 3", "body", "sprites/character/body/Body_32x32_03.png", "{'color': '#ffb893'}", 0),
      (4, "Body 4", "body", "sprites/character/body/Body_32x32_04.png", "{'color': '#bb845c'}", 0),
      (5, "Body 5", "body", "sprites/character/body/Body_32x32_05.png", "{'color': '#cdb57a'}", 0),
      (6, "Body 6", "body", "sprites/character/body/Body_32x32_06.png", "{'color': '#d4cabb'}", 0),
      (7, "Body 7", "body", "sprites/character/body/Body_32x32_07.png", "{'color': '#f0ae80'}", 0),
      (8, "Body 8", "body", "sprites/character/body/Body_32x32_08.png", "{'color': '#e6b8d7'}", 0),
      (9, "Body 9", "body", "sprites/character/body/Body_32x32_09.png", "{'color': '#bab8d7'}", 0),
      (10, "Eyes 1", "eyes", "sprites/character/eyes/Eyes_32x32_01.png", "{'top_color': '#3a3a50', 'bottom_color': '#674d49'}", 0),
      (11, "Eyes 2", "eyes", "sprites/character/eyes/Eyes_32x32_02.png", "{'top_color': '#3a3a50', 'bottom_color': '#568d61'}", 0),
      (12, "Eyes 3", "eyes", "sprites/character/eyes/Eyes_32x32_03.png", "{'top_color': '#3a3a50', 'bottom_color': '#959d58'}", 0),
      (13, "Eyes 4", "eyes", "sprites/character/eyes/Eyes_32x32_04.png", "{'top_color': '#3a3a50', 'bottom_color': '#6c6e85'}", 0),
      (14, "Eyes 5", "eyes", "sprites/character/eyes/Eyes_32x32_05.png", "{'top_color': '#3a3a50', 'bottom_color': '#956020'}", 0),
      (15, "Eyes 6", "eyes", "sprites/character/eyes/Eyes_32x32_06.png", "{'top_color': '#3a3a50', 'bottom_color': '#3b7aa2'}", 0),
      (16, "Eyes 7", "eyes", "sprites/character/eyes/Eyes_32x32_07.png", "{'top_color': '#3a3a50', 'bottom_color': '#5ed6f2'}", 0),
      (17, "Hairstyle 1", "hairstyle", "sprites/character/hairstyle/Hairstyle_01_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (18, "Hairstyle 1", "hairstyle", "sprites/character/hairstyle/Hairstyle_01_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (19, "Hairstyle 1", "hairstyle", "sprites/character/hairstyle/Hairstyle_01_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (20, "Hairstyle 1", "hairstyle", "sprites/character/hairstyle/Hairstyle_01_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (21, "Hairstyle 1", "hairstyle", "sprites/character/hairstyle/Hairstyle_01_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (22, "Hairstyle 1", "hairstyle", "sprites/character/hairstyle/Hairstyle_01_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (23, "Hairstyle 1", "hairstyle", "sprites/character/hairstyle/Hairstyle_01_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (24, "Hairstyle 2", "hairstyle", "sprites/character/hairstyle/Hairstyle_02_32x32_01.png", "{'color': '#ab6736', 'gender': 1}", 0),
      (25, "Hairstyle 2", "hairstyle", "sprites/character/hairstyle/Hairstyle_02_32x32_02.png", "{'color': '#8a6552', 'gender': 1}", 0),
      (26, "Hairstyle 2", "hairstyle", "sprites/character/hairstyle/Hairstyle_02_32x32_03.png", "{'color': '#724a40', 'gender': 1}", 0),
      (27, "Hairstyle 2", "hairstyle", "sprites/character/hairstyle/Hairstyle_02_32x32_04.png", "{'color': '#5b4643', 'gender': 1}", 0),
      (28, "Hairstyle 2", "hairstyle", "sprites/character/hairstyle/Hairstyle_02_32x32_05.png", "{'color': '#898887', 'gender': 1}", 0),
      (29, "Hairstyle 2", "hairstyle", "sprites/character/hairstyle/Hairstyle_02_32x32_06.png", "{'color': '#706663', 'gender': 1}", 0),
      (30, "Hairstyle 2", "hairstyle", "sprites/character/hairstyle/Hairstyle_02_32x32_07.png", "{'color': '#535662', 'gender': 1}", 0),
      (31, "Hairstyle 3", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (32, "Hairstyle 3", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (33, "Hairstyle 3", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (34, "Hairstyle 3", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (35, "Hairstyle 3", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (36, "Hairstyle 3", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (37, "Hairstyle 3", "hairstyle", "sprites/character/hairstyle/Hairstyle_03_32x32_07.png", "{'color': '#566279', 'gender':1}", 0),
      (38, "Hairstyle 4", "hairstyle", "sprites/character/hairstyle/Hairstyle_04_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (39, "Hairstyle 4", "hairstyle", "sprites/character/hairstyle/Hairstyle_04_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (40, "Hairstyle 4", "hairstyle", "sprites/character/hairstyle/Hairstyle_04_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (41, "Hairstyle 4", "hairstyle", "sprites/character/hairstyle/Hairstyle_04_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (42, "Hairstyle 4", "hairstyle", "sprites/character/hairstyle/Hairstyle_04_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (43, "Hairstyle 4", "hairstyle", "sprites/character/hairstyle/Hairstyle_04_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (44, "Hairstyle 4", "hairstyle", "sprites/character/hairstyle/Hairstyle_04_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (45, "Hairstyle 5", "hairstyle", "sprites/character/hairstyle/Hairstyle_05_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (46, "Hairstyle 5", "hairstyle", "sprites/character/hairstyle/Hairstyle_05_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (47, "Hairstyle 5", "hairstyle", "sprites/character/hairstyle/Hairstyle_05_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (48, "Hairstyle 5", "hairstyle", "sprites/character/hairstyle/Hairstyle_05_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (49, "Hairstyle 5", "hairstyle", "sprites/character/hairstyle/Hairstyle_05_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (50, "Hairstyle 5", "hairstyle", "sprites/character/hairstyle/Hairstyle_05_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (51, "Hairstyle 5", "hairstyle", "sprites/character/hairstyle/Hairstyle_05_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (52, "Hairstyle 6", "hairstyle", "sprites/character/hairstyle/Hairstyle_06_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (53, "Hairstyle 6", "hairstyle", "sprites/character/hairstyle/Hairstyle_06_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (54, "Hairstyle 6", "hairstyle", "sprites/character/hairstyle/Hairstyle_06_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (55, "Hairstyle 6", "hairstyle", "sprites/character/hairstyle/Hairstyle_06_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (56, "Hairstyle 6", "hairstyle", "sprites/character/hairstyle/Hairstyle_06_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (57, "Hairstyle 6", "hairstyle", "sprites/character/hairstyle/Hairstyle_06_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (58, "Hairstyle 6", "hairstyle", "sprites/character/hairstyle/Hairstyle_06_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (59, "Hairstyle 7", "hairstyle", "sprites/character/hairstyle/Hairstyle_07_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (60, "Hairstyle 7", "hairstyle", "sprites/character/hairstyle/Hairstyle_07_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (61, "Hairstyle 7", "hairstyle", "sprites/character/hairstyle/Hairstyle_07_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (62, "Hairstyle 7", "hairstyle", "sprites/character/hairstyle/Hairstyle_07_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (63, "Hairstyle 7", "hairstyle", "sprites/character/hairstyle/Hairstyle_07_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (64, "Hairstyle 7", "hairstyle", "sprites/character/hairstyle/Hairstyle_07_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (65, "Hairstyle 7", "hairstyle", "sprites/character/hairstyle/Hairstyle_07_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (66, "Hairstyle 8", "hairstyle", "sprites/character/hairstyle/Hairstyle_08_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (67, "Hairstyle 8", "hairstyle", "sprites/character/hairstyle/Hairstyle_08_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (68, "Hairstyle 8", "hairstyle", "sprites/character/hairstyle/Hairstyle_08_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (69, "Hairstyle 8", "hairstyle", "sprites/character/hairstyle/Hairstyle_08_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (70, "Hairstyle 8", "hairstyle", "sprites/character/hairstyle/Hairstyle_08_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (71, "Hairstyle 8", "hairstyle", "sprites/character/hairstyle/Hairstyle_08_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (72, "Hairstyle 8", "hairstyle", "sprites/character/hairstyle/Hairstyle_08_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (73, "Hairstyle 9", "hairstyle", "sprites/character/hairstyle/Hairstyle_09_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (74, "Hairstyle 9", "hairstyle", "sprites/character/hairstyle/Hairstyle_09_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (75, "Hairstyle 9", "hairstyle", "sprites/character/hairstyle/Hairstyle_09_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (76, "Hairstyle 9", "hairstyle", "sprites/character/hairstyle/Hairstyle_09_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (77, "Hairstyle 9", "hairstyle", "sprites/character/hairstyle/Hairstyle_09_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (78, "Hairstyle 9", "hairstyle", "sprites/character/hairstyle/Hairstyle_09_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (79, "Hairstyle 9", "hairstyle", "sprites/character/hairstyle/Hairstyle_09_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (80, "Hairstyle 10", "hairstyle", "sprites/character/hairstyle/Hairstyle_10_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (81, "Hairstyle 10", "hairstyle", "sprites/character/hairstyle/Hairstyle_10_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (82, "Hairstyle 10", "hairstyle", "sprites/character/hairstyle/Hairstyle_10_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (83, "Hairstyle 10", "hairstyle", "sprites/character/hairstyle/Hairstyle_10_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (84, "Hairstyle 10", "hairstyle", "sprites/character/hairstyle/Hairstyle_10_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (85, "Hairstyle 10", "hairstyle", "sprites/character/hairstyle/Hairstyle_10_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (86, "Hairstyle 10", "hairstyle", "sprites/character/hairstyle/Hairstyle_10_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (87, "Hairstyle 11", "hairstyle", "sprites/character/hairstyle/Hairstyle_11_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (88, "Hairstyle 11", "hairstyle", "sprites/character/hairstyle/Hairstyle_11_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (89, "Hairstyle 11", "hairstyle", "sprites/character/hairstyle/Hairstyle_11_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (90, "Hairstyle 11", "hairstyle", "sprites/character/hairstyle/Hairstyle_11_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (91, "Hairstyle 11", "hairstyle", "sprites/character/hairstyle/Hairstyle_11_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (92, "Hairstyle 11", "hairstyle", "sprites/character/hairstyle/Hairstyle_11_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (93, "Hairstyle 11", "hairstyle", "sprites/character/hairstyle/Hairstyle_11_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (94, "Hairstyle 12", "hairstyle", "sprites/character/hairstyle/Hairstyle_12_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (95, "Hairstyle 12", "hairstyle", "sprites/character/hairstyle/Hairstyle_12_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (96, "Hairstyle 12", "hairstyle", "sprites/character/hairstyle/Hairstyle_12_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (97, "Hairstyle 12", "hairstyle", "sprites/character/hairstyle/Hairstyle_12_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (98, "Hairstyle 12", "hairstyle", "sprites/character/hairstyle/Hairstyle_12_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (99, "Hairstyle 12", "hairstyle", "sprites/character/hairstyle/Hairstyle_12_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (100, "Hairstyle 12", "hairstyle", "sprites/character/hairstyle/Hairstyle_12_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (101, "Hairstyle 13", "hairstyle", "sprites/character/hairstyle/Hairstyle_13_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (102, "Hairstyle 13", "hairstyle", "sprites/character/hairstyle/Hairstyle_13_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (103, "Hairstyle 13", "hairstyle", "sprites/character/hairstyle/Hairstyle_13_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (104, "Hairstyle 13", "hairstyle", "sprites/character/hairstyle/Hairstyle_13_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (105, "Hairstyle 13", "hairstyle", "sprites/character/hairstyle/Hairstyle_13_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (106, "Hairstyle 13", "hairstyle", "sprites/character/hairstyle/Hairstyle_13_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (107, "Hairstyle 13", "hairstyle", "sprites/character/hairstyle/Hairstyle_13_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (108, "Hairstyle 14", "hairstyle", "sprites/character/hairstyle/Hairstyle_14_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (109, "Hairstyle 14", "hairstyle", "sprites/character/hairstyle/Hairstyle_14_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (110, "Hairstyle 14", "hairstyle", "sprites/character/hairstyle/Hairstyle_14_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (111, "Hairstyle 14", "hairstyle", "sprites/character/hairstyle/Hairstyle_14_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (112, "Hairstyle 14", "hairstyle", "sprites/character/hairstyle/Hairstyle_14_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (113, "Hairstyle 14", "hairstyle", "sprites/character/hairstyle/Hairstyle_14_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (114, "Hairstyle 14", "hairstyle", "sprites/character/hairstyle/Hairstyle_14_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (115, "Hairstyle 15", "hairstyle", "sprites/character/hairstyle/Hairstyle_15_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (116, "Hairstyle 15", "hairstyle", "sprites/character/hairstyle/Hairstyle_15_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (117, "Hairstyle 15", "hairstyle", "sprites/character/hairstyle/Hairstyle_15_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (118, "Hairstyle 15", "hairstyle", "sprites/character/hairstyle/Hairstyle_15_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (119, "Hairstyle 15", "hairstyle", "sprites/character/hairstyle/Hairstyle_15_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (120, "Hairstyle 15", "hairstyle", "sprites/character/hairstyle/Hairstyle_15_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (121, "Hairstyle 15", "hairstyle", "sprites/character/hairstyle/Hairstyle_15_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (122, "Hairstyle 16", "hairstyle", "sprites/character/hairstyle/Hairstyle_16_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (123, "Hairstyle 16", "hairstyle", "sprites/character/hairstyle/Hairstyle_16_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (124, "Hairstyle 16", "hairstyle", "sprites/character/hairstyle/Hairstyle_16_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (125, "Hairstyle 16", "hairstyle", "sprites/character/hairstyle/Hairstyle_16_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (126, "Hairstyle 16", "hairstyle", "sprites/character/hairstyle/Hairstyle_16_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (127, "Hairstyle 16", "hairstyle", "sprites/character/hairstyle/Hairstyle_16_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (128, "Hairstyle 16", "hairstyle", "sprites/character/hairstyle/Hairstyle_16_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (129, "Hairstyle 17", "hairstyle", "sprites/character/hairstyle/Hairstyle_17_32x32_01.png", "{'color': '#ab6736', 'gender': 1}", 0),
      (130, "Hairstyle 17", "hairstyle", "sprites/character/hairstyle/Hairstyle_17_32x32_02.png", "{'color': '#8a6552', 'gender': 1}", 0),
      (131, "Hairstyle 17", "hairstyle", "sprites/character/hairstyle/Hairstyle_17_32x32_03.png", "{'color': '#724a40', 'gender': 1}", 0),
      (132, "Hairstyle 17", "hairstyle", "sprites/character/hairstyle/Hairstyle_17_32x32_04.png", "{'color': '#5b4643', 'gender': 1}", 0),
      (133, "Hairstyle 17", "hairstyle", "sprites/character/hairstyle/Hairstyle_17_32x32_05.png", "{'color': '#898887', 'gender': 1}", 0),
      (134, "Hairstyle 17", "hairstyle", "sprites/character/hairstyle/Hairstyle_17_32x32_06.png", "{'color': '#706663', 'gender': 1}", 0),
      (135, "Hairstyle 17", "hairstyle", "sprites/character/hairstyle/Hairstyle_17_32x32_07.png", "{'color': '#535662', 'gender': 1}", 0),
      (136, "Hairstyle 18", "hairstyle", "sprites/character/hairstyle/Hairstyle_18_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (137, "Hairstyle 18", "hairstyle", "sprites/character/hairstyle/Hairstyle_18_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (138, "Hairstyle 18", "hairstyle", "sprites/character/hairstyle/Hairstyle_18_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (139, "Hairstyle 18", "hairstyle", "sprites/character/hairstyle/Hairstyle_18_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (140, "Hairstyle 18", "hairstyle", "sprites/character/hairstyle/Hairstyle_18_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (141, "Hairstyle 18", "hairstyle", "sprites/character/hairstyle/Hairstyle_18_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (142, "Hairstyle 18", "hairstyle", "sprites/character/hairstyle/Hairstyle_18_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (143, "Hairstyle 19", "hairstyle", "sprites/character/hairstyle/Hairstyle_19_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (144, "Hairstyle 19", "hairstyle", "sprites/character/hairstyle/Hairstyle_19_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (145, "Hairstyle 19", "hairstyle", "sprites/character/hairstyle/Hairstyle_19_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (146, "Hairstyle 19", "hairstyle", "sprites/character/hairstyle/Hairstyle_19_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (147, "Hairstyle 19", "hairstyle", "sprites/character/hairstyle/Hairstyle_19_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (148, "Hairstyle 19", "hairstyle", "sprites/character/hairstyle/Hairstyle_19_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (149, "Hairstyle 19", "hairstyle", "sprites/character/hairstyle/Hairstyle_19_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (150, "Hairstyle 20", "hairstyle", "sprites/character/hairstyle/Hairstyle_20_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (151, "Hairstyle 20", "hairstyle", "sprites/character/hairstyle/Hairstyle_20_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (152, "Hairstyle 20", "hairstyle", "sprites/character/hairstyle/Hairstyle_20_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (153, "Hairstyle 20", "hairstyle", "sprites/character/hairstyle/Hairstyle_20_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (154, "Hairstyle 20", "hairstyle", "sprites/character/hairstyle/Hairstyle_20_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (155, "Hairstyle 20", "hairstyle", "sprites/character/hairstyle/Hairstyle_20_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (156, "Hairstyle 20", "hairstyle", "sprites/character/hairstyle/Hairstyle_20_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (157, "Hairstyle 21", "hairstyle", "sprites/character/hairstyle/Hairstyle_21_32x32_01.png", "{'color': '#b37b3f', 'gender': 0}", 0),
      (158, "Hairstyle 21", "hairstyle", "sprites/character/hairstyle/Hairstyle_21_32x32_02.png", "{'color': '#957350', 'gender': 0}", 0),
      (159, "Hairstyle 21", "hairstyle", "sprites/character/hairstyle/Hairstyle_21_32x32_03.png", "{'color': '#805449', 'gender': 0}", 0),
      (160, "Hairstyle 21", "hairstyle", "sprites/character/hairstyle/Hairstyle_21_32x32_04.png", "{'color': '#674d49', 'gender': 0}", 0),
      (161, "Hairstyle 21", "hairstyle", "sprites/character/hairstyle/Hairstyle_21_32x32_05.png", "{'color': '#969695', 'gender': 0}", 0),
      (162, "Hairstyle 21", "hairstyle", "sprites/character/hairstyle/Hairstyle_21_32x32_06.png", "{'color': '#79746f', 'gender': 0}", 0),
      (163, "Hairstyle 21", "hairstyle", "sprites/character/hairstyle/Hairstyle_21_32x32_07.png", "{'color': '#566279', 'gender': 0}", 0),
      (164, "Hairstyle 22", "hairstyle", "sprites/character/hairstyle/Hairstyle_22_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (165, "Hairstyle 22", "hairstyle", "sprites/character/hairstyle/Hairstyle_22_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (166, "Hairstyle 22", "hairstyle", "sprites/character/hairstyle/Hairstyle_22_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (167, "Hairstyle 22", "hairstyle", "sprites/character/hairstyle/Hairstyle_22_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (168, "Hairstyle 22", "hairstyle", "sprites/character/hairstyle/Hairstyle_22_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (169, "Hairstyle 22", "hairstyle", "sprites/character/hairstyle/Hairstyle_22_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (170, "Hairstyle 22", "hairstyle", "sprites/character/hairstyle/Hairstyle_22_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (171, "Hairstyle 23", "hairstyle", "sprites/character/hairstyle/Hairstyle_23_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (172, "Hairstyle 23", "hairstyle", "sprites/character/hairstyle/Hairstyle_23_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (173, "Hairstyle 23", "hairstyle", "sprites/character/hairstyle/Hairstyle_23_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (174, "Hairstyle 23", "hairstyle", "sprites/character/hairstyle/Hairstyle_23_32x32_04.png", "{'color': '#6f5449', 'gender': 1}", 0),
      (175, "Hairstyle 23", "hairstyle", "sprites/character/hairstyle/Hairstyle_23_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (176, "Hairstyle 23", "hairstyle", "sprites/character/hairstyle/Hairstyle_23_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (177, "Hairstyle 23", "hairstyle", "sprites/character/hairstyle/Hairstyle_23_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (178, "Hairstyle 24", "hairstyle", "sprites/character/hairstyle/Hairstyle_24_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (179, "Hairstyle 24", "hairstyle", "sprites/character/hairstyle/Hairstyle_24_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (180, "Hairstyle 24", "hairstyle", "sprites/character/hairstyle/Hairstyle_24_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (181, "Hairstyle 24", "hairstyle", "sprites/character/hairstyle/Hairstyle_24_32x32_04.png", "{'color': '#6f5449', 'gender': 1}", 0),
      (182, "Hairstyle 24", "hairstyle", "sprites/character/hairstyle/Hairstyle_24_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (183, "Hairstyle 24", "hairstyle", "sprites/character/hairstyle/Hairstyle_24_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (184, "Hairstyle 24", "hairstyle", "sprites/character/hairstyle/Hairstyle_24_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (185, "Hairstyle 25", "hairstyle", "sprites/character/hairstyle/Hairstyle_25_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (186, "Hairstyle 25", "hairstyle", "sprites/character/hairstyle/Hairstyle_25_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (187, "Hairstyle 25", "hairstyle", "sprites/character/hairstyle/Hairstyle_25_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (188, "Hairstyle 25", "hairstyle", "sprites/character/hairstyle/Hairstyle_25_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (189, "Hairstyle 25", "hairstyle", "sprites/character/hairstyle/Hairstyle_25_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (190, "Hairstyle 25", "hairstyle", "sprites/character/hairstyle/Hairstyle_25_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (191, "Hairstyle 25", "hairstyle", "sprites/character/hairstyle/Hairstyle_25_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (192, "Hairstyle 26", "hairstyle", "sprites/character/hairstyle/Hairstyle_26_32x32_01.png", "{'color': '#b37b3f', 'gender': 1}", 0),
      (193, "Hairstyle 26", "hairstyle", "sprites/character/hairstyle/Hairstyle_26_32x32_02.png", "{'color': '#957350', 'gender': 1}", 0),
      (194, "Hairstyle 26", "hairstyle", "sprites/character/hairstyle/Hairstyle_26_32x32_03.png", "{'color': '#805449', 'gender': 1}", 0),
      (195, "Hairstyle 26", "hairstyle", "sprites/character/hairstyle/Hairstyle_26_32x32_04.png", "{'color': '#674d49', 'gender': 1}", 0),
      (196, "Hairstyle 26", "hairstyle", "sprites/character/hairstyle/Hairstyle_26_32x32_05.png", "{'color': '#969695', 'gender': 1}", 0),
      (197, "Hairstyle 26", "hairstyle", "sprites/character/hairstyle/Hairstyle_26_32x32_06.png", "{'color': '#79746f', 'gender': 1}", 0),
      (198, "Hairstyle 26", "hairstyle", "sprites/character/hairstyle/Hairstyle_26_32x32_07.png", "{'color': '#566279', 'gender': 1}", 0),
      (199, "Hairstyle 27", "hairstyle", "sprites/character/hairstyle/Hairstyle_27_32x32_01.png", "{'color': '#eea5b8', 'gender': 0}", 0),
      (200, "Hairstyle 27", "hairstyle", "sprites/character/hairstyle/Hairstyle_27_32x32_02.png", "{'color': '#74b453', 'gender': 0}", 0),
      (201, "Hairstyle 27", "hairstyle", "sprites/character/hairstyle/Hairstyle_27_32x32_03.png", "{'color': '#73b8c6', 'gender': 0}", 0),
      (202, "Hairstyle 27", "hairstyle", "sprites/character/hairstyle/Hairstyle_27_32x32_04.png", "{'color': '#50a7e8', 'gender': 0}", 0),
      (203, "Hairstyle 27", "hairstyle", "sprites/character/hairstyle/Hairstyle_27_32x32_05.png", "{'color': '#f8d239', 'gender': 0}", 0),
      (204, "Hairstyle 27", "hairstyle", "sprites/character/hairstyle/Hairstyle_27_32x32_06.png", "{'color': '#fc5c46', 'gender': 0}", 0),
      (205, "Hairstyle 28", "hairstyle", "sprites/character/hairstyle/Hairstyle_28_32x32_01.png", "{'color': '#eea5b8', 'gender': 0}", 0),
      (206, "Hairstyle 28", "hairstyle", "sprites/character/hairstyle/Hairstyle_28_32x32_02.png", "{'color': '#74b453', 'gender': 0}", 0),
      (207, "Hairstyle 28", "hairstyle", "sprites/character/hairstyle/Hairstyle_28_32x32_03.png", "{'color': '#73b8c6', 'gender': 0}", 0),
      (208, "Hairstyle 28", "hairstyle", "sprites/character/hairstyle/Hairstyle_28_32x32_04.png", "{'color': '#50a7e8', 'gender': 0}", 0),
      (209, "Hairstyle 28", "hairstyle", "sprites/character/hairstyle/Hairstyle_28_32x32_05.png", "{'color': '#f8d239', 'gender': 0}", 0),
      (210, "Hairstyle 28", "hairstyle", "sprites/character/hairstyle/Hairstyle_28_32x32_06.png", "{'color': '#fc5c46', 'gender': 0}", 0),
      (211, "Hairstyle 29", "hairstyle", "sprites/character/hairstyle/Hairstyle_29_32x32_01.png", "{'color': '#eea5b8', 'gender': 0}", 0),
      (212, "Hairstyle 29", "hairstyle", "sprites/character/hairstyle/Hairstyle_29_32x32_02.png", "{'color': '#74b453', 'gender': 0}", 0),
      (213, "Hairstyle 29", "hairstyle", "sprites/character/hairstyle/Hairstyle_29_32x32_03.png", "{'color': '#73b8c6', 'gender': 0}", 0),
      (214, "Hairstyle 29", "hairstyle", "sprites/character/hairstyle/Hairstyle_29_32x32_04.png", "{'color': '#50a7e8', 'gender': 0}", 0),
      (215, "Hairstyle 29", "hairstyle", "sprites/character/hairstyle/Hairstyle_29_32x32_05.png", "{'color': '#f8d239', 'gender': 0}", 0),
      (216, "Hairstyle 29", "hairstyle", "sprites/character/hairstyle/Hairstyle_29_32x32_06.png", "{'color': '#fc5c46', 'gender': 0}", 0),
      (217, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_01.png", "{'top_color': '#9f74a8', 'bottom_color': '#5d6043'}", 0),
      (218, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_02.png", "{'top_color': '#c1d2ee', 'bottom_color': '#c6bdd5'}", 0),
      (219, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_03.png", "{'top_color': '#d0be9c', 'bottom_color': '#5a6775'}", 0),
      (220, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_04.png", "{'top_color': '#e63f38', 'bottom_color': '#b9755c'}", 0),
      (221, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_05.png", "{'top_color': '#517867', 'bottom_color': '#766868'}", 0),
      (222, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_06.png", "{'top_color': '#e4806e', 'bottom_color': '#6da3a6'}", 0),
      (223, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_07.png", "{'top_color': '#e480a3', 'bottom_color': '#5f9054'}", 0),
      (224, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_08.png", "{'top_color': '#a29343', 'bottom_color': '#4d7dc8'}", 0),
      (225, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_09.png", "{'top_color': '#d1f4f1', 'bottom_color': '#4d5b7a'}", 0),
      (226, "Outfit 1", "outfit", "sprites/character/outfit/Outfit_01_32x32_10.png", "{'top_color': '#a94965', 'bottom_color': '#955354'}", 0),
      (227, "Outfit 2", "outfit", "sprites/character/outfit/Outfit_02_32x32_01.png", "{'top_color': '#a2394b', 'bottom_color': '#3a3a50'}", 0),
      (228, "Outfit 2", "outfit", "sprites/character/outfit/Outfit_02_32x32_02.png", "{'top_color': '#90444c', 'bottom_color': '#3a3a50'}", 0),
      (229, "Outfit 2", "outfit", "sprites/character/outfit/Outfit_02_32x32_03.png", "{'top_color': '#a99244', 'bottom_color': '#3a3a50'}", 0),
      (230, "Outfit 2", "outfit", "sprites/character/outfit/Outfit_02_32x32_04.png", "{'top_color': '#4497a9', 'bottom_color': '#3a3a50'}", 0),
      (231, "Outfit 3", "outfit", "sprites/character/outfit/Outfit_03_32x32_01.png", "{'top_color': '#6c6e85', 'bottom_color': '#8e6180'}", 0),
      (232, "Outfit 3", "outfit", "sprites/character/outfit/Outfit_03_32x32_02.png", "{'top_color': '#bd99c3', 'bottom_color': '#8e6180'}", 0),
      (233, "Outfit 3", "outfit", "sprites/character/outfit/Outfit_03_32x32_03.png", "{'top_color': '#1b99c3', 'bottom_color': '#b6814a'}", 0),
      (234, "Outfit 3", "outfit", "sprites/character/outfit/Outfit_03_32x32_04.png", "{'top_color': '#a1775f', 'bottom_color': '#439778'}", 0),
      (235, "Outfit 4", "outfit", "sprites/character/outfit/Outfit_04_32x32_01.png", "{'top_color': '#729965', 'bottom_color': '#5a6775'}", 0),
      (236, "Outfit 4", "outfit", "sprites/character/outfit/Outfit_04_32x32_02.png", "{'top_color': '#c78c59', 'bottom_color': '#5a6775'}", 0),
      (237, "Outfit 4", "outfit", "sprites/character/outfit/Outfit_04_32x32_03.png", "{'top_color': '#6e8897', 'bottom_color': '#578468'}", 0),
      (238, "Outfit 5", "outfit", "sprites/character/outfit/Outfit_05_32x32_01.png", "{'top_color': '#6c6e85', 'bottom_color': '#3a3a50'}", 0),
      (239, "Outfit 5", "outfit", "sprites/character/outfit/Outfit_05_32x32_02.png", "{'top_color': '#4d6e85', 'bottom_color': '#3a3a50'}", 0),
      (240, "Outfit 5", "outfit", "sprites/character/outfit/Outfit_05_32x32_03.png", "{'top_color': '#4d695a', 'bottom_color': '#3a3a50'}", 0),
      (241, "Outfit 5", "outfit", "sprites/character/outfit/Outfit_05_32x32_04.png", "{'top_color': '#dc9b5a', 'bottom_color': '#3a3a50'}", 0),
      (242, "Outfit 5", "outfit", "sprites/character/outfit/Outfit_05_32x32_05.png", "{'top_color': '#efdfe3', 'bottom_color': '#3a3a50'}", 0),
      (243, "Outfit 6", "outfit", "sprites/character/outfit/Outfit_06_32x32_01.png", "{'top_color': '#6c6e85', 'bottom_color': '#3a3a50'}", 0),
      (244, "Outfit 6", "outfit", "sprites/character/outfit/Outfit_06_32x32_02.png", "{'top_color': '#6c6e6f', 'bottom_color': '#3a3a50'}", 0),
      (245, "Outfit 6", "outfit", "sprites/character/outfit/Outfit_06_32x32_03.png", "{'top_color': '#6c5a6f', 'bottom_color': '#3a3a50'}", 0),
      (246, "Outfit 6", "outfit", "sprites/character/outfit/Outfit_06_32x32_04.png", "{'top_color': '#4f7598', 'bottom_color': '#3a3a50'}", 0),
      (247, "Outfit 7", "outfit", "sprites/character/outfit/Outfit_07_32x32_01.png", "{'top_color': '#6c6e85', 'bottom_color': '#647e99'}", 0),
      (248, "Outfit 7", "outfit", "sprites/character/outfit/Outfit_07_32x32_02.png", "{'top_color': '#bb814b', 'bottom_color': '#97a6b7'}", 0),
      (249, "Outfit 7", "outfit", "sprites/character/outfit/Outfit_07_32x32_03.png", "{'top_color': '#18838a', 'bottom_color': '#d68143'}", 0),
      (250, "Outfit 7", "outfit", "sprites/character/outfit/Outfit_07_32x32_04.png", "{'top_color': '#bb718a', 'bottom_color': '#979243'}", 0),
      (251, "Outfit 8", "outfit", "sprites/character/outfit/Outfit_08_32x32_01.png", "{'top_color': '#f8f8f8', 'bottom_color': '#f8f8f8'}", 0),
      (252, "Outfit 8", "outfit", "sprites/character/outfit/Outfit_08_32x32_02.png", "{'top_color': '#bab3b8', 'bottom_color': '#bab3b8'}", 0),
      (253, "Outfit 8", "outfit", "sprites/character/outfit/Outfit_08_32x32_03.png", "{'top_color': '#827980', 'bottom_color': '#827980'}", 0),
      (254, "Outfit 9", "outfit", "sprites/character/outfit/Outfit_09_32x32_01.png", "{'top_color': '#f8f8f8', 'bottom_color': '#e63f38'}", 0),
      (255, "Outfit 9", "outfit", "sprites/character/outfit/Outfit_09_32x32_02.png", "{'top_color': '#f8f8f8', 'bottom_color': '#e6ad38'}", 0),
      (256, "Outfit 9", "outfit", "sprites/character/outfit/Outfit_09_32x32_03.png", "{'top_color': '#f8f8f8', 'bottom_color': '#5aada7'}", 0),
      (257, "Outfit 10", "outfit", "sprites/character/outfit/Outfit_10_32x32_01.png", "{'top_color': '#9094aa', 'bottom_color': '#5f6ea2'}", 0),
      (258, "Outfit 10", "outfit", "sprites/character/outfit/Outfit_10_32x32_02.png", "{'top_color': '#6c95b7', 'bottom_color': '#bba05c'}", 0),
      (259, "Outfit 10", "outfit", "sprites/character/outfit/Outfit_10_32x32_03.png", "{'top_color': '#a63249', 'bottom_color': '#7e7795'}", 0),
      (260, "Outfit 10", "outfit", "sprites/character/outfit/Outfit_10_32x32_04.png", "{'top_color': '#897478', 'bottom_color': '#b2aebc'}", 0),
      (261, "Outfit 10", "outfit", "sprites/character/outfit/Outfit_10_32x32_05.png", "{'top_color': '#89b578', 'bottom_color': '#447674'}", 0),
      (262, "Outfit 11", "outfit", "sprites/character/outfit/Outfit_11_32x32_01.png", "{'top_color': '#d1b4d9', 'bottom_color': '#5b7366'}", 0),
      (263, "Outfit 11", "outfit", "sprites/character/outfit/Outfit_11_32x32_02.png", "{'top_color': '#d1b493', 'bottom_color': '#cf7769'}", 0),
      (264, "Outfit 11", "outfit", "sprites/character/outfit/Outfit_11_32x32_03.png", "{'top_color': '#d1c6d9', 'bottom_color': '#846e63'}", 0),
      (265, "Outfit 11", "outfit", "sprites/character/outfit/Outfit_11_32x32_04.png", "{'top_color': '#a09a3e', 'bottom_color': '#637e84'}", 0),
      (266, "Outfit 12", "outfit", "sprites/character/outfit/Outfit_12_32x32_01.png", "{'top_color': '#6c6e85', 'bottom_color': '#46465e'}", 0),
      (267, "Outfit 12", "outfit", "sprites/character/outfit/Outfit_12_32x32_02.png", "{'top_color': '#5d5e70', 'bottom_color': '#46465e'}", 0),
      (268, "Outfit 12", "outfit", "sprites/character/outfit/Outfit_12_32x32_03.png", "{'top_color': '#5d5e70', 'bottom_color': '#46465e'}", 0),
      (269, "Outfit 13", "outfit", "sprites/character/outfit/Outfit_13_32x32_01.png", "{'top_color': '#f8f8f8', 'bottom_color': '#f8f8f8'}", 0),
      (270, "Outfit 13", "outfit", "sprites/character/outfit/Outfit_13_32x32_02.png", "{'top_color': '#f8f8f8', 'bottom_color': '#f8f8f8'}", 0),
      (271, "Outfit 13", "outfit", "sprites/character/outfit/Outfit_13_32x32_03.png", "{'top_color': '#f8f8f8', 'bottom_color': '#f8f8f8'}", 0),
      (272, "Outfit 13", "outfit", "sprites/character/outfit/Outfit_13_32x32_04.png", "{'top_color': '#f8f8f8', 'bottom_color': '#f8f8f8'}", 0),
      (273, "Outfit 14", "outfit", "sprites/character/outfit/Outfit_14_32x32_01.png", "{'top_color': '#d0847c', 'bottom_color': '#566279'}", 0),
      (274, "Outfit 14", "outfit", "sprites/character/outfit/Outfit_14_32x32_02.png", "{'top_color': '#a98783', 'bottom_color': '#80899b'}", 0),
      (275, "Outfit 14", "outfit", "sprites/character/outfit/Outfit_14_32x32_03.png", "{'top_color': '#de8a7c', 'bottom_color': '#7c6279'}", 0),
      (276, "Outfit 14", "outfit", "sprites/character/outfit/Outfit_14_32x32_04.png", "{'top_color': '#adcae9', 'bottom_color': '#7c6862'}", 0),
      (277, "Outfit 14", "outfit", "sprites/character/outfit/Outfit_14_32x32_05.png", "{'top_color': '#57b179', 'bottom_color': '#628565'}", 0),
      (278, "Outfit 15", "outfit", "sprites/character/outfit/Outfit_15_32x32_01.png", "{'top_color': '#ebf3ff', 'bottom_color': '#d9e0f6'}", 0),
      (279, "Outfit 15", "outfit", "sprites/character/outfit/Outfit_15_32x32_02.png", "{'top_color': '#c1d2ee', 'bottom_color': '#a6b6e9'}", 0),
      (280, "Outfit 15", "outfit", "sprites/character/outfit/Outfit_15_32x32_03.png", "{'top_color': '#5185d9', 'bottom_color': '#5774ce'}", 0),
      (281, "Outfit 16", "outfit", "sprites/character/outfit/Outfit_16_32x32_01.png", "{'top_color': '#f5aa14', 'bottom_color': '#ed931e'}", 0),
      (282, "Outfit 16", "outfit", "sprites/character/outfit/Outfit_16_32x32_02.png", "{'top_color': '#f58a4f', 'bottom_color': '#ed764f'}", 0),
      (283, "Outfit 16", "outfit", "sprites/character/outfit/Outfit_16_32x32_03.png", "{'top_color': '#e15847', 'bottom_color': '#de414e'}", 0),
      (284, "Outfit 17", "outfit", "sprites/character/outfit/Outfit_17_32x32_01.png", "{'top_color': '#4b9296', 'bottom_color': '#46465e'}", 0),
      (285, "Outfit 17", "outfit", "sprites/character/outfit/Outfit_17_32x32_02.png", "{'top_color': '#8992d3', 'bottom_color': '#46465e'}", 0),
      (286, "Outfit 17", "outfit", "sprites/character/outfit/Outfit_17_32x32_03.png", "{'top_color': '#89ccd3', 'bottom_color': '#46465e'}", 0),
      (287, "Outfit 18", "outfit", "sprites/character/outfit/Outfit_18_32x32_01.png", "{'top_color': '#d28a5d', 'bottom_color': '#c37759'}", 0),
      (288, "Outfit 18", "outfit", "sprites/character/outfit/Outfit_18_32x32_02.png", "{'top_color': '#b99e86', 'bottom_color': '#b18a74'}", 0),
      (289, "Outfit 18", "outfit", "sprites/character/outfit/Outfit_18_32x32_03.png", "{'top_color': '#d2585d', 'bottom_color': '#c35059'}", 0),
      (290, "Outfit 18", "outfit", "sprites/character/outfit/Outfit_18_32x32_04.png", "{'top_color': '#4e8bac', 'bottom_color': '#437696'}", 0),
      (291, "Outfit 19", "outfit", "sprites/character/outfit/Outfit_19_32x32_01.png", "{'top_color': '#ebe4f2', 'bottom_color': '#3761d6'}", 0),
      (292, "Outfit 19", "outfit", "sprites/character/outfit/Outfit_19_32x32_02.png", "{'top_color': '#ebe4f2', 'bottom_color': '#565972'}", 0),
      (293, "Outfit 19", "outfit", "sprites/character/outfit/Outfit_19_32x32_03.png", "{'top_color': '#ebe4f2', 'bottom_color': '#6c7193'}", 0),
      (294, "Outfit 19", "outfit", "sprites/character/outfit/Outfit_19_32x32_04.png", "{'top_color': '#ebe4f2', 'bottom_color': '#af7193'}", 0),
      (295, "Outfit 20", "outfit", "sprites/character/outfit/Outfit_20_32x32_01.png", "{'top_color': '#4d5988', 'bottom_color': '#afb5df'}", 0),
      (296, "Outfit 20", "outfit", "sprites/character/outfit/Outfit_20_32x32_02.png", "{'top_color': '#b7bccf', 'bottom_color': '#525eaf'}", 0),
      (297, "Outfit 20", "outfit", "sprites/character/outfit/Outfit_20_32x32_03.png", "{'top_color': '#3eab7e', 'bottom_color': '#456786'}", 0),
      (298, "Outfit 21", "outfit", "sprites/character/outfit/Outfit_21_32x32_01.png", "{'top_color': '#76689e', 'bottom_color': '#afb5df'}", 0),
      (299, "Outfit 21", "outfit", "sprites/character/outfit/Outfit_21_32x32_02.png", "{'top_color': '#a99dca', 'bottom_color': '#5e6381'}", 0),
      (300, "Outfit 21", "outfit", "sprites/character/outfit/Outfit_21_32x32_03.png", "{'top_color': '#428f9e', 'bottom_color': '#afb5df'}", 0),
      (301, "Outfit 21", "outfit", "sprites/character/outfit/Outfit_21_32x32_04.png", "{'top_color': '#e17846', 'bottom_color': '#afb5df'}", 0),
      (302, "Outfit 22", "outfit", "sprites/character/outfit/Outfit_22_32x32_01.png", "{'top_color': '#88818e', 'bottom_color': '#3a3a50'}", 0),
      (303, "Outfit 22", "outfit", "sprites/character/outfit/Outfit_22_32x32_02.png", "{'top_color': '#6b6358', 'bottom_color': '#3a3a50'}", 0),
      (304, "Outfit 22", "outfit", "sprites/character/outfit/Outfit_22_32x32_03.png", "{'top_color': '#416358', 'bottom_color': '#3a3a50'}", 0),
      (305, "Outfit 22", "outfit", "sprites/character/outfit/Outfit_22_32x32_04.png", "{'top_color': '#4263a1', 'bottom_color': '#3a3a50'}", 0),
      (306, "Outfit 23", "outfit", "sprites/character/outfit/Outfit_23_32x32_01.png", "{'top_color': '#bda766', 'bottom_color': '#bda766'}", 0),
      (307, "Outfit 23", "outfit", "sprites/character/outfit/Outfit_23_32x32_02.png", "{'top_color': '#bda7a7', 'bottom_color': '#bda7a7'}", 0),
      (308, "Outfit 23", "outfit", "sprites/character/outfit/Outfit_23_32x32_03.png", "{'top_color': '#77bfbf', 'bottom_color': '#77bfbf'}", 0),
      (309, "Outfit 23", "outfit", "sprites/character/outfit/Outfit_23_32x32_04.png", "{'top_color': '#77bf71', 'bottom_color': '#77bf71'}", 0),
      (310, "Outfit 24", "outfit", "sprites/character/outfit/Outfit_24_32x32_01.png", "{'top_color': '#0092e3', 'bottom_color': '#0092e3'}", 0),
      (311, "Outfit 24", "outfit", "sprites/character/outfit/Outfit_24_32x32_02.png", "{'top_color': '#6dcfc6', 'bottom_color': '#6dcfc6'}", 0),
      (312, "Outfit 24", "outfit", "sprites/character/outfit/Outfit_24_32x32_03.png", "{'top_color': '#009292', 'bottom_color': '#009292'}", 0),
      (313, "Outfit 24", "outfit", "sprites/character/outfit/Outfit_24_32x32_04.png", "{'top_color': '#ad83c6', 'bottom_color': '#ad83c6'}", 0),
      (314, "Outfit 25", "outfit", "sprites/character/outfit/Outfit_25_32x32_01.png", "{'top_color': '#0092e3', 'bottom_color': '#0092e3'}", 0),
      (315, "Outfit 25", "outfit", "sprites/character/outfit/Outfit_25_32x32_02.png", "{'top_color': '#9ba3a7', 'bottom_color': '#9ba3a7'}", 0),
      (316, "Outfit 25", "outfit", "sprites/character/outfit/Outfit_25_32x32_03.png", "{'top_color': '#ad957c', 'bottom_color': '#ad957c'}", 0),
      (317, "Outfit 25", "outfit", "sprites/character/outfit/Outfit_25_32x32_04.png", "{'top_color': '#9d4c6d', 'bottom_color': '#9d4c6d'}", 0),
      (318, "Outfit 25", "outfit", "sprites/character/outfit/Outfit_25_32x32_05.png", "{'top_color': '#ffdfec', 'bottom_color': '#ffdfec'}", 0),
      (319, "Outfit 26", "outfit", "sprites/character/outfit/Outfit_26_32x32_01.png", "{'top_color': '#71748c', 'bottom_color': '#71748c'}", 0),
      (320, "Outfit 26", "outfit", "sprites/character/outfit/Outfit_26_32x32_02.png", "{'top_color': '#8c7771', 'bottom_color': '#8c7771'}", 0),
      (321, "Outfit 26", "outfit", "sprites/character/outfit/Outfit_26_32x32_03.png", "{'top_color': '#587793', 'bottom_color': '#587793'}", 0),
      (322, "Outfit 27", "outfit", "sprites/character/outfit/Outfit_27_32x32_01.png", "{'top_color': '#71748c', 'bottom_color': '#71748c'}", 0),
      (323, "Outfit 27", "outfit", "sprites/character/outfit/Outfit_27_32x32_02.png", "{'top_color': '#71748c', 'bottom_color': '#71748c'}", 0),
      (324, "Outfit 27", "outfit", "sprites/character/outfit/Outfit_27_32x32_03.png", "{'top_color': '#7e84bb', 'bottom_color': '#7e84bb'}", 0),
      (325, "Outfit 28", "outfit", "sprites/character/outfit/Outfit_28_32x32_01.png", "{'top_color': '#ead9f3', 'bottom_color': '#535590'}", 0),
      (326, "Outfit 28", "outfit", "sprites/character/outfit/Outfit_28_32x32_02.png", "{'top_color': '#ead9f3', 'bottom_color': '#535590'}", 0),
      (327, "Outfit 28", "outfit", "sprites/character/outfit/Outfit_28_32x32_03.png", "{'top_color': '#ead9f3', 'bottom_color': '#535590'}", 0),
      (328, "Outfit 28", "outfit", "sprites/character/outfit/Outfit_28_32x32_04.png", "{'top_color': '#ead9f3', 'bottom_color': '#6f493c'}", 0),
      (329, "Outfit 29", "outfit", "sprites/character/outfit/Outfit_29_32x32_01.png", "{'top_color': '#b0bfdc', 'bottom_color': '#5a5d78'}", 0),
      (330, "Outfit 29", "outfit", "sprites/character/outfit/Outfit_29_32x32_02.png", "{'top_color': '#6bbfdc', 'bottom_color': '#52578b'}", 0),
      (331, "Outfit 29", "outfit", "sprites/character/outfit/Outfit_29_32x32_03.png", "{'top_color': '#cde6ee', 'bottom_color': '#52578b'}", 0),
      (332, "Outfit 29", "outfit", "sprites/character/outfit/Outfit_29_32x32_04.png", "{'top_color': '#708ce3', 'bottom_color': '#43487e'}", 0),
      (333, "Outfit 30", "outfit", "sprites/character/outfit/Outfit_30_32x32_01.png", "{'top_color': '#565972', 'bottom_color': '#51506f'}", 0),
      (334, "Outfit 30", "outfit", "sprites/character/outfit/Outfit_30_32x32_02.png", "{'top_color': '#71729e', 'bottom_color': '#65648c'}", 0),
      (335, "Outfit 30", "outfit", "sprites/character/outfit/Outfit_30_32x32_03.png", "{'top_color': '#8a837c', 'bottom_color': '#817876'}", 0),
      (336, "Outfit 31", "outfit", "sprites/character/outfit/Outfit_31_32x32_01.png", "{'top_color': '#000000', 'bottom_color': '#335789'}", 0),
      (337, "Outfit 31", "outfit", "sprites/character/outfit/Outfit_31_32x32_02.png", "{'top_color': '#000000', 'bottom_color': '#6c3e89'}", 0),
      (338, "Outfit 31", "outfit", "sprites/character/outfit/Outfit_31_32x32_03.png", "{'top_color': '#000000', 'bottom_color': '#453e85'}", 0),
      (339, "Outfit 31", "outfit", "sprites/character/outfit/Outfit_31_32x32_04.png", "{'top_color': '#000000', 'bottom_color': '#276858'}", 0),
      (340, "Outfit 31", "outfit", "sprites/character/outfit/Outfit_31_32x32_05.png", "{'top_color': '#000000', 'bottom_color': '#694334'}", 0),
      (341, "Outfit 32", "outfit", "sprites/character/outfit/Outfit_32_32x32_01.png", "{'top_color': '#335789', 'bottom_color': '#63a9e2'}", 0),
      (342, "Outfit 32", "outfit", "sprites/character/outfit/Outfit_32_32x32_02.png", "{'top_color': '#644074', 'bottom_color': '#cea9e2'}", 0),
      (343, "Outfit 32", "outfit", "sprites/character/outfit/Outfit_32_32x32_03.png", "{'top_color': '#5e5b60', 'bottom_color': '#dce1e9'}", 0),
      (344, "Outfit 32", "outfit", "sprites/character/outfit/Outfit_32_32x32_04.png", "{'top_color': '#464965', 'bottom_color': '#777b82'}", 0),
      (345, "Outfit 32", "outfit", "sprites/character/outfit/Outfit_32_32x32_05.png", "{'top_color': '#683f3d', 'bottom_color': '#f78c31'}", 0),
      (346, "Outfit 33", "outfit", "sprites/character/outfit/Outfit_33_32x32_01.png", "{'top_color': '#fdf8ec', 'bottom_color': '#eadbd4'}", 0),
      (347, "Outfit 33", "outfit", "sprites/character/outfit/Outfit_33_32x32_02.png", "{'top_color': '#e7f8ec', 'bottom_color': '#b2dbd4'}", 0),
      (348, "Outfit 33", "outfit", "sprites/character/outfit/Outfit_33_32x32_03.png", "{'top_color': '#e7e5ec', 'bottom_color': '#b2bad4'}", 0)
    """);
  }

  Future<void> _addNames() async {
    final db = await instance.database;
    // TODO: add names.
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
