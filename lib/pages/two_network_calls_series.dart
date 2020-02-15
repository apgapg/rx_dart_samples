import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rx_dart_samples/widgets/stream_error_widget.dart';
import 'package:rx_dart_samples/widgets/stream_loading_widget.dart';
import 'package:rxdart/rxdart.dart';

class TwoNetworkCallsSeries extends StatefulWidget {
  @override
  _TwoNetworkCallsSeriesState createState() => _TwoNetworkCallsSeriesState();
}

class _TwoNetworkCallsSeriesState extends State<TwoNetworkCallsSeries> {
  final _userSubject = BehaviorSubject<String>();
  final _todoSubject = BehaviorSubject<List<String>>();

  final _userUrl = "https://jsonplaceholder.typicode.com/users/1";
  final _todoUrl = "https://jsonplaceholder.typicode.com/todos";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Two Network Calls- Series"),
      ),
      body: StreamBuilder<List>(
          stream: _getStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      snapshot.data[0] ?? "NA",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...snapshot.data[1]
                      .map((item) => ListTile(title: Text(item ?? "--")))
                ],
              );
            } else if (snapshot.hasError) {
              return StreamErrorWidget(snapshot.error);
            } else {
              return StreamLoadingWidget();
            }
          }),
    );
  }

  @override
  void dispose() {
    _userSubject.close();
    _todoSubject.close();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await _fetchUser(); //Let first future to complete
    await _fetchTodos(); //Then call second future
  }

  Future<void> _fetchUser() async {
    try {
      final response = await http.get(_userUrl);
      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        _userSubject.add(user['name']);
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _userSubject.addError(e?.toString());
    }
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

  Stream<List> _getStream() {
    return Rx.combineLatest(
      [_userSubject, _todoSubject],
      (values) => [values[0], values[1]],
    ).asBroadcastStream();
  }
}
