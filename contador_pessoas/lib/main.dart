import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<Home> {
  int _people = 0;
  String _infoText = "";

  void _chanePeople(int delta) {
    setState(() {
      _people += delta;
      if (_people >= 10) {
        _infoText = "Lotado";
        _people = 10;
      } else if (_people <= 0) {
        _infoText = "Ta cavando para baixo??";
        _people = 0;
      } else {
        _infoText = "Bem vindo! Pode Entrar";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "imagens/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                "pessoas: $_people",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FlatButton(
                    child: Text("+1",
                        style: TextStyle(fontSize: 40, color: Colors.red)),
                    onPressed: () {
                      _chanePeople(1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: FlatButton(
                    child: Text("-1",
                        style: TextStyle(fontSize: 40, color: Colors.red)),
                    onPressed: () {
                      _chanePeople(-1);
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                _infoText,
                style: TextStyle(
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                    fontSize: 30),
              )
            ),

          ],
        )
      ],
    );
  }
}
