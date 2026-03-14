import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:korpomap/config/supabase_config.dart';
import 'package:korpomap/models/patient.dart';
import 'package:korpomap/services/patient_service.dart';

/// Reusable form screen for creating and editing patients.
///
/// When [patient] is null the form runs in creation mode.
/// When [patient] is provided the fields are pre-filled for editing.
class PatientFormScreen extends StatefulWidget {
  final Patient? patient;
  const PatientFormScreen({super.key, this.patient});

  /// Returns true when the screen is editing an existing patient.
  bool get isEditing => patient != null;

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientService = PatientService();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  DateTime? _birthDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name ?? '');
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
    _phoneController = TextEditingController(text: widget.patient?.phone ?? '');
    _notesController = TextEditingController(text: widget.patient?.notes ?? '');
    _birthDate = widget.patient?.birthDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  /// Opens a date picker dialog and updates [_birthDate] with the selection.
  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  /// Validates the form, sends data to Supabase (create or update),
  /// and pops back with [true] so the caller can refresh its list.
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final userId = SupabaseConfig.client.auth.currentUser!.id;

    final data = {
      'user_id': userId,
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      'phone': _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      'birth_date': _birthDate?.toIso8601String().split('T').first,
      'notes': _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    };

    try {
      if (widget.isEditing) {
        await _patientService.update(widget.patient!.id, data);
      } else {
        await _patientService.create(data);
      }
      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar paciente' : 'Nuevo paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickBirthDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      prefixIcon: const Icon(Icons.calendar_today),
                      hintText: _birthDate != null
                          ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                          : 'Seleccionar fecha',
                    ),
                    controller: TextEditingController(
                      text: _birthDate != null
                          ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                          : '',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _save,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save),
                  label: Text(widget.isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
