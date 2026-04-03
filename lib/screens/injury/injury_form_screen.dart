import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:korpomap/models/injury.dart';
import 'package:korpomap/models/muscle_group.dart';
import 'package:korpomap/services/injury_service.dart';

/// Form screen for creating and editing injuries.
///
/// When [injury] is null the form runs in creation mode.
/// When [injury] is provided the fields are pre-filled for editing.
class InjuryFormScreen extends StatefulWidget {
  final String patientId;
  final MuscleGroupId muscleGroup;
  final Injury? injury;

  const InjuryFormScreen({
    super.key,
    required this.patientId,
    required this.muscleGroup,
    this.injury,
  });

  bool get isEditing => injury != null;

  @override
  State<InjuryFormScreen> createState() => _InjuryFormScreenState();
}

class _InjuryFormScreenState extends State<InjuryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _injuryService = InjuryService();

  late final TextEditingController _descriptionController;
  String? _selectedMuscle;
  String _severity = 'moderate';
  String _status = 'active';
  late DateTime _injuryDate;
  bool _loading = false;

  MuscleGroup get _group => MuscleGroup.all[widget.muscleGroup]!;

  @override
  void initState() {
    super.initState();
    final injury = widget.injury;
    _descriptionController =
        TextEditingController(text: injury?.description ?? '');
    _selectedMuscle = injury?.muscle;
    _severity = injury?.severity ?? 'moderate';
    _status = injury?.status ?? 'active';
    _injuryDate = injury?.injuryDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _injuryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _injuryDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final data = {
      'patient_id': widget.patientId,
      'muscle_group': widget.muscleGroup.name,
      'muscle': _selectedMuscle,
      'description': _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      'severity': _severity,
      'status': _status,
      'injury_date': _injuryDate.toIso8601String().split('T').first,
    };

    try {
      if (widget.isEditing) {
        await _injuryService.update(widget.injury!.id, data);
      } else {
        await _injuryService.create(data);
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
        title: Text(widget.isEditing ? 'Editar lesion' : 'Nueva lesion'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Muscle group (read-only)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF8B5CF6), size: 20),
                    const SizedBox(width: 10),
                    Text(
                      _group.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Specific muscle (optional dropdown)
              if (_group.muscles.length > 1) ...[
                DropdownButtonFormField<String>(
                  initialValue: _selectedMuscle,
                  decoration: const InputDecoration(
                    labelText: 'Musculo especifico (opcional)',
                    prefixIcon: Icon(Icons.my_location),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('General (todo el grupo)'),
                    ),
                    ..._group.muscles.map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m),
                        )),
                  ],
                  onChanged: (value) => setState(() => _selectedMuscle = value),
                ),
                const SizedBox(height: 20),
              ],

              // Severity
              const Text(
                'Severidad',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildSeverityChip('Leve', 'mild', const Color(0xFF22C55E)),
                  const SizedBox(width: 8),
                  _buildSeverityChip(
                      'Moderada', 'moderate', const Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  _buildSeverityChip(
                      'Severa', 'severe', const Color(0xFFEF4444)),
                ],
              ),
              const SizedBox(height: 20),

              // Date picker
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Fecha de la lesion',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(_injuryDate),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripcion (opcional)',
                  prefixIcon: Icon(Icons.notes),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Status toggle (edit mode only)
              if (widget.isEditing)
                SwitchListTile(
                  title: const Text('Lesion activa'),
                  subtitle: Text(
                    _status == 'active' ? 'En tratamiento' : 'Recuperada',
                  ),
                  value: _status == 'active',
                  activeThumbColor: const Color(0xFFEF4444),
                  onChanged: (value) {
                    setState(() {
                      _status = value ? 'active' : 'recovered';
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),

              const SizedBox(height: 32),

              // Save button
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

  Widget _buildSeverityChip(String label, String value, Color color) {
    final isSelected = _severity == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _severity = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
