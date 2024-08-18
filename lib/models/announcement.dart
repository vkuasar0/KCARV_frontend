import 'package:kcarv_front/models/clubVertical.dart';

class Announcement {
  const Announcement({required this.id, required this.title, required this.description,  required this.vertical});

  final String id;
  final String title;
  final String description;
  final clubVertical vertical;

}