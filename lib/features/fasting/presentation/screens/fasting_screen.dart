import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/mock_data_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../shared/models/fasting_model.dart';
import '../../../../shared/models/user_model.dart';
import '../widgets/widgets.dart';

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  final MockDataService _dataService = MockDataService();
  final _authService = ServiceLocator().authService;
  List<FastingModel> _fastings = [];
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFastings();
  }

  Future<void> _loadFastings() async {
    setState(() => _isLoading = true);
    
    try {
      final fastings = await _dataService.getFastings();
      final currentUser = _authService.currentUser;
      
      setState(() {
        _fastings = fastings;
        _currentUser = currentUser;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar ayunos: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayunos'),
        automaticallyImplyLeading: false,
        actions: [
          if (_currentUser?.rol == UserRole.administradorIglesia ||
              _currentUser?.rol == UserRole.administradorGlobal)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.go('/create-fasting'),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadFastings,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildFastingsList(),
      ),
    );
  }

  Widget _buildFastingsList() {
    if (_fastings.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No hay ayunos disponibles',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Los administradores pueden crear nuevos ayunos',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
      itemCount: _fastings.length + 1, // +1 para la tarjeta motivacional
      itemBuilder: (context, index) {
        if (index == 0) {
          return const MotivationCardWidget();
        }
        
        final fasting = _fastings[index - 1];
        return _buildFastingCard(fasting);
      },
    );
  }

  Widget _buildFastingCard(FastingModel fasting) {
    final totalParticipantes = fasting.participantesPorDia.values
        .expand((participants) => participants)
        .toSet()
        .length;

    final userParticipatingDays = <String>[];
    if (_currentUser != null) {
      for (final entry in fasting.participantesPorDia.entries) {
        if (entry.value.contains(_currentUser!.id)) {
          userParticipatingDays.add(entry.key);
        }
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => context.go('/fasting/${fasting.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fasting.titulo,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fasting.descripcion,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: fasting.status == FastingStatus.abierto
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      fasting.status.displayName,
                      style: TextStyle(
                        color: fasting.status == FastingStatus.abierto
                            ? Colors.green[700]
                            : Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (fasting.fechaInicio != null && fasting.fechaFin != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Del ${_formatDate(fasting.fechaInicio!)} al ${_formatDate(fasting.fechaFin!)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$totalParticipantes participantes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (userParticipatingDays.isNotEmpty) ...[
                    const Spacer(),
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
                        'Participando ${userParticipatingDays.length} día${userParticipatingDays.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Toca para ver detalles y participar',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
} 