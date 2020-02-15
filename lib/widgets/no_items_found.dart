import 'package:flutter/material.dart';

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        "No Items Found",
        textAlign: TextAlign.center,
      ),
    );
  }
}
