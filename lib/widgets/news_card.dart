// lib/widgets/news_card.dart (Final Version)

import 'package:flutter/material.dart';
import 'package:football_news_mobile/screens/newslist_form.dart';
import 'package:provider/provider.dart';                 
import 'package:pbp_django_auth/pbp_django_auth.dart';    
import 'package:football_news_mobile/screens/login.dart'; 
import 'package:football_news_mobile/screens/news_list.dart'; // Pastikan file ini ada

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;
  const ItemCard(this.item, {super.key});

  final String _appUrl = "http://localhost:8000";

  @override
  Widget build(BuildContext context) {
    // 1. Ambil request dari Provider
    final request = context.watch<CookieRequest>();

    Color cardColor = Colors.blueAccent[400]!;
    if (item.name == "Add News") {
      cardColor = Colors.indigo;
    } else if (item.name == "Logout") {
      cardColor = Colors.red;
    }

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        // 2. Jadikan 'async'
        onTap: () async {
          // 3. Logika diperluas dengan 'else if'
          
          if (item.name == "Add News") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsFormPage()),
            );
          } 
          
          // 4. Tambahkan logika "See Football News"
          else if (item.name == "See Football News") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewsListPage()),
            );
          } 

          // 5. Tambahkan logika "Logout"
          else if (item.name == "Logout") {
            final response = await request.logout("$_appUrl/auth/logout/");
            if (context.mounted) {
              if (response['status']) {
                // Navigasi kembali ke Login dan hapus semua halaman sebelumnya
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(response['message'])));
              } else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(response['message'])));
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: Colors.white, size: 30.0),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}