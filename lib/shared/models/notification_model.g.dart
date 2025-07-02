// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      titulo: json['titulo'] as String,
      mensaje: json['mensaje'] as String,
      tipo: $enumDecode(_$NotificationTypeEnumMap, json['tipo']),
      targetId: json['targetId'] as String?,
      iglesiaId: json['iglesiaId'] as String?,
      destinatarios: (json['destinatarios'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isGlobal: json['isGlobal'] as bool? ?? false,
      fechaEnvio: DateTime.parse(json['fechaEnvio'] as String),
      fechaProgramada: json['fechaProgramada'] == null
          ? null
          : DateTime.parse(json['fechaProgramada'] as String),
      status:
          $enumDecodeNullable(_$NotificationStatusEnumMap, json['status']) ??
              NotificationStatus.pendiente,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'mensaje': instance.mensaje,
      'tipo': _$NotificationTypeEnumMap[instance.tipo]!,
      'targetId': instance.targetId,
      'iglesiaId': instance.iglesiaId,
      'destinatarios': instance.destinatarios,
      'isGlobal': instance.isGlobal,
      'fechaEnvio': instance.fechaEnvio.toIso8601String(),
      'fechaProgramada': instance.fechaProgramada?.toIso8601String(),
      'status': _$NotificationStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.eventoCreado: 'evento_creado',
  NotificationType.recordatorioEvento: 'recordatorio_evento',
  NotificationType.cambioEvento: 'cambio_evento',
  NotificationType.ayunoAsignado: 'ayuno_asignado',
  NotificationType.confirmacionAyuno: 'confirmacion_ayuno',
  NotificationType.recordatorioAyuno: 'recordatorio_ayuno',
  NotificationType.global: 'global',
};

const _$NotificationStatusEnumMap = {
  NotificationStatus.pendiente: 'pendiente',
  NotificationStatus.enviada: 'enviada',
  NotificationStatus.fallida: 'fallida',
};
