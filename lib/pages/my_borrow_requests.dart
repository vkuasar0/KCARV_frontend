import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcarv_front/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:kcarv_front/models/borrow_request.dart';

class MyBorrowRequestsPage extends StatefulWidget {
  const MyBorrowRequestsPage({super.key});

  @override
  State<MyBorrowRequestsPage> createState() => _MyBorrowRequestsPageState();
}

class _MyBorrowRequestsPageState extends State<MyBorrowRequestsPage> {
  List<BorrowRequest> borrowRequests = [];
  Widget indicator = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    fetchBorrowRequests();
  }

  Future<void> fetchBorrowRequests() async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/borrow/user');
    final token = Provider.of<AuthProvider>(context, listen: false).jwt;
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'authorization': token!,
      },
    );

    if (response.statusCode == 200) {
      indicator = const Text("No Borrow Requests");
      setState(() {
        borrowRequests = (json.decode(response.body) as List)
            .map((request) => BorrowRequest.fromJson(request))
            .toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load borrow requests')),
      );
    }
  }

  Future<void> _okAndDelete(String id) async {
    final url =
        Uri.parse('https://kcarv-backend.onrender.com/api/borrow/$id');
    final response = await http.delete(
        headers: {'authorization': Provider.of<AuthProvider>(context, listen: false).jwt!},
        url);
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      await fetchBorrowRequests();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Borrow request updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  Future<void> _returnItem(String id) async {
    final url =
        Uri.parse('https://kcarv-backend.onrender.com/api/borrow/return/$id');
    final response = await http.put(
        headers: {'authorization': Provider.of<AuthProvider>(context, listen: false).jwt!},
        url);
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      await fetchBorrowRequests();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item returned successfully')),
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
        title: const Text('My Borrow Requests'),
      ),
      body: borrowRequests.isEmpty
          ? Center(child: indicator)
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: borrowRequests.length,
              itemBuilder: (context, index) {
                final request = borrowRequests[index];
                return Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.itemName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text('Status: ${request.status}'),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _okAndDelete(request.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('OK'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _returnItem(request.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('Return'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
