import 'package:flutter/material.dart';
import 'package:ler_depois/models/item_model.dart';
import 'package:ler_depois/database/database_helper.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel> _items = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Lista de itens filtrados (se necessário, pode ser mantida ou removida dependendo da lógica de UI)
  List<ItemModel> _filteredItems = [];

  ItemProvider() {
    _loadItems();
  }

  Future<void> _loadItems() async {
    _items = await _dbHelper.getAllItems();
    _filteredItems = _items; // Inicializa a lista filtrada com todos os itens
    notifyListeners();
  }

  List<ItemModel> get items => _items;
  List<ItemModel> get filteredItems => _filteredItems; // Getter para a lista filtrada

  Future<void> addItem(ItemModel item) async {
    // O ID será gerado pelo banco de dados, então não precisamos passar aqui
    // O createdAt também será gerado pelo DatabaseHelper
    await _dbHelper.insertItem(item);
    await _loadItems(); // Recarrega os itens do banco para ter a lista atualizada com IDs
  }

  Future<void> updateItem(ItemModel item) async {
    if (item.id == null) {
      // Idealmente, isso não deveria acontecer se o item veio do banco
      print("Erro: Tentativa de atualizar item sem ID.");
      return;
    }
    await _dbHelper.updateItem(item);
    await _loadItems(); // Recarrega para refletir a atualização
  }

  Future<void> deleteItem(int id) async {
    await _dbHelper.deleteItem(id);
    await _loadItems(); // Recarrega para refletir a exclusão
  }

  // Método para atualizar a lista filtrada (se a lógica de filtro for mantida na UI)
  void updateFilteredItems(String query) {
    if (query.isEmpty) {
      _filteredItems = _items;
    } else {
      _filteredItems = _items
          .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

