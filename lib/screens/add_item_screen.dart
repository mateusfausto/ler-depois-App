import 'package:flutter/material.dart';
import 'package:ler_depois/models/item_model.dart';
//import 'package:ler_depois/repositories/item_repository.dart';
import 'package:ler_depois/services/item_provider.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _linkController = TextEditingController();
  final _titleController = TextEditingController(); // Adiciona o controller para o título
  String? _selectedCategory;

  @override
  void dispose() {
    _linkController.dispose();
    _titleController.dispose(); // Descarte o controller do título
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A9D1F),
        title: const Text(
              'Adicionar Item',
              style: TextStyle(
                      color: Color(0xFFfcfcfc),
                      fontWeight: FontWeight.bold,
        ),
      ),
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController, // Adiciona o campo de título
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Link',
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o link';
                  }
                   if (!Uri.tryParse(value)!.hasScheme) {
                    return 'Formato de link inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Categoria'),
                items: ['Notícias', 'Compras']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(                
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final item = ItemModel(
                      title: _titleController.text, // Utiliza o valor do título
                      link: _linkController.text,
                      category: _selectedCategory!,
                      icon: _selectedCategory == 'Notícias'
                          ? Icons.newspaper
                          : Icons.shopping_cart,
                      editIcon: Icons.edit,
                      deleteIcon: Icons.delete,
                    );
                    Provider.of<ItemProvider>(context, listen: false).addItem(item);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}