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

  Future<void> _confirmDelete(Patient patient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar paciente'),
        content: Text('¿Seguro que desea eliminar a ${patient.name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      )
    );

    if (confirmed == true){
      try {
        await _patientService.delete(patient.id);
        _loadPatients();
      } catch(e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting patient: $e')),
          );
        }
      }
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(patient),
                  ),
                  onTap: () async {
                    final result = await context.push(
                      '/patient/${patient.id}/edit',
                      extra: patient,
                    );
                    if (result == true) _loadPatients();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push('/patient/new');
          if (result == true) _loadPatients();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}