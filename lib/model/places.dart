class Places{
  int id;
  String name;
  String telefono;
  String urlface;

  Places({
    this.id,
    this.name,
    this.telefono,
    this.urlface
 });
 factory Places.fromJson(Map<String, dynamic> parsedJson){
    return Places(
      id: parsedJson['id'],
      name : parsedJson['name'],
      telefono : parsedJson ['telefono'],
      urlface : parsedJson ['Facebook']
    );
  }
}
