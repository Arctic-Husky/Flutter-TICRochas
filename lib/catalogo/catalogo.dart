import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../chapas.dart';

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

  @override
  State<StatefulWidget> createState() => CatalogoState();
}

class CatalogoState extends State<Catalogo> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<ChapasModel>> futureChapas;

  List<ChapasModel> filteredChapas = [];

  @override
  void initState() {
    super.initState();

    futureChapas = _getAllChapas();
    _searchController.addListener(_filterChapas);
  }

  Future<List<ChapasModel>> _getAllChapas() async {
    var chapasObtidas = Chapas.getAllChapas();

    chapasObtidas.then((items) {
      setState(() {
        filteredChapas = items;
      });
    });

    return chapasObtidas;
  }

  // TODO: o listener ta chamando isto demais, ate pra selecionar texto ta chamando, consertar isso
  void _filterChapas() {
    setState(() {
      futureChapas.then((items) {
        filteredChapas = items
            .where((item) => item.nomeArquivo
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width ~/ 180;
    return FutureBuilder<List<ChapasModel>>(
        future: futureChapas,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                  child: CircularProgressIndicator(
                color: Color.fromARGB(255, 5, 6, 11),
              ));
            default:
              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}');
              }

              return Column(children: <Widget>[
                SearchAnchor(builder: (context, controller) {
                  return SearchBar(
                    controller: _searchController,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    leading: const Icon(Icons.search),
                  );
                }, suggestionsBuilder: (context, controller) {
                  return List.empty();
                }),
                Expanded(
                    child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: filteredChapas.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount),
                  itemBuilder: (context, index) {
                    // Acho que o container aqui nao ta funcionando por causa do gridview
                    return Container(
                        child: GestureDetector(
                            onTap: () {
                              debugPrint('Card ${index} tapped.');
                            },
                            child: Card(
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: CachedNetworkImage( // TODO: melhorar essa coisa da imagem, toda vez que ela sai da tela e volta ela parece ser baixada novamente
                                              imageUrl: filteredChapas[index]
                                                  .urlArquivo,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(
                                                    color: Color.fromARGB(
                                                        255, 5, 6, 11),
                                                  ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              fit: BoxFit.contain)),
                                      Expanded(
                                          child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Center(
                                                  child: Text(
                                                      filteredChapas[index]
                                                          .nomeArquivo)))),
                                    ],
                                  ),
                                ))));
                  },
                ))
              ]);
          }
        });
  }
}
