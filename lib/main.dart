import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml2json/xml2json.dart';

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
  @override
  void initState() {
    super.initState();
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
        log(jsonData);
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
