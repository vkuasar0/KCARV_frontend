import 'package:flutter/material.dart';
import 'package:kcarv_front/data/verticals.dart';

class NewAnnouncement extends StatefulWidget {
  const NewAnnouncement({super.key});

  @override
  State<NewAnnouncement> createState() => _NewAnnouncementState();
}

class _NewAnnouncementState extends State<NewAnnouncement> {
  final _formkey = GlobalKey<FormState>();

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
                onChanged: (value){

                },
              ),
              const SizedBox(height: 8,),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: (){},
                    child: const Text("Save"),
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: (){
                      _formkey.currentState!.reset();
                    }, 
                    child: const Text("Clear")
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}