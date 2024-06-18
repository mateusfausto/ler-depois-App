import 'package:flutter/material.dart';
import 'package:ler_depois/services/item_provider.dart';
import 'package:provider/provider.dart';
import 'my_app.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemProvider(),
      child: MyApp(),
    ),
  );
}