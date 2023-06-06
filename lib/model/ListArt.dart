import '../model/Article.dart';

class ListArt {
  final List<Article> lists;
                                          
  ListArt({required this.lists});

  factory ListArt.fromJson(Map<String, dynamic> jsonData) {   // convertir le json en list d'article , houwa deja 5ater 3andna list d'article
                                                                
    List<Article> articles = [];
    if (jsonData['articles'] != null) {
      jsonData['articles'].forEach((article) {
        articles.add(Article.fromJson(article));
      });
    }
    return ListArt(lists: articles);
  }
}
