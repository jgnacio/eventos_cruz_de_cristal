import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/church_model.dart';
import '../../core/services/firestore_service.dart';

class ChurchRepository {
  static final ChurchRepository _instance = ChurchRepository._internal();
  factory ChurchRepository() => _instance;
  ChurchRepository._internal();

  final FirestoreService _firestoreService = FirestoreService();
  static const String _collection = 'churches';
  static const Uuid _uuid = Uuid();

  /// Crea una nueva iglesia
  Future<ChurchModel> createChurch(ChurchModel church) async {
    final churchWithId = church.copyWith(id: _uuid.v4());
    
    await _firestoreService.setDocument(
      _collection,
      churchWithId.id,
      churchWithId.toJson(),
    );
    
    return churchWithId;
  }

  /// Obtiene una iglesia por ID
  Future<ChurchModel?> getChurchById(String churchId) async {
    try {
      final doc = await _firestoreService.getDocument(_collection, churchId);
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return ChurchModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener iglesia: $e');
    }
  }

  /// Actualiza una iglesia existente
  Future<void> updateChurch(ChurchModel church) async {
    await _firestoreService.updateDocument(
      _collection,
      church.id,
      church.toJson(),
    );
  }

  /// Elimina una iglesia
  Future<void> deleteChurch(String churchId) async {
    await _firestoreService.deleteDocument(_collection, churchId);
  }

  /// Obtiene todas las iglesias aprobadas
  Future<List<ChurchModel>> getApprovedChurches() async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'isApproved', isEqualTo: true),
        ],
        orderBy: [
          QueryOrder('nombre'),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChurchModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener iglesias aprobadas: $e');
    }
  }

  /// Obtiene iglesias pendientes de aprobación
  Future<List<ChurchModel>> getPendingChurches() async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'isApproved', isEqualTo: false),
        ],
        orderBy: [
          QueryOrder('createdAt', descending: true),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChurchModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener iglesias pendientes: $e');
    }
  }

  /// Busca iglesias por nombre o ciudad
  Future<List<ChurchModel>> searchChurches(String query) async {
    try {
      // Búsqueda por nombre
      final nameQuery = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'nombre', isGreaterThanOrEqualTo: query),
          QueryFilter(field: 'nombre', isLessThan: query + '\uf8ff'),
          QueryFilter(field: 'isApproved', isEqualTo: true),
        ],
      );

      // Búsqueda por ciudad
      final cityQuery = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'ciudad', isGreaterThanOrEqualTo: query),
          QueryFilter(field: 'ciudad', isLessThan: query + '\uf8ff'),
          QueryFilter(field: 'isApproved', isEqualTo: true),
        ],
      );

      final Set<String> churchIds = {};
      final List<ChurchModel> churches = [];

      // Combinar resultados sin duplicados
      for (final doc in [...nameQuery.docs, ...cityQuery.docs]) {
        if (!churchIds.contains(doc.id)) {
          churchIds.add(doc.id);
          final data = doc.data() as Map<String, dynamic>;
          churches.add(ChurchModel.fromJson({
            'id': doc.id,
            ...data,
            'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
            'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          }));
        }
      }

      return churches;
    } catch (e) {
      throw Exception('Error al buscar iglesias: $e');
    }
  }

  /// Obtiene iglesias por ciudad
  Future<List<ChurchModel>> getChurchesByCity(String city) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'ciudad', isEqualTo: city),
          QueryFilter(field: 'isApproved', isEqualTo: true),
        ],
        orderBy: [
          QueryOrder('nombre'),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChurchModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener iglesias por ciudad: $e');
    }
  }

  /// Aprueba una iglesia
  Future<void> approveChurch(String churchId) async {
    await _firestoreService.updateDocument(
      _collection,
      churchId,
      {'isApproved': true},
    );
  }

  /// Rechaza/desaprueba una iglesia
  Future<void> rejectChurch(String churchId) async {
    await _firestoreService.updateDocument(
      _collection,
      churchId,
      {'isApproved': false},
    );
  }

  /// Obtiene todas las iglesias paginadas
  Future<List<ChurchModel>> getAllChurches({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestoreService.collection(_collection)
          .orderBy('nombre');
      
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      final querySnapshot = await query.limit(limit).get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChurchModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener iglesias: $e');
    }
  }

  /// Escucha cambios en una iglesia específica
  Stream<ChurchModel?> watchChurch(String churchId) {
    return _firestoreService.watchDocument(_collection, churchId).map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return ChurchModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    });
  }

  /// Escucha cambios en iglesias aprobadas
  Stream<List<ChurchModel>> watchApprovedChurches() {
    return _firestoreService.watchCollection(
      _collection,
      filters: [
        QueryFilter(field: 'isApproved', isEqualTo: true),
      ],
      orderBy: [
        QueryOrder('nombre'),
      ],
    ).map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChurchModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    });
  }
} 