import 'package:flutter/material.dart';
import '../../../../core/services/fasting_record_service.dart';
import '../../../../shared/models/user_fasting_record_model.dart';
import '../../../../shared/models/fasting_model.dart';

class FastingConfirmationScreen extends StatefulWidget {
  const FastingConfirmationScreen({super.key});

  @override
  State<FastingConfirmationScreen> createState() => _FastingConfirmationScreenState();
}

class _FastingConfirmationScreenState extends State<FastingConfirmationScreen> {
  List<UserFastingRecord> pendingConfirmations = [];
  List<UserFastingRecord> todaysFastings = [];
  bool isLoading = true;
  String? currentUserId; // En una implementación real, obtener del servicio de auth

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    
    // En una implementación real, obtener el userId del servicio de autenticación
    currentUserId = 'user_123'; // Placeholder
    
    try {
      final pending = await FastingRecordService.getPendingConfirmationsForToday(currentUserId!);
      final today = await FastingRecordService.getTodaysFastings(currentUserId!);
      
      setState(() {
        pendingConfirmations = pending;
        todaysFastings = today;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Error al cargar los datos: $e');
    }
  }

  Future<void> _confirmParticipation(UserFastingRecord record) async {
    try {
      final confirmed = await FastingRecordService.confirmFastingParticipation(
        userId: record.userId,
        fastingId: record.fastingId,
        dia: record.dia,
      );

      if (confirmed != null) {
        _showSuccessSnackBar('✅ Participación confirmada para ${record.dia}');
        await _loadData();
      } else {
        _showErrorSnackBar('No se pudo confirmar la participación');
      }
    } catch (e) {
      _showErrorSnackBar('Error al confirmar: $e');
    }
  }

  Future<void> _markAsCompleted(UserFastingRecord record) async {
    final notesController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar Ayuno como Completado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Has completado tu ayuno del ${record.dia}?'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                hintText: 'Comparte tu experiencia...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Completar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final completed = await FastingRecordService.markFastingCompleted(
          userId: record.userId,
          fastingId: record.fastingId,
          dia: record.dia,
          notas: notesController.text.isNotEmpty ? notesController.text : null,
        );

        if (completed != null) {
          _showSuccessSnackBar('🎉 ¡Ayuno completado! Felicitaciones');
          await _loadData();
        } else {
          _showErrorSnackBar('No se pudo marcar como completado');
        }
      } catch (e) {
        _showErrorSnackBar('Error al completar: $e');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ayunos'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPendingConfirmationsSection(),
                  const SizedBox(height: 24),
                  _buildTodaysFastingsSection(),
                  const SizedBox(height: 24),
                  _buildHelpSection(),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildPendingConfirmationsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Confirmaciones Pendientes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (pendingConfirmations.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.check_circle_outline, 
                           size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'No tienes confirmaciones pendientes',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...pendingConfirmations.map((record) => 
                _buildConfirmationCard(record)),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysFastingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Ayunos de Hoy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (todaysFastings.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.free_breakfast_outlined, 
                           size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'No tienes ayunos programados para hoy',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...todaysFastings.map((record) => 
                _buildTodayFastingCard(record)),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationCard(UserFastingRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Text(
            record.dia.substring(0, 1).toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
        ),
        title: Text(
          'Ayuno del ${record.dia}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Mañana • ${_formatDate(record.fechaAyuno)}'),
            const SizedBox(height: 8),
            const Text(
              '¿Confirmas que vas a ayunar mañana?',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _confirmParticipation(record),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Confirmar'),
        ),
      ),
    );
  }

  Widget _buildTodayFastingCard(UserFastingRecord record) {
    final isCompleted = record.completoAyuno;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isCompleted ? Colors.green.shade200 : Colors.blue.shade200,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isCompleted 
            ? Colors.green.shade100 
            : Colors.blue.shade100,
          child: Icon(
            isCompleted ? Icons.check : Icons.schedule,
            color: isCompleted 
              ? Colors.green.shade700 
              : Colors.blue.shade700,
          ),
        ),
        title: Text(
          'Ayuno del ${record.dia}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Hoy • ${_formatDate(record.fechaAyuno)}'),
            if (isCompleted) ...[
              const SizedBox(height: 8),
              const Text(
                '✅ ¡Completado!',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (record.notasUsuario != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Notas: ${record.notasUsuario}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ],
        ),
        trailing: isCompleted 
          ? const Icon(Icons.check_circle, color: Colors.green)
          : ElevatedButton(
              onPressed: () => _markAsCompleted(record),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Completar'),
            ),
      ),
    );
  }

  Widget _buildHelpSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.help_outline, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Ayuda',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• Recibirás notificaciones a las 8pm del día anterior para confirmar tu ayuno\n'
              '• Confirma tu participación antes del día del ayuno\n'
              '• Marca como completado después de terminar tu ayuno\n'
              '• Puedes agregar notas sobre tu experiencia',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    
    return '${date.day} ${months[date.month - 1]}';
  }
} 