import 'package:flutter/material.dart';
import 'package:ler_depois/models/item_model.dart';
import 'package:ler_depois/screens/add_item_screen.dart';
import 'package:ler_depois/services/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  ItemModel? _editingItem;
  String? _currentLink;

  // ScrollControllers para cada Tab
  final ScrollController _newsScrollController = ScrollController();
  final ScrollController _shoppingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Não é mais necessário chamar _updateItems aqui se o ItemProvider carrega no construtor
    // Apenas adicionamos o listener para o search controller
    _searchController.addListener(() {
      Provider.of<ItemProvider>(context, listen: false)
          .updateFilteredItems(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _newsScrollController.dispose();
    _shoppingScrollController.dispose();
    super.dispose();
  }

  Widget _buildItemList(
      List<ItemModel> items, ScrollController scrollController) {
    if (items.isEmpty) {
      return const Center(child: Text("Nenhum item para exibir."));
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            onTap: () async {
              if (mounted) {
                if (item.link.isNotEmpty &&
                    await canLaunchUrl(Uri.parse(item.link))) {
                  await launchUrl(Uri.parse(item.link));
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Link inválido ou não pode ser aberto: ${item.link}'),
                      ),
                    );
                  }
                }
              }
            },
            leading: Icon(item.icon, color: const Color(0xFF1A9D1F)),
            title: Text(
              item.title,
              style: const TextStyle(
                  color: Color(0xFF333333), fontWeight: FontWeight.w500),
            ),
            subtitle:
                Text(item.category, style: TextStyle(color: Colors.grey[600])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _editingItem = item; // item já tem o ID do banco
                    _currentLink = _editingItem?.link;
                    _showEditDialog(context, item);
                  },
                  icon: Icon(item.editIcon, color: Colors.blueGrey),
                ),
                IconButton(
                  onPressed: () {
                    if (item.id != null) {
                      _showDeleteConfirmationDialog(context, item.id!);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Erro: Item sem ID para exclusão.')),
                      );
                    }
                  },
                  icon: Icon(item.deleteIcon, color: Colors.redAccent),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, ItemModel currentItem) {
    final TextEditingController linkController =
        TextEditingController(text: currentItem.link);
    final TextEditingController titleController =
        TextEditingController(text: currentItem.title);
    String selectedCategory = currentItem.category;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Item'),
          content: SingleChildScrollView(
            child: Form(
              // Adicionar uma GlobalKey<FormState> se precisar de validação
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: linkController,
                    decoration: const InputDecoration(labelText: 'Link'),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    hint: const Text('Categoria'),
                    items: [
                      'Notícias',
                      'Compras'
                    ] // Mantenha as categorias consistentes
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedCategory = value;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedItem = currentItem.copyWith(
                  title: titleController.text,
                  link: linkController.text,
                  category: selectedCategory,
                  // O ícone pode ser atualizado com base na nova categoria, se necessário
                  icon: selectedCategory == 'Notícias'
                      ? Icons.newspaper
                      : Icons.shopping_cart,
                );
                // A operação de update agora é async
                await Provider.of<ItemProvider>(context, listen: false)
                    .updateItem(updatedItem);
                Navigator.of(context).pop();
                // O ItemProvider já notifica os listeners, então a UI deve atualizar
              },
              child: const Text('Salvar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A9D1F),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Item'),
          content: const Text('Tem certeza que deseja excluir este item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Não'),
            ),
            ElevatedButton(
              onPressed: () async {
                // A operação de delete agora é async
                await Provider.of<ItemProvider>(context, listen: false)
                    .deleteItem(itemId);
                Navigator.of(context).pop();
                // O ItemProvider já notifica os listeners, então a UI deve atualizar
              },
              child: const Text('Sim'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usar Consumer para reconstruir apenas as partes necessárias da UI quando o provider notificar
    return Consumer<ItemProvider>(
      builder: (context, itemProvider, child) {
        final newsItems = itemProvider.filteredItems
            .where((item) => item.category == 'Notícias')
            .toList();
        final shoppingItems = itemProvider.filteredItems
            .where((item) => item.category == 'Compras')
            .toList();

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A9D1F),
              title: const Text(
                'Ler Depois',
                style: TextStyle(
                  color: Color(0xFFfcfcfc),
                  fontWeight: FontWeight.bold,
                ),
              ),
              bottom: TabBar(
                labelColor: const Color(0xFFfcfcfc),
                unselectedLabelColor: Colors.grey[300],
                indicatorColor: const Color(0xFFfcfcfc),
                tabs: const [
                  Tab(text: 'Notícias'),
                  Tab(text: 'Compras'),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Pesquisar itens',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildItemList(newsItems, _newsScrollController),
                      _buildItemList(shoppingItems, _shoppingScrollController),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color(0xFF1A9D1F),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddItemScreen()),
                ).then((_) {
                  // O ItemProvider já deve recarregar e notificar após adicionar um item
                  // Se a lista não atualizar automaticamente, pode ser necessário chamar _loadItems ou similar aqui
                });
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
