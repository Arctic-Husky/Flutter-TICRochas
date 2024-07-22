import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../chapas.dart';

class Catalogo extends StatefulWidget {
  const Catalogo({super.key});

  @override
  State<StatefulWidget> createState() => _Catalogo();
}

class _Catalogo extends State<Catalogo>{

  late Future<List<ChapasModel>> futureChapas;

  @override
  void initState() {
    super.initState();

    futureChapas = Chapas.getAllChapas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width ~/ 150;
    return FutureBuilder<List<ChapasModel>>(
      future: futureChapas,
      builder:(context, snapshot){
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError){
              return Text('Erro: ${snapshot.error}');
            }

            return GridView.builder(itemCount: snapshot.data?.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount),
            itemBuilder: (context, index) { // Acho que o container aqui nao ta funcionando por causa do gridview
              return Container(child:GestureDetector(onTap:(){debugPrint('Card ${index} tapped.');}, child:Card(clipBehavior: Clip.hardEdge,child: Column(children: [
                // InkWell(splashColor: Colors.blue.withAlpha(30),
                // onTap: () {
                //   debugPrint('Card tapped.');
                // },child: const SizedBox(width: 300,height: 100,),),
                Align(alignment: Alignment.topCenter, child:Image( image: CachedNetworkImageProvider(snapshot.data == null ? "" : snapshot.data?[index].urlArquivo as String), fit: BoxFit.contain)),
                Expanded( child:  Align(alignment: Alignment.bottomCenter,child:Center(child:Text('${snapshot.data?[index].nomeArquivo}')))),
              ],),)));
            },);
        }
      });
  }
}

// chapa tem que estar dentro de um row