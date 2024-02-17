import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xml2json/xml2json.dart';
import 'package:xml_restapi_flutter/news_model.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  NewsModel? model;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const String apiUrl =
        'https://timesofindia.indiatimes.com/rssfeedstopstories.cms';

    try {
      final Response response = await get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Successfully fetched data, now parse XML to JSON
        final Xml2Json xml2json = Xml2Json();
        xml2json.parse(response.body);

        // Get the JSON data
        final String jsonData = xml2json.toGData();

        // Use the jsonData as per your requirement
        // log(jsonData);

        setState(() {
          model = NewsModel.fromJson(jsonDecode(jsonData));
        });

        debugPrint("Done");
      } else {
        // Handle error
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      debugPrint('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: InkWell(
                onTap: () async {
                  fetchData();
                },
                child: const Text(
                  'Hello World',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            if (model != null) ...[
              Text(
                model!.rss.channel.title.t,
              ),
              FutureBuilder(
                future: getImage(model!.rss.channel.image.url.t),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return NewsPage(mewItem: model!.rss.channel.item[1]);
                      },
                    ));
                  },
                  child: const Text("Navigate Now"))
            ]
          ],
        ),
      ),
    );
  }
}

/// Fetch imageData in Uint8List
Future<Uint8List> getImage(String url) async =>
    (await get(Uri.parse(url))).bodyBytes;

class NewsPage extends StatefulWidget {
  const NewsPage({super.key, required this.mewItem});
  final NewsItem mewItem;

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    NewsItem mewItem = widget.mewItem;

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              mewItem.title.t,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: FutureBuilder(
                future: getImage(mewItem.enclosure.url),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return Image.memory(
                        snapshot.data!,
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
            Text(
              mewItem.description.cdata,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            ElevatedButton(
              onPressed: () async {
                var url = mewItem.link.t;
                if (await canLaunchUrlString(url)) {
                  launchUrlString(url);
                }
              },
              child: const Text("Read Full Article"),
            )
          ],
        ),
      )),
    );
  }
}
