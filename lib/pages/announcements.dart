import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kcarv_front/data/verticals.dart';
import 'package:kcarv_front/pages/new_announcement.dart';
import 'package:kcarv_front/models/announcement.dart';
import 'package:kcarv_front/pages/sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:kcarv_front/models/clubVertical.dart';

class Announcements extends StatefulWidget {
  const Announcements({super.key, required this.isadmin});

  final bool isadmin;

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  List<Announcement> announcements = [];
  bool isLoading = true;
  String? error;

  Verticals verticalFromString(String verticalString) {
    switch (verticalString.toLowerCase()) {
      case 'acting':
        return Verticals.acting;
      case 'script':
        return Verticals.script;
      case 'production_design':
        return Verticals.production_design;
      case 'technical':
        return Verticals.technical;
      case 'music':
        return Verticals.music;
      case 'media':
        return Verticals.media;
      case 'all':
        return Verticals.all;
      default:
        throw ArgumentError('Invalid vertical string: $verticalString');
    }
  }

  void _new_announcement(BuildContext context) async {
    final _newA =
        await Navigator.push(context, MaterialPageRoute(builder: (cntxt) {
      return const NewAnnouncement();
    }));
    if (_newA == null) {
      return;
    }
    setState(() {
      announcements.add(_newA);
    });
  }

  @override
  void initState() {
    super.initState();
    _load_announcement();
  }

  void _load_announcement() async {
    final url = Uri.https('kcarv-backend.onrender.com', '/api/announcements');
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          error = "Oops! Something went wrong, couldn't load announcements";
          isLoading = false;
        });
        return;
      }

      if (response.body.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final List<dynamic> res = json.decode(response.body);
      final List<Announcement> init_items = [];
      for (final items in res) {
        Verticals vert;
        if (items['vertical'] != null)
          vert = verticalFromString(items['vertical']);
        else
          vert = Verticals.all;
        if (items['title'] != null &&
            items['content'] != null &&
            items['id'] != null)
          init_items.add(Announcement(
              id: items['id'].toString(),
              title: items['title'],
              description: items['content'],
              vertical: verticals[vert]!));
      }

      setState(() {
        announcements = init_items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Check your internet connection";
        print(e);
        isLoading = false;
      });
    }
  }

  void _remove_announcement(Announcement an) async {
    setState(() {
      announcements.remove(an);
    });

    final url =
        Uri.https('kcarv-backend.onrender.com', '/api/announcements/${an.id}');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      print("not deleted so reverting back.....");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Something went wrong. Could not delete the announcement."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        announcements.add(an);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var content = const Center(
      child: Text("There are no Announcements"),
    );

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        centerTitle: true,
      ),
      drawer: Sidebar(isAdmin: widget.isadmin),
      body: announcements.isEmpty
          ? content
          : ListView.builder(
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  confirmDismiss: (direction) async {
                    final bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirm Deletion"),
                          content: const Text(
                              "Are you sure you want to delete this announcement?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                    return confirm ?? false;
                  },
                  key: ValueKey(announcements[index].id),
                  onDismissed: (direction) {
                    _remove_announcement(announcements[index]);
                    direction = DismissDirection.startToEnd;
                  },
                  child: Container(
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
                        announcements[index].title,
                        style: const TextStyle(fontSize: 16),
                      )),
                );
              },
              scrollDirection: Axis.vertical,
            ),
      floatingActionButton: Visibility(
        visible: widget.isadmin,
        child: FloatingActionButton(
            onPressed: () => isLoading ? () {} : _new_announcement(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.add)),
      ),
    );
  }
}
