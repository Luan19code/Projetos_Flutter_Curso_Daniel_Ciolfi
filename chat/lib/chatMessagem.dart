// Text(documents[index].data["text"])

import 'package:flutter/material.dart';

class ChatMassage extends StatelessWidget {
  ChatMassage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          !mine
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(data["SendFoto"]),
                      ),
                      Padding(padding: EdgeInsets.all(1)),
                      Text(
                        data["senderName"],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          Expanded(
              child: Column(
            crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              data["imgUrl"] != null
                  ? Image.network(
                      data["imgUrl"],
                      width: 250,
                    )
                  : Text(
                      data["text"],
                      style: TextStyle(fontSize: 18),
                    ),
              // Text(
              //   data["senderName"],
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w800,
              //   ),
              // )
            ],
          ),
          ),
          mine
              ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(data["SendFoto"]),
                      ),
                      Padding(padding: EdgeInsets.all(1)),
                      Text(
                        data["senderName"],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  
}
