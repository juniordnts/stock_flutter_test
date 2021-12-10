import 'package:flutter/material.dart';

import 'home.dart';

const request =
    "https://api.hgbrasil.com/finance/stock_price?key=SUA-CHAVE&symbol=bidi4,petr4,qual3,ciel3";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Consulta de Ações'),
    );
  }
}
