import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:korpomap/services/auth_service.dart';

class DashboardScreen extends StatelessWidget{

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text('KorpoMap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Dashboard - Patient list coming soon'),
      ),
    );

  }
}