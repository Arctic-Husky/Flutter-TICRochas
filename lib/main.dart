import 'package:flutter/material.dart';
import 'catalogo/catalogo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "TIC Rochas",
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 245, 240, 243)),
        initialRoute: "/",
        routes: {
          '/': (context) => const HomePage(),
          '/tratamento': (context) => const TratamentoPage(), // talvez nao precise disto aqui
        });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        backgroundColor: const Color.fromARGB(255, 5, 6, 11),
        title: const Text("TIC Rochas"),
      ),
      // drawer: const Drawer(),
      body: const Catalogo(),
      floatingActionButton: FloatingActionButton(hoverColor: const Color.fromARGB(255, 5, 6, 11).withAlpha(30),foregroundColor:const Color.fromARGB(255, 5, 6, 11), backgroundColor: colorScheme.surface, child: const Icon(Icons.add_photo_alternate), 
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const TratamentoPage()));
      },),
    );
  }
}

class TratamentoPage extends StatelessWidget{
  const TratamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        backgroundColor: const Color.fromARGB(255, 5, 6, 11),
        title: const Text("TIC Rochas"),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: (){Navigator.pop(context);},)
      ),
    );
  }
}