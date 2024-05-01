class DataModel {
  final String name, initial, fhint, shint;

  DataModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        initial = json['initial'],
        fhint = json['fhint'],
        shint = json['shint'];
}
