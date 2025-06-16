class FotoSolicitudModel {
  final int? id;
  final int? solicitudId;
  final String? urlFoto;
  // final String? subidoEn;

  FotoSolicitudModel({
    this.id,
    this.solicitudId,
    this.urlFoto,
    // this.subidoEn,
  });

  factory FotoSolicitudModel.fromJson(Map<String, dynamic> json) {
    return FotoSolicitudModel(
      id: json['id'] as int?,
      solicitudId: json['solicitud'] as int?,
      urlFoto: json['url_foto'] as String?,
      // subidoEn: json['subido_en'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'solicitud': solicitudId, 
      'url_foto': urlFoto,
      // 'subido_en': subidoEn,
    };
  }
}