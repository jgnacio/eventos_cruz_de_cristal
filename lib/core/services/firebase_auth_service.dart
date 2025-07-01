// Descomenta cuando integres Firebase
/*
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
    // Escuchar cambios en el estado de autenticación
    _firebaseAuth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser != null) {
        try {
          _currentUser = await _getUserFromFirestore(firebaseUser.uid);
        } catch (e) {
          print('Error loading user from Firestore: $e');
          _currentUser = null;
        }
      } else {
        _currentUser = null;
      }
      _authStateController.add(_currentUser);
    });
  }

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        _currentUser = await _getUserFromFirestore(credential.user!.uid);
        return _currentUser;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
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
    final doc = await _firestore.collection('users').doc(uid).get();
    
    if (doc.exists) {
      return UserModel.fromJson({
        'id': doc.id,
        ...doc.data()!,
      });
    } else {
      throw Exception('Usuario no encontrado en Firestore');
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
*/

// Clase placeholder para evitar errores mientras no uses Firebase
class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();
} 