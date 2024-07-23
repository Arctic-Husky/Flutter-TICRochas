import 'package:flutter/material.dart';
import 'catalogo/catalogo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(home: const HomePage());
    return MaterialApp(
        title: "TIC Rochas",
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 245, 240, 243)),
        initialRoute: "/",
        routes: {
          '/': (context) => const HomePage(),
        });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        backgroundColor: const Color.fromARGB(255, 5, 6, 11),
        title: const Text("TIC Rochas"),
      ),
      // drawer: const Drawer(),
      body: const Catalogo(),
    );
  }
}
