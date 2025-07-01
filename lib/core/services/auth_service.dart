import '../../shared/models/user_model.dart';

abstract class AuthService {
  UserModel? get currentUser;
  Stream<UserModel?> get authStateChanges;
  
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> createUserWithEmailAndPassword(String email, String password, String name);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
  Future<void> updateUserProfile(UserModel user);
  
  // Método específico para testing
  Future<UserModel> loginAsUser(UserModel user);
} 