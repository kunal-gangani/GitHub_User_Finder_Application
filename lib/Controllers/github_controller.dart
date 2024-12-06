import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GitHubController extends ChangeNotifier {
  List<String> _starredList = [];

  List<String> get starredList => _starredList;

  GitHubController() {
    _loadStarredList();
  }

  Future<void> _loadStarredList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _starredList = prefs.getStringList('starred_list') ?? [];
    notifyListeners();
  }

  Future<void> addToStarred(String repo) async {
    if (!_starredList.contains(repo)) {
      _starredList.add(repo);
      await _updateSharedPreferences();
      notifyListeners();
    }
  }

  Future<void> removeFromStarred(String repo) async {
    if (_starredList.contains(repo)) {
      _starredList.remove(repo);
      await _updateSharedPreferences();
      notifyListeners();
    }
  }

  Future<void> _updateSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('starred_list', _starredList);
  }
}
