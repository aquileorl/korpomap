import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://iicaqhoalhdpqyfpwvlr.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlpY2FxaG9hbGhkcHF5ZnB3dmxyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzI5MDY3NTAsImV4cCI6MjA4ODQ4Mjc1MH0.5ce_-czJPKHhNTqfWkSSpo9Nr-n8WOOoJB37g6CEMw0',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
