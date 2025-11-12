// lib/screens/news_list.dart (Versi BARU dengan Card Cantik)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:football_news_mobile/models/news.dart'; 
import 'package:football_news_mobile/widgets/left_drawer.dart';
import 'package:intl/intl.dart'; 

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {

  final String _appUrl = "http://localhost:8000"; 

  Future<List<News>> fetchNews() async {
    var url = Uri.parse('$_appUrl/json/'); 
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<News> listNews = [];
    for (var d in data) {
      if (d != null) {
        listNews.add(News.fromJson(d));
      }
    }
    return listNews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football News List'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchNews(),
        builder: (context, AsyncSnapshot<List<News>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news found.'));
          } else {
            // GANTI DARI SINI: Pakai ListView, bukan ListView.builder
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: snapshot.data!.map((news) {
                // Widget Card kustom baru
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  clipBehavior: Clip.antiAlias, // Biar gambar di card rounded
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- GAMBARNYA DISINI ---
                      // Cek jika thumbnail valid dan bukan error box
                      if (news.thumbnail != null && 
                          news.thumbnail!.isNotEmpty && 
                          (news.thumbnail!.startsWith('http') || news.thumbnail!.startsWith('https')))
                        Image.network(
                          news.thumbnail!,
                          width: double.infinity, // Lebar penuh
                          height: 200,            // Tinggi 200
                          fit: BoxFit.cover,
                          // Loading builder biar ada spinner
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          // Error builder jika link gambar error (kayak Pinterest tadi)
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              height: 200,
                              child: Center(
                                child: Icon(Icons.broken_image, color: Colors.grey, size: 48),
                              ),
                            );
                          },
                        ),
                      
                      // --- KONTEN TEKS DI BAWAH GAMBAR ---
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              // Format tanggal jadi lebih cantik
                              DateFormat('d MMMM yyyy').format(news.createdAt),
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              news.content,
                              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${news.newsViews} views'),
                                Text('By User ID: ${news.userId}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
            // --- GANTI SAMPAI SINI ---
          }
        },
      ),
    );
  }
}