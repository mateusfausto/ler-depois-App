import 'package:flutter/material.dart';
import 'package:ler_depois/models/item_model.dart';
//import 'package:ler_depois/repositories/item_repository.dart';
import 'package:ler_depois/screens/add_item_screen.dart';
import 'package:ler_depois/services/item_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  late List<ItemModel> _newsItems;
  late List<ItemModel> _shoppingItems;
  late List<ItemModel> _filteredNewsItems; // Lista filtrada para notícias
  late List<ItemModel> _filteredShoppingItems; // Lista filtrada para compras
  ItemModel? _editingItem; // Armazena o item a ser editado
  String? _currentLink; // Armazena o link atual do item
  bool _isSearching = false; // Indica se a pesquisa está ativa
  final _searchController = TextEditingController(); // Controlador do campo de pesquisa
  late AnimationController _animationController; // Controlador da animação
  late Animation<double> _animation; // Animação para o campo de pesquisa
  late FocusNode _searchFocusNode; // FocusNode para o campo de pesquisa
  late TickerProvider _tickerProvider; // TickerProvider

  ScrollController _scrollController = ScrollController(); // Controlador de scroll

  @override
  void initState() {
    super.initState();
    _tickerProvider = this; // Define o TickerProvider
    _tabController = TabController(length: 2, vsync: _tickerProvider);
    // Substitui o listener do itemRepository pelo listener do Provider:
    Provider.of<ItemProvider>(context, listen: false).addListener(_updateItems);
    WidgetsBinding.instance.addObserver(this);
    _newsItems = Provider.of<ItemProvider>(context, listen: false).items
        .where((item) => item.category == 'Notícias')
        .toList();
    _shoppingItems = Provider.of<ItemProvider>(context, listen: false).items
        .where((item) => item.category == 'Compras')
        .toList();
    _filteredNewsItems = _newsItems; // Inicializa a lista filtrada de notícias
    _filteredShoppingItems = _shoppingItems; // Inicializa a lista filtrada de compras

    // Inicializa a animação do campo de pesquisa
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: _tickerProvider, // Usa o TickerProvider
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Inicializa o FocusNode para o campo de pesquisa
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    // Substitui o removeListener do itemRepository pelo do Provider:
    Provider.of<ItemProvider>(context, listen: false).removeListener(_updateItems);
    _searchController.dispose();
    _animationController.dispose();
    _searchFocusNode.dispose(); // Descarte o FocusNode
    _scrollController.dispose(); // Descarte o ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A9D1F),
        title: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return !_isSearching
                ? Text(
                    'Ler Depois',
                    style: TextStyle(
                      color: Color(0xFFfcfcfc),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(
                    height: 40,
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode, // Associa o FocusNode ao TextField
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                      ),
                      onChanged: (value) {
                        _filterItems(value);
                      },
                      // Define o onTap para colocar o foco no campo de pesquisa ao ser tocado
                      onTap: () {
                        FocusScope.of(context).requestFocus(_searchFocusNode);
                      },
                    ),
                  );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (_isSearching) {
                  _animationController.forward();
                  // Coloca o foco no campo de pesquisa usando o FocusNode
                  FocusScope.of(context).requestFocus(_searchFocusNode);
                } else {
                  _animationController.reverse();
                  _searchController.clear();
                  _filteredNewsItems = _newsItems;
                  _filteredShoppingItems = _shoppingItems;
                }
              });
            },
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Color(0xFFfcfcfc),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Fecha o campo de pesquisa quando a tela é tocada
          if (_isSearching) {
            setState(() {
              _isSearching = false;
              _animationController.reverse();
              _searchController.clear();
              _filteredNewsItems = _newsItems;
              _filteredShoppingItems = _shoppingItems;
            });
          }
        },
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Color(0xFF333333),
              unselectedLabelColor: Color(0xFF707070),
              tabs: [
                Tab(text: 'Notícias'),
                Tab(text: 'Compras'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Adiciona o ScrollController ao ListView.builder
                  _buildItemList(_filteredNewsItems, _scrollController), // Usa a lista filtrada de notícias
                  // Adiciona o ScrollController ao ListView.builder
                  _buildItemList(_filteredShoppingItems, _scrollController), // Usa a lista filtrada de compras
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF1A9D1F),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
        child: Icon(
          Icons.add,
          color: Color(0xFFfcfcfc),
        ),
      ),
    );
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      _filteredNewsItems = _newsItems;
      _filteredShoppingItems = _shoppingItems;
    } else {
      _filteredNewsItems = _newsItems
          .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filteredShoppingItems = _shoppingItems
          .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  Widget _buildItemList(List<ItemModel> items, ScrollController scrollController) {
    return ListView.builder(
      controller: scrollController, // Define o ScrollController
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () async {
              if (await canLaunch(items[index].link)) {
                await launch(items[index].link);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Link inválido.'),
                  ),
                );
              }
            },
            leading: Icon(items[index].icon),
            title: Text(
              items[index].title,
              style: TextStyle(color: Color(0xFF333333)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _editingItem = items[index];
                    _currentLink = _editingItem?.link;
                    _showEditDialog(context);
                  },
                  icon: Icon(items[index].editIcon),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(index, items);
                  },
                  icon: Icon(items[index].deleteIcon),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
    if (_editingItem != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Editar Item'),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _currentLink,
                    onChanged: (value) {
                      _currentLink = value;
                      if (_editingItem != null) {
                        _editingItem!.link = value;
                        Provider.of<ItemProvider>(context, listen: false).updateItem(
                            Provider.of<ItemProvider>(context, listen: false).items.indexOf(_editingItem!),
                            _editingItem!
                        );
                        _updateItems();
                      }
                    },
                    // ...
                  ),
                  // ... (outras informações a serem editadas)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Salvar'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _showDeleteConfirmationDialog(int index, List<ItemModel> items) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Excluir Item'),
          content: Text('Tem certeza que deseja excluir este item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () {
                // Obtendo o índice global corretamente do Provider
                int globalIndex = Provider.of<ItemProvider>(context, listen: false)
                    .items
                    .indexOf(items[index]); 
                Provider.of<ItemProvider>(context, listen: false)
                    .deleteItem(globalIndex);
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  void _updateItems() {
    print("Atualizando a ListView");
    setState(() {
      _newsItems = Provider.of<ItemProvider>(context, listen: false).items
          .where((item) => item.category == 'Notícias')
          .toList();
      _shoppingItems = Provider.of<ItemProvider>(context, listen: false).items
          .where((item) => item.category == 'Compras')
          .toList();
      _filteredNewsItems = _newsItems;
      _filteredShoppingItems = _shoppingItems;
    });
  }
}