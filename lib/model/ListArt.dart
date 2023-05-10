import '../model/Article.dart';

class ListArt {
  final List<Article> lists;

  ListArt({required this.lists});

  factory ListArt.fromJson(Map<String, dynamic> jsonData) {
    List<Article> articles = [];
    if (jsonData['articles'] != null) {
      jsonData['articles'].forEach((article) {
        articles.add(Article.fromJson(article));
      });
    }
    return ListArt(lists: articles);
  }
}
