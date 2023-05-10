class news_model {
  String? title;
  String? author;
  String? content;
  String? urlToImage;
  String? date;

//create the constoctor
  news_model(
    this.title,
    this.author,
    this.content,
    this.date,
    this.urlToImage,
  );
  static List<news_model> breakingNewsdata = [
    news_model(
        'Indonesia cuts tax breaks to discourage low quality nickel investment-minister',
        'Reuters',
        'Indonesia cuts tax breaks to discourage low quality nickel investment-minister',
        '2023-05-04T04:01:14Z',
        'https://i-invdn-com.investing.com/news/LYNXNPEC602U7_L.jpg'),
    news_model(
        'Indonesia cuts tax breaks to discourage low quality nickel investment-minister',
        'Reuters',
        'Indonesia cuts tax breaks to discourage low quality nickel investment-minister',
        '2023-05-04T04:01:14Z',
        'https://i-invdn-com.investing.com/news/LYNXNPEC602U7_L.jpg')
  ];
}
