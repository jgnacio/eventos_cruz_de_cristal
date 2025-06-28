import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fasting_model.g.dart';

@JsonSerializable()
class FastingModel extends Equatable {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String iglesiaId;
  final FastingStatus status;
  final Map<String, List<String>> participantesPorDia; // día: [userId1, userId2]
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FastingModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.fechaInicio,
    this.fechaFin,
    required this.iglesiaId,
    this.status = FastingStatus.abierto,
    this.participantesPorDia = const {},
    required this.createdAt,
    this.updatedAt,
  });

  factory FastingModel.fromJson(Map<String, dynamic> json) =>
      _$FastingModelFromJson(json);

  Map<String, dynamic> toJson() => _$FastingModelToJson(this);

  FastingModel copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? iglesiaId,
    FastingStatus? status,
    Map<String, List<String>>? participantesPorDia,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FastingModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      iglesiaId: iglesiaId ?? this.iglesiaId,
      status: status ?? this.status,
      participantesPorDia: participantesPorDia ?? this.participantesPorDia,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int getParticipantesForDay(String day) {
    return participantesPorDia[day]?.length ?? 0;
  }

  bool hasUserForDay(String userId, String day) {
    return participantesPorDia[day]?.contains(userId) ?? false;
  }

  List<String> getAvailableDays() {
    return [
      'lunes',
      'martes',
      'miercoles',
      'jueves',
      'viernes',
      'sabado',
      'domingo'
    ];
  }

  @override
  List<Object?> get props => [
        id,
        titulo,
        descripcion,
        fechaInicio,
        fechaFin,
        iglesiaId,
        status,
        participantesPorDia,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class UserFastingAssignment extends Equatable {
  final String id;
  final String userId;
  final String fastingId;
  final List<String> diasAsignados;
  final DateTime createdAt;

  const UserFastingAssignment({
    required this.id,
    required this.userId,
    required this.fastingId,
    required this.diasAsignados,
    required this.createdAt,
  });

  factory UserFastingAssignment.fromJson(Map<String, dynamic> json) =>
      _$UserFastingAssignmentFromJson(json);

  Map<String, dynamic> toJson() => _$UserFastingAssignmentToJson(this);

  UserFastingAssignment copyWith({
    String? id,
    String? userId,
    String? fastingId,
    List<String>? diasAsignados,
    DateTime? createdAt,
  }) {
    return UserFastingAssignment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fastingId: fastingId ?? this.fastingId,
      diasAsignados: diasAsignados ?? this.diasAsignados,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        fastingId,
        diasAsignados,
        createdAt,
      ];
}

@JsonEnum()
enum FastingStatus {
  @JsonValue('abierto')
  abierto,
  @JsonValue('cerrado')
  cerrado,
}

extension FastingStatusExtension on FastingStatus {
  String get displayName {
    switch (this) {
      case FastingStatus.abierto:
        return 'Abierto';
      case FastingStatus.cerrado:
        return 'Cerrado';
    }
  }
} 