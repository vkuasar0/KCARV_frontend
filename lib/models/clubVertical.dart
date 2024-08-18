import 'package:flutter/material.dart';

enum Verticals {
  acting,
  script,
  pd,
  technical
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