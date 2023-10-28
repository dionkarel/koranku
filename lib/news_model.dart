class News {
  final String title;
  final String description;
  final String url;
  final String publishedAt;
  final String content;
  final String author;
  final String urlToImage;


  News(this.title, this.description, this.url, this.publishedAt, this.content, this.author, this.urlToImage);

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      json['title'] != null ? json['title'] as String : '',
      json['description'] != null ? json['description'] as String : '',
      json['url'] != null ? json['url'] as String : '',
      json['publishedAt'] != null ? json['publishedAt'] as String : '',
      json['content'] != null ? json['content'] as String : '',
      json['author'] != null ? json['author'] as String : '',
      json['urlToImage'] != null ? json['urlToImage'] as String : '',
    );
  }
}
