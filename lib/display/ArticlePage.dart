import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/Article.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  const ArticlePage({Key? key, required this.article}) : super(key: key);

  Future<void> launchArticleUrl(BuildContext context) async {
    final url = article.ArticleUrl;                    // article.ArticleUrl;
    final uri = Uri.parse(url);                            // encodeFull(url) bech najem nessta3em el url lancher ba3ed ma n7otouh fi uri

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // bech n7el el url yaffichi fi chrome wa  ay browser mte3i 
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/default.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.description,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            //make this button have all the width available
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => launchArticleUrl(context),
                  child: const Text('Explore Now!'),
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(255, 94, 6, 247),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
