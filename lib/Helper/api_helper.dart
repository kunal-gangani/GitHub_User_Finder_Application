import 'dart:convert';
import 'dart:developer';
import 'package:country_display_application/Models/git_model.dart';
import 'package:country_display_application/Models/repo_model.dart';
import 'package:country_display_application/Models/user_model.dart';
import 'package:http/http.dart' as http;

class Apihelper {
  Apihelper._();

  static Apihelper apihelper = Apihelper._();

  Future<List<GitModel>?> fetchData() async {
    try {
      http.Response res = await http.get(
        Uri.parse("https://api.github.com/users"),
      );

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        return data.map((user) => GitModel.fromJson(user)).toList();
      } else if (res.statusCode == 403) {
        log("Forbidden: 403 error. Check your token or rate limit.");
        log("Rate Limit Remaining: ${res.headers['x-ratelimit-remaining']}");
        log("Rate Limit Reset: ${res.headers['x-ratelimit-reset']}");
      } else {
        log("Failed to load data: ${res.statusCode}");
      }
    } catch (e) {
      log("Error: $e");
    }
    return null;
  }

  Future<UserModel?> fetchUserData(String query) async {
    try {
      log("Fetching data for user: $query");

      http.Response res = await http.get(
        Uri.parse("https://api.github.com/users/$query"),
      );

      if (res.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(res.body);
        UserModel userData = UserModel.fromJson(data);
        return userData;
      } else if (res.statusCode == 403) {
        log("Forbidden: 403 error. Check your token or rate limit.");
        log("Rate Limit Remaining: ${res.headers['x-ratelimit-remaining']}");
        log("Rate Limit Reset: ${res.headers['x-ratelimit-reset']}");
      } else {
        log("Failed to load user data: ${res.statusCode}");
      }
    } catch (e) {
      log("User ERROR: $e");
    }
    return null;
  }

  Future<List<RepoModel>?> fetchRepoData(String query) async {
    try {
      log("Query: $query");
      http.Response res = await http.get(
        Uri.parse("https://api.github.com/users/$query/repos"),
      );

      log("API Response Status Code: ${res.statusCode}");
      log("API Response Body: ${res.body}");
      log("API Response Headers: ${res.headers}");

      if (res.statusCode == 200) {
        List<dynamic> data = jsonDecode(res.body);
        log("Parsed Data: $data");
        List<RepoModel> repoData =
            data.map((e) => RepoModel.fromJson(e)).toList();
        return repoData;
      } else if (res.statusCode == 403) {
        log("Forbidden: 403 error. Check your token or rate limit.");
        log("Rate Limit Remaining: ${res.headers['x-ratelimit-remaining']}");
        log("Rate Limit Reset: ${res.headers['x-ratelimit-reset']}");
      } else {
        log("Failed to load repo data: ${res.statusCode}");
      }
    } catch (e) {
      log("Repo ERROR: $e");
    }
    return null;
  }
}
