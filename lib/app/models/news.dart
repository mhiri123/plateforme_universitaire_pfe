class News {
  final int id;
  final String title;
  final String content;
  final String imageUrl;
  final String date;

  News({required this.id, required this.title, required this.content, required this.imageUrl, required this.date});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      date: json['date'],
    );
  }
}
