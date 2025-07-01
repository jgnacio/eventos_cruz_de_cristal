class AppConstants {
  // App Info
  static const String appName = 'Eventos Cruz de Cristal';
  static const String appVersion = '1.0.0';
  
  // Design Constants
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double largeBorderRadius = 20.0;
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;
  
  // Text Sizes
  static const double textSmall = 12.0;
  static const double textMedium = 14.0;
  static const double textLarge = 16.0;
  static const double textXLarge = 18.0;
  
  // Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Colors
  static const primaryColorValue = 0xFF6366F1; // Indigo
  static const secondaryColorValue = 0xFF8B5CF6; // Purple
  static const tertiaryColorValue = 0xFF06B6D4; // Cyan
  
  // Gradients
  static const List<int> primaryGradient = [0xFF6366F1, 0xFF8B5CF6];
  static const List<int> secondaryGradient = [0xFF8B5CF6, 0xFF06B6D4];
  static const List<int> accentGradient = [0xFF06B6D4, 0xFF10B981];
  
  // Bible Verses
  static const List<Map<String, String>> bibleVerses = [
    {
      'verse': '"Porque yo sé los pensamientos que tengo acerca de vosotros, dice Jehová, pensamientos de paz, y no de mal, para daros el fin que esperáis."',
      'reference': 'Jeremías 29:11'
    },
    {
      'verse': '"Porque donde están dos o tres congregados en mi nombre, allí estoy yo en medio de ellos."',
      'reference': 'Mateo 18:20'
    },
    {
      'verse': '"No dejando de congregarnos, como algunos tienen por costumbre, sino exhortándonos..."',
      'reference': 'Hebreos 10:25'
    },
    {
      'verse': '"Todo tiene su tiempo, y todo lo que se quiere debajo del cielo tiene su hora."',
      'reference': 'Eclesiastés 3:1'
    },
    {
      'verse': '"Acercaos a Dios, y él se acercará a vosotros."',
      'reference': 'Santiago 4:8'
    },
    {
      'verse': '"Jehová es mi pastor; nada me faltará."',
      'reference': 'Salmos 23:1'
    },
  ];
  
  // Feature Cards Data
  static const List<Map<String, dynamic>> featureCards = [
    {
      'title': 'Eventos',
      'subtitle': 'Próximos cultos y actividades',
      'icon': 'event_note_rounded',
      'route': '/events',
      'gradientColors': primaryGradient,
    },
    {
      'title': 'Iglesias',
      'subtitle': 'Encuentra tu congregación',
      'icon': 'church_rounded',
      'route': '/churches',
      'gradientColors': [secondaryColorValue, 0xFF8B5CF6],
    },
    {
      'title': 'Ayunos',
      'subtitle': 'Únete en oración y ayuno',
      'icon': 'favorite_rounded',
      'route': '/fasting',
      'gradientColors': [tertiaryColorValue, 0xFF10B981],
    },
    {
      'title': 'Configuración',
      'subtitle': 'Personaliza tu experiencia',
      'icon': 'settings_rounded',
      'route': '/settings',
      'gradientColors': [0xFF6B7280, 0xFF9CA3AF],
    },
  ];
  
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
  
  AppConstants._();
} 