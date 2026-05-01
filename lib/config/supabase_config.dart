import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {

  static const String _supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://iicaqhoalhdpqyfpwvlr.supabase.co',
  );

  static const String _supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  static Future<void> init() async {
    if (_supabaseAnonKey.isEmpty){
      throw StateError('SUPABASE_ANON_KEY missing. Build with --dart-define=SUPABASE_ANON_KEY=<key>');
    }
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
