import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyItemList {
  String symbol;
  String name;
  double price;

  MyItemList({required this.symbol, required this.name, required this.price});
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MyItemList> stocks = [];
  final _formKey = GlobalKey<FormState>();
  final textField = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textField.dispose();
    super.dispose();
  }

  Future<bool> _searchStock() async {
    var code = textField.text.toUpperCase();
    var request =
        "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$code&apikey=O7R3JC8ZA81913RU";

    http.Response response = await http.get(Uri.parse(request));
    Map<String, dynamic> result = json.decode(response.body);

    if (result.containsKey('Information') ||
        result.containsKey('Error Message')) {
      return true;
      // _error = true;
      // setState(() {
      //   _error;
      // });
    } else {
      stocks.add(MyItemList(
          symbol: result['Meta Data']['2. Symbol'],
          name: result['Meta Data']['2. Symbol'],
          price: double.parse(
              result['Time Series (Daily)']['2021-12-09']['4. close'])));

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   shape: const CircularNotchedRectangle(),
      //   child: Container(height: 50.0),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => setState(() {}),
      //   tooltip: 'Increment Counter',
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Center(
        child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Somentes ações da NYSE. Ex.: IBM, AAPL'),
                    TextFormField(
                      controller: textField,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Esse campo não pode ser vazio';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _searchStock().then((res) => {
                                if (res)
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Acão não encontrada')))
                                  }
                                else
                                  {
                                    setState(() {
                                      stocks;
                                    })
                                  }
                              });
                        }
                      },
                      child: const Text('Pesquisar'),
                    ),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: stocks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: Key(stocks[index].symbol),
                            child: Card(
                              child: ListTile(
                                leading: const FlutterLogo(),
                                title: Text(stocks[index].name),
                                subtitle: Text('US \$ ${stocks[index].price}'),
                                trailing: const Icon(Icons.delete),
                                onTap: () {
                                  stocks.removeAt(index);
                                  setState(() {
                                    stocks;
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                  ],
                ))),
      ),
    );
  }
}
