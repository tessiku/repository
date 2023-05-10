import 'package:flutter/foundation.dart';

class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String ArticleUrl;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ArticleUrl,
  });

  factory Article.fromJson(Map<String, dynamic> jsonData) {
    return Article(
      title: jsonData['title'],
      description: jsonData['description'],
      imageUrl: jsonData['urlToImage'],
      ArticleUrl: jsonData['url'],
    );
  }
}
