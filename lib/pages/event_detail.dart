import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:kcarv_front/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late TextEditingController participantsController;
  late TextEditingController libraryController;

  @override
  void initState() {
    super.initState();
    participantsController =
        TextEditingController(text: widget.event.participants.join(', '));
    libraryController =
        TextEditingController(text: widget.event.library.join(', '));
  }

  Future<void> updateParticipants() async {
    final url = Uri.parse(
        'https://kcarv-backend.onrender.com/api/events/${widget.event.id}/participants');
    final response = await http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: json
            .encode({'participants': participantsController.text.split(', ')}));
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Participants updated successfully')),
      );
      setState(() {
        widget.event.participants = participantsController.text.split(', ');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  Future<void> updateLibrary() async {
    final url = Uri.parse(
        'https://kcarv-backend.onrender.com/api/events/${widget.event.id}/library');
    final response = await http.put(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'library': libraryController.text.split(', ')}).toString());
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Library updated successfully')),
      );
      setState(() {
        widget.event.library = libraryController.text.split(', ');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  Future<void> downloadParticipants() async {
    try {
      // Convert participants to CSV format
      final csvData =
          const ListToCsvConverter().convert([widget.event.participants]);

      // Open file save dialog for user to pick location and name
      final result = await FilePicker.platform.saveFile(
          fileName: "${widget.event.title}.csv",
          dialogTitle: 'Save Participants CSV',
          type: FileType.custom,
          allowedExtensions: ['csv'],
          lockParentWindow: true);

      if (result != null) {
        // User picked a file name and location
        final file = File(result);
        await file.writeAsString(csvData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV downloaded to ${file.path}')),
        );
      } else {
        // User canceled the save operation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download canceled')),
        );
      }
    } catch (e) {
      // Handle any errors during the file operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(widget.event.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: SizedBox(
                    height: 200.0,
                    width: double.infinity,
                    child: _buildImageThumbnail() // Replace with actual image
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 40, right: 40),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16,),
                        _buildLibrarySection(),
                        const SizedBox(height: 16.0),
                        _buildParticipantsSection(),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '${widget.event.date.substring(0, 10)} - ${widget.event.status}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 16,)
                      ],
                    ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildParticipantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const Text('Participants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(10),
          width: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(widget.event.participants.join('\n')),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showEditDialog(
                  'Participants', participantsController, updateParticipants),
              child: const Text('Edit'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: downloadParticipants,
              child: const Text('Download'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLibrarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Library',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.event.library
                .map((url) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: TextButton(
                        onPressed: () => _launchURL(url),
                        child: Text(url,
                            style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline)),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () =>
              _showEditDialog('Library', libraryController, updateLibrary),
          child: const Text('Edit'),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Couldn\'t find an app to to launch this link')));
    }
  }

  Widget _buildImageThumbnail() {
    String? thumbnail = widget.event.thumbnail;
    if (thumbnail != null) {
      return Image.network(thumbnail, fit: BoxFit.fill);
    } else {
      return const Center(child: Text('No Image for this event'));
    }
  }

  Future<void> _showEditDialog(String title, TextEditingController controller,
      VoidCallback onSave) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onSave();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
