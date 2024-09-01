import 'package:flutter/material.dart';

class EditableDataTable extends StatefulWidget {
  final List<List<String>> participants;

  const EditableDataTable({super.key, required this.participants});

  @override
  State<EditableDataTable> createState() => EditableDataTableState();
}

class EditableDataTableState extends State<EditableDataTable> {
  bool isEditable = false;
  List<List<String>> participants = []; // Initialize with an empty list
  List<List<TextEditingController>> controllers = []; // Store controllers

  @override
  void initState() {
    super.initState();
    participants = widget.participants; // Copy initial data
    // Initialize controllers
    controllers = participants.map((row) {
      return row.map((data) => TextEditingController(text: data)).toList();
    }).toList();
  }

  void toggleEditable() {
    setState(() {
      isEditable = !isEditable;
    });
  }

  void addRow() {
    setState(() {
      participants.add(['', '']); // Add an empty row 
      controllers.add([
        TextEditingController(text: ''),
        TextEditingController(text: ''),
      ]); // Add new controllers
    });
  }

  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    for (var row in controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            isEditable
                ? const Text('Editing mode')
                : ElevatedButton(
                    onPressed: toggleEditable, 
                    child: const Text('Edit')
                  ),
            ElevatedButton(
              onPressed: addRow, 
              child: const Text('Add Row')
            ),
            createTable(participants, this),
          ],
        ),
      ),
    );
  }

  Widget createTable(List<List<String>> data, EditableDataTableState state) {
    List<List<DataCell>> table = [];
    for (int i = 0; i < data.length; i++) {
      List<DataCell> row = [];
      for (int j = 0; j < 2; j++) {
        row.add(DataCell(
          EditableDataCell(
            isEditable: state.isEditable,
            data: data[i][j],
            controller: controllers[i][j],
            onChanged: (value) {
              setState(() {
                participants[i][j] = value; // Update participants directly with the new value
              });
            },
          ),
        ));
      }
      table.add(row);
    }
    return DataTable(
      columns: const [
        DataColumn(label: Text('USN')),
        DataColumn(label: Text('Student')),
      ],
      rows: table.map((row) => DataRow(cells: row)).toList(),
    );
  }
}

class EditableDataCell extends StatelessWidget {
  final bool isEditable;
  final String data;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const EditableDataCell({
    super.key,
    required this.isEditable,
    required this.data,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isEditable
        ? TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            ),
          )
        : Text(data);
  }
}
