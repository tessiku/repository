import 'package:flutter/material.dart';

class NewsListe extends StatefulWidget {
  NewsListe(this.data, {Key? key}) : super(key: key);
  final data;

  @override
  State<NewsListe> createState() => _NewsListeState();
}

class _NewsListeState extends State<NewsListe> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(12.0),
      height: 200,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(26.0)),
      child: Row(
        children: [
          Flexible(
              flex: 3,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19.0),
                  image: DecorationImage(
                      image: NetworkImage(widget.data.urlToImage!),
                      fit: BoxFit.fitHeight),
                ),
              ))
        ],
      ),
    );
  }
}
