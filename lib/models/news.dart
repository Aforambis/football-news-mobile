import 'dart:convert';

List<News> newsFromJson(String str) => List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

String newsToJson(List<News> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class News {
    final String id;
    final String title;
    final String content;
    final String category;
    final String? thumbnail;
    final int newsViews;
    final DateTime createdAt;
    final bool isFeatured;
    final int userId;

    News({
        required this.id,
        required this.title,
        required this.content,
        required this.category,
        this.thumbnail,
        required this.newsViews,
        required this.createdAt,
        required this.isFeatured,
        required this.userId,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        newsViews: json["news_views"],
        createdAt: DateTime.parse(json["created_at"]),
        isFeatured: json["is_featured"],
        userId: json["user_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "category": category,
        "thumbnail": thumbnail,
        "news_views": newsViews,
        "created_at": createdAt.toIso8601String(),
        "is_featured": isFeatured,
        "user_id": userId,
    };
}