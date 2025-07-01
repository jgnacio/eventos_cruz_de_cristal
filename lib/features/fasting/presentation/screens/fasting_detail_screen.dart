import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/mock_data_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/models/fasting_model.dart';
import '../../../../shared/models/user_model.dart';
import '../widgets/widgets.dart';

class FastingDetailScreen extends StatefulWidget {
  final String fastingId;
  
  const FastingDetailScreen({
    super.key,
    required this.fastingId,
  });

  @override
  State<FastingDetailScreen> createState() => _FastingDetailScreenState();
}

class _FastingDetailScreenState extends State<FastingDetailScreen> {
  final MockDataService _dataService = MockDataService();
  final _authService = ServiceLocator().authService;
  FastingModel? _fasting;
  UserModel? _currentUser;
  bool _isLoading = true;
  bool _isSaving = false;
  Set<String> _selectedDays = {};

  @override
  void initState() {
    super.initState();
    _loadFastingDetail();
  }

  Future<void> _loadFastingDetail() async {
    setState(() => _isLoading = true);
    
    try {
      final fastings = await _dataService.getFastings();
      final currentUser = _authService.currentUser;
      
      final fasting = fastings.firstWhere(
        (f) => f.id == widget.fastingId,
        orElse: () => throw Exception('Ayuno no encontrado'),
      );
      
      // Cargar días previamente seleccionados por el usuario
      final userSelectedDays = <String>{};
      if (currentUser != null) {
        for (final entry in fasting.participantesPorDia.entries) {
          if (entry.value.contains(currentUser.id)) {
            userSelectedDays.add(entry.key);
          }
        }
      }
      
      setState(() {
        _fasting = fasting;
        _currentUser = currentUser;
        _selectedDays = userSelectedDays;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar ayuno: $e')),
        );
        context.pop();
      }
    }
  }

  Future<void> _saveSelection() async {
    if (_fasting == null || _currentUser == null) return;
    
    setState(() => _isSaving = true);
    
    try {
      // Simular guardado (aquí irías a tu API real)
      await Future.delayed(const Duration(seconds: 1));
      
      // Actualizar participantes por día
      final updatedParticipantesPorDia = Map<String, List<String>>.from(
        _fasting!.participantesPorDia,
      );
      
      // Remover usuario de todos los días
      for (final day in AppConstants.daysOfWeek) {
        updatedParticipantesPorDia[day] = 
            (updatedParticipantesPorDia[day] ?? [])
                .where((id) => id != _currentUser!.id)
                .toList();
      }
      
      // Agregar usuario a días seleccionados
      for (final day in _selectedDays) {
        updatedParticipantesPorDia[day] = [
          ...(updatedParticipantesPorDia[day] ?? []),
          _currentUser!.id,
        ];
      }
      
      setState(() {
        _fasting = _fasting!.copyWith(
          participantesPorDia: updatedParticipantesPorDia,
        );
        _isSaving = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _selectedDays.isEmpty
                  ? 'Te has retirado del ayuno'
                  : 'Tu participación ha sido guardada',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Ayuno'),
        actions: [
          if (_fasting?.status == FastingStatus.abierto && _currentUser != null)
            TextButton.icon(
              onPressed: _isSaving ? null : _saveSelection,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Guardando...' : 'Guardar'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_fasting == null) {
      return const Center(
        child: Text('Ayuno no encontrado'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          if (_fasting!.status == FastingStatus.abierto && _currentUser != null) ...[
            _buildDaySelector(),
            const SizedBox(height: 24),
          ],
          _buildParticipantsSection(),
          const SizedBox(height: 24),
          WeeklyProgressWidget(
            fasting: _fasting!,
            currentUserId: _currentUser?.id,
          ),
          const SizedBox(height: 24),
          FastingStatsWidget(fasting: _fasting!),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fasting!.titulo,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _fasting!.status == FastingStatus.abierto
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _fasting!.status.displayName,
                          style: TextStyle(
                            color: _fasting!.status == FastingStatus.abierto
                                ? Colors.green[700]
                                : Colors.grey[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _fasting!.descripcion,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            if (_fasting!.fechaInicio != null && _fasting!.fechaFin != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Del ${_formatDate(_fasting!.fechaInicio!)} al ${_formatDate(_fasting!.fechaFin!)}',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selecciona los días que quieres ayunar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Puedes seleccionar uno o varios días de la semana',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            _buildWeeklyCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyCalendar() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: AppConstants.daysOfWeek.length,
      itemBuilder: (context, index) {
        final day = AppConstants.daysOfWeek[index];
        final displayName = AppConstants.daysOfWeekDisplay[day] ?? day;
        final isSelected = _selectedDays.contains(day);
        final participantCount = _fasting!.getParticipantesForDay(day);

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDays.remove(day);
              } else {
                _selectedDays.add(day);
              }
            });
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected 
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.05),
              border: Border.all(
                color: isSelected 
                    ? Colors.blue 
                    : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.blue[700] : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$participantCount participante${participantCount != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildParticipantsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Participantes por día',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...AppConstants.daysOfWeek.map((day) {
              final displayName = AppConstants.daysOfWeekDisplay[day] ?? day;
              final participantCount = _fasting!.getParticipantesForDay(day);
              final isUserParticipating = _currentUser != null && 
                  _fasting!.hasUserForDay(_currentUser!.id, day);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUserParticipating 
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: isUserParticipating
                      ? Border.all(color: Colors.blue.withOpacity(0.3))
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: participantCount > 0 
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          participantCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: participantCount > 0 
                                ? Colors.green[700]
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '$participantCount participante${participantCount != 1 ? 's' : ''}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUserParticipating)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Participando',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    final totalParticipantes = _fasting!.participantesPorDia.values
        .expand((participants) => participants)
        .toSet()
        .length;

    final totalDaysWithParticipants = _fasting!.participantesPorDia.values
        .where((participants) => participants.isNotEmpty)
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas del Ayuno',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Participantes',
                    totalParticipantes.toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Días Activos',
                    '$totalDaysWithParticipants/7',
                    Icons.calendar_today,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
} 