import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController weihtController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String _infoText = "";

  void _resetFields() {
    weihtController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "";
    });
  }

  void calculate() {
    setState(() {
      if (weihtController.text == "" || heightController.text == "") {
        _infoText = "Por favor Preencha os campos!!";
      } else {
        double weight = double.parse(weihtController.text);
        double height = double.parse(heightController.text) / 100;
        double imc = weight / (height * height);
        if (imc < 18.6) {
          _infoText = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
        } else if (imc >= 18.6 && imc < 24.9) {
          _infoText = "Peso Ideal (${imc.toStringAsPrecision(4)})";
        } else if (imc >= 24.9 && imc < 29.9) {
          _infoText = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
        } else if (imc >= 29.9 && imc < 34.9) {
          _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
        } else if (imc >= 34.9 && imc < 39.9) {
          _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
        } else if (imc >= 40) {
          _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Calculadora IMC"),
          centerTitle: true,
          backgroundColor: Colors.purple,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person, size: 150, color: Colors.grey),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Digite o peso",
                  hintStyle: TextStyle(color: Colors.purple, fontSize: 15),
                  labelText: "Peso (KG)",
                  labelStyle: TextStyle(color: Colors.purple, fontSize: 20),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 25),
                controller: weihtController,
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Digite o altura",
                  hintStyle: TextStyle(color: Colors.purple, fontSize: 15),
                  labelText: "altura (CM)",
                  labelStyle: TextStyle(color: Colors.purple, fontSize: 20),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 25),
                controller: heightController,
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    onPressed: calculate,
                    child: Text("Calcular",
                        style: TextStyle(color: Colors.purple, fontSize: 30)),
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple, fontSize: 30),
              )
            ],
          ),
        ));
  }
}
