import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/fasting_model.dart';

class WeeklyProgressWidget extends StatelessWidget {
  final FastingModel fasting;
  final String? currentUserId;
  
  const WeeklyProgressWidget({
    super.key,
    required this.fasting,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progreso Semanal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildWeeklyGrid(),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: AppConstants.daysOfWeek.map((day) {
        final dayInitial = _getDayInitial(day);
        final participantCount = fasting.getParticipantesForDay(day);
        final isUserParticipating = currentUserId != null && 
            fasting.hasUserForDay(currentUserId!, day);
        
        return Column(
          children: [
            Text(
              dayInitial,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getColorForDay(participantCount, isUserParticipating),
                borderRadius: BorderRadius.circular(16),
                border: isUserParticipating 
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  participantCount.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: participantCount > 0 || isUserParticipating
                        ? Colors.white
                        : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _buildLegendItem(
          color: Colors.green.withValues(alpha: 0.8),
          text: 'Con participantes',
        ),
        const SizedBox(width: 16),
        _buildLegendItem(
          color: Colors.grey.withValues(alpha: 0.3),
          text: 'Sin participantes',
        ),
        const SizedBox(width: 16),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 1),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Tu participación',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  String _getDayInitial(String day) {
    const initials = {
      'lunes': 'L',
      'martes': 'M',
      'miercoles': 'X',
      'jueves': 'J',
      'viernes': 'V',
      'sabado': 'S',
      'domingo': 'D',
    };
    return initials[day] ?? day[0].toUpperCase();
  }

  Color _getColorForDay(int participantCount, bool isUserParticipating) {
    if (isUserParticipating) {
      return Colors.blue.withValues(alpha: 0.8);
    }
    
    if (participantCount > 0) {
      return Colors.green.withValues(alpha: 0.8);
    }
    
    return Colors.grey.withValues(alpha: 0.3);
  }
} 