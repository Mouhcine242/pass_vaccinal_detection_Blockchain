// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotExisted extends StatefulWidget {
  const NotExisted({Key? key}) : super(key: key);

  @override
  _NotExistedState createState() => _NotExistedState();
}

class _NotExistedState extends State<NotExisted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),
            Icon(Icons.cancel_outlined, color: Colors.red, size: 100),
            SizedBox(
              height: 10,
            ),
            Text(
              "False Information",
              style: GoogleFonts.biryani(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
