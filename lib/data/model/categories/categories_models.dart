class CategoriesModel {
  int? id;
  String? nombre;

  CategoriesModel({this.id, this.nombre});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    return data;
  }
}
