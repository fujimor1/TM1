class DistritoTecnicoModel {
  final int tecnicoId;
  final int distritoId;
  final String? distritoNombre;
  final String? tecnicoUsername;

  DistritoTecnicoModel({
    required this.tecnicoId,
    required this.distritoId,
    this.distritoNombre,
    this.tecnicoUsername,
  });

  factory DistritoTecnicoModel.fromJson(Map<String, dynamic> json) {
    return DistritoTecnicoModel(
      tecnicoId: json['tecnico'],
      distritoId: json['distrito'],
      distritoNombre: json['distrito_nombre'],
      tecnicoUsername: json['tecnico_username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tecnico': tecnicoId,
      'distrito': distritoId,
    };
  }
}