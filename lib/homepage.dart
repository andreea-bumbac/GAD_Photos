import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final List<String> _photos = <String>[];

  @override
  void initState() {
    super.initState();
    _showPhotos();
  }

  Future<void> _showPhotos() async {
    const String accessKey = 'rJvUXdjTBBWxuVCk6J04ir6Qg36Cf165Ai-85cJ8ugo';
    const String query = 'bunny';
    const String count = '200';
    const String page = '5';

    final Response response = await get(
        Uri.parse(
            'https://api.unsplash.com/search/photos?query=$query&client_id=$accessKey&per_page=$count&page=$page'
        )
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> results = data['results'] as List<dynamic>;
      for (final dynamic element in results) {
        final Map<String, dynamic> currentResult = element as Map<String, dynamic>;
        final Map<String, dynamic> uriResult = currentResult['urls'] as Map<String, dynamic>;
        _photos.add(uriResult['regular'] as String);
      }
      setState(() {
        // update list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bunny photos'),
      ),
      body: _photos.isNotEmpty
          ? GridView.builder(
          itemCount: _photos.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5
          ),
          itemBuilder: (BuildContext context, int index) {
            return GridTile(
                child: Image.network(_photos[index],
                    fit: BoxFit.cover
                )
            );
          }
      )
          : const Center(
        child: CircularProgressIndicator(
            semanticsLabel: 'Loading photos...'
        ),
      ),
    );
  }
}