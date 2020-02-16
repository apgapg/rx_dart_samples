import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class Bloc {
  Bloc() {
    _addTextChangeListener();
  }

  final _url = "https://jsonplaceholder.typicode.com/comments";
  final _textSubject = BehaviorSubject<String>.seeded("");

  final _controller = TextEditingController();

  Stream<List> get dataStream {
    return _textSubject
        .distinct()
        .debounceTime(
          const Duration(
            milliseconds: 250,
          ),
        )
        .switchMap<List<String>>(
          // ignore: unnecessary_lambdas
          (String value) => _fetchTodos(value),
        );
  }

  TextEditingController get textController => _controller;

  Stream<List<String>> _fetchTodos(String value) async* {
    try {
      yield null; //To show loader while ongoing request
      final url = (value != null && value.isNotEmpty) ? "$_url?postId=$value" : _url;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final list = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
        final nameList = list.map((e) => "Post Id: ${e['postId']}\n${e['name']}").toList();
        yield nameList;
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  void _addTextChangeListener() {
    _controller.addListener(() {
      _textSubject.add(_controller.text);
    });
  }

  void dispose() {
    _textSubject.close();
  }
}
