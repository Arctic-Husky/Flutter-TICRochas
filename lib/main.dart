import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'catalogo/catalogo.dart';
import 'tratamento/tratamento.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "TIC Rochas",
        theme: ThemeData(fontFamily: GoogleFonts.roboto().fontFamily,
            scaffoldBackgroundColor: const Color.fromARGB(255, 245, 240, 243)),
        initialRoute: "/",
        routes: {
          '/': (context) => HomePage()
        });
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  
  final number = RefreshPage();

  @override
  Widget build(BuildContext context) {

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    double unitWidthValue = MediaQuery.of(context).size.width * 0.005;

    double screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        backgroundColor: const Color.fromARGB(255, 5, 6, 11),
        title: responsiveTitle(screenWidth)
      ),
      // drawer: const Drawer(),
      body: Column(children: [Flexible(child:Catalogo(number))]),
      floatingActionButton: FloatingActionButton(hoverColor: const Color.fromARGB(255, 5, 6, 11).withAlpha(30),foregroundColor:const Color.fromARGB(255, 5, 6, 11), backgroundColor: colorScheme.surface, child: const Icon(Icons.add_photo_alternate), 
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TratamentoPage(number)));
      },),
    );
  }
}

Widget responsiveTitle(double width)
{
  if(width <= 720)
  {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Row(children: [ Image.asset('assets/logo.png',fit: BoxFit.contain, height: 40,),const Text("TIC Rochas"),]),const Spacer(),const Text("Catálogo"), const Spacer()],);
  }

  return Stack(alignment: Alignment.center, children:[Row(children: [ Image.asset('assets/logo.png',fit: BoxFit.contain, height: 40,),const Text("TIC Rochas"),]),Center(child:const Text("Catálogo"))],);
}

class TratamentoPage extends StatelessWidget {
  TratamentoPage(this.number, {super.key});

  RefreshPage number;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
        child: Scaffold(
            appBar: AppBar(automaticallyImplyLeading: false,
                foregroundColor: Colors.amber,
                backgroundColor: const Color.fromARGB(255, 5, 6, 11),
                title: responsiveTitleTratamento(screenWidth, context),
                ),
            body: Tratamento(number)),
          onPopInvoked: (didPop) {
            if(didPop)
            {
              number.notify();
            }
          },);
  }
}

Widget responsiveTitleTratamento(double width, BuildContext context)
{
  if(width <= 720)
  {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Row(children: [IconButton(icon: const Icon(Icons.arrow_back_rounded),onPressed: () {Navigator.pop(context);},), const Text("Voltar")]), const Spacer(), const Text("Tratamento"), const Spacer()],);
  }

  

  return Stack(alignment: Alignment.centerLeft, children:[Row(children: [IconButton(icon: const Icon(Icons.arrow_back_rounded),onPressed: () {Navigator.pop(context);},),Text("Voltar")]),Center(child: Text("Tratamento"))],);
}

class RefreshPage with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void notify() {
    _count += 1;
    notifyListeners();
  }
}