import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getCurrentIndex(),
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onTabTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Eventos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.church),
          label: 'Iglesias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Ayunos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

  int _getCurrentIndex() {
    if (currentPath.startsWith('/home')) return 0;
    if (currentPath.startsWith('/events')) return 1;
    if (currentPath.startsWith('/churches')) return 2;
    if (currentPath.startsWith('/fasting')) return 3;
    if (currentPath.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/events');
        break;
      case 2:
        context.go('/churches');
        break;
      case 3:
        context.go('/fasting');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
} 