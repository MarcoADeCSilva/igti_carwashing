import 'package:flutter/material.dart';

class HomeEmpresa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(70.0),
            child: Container(
              alignment: Alignment.center,
              child: Image.asset("assets/logo.png"),
            ),            
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset("assets/missao.png", height: 50.0, width: 200.0),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Ser conhecidos como especialistas em lavagem de carros, através de uma operação que proporcione confiabilidade e satifação nos serviços prestados.", style: TextStyle(fontSize: 16)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset("assets/visao.png", height: 50.0, width: 200.0),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Torna-se a maior e melhor rede de lavagem automotiva do Brasil, comprometidos com os valores e princípios éticos, lucratividade, responsabilidade social e geração de riquezas ao país.", style: TextStyle(fontSize: 16)),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset("assets/valores.png", height: 50.0, width: 200.0),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Contribuição positiva com a comunidade e o meio ambiente, respeito com os franqueados, fornecedores e concorrentes, reconhecimento que a rentabilidade é essencial para os negócios e paixão pelo que fazemos.", style: TextStyle(fontSize: 16)),            ),
          )
        ],
      ),
    );
  }
}
