import 'dart:io';
import 'package:chat/Text_composer.dart';
import 'package:chat/chatMessagem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String _nomeUser = "Usuário Padrão";
  final GoogleSignIn googleSign = GoogleSignIn();
  final GlobalKey<ScaffoldState> _saffoldKey = GlobalKey<ScaffoldState>();

  FirebaseUser _currentuser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      setState(() {
        _currentuser = user;
        _nomeUser = user.displayName;
      });
    });
  }

  Future<FirebaseUser> _getUser() async {
    if (_currentuser != null) {
      return _currentuser;
    }
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSign.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult autResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final FirebaseUser user = autResult.user;

      return user;
    } catch (e) {
      _showDialog(erro: e);
      return null;
    }
  }

  void _sendMessage({String text, File imagem}) async {
    try {
      final FirebaseUser user = await _getUser();

      if (user == null) {
        _saffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Não Foi Possível realizar o login Tente Novamente!"),
          backgroundColor: Colors.red,
        ));
      }

      Map<String, dynamic> data = {
        "uid": user.uid,
        "senderName": user.displayName,
        "SendFoto": user.photoUrl,
        "time": Timestamp.now()
      };
      setState(() {
        _nomeUser = data["senderName"];
      });

      if (imagem != null) {
        StorageUploadTask task = FirebaseStorage.instance
            .ref()
            .child(user.uid + DateTime.now().millisecondsSinceEpoch.toString())
            .putFile(imagem);

        setState(() {
          _isLoading = true;
        });
        StorageTaskSnapshot taskSnapshot = await task.onComplete;
        String url = await taskSnapshot.ref.getDownloadURL();
        data["imgUrl"] = url;
        Firestore.instance.collection("messages").add(data);

        setState(() {
          _isLoading = false;
        });
      }

      if (text != null) {
        data["text"] = text;
        Firestore.instance.collection("messages").add(data);
      }
    } catch (e) {
      _showDialog(erro: e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _saffoldKey,
      appBar: AppBar(
        title: Text(_nomeUser),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          _currentuser != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    googleSign.signOut();
                    _saffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(
                        "Você Saiu!",
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.green,
                    ));
                    setState(() {});
                  })
              : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          _currentuser != null
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("messages")
                        .orderBy("time")
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          List<DocumentSnapshot> documents =
                              snapshot.data.documents.reversed.toList();

                          return ListView.builder(
                            itemCount: documents.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return ChatMassage(
                                documents[index].data,
                                documents[index].data["uid"] ==
                                    _currentuser?.uid,
                              );
                            },
                          );
                      }
                    },
                  ),
                )
              : Expanded(
                  child: Container(),
                ),
          _isLoading ? CircularProgressIndicator() : Container(),
          TextComposer(_sendMessage)
        ],
      ),
    );
  }

  void _showDialog({dynamic erro}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Alert Dialog titulo"),
          content: new Text(erro),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
