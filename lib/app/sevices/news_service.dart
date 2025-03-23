import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/news.dart';

class NewsService {
  static const String apiUrl = "https://example.com/api/news"; // Remplace avec ton URL API

  static Future<List<News>?> getNews() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => News.fromJson(item)).toList();
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching news: $e");
      return null;
    }
  }
}
