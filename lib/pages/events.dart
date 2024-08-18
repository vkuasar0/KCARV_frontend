import 'package:flutter/material.dart';
import 'package:kcarv_front/pages/sidebar.dart';

class Events extends StatelessWidget {
  const Events({super.key, required this.isadmin});

  final bool isadmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      drawer: Sidebar(isAdmin: isadmin),
      body: Center(
        child: Text("This is the events page"),
      ),
    );
  }
}