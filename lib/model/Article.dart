import 'package:flutter/foundation.dart';

class Article {                                         //les caracters de l'article
  final String title; 
  final String description;
  final String imageUrl;
  final String ArticleUrl;

  Article({
    required this.title,
    required this.description,                              //les caracters de l'article             
    required this.imageUrl,
    required this.ArticleUrl,
  });

  factory Article.fromJson(Map<String, dynamic> jsonData) {       //convertir le json en article . 
    return Article(
      title: jsonData['title'],
      description: jsonData['description'],
      imageUrl: jsonData['urlToImage'],
      ArticleUrl: jsonData['url'],
    );
  }
}
