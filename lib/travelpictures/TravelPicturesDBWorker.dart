import 'package:sqflite/sqflite.dart';
import 'TravelPicturesModel.dart';

/// Travel 
class TravelPicturesDBWorker {
  static final TravelPicturesDBWorker db = TravelPicturesDBWorker._();

  // required data to create and insert into DB
  static const String DB_NAME = 'travelPictures.db';
  static const String TBL_NAME = 'travelPictures';
  static const String KEY_ID = 'id';
  static const String KEY_NAME = 'name';
  static const String KEY_PLACE = 'place';
  static const String KEY_DIARY = 'diary';
  static const String KEY_DATE = 'date';

  Database _db;

  TravelPicturesDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    return await openDatabase(DB_NAME, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $TBL_NAME ("
          "$KEY_ID INTEGER PRIMARY KEY,"
          "$KEY_NAME TEXT,"
          "$KEY_PLACE TEXT,"
          "$KEY_DIARY TEXT,"
          "$KEY_DATE TEXT"
          ")");
    });
  }

  @override
  Future<int> create(TravelPicture travelPicture) async {
    Database db = await database;
    return await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_NAME, $KEY_PLACE, $KEY_DIARY, $KEY_DATE) "
        "VALUES (?, ?, ?, ?)",
        [
          travelPicture.name,
          travelPicture.place,
          travelPicture.diary,
          travelPicture.date
        ]);
  }

  @override
  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<TravelPicture> get(int id) async {
    Database db = await database;
    var values =
        await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _travelPictureFromMap(values.first);
  }

  @override
  Future<List<TravelPicture>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty
        ? values.map((m) => _travelPictureFromMap(m)).toList()
        : [];
  }

  @override
  Future<int> update(TravelPicture travelPicture) async {
    Database db = await database;
    return await db.update(TBL_NAME, _travelPictureToMap(travelPicture),
        where: "$KEY_ID = ?", whereArgs: [travelPicture.id]);
  }

  TravelPicture _travelPictureFromMap(Map<String, dynamic> map) {
    return TravelPicture()
      ..id = map[KEY_ID]
      ..name = map[KEY_NAME]
      ..place = map[KEY_PLACE]
      ..diary = map[KEY_DIARY]
      ..date = map[KEY_DATE];
  }

  Map<String, dynamic> _travelPictureToMap(TravelPicture travelPicture) {
    return Map<String, dynamic>()
      ..[KEY_ID] = travelPicture.id
      ..[KEY_NAME] = travelPicture.name
      ..[KEY_PLACE] = travelPicture.place
      ..[KEY_DIARY] = travelPicture.diary
      ..[KEY_DATE] = travelPicture.date;
  }
}
