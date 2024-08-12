import 'package:flutter/material.dart';

class Announcements extends StatelessWidget {
  const Announcements({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> announcements = [
      "announcement 1", 
      "announcement 2",
      "announcement 3",
      "announcement 4", 
      "announcement 5",
      "announcement 6",
      "announcement 7", 
      "announcement 8",
      "announcement 9",
      "announcement 10"
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.menu)),
        title: const Text("Announcements"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              announcements[index],
              style: const TextStyle(fontSize: 16),
            )
          );
        },
        scrollDirection: Axis.vertical,
      ),
    );
  }
}