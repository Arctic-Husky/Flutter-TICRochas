import 'dart:convert';
import 'dart:core';

class Chapas {
  static String baseUrl = "http://181.213.92.95:8000";
}

class ChapasModel{
  late String idChapa;
  late String nomeArquivo;
  late String urlArquivo;
  late String dataCriacao;

  ChapasModel(this.idChapa, this.nomeArquivo, this.urlArquivo, this.dataCriacao);

  ChapasModel.fromJson(Map<String, dynamic> json){
    idChapa = json['ID_CHAPA'];
    nomeArquivo = json['NOME_ARQUIVO'];
    urlArquivo = json['URL_ARQUIVO'];
    dataCriacao = json['DATA_CRIACAO'];
  }
}

class ChapasModelResponse{
  final List<ChapasModel> list;

  ChapasModelResponse(this.list);

  factory ChapasModelResponse.fromJson(List<dynamic> parsedJson)
  {
    List<ChapasModel> list = List.empty(growable: true);

    list = parsedJson.map((i) => ChapasModel.fromJson(i)).toList();

    return ChapasModelResponse(list);
  }
}