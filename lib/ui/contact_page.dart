import 'dart:io';

import 'package:agenda_de_contatos/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum OrderOptions {orderaz,orderza}

class ContactPage extends StatefulWidget {
  final Contact? contact;
  ContactPage({this.contact});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final nameFocus = FocusNode();

  Contact? editedContact;
  bool userEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      editedContact = Contact();
    } else {
      editedContact = Contact.fromMap(widget.contact!.toMap());

      nameController.text = editedContact!.name!;
      emailController.text = editedContact!.email!;
      phoneController.text = editedContact!.phone!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editedContact!.name ?? "Novo Contato"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (editedContact?.name != null &&
                editedContact!.name!.isNotEmpty) {
              Navigator.pop(context, editedContact);
            } else {
              FocusScope.of(context).requestFocus(nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: editedContact!.img != null
                            ? FileImage(File(editedContact!.img!))
                            : const AssetImage("images/person.png")
                                as ImageProvider,
                      ),
                    ),
                  ),
                  onTap: () {
                    ImagePicker.platform
                        .pickImage(source: ImageSource.camera)
                        .then(
                      (file) {
                        if (file == null) {
                          return;
                        }
                        setState(() {
                          editedContact?.img = file.path;
                          print(file.path);
                        });
                      },
                    );
                  }),
              TextField(
                controller: nameController,
                focusNode: nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  userEdited = true;
                  setState(() {
                    editedContact?.name = text;
                  });
                },
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  userEdited = true;

                  editedContact?.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text) {
                  userEdited = true;

                  editedContact?.phone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> requestPop() {
    if (userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text('Se sair as alterações serão perdidas.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Sim'),
              ),
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
