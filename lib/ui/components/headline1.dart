import 'package:flutter/material.dart';

class HeadLine1 extends StatelessWidget {
  final String text;

  const HeadLine1({
    Key key,
    this.text = "HeadLine 1",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
