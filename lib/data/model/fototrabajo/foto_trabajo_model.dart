class FotoTrabajoModel {
  final int id;
  final int tecnico;
  final int categoria;
  final String urlFoto;

  FotoTrabajoModel({
    required this.id,
    required this.tecnico,
    required this.categoria,
    required this.urlFoto,
  });

  factory FotoTrabajoModel.fromJson(Map<String, dynamic> json) {
    return FotoTrabajoModel(
      id: json['id'],
      tecnico: json['tecnico'],
      categoria: json['categoria'],
      urlFoto: json['url_foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tecnico': tecnico,
      'categoria': categoria,
      'url_foto': urlFoto,
    };
  }
}