import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Inicializa el servicio de notificaciones locales
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Inicializar timezone
    tz.initializeTimeZones();
    
    // Configuración para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Solicitar permisos en Android 13+
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _isInitialized = true;
  }

  /// Maneja el tap en la notificación
  static void _onNotificationTap(NotificationResponse response) {
    if (kDebugMode) {
      print('Notificación presionada: ${response.payload}');
    }
    
    // Aquí puedes manejar la navegación o acciones específicas
    // basado en el payload de la notificación
    if (response.payload != null) {
      _handleNotificationPayload(response.payload!);
    }
  }

  /// Maneja la carga útil de la notificación
  static void _handleNotificationPayload(String payload) {
    // Implementar lógica de navegación aquí
    // Por ejemplo, navegar a la pantalla de confirmación de ayuno
    if (kDebugMode) {
      print('Manejando payload: $payload');
    }
  }

  /// Programa una notificación para confirmación de ayuno
  /// Se envía a las 8pm del día anterior
  static Future<void> scheduleConfirmationNotification({
    required String userId,
    required String fastingId,
    required String dia,
    required DateTime fechaAyuno,
    required String tituloAyuno,
  }) async {
    if (!_isInitialized) await initialize();

    // Calcular la fecha y hora de la notificación (8pm del día anterior)
    final fechaNotificacion = fechaAyuno.subtract(const Duration(days: 1));
    final fechaNotificacionConHora = DateTime(
      fechaNotificacion.year,
      fechaNotificacion.month,
      fechaNotificacion.day,
      20, // 8 PM
      0,
      0,
    );

    // Solo programar si la fecha es futura
    if (fechaNotificacionConHora.isBefore(DateTime.now())) {
      if (kDebugMode) {
        print('No se puede programar notificación en el pasado: $fechaNotificacionConHora');
      }
      return;
    }

    final notificationId = _generateNotificationId(userId, fastingId, dia);
    
    const androidDetails = AndroidNotificationDetails(
      'ayuno_confirmacion',
      'Confirmación de Ayuno',
      channelDescription: 'Notificaciones para confirmar participación en ayunos',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = 'fasting_confirmation:$userId:$fastingId:$dia:${fechaAyuno.millisecondsSinceEpoch}';

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '🙏 Confirmación de Ayuno',
      '¿Vas a ayunar mañana ($dia) para "$tituloAyuno"? ¡Confirma tu participación!',
      tz.TZDateTime.from(fechaNotificacionConHora, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    if (kDebugMode) {
      print('Notificación programada para: $fechaNotificacionConHora');
      print('ID de notificación: $notificationId');
    }
  }

  /// Programa notificación de recordatorio el día del ayuno
  static Future<void> scheduleReminderNotification({
    required String userId,
    required String fastingId,
    required String dia,
    required DateTime fechaAyuno,
    required String tituloAyuno,
  }) async {
    if (!_isInitialized) await initialize();

    // Programar para las 6am del día del ayuno
    final fechaRecordatorio = DateTime(
      fechaAyuno.year,
      fechaAyuno.month,
      fechaAyuno.day,
      6, // 6 AM
      0,
      0,
    );

    // Solo programar si la fecha es futura
    if (fechaRecordatorio.isBefore(DateTime.now())) {
      return;
    }

    final notificationId = _generateNotificationId(userId, fastingId, dia, isReminder: true);
    
    const androidDetails = AndroidNotificationDetails(
      'ayuno_recordatorio',
      'Recordatorio de Ayuno',
      channelDescription: 'Recordatorios del día de ayuno',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      enableVibration: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final payload = 'fasting_reminder:$userId:$fastingId:$dia:${fechaAyuno.millisecondsSinceEpoch}';

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '🌅 ¡Día de Ayuno!',
      'Hoy es tu día de ayuno para "$tituloAyuno". ¡Que Dios te bendiga!',
      tz.TZDateTime.from(fechaRecordatorio, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Genera un ID único para la notificación
  static int _generateNotificationId(String userId, String fastingId, String dia, {bool isReminder = false}) {
    final prefix = isReminder ? 'rem' : 'conf';
    final combined = '$prefix:$userId:$fastingId:$dia';
    return combined.hashCode.abs() % 2147483647; // Evitar overflow
  }

  /// Cancela notificaciones para un ayuno específico
  static Future<void> cancelFastingNotifications({
    required String userId,
    required String fastingId,
    required String dia,
  }) async {
    if (!_isInitialized) await initialize();

    final confirmationId = _generateNotificationId(userId, fastingId, dia);
    final reminderId = _generateNotificationId(userId, fastingId, dia, isReminder: true);

    await flutterLocalNotificationsPlugin.cancel(confirmationId);
    await flutterLocalNotificationsPlugin.cancel(reminderId);

    if (kDebugMode) {
      print('Notificaciones canceladas para: $userId, $fastingId, $dia');
    }
  }

  /// Cancela todas las notificaciones
  static Future<void> cancelAllNotifications() async {
    if (!_isInitialized) await initialize();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Obtiene notificaciones pendientes
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) await initialize();
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Muestra una notificación inmediata
  static Future<void> showImmediateNotification({
    required String titulo,
    required String mensaje,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'general',
      'Notificaciones Generales',
      channelDescription: 'Notificaciones generales de la aplicación',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      titulo,
      mensaje,
      notificationDetails,
      payload: payload,
    );
  }
} 