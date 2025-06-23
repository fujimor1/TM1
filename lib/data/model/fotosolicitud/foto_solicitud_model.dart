class FotoSolicitudModel {
  final int? id;
  final int? solicitudId;
  final String? urlFoto;

  FotoSolicitudModel({
    this.id,
    this.solicitudId,
    this.urlFoto,
  });

  factory FotoSolicitudModel.fromJson(Map<String, dynamic> json) {
    return FotoSolicitudModel(
      id: json['id'] as int?,
      solicitudId: json['solicitud'] as int?,
      urlFoto: json['url_foto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'solicitud': solicitudId, 
      'url_foto': urlFoto,
    };
  }
}