// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nombre: json['nombre'] as String,
      telefono: json['telefono'] as String,
      rol: $enumDecode(_$UserRoleEnumMap, json['rol']),
      isVerified: json['isVerified'] as bool? ?? false,
      isBanned: json['isBanned'] as bool? ?? false,
      iglesiasAsistidas: (json['iglesiasAsistidas'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nombre': instance.nombre,
      'telefono': instance.telefono,
      'rol': _$UserRoleEnumMap[instance.rol]!,
      'isVerified': instance.isVerified,
      'isBanned': instance.isBanned,
      'iglesiasAsistidas': instance.iglesiasAsistidas,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.administradorGlobal: 'administrador_global',
  UserRole.administradorIglesia: 'administrador_iglesia',
  UserRole.miembro: 'miembro',
};
