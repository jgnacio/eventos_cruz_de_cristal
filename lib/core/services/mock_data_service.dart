import 'dart:math';
import '../../shared/models/user_model.dart';
import '../../shared/models/church_model.dart';
import '../../shared/models/event_model.dart';
import '../../shared/models/fasting_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock Users
  static final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      email: 'admin@test.com',
      nombre: 'Administrador Global',
      telefono: '+1234567890',
      rol: UserRole.administradorGlobal,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserModel(
      id: '2',
      email: 'iglesia@test.com',
      nombre: 'Pastor Juan',
      telefono: '+1234567891',
      rol: UserRole.administradorIglesia,
      isVerified: true,
      iglesiasAsistidas: ['1'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    UserModel(
      id: '3',
      email: 'miembro@test.com',
      nombre: 'María García',
      telefono: '+1234567892',
      rol: UserRole.miembro,
      isVerified: true,
      iglesiasAsistidas: ['1', '2'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  // Mock Churches
  static final List<ChurchModel> _mockChurches = [
    ChurchModel(
      id: '1',
      nombre: 'Iglesia Central',
      direccion: 'Av. Principal 123',
      ciudad: 'Ciudad de México',
      email: 'central@iglesia.com',
      telefono: '+5512345678',
      administradorId: '2',
      asistentes: ['2', '3'],
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    ChurchModel(
      id: '2',
      nombre: 'Iglesia del Valle',
      direccion: 'Calle Valle 456',
      ciudad: 'Guadalajara',
      email: 'valle@iglesia.com',
      telefono: '+5512345679',
      administradorId: '4',
      asistentes: ['3'],
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
  ];

  // Mock Events
  static final List<EventModel> _mockEvents = [
    EventModel(
      id: '1',
      titulo: 'Conferencia de Jóvenes',
      descripcion: 'Una conferencia especial para jóvenes de toda la comunidad.',
      fechaInicio: DateTime.now().add(const Duration(days: 7)),
      fechaFin: DateTime.now().add(const Duration(days: 7, hours: 3)),
      ubicacion: 'Iglesia Central - Auditorio',
      iglesiaId: '1',
      likes: ['2', '3'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    EventModel(
      id: '2',
      titulo: 'Retiro Espiritual',
      descripcion: 'Retiro de fin de semana para toda la familia.',
      fechaInicio: DateTime.now().add(const Duration(days: 14)),
      fechaFin: DateTime.now().add(const Duration(days: 16)),
      ubicacion: 'Centro de Retiros Monte Tabor',
      iglesiaId: '1',
      likes: ['3'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // Mock Fasting
  static final List<FastingModel> _mockFastings = [
    FastingModel(
      id: '1',
      titulo: 'Ayuno por la Paz',
      descripcion: 'Ayuno comunitario por la paz mundial.',
      fechaInicio: DateTime.now().subtract(const Duration(days: 1)),
      fechaFin: DateTime.now().add(const Duration(days: 6)),
      iglesiaId: '1',
      participantesPorDia: {
        'lunes': ['2', '3'],
        'miercoles': ['3'],
        'viernes': ['2'],
      },
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Authentication Mock
  UserModel? _currentUser;

  Future<UserModel?> login(String email, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));
    
    // Buscar usuario por email
    try {
      _currentUser = _mockUsers.firstWhere((user) => user.email == email);
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  Future<UserModel> loginAsUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = user;
    return user;
  }

  UserModel? get currentUser => _currentUser;

  // Data Getters
  Future<List<ChurchModel>> getChurches() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.from(_mockChurches);
  }

  Future<List<EventModel>> getEvents() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.from(_mockEvents);
  }

  Future<List<EventModel>> getUpcomingEvents() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockEvents
        .where((event) => event.isFutureEvent)
        .toList();
  }

  Future<List<FastingModel>> getFastings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockFastings);
  }

  // Event Actions
  Future<void> toggleEventLike(String eventId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final eventIndex = _mockEvents.indexWhere((e) => e.id == eventId);
    if (eventIndex != -1) {
      final event = _mockEvents[eventIndex];
      final likes = List<String>.from(event.likes);
      
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }
      
      _mockEvents[eventIndex] = event.copyWith(likes: likes);
    }
  }

  // Random data generation helpers
  static String _randomId() {
    return Random().nextInt(99999).toString();
  }
} 