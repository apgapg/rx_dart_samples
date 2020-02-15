import 'package:flutter/material.dart';

class StreamErrorWidget extends StatelessWidget {
  final dynamic error;

  StreamErrorWidget(this.error);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error?.toString() ?? "Some Error Occured"),
    );
  }
}
