import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/widgets/main_scaffold.dart';

// Importar screens cuando estén creadas
// import '../features/auth/presentation/screens/splash_screen.dart';
// import '../features/auth/presentation/screens/login_screen.dart';
// import '../features/auth/presentation/screens/register_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String registerChurch = '/register-church';
  static const String home = '/home';
  static const String events = '/events';
  static const String eventDetail = '/event/:id';
  static const String createEvent = '/create-event';
  static const String editEvent = '/edit-event/:id';
  static const String churches = '/churches';
  static const String churchDetail = '/church/:id';
  static const String fasting = '/fasting';
  static const String fastingDetail = '/fasting/:id';
  static const String createFasting = '/create-fasting';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String admin = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminChurches = '/admin/churches';
  static const String adminEvents = '/admin/events';
  static const String adminRequests = '/admin/requests';
  static const String adminAnalytics = '/admin/analytics';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Splash & Auth Routes (sin navbar)
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: registerChurch,
        builder: (context, state) => const RegisterChurchScreen(),
      ),
      
      // Main App with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainScaffold(
          currentPath: state.fullPath ?? '',
          child: child,
        ),
        routes: [
          // Main App Routes
          GoRoute(
            path: home,
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Events Routes
          GoRoute(
            path: events,
            builder: (context, state) => const EventsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => EventDetailScreen(
                  eventId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: createEvent,
            builder: (context, state) => const CreateEventScreen(),
          ),
          GoRoute(
            path: editEvent,
            builder: (context, state) => EditEventScreen(
              eventId: state.pathParameters['id']!,
            ),
          ),
          
          // Churches Routes
          GoRoute(
            path: churches,
            builder: (context, state) => const ChurchesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ChurchDetailScreen(
                  churchId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          
          // Fasting Routes
          GoRoute(
            path: fasting,
            builder: (context, state) => const FastingScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => FastingDetailScreen(
                  fastingId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: createFasting,
            builder: (context, state) => const CreateFastingScreen(),
          ),
          
          // Profile & Settings Routes
          GoRoute(
            path: profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
      ),
      
      // Admin Routes (sin navbar)
      GoRoute(
        path: admin,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: adminUsers,
        builder: (context, state) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: adminChurches,
        builder: (context, state) => const AdminChurchesScreen(),
      ),
      GoRoute(
        path: adminEvents,
        builder: (context, state) => const AdminEventsScreen(),
      ),
      GoRoute(
        path: adminRequests,
        builder: (context, state) => const AdminRequestsScreen(),
      ),
      GoRoute(
        path: adminAnalytics,
        builder: (context, state) => const AdminAnalyticsScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}

// Placeholder screens - estas serán reemplazadas por las pantallas reales
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Simular tiempo de carga (2 segundos)
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // Por ahora navegar directamente al login
      // En el futuro aquí verificarías si el usuario ya está autenticado
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.church,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'Eventos Cruz de Cristal',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.church,
              size: 64,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simular login exitoso - navegar al home
                  context.go('/home');
                },
                child: const Text('Iniciar Sesión'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('¿No tienes cuenta? '),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text('Regístrate'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/register-church'),
              child: const Text('Registrar mi Iglesia'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: const Center(child: Text('Pantalla de Registro')),
    );
  }
}

class RegisterChurchScreen extends StatelessWidget {
  const RegisterChurchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Iglesia')),
      body: const Center(child: Text('Pantalla de Registro de Iglesia')),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos Cruz de Cristal'),
        automaticallyImplyLeading: false, // No mostrar flecha hacia atrás
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.go('/notifications'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    'Eventos',
                    Icons.event,
                    Colors.blue,
                    () => context.go('/events'),
                  ),
                  _buildMenuCard(
                    context,
                    'Iglesias',
                    Icons.church,
                    Colors.purple,
                    () => context.go('/churches'),
                  ),
                  _buildMenuCard(
                    context,
                    'Ayunos',
                    Icons.favorite,
                    Colors.red,
                    () => context.go('/fasting'),
                  ),
                  _buildMenuCard(
                    context,
                    'Configuración',
                    Icons.settings,
                    Colors.grey,
                    () => context.go('/settings'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eventos'),
        automaticallyImplyLeading: false, // No mostrar flecha hacia atrás
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/create-event'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lista de eventos mock
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.event, size: 40),
                      title: Text('Evento ${index + 1}'),
                      subtitle: Text('Descripción del evento ${index + 1}'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => context.go('/events/${index + 1}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Evento'),
        // automaticallyImplyLeading por defecto es true - mostrará flecha hacia atrás
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evento $eventId',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descripción completa del evento...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Acción de like
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Te gusta este evento!')),
                      );
                    },
                    icon: const Icon(Icons.favorite),
                    label: const Text('Me Gusta'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Acción de compartir
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Evento compartido')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Compartir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Evento')),
      body: const Center(child: Text('Crear Evento')),
    );
  }
}

class EditEventScreen extends StatelessWidget {
  final String eventId;
  const EditEventScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Evento')),
      body: Center(child: Text('Editar Evento: $eventId')),
    );
  }
}

