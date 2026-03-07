import 'package:flutter/material.dart';
import 'package:korpomap/config/theme.dart';
import 'package:korpomap/config/supabase_config.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.init();

  runApp(const KorpoMapApp());
}

class KorpoMapApp extends StatelessWidget {
  const KorpoMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KorpoMap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(
          child: Text('KorpoMap'),
        ),
      ),
    );
  }
}
