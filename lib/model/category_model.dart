class Category {
  int id = 0;
  String name = "";
  String clave = "";
  String description = "";

  Category();

  Category.fromJson(Map<String, dynamic> json)
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
}