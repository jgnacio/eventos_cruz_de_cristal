import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/mock_auth_service.dart';
import '../../../../shared/models/user_model.dart';

class UserSelectorScreen extends StatefulWidget {
  const UserSelectorScreen({super.key});

  @override
  State<UserSelectorScreen> createState() => _UserSelectorScreenState();
}

class _UserSelectorScreenState extends State<UserSelectorScreen> {
  final _authService = ServiceLocator().authService;
  UserModel? _selectedUser;
  bool _isLoading = false;
  List<UserModel> _testUsers = [];

  @override
  void initState() {
    super.initState();
    _loadTestUsers();
    _selectedUser = _authService.currentUser;
  }

  void _loadTestUsers() {
    if (_authService is MockAuthService) {
      _testUsers = (_authService as MockAuthService).allTestUsers;
    }
  }

  Future<void> _selectUser(UserModel user) async {
    setState(() => _isLoading = true);
    
    try {
      await _authService.loginAsUser(user);
      
      setState(() {
        _selectedUser = user;
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sesión iniciada como: ${user.nombre}'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navegar al home después de seleccionar usuario
        context.go('/home');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar usuario: $e'),
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
        title: const Text('Selector de Usuario (Testing)'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildUserList(),
          ),
          _buildCurrentUserInfo(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.amber.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(
            Icons.bug_report,
            size: 32,
            color: Colors.amber,
          ),
          const SizedBox(height: 8),
          const Text(
            'MODO TESTING',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona un usuario para probar diferentes roles',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    if (_testUsers.isEmpty) {
      return const Center(
        child: Text('No hay usuarios de prueba disponibles'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _testUsers.length,
      itemBuilder: (context, index) {
        final user = _testUsers[index];
        final isSelected = _selectedUser?.id == user.id;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isSelected ? 4 : 1,
          child: InkWell(
            onTap: _isLoading ? null : () => _selectUser(user),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isSelected 
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
                color: isSelected 
                    ? Colors.blue.withValues(alpha: 0.05)
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.rol).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      _getRoleIcon(user.rol),
                      color: _getRoleColor(user.rol),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.nombre,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user.rol).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getRoleDisplayName(user.rol),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getRoleColor(user.rol),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    )
                  else
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrentUserInfo() {
    if (_selectedUser == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red.withValues(alpha: 0.1),
        child: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No hay usuario seleccionado',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            _getRoleIcon(_selectedUser!.rol),
            color: _getRoleColor(_selectedUser!.rol),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Usuario Actual:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${_selectedUser!.nombre} (${_getRoleDisplayName(_selectedUser!.rol)})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.administradorGlobal:
        return Colors.purple;
      case UserRole.administradorIglesia:
        return Colors.blue;
      case UserRole.miembro:
        return Colors.green;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.administradorGlobal:
        return Icons.admin_panel_settings;
      case UserRole.administradorIglesia:
        return Icons.church;
      case UserRole.miembro:
        return Icons.person;
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.administradorGlobal:
        return 'Administrador Global';
      case UserRole.administradorIglesia:
        return 'Pastor/Admin Iglesia';
      case UserRole.miembro:
        return 'Miembro';
    }
  }
} 