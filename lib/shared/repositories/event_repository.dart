import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../../core/services/firestore_service.dart';

class EventRepository {
  static final EventRepository _instance = EventRepository._internal();
  factory EventRepository() => _instance;
  EventRepository._internal();

  final FirestoreService _firestoreService = FirestoreService();
  static const String _collection = 'events';
  static const Uuid _uuid = Uuid();

  /// Crea un nuevo evento
  Future<EventModel> createEvent(EventModel event) async {
    final eventWithId = event.copyWith(id: _uuid.v4());
    
    await _firestoreService.setDocument(
      _collection,
      eventWithId.id,
      eventWithId.toJson(),
    );
    
    return eventWithId;
  }

  /// Obtiene un evento por ID
  Future<EventModel?> getEventById(String eventId) async {
    try {
      final doc = await _firestoreService.getDocument(_collection, eventId);
      
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener evento: $e');
    }
  }

  /// Actualiza un evento existente
  Future<void> updateEvent(EventModel event) async {
    await _firestoreService.updateDocument(
      _collection,
      event.id,
      event.toJson(),
    );
  }

  /// Elimina un evento
  Future<void> deleteEvent(String eventId) async {
    await _firestoreService.deleteDocument(_collection, eventId);
  }

  /// Obtiene eventos por iglesia
  Future<List<EventModel>> getEventsByChurch(String churchId) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'iglesiaId', isEqualTo: churchId),
        ],
        orderBy: [
          QueryOrder('fechaInicio', descending: false),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos por iglesia: $e');
    }
  }

  /// Obtiene eventos próximos
  Future<List<EventModel>> getUpcomingEvents({String? churchId, int limit = 20}) async {
    try {
      final now = DateTime.now();
      
      final filters = <QueryFilter>[
        QueryFilter(field: 'fechaInicio', isGreaterThanOrEqualTo: Timestamp.fromDate(now)),
      ];
      
      if (churchId != null) {
        filters.add(QueryFilter(field: 'iglesiaId', isEqualTo: churchId));
      }

      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: filters,
        orderBy: [
          QueryOrder('fechaInicio', descending: false),
        ],
        limit: limit,
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos próximos: $e');
    }
  }

  /// Obtiene eventos pasados
  Future<List<EventModel>> getPastEvents({String? churchId, int limit = 20}) async {
    try {
      final now = DateTime.now();
      
      final filters = <QueryFilter>[
        QueryFilter(field: 'fechaFin', isLessThan: Timestamp.fromDate(now)),
      ];
      
      if (churchId != null) {
        filters.add(QueryFilter(field: 'iglesiaId', isEqualTo: churchId));
      }

      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: filters,
        orderBy: [
          QueryOrder('fechaInicio', descending: true),
        ],
        limit: limit,
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos pasados: $e');
    }
  }

  /// Busca eventos por título
  Future<List<EventModel>> searchEvents(String query) async {
    try {
      final querySnapshot = await _firestoreService.getDocuments(
        _collection,
        filters: [
          QueryFilter(field: 'titulo', isGreaterThanOrEqualTo: query),
          QueryFilter(field: 'titulo', isLessThan: query + '\uf8ff'),
        ],
        orderBy: [
          QueryOrder('titulo'),
        ],
      );

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al buscar eventos: $e');
    }
  }

  /// Obtiene todos los eventos paginados
  Future<List<EventModel>> getAllEvents({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query query = _firestoreService.collection(_collection)
          .orderBy('fechaInicio', descending: true);
      
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      
      final querySnapshot = await query.limit(limit).get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    } catch (e) {
      throw Exception('Error al obtener eventos: $e');
    }
  }

  /// Escucha cambios en un evento específico
  Stream<EventModel?> watchEvent(String eventId) {
    return _firestoreService.watchDocument(_collection, eventId).map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }
      return null;
    });
  }

  /// Escucha cambios en eventos de una iglesia
  Stream<List<EventModel>> watchEventsByChurch(String churchId) {
    return _firestoreService.watchCollection(
      _collection,
      filters: [
        QueryFilter(field: 'iglesiaId', isEqualTo: churchId),
      ],
      orderBy: [
        QueryOrder('fechaInicio', descending: false),
      ],
    ).map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson({
          'id': doc.id,
          ...data,
          'fechaInicio': (data['fechaInicio'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'fechaFin': (data['fechaFin'] as Timestamp?)?.toDate().toIso8601String(),
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ?? DateTime.now().toIso8601String(),
          'updatedAt': (data['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
        });
      }).toList();
    });
  }
} 