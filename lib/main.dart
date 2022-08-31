import 'package:agenda_de_contatos/helpers/contact_help.dart';
import 'package:agenda_de_contatos/ui/contact_page.dart';
import 'package:agenda_de_contatos/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ContactHelper().db;
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
