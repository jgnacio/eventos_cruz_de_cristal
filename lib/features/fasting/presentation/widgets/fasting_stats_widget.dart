import 'package:flutter/material.dart';
import '../../../../shared/models/fasting_model.dart';

class FastingStatsWidget extends StatelessWidget {
  final FastingModel fasting;
  
  const FastingStatsWidget({
    super.key,
    required this.fasting,
  });

  @override
  Widget build(BuildContext context) {
    final stats = _calculateStats();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas Detalladas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildStatsGrid(stats),
            const SizedBox(height: 20),
            _buildProgressBar(stats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Total Participantes',
          stats['totalParticipants'].toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          'Días Activos',
          '${stats['activeDays']}/7',
          Icons.calendar_today,
          Colors.green,
        ),
        _buildStatCard(
          'Día más Popular',
          stats['mostPopularDay'],
          Icons.trending_up,
          Colors.orange,
        ),
        _buildStatCard(
          'Promedio Diario',
          stats['averageDaily'].toStringAsFixed(1),
          Icons.bar_chart,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Map<String, dynamic> stats) {
    final progress = (stats['activeDays'] / 7.0).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cobertura Semanal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getProgressColor(progress),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: progress,
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: _getProgressColor(progress),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getProgressText(progress),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _calculateStats() {
    final participantCounts = <String, int>{};
    int totalUniqueParticipants = 0;
    int activeDays = 0;
    double totalParticipants = 0;

    // Calcular participantes por día
    for (final day in fasting.participantesPorDia.keys) {
      final count = fasting.getParticipantesForDay(day);
      participantCounts[day] = count;
      totalParticipants += count;
      if (count > 0) activeDays++;
    }

    // Calcular participantes únicos
    final allParticipants = <String>{};
    for (final participants in fasting.participantesPorDia.values) {
      allParticipants.addAll(participants);
    }
    totalUniqueParticipants = allParticipants.length;

    // Encontrar día más popular
    String mostPopularDay = 'N/A';
    int maxCount = 0;
    for (final entry in participantCounts.entries) {
      if (entry.value > maxCount) {
        maxCount = entry.value;
        mostPopularDay = _formatDayName(entry.key);
      }
    }

    // Promedio diario
    final averageDaily = activeDays > 0 ? totalParticipants / 7 : 0.0;

    return {
      'totalParticipants': totalUniqueParticipants,
      'activeDays': activeDays,
      'mostPopularDay': mostPopularDay,
      'averageDaily': averageDaily,
      'participantCounts': participantCounts,
    };
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _getProgressText(double progress) {
    if (progress >= 0.8) {
      return 'Excelente cobertura semanal';
    } else if (progress >= 0.5) {
      return 'Buena cobertura semanal';
    } else if (progress > 0) {
      return 'Cobertura semanal limitada';
    } else {
      return 'Sin participación registrada';
    }
  }

  String _formatDayName(String day) {
    const dayNames = {
      'lunes': 'Lunes',
      'martes': 'Martes',
      'miercoles': 'Miércoles',
      'jueves': 'Jueves',
      'viernes': 'Viernes',
      'sabado': 'Sábado',
      'domingo': 'Domingo',
    };
    return dayNames[day] ?? day;
  }
} 