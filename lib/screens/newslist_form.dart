import 'package:flutter/material.dart';
import 'package:football_news_mobile/widgets/left_drawer.dart';
import 'dart:convert'; 
import 'package:provider/provider.dart'; 
import 'package:pbp_django_auth/pbp_django_auth.dart'; 
import 'menu.dart'; 

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({super.key});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  String _category = "update";
  String _thumbnail = "";
  bool _isFeatured = false;

  final List<String> _categories = [
    'transfer',
    'update',
    'exclusive',
    'match',
    'rumor',
    'analysis',
  ];

  // URL ini dari kodemu. Pastikan sudah benar:
  // "http://10.0.2.2:8000" untuk emulator Android
  // "https://<nama-app-deploy>.pbp.cs.ui.ac.id" untuk deploy
  final String _appUrl = "http://localhost:8000";

  @override
  Widget build(BuildContext context) {
    // Ambil 'request' dari Provider
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Form Tambah Berita')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TextFormField Judul (Tidak Berubah) ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Judul Berita",
                    labelText: "Judul Berita",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Judul tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // --- TextFormField Isi Berita (Tidak Berubah) ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Isi Berita",
                    labelText: "Isi Berita",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (String? value) {
                    setState(() {
                      _content = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Isi berita tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // --- TextFormField Thumbnail (Tidak Berubah) ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "URL Thumbnail (opsional)",
                    labelText: "URL Thumbnail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _thumbnail = value!;
                    });
                  },
                ),
              ),
              // --- Dropdown Kategori (Tidak Berubah) ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  value: _category,
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat[0].toUpperCase() + cat.substring(1)),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                ),
              ),
              // --- Switch Featured (Tidak Berubah) ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(
                  title: const Text("Tandai sebagai Berita Unggulan"),
                  value: _isFeatured,
                  onChanged: (bool value) {
                    setState(() {
                      _isFeatured = value;
                    });
                  },
                ),
              ),
              
              // --- Tombol Simpan (INI BAGIAN YANG BERUBAH) ---
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    // 1. Jadikan 'async'
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        
                        // 2. Kirim data ke Django
                        // Endpoint "/create-flutter/" sesuai dengan yang kita buat di urls.py
                        final response = await request.postJson(
                          "$_appUrl/create-flutter/", 
                          jsonEncode({
                            "title": _title,
                            "content": _content,
                            "thumbnail": _thumbnail,
                            "category": _category,
                            "is_featured": _isFeatured,
                          }),
                        );
                        
                        // 3. Handle response dari Django
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                content: Text("News successfully saved!"),
                              ));
                            // 4. Kembali ke halaman utama (menu.dart)
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                          } else {
                            // Tampilkan error jika gagal
                            ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                content: Text("Something went wrong, please try again."),
                              ));
                          }
                        }
                        
                        // 5. Logika 'showDialog' yang lama sudah dihapus.
                      }
                    },
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.white),
                    ),
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