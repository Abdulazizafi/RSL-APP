import 'package:flutter/material.dart';
//import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class NewsItem {
  final String title;
  final String imageUrl;
  final String url;
  final String publicationDate;
  final String NameP;
  // New field for the publication date

  NewsItem(
      {required this.title,
      required this.imageUrl,
      required this.url,
      required this.publicationDate,
      required this.NameP
      // Initialize the new field
      });
}

void _launchURL(String url) async {
  // Ensure that the URL is correctly formatted
  if (url.isNotEmpty) {
    await launch(url);
  } else {
    throw 'Invalid URL: $url';
  }
}

class NewsWidget extends StatelessWidget {
  final NewsItem item;

  const NewsWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(item.url),
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10), bottom: Radius.circular(10)),
              child: Image.network(item.imageUrl,
                  width: double.infinity, height: 200, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(item.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
              child: Text('${item.NameP} - ${item.publicationDate}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewContainer extends StatelessWidget {
  final String url;

  const WebViewContainer(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
            'Implement WebView to navigate to $url'), // Placeholder for WebView implementation
      ),
    );
  }
}
