import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_fasting_record_model.g.dart';

@JsonSerializable()
class UserFastingRecord extends Equatable {
  final String id;
  final String userId;
  final String fastingId;
  final String dia; // lunes, martes, etc.
  final DateTime fechaAyuno; // fecha específica del ayuno
  final bool confirmoParticipacion; // confirmó que va a ayunar
  final DateTime? fechaConfirmacion; // cuándo confirmó
  final bool completoAyuno; // confirmó que ayunó
  final DateTime? fechaCompletado; // cuándo confirmó que ayunó
  final String? notasUsuario; // notas adicionales del usuario
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserFastingRecord({
    required this.id,
    required this.userId,
    required this.fastingId,
    required this.dia,
    required this.fechaAyuno,
    this.confirmoParticipacion = false,
    this.fechaConfirmacion,
    this.completoAyuno = false,
    this.fechaCompletado,
    this.notasUsuario,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserFastingRecord.fromJson(Map<String, dynamic> json) =>
      _$UserFastingRecordFromJson(json);

  Map<String, dynamic> toJson() => _$UserFastingRecordToJson(this);

  UserFastingRecord copyWith({
    String? id,
    String? userId,
    String? fastingId,
    String? dia,
    DateTime? fechaAyuno,
    bool? confirmoParticipacion,
    DateTime? fechaConfirmacion,
    bool? completoAyuno,
    DateTime? fechaCompletado,
    String? notasUsuario,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserFastingRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fastingId: fastingId ?? this.fastingId,
      dia: dia ?? this.dia,
      fechaAyuno: fechaAyuno ?? this.fechaAyuno,
      confirmoParticipacion: confirmoParticipacion ?? this.confirmoParticipacion,
      fechaConfirmacion: fechaConfirmacion ?? this.fechaConfirmacion,
      completoAyuno: completoAyuno ?? this.completoAyuno,
      fechaCompletado: fechaCompletado ?? this.fechaCompletado,
      notasUsuario: notasUsuario ?? this.notasUsuario,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Confirma que el usuario va a participar en el ayuno
  UserFastingRecord confirmarParticipacion() {
    return copyWith(
      confirmoParticipacion: true,
      fechaConfirmacion: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Marca que el usuario completó el ayuno
  UserFastingRecord marcarCompletado({String? notas}) {
    return copyWith(
      completoAyuno: true,
      fechaCompletado: DateTime.now(),
      notasUsuario: notas,
      updatedAt: DateTime.now(),
    );
  }

  /// Estado actual del registro
  FastingRecordStatus get status {
    if (completoAyuno) return FastingRecordStatus.completado;
    if (confirmoParticipacion) return FastingRecordStatus.confirmado;
    return FastingRecordStatus.pendiente;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        fastingId,
        dia,
        fechaAyuno,
        confirmoParticipacion,
        fechaConfirmacion,
        completoAyuno,
        fechaCompletado,
        notasUsuario,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class UserFastingStats extends Equatable {
  final String userId;
  final String fastingId;
  final int totalDiasAsignados;
  final int diasConfirmados;
  final int diasCompletados;
  final double porcentajeCompletado;
  final DateTime? ultimaConfirmacion;
  final DateTime? ultimoAyunoCompletado;

  const UserFastingStats({
    required this.userId,
    required this.fastingId,
    required this.totalDiasAsignados,
    required this.diasConfirmados,
    required this.diasCompletados,
    required this.porcentajeCompletado,
    this.ultimaConfirmacion,
    this.ultimoAyunoCompletado,
  });

  factory UserFastingStats.fromJson(Map<String, dynamic> json) =>
      _$UserFastingStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UserFastingStatsToJson(this);

  factory UserFastingStats.fromRecords(
    String userId,
    String fastingId,
    List<UserFastingRecord> records,
  ) {
    final totalDias = records.length;
    final confirmados = records.where((r) => r.confirmoParticipacion).length;
    final completados = records.where((r) => r.completoAyuno).length;
    
    final porcentaje = totalDias > 0 ? (completados / totalDias) * 100 : 0.0;
    
    final ultimaConfirmacion = records
        .where((r) => r.fechaConfirmacion != null)
        .map((r) => r.fechaConfirmacion!)
        .fold<DateTime?>(null, (prev, current) => 
            prev == null || current.isAfter(prev) ? current : prev);
    
    final ultimoCompletado = records
        .where((r) => r.fechaCompletado != null)
        .map((r) => r.fechaCompletado!)
        .fold<DateTime?>(null, (prev, current) => 
            prev == null || current.isAfter(prev) ? current : prev);

    return UserFastingStats(
      userId: userId,
      fastingId: fastingId,
      totalDiasAsignados: totalDias,
      diasConfirmados: confirmados,
      diasCompletados: completados,
      porcentajeCompletado: porcentaje,
      ultimaConfirmacion: ultimaConfirmacion,
      ultimoAyunoCompletado: ultimoCompletado,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fastingId,
        totalDiasAsignados,
        diasConfirmados,
        diasCompletados,
        porcentajeCompletado,
        ultimaConfirmacion,
        ultimoAyunoCompletado,
      ];
}

@JsonEnum()
enum FastingRecordStatus {
  @JsonValue('pendiente')
  pendiente,
  @JsonValue('confirmado')
  confirmado,
  @JsonValue('completado')
  completado,
}

extension FastingRecordStatusExtension on FastingRecordStatus {
  String get displayName {
    switch (this) {
      case FastingRecordStatus.pendiente:
        return 'Pendiente';
      case FastingRecordStatus.confirmado:
        return 'Confirmado';
      case FastingRecordStatus.completado:
        return 'Completado';
    }
  }

  String get description {
    switch (this) {
      case FastingRecordStatus.pendiente:
        return 'Esperando confirmación';
      case FastingRecordStatus.confirmado:
        return 'Confirmado para ayunar';
      case FastingRecordStatus.completado:
        return 'Ayuno completado';
    }
  }
} 