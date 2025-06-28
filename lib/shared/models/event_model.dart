import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel extends Equatable {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String ubicacion;
  final String iglesiaId;
  final String? imagenUrl;
  final List<String> likes;
  final EventStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const EventModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fechaInicio,
    required this.fechaFin,
    required this.ubicacion,
    required this.iglesiaId,
    this.imagenUrl,
    this.likes = const [],
    this.status = EventStatus.activo,
    required this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  EventModel copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? ubicacion,
    String? iglesiaId,
    String? imagenUrl,
    List<String>? likes,
    EventStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      ubicacion: ubicacion ?? this.ubicacion,
      iglesiaId: iglesiaId ?? this.iglesiaId,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      likes: likes ?? this.likes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get totalLikes => likes.length;

  bool hasUserLiked(String userId) => likes.contains(userId);

  bool get isFutureEvent => fechaInicio.isAfter(DateTime.now());

  bool get isPastEvent => fechaFin.isBefore(DateTime.now());

  Duration get timeUntilStart => fechaInicio.difference(DateTime.now());

  @override
  List<Object?> get props => [
        id,
        titulo,
        descripcion,
        fechaInicio,
        fechaFin,
        ubicacion,
        iglesiaId,
        imagenUrl,
        likes,
        status,
        createdAt,
        updatedAt,
      ];
}

@JsonEnum()
enum EventStatus {
  @JsonValue('activo')
  activo,
  @JsonValue('historico')
  historico,
  @JsonValue('cancelado')
  cancelado,
}

extension EventStatusExtension on EventStatus {
  String get displayName {
    switch (this) {
      case EventStatus.activo:
        return 'Activo';
      case EventStatus.historico:
        return 'Histórico';
      case EventStatus.cancelado:
        return 'Cancelado';
    }
  }
} 