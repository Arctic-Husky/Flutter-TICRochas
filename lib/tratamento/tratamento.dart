import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:namer_app/chapas.dart';
import '../main.dart';
import 'package:path/path.dart';

class Tratamento extends StatefulWidget {
  const Tratamento(this.number, {super.key});

  final RefreshPage number;

  @override
  State<StatefulWidget> createState() => TratamentoState();
}

class TratamentoState extends State<Tratamento> {
  late RefreshPage number;

  String base64Image = '';
  String fileName = '';

  String responseImage = '';
  bool uploading = false;
  bool importing = true;
  bool saved = false;

  @override
  void initState() {
    super.initState();

    number = widget.number;
    // SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.portraitDown,
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),

          Expanded(
            child: Container(
                child: InteractiveViewer(
                    // TODO: ver melhor as barreiras de interação disso
                    clipBehavior: Clip.none,
                    maxScale: 4,
                    child: getImageWidget()
                            )
                            )
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.amber,
                child: const Row(children: [
                  Text("Importar "),
                  Icon(Icons.download_rounded)
                ]),
                onPressed: !uploading ? () {
                  _pickImageFromGallery();
                } : null,
              ),
              const SizedBox(
                width: 20,
              ),
              getSendButtonFunctionality(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    ));
  }

  Widget getSendButtonFunctionality(){
    if(uploading)
    {
      return const MaterialButton(
                color: Colors.green,
                onPressed: null,
                child:
                  Row(children: [Text("Enviar "), Icon(Icons.send_rounded)]),
              );
    }

    if(responseImage == '')
    {
      return MaterialButton(
                color: Colors.green,
                child:
                    const Row(children: [Text("Enviar "), Icon(Icons.send_rounded)]),
                onPressed: () {upload(base64Image);},
              );
    }
    else
    {
      return MaterialButton(
                color: Colors.green,
                child:
                    const Row(children: [Text("Salvar "), Icon(Icons.cloud_upload)]),
                onPressed: () {salvar();},
              );
    }
  }

  Widget getImageWidget(){

    if(saved)
    {
      return const FittedBox(fit: BoxFit.scaleDown,child: Icon(Icons.check_circle));
    }

    if(uploading)
    {
      return const FittedBox(fit: BoxFit.scaleDown,child: CircularProgressIndicator(color: Color.fromARGB(255, 5, 6, 11)));
    }

    if(importing)
    {
      if(base64Image == '')
      {
        return const Center(child: Text("Nenhuma Imagem Selecionada"));
      }

      setState(() {
        responseImage = '';
      });
      
      return Image.memory(base64Decode(base64Image));
    }

    if(responseImage != '')
    {
      return Image.memory(base64Decode(responseImage));
    }

    
    return const Center(child: Text("Nenhuma Imagem Selecionada"));
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) {
      return;
    }

    var bytes = await returnedImage.readAsBytes();

    setState(() {

      base64Image = base64Encode(bytes);
      print("BASENAME");
      print(returnedImage.path);
      fileName = basename(returnedImage.path);
      importing = true;
    });
  }

  Future salvar() async{
    if(responseImage == '')
    {
      return;
    }

    setState(() {
      importing = false;
      uploading = true;
      saved = false;
    });

    var response = await Chapas.saveToCatalog(responseImage, fileName);

    if(response)
    {
        setState(() {
        uploading = false;
        responseImage = '';
        saved = true;
      });
    }

    return response;
  }

  Future upload(String base64image) async {
    if(base64image == '')
    {
      return;
    }

    setState(() {
      importing = false;
      uploading = true;
    });

    var response = await Chapas.uploadChapa(base64image, fileName);

    if(response == "")
    {
      return;
    }

    setState(() {
      uploading = false;
      responseImage = response;
    });
  }
}
