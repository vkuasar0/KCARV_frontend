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
      final csvData = const ListToCsvConverter().convert([widget.event.participants]);

      // Open file save dialog for user to pick location and name
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Participants CSV',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

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
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.event.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                  '${widget.event.date.substring(0, 10)} - ${widget.event.status}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              _buildParticipantsSection(),
              const SizedBox(height: 20),
              _buildLibrarySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Participants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(widget.event.participants.join('\n')),
        ),
        const SizedBox(height: 10),
        Row(
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: InkWell(
                        onTap: () => _launchURL(url),
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
    await launchUrl(uri, mode: LaunchMode.externalApplication);
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
            decoration:
                InputDecoration(hintText: 'Enter $title separated by commas'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSave();
              },
              child: const Text('Save'),
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
}
