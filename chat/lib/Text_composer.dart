import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {
  TextComposer(this.sendMassage);

  final Function({String text, File imagem}) sendMassage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  final TextEditingController _controller = TextEditingController();

  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async {
                final File img =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                if (img == null) {
                  return;
                } else {
                  return widget.sendMassage(imagem: img);
                }
              }),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration:
                  InputDecoration.collapsed(hintText: "Enviar Uma Mensagem"),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                widget.sendMassage(text: text);
                _controller.clear();
                _desabilitarBotaoEnviar();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing
                ? () {
                    widget.sendMassage(text: _controller.text);
                    _controller.clear();
                    _desabilitarBotaoEnviar();
                  }
                : null,
          ),
        ],
      ),
    );
  }

  void _desabilitarBotaoEnviar() {
    setState(() {
      _isComposing = false;
    });
  }

  // void _HabilitarBotaoEnviar() {
  //   setState(() {
  //     _isComposing = true;
  //   });
  // }
}
