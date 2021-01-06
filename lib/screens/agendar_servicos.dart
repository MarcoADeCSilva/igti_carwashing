import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:igti_carwashing/models/cliente.dart';
import 'package:igti_carwashing/models/servico.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Agendar_Servicos extends StatefulWidget {
  @override
  _Agendar_ServicosState createState() => _Agendar_ServicosState();
}

class _Agendar_ServicosState extends State<Agendar_Servicos> {
  final key = GlobalKey<ScaffoldState>();
  Servico _servicoModel;
  String _itemSelecionado;
  List<Cliente> list = [];
  List <String>_newlist = [];
  DateTime selectedDate = DateTime.now();
  String _time = "Not select";
  int _servico;

  void _dropDownItemSelected(String novoItem){
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }

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
        list.forEach((element) {
          _newlist.add(element.nome);
        });
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final DateTime picked = await DatePicker.showTimePicker(context,
        theme: DatePickerTheme(
          containerHeight: 210.0,
        ),
        showTitleActions: true, onConfirm: (time) {
          print('confirm $time');
          _time = '${time.hour} : ${time.minute} : ${time.second}';
          setState(() {});
        }, currentTime: DateTime.now(), locale: LocaleType.pt);

    if (picked != null && picked != _time)
      setState(() {
      });
  }

  _saveItem() async {
    if(_itemSelecionado.isEmpty || selectedDate == null || _time.isEmpty || _servico == null){
      key.currentState.showSnackBar(SnackBar(
          content: Text('Todos os dados são obrigatórios!')
      ));
    }
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Servico> listServico = [];
      var data = prefs.getString('listServico');

      if (data != null) {
        var objs = jsonDecode(data) as List;
        listServico = objs.map((obj) => Servico.fromJson(obj)).toList();
      }

      _servicoModel = Servico.fromClienteServico(
          _itemSelecionado, selectedDate.toString(), _time, _servico);

      debugPrint(_servicoModel.toString());

      listServico.add(_servicoModel);
      prefs.setString('listServico', jsonEncode(listServico));
      showAlertDialog(context);
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
        title: Text('Agendar serviços'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  alignment: Alignment.center,
                  child: DropdownButton<String>(
                    hint: Text('Selecione o cliente'),
                    items : _newlist.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: ( String novoItemSelecionado) {
                    _dropDownItemSelected(novoItemSelecionado);
                    setState(() {
                      this._itemSelecionado =  novoItemSelecionado;
                    });
                  },
                  value: _itemSelecionado
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.calendar_today),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("${selectedDate.toLocal()}".split(' ')[0], style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          onPressed: () => _selectDate(context),
                          child: Text('Selecione a data'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.access_time),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("$_time", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RaisedButton(
                          onPressed: () => _selectTime(context),
                          child: Text('Selecione a hora'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Serviço:', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _servico,
                      onChanged:(value) {
                        setState(() {
                          _servico = value;
                        });
                      },
                    ),
                    Text('Lavagem Simples', style: TextStyle(fontSize: 17.0))
                  ],
                )
              ),
              Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _servico,
                        onChanged:(value) {
                          setState(() {
                            _servico = value;
                          });
                        },
                      ),
                      Text('Lavagem completa sem cera', style: TextStyle(fontSize: 17.0))
                    ],
                  )
              ),
              Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: _servico,
                        onChanged:(value) {
                          setState(() {
                            _servico = value;
                          });
                        },
                      ),
                      Text('Lavagem completa com cera', style: TextStyle(fontSize: 17.0))
                    ],
                  )
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
