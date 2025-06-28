// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaFin: DateTime.parse(json['fechaFin'] as String),
      ubicacion: json['ubicacion'] as String,
      iglesiaId: json['iglesiaId'] as String,
      imagenUrl: json['imagenUrl'] as String?,
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.activo,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      'fechaInicio': instance.fechaInicio.toIso8601String(),
      'fechaFin': instance.fechaFin.toIso8601String(),
      'ubicacion': instance.ubicacion,
      'iglesiaId': instance.iglesiaId,
      'imagenUrl': instance.imagenUrl,
      'likes': instance.likes,
      'status': _$EventStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$EventStatusEnumMap = {
  EventStatus.activo: 'activo',
  EventStatus.historico: 'historico',
  EventStatus.cancelado: 'cancelado',
};
