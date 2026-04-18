import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:korpomap/models/injury.dart';
import 'package:korpomap/models/patient.dart';
import 'package:korpomap/models/muscle_group.dart';
import 'package:korpomap/services/injury_service.dart';
import 'package:korpomap/widgets/body_map/body_map_widget.dart';

/// Patient detail screen with body map and injury history tabs.
class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _injuryService = InjuryService();
  List<Injury> _injuries = [];
  bool _loadingInjuries = true;
  String _statusFilter = 'all';
  MuscleGroupId? _groupFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInjuries();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInjuries() async {
    try {
      final injuries =
          await _injuryService.getByPatient(widget.patient.id);
      if (mounted) {
        setState(() {
          _injuries = injuries;
          _loadingInjuries = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingInjuries = false);
    }
  }

  Map<MuscleGroupId, Color> get _muscleColors {
    final grouped = <MuscleGroupId, List<Injury>>{};
    for (final injury in _injuries) {
      grouped.putIfAbsent(injury.muscleGroup, () => []).add(injury);
    }
    final map = <MuscleGroupId, Color>{};
    for (final entry in grouped.entries) {
      final hasActive = entry.value.any((i) => i.isActive);
      map[entry.key] = hasActive
          ? const Color(0xFFFF0000)
          : const Color(0xFFFACC15);
    }
    return map;
  }

  int get _activeCount => _injuries.where((i) => i.isActive).length;
  int get _recoveredCount => _injuries.where((i) => !i.isActive).length;

  List<Injury> get _filteredInjuries {
    final list = _injuries.where((i) {
      if (_statusFilter == 'active' && !i.isActive) return false;
      if (_statusFilter == 'recovered' && i.isActive) return false;
      if (_groupFilter != null && i.muscleGroup != _groupFilter) return false;
      return true;
    }).toList()
      ..sort((a, b) => b.injuryDate.compareTo(a.injuryDate));
    return list;
  }

  Set<MuscleGroupId> get _groupsWithInjuries =>
      _injuries.map((i) => i.muscleGroup).toSet();

  String _calculateAge() {
    if (widget.patient.birthDate == null) return '';
    final now = DateTime.now();
    final bd = widget.patient.birthDate!;
    var age = now.year - bd.year;
    if (now.month < bd.month || (now.month == bd.month && now.day < bd.day)) {
      age--;
    }
    return '$age anos';
  }

  void _showMuscleGroupSheet(MuscleGroupId groupId) {
    final group = MuscleGroup.all[groupId]!;
    final groupInjuries =
        _injuries.where((i) => i.muscleGroup == groupId).toList()
          ..sort((a, b) => b.injuryDate.compareTo(a.injuryDate));
    final activeInGroup = groupInjuries.where((i) => i.isActive).length;
    final recoveredInGroup = groupInjuries.length - activeInGroup;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Container(
          height: MediaQuery.of(sheetContext).size.height * 0.50,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        group.label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: groupInjuries.isEmpty
                            ? Colors.grey[200]
                            : activeInGroup > 0
                                ? const Color(0xFFEF4444)
                                    .withValues(alpha: 0.1)
                                : const Color(0xFFFACC15)
                                    .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        groupInjuries.isEmpty
                            ? 'Sin lesiones'
                            : '$activeInGroup activa${activeInGroup == 1 ? '' : 's'} · $recoveredInGroup recuperada${recoveredInGroup == 1 ? '' : 's'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: groupInjuries.isEmpty
                              ? Colors.grey[600]
                              : activeInGroup > 0
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFFCA8A04),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Muscle list chips
              if (group.muscles.length > 1)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: group.muscles
                        .map((muscle) => Chip(
                              label: Text(muscle,
                                  style: const TextStyle(fontSize: 12)),
                              backgroundColor: const Color(0xFF8B5CF6)
                                  .withValues(alpha: 0.08),
                              side: BorderSide.none,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 12),

              // Injury list or empty state
              Expanded(
                child: groupInjuries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.healing_outlined,
                                size: 48, color: Colors.grey[300]),
                            const SizedBox(height: 12),
                            Text(
                              'No hay lesiones registradas\npara este grupo muscular',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: groupInjuries.length,
                        itemBuilder: (context, index) {
                          final injury = groupInjuries[index];
                          return _buildInjuryCard(
                            injury,
                            onToggle: () async {
                              final newStatus = injury.isActive
                                  ? 'recovered'
                                  : 'active';
                              await _injuryService.update(
                                injury.id,
                                {...injury.toJson(), 'status': newStatus},
                              );
                              await _loadInjuries();
                              // Refresh bottom sheet data
                              final updated = _injuries
                                  .where((i) => i.muscleGroup == groupId)
                                  .toList();
                              setSheetState(() {
                                groupInjuries
                                  ..clear()
                                  ..addAll(updated);
                              });
                            },
                            onTap: () async {
                              Navigator.pop(sheetContext);
                              final result = await context.push(
                                '/patient/${widget.patient.id}/injury/${injury.id}/edit',
                                extra: {
                                  'muscleGroup': groupId,
                                  'injury': injury,
                                },
                              );
                              if (result == true) _loadInjuries();
                            },
                          );
                        },
                      ),
              ),

              // Action button
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(sheetContext);
                      final result = await context.push(
                        '/patient/${widget.patient.id}/injury/new',
                        extra: {'muscleGroup': groupId},
                      );
                      if (result == true) _loadInjuries();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva lesion'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8B5CF6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF8B5CF6)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInjuryCard(
    Injury injury, {
    VoidCallback? onToggle,
    VoidCallback? onTap,
  }) {
    final severityColor = switch (injury.severity) {
      'mild' => const Color(0xFF22C55E),
      'severe' => const Color(0xFFEF4444),
      _ => const Color(0xFFF59E0B),
    };
    final severityLabel = switch (injury.severity) {
      'mild' => 'Leve',
      'severe' => 'Severa',
      _ => 'Moderada',
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Severity dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: severityColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    injury.muscle ??
                        MuscleGroup.all[injury.muscleGroup]?.label ??
                        '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$severityLabel · ${DateFormat('dd/MM/yyyy').format(injury.injuryDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  if (injury.description != null &&
                      injury.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        injury.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ),
                ],
              ),
            ),
            // Status chip (tappable)
            GestureDetector(
              onTap: onToggle,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: injury.isActive
                      ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                      : const Color(0xFF22C55E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  injury.isActive ? 'Activa' : 'Recuperada',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: injury.isActive
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF22C55E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.patient.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final result = await context.push(
                '/patient/${widget.patient.id}/edit',
                extra: widget.patient,
              );
              if (result == true && context.mounted) {
                context.pop(true);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Patient info card (compact)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  child: Text(
                    _getInitials(widget.patient.name),
                    style: const TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    [
                      if (age.isNotEmpty) age,
                      if (widget.patient.phone != null) widget.patient.phone,
                    ].join(' · '),
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _activeCount > 0
                        ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                        : const Color(0xFF22C55E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_activeCount activa${_activeCount != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: _activeCount > 0
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF22C55E),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF8B5CF6),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF8B5CF6),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Mapa corporal'),
                Tab(text: 'Historial'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Body map
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: BodyMapWidget(
                    muscleColors: _muscleColors,
                    onMuscleGroupTap: _showMuscleGroupSheet,
                  ),
                ),

                // Tab 2: Injury history
                _loadingInjuries
                    ? const Center(child: CircularProgressIndicator())
                    : _injuries.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.history,
                                    size: 48, color: Colors.grey[300]),
                                const SizedBox(height: 12),
                                Text(
                                  'No hay lesiones registradas\npara este paciente',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          )
                        : _buildHistoryView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView() {
    final filtered = _filteredInjuries;
    final groups = _groupsWithInjuries.toList()
      ..sort((a, b) => (MuscleGroup.all[a]?.label ?? '')
          .compareTo(MuscleGroup.all[b]?.label ?? ''));

    return Column(
      children: [
        // Counter
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              _buildCounterPill(
                '$_activeCount activa${_activeCount == 1 ? '' : 's'}',
                const Color(0xFFEF4444),
              ),
              const SizedBox(width: 8),
              _buildCounterPill(
                '$_recoveredCount recuperada${_recoveredCount == 1 ? '' : 's'}',
                const Color(0xFFCA8A04),
              ),
              const SizedBox(width: 8),
              _buildCounterPill(
                '${_injuries.length} total',
                Colors.grey[600]!,
              ),
            ],
          ),
        ),

        // Status filter chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildStatusChip('Todas', 'all'),
              const SizedBox(width: 8),
              _buildStatusChip('Activas', 'active'),
              const SizedBox(width: 8),
              _buildStatusChip('Recuperadas', 'recovered'),
            ],
          ),
        ),

        // Muscle group dropdown
        if (groups.length > 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: DropdownButtonFormField<MuscleGroupId?>(
              initialValue: _groupFilter,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Grupo muscular',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                isDense: true,
              ),
              items: [
                const DropdownMenuItem<MuscleGroupId?>(
                  value: null,
                  child: Text('Todos los grupos'),
                ),
                ...groups.map(
                  (g) => DropdownMenuItem<MuscleGroupId?>(
                    value: g,
                    child: Text(MuscleGroup.all[g]?.label ?? ''),
                  ),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _groupFilter = value),
            ),
          ),

        // List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'Sin resultados para el filtro actual',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final injury = filtered[index];
                    return _buildInjuryCard(
                      injury,
                      onToggle: () async {
                        final newStatus =
                            injury.isActive ? 'recovered' : 'active';
                        await _injuryService.update(
                          injury.id,
                          {...injury.toJson(), 'status': newStatus},
                        );
                        _loadInjuries();
                      },
                      onTap: () async {
                        final result = await context.push(
                          '/patient/${widget.patient.id}/injury/${injury.id}/edit',
                          extra: {
                            'muscleGroup': injury.muscleGroup,
                            'injury': injury,
                          },
                        );
                        if (result == true) _loadInjuries();
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCounterPill(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    final selected = _statusFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _statusFilter = value),
      selectedColor: const Color(0xFF8B5CF6),
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.grey[700],
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      backgroundColor: Colors.grey[100],
      side: BorderSide.none,
      showCheckmark: false,
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
