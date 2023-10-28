import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'news_model.dart';
import 'news_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "2a0a49fa1a6640a88ab71cc7203f12a5";
  List<News> articles = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final uri = Uri.parse(
        "https://newsapi.org/v2/everything?q=berita-indonesia&apiKey=$apiKey");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> articlesJson = json.decode(response.body)["articles"];
      setState(() {
        articles = articlesJson
            .map((articleJson) => News.fromJson(articleJson))
            .toList();
        sortArticlesByDate();
      });
    } else {
      print("Failed to load news data");
    }
  }

  void sortArticlesByDate() {
    articles.sort((a, b) {
      DateTime dateA = DateTime.parse(a.publishedAt);
      DateTime dateB = DateTime.parse(b.publishedAt);
      return dateB.compareTo(dateA);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KoranKu", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff060B26),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final isSmallScreen = constraints.maxWidth <= 600;
          final gridCount = isSmallScreen ? 1 : (constraints.maxWidth <= 900 ? 2 : 4);
          return NewsList(articles: articles, gridCount: gridCount);
        },
      ),
    );
  }
}

class NewsList extends StatelessWidget {
  final List<News> articles;
  final int gridCount;

  const NewsList({Key? key, required this.articles, required this.gridCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gridCount == 1) {
      return Scaffold(
        body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return NewsCard(article: article);
          },
        ),
      );
    } else {
      return NewsListGrid(articles: articles, gridCount: gridCount);
    }
  }
}

class NewsCard extends StatelessWidget {
  final News article;

  const NewsCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(article.publishedAt));

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetail(article),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: article.urlToImage,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset('images/vector.jpg', width: 50, height: 50),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsListGrid extends StatelessWidget {
  final List<News> articles;
  final int gridCount;

  const NewsListGrid({Key? key, required this.articles, required this.gridCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GridView.count(
        crossAxisCount: gridCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: articles.map((article) {
          String formattedDate = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(article.publishedAt));
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetail(article),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: article.urlToImage,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Image.asset('images/vector.jpg', width: 50, height: 50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        article.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
