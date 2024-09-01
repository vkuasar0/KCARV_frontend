class Event {
  final String id;
  final String title;
  final String date;
  final String status;
  List<String> participants;
  List<String> library;
  String? thumbnail;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.participants,
    required this.library,
    required this.thumbnail
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'],
      date: json['date'],
      status: json['status'],
      participants: List<String>.from(json['participants']),
      library: List<String>.from(json['library']),
      thumbnail: json['thumbnail']
    );
  }
}