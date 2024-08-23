import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcarv_front/pages/sidebar.dart';
import 'package:kcarv_front/pages/borrow_requests.dart';
import 'package:kcarv_front/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:kcarv_front/pages/my_borrow_requests.dart';

class PDItem {
  final String id;
  final String name;
  final String description;

  PDItem({required this.id, required this.name, required this.description});

  factory PDItem.fromJson(Map<String, dynamic> json) {
    return PDItem(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
    );
  }
}

class PDInventoryPage extends StatefulWidget {
  final bool isAdmin;
  const PDInventoryPage({super.key, required this.isAdmin});

  @override
  State<PDInventoryPage> createState() => _PDInventoryPageState();
}

class _PDInventoryPageState extends State<PDInventoryPage> {
  List<PDItem> pdItems = [];
  bool isAddingItem = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Widget indicator = const CircularProgressIndicator();
  PDItem? selectedItem;

  @override
  void initState() {
    super.initState();
    fetchPDItems();
  }

  Future<void> fetchPDItems() async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/pd-items');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        pdItems = (json.decode(response.body) as List)
            .map((item) => PDItem.fromJson(item))
            .toList();
        indicator = const Text("No PD Items");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load items')),
      );
    }
  }

  Future<void> addPDItem(String name, String description) async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/pd-items');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'description': description,
      }),
    );

    if (response.statusCode == 201) {
      nameController.clear();
      descriptionController.clear();
      await fetchPDItems();

      setState(() {
        isAddingItem = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add item')),
      );
    }
  }

  Future<void> editPDItem(PDItem item) async {
    final url =
        Uri.parse('https://kcarv-backend.onrender.com/api/pd-items/${item.id}');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': item.name,
        'description': item.description,
      }),
    );

    if (response.statusCode == 200) {
      await fetchPDItems();
      setState(() {
        selectedItem = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item edited successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to edit item')),
      );
    }
  }

  Future<void> deletePDItem(String id) async {
    final url =
        Uri.parse('https://kcarv-backend.onrender.com/api/pd-items/$id');
    final response = await http.delete(url);

    if (response.statusCode == 204) {
      await fetchPDItems();
      setState(() {
        selectedItem = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete item')),
      );
    }
  }

  Future<void> borrowPDItem(String id) async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/borrow');
    final token = Provider.of<AuthProvider>(context, listen: false).jwt;
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': token!
      },
      body: json.encode({'itemId': id}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrow request submitted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PD Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyBorrowRequestsPage(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Sidebar(isAdmin: widget.isAdmin),
      body: Stack(
        children: [
          isAddingItem ? _buildAddItemForm() : _buildGridView(),
          if (selectedItem != null) _buildHoveringWidget(selectedItem!),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  isAddingItem = !isAddingItem;
                });
              },
              child: Icon(isAddingItem ? Icons.close : Icons.add),
            )
          : null,
      bottomNavigationBar: widget.isAdmin
          ? BottomAppBar(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BorrowRequestsPage(),
                    ),
                  );
                },
                child: const Text('Borrow Requests'),
              ),
            )
          : null,
    );
  }

  Widget _buildGridView() {
    return pdItems.isEmpty
        ? Center(child: indicator)
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: pdItems.length,
            itemBuilder: (context, index) {
              final item = pdItems[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = item;
                  });
                },
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text(item.description),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildAddItemForm() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                addPDItem(nameController.text, descriptionController.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill out all fields')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _buildHoveringWidget(PDItem item) {
    List<Widget> hoveringList = [
      Text(
        item.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 10),
      Text(item.description),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          borrowPDItem(item.id);
        },
        child: const Text('Borrow'),
      ),
    ];

    if (widget.isAdmin) {
      hoveringList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                nameController.text = item.name;
                descriptionController.text = item.description;
                setState(() {
                  isAddingItem = true;
                  selectedItem = null;
                });
              },
              child: const Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () {
                deletePDItem(item.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
    }

    return Positioned(
      top: 100,
      left: 50,
      right: 50,
      child: Material(
        elevation: 50,
        borderRadius: BorderRadius.circular(10),
        child: TapRegion(
          onTapOutside: (event) {
            setState(() {
              selectedItem = null;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: hoveringList,
            ),
          ),
        ),
      ),
    );
  }
}
