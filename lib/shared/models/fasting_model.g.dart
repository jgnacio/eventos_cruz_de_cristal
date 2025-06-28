// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fasting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FastingModel _$FastingModelFromJson(Map<String, dynamic> json) => FastingModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fechaInicio: json['fechaInicio'] == null
          ? null
          : DateTime.parse(json['fechaInicio'] as String),
      fechaFin: json['fechaFin'] == null
          ? null
          : DateTime.parse(json['fechaFin'] as String),
      iglesiaId: json['iglesiaId'] as String,
      status: $enumDecodeNullable(_$FastingStatusEnumMap, json['status']) ??
          FastingStatus.abierto,
      participantesPorDia:
          (json['participantesPorDia'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(
                    k, (e as List<dynamic>).map((e) => e as String).toList()),
              ) ??
              const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FastingModelToJson(FastingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      'fechaInicio': instance.fechaInicio?.toIso8601String(),
      'fechaFin': instance.fechaFin?.toIso8601String(),
      'iglesiaId': instance.iglesiaId,
      'status': _$FastingStatusEnumMap[instance.status]!,
      'participantesPorDia': instance.participantesPorDia,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$FastingStatusEnumMap = {
  FastingStatus.abierto: 'abierto',
  FastingStatus.cerrado: 'cerrado',
};

UserFastingAssignment _$UserFastingAssignmentFromJson(
        Map<String, dynamic> json) =>
    UserFastingAssignment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fastingId: json['fastingId'] as String,
      diasAsignados: (json['diasAsignados'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserFastingAssignmentToJson(
        UserFastingAssignment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fastingId': instance.fastingId,
      'diasAsignados': instance.diasAsignados,
      'createdAt': instance.createdAt.toIso8601String(),
    };
