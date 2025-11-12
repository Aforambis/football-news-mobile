import 'package:flutter/material.dart';
import 'package:football_news_mobile/screens/menu.dart';
import 'package:football_news_mobile/screens/newslist_form.dart';
import 'package:football_news_mobile/screens/news_list.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              children: [
                Text(
                  'Football News',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Your one-stop football news app!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Homepage'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add News'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsFormPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('See Football News'),
            onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewsListPage(),
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}
