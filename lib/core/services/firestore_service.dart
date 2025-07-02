import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Servicio base para operaciones comunes de Firestore
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;

  /// Obtiene el ID del usuario actual
  String? get currentUserId => _auth.currentUser?.uid;

  /// Verifica si el usuario está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  /// Obtiene una referencia a una colección
  CollectionReference collection(String collectionName) {
    return _firestore.collection(collectionName);
  }

  /// Obtiene una referencia a un documento
  DocumentReference document(String collectionName, String documentId) {
    return _firestore.collection(collectionName).doc(documentId);
  }

  /// Crea un documento con ID automático
  Future<DocumentReference> addDocument(
    String collectionName,
    Map<String, dynamic> data,
  ) async {
    // Agregar timestamps automáticamente
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();
    
    return await _firestore.collection(collectionName).add(data);
  }

  /// Crea o actualiza un documento con ID específico
  Future<void> setDocument(
    String collectionName,
    String documentId,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    // Agregar timestamp de actualización
    data['updatedAt'] = FieldValue.serverTimestamp();
    
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .set(data, SetOptions(merge: merge));
  }

  /// Actualiza un documento existente
  Future<void> updateDocument(
    String collectionName,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    // Agregar timestamp de actualización
    data['updatedAt'] = FieldValue.serverTimestamp();
    
    await _firestore
        .collection(collectionName)
        .doc(documentId)
        .update(data);
  }

  /// Elimina un documento
  Future<void> deleteDocument(String collectionName, String documentId) async {
    await _firestore.collection(collectionName).doc(documentId).delete();
  }

  /// Obtiene un documento por ID
  Future<DocumentSnapshot> getDocument(
    String collectionName,
    String documentId,
  ) async {
    return await _firestore.collection(collectionName).doc(documentId).get();
  }

  /// Obtiene documentos con consulta
  Future<QuerySnapshot> getDocuments(
    String collectionName, {
    List<QueryFilter>? filters,
    List<QueryOrder>? orderBy,
    int? limit,
  }) async {
    Query query = _firestore.collection(collectionName);

    // Aplicar filtros
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(
          filter.field,
          isEqualTo: filter.isEqualTo,
          isNotEqualTo: filter.isNotEqualTo,
          isLessThan: filter.isLessThan,
          isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
          isGreaterThan: filter.isGreaterThan,
          isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
          arrayContains: filter.arrayContains,
          arrayContainsAny: filter.arrayContainsAny,
          whereIn: filter.whereIn,
          whereNotIn: filter.whereNotIn,
          isNull: filter.isNull,
        );
      }
    }

    // Aplicar ordenamiento
    if (orderBy != null) {
      for (final order in orderBy) {
        query = query.orderBy(order.field, descending: order.descending);
      }
    }

    // Aplicar límite
    if (limit != null) {
      query = query.limit(limit);
    }

    return await query.get();
  }

  /// Escucha cambios en un documento
  Stream<DocumentSnapshot> watchDocument(
    String collectionName,
    String documentId,
  ) {
    return _firestore.collection(collectionName).doc(documentId).snapshots();
  }

  /// Escucha cambios en una colección
  Stream<QuerySnapshot> watchCollection(
    String collectionName, {
    List<QueryFilter>? filters,
    List<QueryOrder>? orderBy,
    int? limit,
  }) {
    Query query = _firestore.collection(collectionName);

    // Aplicar filtros
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(
          filter.field,
          isEqualTo: filter.isEqualTo,
          isNotEqualTo: filter.isNotEqualTo,
          isLessThan: filter.isLessThan,
          isLessThanOrEqualTo: filter.isLessThanOrEqualTo,
          isGreaterThan: filter.isGreaterThan,
          isGreaterThanOrEqualTo: filter.isGreaterThanOrEqualTo,
          arrayContains: filter.arrayContains,
          arrayContainsAny: filter.arrayContainsAny,
          whereIn: filter.whereIn,
          whereNotIn: filter.whereNotIn,
          isNull: filter.isNull,
        );
      }
    }

    // Aplicar ordenamiento
    if (orderBy != null) {
      for (final order in orderBy) {
        query = query.orderBy(order.field, descending: order.descending);
      }
    }

    // Aplicar límite
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots();
  }

  /// Ejecuta una transacción
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction,
  ) async {
    return await _firestore.runTransaction(updateFunction);
  }

  /// Ejecuta operaciones en lote
  Future<void> batch(List<BatchOperation> operations) async {
    final batch = _firestore.batch();

    for (final operation in operations) {
      switch (operation.type) {
        case BatchOperationType.set:
          batch.set(
            _firestore.collection(operation.collectionName).doc(operation.documentId),
            operation.data!,
          );
          break;
        case BatchOperationType.update:
          batch.update(
            _firestore.collection(operation.collectionName).doc(operation.documentId),
            operation.data!,
          );
          break;
        case BatchOperationType.delete:
          batch.delete(
            _firestore.collection(operation.collectionName).doc(operation.documentId),
          );
          break;
      }
    }

    await batch.commit();
  }
}

/// Clase para definir filtros de consulta
class QueryFilter {
  final String field;
  final dynamic isEqualTo;
  final dynamic isNotEqualTo;
  final dynamic isLessThan;
  final dynamic isLessThanOrEqualTo;
  final dynamic isGreaterThan;
  final dynamic isGreaterThanOrEqualTo;
  final dynamic arrayContains;
  final List<dynamic>? arrayContainsAny;
  final List<dynamic>? whereIn;
  final List<dynamic>? whereNotIn;
  final bool? isNull;

  QueryFilter({
    required this.field,
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}

/// Clase para definir ordenamiento
class QueryOrder {
  final String field;
  final bool descending;

  QueryOrder(this.field, {this.descending = false});
}

/// Enum para tipos de operaciones en lote
enum BatchOperationType { set, update, delete }

/// Clase para operaciones en lote
class BatchOperation {
  final BatchOperationType type;
  final String collectionName;
  final String documentId;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.collectionName,
    required this.documentId,
    this.data,
  });
} 