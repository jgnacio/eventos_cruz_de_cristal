import 'auth_service.dart';
import 'mock_auth_service.dart';
import 'firebase_auth_service.dart';
import 'firestore_service.dart';
import '../../shared/repositories/user_repository.dart';
import '../../shared/repositories/fasting_repository.dart';
import '../../shared/repositories/user_fasting_record_repository.dart';
import '../../shared/repositories/church_repository.dart';
import '../../shared/repositories/event_repository.dart';
import 'firebase_fasting_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Flag para determinar si usar Firebase o Mock
  static const bool _useFirebase = true; // ✅ Firebase activado
  
  AuthService? _authService;
  FirestoreService? _firestoreService;
  UserRepository? _userRepository;
  FastingRepository? _fastingRepository;
  UserFastingRecordRepository? _userFastingRecordRepository;
  ChurchRepository? _churchRepository;
  EventRepository? _eventRepository;
  FirebaseFastingService? _firebaseFastingService;

  // Getters para los servicios
  AuthService get authService {
    _authService ??= _useFirebase 
        ? FirebaseAuthService()
        : MockAuthService();
    return _authService!;
  }

  FirestoreService get firestoreService {
    _firestoreService ??= FirestoreService();
    return _firestoreService!;
  }

  UserRepository get userRepository {
    _userRepository ??= UserRepository();
    return _userRepository!;
  }

  FastingRepository get fastingRepository {
    _fastingRepository ??= FastingRepository();
    return _fastingRepository!;
  }

  UserFastingRecordRepository get userFastingRecordRepository {
    _userFastingRecordRepository ??= UserFastingRecordRepository();
    return _userFastingRecordRepository!;
  }

  ChurchRepository get churchRepository {
    _churchRepository ??= ChurchRepository();
    return _churchRepository!;
  }

  EventRepository get eventRepository {
    _eventRepository ??= EventRepository();
    return _eventRepository!;
  }

  FirebaseFastingService get firebaseFastingService {
    _firebaseFastingService ??= FirebaseFastingService();
    return _firebaseFastingService!;
  }

  // Método para testing - forzar uso del mock service
  void useTestingServices() {
    _authService = MockAuthService();
  }

  // Método para producción - forzar uso de Firebase
  void useProductionServices() {
    if (_useFirebase) {
      _authService = FirebaseAuthService();
    } else {
      throw Exception('Firebase no está configurado. Configura Firebase primero.');
    }
  }

  // Reset para testing
  void reset() {
    _authService = null;
    _firestoreService = null;
    _userRepository = null;
    _fastingRepository = null;
    _userFastingRecordRepository = null;
    _churchRepository = null;
    _eventRepository = null;
    _firebaseFastingService = null;
  }
} 