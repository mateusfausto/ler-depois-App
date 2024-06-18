import 'package:flutter/material.dart';
import 'package:ler_depois/models/item_model.dart';

class ItemProvider with ChangeNotifier {
    final List<ItemModel> _items = [
     // Notícia
    ItemModel(
      title: 'Título do Artigo 1 - Notícia',
      link: 'https://www.google.com/news/story',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Título do Artigo 2 - Notícia',
      link: 'https://www.uol.com.br/noticias',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Título do Artigo 3 - Notícia',
      link: 'https://www.estadao.com.br',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Novo Estudo Revela Impacto da Pandemia na Economia',
      link: 'https://www.bbc.com/news',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Governo Anuncia Novas Medidas para Combater a Inflação',
      link: 'https://www.g1.globo.com/economia',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Cientistas Descobrem Nova Espécie de Animal na Amazônia',
      link: 'https://www.nationalgeographic.com',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Eleições 2023: Candidatos Disputam Debate Acesa',
      link: 'https://www.folha.uol.com.br/politica',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Crimes Cibernéticos Aumentam em 2023',
      link: 'https://www.techtudo.com.br/noticias',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Time de Futebol Local Conquista Título Inesperado',
      link: 'https://www.espn.com.br/futebol',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Novo Filme de Ação Chega aos Cinemas em Breve',
      link: 'https://www.adorocinema.com',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Festival de Música Anual Atrai Multidões',
      link: 'https://www.rollingstone.com.br',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Mudanças Climáticas Ameaçam Recursos Hídricos',
      link: 'https://www.greenpeace.org',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Crise na Saúde Pública: Falta de Médicos e Medicamentos',
      link: 'https://www.bbc.com/portuguese/brasil',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Inovações Tecnológicas Impulsionam o Mercado de Trabalho',
      link: 'https://www.exame.com',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Nova Lei de Trânsito Entra em Vigor em 2024',
      link: 'https://www.denatran.gov.br',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Astronautas Retornam da Estação Espacial Internacional',
      link: 'https://www.nasa.gov',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Crise Econômica Global: Impacto nas Bolsas de Valores',
      link: 'https://www.bloomberg.com',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Brasil Enfrenta Desafios na área da Educação',
      link: 'https://www.gov.br/mec',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Protestos Sociais Abalam o País',
      link: 'https://www.cartacapital.com.br',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Nova Tecnologia Promete Revolucionar a Medicina',
      link: 'https://www.sciam.com',
      category: 'Notícias',
      icon: Icons.newspaper,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),

    // Compras
    ItemModel(
      title: 'Produto Incrível - Oferta!',
      link: 'https://www.amazon.com/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Roupa de Verão - Desconto!',
      link: 'https://www.shoptime.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Eletrônicos em Promoção',
      link: 'https://www.magazineluiza.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Smartphones com Descontos Imperdíveis',
      link: 'https://www.americanas.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Livros de Ficção a Preços Incríveis',
      link: 'https://www.submarino.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Eletrodomésticos para sua Casa',
      link: 'https://www.walmart.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Ofertas Exclusivas de Móveis',
      link: 'https://www.casasbahia.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Brinquedos para Todas as Idades',
      link: 'https://www.rihappy.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Perfumes e Cosméticos com Descontos',
      link: 'https://www.boticario.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Calçados e Acessórios da Moda',
      link: 'https://www.dafiti.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Promoções de Viagens e Passagens Aéreas',
      link: 'https://www.decolar.com/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Equipamentos Esportivos para Todos os Gostos',
      link: 'https://www.netshoes.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Presentes Criativos para Todas as Ocasiões',
      link: 'https://www.presentes.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Produtos de Limpeza e Organização',
      link: 'https://www.casasbahia.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Alimentos e Bebidas com Descontos Especiais',
      link: 'https://www.jamesdelivery.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Ferramentas e Materiais de Construção',
      link: 'https://www.leroymerlin.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Camisetas e Acessórios de Bandas',
      link: 'https://www.submarino.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Jogos para PC e Consoles',
      link: 'https://www.magazineluiza.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
    ItemModel(
      title: 'Ofertas de Equipamentos de Camping',
      link: 'https://www.decatholon.com.br/product',
      category: 'Compras',
      icon: Icons.shopping_cart,
      editIcon: Icons.edit,
      deleteIcon: Icons.delete,
    ),
  ]; // Lista para armazenar os itens

  List<ItemModel> get items => _items;

  void addItem(ItemModel item) {
    _items.add(item);
    notifyListeners();
  }

  void updateItem(int index, ItemModel item) {
    _items[index] = item;
    notifyListeners();
  }

  void deleteItem(int index) {
    // Encontre o índice correto do item na lista completa _items
    int correctIndex = _items.indexOf(_items[index]); 

    if (correctIndex != -1) {
      _items.removeAt(correctIndex);
    } else {
      print("Erro: Item não encontrado na lista.");
    }
    notifyListeners();
  }
  // Lista de itens filtrados
  List<ItemModel> _filteredItems = [];

  // Getter para a lista filtrada
  List<ItemModel> get filteredItems => _filteredItems;

  // Método para atualizar a lista filtrada
  void updateFilteredItems(List<ItemModel> items) {
    _filteredItems = items;
    notifyListeners();
  }
}
