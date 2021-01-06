import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:igti_carwashing/models/cliente.dart';
import 'package:igti_carwashing/screens/cadastro_clientes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lista_Clientes extends StatefulWidget {
  @override
  _Lista_ClientesState createState() => _Lista_ClientesState();
}

class _Lista_ClientesState extends State<Lista_Clientes> {

  List<Cliente> list = [];

  @override
  void initState() {
    super.initState();
    _reloadList();
  }

  _reloadList() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('listCliente');
    if(data != null){
      setState(() {
        var objs = jsonDecode(data) as List;
        list = objs.map((obj) => Cliente.fromJson(obj)).toList();
        list.sort((a,b) => a.nome.compareTo(b.nome));//Ordena a lista em ordem crescente.
      });
    }
  }

  _removeItem(int index){
    setState(() {
      list.removeAt(index);
    });
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setString('listCliente', jsonEncode(list)));
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
        title: Text('Lista de clientes'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${list[index].nome}'),
              subtitle: Text('${list[index].telefone}'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cadastro_Clientes(cliente: list[index], index: index),
                  )).then((value) => _reloadList()),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Cadastro_Clientes(cliente: null,index: -1),
            )).then((value) => _reloadList()),
      ),
    );
  }
}
