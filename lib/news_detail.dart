import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'news_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetail extends StatelessWidget {
  final News article;

  const NewsDetail(this.article, {super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy, HH:mm:ss')
        .format(DateTime.parse(article.publishedAt))
        .toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("KoranKu", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xff060B26),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              CachedNetworkImage(
                imageUrl: article.urlToImage,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset('images/vector.jpg', width: 400, height: 400),
              ),
              const SizedBox(height: 16.0),
              Text("Published At: $formattedDate", style: const TextStyle(fontSize: 12)),
              Text("Author: ${article.author}", style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 16.0),
              Text(
                article.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              const Text("Read more at:"),
              InkWell(
                onTap: () async {
                  if (await canLaunch(article.url)) {
                    await launch(article.url);
                  } else {
                    print("Could not launch ${article.url}");
                  }
                },
                child: Text(
                  article.url,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
