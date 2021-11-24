// ignore_for_file: file_names, prefer_const_constructors

import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pass_vaccinal_verification/controllers/ownerController.dart';
import 'package:pass_vaccinal_verification/pages/existedQr.dart';
import 'package:pass_vaccinal_verification/pages/notExistedQr.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController nationalidentitytextEditingController =
      TextEditingController();
  TextEditingController fullNametextEditingController = TextEditingController();
  String qrCodeResult = "Not Yet Scanned";
  @override
  Widget build(BuildContext context) {
    var contractLink = Provider.of<ContractLinking>(context, listen: true);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              HexColor("#2980B9"),
              HexColor("#6DD5FA"),
              HexColor("#FFFFFF")
            ],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                Text("Verify The Vaccination Pass",
                    style: GoogleFonts.biryani(
                      fontSize: 24,
                    )),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nationalidentitytextEditingController,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                            labelText: "Enter your national identity",
                            labelStyle: const TextStyle(fontSize: 14),
                            hintStyle: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      TextFormField(
                        controller: fullNametextEditingController,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                            labelText: "Enter your Full Name",
                            labelStyle: const TextStyle(fontSize: 14),
                            // ignore: prefer_const_constructors
                            hintStyle: const TextStyle(
                                fontSize: 10, color: Colors.grey)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          String codeSanner =
                              await BarcodeScanner.scan(); //barcode scanner
                          setState(() {
                            qrCodeResult = codeSanner;
                            contractLink.owners.forEach((owner) {
                              if (contractLink.verifyOwner(qrCodeResult) &&
                                  owner.cin ==
                                      nationalidentitytextEditingController.text
                                          .toString() &&
                                  fullNametextEditingController.text
                                          .toString() ==
                                      owner.fullName) {
                                Navigator.pushNamed(context, 'existed');
                              }
                              Navigator.pushNamed(context, 'notExisted');
                            });
                          });
                          Navigator.pushNamed(context, 'notExisted');
                          fullNametextEditingController.clear();
                          nationalidentitytextEditingController.clear();
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              "Scann QR code",
                              style: GoogleFonts.biryani(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
