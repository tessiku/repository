// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../display/ArticlePage.dart';
import '../api/NewsApi.dart';
import '../model/Article.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);
  final String? title;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
          width: 100,
          height: 100,
          child: Transform.scale(scale: 1.5, child: Icon(Icons.newspaper)),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: const Text(
              'Suggested Articles',
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
                if (article.title == null || article.description == null) {
                  return SizedBox();
                }
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
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              dynamic conversationObject = {
                'appId':
                    '25aefadf29154e9cf2f13546d53acbb12' // The [APP_ID](https://dashboard.kommunicate.io/settings/install) obtained from kommunicate dashboard.
              };
              dynamic result = await KommunicateFlutterPlugin.buildConversation(
                  conversationObject);
              print("Conversation builder success : " + result.toString());
            } on Exception catch (e) {
              print("Conversation builder error occurred : " + e.toString());
            }
          },
          backgroundColor: Color.fromARGB(
              195, 0, 138, 251), // Set the desired background color
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Icon(
            Icons.smart_toy,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }
}
