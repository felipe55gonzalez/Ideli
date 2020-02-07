class PlacesList{
  final List <Place> place;
  PlacesList({this.place});
  factory PlacesList.fromJson(List<dynamic> parsedJson){
    List<Place> places = new List<Place>();
    places=parsedJson.map((i)=> Place.fromJson(i)).toList();
    return new PlacesList(
      place : places
    );

  }
}

class Place {
  int id;
  String name;
  String telefono;
  String urlface;
  String urlimg;
  final List<String> comidas;
  Location cordenadas;

  Place(
      {this.id,
      this.name,
      this.telefono,
      this.urlface,
      this.urlimg,
      this.comidas,
      this.cordenadas});
  factory Place.fromJson(Map<String, dynamic> json) {
    var comidastoConvert = json['comidas'];
    List<String> comidaslist = new List<String>.from(comidastoConvert);
    return new Place(
        id: json['id'],
        name: json['name'],
        telefono: json['telefono'],
        urlface: json['Facebook'],
        urlimg: json['Img'],
        comidas: comidaslist,
        cordenadas: Location.fromJson(json['cordenadas']));
  }
}

class Location {
  double lat;
  double long;
  Location({this.lat, this.long});
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(lat: json['lat'], long: json['long']);
  }
}
