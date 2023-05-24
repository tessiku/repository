import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ins_app/Pages1/StatsPage.dart';
import 'package:ins_app/greeding/GreedingPage.dart';
import 'package:ins_app/services/Enquette.dart';
import '../display/ArticlePage.dart';
import '../api/NewsApi.dart';
import '../model/Article.dart';

class HomePageLoginC extends StatefulWidget {
  HomePageLoginC(
      {Key? key, this.title, required this.userEmail, required this.name})
      : super(key: key);
  final String? title;
  final String userEmail;
  final String name;
  late String cin = '';

  @override
  State<HomePageLoginC> createState() => _HomePageLoginCState();
}

class _HomePageLoginCState extends State<HomePageLoginC> {
  List<Article> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
    checkUserAuth();
    //getUserUid();
  }

  Future<String?> checkUserAuth() async {
    // Get the current user
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? cin1;

    // Check if the user is signed in
    if (currentUser != null) {
      // Get the reference to the "Citoyen" collection
      CollectionReference citoyenCollection =
          FirebaseFirestore.instance.collection('Citoyen');

      // Query all documents in the "Citoyen" collection
      QuerySnapshot querySnapshot = await citoyenCollection.get();

      // Iterate over each document in the query snapshot
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Get the reference to the "data" subcollection inside the document
        CollectionReference dataCollection =
            documentSnapshot.reference.collection('data');

        // Query the "uid" document in the "data" subcollection
        DocumentSnapshot<Object?> uidQuerySnapshot = await dataCollection
            .doc('UID')
            .get(); // Assuming 'uid' is the document ID

        // Check if the "uid" document exists
        if (uidQuerySnapshot.exists) {
          // Get the data map for the "uid" document
          Map<String, dynamic>? data =
              uidQuerySnapshot.data() as Map<String, dynamic>?;

          // Check if the "uid" document has a field named "uid"
          if (data != null && data.containsKey('uid')) {
            // Get the value of the "uid" field
            String? uid = data['uid'];

            // Check if the UID matches the currently signed-in user
            if (uid == currentUser.uid) {
              // Retrieve the document ID (CIN) of the matching document
              String documentId = documentSnapshot.id;
              print('Document ID (CIN): $documentId');
              cin1 = documentId;
              setState(() {
                widget.cin = documentId;
              });

              break; // Exit the loop after finding the first match
            }
          }
        }
      }
    } else {
      // User is not signed in
      print('User is not signed in');
    }
    return cin1;
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
                        builder: (context) => HomePageLoginC(
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
                leading: Icon(Icons.handshake),
                title: Text('To do list'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Enquette(
                              cin: widget.cin,
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log out'),
                onTap: () {
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
