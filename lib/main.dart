import 'package:flutter/material.dart';
import 'catalogo/catalogo.dart';
import 'tratamento/tratamento.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  
  // WidgetsFlutterBinding.ensureInitialized();

  // await Supabase.initialize(
  //   url: 'https://yjdjcvftedrffiiidcyb.supabase.co',
  //   anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlqZGpjdmZ0ZWRyZmZpaWlkY3liIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTY5MzcxMjAsImV4cCI6MjAxMjUxMzEyMH0.p1SepvPwB_J_xiHxOiQldPZFzqIFH2powluHzqwDN7Q',
  // );

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
    
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.amber,
        backgroundColor: const Color.fromARGB(255, 5, 6, 11),
        title: Row(children: [Image.asset('assets/logo.png',fit: BoxFit.contain, height: 60,),const Text("TIC Rochas")],),
      ),
      // drawer: const Drawer(),
      body: Column(children: [const SizedBox(height: 15,),Text("Catálogo", style: TextStyle(fontSize: 18+unitWidthValue),),Flexible(child:Catalogo(number))]),
      floatingActionButton: FloatingActionButton(hoverColor: const Color.fromARGB(255, 5, 6, 11).withAlpha(30),foregroundColor:const Color.fromARGB(255, 5, 6, 11), backgroundColor: colorScheme.surface, child: const Icon(Icons.add_photo_alternate), 
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => TratamentoPage(number)));
      },),
    );
  }
}

class TratamentoPage extends StatelessWidget {
  TratamentoPage(this.number, {super.key});

  RefreshPage number;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        child: Scaffold(
            appBar: AppBar(
                foregroundColor: Colors.amber,
                backgroundColor: const Color.fromARGB(255, 5, 6, 11),
                title: const Text("TIC Rochas"),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )),
            body: Tratamento(number)),
          onPopInvoked: (didPop) {
            if(didPop)
            {
              number.notify();
            }
          },);
  }
}

class RefreshPage with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void notify() {
    _count += 1;
    notifyListeners();
  }
}

// class MyCacheManager {
//   Future<void> cacheImage() async {
//     // final SupabaseStorageClient storage = FirebaseStorage(
//     //   app: Firestore.instance.app,
//     //   storageBucket: 'gs://my-project.appspot.com',
//     // );

//     final SupabaseStorageClient storageClient = SupabaseStorageClient("");

//     final Reference ref = storage.ref().child('selfies/me2.jpg');
    
//     // Get your image url
//     final imageUrl = await ref.getDownloadURL();

//     // Download your image data
//     final imageBytes = await ref.getData(10000000);

//     // Put the image file in the cache
//     await DefaultCacheManager().putFile(
//       imageUrl,
//       imageBytes,
//       fileExtension: "jpg",
//     );
//   }
// }