class Places {
  int id;
  String name;
  String telefono;
  String urlface;
  final List<String> comidas;
  Location cordenadas;

  Places(
      {this.id,
      this.name,
      this.telefono,
      this.urlface,
      this.comidas,
      this.cordenadas});
  factory Places.fromJson(Map<String, dynamic> parsedJson) {
    var comidastoConvert = parsedJson['comidas'];
    List<String> comidaslist = new List<String>.from(comidastoConvert);
    return Places(
        id: parsedJson['id'],
        name: parsedJson['name'],
        telefono: parsedJson['telefono'],
        urlface: parsedJson['Facebook'],
        comidas: comidaslist,
        cordenadas: Location.fromJson(parsedJson['cordenadas']));
  }
}

class Location {
  double lat;
  double long;
  Location({this.lat, this.long});
  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(lat: parsedJson['lat'], long: parsedJson['long']);
  }
}
