import 'package:flutter/material.dart';
import 'package:ler_depois/models/item_model.dart';
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
  final _titleController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _linkController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      // O ID e createdAt são gerenciados pelo banco de dados e DatabaseHelper
      final item = ItemModel(
        title: _titleController.text,
        link: _linkController.text,
        category: _selectedCategory!,
        icon: _selectedCategory == 'Notícias'
            ? Icons.newspaper
            : Icons.shopping_cart,
        // editIcon e deleteIcon podem ter valores padrão no modelo ou serem definidos aqui
        editIcon: Icons.edit,
        deleteIcon: Icons.delete,
      );
      // A chamada addItem agora é assíncrona
      await Provider.of<ItemProvider>(context, listen: false).addItem(item);
      
      // Verifica se o widget ainda está montado antes de chamar Navigator.pop
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A9D1F),
        title: const Text(
          'Adicionar Item',
          style: TextStyle(
            color: Color(0xFFfcfcfc),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Para o ícone de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Para o botão ocupar a largura
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o link';
                  }
                  // Validação de URL simples, pode ser melhorada
                  if (!Uri.tryParse(value)!.isAbsolute) {
                    return 'Formato de link inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text('Categoria'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
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
                // onPressed agora chama a função assíncrona _saveItem
                onPressed: _saveItem, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A9D1F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24), // Padding aumentado
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

