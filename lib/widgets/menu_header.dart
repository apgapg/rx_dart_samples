import 'package:flutter/material.dart';

class MenuHeader extends StatelessWidget {
  final String title;

  MenuHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4 ,
        horizontal: 16,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.overline.copyWith(
              fontSize: 12,
              color: Colors.blue,
            ),
      ),
    );
  }
}
