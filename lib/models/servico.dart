import 'dart:convert';

class Servico{
  String nome;
  String data;
  String horario;
  int tipoServico;

  Servico();

  Servico.fromClienteServico(String nome, String data, String horario, int tipoServico){
    this.nome = nome;
    this.data = data;
    this.horario = horario;
    this.tipoServico = tipoServico;
  }

  Servico.fromJson(Map<String, dynamic> json):
        nome = json['nome'],
        data =  json['data'],
        horario = json['horario'],
        tipoServico = json['tipoServico'];

  Map toJson() => {
    'nome': nome,
    'data': data,
    'horario': horario,
    'tipoServico': tipoServico
  };
}