// import 'dart:math';

// import 'package:tm1/data/model/categories/categories_models.dart';
// import 'package:tm1/data/model/district/district_model.dart';
// import 'package:tm1/data/model/user/user_model.dart';

// class TecnicoModel {
//   final UserModel usuario;
//   final int? usuarioId;
//   final double? calificacion;
//   final String? fechaVencimiento;
//   final bool suscripcionActiva;
//   final String? fechaInicioSuscripcion;
//   final String? fechaFinSuscripcion;
//   final String? mercadopagoPreferenceId;
//   final String? mercadopagoCollectorId;
//   final List<CategoriesModel> categorias;
//   final List<DistrictModel> distritos;
//   final List<dynamic> fotosTrabajos; 

//   TecnicoModel({
//     required this.usuario,
//     this.usuarioId,
//     this.calificacion,
//     this.fechaVencimiento,
//     required this.suscripcionActiva,
//     this.fechaInicioSuscripcion,
//     this.fechaFinSuscripcion,
//     this.mercadopagoPreferenceId,
//     this.mercadopagoCollectorId,
//     required this.categorias,
//     required this.distritos,
//     required this.fotosTrabajos,
//   });

//   factory TecnicoModel.fromJson(Map<String, dynamic> json) {
//     return TecnicoModel(
//       usuario: UserModel.fromJson(json['usuario']),
//       usuarioId: json['usuario']['id'],
//       calificacion: double.tryParse(json['calificacion']?.toString() ?? '0.0') ?? 0.0,
//       fechaVencimiento: json['fecha_vencimiento'],
//       suscripcionActiva: json['suscripcion_activa'] ?? false,
//       fechaInicioSuscripcion: json['fecha_inicio_suscripcion'],
//       fechaFinSuscripcion: json['fecha_fin_suscripcion'],
//       mercadopagoPreferenceId: json['mercadopago_preference_id'],
//       mercadopagoCollectorId: json['mercadopago_collector_id'],
//       categorias: (json['categorias'] as List<dynamic>?)?.map((e) => CategoriesModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
//       // categorias: json['categorias'] is List ? List<dynamic>.from(json['categorias']) : [],
//       // distritos: json['distritos'] is List ? List<dynamic>.from(json['distritos']) : [],
//       distritos: (json['distritos'] as List<dynamic>?)?.map((e) => DistrictModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
//       fotosTrabajos: json['fotos_trabajos'] is List ? List<dynamic>.from(json['fotos_trabajos']) : [],
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'usuario': usuario.toJson(), 
//       // usuario_id es redundante si envías el objeto usuario completo,
//       // pero se puede incluir si el backend lo espera así en alguna operación.
//       // 'usuario_id': usuario.id,
//       'calificacion': calificacion,
//       'fecha_vencimiento': fechaVencimiento,
//       'suscripcion_activa': suscripcionActiva,
//       'fecha_inicio_suscripcion': fechaInicioSuscripcion,
//       'fecha_fin_suscripcion': fechaFinSuscripcion,
//       'mercadopago_preference_id': mercadopagoPreferenceId,
//       'mercadopago_collector_id': mercadopagoCollectorId,
//       'categorias': categorias,
//       'distritos': distritos,
//       'fotos_trabajos': fotosTrabajos,
//     };
//   }

//   Map<String, dynamic> toJsonForPost() {
//     return {
//       'usuario_id': usuario.id,
//       // 'fecha_vencimiento': fechaVencimiento,
//     };
//   }
// }

// import 'dart:math';

import 'package:tm1/data/model/categories/categories_models.dart';
import 'package:tm1/data/model/district/district_model.dart';
import 'package:tm1/data/model/user/user_model.dart';

class TecnicoModel {
  final UserModel usuario;
  final int? usuarioId;
  final double? calificacion;
  final String? fechaVencimiento;
  final bool suscripcionActiva;
  final String? fechaInicioSuscripcion;
  final String? fechaFinSuscripcion;
  final String? mercadopagoPreferenceId;
  final String? mercadopagoCollectorId;
  final String? fotoPerfil; 
  final String? descripcion; 
  final List<CategoriesModel> categorias;
  final List<DistrictModel> distritos;
  final List<dynamic> fotosTrabajos;

  TecnicoModel({
    required this.usuario,
    this.usuarioId,
    this.calificacion,
    this.fechaVencimiento,
    required this.suscripcionActiva,
    this.fechaInicioSuscripcion,
    this.fechaFinSuscripcion,
    this.mercadopagoPreferenceId,
    this.mercadopagoCollectorId,
    this.fotoPerfil,
    this.descripcion,
    required this.categorias,
    required this.distritos,
    required this.fotosTrabajos,
  });

  factory TecnicoModel.fromJson(Map<String, dynamic> json) {
    return TecnicoModel(
      usuario: UserModel.fromJson(json['usuario']),
      usuarioId: json['usuario']['id'],
      calificacion: double.tryParse(json['calificacion']?.toString() ?? '0.0') ?? 0.0,
      fechaVencimiento: json['fecha_vencimiento'],
      suscripcionActiva: json['suscripcion_activa'] ?? false,
      fechaInicioSuscripcion: json['fecha_inicio_suscripcion'],
      fechaFinSuscripcion: json['fecha_fin_suscripcion'],
      mercadopagoPreferenceId: json['mercadopago_preference_id'],
      mercadopagoCollectorId: json['mercadopago_collector_id'],
      fotoPerfil: json['foto_perfil'],
      descripcion: json['descripcion'],
      categorias: (json['categorias'] as List<dynamic>?)?.map((e) => CategoriesModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      distritos: (json['distritos'] as List<dynamic>?)?.map((e) => DistrictModel.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      fotosTrabajos: json['fotos_trabajos'] is List ? List<dynamic>.from(json['fotos_trabajos']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'calificacion': calificacion,
      'fecha_vencimiento': fechaVencimiento,
      'suscripcion_activa': suscripcionActiva,
      'fecha_inicio_suscripcion': fechaInicioSuscripcion,
      'fecha_fin_suscripcion': fechaFinSuscripcion,
      'mercadopago_preference_id': mercadopagoPreferenceId,
      'mercadopago_collector_id': mercadopagoCollectorId,
      'foto_perfil': fotoPerfil,
      'descripcion': descripcion,
      'categorias': categorias.map((e) => e.toJson()).toList(),
      'distritos': distritos.map((e) => e.toJson()).toList(),
      'fotos_trabajos': fotosTrabajos,
    };
  }

  Map<String, dynamic> toJsonForPost() {
    return {
      'usuario_id': usuario.id,
      'foto_perfil': fotoPerfil,
      // You might want to include foto_perfil and descripcion here if they are part of the POST payload
      // 'foto_perfil': fotoPerfil,
      // 'descripcion': descripcion,
    };
  }
}