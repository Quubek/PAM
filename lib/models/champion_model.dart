import 'dart:convert';

class Champion {
  final String id;
  final String key;
  final String name;
  final String title;

  static const String BASE_IMAGE_URL =
      'https://ddragon.leagueoflegends.com/cdn/13.24.1/img/champion/';

  String get loadingImageUrl => 'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${id}_0.jpg';
  String get splashImageUrl => 'https://ddragon.leagueoflegends.com/cdn/img/champion/splash/${id}_0.jpg';
  String get imageUrl => '$BASE_IMAGE_URL$id.png';

  Champion({required this.id, required this.key, required this.name, required this.title});

  factory Champion.fromJson(String championId, Map<String, dynamic> json) {
    return Champion(
      id: json['id'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'key': key,
    'name': name,
    'title': title,
  };
}

class ChampionDetail {
  final String id;
  final String name;
  final String lore;
  final String blurb;
  final List<String> tags;
  final List<Spell> spells;
  final Passive passive;
  final List<Skin> skins;
  final ChampionInfo info;
  final List<String> allyTips;
  final List<String> enemyTips;

  ChampionDetail({
    required this.id,
    required this.name,
    required this.lore,
    required this.blurb,
    required this.tags,
    required this.spells,
    required this.passive,
    required this.skins,
    required this.info,
    required this.allyTips,
    required this.enemyTips,
  });

  factory ChampionDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data'].values.first as Map<String, dynamic>;

    List<Spell> spells = (data['spells'] as List)
        .map((spellJson) => Spell.fromJson(spellJson as Map<String, dynamic>))
        .toList();

    List<Skin> skins = (data['skins'] as List)
        .map((skinJson) => Skin.fromJson(skinJson, data['id']))
        .toList();

    return ChampionDetail(
      id: data['id'] as String,
      name: data['name'] as String,
      lore: data['lore'] as String,
      blurb: data['blurb'] as String,
      tags: List<String>.from(data['tags'] as List),
      spells: spells,
      passive: Passive.fromJson(data['passive']),
      skins: skins,
      info: ChampionInfo.fromJson(data['info']),
      allyTips: List<String>.from(data['allytips'] ?? []),
      enemyTips: List<String>.from(data['enemytips'] ?? []),
    );
  }
}

class ChampionInfo {
  final int attack;
  final int defense;
  final int magic;
  final int difficulty;

  ChampionInfo({
    required this.attack,
    required this.defense,
    required this.magic,
    required this.difficulty,
  });

  factory ChampionInfo.fromJson(Map<String, dynamic> json) {
    return ChampionInfo(
      attack: json['attack'] ?? 0,
      defense: json['defense'] ?? 0,
      magic: json['magic'] ?? 0,
      difficulty: json['difficulty'] ?? 0,
    );
  }
}

class Spell {
  final String id;
  final String name;
  final String description;
  final String cooldown;
  final String cost;
  final String range;
  final String imageId;

  Spell({
    required this.id,
    required this.name,
    required this.description,
    required this.cooldown,
    required this.cost,
    required this.range,
    required this.imageId,
  });

  String get imageUrl => 'https://ddragon.leagueoflegends.com/cdn/13.24.1/img/spell/$imageId';

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      cooldown: json['cooldownBurn']?.toString() ?? 'N/A',
      cost: json['costBurn']?.toString() ?? '0',
      range: json['rangeBurn']?.toString() ?? 'N/A',
      imageId: json['image']['full'],
    );
  }
}

class Passive {
  final String name;
  final String description;
  final String imageId;

  Passive({required this.name, required this.description, required this.imageId});

  String get imageUrl => 'https://ddragon.leagueoflegends.com/cdn/13.24.1/img/passive/$imageId';

  factory Passive.fromJson(Map<String, dynamic> json) {
    return Passive(
      name: json['name'],
      description: json['description'],
      imageId: json['image']['full'],
    );
  }
}

class Skin {
  final String id;
  final int num;
  final String name;
  final String championId;

  Skin({required this.id, required this.num, required this.name, required this.championId});

  String get skinImageUrl => 'https://ddragon.leagueoflegends.com/cdn/img/champion/loading/${championId}_$num.jpg';

  factory Skin.fromJson(Map<String, dynamic> json, String championId) {
    return Skin(
      id: json['id'],
      num: json['num'],
      name: json['name'] == 'default' ? 'Podstawowa' : json['name'],
      championId: championId,
    );
  }
}