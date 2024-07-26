import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import "package:universal_html/html.dart" as html;

class Chapas {
  static String baseUrl = "http://181.213.92.95:8000";

  static Future<List<ChapasModel>> getAllChapas() async {
    final response = await http.get(Uri.parse('${Chapas.baseUrl}/catalogo'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<ChapasModel> chapasList = ChapasModelResponse.fromJson(data[1]).list;

      return chapasList;
    }

    throw Exception("Failed to load with code ${response.statusCode}");
  }

  // No need
  static Future<List<ChapasModel>> searchChapas(String search) async {
    if (search == '') {
      return getAllChapas();
    }

    const headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };

    var searchToSend = StringBuffer();

    searchToSend.write('%');
    searchToSend.write(search);
    searchToSend.write('%');

    final response = await http.post(Uri.parse('${Chapas.baseUrl}/busca'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
            <String, String>{'stringBusca': searchToSend.toString()}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      List<ChapasModel> chapasList = ChapasModelResponse.fromJson(data[1]).list;

      return chapasList;
    }

    throw Exception("Failed to load with code ${response.statusCode}");
  }

  static Future<String> uploadChapa(String image, String fileName) async {

    var request = http.MultipartRequest("POST",Uri.parse('${Chapas.baseUrl}/upload'));

    Uint8List bytes = base64Decode(image);

    request.files.add(http.MultipartFile.fromBytes('file', bytes,filename: fileName, contentType: MediaType('image', 'jpeg')));

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if(response.statusCode == 200)
    {
      return response.body;
    }

    return "";

  }

  static Future<bool> saveToCatalog(String image, String fileName) async {

    var request = http.MultipartRequest("POST",Uri.parse('${Chapas.baseUrl}/salvar'));

    Uint8List bytes = base64Decode(image);

    request.files.add(http.MultipartFile.fromBytes('file', bytes,filename: fileName, contentType: MediaType('image', 'jpeg')));

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    if(response.statusCode == 200)
    {
      return true;
    }

    return false;
  }
}

class ChapasModel {
  late String idChapa;
  late String nomeArquivo;
  late String urlArquivo;
  late String dataCriacao;

  ChapasModel(
      this.idChapa, this.nomeArquivo, this.urlArquivo, this.dataCriacao);

  ChapasModel.fromJson(Map<String, dynamic> json) {
    idChapa = json['ID_CHAPA'];
    nomeArquivo = json['NOME_ARQUIVO'];
    urlArquivo = json['URL_ARQUIVO'];
    dataCriacao = json['DATA_CRIACAO'];
  }
}

class ChapasModelResponse {
  final List<ChapasModel> list;

  ChapasModelResponse(this.list);

  factory ChapasModelResponse.fromJson(List<dynamic> parsedJson) {
    List<ChapasModel> list = List.empty(growable: true);

    list = parsedJson.map((i) => ChapasModel.fromJson(i)).toList();

    return ChapasModelResponse(list);
  }
}
