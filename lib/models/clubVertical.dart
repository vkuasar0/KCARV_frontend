import 'package:flutter/material.dart';

enum Verticals {
  acting,
  script,
  production_design,
  technical,
  music,
  media,
  all
}

class clubVertical extends StatelessWidget {
  const clubVertical(this.verticalName, this.colorCode);

  final String verticalName;
  final Color colorCode;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}