import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:korpomap/config/supabase_config.dart';

/// Authentication service that centralizes all Supabase Auth calls.
class AuthService {
  final _client = SupabaseConfig.client;

  /// Signs in a user with email and password.
  Future<AuthResponse> signIn(String email, String password) async{
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  } //signIn

  /// Registers a new user with email and password.
  Future<AuthResponse> signUp(String email, String password) async{
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }//signUp

  /// Signs out the current user.
  Future<void> signOut() async{
    await _client.auth.signOut();
  }//signOut

  /// Returns the currently authenticated user, or null if no session exists.
  User? get currentUser => _client.auth.currentUser;



} //AuthService