import 'package:flutter/material.dart';
import 'package:ler_depois/services/item_provider.dart'; // Certifique-se que o caminho está correto
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'my_app.dart'; // Certifique-se que o caminho está correto

// Import kIsWeb para verificar se está rodando na Web
import 'package:flutter/foundation.dart' show kIsWeb;

// Importe o factory para Web
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// Se você também for rodar em Desktop (Windows, Linux, macOS),
// você pode precisar destes imports também:
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'dart:io'; // Para Platform.isWindows, etc.

Future<void> main() async {
  // Garante que os bindings do Flutter estão inicializados
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Define o database factory para a web.
    // Isso é crucial para o sqflite funcionar no navegador.
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // Para plataformas mobile (Android/iOS), o sqflite geralmente funciona sem
    // configuração explícita do databaseFactory aqui, pois usa a implementação nativa.

    // Se você planeja suportar Desktop (Windows, Linux, macOS):
    // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    //   sqfliteFfiInit(); // Inicializa o FFI para desktop
    //   databaseFactory = databaseFactoryFfi; // Define o factory para desktop
    // }
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemProvider(),
      child: const MyApp(),
    ),
  );
}

