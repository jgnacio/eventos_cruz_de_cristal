import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../core/services/firestore_service.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final FirestoreService _firestoreService = FirestoreService();
  static const String _collection = 'users';

  /// Crea un nuevo usuario en Firestore
  Future<void> createUser(UserModel user) async {
    await _firestoreService.setDocument(
      _collection,
      user.id,
      user.toJson(),
    );
  }

  /// Obtiene un usuario por ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestoreService.getDocument(_collection, userId);
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener usuario: $e');
    }
  }

  /// Actualiza un usuario existente
  Future<void> updateUser(UserModel user) async {
    await _firestoreService.updateDocument(
      _collection,
      user.id,
      user.toJson(),
    );
  }

  /// Elimina un usuario
  Future<void> deleteUser(String userId) async {
    await _firestoreService.deleteDocument(_collection, userId);
  }

  /// Obtiene usuarios por rol
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'rol', isEqualTo: role.name),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios por rol: $e');
    }
  }

  /// Obtiene usuarios por iglesia
  Future<List<UserModel>> getUsersByChurch(String churchId) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'iglesiasAsistidas', arrayContains: churchId),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios por iglesia: $e');
    }
  }

  /// Busca usuarios por nombre o email
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      // Búsqueda por nombre
      final nameQuery = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'nombre', isGreaterThanOrEqualTo: query),
          QueryFilter(field: 'nombre', isLessThan: query + '\uf8ff'),
        ],
      );

      // Búsqueda por email
      final emailQuery = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'email', isGreaterThanOrEqualTo: query),
          QueryFilter(field: 'email', isLessThan: query + '\uf8ff'),
        ],
      );

      final Set<String> userIds = {};
      final List<UserModel> users = [];

      // Combinar resultados sin duplicados
      for (final doc in [...nameQuery.docs, ...emailQuery.docs]) {
        if (!userIds.contains(doc.id)) {
          userIds.add(doc.id);
          final data = doc.data() as Map<String, dynamic>;
          users.add(UserModel.fromJson({
            'id': doc.id,
            ...data,
            'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
            'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          }));
        }
      }

      return users;
    } catch (e) {
      throw Exception('Error al buscar usuarios: $e');
    }
  }

  /// Obtiene todos los usuarios paginados
  Future<List<UserModel>> getAllUsers({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestoreService.collection(_collection);
      
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      final querySnapshot = await query.limit(limit).get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  /// Agrega una iglesia a la lista de iglesias asistidas del usuario
  Future<void> addChurchToUser(String userId, String churchId) async {
    await _firestoreService.updateDocument(
      _collection,
      userId,
      {
        'iglesiasAsistidas': FieldValue.arrayUnion([churchId]),
      },
    );
  }

  /// Remueve una iglesia de la lista de iglesias asistidas del usuario
  Future<void> removeChurchFromUser(String userId, String churchId) async {
    await _firestoreService.updateDocument(
      _collection,
      userId,
      {
        'iglesiasAsistidas': FieldValue.arrayRemove([churchId]),
      },
    );
  }

  /// Verifica el email del usuario
  Future<void> verifyUserEmail(String userId) async {
    await _firestoreService.updateDocument(
      _collection,
      userId,
      {'isVerified': true},
    );
  }

  /// Banea o desbanea un usuario
  Future<void> toggleUserBan(String userId, bool isBanned) async {
    await _firestoreService.updateDocument(
      _collection,
      userId,
      {'isBanned': isBanned},
    );
  }

  /// Escucha cambios en un usuario específico
  Stream<UserModel?> watchUser(String userId) {
    return _firestoreService.watchDocument(_collection, userId).map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    });
  }

  /// Escucha cambios en usuarios de una iglesia
  Stream<List<UserModel>> watchUsersByChurch(String churchId) {
    return _firestoreService.watchCollection(
      _collection,
      filters: [
        QueryFilter(field: 'iglesiasAsistidas', arrayContains: churchId),
      ],
    ).map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    });
  }
} 