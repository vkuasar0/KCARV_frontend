import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcarv_front/models/event.dart';
import 'package:kcarv_front/pages/event_detail.dart';
import 'package:kcarv_front/pages/sidebar.dart';
import 'package:kcarv_front/utils/dateFormatter.dart';
import 'package:image_picker/image_picker.dart';

class EventsPage extends StatefulWidget {
  final bool isAdmin;

  const EventsPage({super.key, required this.isAdmin});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];
  bool isLoading = true;
  File? _image;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/events');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        events = (json.decode(response.body) as List)
            .map((event) => Event.fromJson(event))
            .toList();
        isLoading = false;
      });
    } else {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  Future<void> createEvent(String title, String date) async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/events');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'date': date,}),
    );

    if (response.statusCode == 201) {
      final eventId = await json.decode(response.body)['id'];
      final turl = Uri.parse('https://kcarv-backend.onrender.com/api/events/$eventId/thumbnail');
      final request = http.MultipartRequest('POST', turl);
      request.files.add(await http.MultipartFile.fromPath('thumbnail', _image!.path));
      final tresponse = await request.send();
      if(tresponse.statusCode==200){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully')),
        );
        fetchEvents();
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add thumbnail"))
        );
      } // Refresh the events list after creation
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create event')),
      );
    }
    setState(() {
      _image = null;
    });
  }

  Future<void> _pickImage () async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? _pickImage = await imagePicker.pickImage(source: ImageSource.gallery);


    if(_pickImage!=null){
      setState(() {
        _image = File(_pickImage.path);
      });
    }

  }

  void _showCreateEventDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Event Title'),
              ),
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(labelText: 'Event Date (yyyy-mm-dd)'),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 10,),
              _image != null ? 
              Image.file(
                _image!,
                height: 30,
                width: 30,
              ):
              Text("No thumbnail added"),
              ElevatedButton(onPressed: _pickImage, child: Text("Add a thumbnail"))
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final date = dateController.text;
                if (title.isNotEmpty && date.isNotEmpty && _image!=null) {
                  createEvent(title, date);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                }
              },
              child: const Text('Create'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget eventCard(Event event) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(event: event),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        event.thumbnail!), // Thumbnail for the event
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatter(event), // Display the formatted date
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(event.status), // Display the event status
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      drawer: Sidebar(isAdmin: widget.isAdmin),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns in the grid
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio:
                    3 / 4, // Adjust this ratio based on your image size
              ),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return eventCard(event); // Use the eventCard widget
              },
            ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: _showCreateEventDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
