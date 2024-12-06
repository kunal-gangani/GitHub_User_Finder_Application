import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GitHubController extends ChangeNotifier {
  List<String> starredList = [];

  Future<void> loadStarredList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    starredList = prefs.getStringList('starred_list') ?? [];
    notifyListeners();
  }

  Future<void> addToStarred(String repo) async {
    if (!starredList.contains(repo)) {
      starredList.add(repo);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('starred_list', starredList);
      notifyListeners();
    }
  }

  Future<void> removeFromStarred(String repo) async {
    if (starredList.contains(repo)) {
      starredList.remove(repo);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('starred_list', starredList);
      notifyListeners();
    }
  }
}
