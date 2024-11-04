import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

class PostsRepository {
  static const String _postsKey = 'posts';

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final posts = jsonList.map((json) => Post.fromJson(json)).toList();

        // Guardar en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_postsKey, jsonEncode(jsonList));

        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      return getCachedPosts();
    }
  }

  Future<List<Post>> getCachedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsString = prefs.getString(_postsKey);

    if (postsString != null) {
      final List<dynamic> jsonList = json.decode(postsString);
      return jsonList.map((json) => Post.fromJson(json)).toList();
    }
    return [];
  }
}
