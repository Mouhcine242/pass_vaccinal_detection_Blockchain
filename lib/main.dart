// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pass_vaccinal_verification/pages/existedQr.dart';
import 'package:pass_vaccinal_verification/pages/mainPage.dart';
import 'package:provider/provider.dart';

import 'controllers/ownerController.dart';
import 'pages/notExistedQr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractLinking>(
        create: (_) => ContractLinking(),
        child: MaterialApp(
          initialRoute: 'main',
          routes: {
            'main': (context) => MainPage(),
            'existed': (context) => Existed(),
            "notExisted": (context) => NotExisted(),
          },
          debugShowCheckedModeBanner: false,
          title: "Verification of Vaccinal Pass",
          theme: ThemeData(
              primaryColor: Colors.cyan[400],
              accentColor: Colors.deepOrange[200]),
          home: MainPage(),
        ));
  }
}
