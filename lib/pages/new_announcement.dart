import 'package:flutter/material.dart';
import 'package:kcarv_front/data/verticals.dart';
import 'package:kcarv_front/models/announcement.dart';
import 'package:kcarv_front/models/clubVertical.dart';

class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement({super.key});

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final _formkey = GlobalKey<FormState>();
  bool isSaving = false;
  var enteredText = '';
  clubVertical? enteredVertical;

  void _saveItem () async {
    if(_formkey.currentState!.validate()){
      _formkey.currentState!.save();
      setState(() {
        isSaving = true;
      });
      Navigator.of(context).pop(
        Announcement(text: enteredText, vertical: enteredVertical!)
      );
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
                decoration: const InputDecoration(
                  label: Text("Text")
                ),
                validator: (value){
                  if(value==null || value.length==0) return "Text cannot be empty";
                  return null;
                },
                onSaved: (value){
                  enteredText = value!;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                hint: const Text("Select vertical type"),
                items: [
                  for (final vertical in verticals.entries)
                    DropdownMenuItem(
                      value: vertical.value,
                      child: Row(
                        children: [
                          Container(
                                  width: 16,
                                  height: 16,
                                  color: vertical.value.colorCode,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            vertical.value.verticalName
                          )
                        ],
                      ),
                    )
                ],
                validator: (value){
                  if(value==null) return "Please select a valid vertical type";
                  return null;
                },
                onChanged: (value){
                  setState(() {
                    enteredVertical = value;
                  });
                },
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  TextButton(
                    onPressed: isSaving? null:(){
                      _formkey.currentState!.reset();
                    }, 
                    child: const Text("Clear")
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: isSaving? null : _saveItem,
                    child: (isSaving)? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(),
                    ) : const Text("Save")
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}