import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Photo Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatPhotoGallery(),
    );
  }
}

class CatPhotoGallery extends StatefulWidget {
  @override
  _CatPhotoGalleryState createState() => _CatPhotoGalleryState();
}

class _CatPhotoGalleryState extends State<CatPhotoGallery> {
  List<String> catImageUrls = [];

  Future<void> fetchCatPhotos() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search?limit=5'),

        headers: {'Content-Type': 'application/json', 'x-api-key': 'live_YEGmteSZB1ylRjnRbolzwijadQ0bGFYPpzsbQv9wQT59B2SkoFUhi7DqyRL0bPqB'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<String> urls = data.map((cat) => cat['url'] as String).toList();
        setState(() {
          catImageUrls.addAll(urls);
        });
      } else {
        _showError('Failed to load photos');
      }
    } catch (error) {
      _showError('An error occurred: $error');
    }
  }

  void _showError(String message) {
    void _showErrorDialog(String message) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
             onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
}

  }

  @override
  void initState() {
    super.initState();
    fetchCatPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Photo Gallery'),
      ),
      body: ListView.builder(
        itemCount: catImageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.network(catImageUrls[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchCatPhotos();
        },
        tooltip: 'More Photos',
        child: Icon(Icons.add),
      ),
    );
  }
}