import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:korpomap/services/auth_service.dart';
import 'package:korpomap/services/patient_service.dart';
import 'package:korpomap/models/patient.dart';

class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}


class _DashboardScreenState extends State<DashboardScreen> {

  final _patientService = PatientService();
  List<Patient> _patients = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    setState(() => _loading = true);

    try {
      final patients = await _patientService.getAll();
      if (mounted) setState(() => _patients = patients);
    } catch(e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading patients: $e')),
        );
      }
    } finally {
      if (mounted) setState (() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _patients.isEmpty
          ? const Center(child: Text('No hay pacientes aún'))
          : ListView.builder(
              itemCount: _patients.length,
              itemBuilder: (context, index){
                final patient = _patients[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(patient.name),
                  subtitle: Text(patient.email ?? patient.phone ?? ''),
                  // TODO: onTap -> navigate to patient details
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: navigate to create_patient screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}