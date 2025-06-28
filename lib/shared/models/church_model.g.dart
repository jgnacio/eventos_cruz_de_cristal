// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChurchModel _$ChurchModelFromJson(Map<String, dynamic> json) => ChurchModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String,
      ciudad: json['ciudad'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      email: json['email'] as String,
      telefono: json['telefono'] as String,
      administradorId: json['administradorId'] as String,
      asistentes: (json['asistentes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChurchModelToJson(ChurchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'direccion': instance.direccion,
      'ciudad': instance.ciudad,
      'fotoUrl': instance.fotoUrl,
      'email': instance.email,
      'telefono': instance.telefono,
      'administradorId': instance.administradorId,
      'asistentes': instance.asistentes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

ChurchRegistrationRequest _$ChurchRegistrationRequestFromJson(
        Map<String, dynamic> json) =>
    ChurchRegistrationRequest(
      id: json['id'] as String,
      nombreIglesia: json['nombreIglesia'] as String,
      direccion: json['direccion'] as String,
      ciudad: json['ciudad'] as String,
      fotoUrl: json['fotoUrl'] as String?,
      emailContacto: json['emailContacto'] as String,
      telefonoContacto: json['telefonoContacto'] as String,
      solicitanteId: json['solicitanteId'] as String,
      status: $enumDecode(_$ChurchRequestStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      motivoRechazo: json['motivoRechazo'] as String?,
    );

Map<String, dynamic> _$ChurchRegistrationRequestToJson(
        ChurchRegistrationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nombreIglesia': instance.nombreIglesia,
      'direccion': instance.direccion,
      'ciudad': instance.ciudad,
      'fotoUrl': instance.fotoUrl,
      'emailContacto': instance.emailContacto,
      'telefonoContacto': instance.telefonoContacto,
      'solicitanteId': instance.solicitanteId,
      'status': _$ChurchRequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'motivoRechazo': instance.motivoRechazo,
    };

const _$ChurchRequestStatusEnumMap = {
  ChurchRequestStatus.pendiente: 'pendiente',
  ChurchRequestStatus.aprobada: 'aprobada',
  ChurchRequestStatus.rechazada: 'rechazada',
};
