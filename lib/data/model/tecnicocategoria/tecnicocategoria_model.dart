class TecnicoCategoriaModel {
  int? id;
  int? tecnico;
  int? categoria;
  String? categoriaNombre;
  String? tecnicoUsername;

  TecnicoCategoriaModel(
      {this.id,
      this.tecnico,
      this.categoria,
      this.categoriaNombre,
      this.tecnicoUsername});

  TecnicoCategoriaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tecnico = json['tecnico'];
    categoria = json['categoria'];
    categoriaNombre = json['categoria_nombre'];
    tecnicoUsername = json['tecnico_username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tecnico'] = this.tecnico;
    data['categoria'] = this.categoria;
    return data;
  }
}
