// ignore_for_file: non_constant_identifier_names

class Owner {
  final String id;
  final String cin;
  final String fullName;
  final String qrHash;
  final String vaccine_name;
  final int nb_shots;

  Owner(
      {required this.id,
      required this.cin,
      required this.fullName,
      required this.qrHash,
      required this.vaccine_name,
      required this.nb_shots});

  Owner.fromJson(
    Map<String, dynamic> json,
    this.nb_shots,
  )   : id = json['id'],
        cin = json['cin'],
        fullName = json['fullName'],
        qrHash = json['qrHash'],
        vaccine_name = json['vaccine_name'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "cin": cin,
        "fullName": fullName,
        "qrHash": qrHash,
      };
}
