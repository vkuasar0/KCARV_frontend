class BorrowRequest {
  final String id;
  final String itemId;
  final String status;
  final String itemName;
  final String userId;
  final String userName;

  BorrowRequest(
      {required this.id,
      required this.itemId,
      required this.status,
      required this.itemName,
      required this.userId,
      required this.userName});

  factory BorrowRequest.fromJson(Map<String, dynamic> json) {
    final item = json['item'];
    final user = json['user'];
    return BorrowRequest(
        id: json['id'].toString(),
        itemId: json['itemId'].toString(),
        status: json['status'],
        itemName: item['name'],
        userId: user['id'].toString(),
        userName: user['name']);
  }
}