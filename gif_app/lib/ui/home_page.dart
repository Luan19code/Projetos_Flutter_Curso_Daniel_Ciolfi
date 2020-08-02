import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gif_app/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    if (_search == null || _search.isEmpty) {
      response =
          await http.get("https://api.giphy.com/v1/gifs/trending?api_key="
          "WjdJvSJe4YnSAQDGJNQd55cFTwRKhcb6&limit=20&rating=g"
              );
//      "https://pixabay.com/api/?key=17465536-361be9e04a999b64a519483ff"
//      "https://api.giphy.com/v1/gifs/trending?api_key="
//          "WjdJvSJe4YnSAQDGJNQd55cFTwRKhcb6&limit=20&rating=g"
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=WjdJvSJe4Y"
          "nSAQDGJNQd55cFTwRKhcb6&q=$_search&limit=19&offset=$_offset&rating=g&lang=pt");
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"
            ),
//        "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"
//        "https://i2.wp.com/figure.superhentais.com/img/figure/52901.gif?v=1"
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 16),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
              onSubmitted: (texto) {
                setState(() {
                  _search = texto;
                  _offset = 0;

                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              // ignore: missing_return
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _creatGifTable(context, snapshot);
                    }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _creatGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.only(top: 10, left: 20, right: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == null || index < snapshot.data["data"].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"], fit: BoxFit.cover,),

              onTap: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> GigPage(snapshot.data["data"][index])));
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                onTap: (){
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        });
  }
}
