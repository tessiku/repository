import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../model/Article.dart';
import '../model/ListArt.dart';

class NewsApi {
  final String apikey = '78c26ec0f8dd4398b54b3b650843894a';

  Future<List<Article>> fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=$apikey'));
      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = jsonDecode(data);
        ListArt listArt = ListArt.fromJson(jsonData);
        return listArt.lists;
      } else {
        // 401 serveur .... 404 page not found
        print('statuscode =${response.statusCode}');
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  void launchArticleUrl(BuildContext context, Article article) async {
    final url = article.ArticleUrl;
    final uri = Uri.encodeFull(url);

    // ignore: deprecated_member_use
    if (await canLaunch(uri)) {
      // ignore: deprecated_member_use
      await launch(uri, forceSafariVC: false);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
