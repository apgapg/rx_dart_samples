import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rx_dart_samples/widgets/stream_error_widget.dart';
import 'package:rx_dart_samples/widgets/stream_loading_widget.dart';
import 'package:rxdart/rxdart.dart';

class OneNetworkCall extends StatefulWidget {
  @override
  _OneNetworkCallState createState() => _OneNetworkCallState();
}

class _OneNetworkCallState extends State<OneNetworkCall> {
  final _dataSubject = BehaviorSubject<List<String>>();

  final _url = "https://jsonplaceholder.typicode.com/users";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("One Network Call"),
      ),
      body: StreamBuilder<List<String>>(
          stream: _dataSubject,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return ListView(
                children: <Widget>[
                  ...snapshot.data
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
    _dataSubject.close();
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      _dataSubject.add(null);
      final response = await http.get(_url);
      if (response.statusCode == 200) {
        final List list =
            jsonDecode(response.body).cast<Map<String, dynamic>>();
        final nameList = list.map((e) => e['name']?.toString()).toList();
        _dataSubject.add(nameList);
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _dataSubject.addError(e?.toString());
    }
  }
}