class ChurchesScreen extends StatelessWidget {
  const ChurchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iglesias'),
        automaticallyImplyLeading: false, // No mostrar flecha hacia atrás
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Iglesias Disponibles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.church, size: 40),
                      title: Text('Iglesia ${index + 1}'),
                      subtitle: Text('Ciudad ${index + 1} - 50 asistentes'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => context.go('/churches/${index + 1}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChurchDetailScreen extends StatelessWidget {
  final String churchId;
  const ChurchDetailScreen({super.key, required this.churchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Iglesia')),
      body: Center(child: Text('Detalle de Iglesia: $churchId')),
    );
  }
}

class FastingScreen extends StatelessWidget {
  const FastingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayunos'),
        automaticallyImplyLeading: false, // No mostrar flecha hacia atrás
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/create-fasting'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Ayunos Activos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.favorite, size: 40, color: Colors.red),
                      title: Text('Ayuno ${index + 1}'),
                      subtitle: Text('Por la paz mundial - ${index + 5} participantes'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => context.go('/fasting/${index + 1}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FastingDetailScreen extends StatelessWidget {
  final String fastingId;
  const FastingDetailScreen({super.key, required this.fastingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Ayuno')),
      body: Center(child: Text('Detalle del Ayuno: $fastingId')),
    );
  }
}

class CreateFastingScreen extends StatelessWidget {
  const CreateFastingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Ayuno')),
      body: const Center(child: Text('Crear Ayuno')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        automaticallyImplyLeading: false, // No mostrar flecha hacia atrás
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              'Juan Pérez',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'miembro@test.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.church),
              title: const Text('Mis Iglesias'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/churches'),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Mis Eventos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/events'),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Mis Ayunos'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.go('/fasting'),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: const Center(child: Text('Pantalla de Configuración')),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: const Center(child: Text('Pantalla de Notificaciones')),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administración')),
      body: const Center(child: Text('Panel de Administración')),
    );
  }
}

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Usuarios')),
      body: const Center(child: Text('Administrar Usuarios')),
    );
  }
}

class AdminChurchesScreen extends StatelessWidget {
  const AdminChurchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Iglesias')),
      body: const Center(child: Text('Administrar Iglesias')),
    );
  }
}

class AdminEventsScreen extends StatelessWidget {
  const AdminEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Eventos')),
      body: const Center(child: Text('Administrar Eventos')),
    );
  }
}

class AdminRequestsScreen extends StatelessWidget {
  const AdminRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes de Iglesias')),
      body: const Center(child: Text('Solicitudes de Iglesias')),
    );
  }
}

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analíticas')),
      body: const Center(child: Text('Analíticas')),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página no encontrada')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64),
            SizedBox(height: 16),
            Text('Página no encontrada'),
          ],
        ),
      ),
    );
  }
} 