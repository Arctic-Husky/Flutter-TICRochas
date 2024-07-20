import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chapas.dart';
import 'dart:convert';

// funny
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(home: const HomePage());
    return MaterialApp(title: "TIC Rochas",
    initialRoute:"/",
    routes:{
        '/': (context) => const HomePage(),
        '/teste': (context) => const FutureGetChapas(),
        }
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar(title: const Text("TIC Rochas"),),
      drawer: const Drawer(),
      body: Center(
        child: ElevatedButton(
          // Within the `FirstScreen` widget
          onPressed: () {
            // Navigate to the second screen using a named route.
            Navigator.pushNamed(context, '/teste');
          },
          child: const Text('Chapa'),
        ),
      ),
    );
  }
}

class FutureGetChapas extends StatefulWidget {
  const FutureGetChapas({super.key});

  @override
  State<StatefulWidget> createState() => _FutureGetChapas();

}

class _FutureGetChapas extends State<FutureGetChapas>
{
  // final Future<String> _chapas = Future<String>;

  Future<String> getChapas() async
  {
    final response = await http.get(Uri.parse('${Chapas.baseUrl}/catalogo'));
    
    return response.body;
  }

 @override
  Widget build(BuildContext context) {

    Future<String> _chapas = getChapas();

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.displayMedium!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _chapas, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            final data = jsonDecode(snapshot.data.toString()) as List<dynamic>;
            //final primeira = jsonDecode(chapas[0]) as Map<String, dynamic>;
            //final primeira = jsonDecode(chapas[0]) as List<dynamic>;
            // var parsedJsonData = chapas['data'] as List;
            List<ChapasModel> chapasList = ChapasModelResponse.fromJson(data[1]).list;

            int numero = Random().nextInt(chapasList.length);
            // chapasList.first.nomeArquivo
            children = <Widget>[
              Image( image: NetworkImage(chapasList[numero].urlArquivo),
),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(child: Text(chapasList[numero].nomeArquivo)),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}