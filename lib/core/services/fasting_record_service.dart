import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../shared/models/user_fasting_record_model.dart';
import '../../shared/models/fasting_model.dart';
import 'local_notification_service.dart';

class FastingRecordService {
  static const String _storageKey = 'user_fasting_records';
  static const Uuid _uuid = Uuid();

  /// Crea registros de ayuno para un usuario cuando se asigna a días específicos
  static Future<List<UserFastingRecord>> createFastingRecords({
    required String userId,
    required String fastingId,
    required List<String> diasAsignados,
    required FastingModel ayuno,
  }) async {
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

      // Programar notificación de confirmación (8pm del día anterior)
      await LocalNotificationService.scheduleConfirmationNotification(
        userId: userId,
        fastingId: fastingId,
        dia: dia,
        fechaAyuno: fechaAyuno,
        tituloAyuno: ayuno.titulo,
      );

      // Programar notificación de recordatorio (6am del día del ayuno)
      await LocalNotificationService.scheduleReminderNotification(
        userId: userId,
        fastingId: fastingId,
        dia: dia,
        fechaAyuno: fechaAyuno,
        tituloAyuno: ayuno.titulo,
      );
    }

    // Guardar registros
    await _saveRecords(records);

    if (kDebugMode) {
      print('Creados ${records.length} registros de ayuno para usuario $userId');
    }

