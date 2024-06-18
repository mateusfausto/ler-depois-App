import 'package:flutter/material.dart';
import 'package:ler_depois/screens/home_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ler depois',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFfcfcfc),
      ),
      home: const HomeScreen(),
    );
  }
}