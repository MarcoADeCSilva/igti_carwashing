import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:igti_carwashing/models/servico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  List<Servico> listServico = [];

  @override
  void initState() {
    super.initState();
    _reloadList();
  }

  _reloadList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('listServico');
    if(data != null){
      setState(() {
        var objs = jsonDecode(data) as List;
        listServico = objs.map((obj) => Servico.fromJson(obj)).toList();
        listServico.sort((a,b) => a.nome.compareTo(b.nome));//Ordena a lista em ordem crescente.
      });
    }
  }

  _removeItem(int index){
    setState(() {
      listServico.removeAt(index);
    });
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setString('listServico', jsonEncode(listServico)));
  }

  _showAlertDialog(BuildContext context, String conteudo, Function confirmFunction, int index){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            FlatButton(
              child: Text('Não'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Sim'),
              onPressed: () {
                confirmFunction(index);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: listServico.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${listServico[index].nome}'),
            subtitle: Text('${listServico[index].tipoServico}' == '0' ? "Lavagem Simples" : '${listServico[index].tipoServico}' == '1' ? "Lavagem completa sem cera" : "Lavagem completa com cera"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.clear),
                  color: Colors.red,
                  onPressed: () => _showAlertDialog(context, 'Confirma a exclusão do cadastro?', _removeItem, index),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
