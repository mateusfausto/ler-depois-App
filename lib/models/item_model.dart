import 'package:flutter/widgets.dart';

class ItemModel {
  final String title;
  String link;
  final String category;
  final IconData icon;
  final IconData editIcon;
  final IconData deleteIcon;

  ItemModel({
    required this.title,
    required this.link,
    required this.category,
    required this.icon,
    required this.editIcon,
    required this.deleteIcon,
  });
}