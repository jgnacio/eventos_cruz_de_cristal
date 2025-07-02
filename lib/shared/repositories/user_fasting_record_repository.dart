import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/user_fasting_record_model.dart';
import '../../core/services/firestore_service.dart';

class UserFastingRecordRepository {
  static final UserFastingRecordRepository _instance = UserFastingRecordRepository._internal();
  factory UserFastingRecordRepository() => _instance;
  UserFastingRecordRepository._internal();

  final FirestoreService _firestoreService = FirestoreService();
  static const String _collection = 'user_fasting_records';
  static const Uuid _uuid = Uuid();

  /// Crea un nuevo registro de ayuno
  Future<UserFastingRecord> createRecord(UserFastingRecord record) async {
    final recordWithId = record.copyWith(id: _uuid.v4());
    
    await _firestoreService.setDocument(
      _collection,
      recordWithId.id,
      recordWithId.toJson(),
    );
    
    return recordWithId;
  }

  /// Crea múltiples registros de ayuno (para cuando el usuario se asigna a varios días)
  Future<List<UserFastingRecord>> createMultipleRecords(List<UserFastingRecord> records) async {
    final recordsWithId = records.map((record) => record.copyWith(id: _uuid.v4())).toList();
    
    final operations = recordsWithId.map((record) => BatchOperation(
      type: BatchOperationType.set,
      collectionName: _collection,
      documentId: record.id,
      data: record.toJson(),
    )).toList();

    await _firestoreService.batch(operations);
    return recordsWithId;
  }

  /// Obtiene un registro por ID
  Future<UserFastingRecord?> getRecordById(String recordId) async {
    try {
      final doc = await _firestoreService.getDocument(_collection, recordId);
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserFastingRecord.fromJson({
          'id': doc.id,
          ...data,
          'fechaAyuno': (data['fechaAyuno'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaConfirmacion': (data['fechaConfirmacion'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaCompletado': (data['fechaCompletado'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener registro: $e');
    }
  }

  /// Actualiza un registro existente
  Future<void> updateRecord(UserFastingRecord record) async {
    await _firestoreService.updateDocument(
      _collection,
      record.id,
      record.toJson(),
    );
  }

  /// Obtiene todos los registros de un usuario
  Future<List<UserFastingRecord>> getRecordsByUser(String userId) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'userId', isEqualTo: userId),
        ],
        orderBy: [
          QueryOrder('fechaAyuno', descending: false),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserFastingRecord.fromJson({
          'id': doc.id,
          ...data,
          'fechaAyuno': (data['fechaAyuno'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaConfirmacion': (data['fechaConfirmacion'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaCompletado': (data['fechaCompletado'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener registros del usuario: $e');
    }
  }

  /// Obtiene registros de un usuario para un ayuno específico
  Future<List<UserFastingRecord>> getRecordsByUserAndFasting(String userId, String fastingId) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'userId', isEqualTo: userId),
          QueryFilter(field: 'fastingId', isEqualTo: fastingId),
        ],
        orderBy: [
          QueryOrder('fechaAyuno', descending: false),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserFastingRecord.fromJson({
          'id': doc.id,
          ...data,
          'fechaAyuno': (data['fechaAyuno'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaConfirmacion': (data['fechaConfirmacion'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaCompletado': (data['fechaCompletado'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener registros del usuario para el ayuno: $e');
    }
  }

  /// Confirma participación en un ayuno
  Future<UserFastingRecord?> confirmParticipation(String userId, String fastingId, String dia) async {
    try {
      final records = await getRecordsByUserAndFasting(userId, fastingId);
      final record = records.where((r) => r.dia == dia && !r.confirmoParticipacion).firstOrNull;
      
      if (record != null) {
        final updatedRecord = record.confirmarParticipacion();
        await updateRecord(updatedRecord);
        return updatedRecord;
      }
      return null;
    } catch (e) {
      throw Exception('Error al confirmar participación: $e');
    }
  }

  /// Marca ayuno como completado
  Future<UserFastingRecord?> markCompleted(String userId, String fastingId, String dia, {String? notas}) async {
    try {
      final records = await getRecordsByUserAndFasting(userId, fastingId);
      final record = records.where((r) => r.dia == dia && r.confirmoParticipacion && !r.completoAyuno).firstOrNull;
      
      if (record != null) {
        final updatedRecord = record.marcarCompletado(notas: notas);
        await updateRecord(updatedRecord);
        return updatedRecord;
      }
      return null;
    } catch (e) {
      throw Exception('Error al marcar completado: $e');
    }
  }

  /// Obtiene estadísticas de un usuario para un ayuno
  Future<UserFastingStats> getUserStats(String userId, String fastingId) async {
    try {
      final records = await getRecordsByUserAndFasting(userId, fastingId);
      return UserFastingStats.fromRecords(userId, fastingId, records);
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  /// Obtiene registros pendientes de confirmación para hoy
  Future<List<UserFastingRecord>> getPendingConfirmationsForToday(String userId) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'userId', isEqualTo: userId),
          QueryFilter(field: 'confirmoParticipacion', isEqualTo: false),
          QueryFilter(field: 'fechaAyuno', isGreaterThanOrEqualTo: Timestamp.fromDate(tomorrow)),
          QueryFilter(field: 'fechaAyuno', isLessThan: Timestamp.fromDate(tomorrow.add(const Duration(days: 1)))),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserFastingRecord.fromJson({
          'id': doc.id,
          ...data,
          'fechaAyuno': (data['fechaAyuno'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaConfirmacion': (data['fechaConfirmacion'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaCompletado': (data['fechaCompletado'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener confirmaciones pendientes: $e');
    }
  }

  /// Obtiene ayunos de hoy
  Future<List<UserFastingRecord>> getTodaysFastings(String userId) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'userId', isEqualTo: userId),
          QueryFilter(field: 'fechaAyuno', isGreaterThanOrEqualTo: Timestamp.fromDate(today)),
          QueryFilter(field: 'fechaAyuno', isLessThan: Timestamp.fromDate(today.add(const Duration(days: 1)))),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserFastingRecord.fromJson({
          'id': doc.id,
          ...data,
          'fechaAyuno': (data['fechaAyuno'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaConfirmacion': (data['fechaConfirmacion'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaCompletado': (data['fechaCompletado'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener ayunos de hoy: $e');
    }
  }

  /// Elimina un registro
  Future<void> deleteRecord(String recordId) async {
    await _firestoreService.deleteDocument(_collection, recordId);
  }

  /// Escucha cambios en registros de un usuario
  Stream<List<UserFastingRecord>> watchRecordsByUser(String userId) {
    return _firestoreService.watchCollection(
      _collection,
      filters: [
        QueryFilter(field: 'userId', isEqualTo: userId),
      ],
      orderBy: [
        QueryOrder('fechaAyuno', descending: false),
      ],
    ).map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserFastingRecord.fromJson({
          'id': doc.id,
          ...data,
          'fechaAyuno': (data['fechaAyuno'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaConfirmacion': (data['fechaConfirmacion'] as Timestamp?)?.toDate().toIso8601String(),
          'fechaCompletado': (data['fechaCompletado'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    });
  }
} 