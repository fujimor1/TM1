import 'package:tm1/data/model/categories/categories_models.dart';
import 'package:tm1/data/model/fotosolicitud/foto_solicitud_model.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/data/model/user/user_model.dart'; 

class SolicitudModel {
  final int id;
  final UserModel cliente;
  final TecnicoModel? tecnico;
  final CategoriesModel categoria;
  final String direccion;
  final String titulo;
  final String descripcion;
  final String estado;
  final double? calificacion;
  final String creadoEn;
  final String actualizadoEn;
  final List<FotoSolicitudModel> fotosSolicitud;

  SolicitudModel({
    required this.id,
    required this.cliente,
    this.tecnico,
    required this.categoria,
    required this.direccion,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    this.calificacion,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.fotosSolicitud,
  });

  factory SolicitudModel.fromJson(Map<String, dynamic> json) {
    return SolicitudModel(
      id: json['id'] as int,
      cliente: UserModel.fromJson(json['cliente'] as Map<String, dynamic>),
      tecnico: json['tecnico'] != null
          ? TecnicoModel.fromJson(json['tecnico'] as Map<String, dynamic>)
          : null,
      categoria: CategoriesModel.fromJson(json['categoria'] as Map<String, dynamic>),
      direccion: json['direccion'] as String,
      titulo: json['titulo'] as String, 
      descripcion: json['descripcion'] as String, 
      estado: json['estado'] as String,
      calificacion: (json['calificacion'] as num?)?.toDouble(),
      creadoEn: json['creado_en'] as String,
      actualizadoEn: json['actualizado_en'] as String,
      fotosSolicitud: (json['fotos_solicitud'] as List<dynamic>?)?.map((e) => FotoSolicitudModel.fromJson(e as Map<String, dynamic>)).toList() ?? [], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente': cliente.toJson(),
      'tecnico': tecnico?.toJson(),
      'categoria': categoria.toJson(),
      'direccion': direccion,
      'titulo': titulo,
      'descripcion': descripcion,
      'estado': estado,
      'calificacion': calificacion,
      'creado_en': creadoEn,
      'actualizado_en': actualizadoEn,
      'fotos_solicitud': fotosSolicitud.map((e) => e.toJson()).toList(),
    };
  }
}