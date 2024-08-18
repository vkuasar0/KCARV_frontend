import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kcarv_front/data/verticals.dart';
import 'package:kcarv_front/models/announcement.dart';
import 'package:kcarv_front/models/clubVertical.dart';
import 'package:http/http.dart' as http;

class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement({super.key});

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final _formkey = GlobalKey<FormState>();
  bool isSaving = false;
  var enteredTitle = '';
  var enteredDesc = '';
  Verticals? enteredVertical;

  void _saveItem() async {
    if (_formkey.currentState!.validate()) {
      try {
        _formkey.currentState!.save();
        setState(() {
          isSaving = true;
        });
        final verticalString = enteredVertical.toString().split('.').last;
        final url =
            Uri.https('kcarv-backend.onrender.com', '/api/announcements');
        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'title': enteredTitle,
              'content': enteredDesc,
              'vertical': verticalString,
            }));
        
        Navigator.of(context).pop(
          Announcement(
            id : response.body,
            title: enteredTitle,
            description: enteredDesc,
            vertical: verticals[enteredVertical]!,
          ),
        );
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save the announcement.')),
        );
      }

      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add an announcement"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Title")),
                validator: (value) {
                  if (value == null || value.length == 0)
                    return "Title cannot be empty";
                  return null;
                },
                onSaved: (value) {
                  enteredTitle = value!;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(label: Text("Description")),
                validator: (value) {
                  if (value == null || value.length == 0)
                    return "Description cannot be empty";
                  return null;
                },
                onSaved: (value) {
                  enteredDesc = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: Verticals.all,
                hint: const Text("Select vertical type"),
                items: [
                  for (final vertical in Verticals.values)
                    DropdownMenuItem(
                      value: vertical,
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            color: verticals[vertical]!.colorCode,
                          ),
                          const SizedBox(width: 10),
                          Text(verticals[vertical]!.verticalName)
                        ],
                      ),
                    )
                ],
                validator: (value) {
                  if (value == null)
                    return "Please select a valid vertical type";
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    enteredVertical = value;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: isSaving
                          ? null
                          : () {
                              _formkey.currentState!.reset();
                            },
                      child: const Text("Clear")),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: isSaving ? null : _saveItem,
                      child: (isSaving)
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(),
                            )
                          : const Text("Save")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
