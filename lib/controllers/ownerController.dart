// ignore_for_file: unused_field, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pass_vaccinal_verification/models/owner.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://127.0.0.1:7545";
  final String _wsUrl = "ws://127.0.0.1:7545";
  final String _privateKey =
      "de885a343bce86bd65dd898bd4e4fc1d64cd7c2e57dcba0db4aecdd397d39c9";

  late Web3Client _client;
  bool isLoading = true;
  List<Owner> owners = [];
  int ownerCount = 0;

  late String _abiCode;
  late EthereumAddress _contractAddress;

  late Credentials _credentials;

  late DeployedContract _contract;
  late ContractFunction _addOwner;
  late ContractFunction _owners;
  late ContractFunction _nbOwners;
  late ContractFunction _deleteOwner;
  late ContractFunction _verifyOwner;
  late ContractEvent _addedEvent;
  late ContractEvent _deletedEvent;
  late ContractEvent _verifyEvent;
  late String deployedName;

  ContractLinking() {
    initialSetup();
  }

  initialSetup() async {
    // establish a connection to the ethereum rpc node. The socketConnector
    // property allows more efficient event streams over websocket instead of
    // http-polls. However, the socketConnector property is experimental.
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    // Reading the contract abi
    String abiStringFile =
        await rootBundle.loadString("src/artifacts/Vaccination.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "Vaccination"), _contractAddress);

    // Extracting the functions, declared in contract.
    _nbOwners = _contract.function("nbOwners");
    _owners = _contract.function("owners");
    _addOwner = _contract.function("addOwner");
    _deleteOwner = _contract.function("deleteOwner");
    _verifyOwner = _contract.function("verifyOwner");
    _addedEvent = _contract.event("OwnerAdded");
    _deletedEvent = _contract.event("OwnerDeleted");
    _verifyEvent = _contract.event("OwnerVerified");

    getOwner();
  }

  getOwner() async {
    List ownerList = await _client
        .call(contract: _contract, function: _nbOwners, params: []);
    BigInt totalowner = ownerList[0];
    ownerCount = totalowner.toInt();
    owners.clear();
    for (int i = 0; i < ownerCount; i++) {
      var tmp = await _client.call(
          contract: _contract, function: _owners, params: [BigInt.from(i)]);
      if (tmp[1] != "") {
        owners.add(Owner(
          id: tmp[0].toString(),
          cin: tmp[1].toString(),
          fullName: tmp[2].toString(),
          qrHash: tmp[3].toString(),
          vaccine_name: tmp[4].toString(),
          nb_shots: tmp[5].toInt(),
        ));
      }
    }
    isLoading = false;
    notifyListeners();
  }

  addOwner(Owner owner) async {
    // Setting the name to nameToSet(name defined by user)
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _addOwner,
            parameters: [
              owner.cin,
              owner.fullName,
              owner.qrHash,
              owner.vaccine_name,
              owner.nb_shots
            ]));
    await getOwner();
  }

  deleteOwner(int id) async {
    isLoading = true;
    notifyListeners();
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _deleteOwner,
            parameters: [BigInt.from(id)]));

    await getOwner();
  }

  verifyOwner(String qr) async {
    isLoading = true;
    notifyListeners();

    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract, function: _verifyOwner, parameters: [qr]));
    await getOwner();
  }
}
