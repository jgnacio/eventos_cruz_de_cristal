import 'auth_service.dart';
import 'mock_auth_service.dart';
import 'firebase_auth_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Flag para determinar si usar Firebase o Mock
  static const bool _useFirebase = false; // Cambia a true cuando integres Firebase
  
  AuthService? _authService;

  // Getters para los servicios
  AuthService get authService {
    _authService ??= _useFirebase 
        ? FirebaseAuthService() as AuthService // Descomenta cuando tengas Firebase
        : MockAuthService();
    return _authService!;
  }

  // Método para testing - forzar uso del mock service
  void useTestingServices() {
    _authService = MockAuthService();
  }

  // Método para producción - forzar uso de Firebase
  void useProductionServices() {
    if (_useFirebase) {
      _authService = FirebaseAuthService() as AuthService;
    } else {
      throw Exception('Firebase no está configurado. Configura Firebase primero.');
    }
  }

  // Reset para testing
  void reset() {
    _authService = null;
  }
} 