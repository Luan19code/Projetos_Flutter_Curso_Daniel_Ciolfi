import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=543f8ec4";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    theme: ThemeData(
        hintColor: Color(0xfff4c430),
        primaryColor: Color(0xff96a5a9),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff96a5a9))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xfff4c430))),
          hintStyle: TextStyle(color: Color(0xfff4c430)),
        ))
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realControler = TextEditingController();
  final dolarControler = TextEditingController();
  final euroControler = TextEditingController();

  double dolar = 0;
  double euro = 0;

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarControler.text = (real/dolar).toStringAsFixed(2);
    euroControler.text = (real/euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realControler.text = (dolar * this.dolar).toStringAsFixed(2);
    euroControler.text = (dolar * this.dolar/euro).toStringAsFixed(2);

  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro_e = double.parse(text);
    realControler.text = (euro_e * euro).toStringAsFixed(2);
    dolarControler.text = (euro_e * euro/dolar).toStringAsFixed(2);
  }
  void _clearAll(){

    realControler.text = "";
    dolarControler.text = "";
    euroControler.text = "";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de Moedas \$"),
        backgroundColor: Color(0xff96a5a9),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text("Carregando Dados...",
                        style:
                            TextStyle(color: Color(0xfff4c430), fontSize: 30)));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Erro ao Carregar os Dados!",
                          style: TextStyle(
                              color: Color(0xfff4c430), fontSize: 30)));
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.attach_money,
                            size: 150, color: Color(0xff96a5a9)),
                        Divider(),
                        buildTextField("Reais", "R\$", realControler, _realChanged),
                        Divider(),
                        buildTextField("Dolares", "US\$", dolarControler, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroControler, _euroChanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController controller, Function function) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xfff4c430)),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Color(0xfff4c430), fontSize: 25),
    onChanged: function,
    keyboardType: TextInputType.number,
  );
}

