import 'package:flutter/material.dart';
import 'package:football_news_mobile/widgets/left_drawer.dart'; 

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

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Center(
                    child: Text(
                        'Form Tambah Berita',
                    ),
                ),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "URL Thumbnail",
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
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "URL Thumbnail tidak boleh kosong!";
                            }
                            if (!Uri.parse(value).isAbsolute) {
                                return "URL tidak valid!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          value: _category,
                          hint: const Text("Pilih Kategori"),
                          items: _categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _category = newValue!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Kategori tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CheckboxListTile(
                          title: const Text("Berita Unggulan (Featured)"),
                          value: _isFeatured,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _isFeatured = newValue!;
                            });
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.indigo),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    SnackBar(content: Text(
                                      "Berita '$_title' berhasil disimpan!"
                                    )),
                                  );
                                _formKey.currentState!.reset();
                                setState(() {
                                  _isFeatured = false;
                                  _category = "update";
                                });
                              }
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ),
            ),
        );
    }
}