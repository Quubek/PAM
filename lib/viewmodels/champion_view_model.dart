import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/champion_model.dart';
import '../services/champion_service.dart';

enum ViewState { initial, loading, loaded, error, loadedOffline }

class ChampionViewModel extends ChangeNotifier {
  final ChampionService _championService;

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  List<Champion> _allChampions = [];
  List<Champion> _filteredChampions = [];
  List<Champion> get filteredChampions => _filteredChampions;

  String _currentSearchQuery = '';

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  final String _currentLanguage = 'pl_PL';
  String get currentLanguage => _currentLanguage;

  Champion? _randomChampion;
  Champion? get randomChampion => _randomChampion;

  ChampionViewModel(this._championService);

  Future<void> loadChampions() async {
    if (_state == ViewState.loading) return;

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _allChampions = await _championService.fetchAllChampions(_currentLanguage);
      _state = ViewState.loaded;
      _isOffline = false;
      _pickRandomChampion();
      _applyFilter(_currentSearchQuery);
    } catch (e) {
      final localData = await _championService.getChampionsLocally();
      if (localData.isNotEmpty) {
        _allChampions = localData;
        _state = ViewState.loadedOffline;
        _isOffline = true;
        _pickRandomChampion();
        _applyFilter(_currentSearchQuery);
      } else {
        _errorMessage = e.toString();
        _state = ViewState.error;
      }
    } finally {
      notifyListeners();
    }
  }

  void _pickRandomChampion() {
    if (_allChampions.isNotEmpty) {
      final random = Random();
      _randomChampion = _allChampions[random.nextInt(_allChampions.length)];
    }
  }

  void searchChampions(String query) {
    _currentSearchQuery = query;
    _applyFilter(query);
    notifyListeners();
  }

  void _applyFilter(String query) {
    if (query.isEmpty) {
      _filteredChampions = _allChampions;
    } else {
      _filteredChampions = _allChampions
          .where((champion) => champion.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<ChampionDetail> getChampionDetails(String championId) async {
    return _championService.fetchChampionDetails(championId, _currentLanguage);
  }

  void logSearchEvent(String query) {
    if (kDebugMode) print('Analytics: Logged search: $query');
  }
}