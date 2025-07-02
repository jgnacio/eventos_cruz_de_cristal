import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/fasting_model.dart';
import '../../core/services/firestore_service.dart';

class FastingRepository {
  static final FastingRepository _instance = FastingRepository._internal();
  factory FastingRepository() => _instance;
  FastingRepository._internal();

  final FirestoreService _firestoreService = FirestoreService();
  static const String _collection = 'fastings';
  static const Uuid _uuid = Uuid();

  /// Crea un nuevo ayuno
  Future<FastingModel> createFasting(FastingModel fasting) async {
    final fastingWithId = fasting.copyWith(id: _uuid.v4());
    
    await _firestoreService.setDocument(
      _collection,
      fastingWithId.id,
      fastingWithId.toJson(),
    );
    
    return fastingWithId;
  }

  /// Obtiene un ayuno por ID
  Future<FastingModel?> getFastingById(String fastingId) async {
    try {
      final doc = await _firestoreService.getDocument(_collection, fastingId);
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return FastingModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener ayuno: $e');
    }
  }

  /// Actualiza un ayuno existente
  Future<void> updateFasting(FastingModel fasting) async {
    await _firestoreService.updateDocument(
      _collection,
      fasting.id,
      fasting.toJson(),
    );
  }

  /// Elimina un ayuno
  Future<void> deleteFasting(String fastingId) async {
    await _firestoreService.deleteDocument(_collection, fastingId);
  }

  /// Obtiene ayunos por iglesia
  Future<List<FastingModel>> getFastingsByChurch(String churchId) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'iglesiaId', isEqualTo: churchId),
        ],
        orderBy: [
          QueryOrder('createdAt', descending: true),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FastingModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener ayunos por iglesia: $e');
    }
  }

  /// Obtiene ayunos activos (abiertos)
  Future<List<FastingModel>> getActiveFastings() async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'status', isEqualTo: 'abierto'),
        ],
        orderBy: [
          QueryOrder('createdAt', descending: true),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return FastingModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener ayunos activos: $e');
    }
  }

  /// Agrega un participante a un día específico del ayuno
  Future<void> addParticipantToDay(String fastingId, String userId, String day) async {
    await _firestoreService.updateDocument(
      _collection,
      fastingId,
      {
        'participantesPorDia.$day': FieldValue.arrayUnion([userId]),
      },
    );
  }

  /// Remueve un participante de un día específico del ayuno
  Future<void> removeParticipantFromDay(String fastingId, String userId, String day) async {
    await _firestoreService.updateDocument(
      _collection,
      fastingId,
      {
        'participantesPorDia.$day': FieldValue.arrayRemove([userId]),
      },
    );
  }

  /// Cambia el estado de un ayuno
  Future<void> changeFastingStatus(String fastingId, FastingStatus status) async {
    await _firestoreService.updateDocument(
      _collection,
      fastingId,
      {'status': status.name},
    );
  }

  /// Escucha cambios en un ayuno específico
  Stream<FastingModel?> watchFasting(String fastingId) {
    return _firestoreService.watchDocument(_collection, fastingId).map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return FastingModel.fromJson({
          'id': doc.id,
          ...data,
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    });
  }
} 