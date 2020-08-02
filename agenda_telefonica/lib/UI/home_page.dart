import 'dart:io';

import 'package:agenda_telefonica/UI/Contact_page.dart';
import 'package:agenda_telefonica/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts = List();

  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();
    /*  Contact c = new Contact();
    c.name = "LUAN777";
    c.email = "Luandantas7@gmail.com";
    c.phone = "998627604";
    c.img = null;
    helper.saveContact(c); */

    _getAllContacts();
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
      default:
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return _contactCard(context, index);
        },
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          _showContactPage(contact: contacts[index]);
          // _showOption(context, index);
        },
        onLongPress: () {
          _showOption(context, index);
        },
        onDoubleTap: () {
          _showOption(context, index);
        },
        child:
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Padding(
            //         padding: EdgeInsets.only(right: 30),
            //         child: Container(
            //           width: 100,
            //           height: 100,
            //           decoration: BoxDecoration(
            //               shape: BoxShape.circle,
            //               image: DecorationImage(
            //                   image: contacts[index].img != null
            //                       ? FileImage(File(contacts[index].img))
            //                       : AssetImage("Imagens/perfil.jpg"),
            //                   fit: BoxFit.cover)),
            //         ),
            //       ),
            //       SizedBox(
            //         width: 160,
            //         child: Column(
            //           children: <Widget>[
            //             Text(
            //               contacts[index].name ?? "",
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //               textAlign: TextAlign.center,
            //             ),
            //             Text(
            //               contacts[index].email ?? "",
            //               style: TextStyle(
            //                 fontSize: 18,
            //               ),
            //             ),
            //             Text(
            //               contacts[index].phone ?? "",
            //               style: TextStyle(
            //                 fontSize: 18,
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            // ),

            ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img))
                        : AssetImage("Imagens/perfil.jpg"),
                    fit: BoxFit.cover)),
          ),
          title: Text(contacts[index].name ?? "",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
          contentPadding: EdgeInsets.only(left: 100),
          subtitle: Text(contacts[index].phone ?? "",
              style: TextStyle(
                fontSize: 15,
              )),
        ));
  }

  void _showOption(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                        padding: EdgeInsets.all(5),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        )),
                    FlatButton(
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 30),
                        )),
                    FlatButton(
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        )),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }
}
