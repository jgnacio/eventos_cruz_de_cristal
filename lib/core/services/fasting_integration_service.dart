import 'package:flutter/foundation.dart';
import '../../shared/models/fasting_model.dart';
import '../../shared/models/user_fasting_record_model.dart';
import 'fasting_record_service.dart';
import 'local_notification_service.dart';

/// Servicio de integración que demuestra cómo usar todo el sistema de ayuno
/// Este servicio conecta todos los componentes del sistema de notificaciones de ayuno
class FastingIntegrationService {
  
  /// Asigna un usuario a un ayuno y programa todas las notificaciones necesarias
  /// 
  /// Este método debe ser llamado cuando:
  /// - Un administrador asigne a un usuario a días específicos de ayuno
  /// - Un usuario se registre voluntariamente para ciertos días
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await FastingIntegrationService.assignUserToFasting(
  ///   userId: 'user_123',
  ///   ayuno: ayunoModel,
  ///   diasAsignados: ['lunes', 'miercoles', 'viernes'],
  /// );
  /// ```
  static Future<List<UserFastingRecord>> assignUserToFasting({
    required String userId,
    required FastingModel ayuno,
    required List<String> diasAsignados,
  }) async {
    try {
      if (kDebugMode) {
        print('Asignando usuario $userId a ayuno ${ayuno.id} para días: $diasAsignados');
      }

      // Crear registros de ayuno con notificaciones automáticas
      final records = await FastingRecordService.createFastingRecords(
        userId: userId,
        fastingId: ayuno.id,
        diasAsignados: diasAsignados,
        ayuno: ayuno,
      );

      // Mostrar notificación de confirmación de asignación
      await LocalNotificationService.showImmediateNotification(
        titulo: '📅 Ayuno Asignado',
        mensaje: 'Has sido asignado para ayunar ${diasAsignados.length} día(s) para "${ayuno.titulo}"',
      );

      if (kDebugMode) {
        print('Usuario $userId asignado exitosamente a ${records.length} días de ayuno');
        for (final record in records) {
          print('- ${record.dia}: ${record.fechaAyuno}');
        }
      }

      return records;
    } catch (e) {
      if (kDebugMode) {
        print('Error al asignar usuario a ayuno: $e');
      }
      rethrow;
    }
  }

  /// Maneja la confirmación de participación desde una notificación o la app
  /// 
  /// Este método debe ser llamado cuando:
  /// - El usuario presiona "confirmar" en la notificación
  /// - El usuario confirma desde la app
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// final confirmed = await FastingIntegrationService.handleFastingConfirmation(
  ///   userId: 'user_123',
  ///   fastingId: 'fasting_456',
  ///   dia: 'lunes',
  /// );
  /// ```
  static Future<UserFastingRecord?> handleFastingConfirmation({
    required String userId,
    required String fastingId,
    required String dia,
  }) async {
    try {
      if (kDebugMode) {
        print('Procesando confirmación: $userId, $fastingId, $dia');
      }

      final confirmed = await FastingRecordService.confirmFastingParticipation(
        userId: userId,
        fastingId: fastingId,
        dia: dia,
      );

      if (confirmed != null) {
        if (kDebugMode) {
          print('Confirmación exitosa para $dia');
        }
      } else {
        if (kDebugMode) {
          print('No se pudo procesar la confirmación');
        }
      }

      return confirmed;
    } catch (e) {
      if (kDebugMode) {
        print('Error al confirmar participación: $e');
      }
      rethrow;
    }
  }

  /// Maneja el completado de un ayuno
  /// 
  /// Este método debe ser llamado cuando:
  /// - El usuario marca un ayuno como completado
  /// - Se verifica automáticamente el completado
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// final completed = await FastingIntegrationService.handleFastingCompletion(
  ///   userId: 'user_123',
  ///   fastingId: 'fasting_456',
  ///   dia: 'lunes',
  ///   notas: 'Fue una experiencia muy enriquecedora',
  /// );
  /// ```
  static Future<UserFastingRecord?> handleFastingCompletion({
    required String userId,
    required String fastingId,
    required String dia,
    String? notas,
  }) async {
    try {
      if (kDebugMode) {
        print('Procesando completado: $userId, $fastingId, $dia');
      }

      final completed = await FastingRecordService.markFastingCompleted(
        userId: userId,
        fastingId: fastingId,
        dia: dia,
        notas: notas,
      );

      if (completed != null) {
        if (kDebugMode) {
          print('Ayuno completado exitosamente para $dia');
        }
      } else {
        if (kDebugMode) {
          print('No se pudo marcar como completado');
        }
      }

      return completed;
    } catch (e) {
      if (kDebugMode) {
        print('Error al completar ayuno: $e');
      }
      rethrow;
    }
  }

  /// Obtiene estadísticas completas del ayuno para un usuario
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// final stats = await FastingIntegrationService.getUserStats(
  ///   userId: 'user_123',
  ///   fastingId: 'fasting_456',
  /// );
  /// print('Completado: ${stats.porcentajeCompletado}%');
  /// ```
  static Future<UserFastingStats> getUserStats({
    required String userId,
    required String fastingId,
  }) async {
    return await FastingRecordService.getUserFastingStats(
      userId: userId,
      fastingId: fastingId,
    );
  }

  /// Cancela la participación de un usuario en días específicos
  /// 
  /// Este método debe ser llamado cuando:
  /// - Un usuario cancela su participación
  /// - Un administrador remueve a un usuario
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await FastingIntegrationService.cancelUserParticipation(
  ///   userId: 'user_123',
  ///   fastingId: 'fasting_456',
  ///   specificDays: ['lunes'], // Opcional, si no se especifica cancela todos
  /// );
  /// ```
  static Future<void> cancelUserParticipation({
    required String userId,
    required String fastingId,
    List<String>? specificDays,
  }) async {
    try {
      if (kDebugMode) {
        print('Cancelando participación: $userId, $fastingId, días: $specificDays');
      }

      await FastingRecordService.cancelFastingRecords(
        userId: userId,
        fastingId: fastingId,
        specificDays: specificDays,
      );

      // Mostrar notificación de cancelación
      await LocalNotificationService.showImmediateNotification(
        titulo: '❌ Participación Cancelada',
        mensaje: specificDays != null 
          ? 'Se canceló tu participación en ${specificDays.length} día(s)'
          : 'Se canceló toda tu participación en el ayuno',
      );

      if (kDebugMode) {
        print('Participación cancelada exitosamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al cancelar participación: $e');
      }
      rethrow;
    }
  }

  /// Procesa notificaciones desde el payload
  /// 
  /// Este método debe ser llamado desde el handler de notificaciones
  /// cuando una notificación es presionada
  /// 
  /// Ejemplo de payload esperado:
  /// - "fasting_confirmation:user_123:fasting_456:lunes:1234567890"
  /// - "fasting_reminder:user_123:fasting_456:lunes:1234567890"
  static Future<void> handleNotificationPayload(String payload) async {
    try {
      if (kDebugMode) {
        print('Procesando payload de notificación: $payload');
      }

      final parts = payload.split(':');
      if (parts.length < 5) {
        if (kDebugMode) {
          print('Formato de payload inválido: $payload');
        }
        return;
      }

      final type = parts[0];
      final userId = parts[1];
      final fastingId = parts[2];
      final dia = parts[3];
      // final timestamp = parts[4]; // Se puede usar para validaciones adicionales

      switch (type) {
        case 'fasting_confirmation':
          // Navegar a la pantalla de confirmación o mostrar dialog
          if (kDebugMode) {
            print('Abrir pantalla de confirmación para $dia');
          }
          // Aquí puedes agregar navegación específica
          break;
          
        case 'fasting_reminder':
          // Mostrar recordatorio o navegar a pantalla de ayuno
          if (kDebugMode) {
            print('Mostrar recordatorio de ayuno para $dia');
          }
          await LocalNotificationService.showImmediateNotification(
            titulo: '🙏 Recordatorio',
            mensaje: 'No olvides tu ayuno de hoy ($dia)',
          );
          break;
          
        default:
          if (kDebugMode) {
            print('Tipo de notificación desconocido: $type');
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al procesar payload de notificación: $e');
      }
    }
  }

  /// Verifica y programa notificaciones para ayunos existentes
  /// 
  /// Este método debe ser llamado:
  /// - Al iniciar la aplicación
  /// - Después de actualizaciones de ayunos
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await FastingIntegrationService.syncNotifications('user_123');
  /// ```
  static Future<void> syncNotifications(String userId) async {
    try {
      if (kDebugMode) {
        print('Sincronizando notificaciones para usuario: $userId');
      }

      final allRecords = await FastingRecordService.getUserFastingRecords(userId: userId);
      final pendingRecords = allRecords.where(
        (record) => !record.confirmoParticipacion && 
                   record.fechaAyuno.isAfter(DateTime.now())
      ).toList();

      if (kDebugMode) {
        print('Encontrados ${pendingRecords.length} registros pendientes');
      }

      // Aquí puedes volver a programar notificaciones si es necesario
      // Por ejemplo, después de reinstalar la app o cambios en el sistema

    } catch (e) {
      if (kDebugMode) {
        print('Error al sincronizar notificaciones: $e');
      }
    }
  }

  /// Limpia todos los datos de ayuno (para testing o reset)
  /// 
  /// ⚠️ Este método elimina TODOS los registros y notificaciones
  /// 
  /// Ejemplo de uso:
  /// ```dart
  /// await FastingIntegrationService.resetAllData();
  /// ```
  static Future<void> resetAllData() async {
    try {
      if (kDebugMode) {
        print('Eliminando todos los datos de ayuno...');
      }

      await FastingRecordService.clearAllRecords();

      if (kDebugMode) {
        print('Todos los datos han sido eliminados');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al limpiar datos: $e');
      }
      rethrow;
    }
  }
}

/// Clase de utilidades para trabajar con fechas de ayuno
class FastingDateUtils {
  
  /// Convierte nombre de día a índice (0 = lunes, 6 = domingo)
  static int dayNameToIndex(String dayName) {
    const days = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'];
    return days.indexOf(dayName.toLowerCase());
  }

  /// Convierte índice a nombre de día
  static String indexToDayName(int index) {
    const days = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    return days[index % 7];
  }

  /// Encuentra la próxima fecha de un día específico
  static DateTime getNextDateForDay(String dayName) {
    final dayIndex = dayNameToIndex(dayName);
    final now = DateTime.now();
    final currentWeekday = now.weekday - 1; // Convertir a 0-6
    
    int daysToAdd = dayIndex - currentWeekday;
    if (daysToAdd <= 0) {
      daysToAdd += 7; // Siguiente semana
    }
    
    return now.add(Duration(days: daysToAdd));
  }

  /// Verifica si una fecha es hoy
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Verifica si una fecha es mañana
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }
} 