import 'package:flutter/material.dart';
import 'package:kcarv_front/pages/sidebar.dart';

class Inventory extends StatelessWidget {
  const Inventory({super.key, required this.isadmin});

  final bool isadmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory"),
      ),
      drawer: Sidebar(isAdmin: isadmin),
      body: Center(
        child: Text("This is the inventory page"),
      ),
    );
  }
}