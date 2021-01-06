import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igti_carwashing/models/cliente.dart';
import 'package:igti_carwashing/screens/lista_clientes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Cadastro_Clientes extends StatefulWidget {
  final Cliente cliente;
  final int index;
  Cadastro_Clientes({Key key, @required this.cliente, @required this.index}) : super(key: key);

  @override
  _Cadastro_ClientesState createState() => _Cadastro_ClientesState(cliente, index);
}

class _Cadastro_ClientesState extends State<Cadastro_Clientes> {
  Cliente _cliente;
  int _index;
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final key = GlobalKey<ScaffoldState>();
  var maskDateFormatter = new MaskTextInputFormatter(mask: '(##)#####-####', filter: { "#": RegExp(r'[0-9]') });

  _Cadastro_ClientesState(Cliente cliente, int index){
    this._cliente = cliente;
    this._index = index;
    if(_cliente != null){
      _nomeController.text = cliente.nome;
      _telefoneController.text = cliente.telefone;
    }
  }

  _saveItem() async {

    if(_nomeController.text.isEmpty || _telefoneController.text.isEmpty){
      key.currentState.showSnackBar(SnackBar(
          content: Text('Nome e telefone são obrigatórios!')
      ));
    }
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Cliente> list = [];
      var data = prefs.getString('listCliente');

      if (data != null) {
        var objs = jsonDecode(data) as List;
        list = objs.map((obj) => Cliente.fromJson(obj)).toList();
      }

      _cliente = Cliente.fromNomeDescricao(
          _nomeController.text, _telefoneController.text);

      if ((_index != -1) && (_index != null)) {
        list[_index] = _cliente;
        prefs.setString('listCliente', jsonEncode(list));
        Navigator.pop(context);
      } else {
        list.add(_cliente);
        prefs.setString('listCliente', jsonEncode(list));
        _index == -1 ?
          Navigator.pop(context) : showAlertDialog(context);
      }
    }
  }

  showAlertDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cadastro realizado com sucesso!', style: TextStyle(fontSize: 17),),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: (){
                  _nomeController.clear();
                  _telefoneController.clear();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de clientes'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                hintText: 'Nome',
                border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _telefoneController,
              inputFormatters: [
                maskDateFormatter
              ],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '(12)98163-5982',
                border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding:  const EdgeInsets.all(8.0),
            child: ButtonTheme(
              minWidth: double.infinity,
              child: RaisedButton(
                child: Text('Salvar', style: TextStyle(fontSize: 16.0)),
                color: Colors.blueGrey,
                textColor: Colors.white,
                onPressed: () => _saveItem(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
