import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../shared/models/user_fasting_record_model.dart';
import '../../shared/models/fasting_model.dart';
import '../../shared/repositories/fasting_repository.dart';
import '../../shared/repositories/user_fasting_record_repository.dart';
import 'local_notification_service.dart';
import 'service_locator.dart';

class FirebaseFastingService {
  static final FirebaseFastingService _instance = FirebaseFastingService._internal();
  factory FirebaseFastingService() => _instance;
  FirebaseFastingService._internal();

  final ServiceLocator _serviceLocator = ServiceLocator();
  static const Uuid _uuid = Uuid();

  FastingRepository get _fastingRepository => _serviceLocator.fastingRepository;
  UserFastingRecordRepository get _recordRepository => _serviceLocator.userFastingRecordRepository;

  /// Crea registros de ayuno para un usuario cuando se asigna a días específicos
  Future<List<UserFastingRecord>> createFastingRecords({
    required String userId,
    required String fastingId,
    required List<String> diasAsignados,
    required FastingModel ayuno,
  }) async {
    try {
      final records = <UserFastingRecord>[];

      // Calcular fechas específicas basadas en las fechas del ayuno
      final fechasAyuno = _calculateFastingDates(diasAsignados, ayuno);

      for (int i = 0; i < diasAsignados.length; i++) {
        final dia = diasAsignados[i];
        final fechaAyuno = fechasAyuno[i];

        final record = UserFastingRecord(
          id: _uuid.v4(),
          userId: userId,
          fastingId: fastingId,
          dia: dia,
          fechaAyuno: fechaAyuno,
          createdAt: DateTime.now(),
        );

        records.add(record);

        // Programar notificaciones
        await _scheduleNotifications(
          userId: userId,
          fastingId: fastingId,
          dia: dia,
          fechaAyuno: fechaAyuno,
          tituloAyuno: ayuno.titulo,
        );
      }

      // Guardar registros en Firebase
      await _recordRepository.createMultipleRecords(records);

      // Actualizar participantes en el ayuno
      for (int i = 0; i < diasAsignados.length; i++) {
        await _fastingRepository.addParticipantToDay(fastingId, userId, diasAsignados[i]);
      }

      if (kDebugMode) {
        print('✅ Creados ${records.length} registros de ayuno para usuario $userId');
      }

      return records;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creando registros de ayuno: $e');
      }
      throw Exception('Error al crear registros de ayuno: $e');
    }
  }

  /// Confirma que el usuario va a participar en el ayuno
  Future<UserFastingRecord?> confirmFastingParticipation({
    required String userId,
    required String fastingId,
    required String dia,
  }) async {
    try {
      final updatedRecord = await _recordRepository.confirmParticipation(userId, fastingId, dia);

      if (updatedRecord != null) {
        // Mostrar notificación de confirmación
        await LocalNotificationService.showImmediateNotification(
          titulo: '✅ Confirmación Recibida',
          mensaje: 'Has confirmado tu participación en el ayuno del $dia. ¡Que Dios te bendiga!',
        );

        if (kDebugMode) {
          print('✅ Confirmada participación: $userId, $dia');
        }
      }

      return updatedRecord;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error confirmando participación: $e');
      }
      throw Exception('Error al confirmar participación: $e');
    }
  }

  /// Marca que el usuario completó el ayuno
  Future<UserFastingRecord?> markFastingCompleted({
    required String userId,
    required String fastingId,
    required String dia,
    String? notas,
  }) async {
    try {
      final updatedRecord = await _recordRepository.markCompleted(
        userId,
        fastingId,
        dia,
        notas: notas,
      );

      if (updatedRecord != null) {
        // Mostrar notificación de felicitación
        await LocalNotificationService.showImmediateNotification(
          titulo: '🎉 ¡Ayuno Completado!',
          mensaje: 'Has completado tu ayuno del $dia. ¡Felicitaciones por tu dedicación!',
        );

        if (kDebugMode) {
          print('✅ Ayuno completado: $userId, $dia');
        }
      }

      return updatedRecord;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error marcando ayuno completado: $e');
      }
      throw Exception('Error al marcar ayuno completado: $e');
    }
  }

  /// Obtiene todos los registros de ayuno de un usuario para un ayuno específico
  Future<List<UserFastingRecord>> getUserFastingRecords({
    required String userId,
    String? fastingId,
  }) async {
    try {
      if (fastingId != null) {
        return await _recordRepository.getRecordsByUserAndFasting(userId, fastingId);
      } else {
        return await _recordRepository.getRecordsByUser(userId);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo registros de usuario: $e');
      }
      throw Exception('Error al obtener registros de ayuno: $e');
    }
  }

  /// Obtiene estadísticas de ayuno del usuario
  Future<UserFastingStats> getUserFastingStats({
    required String userId,
    required String fastingId,
  }) async {
    try {
      return await _recordRepository.getUserStats(userId, fastingId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo estadísticas: $e');
      }
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  /// Obtiene registros pendientes de confirmación para hoy
  Future<List<UserFastingRecord>> getPendingConfirmationsForToday(String userId) async {
    try {
      return await _recordRepository.getPendingConfirmationsForToday(userId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo confirmaciones pendientes: $e');
      }
      throw Exception('Error al obtener confirmaciones pendientes: $e');
    }
  }

  /// Obtiene ayunos programados para hoy
  Future<List<UserFastingRecord>> getTodaysFastings(String userId) async {
    try {
      return await _recordRepository.getTodaysFastings(userId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo ayunos de hoy: $e');
      }
      throw Exception('Error al obtener ayunos de hoy: $e');
    }
  }

  /// Obtiene ayunos activos
  Future<List<FastingModel>> getActiveFastings() async {
    try {
      return await _fastingRepository.getActiveFastings();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo ayunos activos: $e');
      }
      throw Exception('Error al obtener ayunos activos: $e');
    }
  }

  /// Obtiene ayunos de una iglesia
  Future<List<FastingModel>> getChurchFastings(String churchId) async {
    try {
      return await _fastingRepository.getFastingsByChurch(churchId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo ayunos de iglesia: $e');
      }
      throw Exception('Error al obtener ayunos de la iglesia: $e');
    }
  }

  /// Crea un nuevo ayuno
  Future<FastingModel> createFasting(FastingModel fasting) async {
    try {
      return await _fastingRepository.createFasting(fasting);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creando ayuno: $e');
      }
      throw Exception('Error al crear ayuno: $e');
    }
  }

  /// Actualiza un ayuno
  Future<void> updateFasting(FastingModel fasting) async {
    try {
      await _fastingRepository.updateFasting(fasting);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error actualizando ayuno: $e');
      }
      throw Exception('Error al actualizar ayuno: $e');
    }
  }

  /// Elimina un ayuno
  Future<void> deleteFasting(String fastingId) async {
    try {
      await _fastingRepository.deleteFasting(fastingId);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error eliminando ayuno: $e');
      }
      throw Exception('Error al eliminar ayuno: $e');
    }
  }

  /// Escucha cambios en registros de un usuario
  Stream<List<UserFastingRecord>> watchUserRecords(String userId) {
    return _recordRepository.watchRecordsByUser(userId);
  }

  /// Escucha cambios en un ayuno específico
  Stream<FastingModel?> watchFasting(String fastingId) {
    return _fastingRepository.watchFasting(fastingId);
  }

  // Métodos privados auxiliares

  /// Calcula las fechas específicas de ayuno basadas en los días asignados
  List<DateTime> _calculateFastingDates(List<String> diasAsignados, FastingModel ayuno) {
    final fechas = <DateTime>[];
    final diasSemana = {
      'lunes': DateTime.monday,
      'martes': DateTime.tuesday,
      'miercoles': DateTime.wednesday,
      'jueves': DateTime.thursday,
      'viernes': DateTime.friday,
      'sabado': DateTime.saturday,
      'domingo': DateTime.sunday,
    };

    final fechaInicio = ayuno.fechaInicio ?? DateTime.now();
    final fechaFin = ayuno.fechaFin ?? fechaInicio.add(const Duration(days: 30));

    for (final dia in diasAsignados) {
      final diaSemana = diasSemana[dia.toLowerCase()];
      if (diaSemana != null) {
        // Encontrar la próxima ocurrencia de este día
        DateTime fecha = fechaInicio;
        while (fecha.weekday != diaSemana || fecha.isBefore(fechaInicio)) {
          fecha = fecha.add(const Duration(days: 1));
        }
        
        // Si la fecha calculada está dentro del rango del ayuno
        if (fecha.isBefore(fechaFin) || fecha.isAtSameMomentAs(fechaFin)) {
          fechas.add(fecha);
        }
      }
    }

    return fechas;
  }

  /// Programa notificaciones para un registro de ayuno
  Future<void> _scheduleNotifications({
    required String userId,
    required String fastingId,
    required String dia,
    required DateTime fechaAyuno,
    required String tituloAyuno,
  }) async {
    try {
      // Programar notificación de confirmación (8pm del día anterior)
      await LocalNotificationService.scheduleConfirmationNotification(
        userId: userId,
        fastingId: fastingId,
        dia: dia,
        fechaAyuno: fechaAyuno,
        tituloAyuno: tituloAyuno,
      );

      // Programar notificación de recordatorio (6am del día del ayuno)
      await LocalNotificationService.scheduleReminderNotification(
        userId: userId,
        fastingId: fastingId,
        dia: dia,
        fechaAyuno: fechaAyuno,
        tituloAyuno: tituloAyuno,
      );

      if (kDebugMode) {
        print('✅ Notificaciones programadas para $dia');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error programando notificaciones: $e');
      }
      // No lanzar excepción aquí para no bloquear la creación del registro
    }
  }
} 