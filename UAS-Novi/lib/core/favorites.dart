import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites {
  static const _kFavHouses = "fav_houses";
  static const _kFavArticles = "fav_articles";

  static Future<Set<int>> _getSet(String key) async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(key) ?? "[]";
    return (jsonDecode(raw) as List).map((e) => e as int).toSet();
  }

  static Future<void> _saveSet(String key, Set<int> set) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(key, jsonEncode(set.toList()));
  }

  static Future<Set<int>> getHouseIds() => _getSet(_kFavHouses);
  static Future<Set<int>> getArticleIds() => _getSet(_kFavArticles);

  static Future<bool> isHouseFav(int id) async => (await getHouseIds()).contains(id);
  static Future<bool> isArticleFav(int id) async => (await getArticleIds()).contains(id);

  static Future<void> toggleHouse(int id) async {
    final set = await getHouseIds();
    set.contains(id) ? set.remove(id) : set.add(id);
    await _saveSet(_kFavHouses, set);
  }

  static Future<void> toggleArticle(int id) async {
    final set = await getArticleIds();
    set.contains(id) ? set.remove(id) : set.add(id);
    await _saveSet(_kFavArticles, set);
  }
}
