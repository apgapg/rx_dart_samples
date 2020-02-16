import 'package:flutter/material.dart';
import 'package:rx_dart_samples/pages/one_network_call.dart';
import 'package:rx_dart_samples/pages/one_network_call_with_refresh.dart';
import 'package:rx_dart_samples/pages/search_in_app.dart';
import 'package:rx_dart_samples/pages/two_network_calls_parallel.dart';
import 'package:rx_dart_samples/pages/two_network_calls_series.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RxDart Samples"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text(
                "One Network Call",
              ),
              subtitle: const Text(
                "Behavior Subject",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OneNetworkCall(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                "One Network Call with Refresh",
              ),
              subtitle: const Text(
                "Behavior Subject",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OneNetworkCallWithRefresh(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                "Two Network Calls- Series",
              ),
              subtitle: const Text(
                "Behavior Subject, Rx.combineLatest",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TwoNetworkCallsSeries(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                "Two Network Calls- Parallel",
              ),
              subtitle: const Text(
                "Behavior Subject, Rx.combineLatest",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TwoNetworkCallsParallel(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                "Search: In App",
              ),
              subtitle: const Text(
                "Behavior Subject, StreamTransformers",
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchInApp(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
