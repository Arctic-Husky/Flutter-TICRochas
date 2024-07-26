import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../chapas.dart';
import '../main.dart';

class Catalogo extends StatefulWidget {
  const Catalogo(this.number, {super.key});

  final RefreshPage number;

  @override
  State<StatefulWidget> createState() => CatalogoState();
}

class CatalogoState extends State<Catalogo> {
  late RefreshPage number;

  final TextEditingController _searchController = TextEditingController();

  late Future<List<ChapasModel>> futureChapas;

  List<ChapasModel> filteredChapas = [];

  @override
  void initState() {
    super.initState();
    
    number = widget.number;

    number.addListener(() {
      futureChapas = _getAllChapas();
    },);

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
    var mediaQuery = MediaQuery.of(context);

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
                SizedBox(height: 20,),
                SearchAnchor(builder: (context, controller) {
                  return SearchBar(
                    controller: _searchController,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0)),
                    leading: const Icon(Icons.search),
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  );
                }, suggestionsBuilder: (context, controller) {
                  return List.empty();
                }),
                SizedBox(height: 20,),
                Expanded(
                    child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: filteredChapas.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount),
                  itemBuilder: (context, index) {
                    // Acho que o container aqui nao ta funcionando por causa do gridview
                    return Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: const Color.fromARGB(30, 5, 6, 11),
                          onTap: () async {
                            await Future.delayed(const Duration(milliseconds: 200));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) {
                                      number.notify();
                                      return ExpandedChapa(
                                          filteredChapas[index]);
                                    },
                                    fullscreenDialog: true));
                          },
                          child: Column(
                            children: [
                              Expanded(child:Align(
                                  alignment: Alignment.topCenter,
                                  child: CachedNetworkImage(
                                      // TODO: melhorar essa coisa da imagem, toda vez que ela sai da tela e volta ela parece ser baixada novamente
                                      // memCacheHeight: mediaQuery.size.height.toInt(),
                                      // memCacheWidth: mediaQuery.size.width.toInt(),
                                      maxWidthDiskCache: 500,
                                      maxHeightDiskCache: 500,
                                      imageUrl:
                                          filteredChapas[index].urlArquivo,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(
                                            color:
                                                Color.fromARGB(255, 5, 6, 11),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.none))),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Center(
                                          child: Text(filteredChapas[index]
                                              .nomeArquivo)))),
                            ],
                          ),
                        ));
                  },
                ))
              ]);
          }
        });
  }
}

class ExpandedChapa extends StatelessWidget {
  final ChapasModel chapa;

  const ExpandedChapa(this.chapa, {super.key});

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      primary: false,
      leading: const IconTheme(
          data: IconThemeData(color: Colors.black),
          child: CloseButton(
              style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color>(
                Color.fromARGB(255, 254, 247, 255)),
          ))),
      // flexibleSpace: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [Colors.transparent, Colors.transparent],
      //     ),
      //   ),
      // ),
      backgroundColor: Colors.transparent,
    );

    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Stack(
      children: <Widget>[
        Hero(
            tag: "extendedChapa",
            child: Material(
                child: Column(
              children: <Widget>[
                //Spacer(),
                Expanded(
                    child: InteractiveViewer(
                        // TODO: ver melhor as barreiras de interação disso
                        clipBehavior: Clip.none,
                        maxScale: 4,
                        child: CachedNetworkImage(
                            // maxWidthDiskCache: 1000,
                            // maxHeightDiskCache: 1000,
                            imageUrl: chapa.urlArquivo,
                            imageBuilder: (context, imageProvider) => Container(decoration: BoxDecoration(image: DecorationImage(image: imageProvider,fit: BoxFit.scaleDown,))),
                            placeholder: (context, url) => const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 5, 6, 11),
                                )),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.contain))),
                Material(
                    child: ListTile(
                  title: Center(child: SelectableText(chapa.nomeArquivo)),
                  subtitle: Center(child: Text(chapa.dataCriacao)),
                )),
                // Expanded(child: Center(child:Text("testeteste")),)
              ],
            ))),
        Column(
          children: <Widget>[
            Container(
              height: mediaQuery.padding.top,
            ),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: appBar.preferredSize.height),
              child: appBar,
            )
          ],
        )
      ],
    ); // Stack
  }
}
