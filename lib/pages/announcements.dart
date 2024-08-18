import 'package:flutter/material.dart';
import 'package:kcarv_front/data/verticals.dart';
import 'package:kcarv_front/models/clubVertical.dart';
import 'package:kcarv_front/pages/new_announcement.dart';
import 'package:kcarv_front/models/announcement.dart';
import 'package:kcarv_front/pages/sidebar.dart';


class Announcements extends StatefulWidget {
  const Announcements({super.key, required this.isadmin});

  final bool isadmin;

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {

    final List<Announcement> announcements = [
      Announcement(text: "This is a dummy announcement", vertical: verticals[Verticals.acting]!)
    ];

    return Scaffold(
      appBar: AppBar(
        // leading: Builder(builder: (BuildContext context){
        //   return IconButton(
        //   onPressed: () => Scaffold.of(context).openDrawer(), 
        //   icon: const Icon(Icons.menu)
        //   );
        // }),
        title: const Text("Announcements"),
        centerTitle: true,
      ),
      drawer: Sidebar(isAdmin: widget.isadmin),
      body: announcements.isEmpty? const Center(child: Text("No Announcements yet"),) : ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index){
          return Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: announcements[index].vertical.colorCode,
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
              announcements[index].text,
              style: const TextStyle(fontSize: 16),
            )
          );
        },
        scrollDirection: Axis.vertical,
      ),
      floatingActionButton: Visibility(
        visible: widget.isadmin,
        child: FloatingActionButton(
          onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context){
            return NewAnnouncement();
          })),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          child: const Icon(Icons.add)
        ),
      ),
    );
  }
}