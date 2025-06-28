import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel extends Equatable {
  final String id;
  final String titulo;
  final String mensaje;
  final NotificationType tipo;
  final String? targetId; // ID del evento, ayuno, etc.
  final String? iglesiaId;
  final List<String> destinatarios;
  final bool isGlobal;
  final DateTime fechaEnvio;
  final DateTime? fechaProgramada;
  final NotificationStatus status;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    this.targetId,
    this.iglesiaId,
    this.destinatarios = const [],
    this.isGlobal = false,
    required this.fechaEnvio,
    this.fechaProgramada,
    this.status = NotificationStatus.pendiente,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? titulo,
    String? mensaje,
    NotificationType? tipo,
    String? targetId,
    String? iglesiaId,
    List<String>? destinatarios,
    bool? isGlobal,
    DateTime? fechaEnvio,
    DateTime? fechaProgramada,
    NotificationStatus? status,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      tipo: tipo ?? this.tipo,
      targetId: targetId ?? this.targetId,
      iglesiaId: iglesiaId ?? this.iglesiaId,
      destinatarios: destinatarios ?? this.destinatarios,
      isGlobal: isGlobal ?? this.isGlobal,
      fechaEnvio: fechaEnvio ?? this.fechaEnvio,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titulo,
        mensaje,
        tipo,
        targetId,
        iglesiaId,
        destinatarios,
        isGlobal,
        fechaEnvio,
        fechaProgramada,
        status,
        createdAt,
      ];
}

@JsonEnum()
enum NotificationType {
  @JsonValue('evento_creado')
  eventoCreado,
  @JsonValue('recordatorio_evento')
  recordatorioEvento,
  @JsonValue('cambio_evento')
  cambioEvento,
  @JsonValue('ayuno_asignado')
  ayunoAsignado,
  @JsonValue('global')
  global,
}

@JsonEnum()
enum NotificationStatus {
  @JsonValue('pendiente')
  pendiente,
  @JsonValue('enviada')
  enviada,
  @JsonValue('fallida')
  fallida,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.eventoCreado:
        return 'Evento Creado';
      case NotificationType.recordatorioEvento:
        return 'Recordatorio de Evento';
      case NotificationType.cambioEvento:
        return 'Cambio en Evento';
      case NotificationType.ayunoAsignado:
        return 'Ayuno Asignado';
      case NotificationType.global:
        return 'Notificación Global';
    }
  }
}

extension NotificationStatusExtension on NotificationStatus {
  String get displayName {
    switch (this) {
      case NotificationStatus.pendiente:
        return 'Pendiente';
      case NotificationStatus.enviada:
        return 'Enviada';
      case NotificationStatus.fallida:
        return 'Fallida';
    }
  }
} 