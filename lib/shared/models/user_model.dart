import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String nombre;
  final String telefono;
  final UserRole rol;
  final bool isVerified;
  final bool isBanned;
  final List<String> iglesiasAsistidas;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.nombre,
    required this.telefono,
    required this.rol,
    this.isVerified = false,
    this.isBanned = false,
    this.iglesiasAsistidas = const [],
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? nombre,
    String? telefono,
    UserRole? rol,
    bool? isVerified,
    bool? isBanned,
    List<String>? iglesiasAsistidas,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      isVerified: isVerified ?? this.isVerified,
      isBanned: isBanned ?? this.isBanned,
      iglesiasAsistidas: iglesiasAsistidas ?? this.iglesiasAsistidas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        nombre,
        telefono,
        rol,
        isVerified,
        isBanned,
        iglesiasAsistidas,
        createdAt,
        updatedAt,
      ];
}

@JsonEnum()
enum UserRole {
  @JsonValue('administrador_global')
  administradorGlobal,
  @JsonValue('administrador_iglesia')
  administradorIglesia,
  @JsonValue('miembro')
  miembro,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.administradorGlobal:
        return 'Administrador Global';
      case UserRole.administradorIglesia:
        return 'Administrador de Iglesia';
      case UserRole.miembro:
        return 'Miembro';
    }
  }

  String get abbreviation {
    switch (this) {
      case UserRole.administradorGlobal:
        return 'AG';
      case UserRole.administradorIglesia:
        return 'AI';
      case UserRole.miembro:
        return 'M';
    }
  }
} 