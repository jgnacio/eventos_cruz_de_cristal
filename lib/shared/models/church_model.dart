import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'church_model.g.dart';

@JsonSerializable()
class ChurchModel extends Equatable {
  final String id;
  final String nombre;
  final String direccion;
  final String ciudad;
  final String? fotoUrl;
  final String email;
  final String telefono;
  final String administradorId;
  final List<String> asistentes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ChurchModel({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.ciudad,
    this.fotoUrl,
    required this.email,
    required this.telefono,
    required this.administradorId,
    this.asistentes = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory ChurchModel.fromJson(Map<String, dynamic> json) =>
      _$ChurchModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChurchModelToJson(this);

  ChurchModel copyWith({
    String? id,
    String? nombre,
    String? direccion,
    String? ciudad,
    String? fotoUrl,
    String? email,
    String? telefono,
    String? administradorId,
    List<String>? asistentes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChurchModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      administradorId: administradorId ?? this.administradorId,
      asistentes: asistentes ?? this.asistentes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get totalAsistentes => asistentes.length;

  @override
  List<Object?> get props => [
        id,
        nombre,
        direccion,
        ciudad,
        fotoUrl,
        email,
        telefono,
        administradorId,
        asistentes,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class ChurchRegistrationRequest extends Equatable {
  final String id;
  final String nombreIglesia;
  final String direccion;
  final String ciudad;
  final String? fotoUrl;
  final String emailContacto;
  final String telefonoContacto;
  final String solicitanteId;
  final ChurchRequestStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? motivoRechazo;

  const ChurchRegistrationRequest({
    required this.id,
    required this.nombreIglesia,
    required this.direccion,
    required this.ciudad,
    this.fotoUrl,
    required this.emailContacto,
    required this.telefonoContacto,
    required this.solicitanteId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.motivoRechazo,
  });

  factory ChurchRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$ChurchRegistrationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChurchRegistrationRequestToJson(this);

  ChurchRegistrationRequest copyWith({
    String? id,
    String? nombreIglesia,
    String? direccion,
    String? ciudad,
    String? fotoUrl,
    String? emailContacto,
    String? telefonoContacto,
    String? solicitanteId,
    ChurchRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? motivoRechazo,
  }) {
    return ChurchRegistrationRequest(
      id: id ?? this.id,
      nombreIglesia: nombreIglesia ?? this.nombreIglesia,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      emailContacto: emailContacto ?? this.emailContacto,
      telefonoContacto: telefonoContacto ?? this.telefonoContacto,
      solicitanteId: solicitanteId ?? this.solicitanteId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      motivoRechazo: motivoRechazo ?? this.motivoRechazo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombreIglesia,
        direccion,
        ciudad,
        fotoUrl,
        emailContacto,
        telefonoContacto,
        solicitanteId,
        status,
        createdAt,
        updatedAt,
        motivoRechazo,
      ];
}

@JsonEnum()
enum ChurchRequestStatus {
  @JsonValue('pendiente')
  pendiente,
  @JsonValue('aprobada')
  aprobada,
  @JsonValue('rechazada')
  rechazada,
}

extension ChurchRequestStatusExtension on ChurchRequestStatus {
  String get displayName {
    switch (this) {
      case ChurchRequestStatus.pendiente:
        return 'Pendiente';
      case ChurchRequestStatus.aprobada:
        return 'Aprobada';
      case ChurchRequestStatus.rechazada:
        return 'Rechazada';
    }
  }
} 