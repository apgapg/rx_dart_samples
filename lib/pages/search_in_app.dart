import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rx_dart_samples/widgets/no_items_found.dart';
import 'package:rx_dart_samples/widgets/search_text_field.dart';
import 'package:rx_dart_samples/widgets/stream_error_widget.dart';
import 'package:rx_dart_samples/widgets/stream_loading_widget.dart';
import 'package:rxdart/rxdart.dart';

class SearchInApp extends StatefulWidget {
  @override
  _SearchInAppState createState() => _SearchInAppState();
}

class _SearchInAppState extends State<SearchInApp> {
  final _todoSubject = BehaviorSubject<List<String>>();
  final _todoUrl = "https://jsonplaceholder.typicode.com/todos";

  final _controller = TextEditingController();

  StreamTransformer<List<String>, List<String>> get streamTransformer =>
      StreamTransformer<List<String>, List<String>>.fromHandlers(
          handleData: (list, sink) {
        if ((_controller.text ?? "").isNotEmpty) {
          var newList = list.where((item) {
            return item.toLowerCase().contains(_controller.text.toLowerCase());
          }).toList();
          return sink.add(newList);
        } else {
          return sink.add(list);
        }
      });

  @override
  void initState() {
    super.initState();
    _fetchTodos();
    _addTextChangeListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search: In App"),
      ),
      body: StreamBuilder<List>(
        stream: _getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SearchTextField(_controller),
                ),
                if (snapshot.data.isNotEmpty)
                  ...snapshot.data
                      .map((item) => ListTile(title: Text(item ?? "--")))
                else
                  NoItemsFound()
              ],
            );
          } else if (snapshot.hasError) {
            return StreamErrorWidget(snapshot.error);
          } else {
            return StreamLoadingWidget();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _todoSubject.close();
    super.dispose();
  }

  Future<void> _fetchTodos() async {
    try {
      final response = await http.get(_todoUrl);
      if (response.statusCode == 200) {
        final List list =
            jsonDecode(response.body).cast<Map<String, dynamic>>();
        final nameList = list.map((e) => e['title']?.toString()).toList();
        _todoSubject.add(nameList);
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _todoSubject.addError(e?.toString());
    }
  }

  void _addTextChangeListener() {
    _controller.addListener(() {
      _todoSubject.add(_todoSubject.value);
    });
  }

  Stream<List<String>> _getStream() {
    return _todoSubject.transform(streamTransformer);
  }
}
