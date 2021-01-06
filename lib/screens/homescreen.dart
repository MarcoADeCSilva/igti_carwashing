import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igti_carwashing/screens/agenda.dart';
import 'package:igti_carwashing/screens/agendar_servicos.dart';
import 'package:igti_carwashing/screens/cadastro_clientes.dart';
import 'package:igti_carwashing/screens/homeempresa.dart';
import 'package:igti_carwashing/screens/lista_clientes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final pageViewController = PageController();

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        children: [
          HomeEmpresa(),
          Cadastro_Clientes(),
          Agendar_Servicos(),
          Agenda(),
          Lista_Clientes()
        ],
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: pageViewController,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 40,
            backgroundColor: Colors.teal,
            currentIndex: pageViewController?.page?.round() ?? 0,
            onTap: (index) {
              pageViewController.jumpToPage(index);
              _currentIndex = pageViewController?.page?.round() ?? 0;
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: _currentIndex == 0 ? Colors.black : Colors.white),
                  title: Text('Home', style: TextStyle(color: _currentIndex == 0 ? Colors.black : Colors.white))
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_box, color: _currentIndex == 1 ? Colors.black : Colors.white),
                  title: Text('Adicionar', style: TextStyle(color: _currentIndex == 1 ? Colors.black : Colors.white))
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box, color: _currentIndex == 2 ? Colors.black : Colors.white),
                  title: Text('Serviços', style: TextStyle(color: _currentIndex == 2 ? Colors.black : Colors.white))
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment, color: _currentIndex == 3 ? Colors.black : Colors.white),
                  title: Text('Agenda', style: TextStyle(color: _currentIndex == 3 ? Colors.black : Colors.white))
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list, color: _currentIndex == 4 ? Colors.black : Colors.white),
                  title: Text('Clientes', style: TextStyle(color: _currentIndex == 4 ? Colors.black : Colors.white))
              )
            ]
          );
        }
      ),
    );
  }
}
