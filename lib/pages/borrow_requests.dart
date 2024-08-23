import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcarv_front/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:kcarv_front/models/borrow_request.dart';

class BorrowRequestsPage extends StatefulWidget {
  const BorrowRequestsPage({super.key});

  @override
  State<BorrowRequestsPage> createState() => _BorrowRequestsPageState();
}

class _BorrowRequestsPageState extends State<BorrowRequestsPage> {
  List<BorrowRequest> borrowRequests = [];
  Widget indicator = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    fetchBorrowRequests();
  }

  Future<void> fetchBorrowRequests() async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/borrow');
    final response = await http.get(headers: {
      'authorization': Provider.of<AuthProvider>(context, listen: false).jwt!
    }, url);
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        borrowRequests =
            (data as List).map((item) => BorrowRequest.fromJson(item)).toList();
        indicator = const Text("No Borrow Requests");
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  Future<void> updateBorrowRequest(String id, String action) async {
    final url =
        Uri.parse('https://kcarv-backend.onrender.com/api/borrow/$action/$id');
    final response = await http.put(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrow Requests'),
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
                                updateBorrowRequest(request.id, 'approve');
                              },
                              child: const Text('Approve'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                updateBorrowRequest(request.id, 'reject');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Reject'),
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
