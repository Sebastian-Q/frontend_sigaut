class CategoryModel {
  int id = 0;
  String name = "";
  String clave = "";
  String description = "";
  int? idUser;

  CategoryModel();

  CategoryModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        clave = json["clave"],
        description = json["description"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "clave": clave,
      "description": description
    };
  }

  Map<String, dynamic> toSaveMap() {
    return {
      "name": name,
      "clave": clave,
      "description": description,
      "idUser": idUser
    };
  }
}