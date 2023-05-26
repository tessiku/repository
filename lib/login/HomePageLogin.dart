import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ins_app/Pages1/AccountPage.dart';
import 'package:ins_app/Pages1/HomePage.dart';

import 'package:ins_app/Pages1/StatsPage.dart';
import 'package:ins_app/greeding/GreedingPage.dart';
import 'package:ins_app/login/Admin/dash2.dart';
import 'package:ins_app/services/Cin_Collector.dart';
import '../display/ArticlePage.dart';
import '../api/NewsApi.dart';
import '../model/Article.dart';
import 'package:http/http.dart' as http;

import 'Work/AddPerson.dart';
import 'Work/CalendarPage.dart';
import 'Work/CheckPage.dart';
import 'Work/EventListPage.dart';
//import 'package:ins_app/greeding/Barwork.dart';

class HomePageLogin extends StatefulWidget {
  HomePageLogin({
    Key? key,
    this.title,
    required this.userEmail,
    required this.name,
  }) : super(key: key);
  final String? title;
  final String userEmail;
  final String name;

  @override
  State<HomePageLogin> createState() => _HomePageLoginState();
}

class _HomePageLoginState extends State<HomePageLogin> {
  List<Article> articles = [];
 // late String userEmail;
 // late String name;
  /*User? getCurrentUser() {
    // jbli el inforamtion mta3 el user
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }*/

  @override
  void initState() {
    super.initState();
    fetchArticles();
    setState(() {
      
    });
    //userdata();
  }

  //fetch info current user
  /*void userdata() async {
    var user = getCurrentUser();
    if (user != null) {
      var email = user.email;
      
      setState(() {
        userEmail = email!;
        
      });
      print(userEmail);
      print(name);
    }
  }*/

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
      'assets/default1.jpg',
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
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 203, 207, 227),
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.name),
                accountEmail: Text(widget.userEmail),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
                        builder: (context) => HomePageLogin(
                              title: 'Home Page',
                              userEmail: widget.userEmail,
                              name: widget.name,
                            )),
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
                leading: Icon(Icons.calendar_view_day),
                title: Text('To do list'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventListPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                onTap: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GreedingPage()),
                    (route) => false,
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
                                      'assets/default1.jpg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/default1.jpg",
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
      floatingActionButton: MyCustomWidget(),
    );
  }
}

class MyCustomWidget extends StatelessWidget {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Builder(
      builder: (context) => FabCircularMenu(
        key: fabKey,
        alignment: Alignment.bottomRight,
        ringColor: Color.fromARGB(61, 29, 29, 29).withAlpha(100),
        ringDiameter: 500.0,
        ringWidth: 150.0,
        fabSize: 64.0,
        fabElevation: 8.0,
        fabIconBorder: CircleBorder(),
        fabColor: Color.fromARGB(255, 255, 255, 255),
        fabOpenIcon: Icon(Icons.menu, color: primaryColor),
        fabCloseIcon: Icon(Icons.close, color: primaryColor),
        fabMargin: const EdgeInsets.all(16.0),
        animationDuration: const Duration(milliseconds: 800),
        animationCurve: Curves.easeInOutCirc,
        onDisplayChange: (isOpen) {
          _showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
        },
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              _navigateToPage(context, " 1");
            },
            shape: CircleBorder(),
            padding: const EdgeInsets.all(24.0),
            child: Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)),
          ),
          RawMaterialButton(
            onPressed: () {
              _navigateToPage(context, " 2");
            },
            shape: CircleBorder(),
            padding: const EdgeInsets.all(24.0),
            child: Icon(Icons.search, color: Color.fromARGB(255, 0, 250, 137)),
          ),
          RawMaterialButton(
            onPressed: () {
              _navigateToPage(context, " 3");
            },
            shape: CircleBorder(),
            padding: const EdgeInsets.all(24.0),
            child: Icon(Icons.calendar_view_day,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          RawMaterialButton(
            onPressed: () {
              _navigateToPage(context, " 4");
              fabKey.currentState?.close();
            },
            shape: CircleBorder(),
            padding: const EdgeInsets.all(24.0),
            child:
                Icon(Icons.add_alert, color: Color.fromARGB(255, 188, 226, 0)),
          )
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }

  void _navigateToPage(BuildContext context, String pageTitle) {
    Widget page;

    switch (pageTitle) {
      case " 1":
        page = AddPerson();
        break;
      case " 2":
        page = cin_Collector( );
        break;
      case " 3":
        page = RegionCitoyen();
        break;
      case " 4":
        page = EventListPage();
        break;
      default:
        page = Container(); // Provide a fallback page or handle error case
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
