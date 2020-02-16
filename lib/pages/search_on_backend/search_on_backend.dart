import 'package:flutter/material.dart';
import 'package:rx_dart_samples/widgets/no_items_found.dart';
import 'package:rx_dart_samples/widgets/stream_error_widget.dart';
import 'package:rx_dart_samples/widgets/stream_loading_widget.dart';

import 'bloc.dart';

class SearchOnBackend extends StatefulWidget {
  @override
  _SearchOnBackendState createState() => _SearchOnBackendState();
}

class _SearchOnBackendState extends State<SearchOnBackend> {
  final _bloc = Bloc();

  @override
  void initState() {
    super.initState();
    //_bloc.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search: On Backend"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _bloc.textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Search with post id...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List>(
              stream: _bloc.dataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return ListView(
                    children: <Widget>[
                      if (snapshot.data.isNotEmpty)
                        ...snapshot.data.map(
                          (item) => ListTile(
                            title: Text(item ?? "--"),
                          ),
                        )
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
