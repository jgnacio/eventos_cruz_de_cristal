class AppConstants {
  // App Info
  static const String appName = 'Eventos Cruz de Cristal';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.eventoscruzdecruzal.com/v1';
  static const String apiKey = 'YOUR_API_KEY_HERE';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String selectedChurchesKey = 'selected_churches';
  static const String notificationSettingsKey = 'notification_settings';
  
  // Notification Settings
  static const String fcmTopic = 'all_users';
  static const Duration reminderBeforeEvent24h = Duration(hours: 24);
  static const Duration reminderBeforeEvent1h = Duration(hours: 1);
  static const Duration fastingReminderTime = Duration(hours: 21); // 21:00
  
  // Pagination
  static const int pageSize = 20;
  static const int maxPageSize = 100;
  
  // Validation
  static const int minPasswordLength = 6;
  static const int maxDescriptionLength = 1000;
  static const int maxTitleLength = 100;
  
  // File Upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageExtensions = ['.jpg', '.jpeg', '.png'];
  
  // Time Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Colors (si decides no usar Material Design completamente)
  static const String primaryColor = '#6200EE';
  static const String secondaryColor = '#03DAC6';
  static const String errorColor = '#B00020';
  static const String backgroundColor = '#FAFAFA';
  
  // Days of Week for Fasting
  static const List<String> daysOfWeek = [
    'lunes',
    'martes',
    'miercoles',
    'jueves',
    'viernes',
    'sabado',
    'domingo'
  ];
  
  static const Map<String, String> daysOfWeekDisplay = {
    'lunes': 'Lunes',
    'martes': 'Martes',
    'miercoles': 'Miércoles',
    'jueves': 'Jueves',
    'viernes': 'Viernes',
    'sabado': 'Sábado',
    'domingo': 'Domingo',
  };
  
  // Error Messages
  static const String networkErrorMessage = 'Error de conexión. Verifica tu internet.';
  static const String serverErrorMessage = 'Error del servidor. Intenta más tarde.';
  static const String unknownErrorMessage = 'Error desconocido. Intenta más tarde.';
  static const String unauthorizedErrorMessage = 'No tienes permisos para esta acción.';
  
  // Success Messages
  static const String eventCreatedMessage = 'Evento creado exitosamente';
  static const String fastingCreatedMessage = 'Ayuno creado exitosamente';
  static const String churchRegisteredMessage = 'Solicitud de iglesia enviada exitosamente';
  static const String profileUpdatedMessage = 'Perfil actualizado exitosamente';
} 