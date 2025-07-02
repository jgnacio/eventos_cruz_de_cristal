// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_fasting_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserFastingRecord _$UserFastingRecordFromJson(Map<String, dynamic> json) =>
    UserFastingRecord(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fastingId: json['fastingId'] as String,
      dia: json['dia'] as String,
      fechaAyuno: DateTime.parse(json['fechaAyuno'] as String),
      confirmoParticipacion: json['confirmoParticipacion'] as bool? ?? false,
      fechaConfirmacion: json['fechaConfirmacion'] == null
          ? null
          : DateTime.parse(json['fechaConfirmacion'] as String),
      completoAyuno: json['completoAyuno'] as bool? ?? false,
      fechaCompletado: json['fechaCompletado'] == null
          ? null
          : DateTime.parse(json['fechaCompletado'] as String),
      notasUsuario: json['notasUsuario'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserFastingRecordToJson(UserFastingRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'fastingId': instance.fastingId,
      'dia': instance.dia,
      'fechaAyuno': instance.fechaAyuno.toIso8601String(),
      'confirmoParticipacion': instance.confirmoParticipacion,
      'fechaConfirmacion': instance.fechaConfirmacion?.toIso8601String(),
      'completoAyuno': instance.completoAyuno,
      'fechaCompletado': instance.fechaCompletado?.toIso8601String(),
      'notasUsuario': instance.notasUsuario,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

UserFastingStats _$UserFastingStatsFromJson(Map<String, dynamic> json) =>
    UserFastingStats(
      userId: json['userId'] as String,
      fastingId: json['fastingId'] as String,
      totalDiasAsignados: (json['totalDiasAsignados'] as num).toInt(),
      diasConfirmados: (json['diasConfirmados'] as num).toInt(),
      diasCompletados: (json['diasCompletados'] as num).toInt(),
      porcentajeCompletado: (json['porcentajeCompletado'] as num).toDouble(),
      ultimaConfirmacion: json['ultimaConfirmacion'] == null
          ? null
          : DateTime.parse(json['ultimaConfirmacion'] as String),
      ultimoAyunoCompletado: json['ultimoAyunoCompletado'] == null
          ? null
          : DateTime.parse(json['ultimoAyunoCompletado'] as String),
    );

Map<String, dynamic> _$UserFastingStatsToJson(UserFastingStats instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fastingId': instance.fastingId,
      'totalDiasAsignados': instance.totalDiasAsignados,
      'diasConfirmados': instance.diasConfirmados,
      'diasCompletados': instance.diasCompletados,
      'porcentajeCompletado': instance.porcentajeCompletado,
      'ultimaConfirmacion': instance.ultimaConfirmacion?.toIso8601String(),
      'ultimoAyunoCompletado':
          instance.ultimoAyunoCompletado?.toIso8601String(),
    };
