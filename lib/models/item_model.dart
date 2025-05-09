import 'package:flutter/material.dart'; // Mantido para IconData

class ItemModel {
  final int? id; // Adicionado para o ID do banco de dados
  final String title;
  String link;
  final String category;
  final IconData icon;
  final IconData editIcon; // Geralmente fixo, mas mantido no modelo
  final IconData deleteIcon; // Geralmente fixo, mas mantido no modelo
  final DateTime? createdAt; // Adicionado para a data de criação

  ItemModel({
    this.id,
    required this.title,
    required this.link,
    required this.category,
    required this.icon,
    this.editIcon = Icons.edit, // Valor padrão se não vier do DB
    this.deleteIcon = Icons.delete, // Valor padrão se não vier do DB
    this.createdAt,
  });

  // Método para criar uma cópia do modelo com possíveis alterações (útil para updates)
  ItemModel copyWith({
    int? id,
    String? title,
    String? link,
    String? category,
    IconData? icon,
    IconData? editIcon,
    IconData? deleteIcon,
    DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      editIcon: editIcon ?? this.editIcon,
      deleteIcon: deleteIcon ?? this.deleteIcon,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
