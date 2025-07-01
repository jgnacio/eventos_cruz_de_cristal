import 'dart:async';
import 'auth_service.dart';
import '../../shared/models/user_model.dart';

class MockAuthService implements AuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();

  UserModel? _currentUser;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  // Mock Users para testing
  static final List<UserModel> _mockUsers = [
    UserModel(
      id: '1',
      email: 'admin@global.com',
      nombre: 'Administrador Global',
      telefono: '+1234567890',
      rol: UserRole.administradorGlobal,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserModel(
      id: '2',
      email: 'pastor@iglesia.com',
      nombre: 'Pastor Juan Pérez',
      telefono: '+1234567891',
      rol: UserRole.administradorIglesia,
      isVerified: true,
      iglesiasAsistidas: ['1'],
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    UserModel(
      id: '3',
      email: 'miembro@iglesia.com',
      nombre: 'María García',
      telefono: '+1234567892',
      rol: UserRole.miembro,
      isVerified: true,
      iglesiasAsistidas: ['1', '2'],
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    UserModel(
      id: '4',
      email: 'pedro@iglesia.com',
      nombre: 'Pedro Rodríguez',
      telefono: '+1234567893',
      rol: UserRole.miembro,
      isVerified: true,
      iglesiasAsistidas: ['1'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));
    
    // Buscar usuario por email
    try {
      final user = _mockUsers.firstWhere((user) => user.email == email);
      _currentUser = user;
      _authStateController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      throw Exception('Usuario no encontrado o credenciales incorrectas');
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 2));
    
    // Verificar que el email no exista
    final existingUser = _mockUsers.where((user) => user.email == email).firstOrNull;
    if (existingUser != null) {
      throw Exception('El email ya está registrado');
    }
    
    // Crear nuevo usuario
    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      nombre: name,
      telefono: '',
      rol: UserRole.miembro,
      isVerified: false,
      createdAt: DateTime.now(),
    );
    
    _mockUsers.add(newUser);
    _currentUser = newUser;
    _authStateController.add(_currentUser);
    
    return newUser;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _authStateController.add(_currentUser);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Verificar que el email existe
    final user = _mockUsers.where((user) => user.email == email).firstOrNull;
    if (user == null) {
      throw Exception('No se encontró una cuenta con ese email');
    }
    
    // Simular envío de email
    print('Email de recuperación enviado a: $email');
  }

  @override
  Future<void> sendEmailVerification() async {
    if (_currentUser == null) {
      throw Exception('No hay usuario autenticado');
    }
    
    await Future.delayed(const Duration(seconds: 1));
    
    // Simular envío de verificación
    print('Email de verificación enviado a: ${_currentUser!.email}');
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentUser?.id != user.id) {
      throw Exception('No tienes permisos para actualizar este perfil');
    }
    
    // Actualizar usuario en la lista mock
    final index = _mockUsers.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _mockUsers[index] = user;
      _currentUser = user;
      _authStateController.add(_currentUser);
    }
  }

  @override
  Future<UserModel> loginAsUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  // Métodos adicionales para testing
  List<UserModel> get allTestUsers => List.unmodifiable(_mockUsers);
  
  void dispose() {
    _authStateController.close();
  }
} 