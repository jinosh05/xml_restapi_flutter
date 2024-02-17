import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Exception: $e');
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
              )
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
