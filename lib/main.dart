// lib/main.dart

import 'package:flutter/material.dart';
// import 'package:football_news_mobile/screens/menu.dart'; // <- ini boleh dihapus dulu
import 'package:provider/provider.dart';                 // <-- PENTING
import 'package:pbp_django_auth/pbp_django_auth.dart';    // <-- PENTING
import 'package:football_news_mobile/screens/login.dart'; // <-- PENTING

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        // PASTIKAN HOME-NYA KE LOGINPAGE
        home: const LoginPage(), 
      ),
    );
  }
}