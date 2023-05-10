import 'package:flutter/material.dart';
import 'package:ins_app/Pages1/AccountPage.dart';
import 'package:ins_app/Pages1/HomePage.dart';
import 'package:ins_app/Pages1/SettingsPage.dart';
import 'package:ins_app/Pages1/StatsPage.dart';
import 'package:ins_app/greeding/GreedingPage.dart';
import '../display/ArticlePage.dart';
import '../api/NewsApi.dart';
import '../model/Article.dart';
import 'package:http/http.dart' as http;

class HomePageLogin extends StatefulWidget {
  const HomePageLogin({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  State<HomePageLogin> createState() => _HomePageLoginState();
}

class _HomePageLoginState extends State<HomePageLogin> {
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
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 203, 207, 227),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text('accountName'),
                accountEmail: Text('accountEmail'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/avatar_male.png'),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/stats1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePageLogin(title: 'Home Page')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.query_stats_outlined),
                title: Text('Stats'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatsPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('To do list'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              /*ListTile(
                leading: Icon(Icons.work_history),
                title: Text('Work History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountPage()),
                  );
                },
              ),*/
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('logo out'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GreedingPage()),
                  );
                },
              ),
            ],
          ),
        ),
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
