import 'package:flutter/material.dart';
import '/pages/ArticlePage.dart';
import '../api/NewsApi.dart';
import '../model/Article.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  void fetchArticles() async {
    NewsApi newsApi = NewsApi();
    List<Article> fetchedArticles = await newsApi.fetchData();
    setState(() {
      articles = fetchedArticles;
    });
  }

  //create a default image in case of error
  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/images/default.png',
      fit: BoxFit.cover,
    );
  }
  /*void _navigateToDetails(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsDetailsPage(article: article)),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("what's new in tunisa"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: const Text(
              'News',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics:
                  BouncingScrollPhysics(), // smoothly screen view scrolling
              itemCount: articles.length,
              itemBuilder: (BuildContext context, int index) {
                Article article = articles[index];
                return GestureDetector(
                  onTap: () {
                    // _navigateToDetails(article);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ArticlePage(article: article),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: article.imageUrl != null
                              ? Image.network(
                                  article.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      'assets/images/default1.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/images/default1.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                article.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                article.description,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
