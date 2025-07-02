// Integración completa con Firebase
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import '../../shared/models/user_model.dart';

class FirebaseAuthService implements AuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  UserModel? _currentUser;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  // Inicializar el servicio
  Future<void> initialize() async {
    print('Inicializando FirebaseAuthService...');
    
    // Verificar si ya hay un usuario autenticado
    final currentFirebaseUser = _firebaseAuth.currentUser;
    if (currentFirebaseUser != null) {
      print('Usuario ya autenticado encontrado: ${currentFirebaseUser.email}');
      try {
        _currentUser = await _getUserFromFirestore(currentFirebaseUser.uid);
        _authStateController.add(_currentUser);
        print('Usuario cargado desde Firestore exitosamente');
      } catch (e) {
        print('Error cargando usuario desde Firestore: $e');
        _currentUser = null;
        _authStateController.add(_currentUser);
      }
    }
    
    // Escuchar cambios en el estado de autenticación
    _firebaseAuth.authStateChanges().listen((User? firebaseUser) async {
      print('Cambio en estado de autenticación detectado');
      
      if (firebaseUser != null) {
        print('Usuario autenticado: ${firebaseUser.email}');
        try {
          _currentUser = await _getUserFromFirestore(firebaseUser.uid);
          print('Usuario cargado/creado exitosamente');
        } catch (e) {
          print('Error loading user from Firestore: $e');
          _currentUser = null;
        }
      } else {
        print('Usuario no autenticado');
        _currentUser = null;
      }
      _authStateController.add(_currentUser);
    });
    
    print('FirebaseAuthService inicializado correctamente');
  }

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('Intentando autenticar usuario con email: $email');
      
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('Autenticación exitosa. UID: ${credential.user?.uid}');
      
      if (credential.user != null) {
        print('Buscando documento del usuario en Firestore...');
        _currentUser = await _getUserFromFirestore(credential.user!.uid);
        print('Usuario encontrado/creado en Firestore: ${_currentUser?.nombre}');
        return _currentUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('Error de Firebase Auth: ${e.code} - ${e.message}');
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      print('Error inesperado durante el login: $e');
      throw Exception('Error inesperado durante el login: $e');
    }
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String name) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        // Crear el documento del usuario en Firestore
        final newUser = UserModel(
          id: credential.user!.uid,
          email: email,
          nombre: name,
          telefono: '',
          rol: UserRole.miembro,
          isVerified: credential.user!.emailVerified,
          createdAt: DateTime.now(),
        );
        
        await _saveUserToFirestore(newUser);
        _currentUser = newUser;
        
        return newUser;
      } else {
        throw Exception('Error al crear usuario');
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _currentUser = null;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw Exception('No hay usuario autenticado o el email ya está verificado');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _saveUserToFirestore(user);
      
      // Actualizar el displayName en Firebase Auth si es necesario
      if (_firebaseAuth.currentUser?.displayName != user.nombre) {
        await _firebaseAuth.currentUser?.updateDisplayName(user.nombre);
      }
      
      _currentUser = user;
      _authStateController.add(_currentUser);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  @override
  Future<UserModel> loginAsUser(UserModel user) async {
    // Este método no se usa en producción con Firebase
    // Solo está aquí para cumplir con la interfaz
    throw UnimplementedError('loginAsUser no está disponible en producción');
  }

  // Métodos privados para Firestore
  Future<UserModel> _getUserFromFirestore(String uid) async {
    try {
      print('Intentando obtener documento del usuario: $uid');
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists) {
        print('Documento encontrado en Firestore');
        final userData = doc.data()!;
        print('Datos del usuario: $userData');
        
        return UserModel.fromJson({
          'id': doc.id,
          ...userData,
        });
      } else {
        print('Documento no encontrado en Firestore. Creando automáticamente...');
        // Si el usuario no existe en Firestore, crear el documento automáticamente
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          print('Creando nuevo documento para usuario: ${user.email}');
          final newUser = UserModel(
            id: uid,
            email: user.email ?? '',
            nombre: user.displayName ?? 'Usuario',
            telefono: '',
            rol: UserRole.miembro,
            isVerified: user.emailVerified,
            createdAt: DateTime.now(),
          );
          
          await _saveUserToFirestore(newUser);
          print('Documento creado exitosamente en Firestore');
          return newUser;
        } else {
          throw Exception('Usuario no encontrado en Firestore y no se pudo crear automáticamente');
        }
      }
    } catch (e) {
      print('Error al acceder a Firestore: $e');
      rethrow;
    }
  }

  Future<void> _saveUserToFirestore(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toJson());
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No se encontró una cuenta con ese email');
      case 'wrong-password':
        return Exception('Contraseña incorrecta');
      case 'email-already-in-use':
        return Exception('Ya existe una cuenta con ese email');
      case 'weak-password':
        return Exception('La contraseña es muy débil');
      case 'invalid-email':
        return Exception('El email no es válido');
      case 'user-disabled':
        return Exception('Esta cuenta ha sido deshabilitada');
      case 'too-many-requests':
        return Exception('Demasiados intentos. Intenta más tarde');
      default:
        return Exception('Error de autenticación: ${e.message}');
    }
  }
} 