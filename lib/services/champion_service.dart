import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/champion_model.dart';

class ChampionService {

  late Database _database;
  bool _isDbInitialized = false;

  ChampionService() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'champions.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE champions(id TEXT PRIMARY KEY, json TEXT)',
        );
      },
      version: 1,
    );
    _isDbInitialized = true;
  }

  Future<void> saveChampionsLocally(List<Champion> champions) async {
    if (!_isDbInitialized) await _initDatabase();
    final Batch batch = _database.batch();
    for (var champ in champions) {
      batch.insert(
        'champions',
        {'id': champ.id, 'json': jsonEncode(champ.toJson())},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Champion>> getChampionsLocally() async {
    if (!_isDbInitialized) await _initDatabase();
    final List<Map<String, dynamic>> maps = await _database.query('champions');
    if (maps.isEmpty) return [];

    return List.generate(maps.length, (i) {
      final jsonString = maps[i]['json'] as String;
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return Champion(
        id: maps[i]['id'] as String,
        key: jsonMap['key'] as String,
        name: jsonMap['name'] as String,
        title: jsonMap['title'] as String,
      );
    });
  }

  Future<List<Champion>> fetchAllChampions(String languageCode) async {
    final url = Uri.parse('https://ddragon.leagueoflegends.com/cdn/13.24.1/data/$languageCode/champion.json');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData =
        json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> championsMap = decodedData['data'];

        List<Champion> champions = championsMap.entries.map((entry) {
          return Champion.fromJson(entry.key, entry.value);
        }).toList();

        await saveChampionsLocally(champions);
        return champions;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch error: $e. Loading local data...');
      final localData = await getChampionsLocally();
      if (localData.isNotEmpty) return localData;
      rethrow;
    }
  }

  Future<ChampionDetail> fetchChampionDetails(String championId, String languageCode) async {
    final url = Uri.parse('https://ddragon.leagueoflegends.com/cdn/13.24.1/data/$languageCode/champion/$championId.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData =
      json.decode(utf8.decode(response.bodyBytes));
      return ChampionDetail.fromJson(decodedData);
    } else {
      throw Exception('Details Error: ${response.statusCode}');
    }
  }
}