    return records;
  }

  /// Confirma que el usuario va a participar en el ayuno
  static Future<UserFastingRecord?> confirmFastingParticipation({
    required String userId,
    required String fastingId,
    required String dia,
  }) async {
    final records = await getUserFastingRecords(userId: userId, fastingId: fastingId);
    
    final recordIndex = records.indexWhere(
      (r) => r.dia == dia && !r.confirmoParticipacion,
    );

    if (recordIndex == -1) {
      if (kDebugMode) {
        print('No se encontró registro pendiente para confirmar: $userId, $dia');
      }
      return null;
    }

    final updatedRecord = records[recordIndex].confirmarParticipacion();
    records[recordIndex] = updatedRecord;

    await _updateRecords(records);

    // Mostrar notificación de confirmación
    await LocalNotificationService.showImmediateNotification(
      titulo: '✅ Confirmación Recibida',
      mensaje: 'Has confirmado tu participación en el ayuno del $dia. ¡Que Dios te bendiga!',
    );

    if (kDebugMode) {
      print('Confirmada participación: $userId, $dia');
    }

    return updatedRecord;
  }

  /// Marca que el usuario completó el ayuno
  static Future<UserFastingRecord?> markFastingCompleted({
    required String userId,
    required String fastingId,
    required String dia,
    String? notas,
  }) async {
    final records = await getUserFastingRecords(userId: userId, fastingId: fastingId);
    
    final recordIndex = records.indexWhere(
      (r) => r.dia == dia && r.confirmoParticipacion && !r.completoAyuno,
    );

    if (recordIndex == -1) {
      if (kDebugMode) {
        print('No se encontró registro confirmado para completar: $userId, $dia');
      }
      return null;
    }

    final updatedRecord = records[recordIndex].marcarCompletado(notas: notas);
    records[recordIndex] = updatedRecord;

    await _updateRecords(records);

    // Mostrar notificación de felicitación
    await LocalNotificationService.showImmediateNotification(
      titulo: '🎉 ¡Ayuno Completado!',
      mensaje: 'Has completado tu ayuno del $dia. ¡Felicitaciones por tu dedicación!',
    );

    if (kDebugMode) {
      print('Ayuno completado: $userId, $dia');
    }

    return updatedRecord;
  }

  /// Obtiene todos los registros de ayuno de un usuario para un ayuno específico
  static Future<List<UserFastingRecord>> getUserFastingRecords({
    required String userId,
    String? fastingId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_storageKey) ?? [];

    final allRecords = recordsJson
        .map((json) => UserFastingRecord.fromJson(jsonDecode(json)))
        .where((record) => record.userId == userId)
        .toList();

    if (fastingId != null) {
      return allRecords.where((record) => record.fastingId == fastingId).toList();
    }

    return allRecords;
  }

  /// Obtiene estadísticas de ayuno del usuario
  static Future<UserFastingStats> getUserFastingStats({
    required String userId,
    required String fastingId,
  }) async {
    final records = await getUserFastingRecords(userId: userId, fastingId: fastingId);
    return UserFastingStats.fromRecords(userId, fastingId, records);
  }

  /// Obtiene registros pendientes de confirmación para hoy
  static Future<List<UserFastingRecord>> getPendingConfirmationsForToday(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final allRecords = await getUserFastingRecords(userId: userId);

    return allRecords.where((record) {
      final fechaAyuno = DateTime(
        record.fechaAyuno.year,
        record.fechaAyuno.month,
        record.fechaAyuno.day,
      );
      
      return fechaAyuno.isAtSameMomentAs(tomorrow) && 
             !record.confirmoParticipacion;
    }).toList();
  }

  /// Obtiene ayunos programados para hoy
  static Future<List<UserFastingRecord>> getTodaysFastings(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final allRecords = await getUserFastingRecords(userId: userId);

    return allRecords.where((record) {
      final fechaAyuno = DateTime(
        record.fechaAyuno.year,
        record.fechaAyuno.month,
        record.fechaAyuno.day,
      );
      
      return fechaAyuno.isAtSameMomentAs(today) && 
             record.confirmoParticipacion;
    }).toList();
  }

  /// Cancela registros de ayuno y notificaciones asociadas
  static Future<void> cancelFastingRecords({
    required String userId,
    required String fastingId,
    List<String>? specificDays,
  }) async {
    final records = await getUserFastingRecords(userId: userId, fastingId: fastingId);
    
    final recordsToCancel = specificDays != null
        ? records.where((r) => specificDays.contains(r.dia)).toList()
        : records;

    for (final record in recordsToCancel) {
      await LocalNotificationService.cancelFastingNotifications(
        userId: userId,
        fastingId: fastingId,
        dia: record.dia,
      );
    }

    // Remover registros cancelados
    final remainingRecords = records.where((r) => !recordsToCancel.contains(r)).toList();
    await _updateRecords(remainingRecords);

    if (kDebugMode) {
      print('Cancelados ${recordsToCancel.length} registros de ayuno');
    }
  }

  /// Calcula las fechas específicas de ayuno basadas en los días asignados
  static List<DateTime> _calculateFastingDates(List<String> diasAsignados, FastingModel ayuno) {
    final fechas = <DateTime>[];
    
    if (ayuno.fechaInicio == null || ayuno.fechaFin == null) {
      // Si no hay fechas específicas, usar la próxima semana
      final ahora = DateTime.now();
      final inicioSemana = ahora.add(Duration(days: 7 - ahora.weekday + 1));
      
      for (final dia in diasAsignados) {
        final diaIndice = _getDayIndex(dia);
        final fechaAyuno = inicioSemana.add(Duration(days: diaIndice));
        fechas.add(fechaAyuno);
      }
    } else {
      // Calcular fechas dentro del rango del ayuno
      final inicio = ayuno.fechaInicio!;
      final fin = ayuno.fechaFin!;
      
      for (final dia in diasAsignados) {
        final fechaEnRango = _findNextDateInRange(dia, inicio, fin);
        if (fechaEnRango != null) {
          fechas.add(fechaEnRango);
        }
      }
    }
    
    return fechas;
  }

  /// Encuentra la próxima fecha de un día específico dentro de un rango
  static DateTime? _findNextDateInRange(String dia, DateTime inicio, DateTime fin) {
    final diaIndice = _getDayIndex(dia);
    DateTime fecha = inicio;
    
    while (fecha.isBefore(fin) || fecha.isAtSameMomentAs(fin)) {
      if (fecha.weekday == diaIndice + 1) { // DateTime.weekday es 1-7, nuestro índice es 0-6
        return fecha;
      }
      fecha = fecha.add(const Duration(days: 1));
    }
    
    return null;
  }

  /// Obtiene el índice del día (0 = lunes, 6 = domingo)
  static int _getDayIndex(String dia) {
    const dias = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'];
    return dias.indexOf(dia.toLowerCase());
  }

  /// Guarda nuevos registros
  static Future<void> _saveRecords(List<UserFastingRecord> newRecords) async {
    final prefs = await SharedPreferences.getInstance();
    final existingJson = prefs.getStringList(_storageKey) ?? [];
    
    final newJson = newRecords.map((record) => jsonEncode(record.toJson())).toList();
    existingJson.addAll(newJson);
    
    await prefs.setStringList(_storageKey, existingJson);
  }

  /// Actualiza registros existentes
  static Future<void> _updateRecords(List<UserFastingRecord> updatedRecords) async {
    final prefs = await SharedPreferences.getInstance();
    final allRecordsJson = prefs.getStringList(_storageKey) ?? [];
    
    final allRecords = allRecordsJson
        .map((json) => UserFastingRecord.fromJson(jsonDecode(json)))
        .toList();

    // Reemplazar registros actualizados
    for (final updatedRecord in updatedRecords) {
      final index = allRecords.indexWhere((r) => r.id == updatedRecord.id);
      if (index != -1) {
        allRecords[index] = updatedRecord;
      }
    }

    // Guardar todos los registros actualizados
    final updatedJson = allRecords.map((record) => jsonEncode(record.toJson())).toList();
    await prefs.setStringList(_storageKey, updatedJson);
  }

  /// Limpia todos los registros (para testing o reset)
  static Future<void> clearAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await LocalNotificationService.cancelAllNotifications();
    
    if (kDebugMode) {
      print('Todos los registros de ayuno han sido eliminados');
    }
  }
} 